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
                        let
                            html = view (Model Nothing "")
                        in
                            Query.fromHtml html
                            |> Query.find [ tag "input" ]
                            |> Query.has [ attribute "placeholder" "OAuth token..." ]
                , test "Shows a login button" <|
                    \() ->
                        let
                            html = view (Model Nothing "")
                        in
                            Query.fromHtml html
                            |> Query.find [ tag "button" ]
                            |> Query.has [ text "Login" ]
                , test "Does not show current user name" <|
                    \() ->
                        let
                            html = view (Model Nothing "")
                        in
                            Query.fromHtml html
                            |> Query.findAll [ tag "span" ]
                            |> Query.count (Expect.equal 0)
                ]
            , describe "authenticated"
                [ test "Does not show a token input" <|
                    \() ->
                        let
                            html = view (Model (Just (Layout.User "foo")) "")
                        in
                            Query.fromHtml html
                            |> Query.findAll [ tag "input" ]
                            |> Query.count (Expect.equal 0)
                , test "Does not show a login button" <|
                    \() ->
                        let
                            html = view (Model (Just (Layout.User "foo")) "")
                        in
                            Query.fromHtml html
                            |> Query.findAll [ tag "button" ]
                            |> Query.count (Expect.equal 0)
                , test "Shows current user name" <|
                    \() ->
                        let
                            html = view (Model (Just (Layout.User "foo")) "")
                        in
                            Query.fromHtml html
                            |> Query.find [ tag "span" ]
                            |> Query.has [ text "foo" ]
                ]
            ]
        , describe "update"
            [ describe "AttemptLogin"
                [ test "does not change the model" <|
                    \() ->
                        let
                            result = update Layout.AttemptLogin (Model Nothing "")
                        in
                            result
                                |> Tuple.first
                                |> Expect.equal (Model Nothing "")

                ]
            , describe "UpdateAuthenticatedUser"
                [ test "does not change the model on error" <|
                    \() ->
                        let
                            result = update (Layout.UpdateAuthenticatedUser (Err Http.Timeout)) (Model Nothing "")
                        in
                            result
                                |> Tuple.first
                                |> Expect.equal (Model Nothing "")
                , test "changes the model on success" <|
                    \() ->
                        let
                            result = update (Layout.UpdateAuthenticatedUser (Ok "foobar")) (Model Nothing "sometoken")
                        in
                            result
                                |> Tuple.first
                                |> Expect.equal (Model (Just (Layout.User "foobar")) "")
                ]
            , describe "UpdateOAuthToken"
                [ test "updates username and resets token" <|
                    \() ->
                        let
                            result = update (Layout.UpdateOAuthToken "baz") (Model Nothing "")
                        in
                            result
                                |> Tuple.first
                                |> Expect.equal (Model Nothing "baz")
                ]
            ]
        ]