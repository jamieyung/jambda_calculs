module Anonymize_Vars (anonymous_var, anonymize_vars) where


import Data.Map (Map)
import Data.Map as Map
import Ast (Expr(..), Args(..), DefList(..), Def(..))


anonymous_var :: Int -> (Int, String)
anonymous_var i =
    (i + 1, "_" ++ show i)


type AnonymousVarMap = (Map String String, Int)


anonymize_args_vars :: AnonymousVarMap -> Args -> (AnonymousVarMap, Args)
anonymize_args_vars (m, i) (ArgsOne name) =
    case Map.lookup name m of
        Nothing ->
            let
                (i1, v) =
                    anonymous_var i
                m' =
                    Map.insert name v m
            in
                ((m', i1), ArgsOne v)
        Just v ->
            ((m, i), ArgsOne v)
anonymize_args_vars (m, i) (ArgsCons name next) =
    case Map.lookup name m of
        Nothing ->
            let
                (i1, v) =
                    anonymous_var i
                m' =
                    Map.insert name v m
                (s1, next') =
                    anonymize_args_vars (m', i1) next
            in
                (s1, ArgsCons v next')
        Just v ->
            let
                (s1, next') =
                    anonymize_args_vars (m, i) next
            in
                (s1, ArgsCons v next')


anonymize_x_vars :: AnonymousVarMap -> Def -> (AnonymousVarMap, Def)
anonymize_x_vars (m, i) (Def name a) =
    case Map.lookup name m of
        Nothing ->
            let
                (i1, v) =
                    anonymous_var i
                m' =
                    Map.insert name v m
                (s1, a') =
                    anonymize_vars' (m', i1) a
            in
                (s1, Def v a')
        Just v ->
            let
                (s1, a') =
                    anonymize_vars' (m, i) a
            in
                (s1, Def v a')


anonymize_xs_vars :: AnonymousVarMap -> DefList -> (AnonymousVarMap, DefList)
anonymize_xs_vars s (DefListOne x) =
    let
        (s1, x') =
            anonymize_x_vars s x
    in
        (s1, DefListOne x')
anonymize_xs_vars s (DefListCons x xs) =
    let
        (s1, x') =
            anonymize_x_vars s x

        (s2, xs') =
            anonymize_xs_vars s1 xs
    in
        (s2, DefListCons x' xs')


anonymize_vars' :: AnonymousVarMap -> Expr -> (AnonymousVarMap, Expr)
anonymize_vars' (m, i) (Var name) =
    case Map.lookup name m of
        Nothing ->
            let
                (i1, v) =
                    anonymous_var i
                m' =
                    Map.insert name v m
            in
                ((m', i1), Var v)
        Just v ->
            ((m, i), Var v)
anonymize_vars' s      (Lam args a) =
    let
        (s1, args') =
            anonymize_args_vars s args

        (s2, a') =
            anonymize_vars' s1 a
    in
        (s2, Lam args' a')
anonymize_vars' s      (LetRec xs a) =
    let
        (s1, xs') =
            anonymize_xs_vars s xs

        (s2, a') =
            anonymize_vars' s1 a
    in
        (s2, LetRec xs' a')
anonymize_vars' s      (IfElse p a b) =
    let
        (s1, p') =
            anonymize_vars' s p
        (s2, a') =
            anonymize_vars' s1 a
        (s3, b') =
            anonymize_vars' s2 b
    in
        (s3, IfElse p' a' b')
anonymize_vars' s      (App a b) =
    let
        (s1, a') =
            anonymize_vars' s a
        (s2, b') =
            anonymize_vars' s1 b
    in
        (s2, App a' b')
anonymize_vars' s      (Brack a) =
    let
        (s1, a') =
            anonymize_vars' s a
    in
        (s1, Brack a')
anonymize_vars' s      (BinOp op a) =
    let
        (s1, a') =
            anonymize_vars' s a
    in
        (s1, BinOp op a')
anonymize_vars' s x =
    (s, x)


anonymize_vars :: Expr -> (AnonymousVarMap, Expr)
anonymize_vars =
    anonymize_vars' (Map.empty, 0)
