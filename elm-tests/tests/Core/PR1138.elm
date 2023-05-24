module Core.PR1138 exposing (suite)

{-| Test changes of <https://github.com/elm/core/pull/1138>
which obsoletes <https://github.com/elm/core/pull/970>
-}

import Char exposing (isLower)
import Expect
import Test exposing (..)
import TestExtra


suite : Test
suite =
    describe "Fixes from https://github.com/elm/core/pull/1138"
        [ issue942
        , examplesInPr970
        , verifyCodeDocsOfPr1138
        ]


{-| Fixes <https://github.com/elm/core/issues/942>
-}
issue942 : Test
issue942 =
    let
        verifyLowerAndUpper : Char -> Char -> Test
        verifyLowerAndUpper lower upper =
            describe ("'" ++ String.fromChar lower ++ "' is the lower case variant of '" ++ String.fromChar upper ++ "'")
                [ isLowerNotUpper lower
                , isUpperNotLower upper
                , TestExtra.verify
                    ("Char.toUpper '" ++ String.fromChar lower ++ "' == '" ++ String.fromChar upper ++ "'")
                    Char.toUpper
                    lower
                    upper
                , TestExtra.verify
                    ("Char.toLower '" ++ String.fromChar upper ++ "' == '" ++ String.fromChar lower ++ "'")
                    Char.toLower
                    upper
                    lower
                ]
    in
    describe "Examples from https://github.com/elm/core/issues/942" <|
        [ -- from https://github.com/elm/core/issues/942#issue-296756166
          verifyLowerAndUpper 'å' 'Å'
        , verifyLowerAndUpper 'ä' 'Ä'
        , verifyLowerAndUpper 'ö' 'Ö'
        , -- From https://github.com/elm/core/issues/942#issuecomment-374922955
          isLowerNotUpper 'ß'
        ]


examplesInPr970 : Test
examplesInPr970 =
    -- From https://github.com/elm/core/pull/970#issuecomment-1030142359
    -- https://ellie-app.com/gBmgVVFzhbRa1 contains a table of all the 1441 codepoints
    --  that gave wrong results with the official 1.0.5 release
    describe "'ǅ' is neither upper nor lower case according to Unicode standard"
        [ equals (Char.fromCode 453) 'ǅ'
        , isUpper 'ǅ' False
        , isLower 'ǅ' False
        ]


{-| From code documentation in <https://github.com/elm/core/pull/1138>
-}
verifyCodeDocsOfPr1138 : Test
verifyCodeDocsOfPr1138 =
    describe "Examples from code docs"
        [ describe "Same behavior as before"
            [ describe "Char.isUpper" unchangedIsUpper
            , describe "Char.isLower" unchangedIsLower
            ]
        , describe "Changes with https://github.com/elm/core/pull/1138"
            [ TestExtra.verify "Char.isUpper" Char.isUpper 'Σ' True
            , isLowerNotUpper 'π'
            ]
        ]


unchangedIsUpper : List Test
unchangedIsUpper =
    [ ( 'A', True )
    , ( 'B', True )
    , ( 'Z', True )
    , ( '0', False )
    , ( 'a', False )
    , ( '-', False )
    ]
        |> List.map (\( input, expected ) -> isUpper input expected)


unchangedIsLower : List Test
unchangedIsLower =
    [ ( 'a', True )
    , ( 'b', True )
    , ( 'z', True )
    , ( '0', False )
    , ( 'A', False )
    , ( '-', False )
    ]
        |> List.map (\( input, expected ) -> isLower input expected)



-- SHARED HELPERS


isLowerNotUpper : Char -> Test
isLowerNotUpper char =
    describe (String.fromChar char ++ "is lower case, not upper case")
        [ isLower char True
        , isUpper char False
        ]


isUpperNotLower : Char -> Test
isUpperNotLower char =
    describe (String.fromChar char ++ "is upper case, not lower case")
        [ isUpper char True
        , isLower char False
        ]


isLower : Char -> Bool -> Test
isLower =
    TestExtra.verify "Char.isLower" Char.isLower


isUpper : Char -> Bool -> Test
isUpper =
    TestExtra.verify "Char.isUpper" Char.isUpper


equals : Char -> Char -> Test
equals a b =
    test ("'" ++ String.fromChar a ++ "' == '" ++ String.fromChar b ++ "'") <|
        \_ -> Expect.equal a b
