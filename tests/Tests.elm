module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import Json.Decode exposing (decodeString)
import String
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, attribute, class)
import Http exposing (get)

import Layout exposing (Model, decodeRelease, decodeRepository, view, update)


all : Test
all =
    describe "Willow Deploy front end"
        [ describe "update"
            [ describe "AttemptLogin"
                [ test "does not change the model" <|
                    \() ->
                        update Layout.AttemptLogin (Model "" Nothing "" (Just []) Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" (Just []) Nothing Nothing)

                ]
            , describe "UpdateAuthenticatedUser"
                [ test "does not change the model on error" <|
                    \() ->
                        update (Layout.UpdateAuthenticatedUser (Err Http.Timeout)) (Model "" Nothing "" (Just []) Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" (Just []) Nothing Nothing)
                , test "changes the model on success" <|
                    \() ->
                        update (Layout.UpdateAuthenticatedUser (Ok "foobar")) (Model "" Nothing "sometoken" (Just []) Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" (Just (Layout.User "foobar")) "sometoken" (Just []) Nothing Nothing)
                ]
            , describe "UpdateOAuthToken"
                [ test "updates username and resets token" <|
                    \() ->
                        update (Layout.UpdateOAuthToken "baz") (Model "" Nothing "" (Just []) Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "baz" (Just []) Nothing Nothing)
                ]
            , describe "Logout"
                [ test "resets the model" <|
                    \() ->
                        update Layout.Logout (Model "" (Just (Layout.User "")) "some token" (Just []) Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" Nothing Nothing Nothing)
                ]
            , describe "UpdateRepositories"
                [ test "updates repositories on model" <|
                    \() ->
                        update (Layout.UpdateRepositories (Ok [])) (Model "" Nothing "" Nothing Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" (Just []) Nothing Nothing)
                , test "does not change the repositories on error" <|
                    \() ->
                        update (Layout.UpdateRepositories (Err Http.Timeout)) (Model "" Nothing "" (Just [Layout.Repository "re/po1" "re" "po1"]) Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" (Just [Layout.Repository "re/po1" "re" "po1"]) Nothing Nothing)
                ]
            , describe "ChooseRepository"
                [ test "updates the current repository" <|
                    \() ->
                        update (Layout.ChooseRepository <| Layout.Repository "fo/o" "fo" "o") (Model "" Nothing "" Nothing Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" Nothing (Just <| Layout.Repository "fo/o" "fo" "o") Nothing)
                ]
            , describe "UpdateReleases"
                [ test "updates the releases on model" <|
                    \() ->
                        update (Layout.UpdateReleases (Ok [ Layout.Release "v1" True True ])) (Model "" Nothing "" Nothing Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" Nothing Nothing (Just [ Layout.Release "v1" True True ]))
                , test "does not update releases on error" <|
                    \() ->
                        update (Layout.UpdateReleases (Err Http.Timeout)) (Model "" Nothing "" Nothing Nothing Nothing)
                        |> Tuple.first
                        |> Expect.equal (Model "" Nothing "" Nothing Nothing Nothing)
                ]
            ]
        , describe "decodeRepository"
            [ test "all fields present" <|
                \() ->
                    "{\"full_name\": \"foo\", \"name\": \"bar\", \"owner\": {\"login\": \"baz\"}}"
                    |> decodeString decodeRepository
                    |> Expect.equal (Ok (Layout.Repository "foo" "bar" "baz"))
            ]
        , describe "decodeRelease"
            [ test "all fields present" <|
                \() ->
                    "{\"name\": \"foobar\", \"draft\": true, \"prerelease\": false}"
                    |> decodeString decodeRelease
                    |> Expect.equal (Ok (Layout.Release "foobar" True False))
            ]
        ]
