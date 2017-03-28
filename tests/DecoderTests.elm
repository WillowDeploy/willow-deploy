module DecoderTests exposing (tests)

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
                    "{\"name\": \"foobar\", \"draft\": true, \"prerelease\": false}"
                    |> decodeString decodeRelease
                    |> Expect.equal (Ok (Release "foobar" True False))
            ]
        ]
