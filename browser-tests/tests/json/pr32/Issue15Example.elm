module Issue15Example exposing (main)

{-| Source: <https://github.com/elm/json/issues/15#issue-431599397>
-}

import Browser
import Html exposing (Html)
import Html.Events
import Json.Decode


main : Program () Int Int
main =
    Browser.sandbox
        { init = 0
        , view = view
        , update = always
        }


view : Int -> Html Int
view clicks =
    Html.div []
        [ Html.h1 [] [ Html.text (String.fromInt clicks) ]
        , Html.text "Expected: Both buttons should increase the value by 1"
        , Html.hr [] []
        , Html.button
            [ Html.Events.on "click" (Json.Decode.oneOf [ Json.Decode.succeed (clicks + 1) ]) ]
            [ Html.text "oneOf failure: Will always set value to 1" ]
        , Html.button
            [ Html.Events.on "click" (Json.Decode.succeed (clicks + 1)) ]
            [ Html.text "+1 (works)" ]
        ]
