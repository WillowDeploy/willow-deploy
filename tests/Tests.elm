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
                        view (Model Nothing "")
                        |> Query.fromHtml
                        |> Query.find [ tag "input" ]
                        |> Query.has [ attribute "placeholder" "OAuth token..." ]
                , test "Shows a login button" <|
                    \() ->
                        view (Model Nothing "")
                        |> Query.fromHtml
                        |> Query.find [ tag "button" ]
                        |> Query.has [ text "Login" ]
                , test "Does not show current user name" <|
                    \() ->
                        view (Model Nothing "")
                        |> Query.fromHtml
                        |> Query.findAll [ tag "span" ]
                        |> Query.count (Expect.equal 0)
                , test "Does not show logout link" <|
                    \() ->
                        view (Model Nothing "")
                        |> Query.fromHtml
                        |> Query.findAll [ tag "a" ]
                        |> Query.count (Expect.equal 0)
                ]
            , describe "authenticated"
                [ test "Does not show a token input" <|
                    \() ->
                        view (Model (Just (Layout.User "foo")) "")
                        |> Query.fromHtml
                        |> Query.findAll [ tag "input" ]
                        |> Query.count (Expect.equal 0)
                , test "Does not show a login button" <|
                    \() ->
                        view (Model (Just (Layout.User "foo")) "")
                        |> Query.fromHtml
                        |> Query.findAll [ tag "button" ]
                        |> Query.count (Expect.equal 0)
                , test "Shows current user name" <|
                    \() ->
                        view (Model (Just (Layout.User "foo")) "")
                        |> Query.fromHtml
                        |> Query.find [ tag "span" ]
                        |> Query.has [ text "foo" ]
                , test "Shows a logout link" <|
                    \() ->
                        view (Model (Just (Layout.User "")) "")
                        |> Query.fromHtml
                        |> Query.find [ tag "a" ]
                        |> Query.has [ attribute "href" "#", text "logout" ]

                ]
            ]
        , describe "update"
            [ describe "AttemptLogin"
                [ test "does not change the model" <|
                    \() ->
                        update Layout.AttemptLogin (Model Nothing "")
                        |> Tuple.first
                        |> Expect.equal (Model Nothing "")

                ]
            , describe "UpdateAuthenticatedUser"
                [ test "does not change the model on error" <|
                    \() ->
                        update (Layout.UpdateAuthenticatedUser (Err Http.Timeout)) (Model Nothing "")
                        |> Tuple.first
                        |> Expect.equal (Model Nothing "")
                , test "changes the model on success" <|
                    \() ->
                        update (Layout.UpdateAuthenticatedUser (Ok "foobar")) (Model Nothing "sometoken")
                        |> Tuple.first
                        |> Expect.equal (Model (Just (Layout.User "foobar")) "sometoken")
                ]
            , describe "UpdateOAuthToken"
                [ test "updates username and resets token" <|
                    \() ->
                        update (Layout.UpdateOAuthToken "baz") (Model Nothing "")
                        |> Tuple.first
                        |> Expect.equal (Model Nothing "baz")
                ]
            , describe "Logout"
                [ test "resets the authenticated user" <|
                    \() ->
                        update Layout.Logout (Model (Just (Layout.User "")) "some token")
                        |> Tuple.first
                        |> Expect.equal (Model Nothing "")
                ]
            ]
        ]