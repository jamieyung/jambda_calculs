{
module Lexer (lexer) where

import Token (Token(..))
}

%wrapper "basic"

@int            = [1-9][0-9]*
@var            = [A-Za-z][A-Za-z0-9'_]*

rules :-

  \n            ;
  \\            { const TokenLambda }
  \.            { const TokenPeriod }
  \(            { const TokenLParen }
  \)            { const TokenRParen }
  "True"        { const TokenTrue }
  "False"       { const TokenFalse }
  " "+          { const TokenSpace }
  @var          { TokenVar }
  @int          { TokenInt . read }

{
lexer = alexScanTokens
}
