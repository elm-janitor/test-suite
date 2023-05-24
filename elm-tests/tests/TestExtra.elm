module TestExtra exposing
    ( verify
    , verifyList
    )

import Expect
import Test exposing (..)


verifyList : String -> (a -> b) -> List ( a, b ) -> List Test
verifyList fnName fn list =
    List.map (\( input, expected ) -> verify fnName fn input expected) list


verify : String -> (a -> b) -> a -> b -> Test
verify fnName fn input expected =
    test ("Expected " ++ fnName ++ " " ++ Debug.toString input ++ " == " ++ Debug.toString expected) <|
        \_ ->
            fn input |> Expect.equal expected
