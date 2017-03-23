module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, attribute)
import Http exposing (get)

import Layout exposing (Model, view, update)


all : Test
all =
    describe "The Deploy Button front end"
        [ describe "Navigation bar"
            [ describe "unauthenticated"
                [ test "Shows a token input" <|
                    \() ->
                        view (Model Nothing "" (Just []))
                        |> Query.fromHtml
                        |> Query.find [ tag "input" ]
                        |> Query.has [ attribute "placeholder" "OAuth token..." ]
                , test "Shows a login button" <|
                    \() ->
                        view (Model Nothing "" (Just []))
                        |> Query.fromHtml
                        |> Query.find [ tag "button" ]
                        |> Query.has [ text "Login" ]
                , test "Does not show current user name" <|
                    \() ->
                        view (Model Nothing "" (Just []))
                        |> Query.fromHtml
                        |> Query.findAll [ tag "span" ]
                        |> Query.count (Expect.equal 0)
                , test "Does not show logout link" <|
                    \() ->
                        view (Model Nothing "" (Just []))
                        |> Query.fromHtml
                        |> Query.findAll [ tag "a" ]
                        |> Query.count (Expect.equal 0)
                ]
            , describe "authenticated"
                [ test "Does not show a token input" <|
                    \() ->
                        view (Model (Just (Layout.User "foo")) "" (Just []))
                        |> Query.fromHtml
                        |> Query.findAll [ tag "input" ]
                        |> Query.count (Expect.equal 0)
                , test "Does not show a login button" <|
                    \() ->
                        view (Model (Just (Layout.User "foo")) "" (Just []))
                        |> Query.fromHtml
                        |> Query.findAll [ tag "button" ]
                        |> Query.count (Expect.equal 0)
                , test "Shows current user name" <|
                    \() ->
                        view (Model (Just (Layout.User "foo")) "" (Just []))
                        |> Query.fromHtml
                        |> Query.find [ tag "span" ]
                        |> Query.has [ text "foo" ]
                , test "Shows a logout link" <|
                    \() ->
                        view (Model (Just (Layout.User "")) "" (Just []))
                        |> Query.fromHtml
                        |> Query.find [ tag "a" ]
                        |> Query.has [ attribute "href" "#", text "logout" ]

                ]
            ]
        , describe "Repositories"
            [ describe "heading"
                [ test "Shows a heading describing the list for authenticated user" <|
                    \() ->
                        view (Model (Just (Layout.User "")) "" (Just []))
                        |> Query.fromHtml
                        |> Query.find [ tag "h2" ]
                        |> Query.has [ text "Repositories" ]
                , test "Does not show heading for non-authenticated user" <|
                    \() ->
                        view (Model Nothing "" (Just []))
                        |> Query.fromHtml
                        |> Query.findAll [ tag "h2" ]
                        |> Query.count (Expect.equal 0)
                ]
            , describe "list"
                [ test "Show a UL when the repositories is present" <|
                    \() ->
                        view (Model (Just (Layout.User "")) "" (Just []))
                        |> Query.fromHtml
                        |> Query.findAll [ tag "ul" ]
                        |> Query.count (Expect.equal 1)
                , test "Shows a LI for each repository" <|
                    \() ->
                        view (Model (Just (Layout.User "")) "" (Just [ Layout.Repository "bar" ]))
                        |> Query.fromHtml
                        |> Query.find [ tag "li", text "bar" ]
                        |> Query.has [ text "bar" ]
                , test "Does not show a UL when repositories is nothing" <|
                    \() ->
                        view (Model (Just (Layout.User "")) "" Nothing)
                        |> Query.fromHtml
                        |> Query.findAll [ tag "ul" ]
                        |> Query.count (Expect.equal 0)
                ]
            ]
        , describe "update"
            [ describe "AttemptLogin"
                [ test "does not change the model" <|
                    \() ->
                        update Layout.AttemptLogin (Model Nothing "" (Just []))
                        |> Tuple.first
                        |> Expect.equal (Model Nothing "" (Just []))

                ]
            , describe "UpdateAuthenticatedUser"
                [ test "does not change the model on error" <|
                    \() ->
                        update (Layout.UpdateAuthenticatedUser (Err Http.Timeout)) (Model Nothing "" (Just []))
                        |> Tuple.first
                        |> Expect.equal (Model Nothing "" (Just []))
                , test "changes the model on success" <|
                    \() ->
                        update (Layout.UpdateAuthenticatedUser (Ok "foobar")) (Model Nothing "sometoken" (Just []))
                        |> Tuple.first
                        |> Expect.equal (Model (Just (Layout.User "foobar")) "sometoken" (Just []))
                ]
            , describe "UpdateOAuthToken"
                [ test "updates username and resets token" <|
                    \() ->
                        update (Layout.UpdateOAuthToken "baz") (Model Nothing "" (Just []))
                        |> Tuple.first
                        |> Expect.equal (Model Nothing "baz" (Just []))
                ]
            , describe "Logout"
                [ test "resets the model" <|
                    \() ->
                        update Layout.Logout (Model (Just (Layout.User "")) "some token" (Just []))
                        |> Tuple.first
                        |> Expect.equal (Model Nothing "" Nothing)
                ]
            , describe "UpdateRepositories"
                [ test "updates repositories on model" <|
                    \() ->
                        update (Layout.UpdateRepositories (Ok [])) (Model Nothing "" Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model Nothing "" (Just []))
                , test "does not change the repositories on error" <|
                    \() ->
                        update (Layout.UpdateRepositories (Err Http.Timeout)) (Model Nothing "" (Just [Layout.Repository "repo1"]))
                        |> Tuple.first
                        |> Expect.equal (Model Nothing "" (Just [Layout.Repository "repo1"]))
                ]
            ]
        ]