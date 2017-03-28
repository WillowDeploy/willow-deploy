module Main exposing (..)

import Html exposing (programWithFlags)

import Message exposing (Msg)
import Model exposing (Model)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


type alias Flags =
    { githubBaseUrl: String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model flags.githubBaseUrl  Nothing "" Nothing Nothing Nothing, Cmd.none )


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
