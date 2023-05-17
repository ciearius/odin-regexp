package tests

import "core:testing"
import "core:slice"
import "core:fmt"

import "../src/describe"
import "../src/ast"
import "../src/parser"
import "../src/tokenizer"
import "../src/bytecode"
import "../src/compiler"

// When everything in these patterns is supported, we can compare the results to https://github.com/mariomka/regex-benchmark
PATTERN_Email :: `[\w\.+-]+@[\w\.-]+\.[\w\.-]+`
PATTERN_URI :: `[\w]+://[^/\s?#]+[^\s?#]+(?:\?[^\s#]*)?(?:#[^\s]*)?`
PATTERN_IPv4 :: `(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9])`
