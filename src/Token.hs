module Token
    ( Token(..)
    ) where

data Token
    = TokenLambda
    | TokenPeriod
    | TokenDef
    | TokenLet
    | TokenIn
    | TokenIf
    | TokenThen
    | TokenElse
    | TokenLParen
    | TokenRParen
    | TokenBinOp String
    | TokenTrue
    | TokenFalse
    | TokenSpace
    | TokenVar String
    | TokenInt Int
    | TokenStr String
    deriving Show
