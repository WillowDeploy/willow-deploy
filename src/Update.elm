module Update exposing (..)

import Json.Decode as Decode
import Json.Decode.Extra exposing ((|:))
import Http

import Message exposing (..)
import Model exposing (Model, User, Release, Releases, Repositories, Repository)


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