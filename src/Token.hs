module Token
    ( Token(..)
    ) where

data Token
    = TokenLambda
    | TokenPeriod
    | TokenLParen
    | TokenRParen
    | TokenOp String
    | TokenTrue
    | TokenFalse
    | TokenSpace
    | TokenVar String
    | TokenInt Int
    deriving Show
