module Core.PR1092 exposing (suite)

{-| Test changes of <https://github.com/elm/core/pull/1092>
which fixes <https://github.com/elm/bytes/issues/15>
-}

import Bytes exposing (Bytes)
import Bytes.Encode
import Expect
import Fuzz exposing (Fuzzer)
import Test exposing (..)


{-| Fixes <https://github.com/elm/bytes/issues/15>
-}
suite : Test
suite =
    describe "Fixes from https://github.com/elm/core/pull/1092"
        [ fuzz listInt "Bytes from the same int values should be equal" <|
            \ints ->
                Expect.equal (uint8stoBytes ints) (uint8stoBytes ints)
        , test "Simplest case: [] != [1]" <|
            \_ ->
                Expect.notEqual (uint8stoBytes []) (uint8stoBytes [ 1 ])
        , test "Same numbers, different encoding should not be equal" <|
            \_ ->
                let
                    as2Bytes =
                        [ Bytes.Encode.unsignedInt16 Bytes.LE 1 ] |> toBytes

                    as1Byte =
                        [ Bytes.Encode.unsignedInt8 1 ] |> toBytes
                in
                Expect.notEqual as1Byte as2Bytes
        , fuzz2 listInt listInt "Compare different bytes" <|
            \ints1 ints2 ->
                let
                    a =
                        uint8stoBytes ints1

                    b =
                        uint8stoBytes ints2
                in
                if Bytes.width a /= Bytes.width b then
                    Expect.notEqual a b

                else if ints1 == ints2 then
                    Expect.equal a b

                else
                    Expect.notEqual a b
        ]


listInt : Fuzzer (List Int)
listInt =
    Fuzz.list <| Fuzz.intRange 0 255


uint8stoBytes : List Int -> Bytes
uint8stoBytes list =
    List.map Bytes.Encode.unsignedInt8 list
        |> toBytes


toBytes : List Bytes.Encode.Encoder -> Bytes
toBytes =
    Bytes.Encode.encode << Bytes.Encode.sequence
