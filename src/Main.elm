module Main exposing (..)

import Html exposing (programWithFlags)

import Message exposing (Msg)
import Model exposing (Model)
import Subscriptions exposing (subscriptions)
import Update exposing (fetchAuthenticatedUser, update)
import View exposing (view)


type alias Flags =
    { githubBaseUrl: String
    , token: Maybe String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        githubBaseUrl = flags.githubBaseUrl
        (doNext, token) = case flags.token of
            Nothing -> (Cmd.none, "")
            Just token -> (fetchAuthenticatedUser githubBaseUrl token, token)
    in
        ( Model flags.githubBaseUrl Nothing token Nothing Nothing Nothing, doNext )


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
