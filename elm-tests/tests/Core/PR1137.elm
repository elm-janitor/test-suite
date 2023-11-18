module Core.PR1137 exposing (suite)

{-| Test changes of <https://github.com/elm/core/pull/1137>
-}

import Expect
import Test exposing (..)


{-| from <https://github.com/elm/core/pull/1137#issue-1689843724>
-}
suite : Test
suite =
    describe "Fix `String.foldr` bug that causes infinite loop"
        [ stringToList
        , stringAny
        , stringAll
        ]


stringToList : Test
stringToList =
    test "String.toList does not cause an infinite loop" <|
        \() ->
            String.toList evilPartialCharacter
                |> List.length
                |> Expect.equal 1


stringAny : Test
stringAny =
    test "String.any does not cause an infinite loop" <|
        \() ->
            evilPartialCharacter
                |> String.any (\c -> c == ' ')
                |> Expect.equal False


stringAll : Test
stringAll =
    test "String.all does not cause an infinite loop" <|
        \() ->
            evilPartialCharacter
                |> String.all (\c -> c /= ' ')
                |> Expect.equal True


evilPartialCharacter : String
evilPartialCharacter =
    String.right 1 "foobar😈"
