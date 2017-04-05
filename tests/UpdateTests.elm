module UpdateTests exposing (tests)

import Date exposing (Date, Month(..))
import Date.Extra exposing (fromParts)
import Expect
import Http
import RemoteData exposing (RemoteData(..))
import Test exposing (..)

import Message exposing (..)
import Model exposing (Model, Release, Repository, User)
import Update exposing (update)


someDate : Date
someDate = fromParts 2017 Mar 29 11 15 0 0

tests : Test
tests =
    describe "update"
        [ describe "AttemptLogin"
            [ test "does not change the model" <|
                \() ->
                    update AttemptLogin (Model "" Nothing "" NotAsked Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked Nothing Nothing)

            ]
        , describe "UpdateAuthenticatedUser"
            [ test "does not change the model on error" <|
                \() ->
                    update (UpdateAuthenticatedUser (Err Http.Timeout)) (Model "" Nothing "" NotAsked Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked Nothing Nothing)
            , test "changes the model on success" <|
                \() ->
                    update (UpdateAuthenticatedUser (Ok "foobar")) (Model "" Nothing "sometoken" NotAsked Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" (Just (User "foobar")) "sometoken" Loading Nothing Nothing)
            ]
        , describe "UpdateOAuthToken"
            [ test "updates username and resets token" <|
                \() ->
                    update (UpdateOAuthToken "baz") (Model "" Nothing "" NotAsked Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "baz" NotAsked Nothing Nothing)
            ]
        , describe "Logout"
            [ test "resets the model" <|
                \() ->
                    update Logout (Model "" (Just (User "")) "some token" (Success []) Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked Nothing Nothing)
            ]
        , describe "UpdateRepositories"
            [ test "updates repositories on model" <|
                \() ->
                    update (UpdateRepositories (Success [])) (Model "" Nothing "" Loading Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" (Success []) Nothing Nothing)
            ]
        , describe "ChooseRepository"
            [ test "updates the current repository" <|
                \() ->
                    update (ChooseRepository <| Repository "fo/o" "fo" "o") (Model "" Nothing "" NotAsked Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked (Just <| Repository "fo/o" "fo" "o") Nothing)
            ]
        , describe "UpdateReleases"
            [ test "updates the releases on model" <|
                \() ->
                    update (UpdateReleases (Ok [ Release "v1" True True "url" "tag" someDate])) (Model "" Nothing "" NotAsked Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked Nothing (Just [ Release "v1" True True "url" "tag" someDate ]))
            , test "does not update releases on error" <|
                \() ->
                    update (UpdateReleases (Err Http.Timeout)) (Model "" Nothing "" NotAsked Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked Nothing Nothing)
            ]
        ]
