port module SimpleWorker exposing (main)

import Platform


port initial : Int -> Cmd msg


port state : Int -> Cmd msg


port increment : (Int -> msg) -> Sub msg


port decrement : (Int -> msg) -> Sub msg


type Msg
    = Increment Int
    | Decrement Int


main =
    Platform.worker
        { init = \() -> ( 0, initial 0 )
        , subscriptions = \_ -> Sub.batch [ increment Increment, decrement Decrement ]
        , update = update
        }


update msg model =
    case msg of
        Increment int ->
            model + int |> publish

        Decrement int ->
            model - int |> publish


publish model =
    ( model, state model )
