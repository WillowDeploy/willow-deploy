module ModelTests exposing (tests)

import Expect
import Test exposing (..)

import Model exposing (Release, isDraft, isPreRelease, isRelease)


tests : Test
tests =
    describe "model"
        [ describe "isDraft"
            [ test "when 'draft' is True" <|
                \() ->
                    Release "" True False
                    |> isDraft
                    |> Expect.equal True
            , test "when 'draft' is False" <|
                \() ->
                    Release "" False False
                    |> isDraft
                    |> Expect.equal False
            ]
        , describe "isPreRelease"
            [ test "when 'draft' is True" <|
                \() ->
                    Release "" True False
                    |> isPreRelease
                    |> Expect.equal False
            , test "when 'draft' is False and 'prerelease' is False" <|
                \() ->
                    Release "" False False
                    |> isPreRelease
                    |> Expect.equal False
            , test "when 'draft' is False and 'prerelease' is True" <|
                \() ->
                    Release "" False True
                    |> isPreRelease
                    |> Expect.equal True
            ]
        , describe "isRelease"
            [ test "when 'draft' is True" <|
                \() ->
                    Release "" True False
                    |> isRelease
                    |> Expect.equal False
            , test "when 'draft' is False and 'prerelease' is True" <|
                \() ->
                    Release "" False True
                    |> isRelease
                    |> Expect.equal False
            , test "when 'draft' is False and 'prerelease' is False" <|
                \() ->
                    Release "" False False
                    |> isRelease
                    |> Expect.equal True
            ]
        ]
