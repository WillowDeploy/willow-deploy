module UpdateTests exposing (tests)

import Expect
import Http
import Test exposing (..)

import Message exposing (..)
import Model exposing (Model, Release, Repository, User)
import Update exposing (update)

tests : Test
tests =
    describe "update"
        [ describe "AttemptLogin"
            [ test "does not change the model" <|
                \() ->
                    update AttemptLogin (Model "" Nothing "" (Just []) Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" (Just []) Nothing Nothing)

            ]
        , describe "UpdateAuthenticatedUser"
            [ test "does not change the model on error" <|
                \() ->
                    update (UpdateAuthenticatedUser (Err Http.Timeout)) (Model "" Nothing "" (Just []) Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" (Just []) Nothing Nothing)
            , test "changes the model on success" <|
                \() ->
                    update (UpdateAuthenticatedUser (Ok "foobar")) (Model "" Nothing "sometoken" (Just []) Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" (Just (User "foobar")) "sometoken" (Just []) Nothing Nothing)
            ]
        , describe "UpdateOAuthToken"
            [ test "updates username and resets token" <|
                \() ->
                    update (UpdateOAuthToken "baz") (Model "" Nothing "" (Just []) Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "baz" (Just []) Nothing Nothing)
            ]
        , describe "Logout"
            [ test "resets the model" <|
                \() ->
                    update Logout (Model "" (Just (User "")) "some token" (Just []) Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" Nothing Nothing Nothing)
            ]
        , describe "UpdateRepositories"
            [ test "updates repositories on model" <|
                \() ->
                    update (UpdateRepositories (Ok [])) (Model "" Nothing "" Nothing Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" (Just []) Nothing Nothing)
            , test "does not change the repositories on error" <|
                \() ->
                    update (UpdateRepositories (Err Http.Timeout)) (Model "" Nothing "" (Just [Repository "re/po1" "re" "po1"]) Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" (Just [Repository "re/po1" "re" "po1"]) Nothing Nothing)
            ]
        , describe "ChooseRepository"
            [ test "updates the current repository" <|
                \() ->
                    update (ChooseRepository <| Repository "fo/o" "fo" "o") (Model "" Nothing "" Nothing Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" Nothing (Just <| Repository "fo/o" "fo" "o") Nothing)
            ]
        , describe "UpdateReleases"
            [ test "updates the releases on model" <|
                \() ->
                    update (UpdateReleases (Ok [ Release "v1" True True "url" ])) (Model "" Nothing "" Nothing Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" Nothing Nothing (Just [ Release "v1" True True "url" ]))
            , test "does not update releases on error" <|
                \() ->
                    update (UpdateReleases (Err Http.Timeout)) (Model "" Nothing "" Nothing Nothing Nothing)
                    |> Tuple.first
                    |> Expect.equal (Model "" Nothing "" Nothing Nothing Nothing)
            ]
        ]
