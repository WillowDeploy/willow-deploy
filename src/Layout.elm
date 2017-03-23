module Layout exposing (..)

import Json.Decode as Decode
import Json.Decode.Extra exposing ((|:))
import Html exposing (Html, a, button, div, h2, input, li, span, text, ul)
import Html.Attributes exposing (attribute, href)
import Html.Events exposing (onClick, onInput)
import Http


-- MODEL

type alias User =
    { username: String
    }

type alias Repository =
    { fullName: String
    }

type alias Repositories = List Repository

type alias Model =
    { authenticatedUser: Maybe User
    , oauthToken: String
    , repositories: Maybe Repositories
    }



-- MESSAGES

type Msg
    = AttemptLogin
    | UpdateOAuthToken String
    | UpdateAuthenticatedUser (Result Http.Error String)
    | UpdateRepositories (Result Http.Error Repositories)
    | Logout



-- VIEW


view : Model -> Html Msg
view model =
    let
        page = case model.authenticatedUser of
            Nothing ->
                viewLoginPage
            Just _ ->
                viewRepositoriesPage model.repositories
    in
        div []
            [ viewNavigation model.authenticatedUser
            , page
            ]

viewNavigation : Maybe User -> Html Msg
viewNavigation authenticatedUser =
    case authenticatedUser of
        Nothing ->
            div [] []
        Just user ->
            div []
                [ span [] [ text user.username ]
                , text " "
                , a [ href "#", onClick Logout ] [ text "logout" ]
                ]

viewRepositoriesPage : Maybe Repositories -> Html Msg
viewRepositoriesPage repositories =
    case repositories of
        Nothing ->
            div [] [ h2 [] [ text "Repositories" ] ]
        Just repositories ->
            div []
                [ h2 [] [ text "Repositories" ]
                , repositories
                    |> List.map (\(repository) -> li [] [text repository.fullName])
                    |> ul []
                ]

viewLoginPage : Html Msg
viewLoginPage =
    div []
        [ input [ attribute "placeholder" "OAuth token...", onInput UpdateOAuthToken ] []
        , button [ onClick AttemptLogin ] [ text "Login" ]
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
    githubRequest "/user" model.oauthToken decodeUsername
        |> Http.send UpdateAuthenticatedUser

decodeUsername : Decode.Decoder String
decodeUsername =
    Decode.at ["login"] Decode.string

fetchRepositories : Model -> Cmd Msg
fetchRepositories model =
    githubRequest "/user/repos?affiliation=owner&sort=pushed" model.oauthToken decodeRepositories
        |> Http.send UpdateRepositories

decodeRepositories : Decode.Decoder Repositories
decodeRepositories =
    Decode.list decodeRepository

decodeRepository : Decode.Decoder Repository
decodeRepository =
    Decode.succeed Repository
        |: (Decode.field "full_name" Decode.string)

githubRequest : String -> String -> Decode.Decoder a -> Http.Request a
githubRequest url token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("token " ++ token) ]
        , url = "https://api.github.com" ++ url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none