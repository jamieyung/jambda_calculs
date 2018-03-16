module Token
    ( Token(..)
    ) where

data Token
    = TokenVar String
    | TokenInt Int
    | TokenLambda
    | TokenPeriod
    | TokenLParen
    | TokenRParen
    | TokenTrue
    | TokenFalse
    | TokenSpace
    deriving Show
