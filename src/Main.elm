module Main exposing (..)

import Html exposing (program)

import Layout

main : Program Never Layout.Model Layout.Msg
main =
    program
        { init = Layout.init
        , view = Layout.view
        , update = Layout.update
        , subscriptions = Layout.subscriptions
        }

