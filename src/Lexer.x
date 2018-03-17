{
module Lexer (lexer) where

import Token (Token(..))
}

%wrapper "basic"

@int            = "0" | [1-9][0-9]*
@var            = [A-Za-z][A-Za-z0-9'_]*
@string         = \" [^ \"]* \"

rules :-

  \n            ;
  \\            { const TokenLambda }
  \.            { const TokenPeriod }
  " := "        { const TokenDef }
  \(            { const TokenLParen }
  \)            { const TokenRParen }
  "=="          { const TokenBinOp "===" }
  \+            { TokenBinOp }
  \-            { TokenBinOp }
  \*            { TokenBinOp }
  \/            { TokenBinOp }
  "let"         { const TokenLet }
  "in"          { const TokenIn }
  "if"          { const TokenIf }
  "then"        { const TokenThen }
  "else"        { const TokenElse }
  "True"        { const TokenTrue }
  "False"       { const TokenFalse }
  " "+          { const TokenSpace }
  @var          { TokenVar }
  @int          { TokenInt . read }
  @string       { TokenStr }

{
lexer = alexScanTokens
}
