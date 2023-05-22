module Parser.PR29 exposing (suite)

{-| Test changes of <https://github.com/elm/parser/pull/29>
-}

import Expect
import Parser
import Test exposing (..)


suite : Test
suite =
    describe "Fixes from https://github.com/elm/parser/pull/29"
        [ example
        , issue9
        ]


{-| from <https://github.com/elm/parser/pull/29>
-}
example : Test
example =
    test "Was Parser.deadEndsToString patched?" <|
        \_ ->
            Parser.run Parser.int "abc"
                |> Result.mapError Parser.deadEndsToString
                |> Expect.equal (Err "Expecting Int at row 1, col 1")


{-| Fixes <https://github.com/elm/parser/issues/9>
-}
issue9 : Test
issue9 =
    test "Fix: Add Parser.deadEndsToString implementation?" <|
        \_ ->
            Parser.run Parser.int "abc"
                |> Result.mapError Parser.deadEndsToString
                |> Expect.notEqual (Err "TODO deadEndsToString")
