module FilePr17 exposing (main)

import Bytes.Encode
import File.Download


main : Program () () msg
main =
    Platform.worker
        { init = \() -> ( (), download )
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


download : Cmd msg
download =
    [ 119, 111, 114, 100 ]
        |> List.map Bytes.Encode.unsignedInt8
        |> Bytes.Encode.sequence
        |> Bytes.Encode.encode
        |> File.Download.bytes "word.txt" "text/plain"
