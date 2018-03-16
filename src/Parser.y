{
module Parser where

import Ast (Expr(..), Args(..), Xs(..), X(..))
import Lexer (lexer)
import Token (Token(..))
}

%name parser
%tokentype { Token }
%error { parseError }

%token 
    'λ'             { TokenLambda }
    '.'             { TokenPeriod }
    ','             { TokenComma }
    '='             { TokenEq }
    '('             { TokenLParen }
    ')'             { TokenRParen }
    let             { TokenLet }
    in              { TokenIn }
    T               { TokenTrue }
    F               { TokenFalse }
    binop           { TokenBinOp $$ }
    ' '             { TokenSpace }
    var             { TokenVar $$ }
    int             { TokenInt $$ }

%right ' '
%left ','
%left '='
%left binop

%%

Expr        : var                           { Var $1 }
            | int                           { E_Int $1 }
            | T                             { Bool True }
            | F                             { Bool False }
            | binop                         { BinOpSolo $1 }
            | binop Expr                    { BinOp $1 $2 }
            | '(' Expr ')'                  { Brack $2 }
            | Expr ' ' Expr                 { App $1 $3 }
            | 'λ' Args '.' Expr             { Lam $2 $4 }
            | let ' ' Xs ' ' in ' ' Expr    { LetRec $3 $7 }

Xs          : X                             { XsOne $1 }
            | X ',' Xs                      { XsCons $1 $3 }

X           : var '=' Expr                  { X $1 $3 }

Args        : var                           { ArgsOne $1 }
            | var ' ' Args                  { ArgsCons $1 $3 }

{
parseError :: [Token] -> a
parseError toks = error $ "Parse error: " ++ show toks
}
