{
module Lexer (lexer) where

import Token (Token(..))
}

%wrapper "basic"

@int            = [1-9][0-9]*
@var            = [A-Za-z][A-Za-z0-9'_]*

rules :-

  @var          { TokenVar }
  @int          { TokenInt . read }
  \\            { const TokenLambda }
  \.            { const TokenPeriod }
  \(            { const TokenLParen }
  \)            { const TokenRParen }
  "True"        { const TokenTrue }
  "False"       { const TokenFalse }
  " "+          { const TokenSpace }
  \n            ;

{
lexer = alexScanTokens
}
