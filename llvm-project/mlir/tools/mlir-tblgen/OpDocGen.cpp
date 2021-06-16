//===- OpDocGen.cpp - MLIR operation documentation generator --------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// OpDocGen uses the description of operations to generate documentation for the
// operations.
//
//===----------------------------------------------------------------------===//

#include "DocGenUtilities.h"
#include "mlir/Support/IndentedOstream.h"
#include "mlir/TableGen/GenInfo.h"
#include "mlir/TableGen/Operator.h"
#include "mlir/TableGen/TypeDef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/FormatVariadic.h"
#include "llvm/Support/Signals.h"
#include "llvm/TableGen/Error.h"
#include "llvm/TableGen/Record.h"
#include "llvm/TableGen/TableGenBackend.h"

#include <set>

using namespace llvm;
using namespace mlir;
using namespace mlir::tblgen;

using mlir::tblgen::Operator;

// Emit the description by aligning the text to the left per line (e.g.,
// removing the minimum indentation across the block).
//
// This expects that the description in the tablegen file is already formatted
// in a way the user wanted but has some additional indenting due to being
// nested in the op definition.
void mlir::tblgen::emitDescription(StringRef description, raw_ostream &os) {
  raw_indented_ostream ros(os);
  ros.reindent(description.rtrim(" \t"));
}

// Emits `str` with trailing newline if not empty.
static void emitIfNotEmpty(StringRef str, raw_ostream &os) {
  if (!str.empty()) {
    emitDescription(str, os);
    os << "\n";
  }
}

/// Emit the given named constraint.
template <typename T>
static void emitNamedConstraint(const T &it, raw_ostream &os) {
  if (!it.name.empty())
    os << "`" << it.name << "`";
  else
    os << "&laquo;unnamed&raquo;";
  os << " | " << it.constraint.getSummary() << "\n";
}

//===----------------------------------------------------------------------===//
// Operation Documentation
//===----------------------------------------------------------------------===//

/// Emit the assembly format of an operation.
static void emitAssemblyFormat(StringRef opName, StringRef format,
                               raw_ostream &os) {
  os << "\nSyntax:\n\n```\noperation ::= `" << opName << "` ";

  // Print the assembly format aligned.
  unsigned indent = strlen("operation ::= ");
  std::pair<StringRef, StringRef> split = format.split('\n');
  os << split.first.trim() << "\n";
  do {
    split = split.second.split('\n');
    StringRef formatChunk = split.first.trim();
    if (!formatChunk.empty())
      os.indent(indent) << formatChunk << "\n";
  } while (!split.second.empty());
  os << "```\n\n";
}

static void emitOpDoc(Operator op, raw_ostream &os) {
  os << llvm::formatv("### `{0}` ({1})\n", op.getOperationName(),
                      op.getQualCppClassName());

  // Emit the summary, syntax, and description if present.
  if (op.hasSummary())
    os << "\n" << op.getSummary() << "\n\n";
  if (op.hasAssemblyFormat())
    emitAssemblyFormat(op.getOperationName(), op.getAssemblyFormat().trim(),
                       os);
  if (op.hasDescription())
    mlir::tblgen::emitDescription(op.getDescription(), os);

  // Emit attributes.
  if (op.getNumAttributes() != 0) {
    // TODO: Attributes are only documented by TableGen name, with no further
    // info. This should be improved.
    os << "\n#### Attributes:\n\n";
    os << "| Attribute | MLIR Type | Description |\n"
       << "| :-------: | :-------: | ----------- |\n";
    for (const auto &it : op.getAttributes()) {
      StringRef storageType = it.attr.getStorageType();
      os << "`" << it.name << "` | " << storageType << " | "
         << it.attr.getSummary() << "\n";
    }
  }

  // Emit each of the operands.
  if (op.getNumOperands() != 0) {
    os << "\n#### Operands:\n\n";
    os << "| Operand | Description |\n"
       << "| :-----: | ----------- |\n";
    for (const auto &it : op.getOperands())
      emitNamedConstraint(it, os);
  }

  // Emit results.
  if (op.getNumResults() != 0) {
    os << "\n#### Results:\n\n";
    os << "| Result | Description |\n"
       << "| :----: | ----------- |\n";
    for (const auto &it : op.getResults())
      emitNamedConstraint(it, os);
  }

  // Emit successors.
  if (op.getNumSuccessors() != 0) {
    os << "\n#### Successors:\n\n";
    os << "| Successor | Description |\n"
       << "| :-------: | ----------- |\n";
    for (const auto &it : op.getSuccessors())
      emitNamedConstraint(it, os);
  }

  os << "\n";
}

static void emitOpDoc(const RecordKeeper &recordKeeper, raw_ostream &os) {
  auto opDefs = recordKeeper.getAllDerivedDefinitions("Op");

  os << "<!-- Autogenerated by mlir-tblgen; don't manually edit -->\n";
  for (const llvm::Record *opDef : opDefs)
    emitOpDoc(Operator(opDef), os);
}

//===----------------------------------------------------------------------===//
// Type Documentation
//===----------------------------------------------------------------------===//

static void emitTypeDoc(const Type &type, raw_ostream &os) {
  os << "### " << type.getSummary() << "\n";
  emitDescription(type.getDescription(), os);
  os << "\n";
}

