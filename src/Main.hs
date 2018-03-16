module Main (main) where


import Data.Map (Map)
import Data.Map as Map
import Expr (Expr(..), Args(..))
import Lexer (lexer)
import Parser (parser)
import System.Environment
import System.IO


compile_expr :: Int -> Expr -> String
compile_expr _ (Var name) =
    name
compile_expr i (App a b) =
    compile_expr i a ++ "(" ++ compile_expr i b ++ ")"
compile_expr i (Lam (ArgsOne name) a) =
    "function(" ++ name ++ "){return " ++ compile_expr i a ++ "}"
compile_expr i (Lam (ArgsCons name next) a) =
    "function(" ++ name ++ "){return " ++ compile_expr i (Lam next a) ++ "}"
compile_expr _ (Int a) =
    show a
compile_expr _ (Bool True) =
    "true"
compile_expr _ (Bool False) =
    "false"
compile_expr i (Brack a) =
    "(" ++ compile_expr i a ++ ")"
compile_expr i (BinOp op a) =
    let
        x =
            anonymous_var i
    in
        "(function(" ++ x ++ "){return "
        ++ compile_expr (i + 1) a ++ " " ++ op ++ " " ++ x ++ "})"
compile_expr i (BinOpSolo op) =
    let
        x =
            anonymous_var i

        y =
            anonymous_var (i + 1)
    in
        "(function(" ++ x ++ "){"
        ++ " return function(" ++ y ++ ") {return " ++ x ++ " " ++ op ++" " ++
        y ++ "} })"


anonymous_var :: Int -> String
anonymous_var i =
    "_" ++ show i


type AnonymousVarMap = (Map String String, Int)


anonymise_args_vars :: AnonymousVarMap -> Args -> (AnonymousVarMap, Args)
anonymise_args_vars (m, i) (ArgsOne name) =
    case Map.lookup name m of
        Nothing ->
            let
                v =
                    anonymous_var i
                m' =
                    Map.insert name v m
            in
                ((m', i + 1), ArgsOne v)
        Just v ->
            ((m, i), ArgsOne v)
anonymise_args_vars (m, i) (ArgsCons name next) =
    case Map.lookup name m of
        Nothing ->
            let
                v =
                    anonymous_var i
                m' =
                    Map.insert name v m
                (s1, next') =
                    anonymise_args_vars (m', i + 1) next
            in
                (s1, ArgsCons v next')
        Just v ->
            let
                (s1, next') =
                    anonymise_args_vars (m, i) next
            in
                (s1, ArgsCons v next')


anonymise_vars :: AnonymousVarMap -> Expr -> (AnonymousVarMap, Expr)
anonymise_vars (m, i) (Var name) =
    case Map.lookup name m of
        Nothing ->
            let
                v =
                    anonymous_var i
                m' =
                    Map.insert name v m
            in
                ((m', i + 1), Var v)
        Just v ->
            ((m, i), (Var v))
anonymise_vars s      (Lam args a) =
    let
        (s1, args') =
            anonymise_args_vars s args

        (s2, a') =
            anonymise_vars s1 a
    in
        (s2, Lam args' a')
anonymise_vars s      (App a b) =
    let
        (s1, a') =
            anonymise_vars s a
        (s2, b') =
            anonymise_vars s1 b
    in
        (s2, App a' b')
anonymise_vars s      (Brack a) =
    let
        (s1, a') =
            anonymise_vars s a
    in
        (s1, Brack a')
anonymise_vars s x =
    (s, x)


compile :: String -> String
compile s =
    let
        ((_, i), ast) =
            anonymise_vars (Map.empty, 0) $ parser $ lexer s
    in
        "// AST: " ++ show ast ++ "\n"
        ++ "_ = " ++ compile_expr i ast ++ "\nconsole.log(_)"

main = do
    args <- getArgs
    s <- readFile $ args !! 1
    writeFile (head args) (compile s)
