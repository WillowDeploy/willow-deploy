module Layout exposing (..)

import Json.Decode as Decode
import Json.Decode.Extra exposing ((|:))
import Html exposing (Html, a, button, div, h2, h3, input, label, span, text)
import Html.Attributes exposing (attribute, class, href)
import Html.Events exposing (onClick, onInput)
import Http


-- MODEL

type alias User =
    { username: String
    }

type alias Repository =
    { fullName: String
    , name: String
    , ownerLogin: String
    }

type alias Repositories = List Repository

type alias Release =
    { name: String
    , draft: Bool
    , prerelease: Bool
    }

type alias Releases = List Release

type alias Model =
    { githubBaseUrl: String
    , authenticatedUser: Maybe User
    , oauthToken: String
    , repositories: Maybe Repositories
    , repository: Maybe Repository
    , releases: Maybe Releases
    }



-- MESSAGES

type Msg
    = AttemptLogin
    | UpdateOAuthToken String
    | UpdateAuthenticatedUser (Result Http.Error String)
    | UpdateRepositories (Result Http.Error Repositories)
    | ChooseRepository Repository
    | UpdateReleases (Result Http.Error Releases)
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
                        viewRepositoryPage model.repository model.releases
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
                [ h2 [ class "brand" ] [ text "Willow Deploy" ]
                ]
        Just user ->
            div [ class "navigation" ]
                [ h2 [ class "brand" ] [ text "Willow Deploy" ]
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
                [ h2 [ class "heading" ] [ text "Repositories" ]
                ]
        Just repositories ->
            div [ class "repositories-page" ]
                [ h2 [ class "heading" ] [ text "Repositories" ]
                , repositories
                    |> List.map (\(repo) -> div [ class "repository", onClick (ChooseRepository repo)] [ text repo.fullName ])
                    |> div [ class "repositories" ]
                ]

viewRepositoryPage : Maybe Repository -> Maybe Releases -> Html Msg
viewRepositoryPage repository releases =
    let
        heading = case repository of
            Nothing ->
                text "Repository"
            Just repo ->
                text ("Repository " ++ repo.fullName)
    in
        div [ class "repository-page" ]
            [ h2 [ class "heading" ] [ heading ]
            , viewReleaseBoard releases
            ]

viewReleaseBoard : Maybe Releases -> Html Msg
viewReleaseBoard releases =
    case releases of
        Nothing ->
            div [ class "release-board" ] []
        Just releases ->
            div [ class "release-board" ]
                [ viewDraftReleases releases
                , viewPreReleaseReleases releases
                , viewReleaseReleases releases
                ]

viewDraftReleases : Releases -> Html Msg
viewDraftReleases releases =
    releases
    |> List.filter isDraft
    |> List.map viewRelease
    |> List.append [ h3 [ class "sub-heading" ] [ text "Drafts" ] ]
    |> div [ class "drafts" ]

viewPreReleaseReleases : Releases -> Html Msg
viewPreReleaseReleases releases =
    releases
    |> List.filter isPreRelease
    |> List.map viewRelease
    |> List.append [ h3 [ class "sub-heading" ] [ text "Pre-releases" ] ]
    |> div [ class "pre-releases" ]

viewReleaseReleases : Releases -> Html Msg
viewReleaseReleases releases =
    releases
    |> List.filter isRelease
    |> List.map viewRelease
    |> List.append [ h3 [ class "sub-heading" ] [ text "Releases" ] ]
    |> div [ class "releases" ]

viewRelease : Release -> Html Msg
viewRelease release =
    div [ class "release" ]
        [ text release.name
        ]

isDraft : Release -> Bool
isDraft release = release.draft

isPreRelease : Release -> Bool
isPreRelease release = not release.draft && release.prerelease

isRelease : Release -> Bool
isRelease release = not release.draft && not release.prerelease

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
            ( { model | repository = Just repository }, fetchReleases model.githubBaseUrl model.oauthToken repository )
        UpdateReleases (Ok releases) ->
            ( { model | releases = Just releases }, Cmd.none )
        UpdateReleases (Err _) ->
            ( model, Cmd.none )

fetchAuthenticatedUser : Model -> Cmd Msg
fetchAuthenticatedUser model =
    githubRequest model.githubBaseUrl "/user" model.oauthToken decodeUsername
        |> Http.send UpdateAuthenticatedUser

decodeUsername : Decode.Decoder String
decodeUsername =
    Decode.at ["login"] Decode.string

fetchRepositories : Model -> Cmd Msg
fetchRepositories model =
    githubRequest model.githubBaseUrl "/user/repos?affiliation=owner&sort=pushed" model.oauthToken decodeRepositories
        |> Http.send UpdateRepositories

decodeRepositories : Decode.Decoder Repositories
decodeRepositories =
    Decode.list decodeRepository

decodeRepository : Decode.Decoder Repository
decodeRepository =
    Decode.succeed Repository
        |: (Decode.field "full_name" Decode.string)
        |: (Decode.field "name" Decode.string)
        |: (Decode.at [ "owner", "login" ] Decode.string)

fetchReleases : String -> String -> Repository -> Cmd Msg
fetchReleases githubBaseUrl oauthToken repo =
    githubRequest githubBaseUrl ("/repos/" ++ repo.ownerLogin ++ "/" ++ repo.name ++ "/releases") oauthToken decodeReleases
        |> Http.send UpdateReleases

decodeReleases : Decode.Decoder Releases
decodeReleases =
    Decode.list decodeRelease

decodeRelease : Decode.Decoder Release
decodeRelease =
    Decode.succeed Release
        |: (Decode.field "name" Decode.string)
        |: (Decode.field "draft" Decode.bool)
        |: (Decode.field "prerelease" Decode.bool)


githubRequest : String -> String -> String -> Decode.Decoder a -> Http.Request a
githubRequest baseUrl url token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("token " ++ token) ]
        , url = baseUrl ++ url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none