module Ast
    ( Expr(..)
    , Args(..)
    , DefList(..)
    , Def(..)
    ) where


type Name = String


data Expr
    = App Expr Expr
    | Lam Args Expr
    | LetRec DefList Expr
    | IfElse Expr Expr Expr
    | BinOp String Expr
    | BinOpSolo String
    | Var Name
    | Int Int
    | String String
    | Bool Bool
    | Brack Expr
    deriving (Eq, Show)


data Args
    = ArgsOne Name
    | ArgsCons Name Args
    deriving (Eq, Show)


data DefList
    = DefListOne Def
    | DefListCons Def DefList
    deriving (Eq, Show)


data Def
    = Def Name Expr
    deriving (Eq, Show)
