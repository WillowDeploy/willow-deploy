module Main exposing (..)

import Html exposing (programWithFlags)
import RemoteData exposing (RemoteData(..))

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

        ( doNext, user, token ) = case flags.token of
            Nothing -> ( Cmd.none, NotAsked, "" )
            Just token -> ( fetchAuthenticatedUser githubBaseUrl token, Loading, token )
    in
        ( Model flags.githubBaseUrl user token NotAsked Nothing NotAsked, doNext )


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
