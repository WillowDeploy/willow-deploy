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
            [ test "marks user as loading" <|
                \() ->
                    update AttemptLogin (Model "" NotAsked "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" Loading "" NotAsked Nothing NotAsked)

            ]
        , describe "UpdateAuthenticatedUser"
            [ test "does not change the model on error" <|
                \() ->
                    update (UpdateAuthenticatedUser (Failure Http.Timeout)) (Model "" Loading "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" (Failure Http.Timeout) "" NotAsked Nothing NotAsked)
            , test "changes the model on success" <|
                \() ->
                    update (UpdateAuthenticatedUser (Success (User "foobar"))) (Model "" NotAsked "sometoken" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" (Success (User "foobar")) "sometoken" Loading Nothing NotAsked)
            ]
        , describe "UpdateOAuthToken"
            [ test "updates username and resets token" <|
                \() ->
                    update (UpdateOAuthToken "baz") (Model "" NotAsked "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" NotAsked "baz" NotAsked Nothing NotAsked)
            ]
        , describe "Logout"
            [ test "resets the model" <|
                \() ->
                    update Logout (Model "" (Success (User "")) "some token" (Success []) Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" NotAsked "" NotAsked Nothing NotAsked)
            ]
        , describe "UpdateRepositories"
            [ test "updates repositories on model" <|
                \() ->
                    update (UpdateRepositories (Success [])) (Model "" NotAsked "" Loading Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" NotAsked "" (Success []) Nothing NotAsked)
            ]
        , describe "ChooseRepository"
            [ test "updates the current repository" <|
                \() ->
                    update (ChooseRepository <| Repository "fo/o" "fo" "o") (Model "" NotAsked "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" NotAsked "" NotAsked (Just <| Repository "fo/o" "fo" "o") Loading)
            ]
        , describe "UpdateReleases"
            [ test "updates model on success" <|
                \() ->
                    update (UpdateReleases (Success [ Release "v1" True True "url" "tag" someDate])) (Model "" NotAsked "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" NotAsked "" NotAsked Nothing (Success [ Release "v1" True True "url" "tag" someDate ]))
            , test "update model on error" <|
                \() ->
                    update (UpdateReleases (Failure Http.Timeout)) (Model "" NotAsked "" NotAsked Nothing NotAsked)
                    |> Tuple.first
                    |> Expect.equal (Model "" NotAsked "" NotAsked Nothing (Failure Http.Timeout))
            ]
        ]
