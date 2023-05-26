module HttpPr66 exposing (main)

import Http
import Json.Encode


type Msg
    = Whatever (Result Http.Error ())


main : Program () () Msg
main =
    Platform.worker
        { init = \() -> ( (), post )
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


post : Cmd Msg
post =
    Http.post
        { url = "https://example.test"
        , body = Http.jsonBody (Json.Encode.string "body")
        , expect = Http.expectWhatever Whatever
        }
