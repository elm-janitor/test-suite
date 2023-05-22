module Parser.PR54 exposing (suite)

{-| Test changes of <https://github.com/elm/parser/pull/54>
Closes <https://github.com/elm/parser/pull/21>
Closes <https://github.com/elm/parser/pull/37>
-}

import Expect
import Parser exposing ((|.), (|=), Parser)
import Test exposing (..)


suite : Test
suite =
    describe "Fixes from https://github.com/elm/parser/pull/54"
        [ examplePr54
        , issue2
        , issue20
        , issue46
        , issue53
        ]


{-| from <https://github.com/elm/parser/pull/54#issue-1448354010>
-}
examplePr54 : Test
examplePr54 =
    let
        testParser : Parser { row : Int, col : Int, offset : Int }
        testParser =
            Parser.succeed (\row col offset -> { row = row, col = col, offset = offset })
                |. Parser.multiComment "{-" "-}" Parser.Nestable
                |= Parser.getRow
                |= Parser.getCol
                |= Parser.getOffset
    in
    test "Bugfix for `Elm.Kernel.Parser.findSubString`" <|
        \_ ->
            Parser.run testParser "{- -}"
                |> Expect.equal (Ok { row = 1, col = 6, offset = 5 })


{-| Fixes <https://github.com/elm/parser/issues/2>
-}
issue2 : Test
issue2 =
    let
        commentByItself : String
        commentByItself =
            "/*abc*/"

        commentWithTrailingText : String
        commentWithTrailingText =
            "/*abc*/def"

        nestable : Parser ()
        nestable =
            Parser.multiComment "/*" "*/" Parser.Nestable |. Parser.end

        notNestable : Parser ()
        notNestable =
            Parser.multiComment "/*" "*/" Parser.NotNestable |. Parser.end

        notNestableWorkaround : Parser ()
        notNestableWorkaround =
            Parser.multiComment "/*" "*/" Parser.NotNestable
                |. Parser.token "*/"
                |. Parser.end

        chompUntil : Parser ()
        chompUntil =
            Parser.token "/*" |. Parser.chompUntil "*/" |. Parser.end

        chompUntilWorkaround : Parser ()
        chompUntilWorkaround =
            Parser.token "/*"
                |. Parser.chompUntil "*/"
                |. Parser.token "*/"
                |. Parser.end
    in
    describe "Fix: Parser.multiComment does not chomp comment terminator in NotNestable mode"
        [ test ("nestable " ++ commentByItself) <|
            \_ ->
                Parser.run nestable commentByItself
                    |> Expect.equal (Ok ())
        , test ("nestable" ++ commentWithTrailingText) <|
            \_ ->
                Parser.run nestable commentWithTrailingText
                    |> Expect.equal (Err [ { col = 8, problem = Parser.ExpectingEnd, row = 1 } ])
        , test ("notNestable " ++ commentByItself) <|
            \_ ->
                Parser.run notNestable commentByItself
                    |> Expect.equal (Ok ())
        , test ("notNestable" ++ commentWithTrailingText) <|
            \_ ->
                Parser.run notNestable commentWithTrailingText
                    |> Expect.equal (Err [ { col = 8, problem = Parser.ExpectingEnd, row = 1 } ])
        , test ("notNestableWorkaround " ++ commentByItself) <|
            \_ ->
                Parser.run notNestableWorkaround commentByItself
                    |> Expect.equal (Err [ { col = 8, problem = Parser.Expecting "*/", row = 1 } ])
        , test ("notNestableWorkaround" ++ commentWithTrailingText) <|
            \_ ->
                Parser.run notNestableWorkaround commentWithTrailingText
                    |> Expect.equal (Err [ { col = 8, problem = Parser.Expecting "*/", row = 1 } ])
        , test ("chompUntil " ++ commentByItself) <|
            \_ ->
                Parser.run chompUntil commentByItself
                    |> Expect.equal (Ok ())
        , test ("chompUntil" ++ commentWithTrailingText) <|
            \_ ->
                Parser.run chompUntil commentWithTrailingText
                    |> Expect.equal (Err [ { col = 8, problem = Parser.ExpectingEnd, row = 1 } ])
        , test ("chompUntilWorkaround " ++ commentByItself) <|
            \_ ->
                Parser.run chompUntilWorkaround commentByItself
                    |> Expect.equal (Err [ { col = 8, problem = Parser.Expecting "*/", row = 1 } ])
        , test ("chompUntilWorkaround" ++ commentWithTrailingText) <|
            \_ ->
                Parser.run chompUntilWorkaround commentWithTrailingText
                    |> Expect.equal (Err [ { col = 8, problem = Parser.Expecting "*/", row = 1 } ])
        ]


