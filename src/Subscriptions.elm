module Subscriptions exposing (subscriptions)

import Message exposing (Msg)
import Model exposing (Model)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
