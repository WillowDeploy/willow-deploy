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
        [ describe "Navigation bar"
            [ describe "unauthenticated"
                [ test "Does not show current user name" <|
                    \() ->
                        view (Model "" Nothing "" (Just []) Nothing)
                        |> Query.fromHtml
                        |> Query.findAll [ tag "span" ]
                        |> Query.count (Expect.equal 0)
                , test "Does not show logout link" <|
                    \() ->
                        view (Model "" Nothing "" (Just []) Nothing)
                        |> Query.fromHtml
                        |> Query.findAll [ tag "a" ]
                        |> Query.count (Expect.equal 0)
                ]
            , describe "authenticated"
                [ test "Shows current user name" <|
                    \() ->
                        view (Model "" (Just (Layout.User "foo")) "" (Just []) Nothing)
                        |> Query.fromHtml
                        |> Query.find [ tag "span" ]
                        |> Query.has [ text "foo" ]
                , test "Shows a logout link" <|
                    \() ->
                        view (Model "" (Just (Layout.User "")) "" (Just []) Nothing)
                        |> Query.fromHtml
                        |> Query.find [ tag "a" ]
                        |> Query.has [ attribute "href" "#", text "logout" ]
                ]
            ]
        , describe "Login Page"
            [ test "Shows a token input" <|
                \() ->
                    view (Model "" Nothing "" (Just []) Nothing)
                    |> Query.fromHtml
                    |> Query.find [ tag "input" ]
                    |> Query.has [ attribute "placeholder" "Token" ]
            , test "Shows a login button" <|
                \() ->
                    view (Model "" Nothing "" (Just []) Nothing)
                    |> Query.fromHtml
                    |> Query.find [ tag "button" ]
                    |> Query.has [ text "Login" ]
            ]
        , describe "Repositories Page"
            [ describe "list"
                [ test "Show a div when the repositories is present" <|
                    \() ->
                        view (Model "" (Just (Layout.User "")) "" (Just []) Nothing)
                        |> Query.fromHtml
                        |> Query.findAll [ class "repositories" ]
                        |> Query.count (Expect.equal 1)
                , test "Shows a div for each repository" <|
                    \() ->
                        view (Model "" (Just (Layout.User "")) "" (Just [ Layout.Repository "bar" ]) Nothing)
                        |> Query.fromHtml
                        |> Query.find [ tag "div", text "bar" ]
                        |> Query.has [ text "bar" ]
                , test "Does not show a UL when repositories is nothing" <|
                    \() ->
                        view (Model "" (Just (Layout.User "")) "" Nothing Nothing)
                        |> Query.fromHtml
                        |> Query.findAll [ tag "ul" ]
                        |> Query.count (Expect.equal 0)
                ]
            ]
        , describe "update"
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