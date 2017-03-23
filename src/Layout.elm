module Layout exposing (..)

import Json.Decode as Decode
import Json.Decode.Extra exposing ((|:))
import Html exposing (Html, a, button, div, h2, input, label, span, text)
import Html.Attributes exposing (attribute, class, href)
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
    , repository: Maybe Repository
    }



-- MESSAGES

type Msg
    = AttemptLogin
    | UpdateOAuthToken String
    | UpdateAuthenticatedUser (Result Http.Error String)
    | UpdateRepositories (Result Http.Error Repositories)
    | ChooseRepository Repository
    | Logout



-- VIEW


view : Model -> Html Msg
view model =
    let
        page = case model.authenticatedUser of
            Nothing ->
                viewLoginPage
            Just _ ->
                case model.repository of
                    Nothing ->
                        viewRepositoriesPage model.repositories
                    Just _ ->
                        viewRepositoryPage model.repository
    in
        div []
            [ viewNavigation model.authenticatedUser
            , page
            ]

viewNavigation : Maybe User -> Html Msg
viewNavigation authenticatedUser =
    case authenticatedUser of
        Nothing ->
            div [ class "navigation" ]
                [ h2 [ class "brand" ] [ text "The Deploy Button" ]
                ]
        Just user ->
            div [ class "navigation" ]
                [ h2 [ class "brand" ] [ text "The Deploy Button" ]
                , div [ class "links" ]
                    [ span [ class "current-username" ] [ text user.username ]
                    , a [ class "logout-link", href "#", onClick Logout ] [ text "logout" ]
                    ]
                ]

viewRepositoriesPage : Maybe Repositories -> Html Msg
viewRepositoriesPage repositories =
    case repositories of
        Nothing ->
            div [ class "repositories-page" ]
                [ h2 [] [ text "Repositories" ]
                ]
        Just repositories ->
            div [ class "repositories-page" ]
                [ h2 [] [ text "Repositories" ]
                , repositories
                    |> List.map (\(repo) -> div [ class "repository", onClick (ChooseRepository repo)] [ text repo.fullName ])
                    |> div [ class "repositories" ]
                ]

viewRepositoryPage : Maybe Repository -> Html Msg
viewRepositoryPage repository =
    let
        heading = case repository of
            Nothing ->
                text "Repository"
            Just repo ->
                text ("Repository " ++ repo.fullName)
    in
        div [ class "repository-page" ]
            [ h2 [] [ heading ]
            ]


viewLoginPage : Html Msg
viewLoginPage =
    div [ class "login-page" ]
        [ div [ class "login-form" ]
            [ label [] [ text "Personal Access Token" ]
            , input [ attribute "placeholder" "Token", onInput UpdateOAuthToken ] []
            , div [ class "buttons" ]
                [ button [ onClick AttemptLogin ] [ text "Login" ]
                ]
            ]
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
        ChooseRepository repository ->
            ( { model | repository = Just repository }, Cmd.none )

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