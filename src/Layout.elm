module Layout exposing (..)

import Json.Decode as Decode
import Html exposing (Html, button, div, input, span, text)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick, onInput)
import Http


-- MODEL

type alias User =
    { username: String
    }

type alias Model =
    { authenticatedUser: Maybe User
    , oauthToken: String
    }



-- MESSAGES

type Msg
    = AttemptLogin
    | UpdateOAuthToken String
    | UpdateAuthenticatedUser (Result Http.Error String)



-- VIEW


view : Model -> Html Msg
view model =
    case model.authenticatedUser of
        Nothing ->
            div []
                [ input [ attribute "placeholder" "OAuth token...", onInput UpdateOAuthToken ] []
                , button [ onClick AttemptLogin ] [ text "Login" ]
                ]
        Just user ->
            div [] [ span [] [ text user.username ] ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AttemptLogin ->
            ( model, fetchAuthenticatedUser model )
        UpdateOAuthToken token ->
            ( { model | oauthToken = token }, Cmd.none )
        UpdateAuthenticatedUser (Err _) ->
            ( model, Cmd.none )
        UpdateAuthenticatedUser (Ok authenticatedUser) ->
            ( { model | authenticatedUser = Just (User authenticatedUser), oauthToken = "" }, Cmd.none )

fetchAuthenticatedUser : Model -> Cmd Msg
fetchAuthenticatedUser model =
    let
        request = Http.request
            { method = "GET"
            , headers = [ Http.header "Authorization" ("token " ++ model.oauthToken) ]
            , url = "https://api.github.com/user"
            , body = Http.emptyBody
            , expect = Http.expectJson decodeUsername
            , timeout = Nothing
            , withCredentials = False
            }
    in
        Http.send UpdateAuthenticatedUser request

decodeUsername : Decode.Decoder String
decodeUsername =
    Decode.at ["login"] Decode.string

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none