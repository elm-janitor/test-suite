module Random.PR22 exposing (suite)

{-| Test changes of <https://github.com/elm/random/pull/22>
-}

import Expect
import Fuzz
import Random
import Test exposing (..)


suite : Test
suite =
    describe "Fixes from https://github.com/elm/random/pull/22"
        [ issue21
        , fuzzIssue21
        ]


{-| Fixes <https://github.com/elm/random/issues/21>
-}
issue21 : Test
issue21 =
    let
        min =
            -100

        max =
            100
    in
    describe "issue 21: Random.float and Random.int should generate values in the same range"
        [ test ("Random.float " ++ String.fromInt max ++ " " ++ String.fromInt min ++ " should return a number between " ++ String.fromInt min ++ " and " ++ String.fromInt max) <|
            \() ->
                Random.initialSeed 13
                    |> Random.step (Random.float max min)
                    |> Tuple.first
                    |> Expect.all
                        [ Expect.greaterThan min
                        , Expect.lessThan max
                        ]
        , test ("Random.int " ++ String.fromInt max ++ " " ++ String.fromInt min ++ " should return a number between " ++ String.fromInt min ++ " and " ++ String.fromInt max) <|
            \() ->
                Random.initialSeed 13
                    |> Random.step (Random.int max min)
                    |> Tuple.first
                    |> Expect.all
                        [ Expect.greaterThan min
                        , Expect.lessThan max
                        ]
        ]


fuzzIssue21 : Test
fuzzIssue21 =
    fuzz2 Fuzz.int Fuzz.int "`Random.float` should generate values in the same range as `Random.int`" <|
        \a b ->
            let
                ( min, max ) =
                    if a == b then
                        ( a, a - 10 )

                    else if a > b then
                        ( a, b )

                    else
                        ( b, a )

                randomList rand =
                    Random.list 10 rand
                        |> (\r -> Random.step r (Random.initialSeed 13))
                        |> Tuple.first

                getMinMax : List Float -> ( Float, Float )
                getMinMax l =
                    case ( List.minimum l, List.maximum l ) of
                        ( Just foundMin, Just foundMax ) ->
                            ( foundMin, foundMax )

                        _ ->
                            Debug.todo "Empty list is not allowed, it has a length > 0"

                ( floatMin, floatMax ) =
                    Random.float (toFloat max) (toFloat min)
                        |> randomList
                        |> getMinMax

                ( intMin, intMax ) =
                    Random.int max min
                        |> randomList
                        |> List.map toFloat
                        |> getMinMax
            in
            Expect.all
                [ \( expected, _ ) -> Expect.greaterThan intMin expected
                , \( expected, _ ) -> Expect.greaterThan floatMin expected
                , \( _, expected ) -> Expect.lessThan intMax expected
                , \( _, expected ) -> Expect.lessThan floatMax expected
                ]
                ( toFloat min, toFloat max )
