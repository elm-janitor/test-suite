module ProjectMetadataUtils.PR19 exposing (suite)

{-| Test changes of <https://github.com/elm/project-metadata-utils/pull/19>
-}

import Elm.Project
import Expect
import Json.Decode
import Json.Encode
import Result.Extra
import Test exposing (..)


suite : Test
suite =
    describe "Fixes from https://github.com/elm/project-metadata-utils/pull/19"
        [ issue19
        ]


{-| Fixes <https://github.com/elm/project-metadata-utils/issues/19>
-}
issue19 : Test
issue19 =
    test "Should sort `elm/core` before `elm-community/result-extra`" <|
        \() ->
            Json.Decode.decodeString Elm.Project.decoder sample
                |> Result.Extra.extract (\_ -> Debug.todo "decoder failed")
                |> Elm.Project.encode
                |> Json.Encode.encode 4
                |> Expect.equal sample


sample =
    """{
    "type": "application",
    "source-directories": [
        "src"
    ],
    "elm-version": "0.19.1",
    "dependencies": {
        "direct": {
            "elm/core": "1.0.5",
            "elm-community/result-extra": "2.4.0"
        },
        "indirect": {}
    },
    "test-dependencies": {
        "direct": {},
        "indirect": {}
    }
}"""
