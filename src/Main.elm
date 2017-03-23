module Main exposing (..)

import Html exposing (program)

import Layout exposing (Model, Msg)


init : ( Model, Cmd Msg )
init =
    ( Model Nothing "" Nothing Nothing, Cmd.none )


main : Program Never Layout.Model Layout.Msg
main =
    program
        { init = init
        , view = Layout.view
        , update = Layout.update
        , subscriptions = Layout.subscriptions
        }

