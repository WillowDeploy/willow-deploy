module ModelTests exposing (tests)

import Date exposing (Date, Month(..))
import Date.Extra exposing (fromParts)
import Expect
import Test exposing (..)

import Model exposing (Release, isDraft, isPreRelease, isRelease)


someDate : Date
someDate = fromParts 2017 Mar 29 11 15 0 0

tests : Test
tests =
    describe "model"
        [ describe "isDraft"
            [ test "when 'draft' is True" <|
                \() ->
                    Release "" True False "" "" someDate
                    |> isDraft
                    |> Expect.equal True
            , test "when 'draft' is False" <|
                \() ->
                    Release "" False False "" "" someDate
                    |> isDraft
                    |> Expect.equal False
            ]
        , describe "isPreRelease"
            [ test "when 'draft' is True" <|
                \() ->
                    Release "" True False "" "" someDate
                    |> isPreRelease
                    |> Expect.equal False
            , test "when 'draft' is False and 'prerelease' is False" <|
                \() ->
                    Release "" False False "" "" someDate
                    |> isPreRelease
                    |> Expect.equal False
            , test "when 'draft' is False and 'prerelease' is True" <|
                \() ->
                    Release "" False True "" "" someDate
                    |> isPreRelease
                    |> Expect.equal True
            ]
        , describe "isRelease"
            [ test "when 'draft' is True" <|
                \() ->
                    Release "" True False "" "" someDate
                    |> isRelease
                    |> Expect.equal False
            , test "when 'draft' is False and 'prerelease' is True" <|
                \() ->
                    Release "" False True "" "" someDate
                    |> isRelease
                    |> Expect.equal False
            , test "when 'draft' is False and 'prerelease' is False" <|
                \() ->
                    Release "" False False "" "" someDate
                    |> isRelease
                    |> Expect.equal True
            ]
        ]