{-| Fixes <https://github.com/elm/parser/issues/20#issue-376898585>
-}
issue20 : Test
issue20 =
    let
        chomper : Parser ( String, ( Int, Int ) )
        chomper =
            Parser.succeed Tuple.pair
                |= Parser.getChompedString (Parser.chompUntil "bar")
                |= Parser.getPosition
    in
    test "`chompUntil` consumes the last string" <|
        \_ ->
            Parser.run chomper "foobar"
                |> Expect.equal (Ok ( "foobar", ( 1, 7 ) ))


{-| Fixes <https://github.com/elm/parser/issues/46#issue-611518583>
-}
issue46 : Test
issue46 =
    let
        valid : String
        valid =
            """one -- comment before newline
two -- comment before end of file"""

        invalid : String
        invalid =
            """one -- comment before newline
two - comment before end of file"""

        parser : Parser ( Located (), Located () )
        parser =
            Parser.succeed Tuple.pair
                |= (located <| Parser.token "one")
                |. sps
                |= (located <| Parser.token "two")
                |. sps
                |. Parser.end

        parserWorkAround : Parser ( Located (), Located () )
        parserWorkAround =
            Parser.succeed Tuple.pair
                |= (located <| Parser.token "one")
                |. spsWorkAround
                |= (located <| Parser.token "two")
                |. sps
                |. Parser.end

        located : Parser a -> Parser (Located a)
        located p =
            Parser.succeed Located
                |= Parser.getPosition
                |= p
                |= Parser.getPosition

        sps : Parser ()
        sps =
            Parser.loop 0 <|
                ifProgress <|
                    Parser.oneOf
                        [ Parser.lineComment "--"
                        , Parser.multiComment "{-" "-}" Parser.Nestable
                        , Parser.spaces
                        ]

        spsWorkAround : Parser ()
        spsWorkAround =
            Parser.loop 0 <|
                ifProgress <|
                    Parser.oneOf
                        [ lineCommentWorkAround "--"
                        , Parser.multiComment "{-" "-}" Parser.Nestable
                        , Parser.spaces
                        ]

        lineCommentWorkAround : String -> Parser ()
        lineCommentWorkAround start =
            Parser.succeed ()
                |. Parser.symbol start
                |. Parser.chompWhile (\c -> c /= '\n')

        ifProgress : Parser a -> Int -> Parser (Parser.Step Int ())
        ifProgress p offset =
            Parser.succeed identity
                |. p
                |= Parser.getOffset
                |> Parser.map
                    (\newOffset ->
                        if offset == newOffset then
                            Parser.Done ()

                        else
                            Parser.Loop newOffset
                    )
    in
    let
        ok : ( Located (), Located () )
        ok =
            ( { from = ( 1, 1 ), to = ( 1, 4 ), value = () }
            , { from = ( 2, 1 ), to = ( 2, 4 ), value = () }
            )

        err =
            Err [ { col = 5, problem = Parser.ExpectingEnd, row = 2 } ]
    in
    describe "lineComment messes up newline tracking"
        [ describe "Normal source string without error"
            [ test "lineCommentWorkAround" <|
                \_ ->
                    Parser.run parserWorkAround valid
                        |> Expect.equal (Ok ok)
            , test "lineComment" <|
                \_ ->
                    Parser.run parser valid
                        |> Expect.equal (Ok ok)
            ]
        , describe "misspelled '--' in second line"
            [ test "lineCommentWorkAround" <|
                \_ ->
                    Parser.run parserWorkAround invalid
                        |> Expect.equal err
            , test "lineComment" <|
                \_ ->
                    Parser.run parser invalid
                        |> Expect.equal err
            ]
        ]


type alias Located a =
    { from : ( Int, Int )
    , value : a
    , to : ( Int, Int )
    }


{-| Fixes <https://github.com/elm/parser/issues/53#issue-1447657030>
-}
issue53 : Test
issue53 =
    let
        testParser : Parser { row : Int, col : Int, offset : Int }
        testParser =
            Parser.succeed (\row col offset -> { row = row, col = col, offset = offset })
                |. Parser.chompUntil "token"
                |= Parser.getRow
                |= Parser.getCol
                |= Parser.getOffset
    in
    test "issue 53" <|
        \_ ->
            Parser.run testParser "< token >"
                |> Expect.equal (Ok { row = 1, col = 8, offset = 7 })
