module Main (main, compile) where


import Ast (Expr(..), Args(..), DefList(..), Def(..))
import Anonymize_Vars (anonymous_var, anonymize_vars)
import Lexer (lexer)
import Parser (parser)
import System.Environment
import System.IO
import Text.Printf


compile_expr :: Int -> Expr -> (Int, String)
compile_expr i (App a b) =
    let
        (i1, a') =
            compile_expr i a
        (i2, b') =
            compile_expr i1 b
        format_str =
            "%s(%s)"
    in
        (i2, printf format_str a' b')
compile_expr i (Lam (ArgsOne name) a) =
    let
        (i1, a') =
            compile_expr i a
        format_str =
            "(%s)=>%s"
    in
        (i1, printf format_str name a')
compile_expr i (Lam (ArgsCons name next) a) =
    let
        (i1, a') =
            compile_expr i (Lam next a)
        format_str =
            "(%s)=>%s"
    in
        (i1, printf format_str name a')
compile_expr i (LetRec xs a) =
    let
        (i1, xs') =
            compile_deflist i xs
        (i2, a') =
            compile_expr i1 a
        format_str =
            "(%s%s)"
    in
        (i2, printf format_str xs' a')
compile_expr i (IfElse p a b) =
    let
        (i1, p') =
            compile_expr i p
        (i2, a') =
            compile_expr i1 a
        (i3, b') =
            compile_expr i2 b
        format_str =
            "(%s?%s:%s)"
    in
        (i3, printf format_str p' a' b')
compile_expr i (BinOp op a) =
    let
        (i1, x) =
            anonymous_var i
        (i2, a') =
            compile_expr i1 a
        format_str =
            "((%s)=>%s %s %s)"
    in
        (i2, printf format_str x a' op x)
compile_expr i (BinOpSolo op) =
    let
        (i1, x) =
            anonymous_var i
        (i2, y) =
            anonymous_var i1
        format_str =
            "((%s)=>(%s)=>%s %s %s)"
    in
        (i2, printf format_str x y x op y)
compile_expr i (Var name) =
    (i, name)
compile_expr i (Int x) =
    (i, show x)
compile_expr i (String x) =
    (i, x)
compile_expr i (Brack a) =
    let
        (i1, a') =
            compile_expr i a
    in
        (i1, "(" ++ a' ++ ")")
compile_expr i (Bool True) =
    (i, "true")
compile_expr i (Bool False) =
    (i, "false")


compile_deflist :: Int -> DefList -> (Int, String)
compile_deflist i (DefListOne x) =
    compile_def i x
compile_deflist i (DefListCons x xs) =
    let
        (i1, x') =
            compile_def i x
        (i2, xs') =
            compile_deflist i1 xs
    in
        (i2, x' ++ xs')


compile_def :: Int -> Def -> (Int, String)
compile_def i (Def name a) =
    let
        (i1, a') =
            compile_expr i a
    in
        (i1, name ++ "=" ++ a' ++ ",")


compile :: String -> String
compile s =
    let
        ((_, i), ast) =
            anonymize_vars $ parser $ lexer s

        (_, compiled) =
            compile_expr i ast
    in
        "// AST: " ++ show ast ++ "\n"
        ++ "_=" ++ compiled ++ "\nconsole.log(_)"


main = do
    args <- getArgs
    s <- readFile $ head args
    writeFile (args !! 1) (compile s)
