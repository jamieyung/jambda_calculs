module Main (main) where


import Data.Map (Map)
import Data.Map as Map
import Expr (Expr(..), Args(..))
import Lexer (lexer)
import Parser (parser)
import System.Environment
import System.IO


compile_expr :: Expr -> String
compile_expr (Var name) =
    name
compile_expr (App a b) =
    compile_expr a ++ "(" ++ compile_expr b ++ ")"
compile_expr (Lam (ArgsOne name) a) =
    "function(" ++ name ++ "){return " ++ compile_expr a ++ "}"
compile_expr (Lam (ArgsCons name next) a) =
    "function(" ++ name ++ "){return " ++ compile_expr (Lam next a) ++ "}"
compile_expr (Int a) =
    show a
compile_expr (Bool True) =
    "true"
compile_expr (Bool False) =
    "false"
compile_expr (Brack a) =
    "(" ++ compile_expr a ++ ")"
compile_expr (Op op a) =
    "(function(){return " ++ compile_expr a ++ " " ++ op ++ " arguments[0]})"


compile_args :: Args -> String
compile_args (ArgsOne name) =
    name
compile_args (ArgsCons name rest) =
    name ++ "," ++ compile_args rest


compile :: String -> String
compile s =
    let
        ast =
            parser $ lexer s
    in
        "// AST: " ++ show ast ++ "\n"
        ++ "_ = " ++ compile_expr ast ++ "\nconsole.log(_)"

main = do
    args <- getArgs
    s <- readFile $ args !! 1
    writeFile (head args) (compile s)
