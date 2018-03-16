module Token
    ( Token(..)
    ) where

data Token
    = TokenLambda
    | TokenPeriod
    | TokenLParen
    | TokenRParen
    | TokenBinOp String
    | TokenTrue
    | TokenFalse
    | TokenSpace
    | TokenVar String
    | TokenInt Int
    deriving Show
