module Main exposing (..)

import Html exposing (programWithFlags)

import Layout exposing (Model, Msg)


type alias Flags =
    { githubBaseUrl: String
    }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model flags.githubBaseUrl  Nothing "" Nothing Nothing, Cmd.none )


main : Program Flags Layout.Model Layout.Msg
main =
    programWithFlags
        { init = init
        , view = Layout.view
        , update = Layout.update
        , subscriptions = Layout.subscriptions
        }

