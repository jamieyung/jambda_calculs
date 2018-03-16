module Expr
    ( Expr(..)
    , Args(..)
    ) where


type Name = String


data Expr  
    = Var Name
    | App Expr Expr
    | Lam Args Expr
    | Int Int
    | Bool Bool
    | Brack Expr
    deriving (Eq, Show)

data Args
    = ArgsOne Name
    | ArgsCons Name Args
    deriving (Eq, Show)
