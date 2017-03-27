module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, attribute, class)
import Http exposing (get)

import Layout exposing (Model, view, update)


all : Test
all =
    describe "Willow Deploy front end"
        [ describe "update"
            [ describe "AttemptLogin"
                [ test "does not change the model" <|
                    \() ->
                        update Layout.AttemptLogin (Model "" Nothing "" (Just []) Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" (Just []) Nothing)

                ]
            , describe "UpdateAuthenticatedUser"
                [ test "does not change the model on error" <|
                    \() ->
                        update (Layout.UpdateAuthenticatedUser (Err Http.Timeout)) (Model "" Nothing "" (Just []) Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" (Just []) Nothing)
                , test "changes the model on success" <|
                    \() ->
                        update (Layout.UpdateAuthenticatedUser (Ok "foobar")) (Model "" Nothing "sometoken" (Just []) Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" (Just (Layout.User "foobar")) "sometoken" (Just []) Nothing)
                ]
            , describe "UpdateOAuthToken"
                [ test "updates username and resets token" <|
                    \() ->
                        update (Layout.UpdateOAuthToken "baz") (Model "" Nothing "" (Just []) Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "baz" (Just []) Nothing)
                ]
            , describe "Logout"
                [ test "resets the model" <|
                    \() ->
                        update Layout.Logout (Model "" (Just (Layout.User "")) "some token" (Just []) Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" Nothing Nothing)
                ]
            , describe "UpdateRepositories"
                [ test "updates repositories on model" <|
                    \() ->
                        update (Layout.UpdateRepositories (Ok [])) (Model "" Nothing "" Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" (Just []) Nothing)
                , test "does not change the repositories on error" <|
                    \() ->
                        update (Layout.UpdateRepositories (Err Http.Timeout)) (Model "" Nothing "" (Just [Layout.Repository "repo1"]) Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" (Just [Layout.Repository "repo1"]) Nothing)
                ]
            , describe "ChooseRepository"
                [ test "updates the current repository" <|
                    \() ->
                        update (Layout.ChooseRepository <| Layout.Repository "foo") (Model "" Nothing "" Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" Nothing (Just <| Layout.Repository "foo"))
                ]
            ]
        ]