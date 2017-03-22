module Layout exposing (..)

import Json.Decode as Decode
import Html exposing (Html, a, button, div, h2, input, li, span, text, ul)
import Html.Attributes exposing (attribute, href)
import Html.Events exposing (onClick, onInput)
import Http


-- MODEL

type alias User =
    { username: String
    }

type alias Repository = String

type alias Model =
    { authenticatedUser: Maybe User
    , oauthToken: String
    , repositories: Maybe (List Repository)
    }



-- MESSAGES

type Msg
    = AttemptLogin
    | UpdateOAuthToken String
    | UpdateAuthenticatedUser (Result Http.Error String)
    | UpdateRepositories (Result Http.Error (List Repository))
    | Logout



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
            let
                repositories = case model.repositories of
                    Nothing ->
                        text ""
                    Just repositories ->
                        repositories
                        |> List.map (\(repository) -> li [] [text repository])
                        |> ul []
            in
                div []
                    [ span [] [ text user.username ]
                    , text " "
                    , a [ href "#", onClick Logout ] [ text "logout" ]
                    , h2 [] [ text "Repositories" ]
                    , repositories
                    ]



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
            ( { model | authenticatedUser = Just (User authenticatedUser) }, fetchRepositories model )
        Logout ->
            ( { model | authenticatedUser = Nothing, oauthToken = "", repositories = Nothing }, Cmd.none )
        UpdateRepositories (Ok repositories) ->
            ( { model | repositories = Just repositories }, Cmd.none )
        UpdateRepositories (Err _) ->
            ( model, Cmd.none )

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

fetchRepositories : Model -> Cmd Msg
fetchRepositories model =
    let
        request = Http.request
            { method = "GET"
            , headers = [ Http.header "Authorization" ("token " ++ model.oauthToken) ]
            , url = "https://api.github.com/user/repos?affiliation=owner&sort=pushed"
            , body = Http.emptyBody
            , expect = Http.expectJson decodeRepositories
            , timeout = Nothing
            , withCredentials = False
            }
    in
        Http.send UpdateRepositories request

decodeRepositories : Decode.Decoder (List Repository)
decodeRepositories =
    Decode.list
        <| Decode.at ["full_name"] Decode.string

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none