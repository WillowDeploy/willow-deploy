module DecoderTests exposing (tests)

import Date exposing (Month(..))
import Date.Extra exposing (atTime, calendarDate, fromSpec, utc)
import Expect
import Json.Decode exposing (decodeString)
import Test exposing (..)

import Model exposing (Release, Repository)
import Update exposing (decodeRelease, decodeRepository)


tests : Test
tests =
    describe "decoders"
        [ describe "decodeRepository"
             [ test "all fields present" <|
                 \() ->
                     "{\"full_name\": \"foo\", \"name\": \"bar\", \"owner\": {\"login\": \"baz\"}}"
                     |> decodeString decodeRepository
                     |> Expect.equal (Ok (Repository "foo" "bar" "baz"))
             ]
        , describe "decodeRelease"
            [ test "all fields present" <|
                \() ->
                    let
                        date = fromSpec
                            utc
                            (atTime 21 1 46 0)
                            (calendarDate 2017 Mar 20)
                    in
                        "{\"name\": \"foobar\", \"draft\": true, \"prerelease\": false, \"html_url\": \"blah\", "
                        ++ "\"tag_name\": \"qux\", \"created_at\": \"2017-03-20T21:01:46Z\"}"
                        |> decodeString decodeRelease
                        |> Expect.equal (Ok (Release "foobar" True False "blah" "qux" date))
            ]
        ]
