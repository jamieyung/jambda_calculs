module Ast
    ( Expr(..)
    , Args(..)
    , Xs(..)
    , X(..)
    ) where


type Name = String


data Expr  
    = Var Name
    | App Expr Expr
    | Lam Args Expr
    | LetRec Xs Expr
    | E_Int Int
    | Bool Bool
    | Brack Expr
    | BinOp String Expr
    | BinOpSolo String
    deriving (Eq, Show)


data Args
    = ArgsOne Name
    | ArgsCons Name Args
    deriving (Eq, Show)


data Xs
    = XsOne X
    | XsCons X Xs
    deriving (Eq, Show)


data X
    = X Name Expr
    deriving (Eq, Show)
