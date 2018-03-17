{
module Parser where

import Ast (Expr(..), Args(..), DefList(..), Def(..))
import Lexer (lexer)
import Token (Token(..))
}

%name parser
%tokentype { Token }
%error { parseError }

--------------------------------------------------------------------------------

%token 
    'λ'         { TokenLambda }
    '.'         { TokenPeriod }
    ':='        { TokenDef }
    '('         { TokenLParen }
    ')'         { TokenRParen }
    let         { TokenLet }
    in          { TokenIn }
    if          { TokenIf }
    then        { TokenThen }
    else        { TokenElse }
    binop       { TokenBinOp $$ }
    sp          { TokenSpace }
    var         { TokenVar $$ }
    int         { TokenInt $$ }
    str         { TokenStr $$ }
    T           { TokenTrue }
    F           { TokenFalse }

--------------------------------------------------------------------------------

%right sp
%left ','
%left ':='
%left binop
%left APP

%% -----------------------------------------------------------------------------

Expr        : Expr sp Expr %prec APP                    { App $1 $3 }
            
            | 'λ' Args '.' Expr                         { Lam $2 $4 }
            
            | let sp DefList sp in sp Expr              { LetRec $3 $7 }
            
            | let sp DefList in sp Expr                 { LetRec $3 $6 }
            
            | if sp Expr sp then sp Expr sp else sp Expr
                                                        { IfElse $3 $7 $11 }
            
            | binop Expr                                { BinOp $1 $2 }
            
            | binop                                     { BinOpSolo $1 }
            
            | var                                       { Var $1 }
            
            | int                                       { Int $1 }
            
            | str                                       { String $1 }
            
            | '(' Expr ')'                              { Brack $2 }

            | '(' Expr sp ')'                           { Brack $2 }

            | '(' sp Expr ')'                           { Brack $3 }

            | '(' sp Expr sp ')'                        { Brack $3 }
            
            | T                                         { Bool True }
            
            | F                                         { Bool False }

--------------------------------------------------------------------------------

DefList     : Def                               { DefListOne $1 }
            | Def sp DefList                    { DefListCons $1 $3 }

--------------------------------------------------------------------------------

Def         : var ':=' Expr                     { Def $1 $3 }

--------------------------------------------------------------------------------

Args        : var                               { ArgsOne $1 }
            | var sp Args                       { ArgsCons $1 $3 }

{
parseError :: [Token] -> a
parseError toks = error $ "Parse error: " ++ show toks
}
