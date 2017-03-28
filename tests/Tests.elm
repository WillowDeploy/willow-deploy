module Tests exposing (all)

import Test exposing (..)

import DecoderTests
import ModelTests
import UpdateTests


all : Test
all =
    describe "Willow Deploy front end"
        [ UpdateTests.tests
        , ModelTests.tests
        , DecoderTests.tests
        ]