//===----------------------------------------------------------------------===//
// TypeDef Documentation
//===----------------------------------------------------------------------===//

/// Emit the assembly format of a type.
static void emitTypeAssemblyFormat(TypeDef td, raw_ostream &os) {
  SmallVector<TypeParameter, 4> parameters;
  td.getParameters(parameters);
  if (parameters.size() == 0) {
    os << "\nSyntax: `!" << td.getDialect().getName() << "." << td.getMnemonic()
       << "`\n";
    return;
  }

  os << "\nSyntax:\n\n```\n!" << td.getDialect().getName() << "."
     << td.getMnemonic() << "<\n";
  for (auto *it = parameters.begin(), *e = parameters.end(); it < e; ++it) {
    os << "  " << it->getSyntax();
    if (it < parameters.end() - 1)
      os << ",";
    os << "   # " << it->getName() << "\n";
  }
  os << ">\n```\n";
}

static void emitTypeDefDoc(TypeDef td, raw_ostream &os) {
  os << llvm::formatv("### `{0}` ({1})\n", td.getName(), td.getCppClassName());

  // Emit the summary, syntax, and description if present.
  if (td.hasSummary())
    os << "\n" << td.getSummary() << "\n";
  if (td.getMnemonic() && td.getPrinterCode() && *td.getPrinterCode() == "" &&
      td.getParserCode() && *td.getParserCode() == "")
    emitTypeAssemblyFormat(td, os);
  if (td.hasDescription())
    mlir::tblgen::emitDescription(td.getDescription(), os);

  // Emit attribute documentation.
  SmallVector<TypeParameter, 4> parameters;
  td.getParameters(parameters);
  if (!parameters.empty()) {
    os << "\n#### Type parameters:\n\n";
    os << "| Parameter | C++ type | Description |\n"
       << "| :-------: | :-------: | ----------- |\n";
    for (const auto &it : parameters) {
      auto desc = it.getSummary();
      os << "| " << it.getName() << " | `" << td.getCppClassName() << "` | "
         << (desc ? *desc : "") << " |\n";
    }
  }

  os << "\n";
}

//===----------------------------------------------------------------------===//
// Dialect Documentation
//===----------------------------------------------------------------------===//

static void emitDialectDoc(const Dialect &dialect, ArrayRef<Operator> ops,
                           ArrayRef<Type> types, ArrayRef<TypeDef> typeDefs,
                           raw_ostream &os) {
  os << "# '" << dialect.getName() << "' Dialect\n\n";
  emitIfNotEmpty(dialect.getSummary(), os);
  emitIfNotEmpty(dialect.getDescription(), os);

  os << "[TOC]\n\n";

  // TODO: Add link between use and def for types
  if (!types.empty()) {
    os << "## Type constraint definition\n\n";
    for (const Type &type : types)
      emitTypeDoc(type, os);
  }

  if (!ops.empty()) {
    os << "## Operation definition\n\n";
    for (const Operator &op : ops)
      emitOpDoc(op, os);
  }

  if (!typeDefs.empty()) {
    os << "## Type definition\n\n";
    for (const TypeDef &td : typeDefs)
      emitTypeDefDoc(td, os);
  }
}

static void emitDialectDoc(const RecordKeeper &recordKeeper, raw_ostream &os) {
  const auto &opDefs = recordKeeper.getAllDerivedDefinitions("Op");
  const auto &typeDefs = recordKeeper.getAllDerivedDefinitions("DialectType");
  const auto &typeDefDefs = recordKeeper.getAllDerivedDefinitions("TypeDef");

  std::set<Dialect> dialectsWithDocs;
  std::map<Dialect, std::vector<Operator>> dialectOps;
  std::map<Dialect, std::vector<Type>> dialectTypes;
  std::map<Dialect, std::vector<TypeDef>> dialectTypeDefs;
  for (auto *opDef : opDefs) {
    Operator op(opDef);
    dialectOps[op.getDialect()].push_back(op);
    dialectsWithDocs.insert(op.getDialect());
  }
  for (auto *typeDef : typeDefs) {
    Type type(typeDef);
    if (auto dialect = type.getDialect())
      dialectTypes[dialect].push_back(type);
  }
  for (auto *typeDef : typeDefDefs) {
    TypeDef type(typeDef);
    dialectTypeDefs[type.getDialect()].push_back(type);
    dialectsWithDocs.insert(type.getDialect());
  }

  os << "<!-- Autogenerated by mlir-tblgen; don't manually edit -->\n";
  for (auto dialect : dialectsWithDocs)
    emitDialectDoc(dialect, dialectOps[dialect], dialectTypes[dialect],
                   dialectTypeDefs[dialect], os);
}

//===----------------------------------------------------------------------===//
// Gen Registration
//===----------------------------------------------------------------------===//

static mlir::GenRegistration
    genOpRegister("gen-op-doc", "Generate dialect documentation",
                  [](const RecordKeeper &records, raw_ostream &os) {
                    emitOpDoc(records, os);
                    return false;
                  });

static mlir::GenRegistration
    genRegister("gen-dialect-doc", "Generate dialect documentation",
                [](const RecordKeeper &records, raw_ostream &os) {
                  emitDialectDoc(records, os);
                  return false;
                });