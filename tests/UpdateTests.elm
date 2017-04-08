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
                    update AttemptLogin (Model "" Nothing "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked Nothing NotAsked)

            ]
        , describe "UpdateAuthenticatedUser"
            [ test "does not change the model on error" <|
                \() ->
                    update (UpdateAuthenticatedUser (Err Http.Timeout)) (Model "" Nothing "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked Nothing NotAsked)
            , test "changes the model on success" <|
                \() ->
                    update (UpdateAuthenticatedUser (Ok "foobar")) (Model "" Nothing "sometoken" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" (Just (User "foobar")) "sometoken" Loading Nothing NotAsked)
            ]
        , describe "UpdateOAuthToken"
            [ test "updates username and resets token" <|
                \() ->
                    update (UpdateOAuthToken "baz") (Model "" Nothing "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "baz" NotAsked Nothing NotAsked)
            ]
        , describe "Logout"
            [ test "resets the model" <|
                \() ->
                    update Logout (Model "" (Just (User "")) "some token" (Success []) Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked Nothing NotAsked)
            ]
        , describe "UpdateRepositories"
            [ test "updates repositories on model" <|
                \() ->
                    update (UpdateRepositories (Success [])) (Model "" Nothing "" Loading Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" (Success []) Nothing NotAsked)
            ]
        , describe "ChooseRepository"
            [ test "updates the current repository" <|
                \() ->
                    update (ChooseRepository <| Repository "fo/o" "fo" "o") (Model "" Nothing "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked (Just <| Repository "fo/o" "fo" "o") Loading)
            ]
        , describe "UpdateReleases"
            [ test "updates model on success" <|
                \() ->
                    update (UpdateReleases (Success [ Release "v1" True True "url" "tag" someDate])) (Model "" Nothing "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked Nothing (Success [ Release "v1" True True "url" "tag" someDate ]))
            , test "update model on error" <|
                \() ->
                    update (UpdateReleases (Failure Http.Timeout)) (Model "" Nothing "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" NotAsked Nothing (Failure Http.Timeout))
            ]
        ]
