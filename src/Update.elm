module Update exposing (..)

import Json.Decode as Decode
import Json.Decode.Extra exposing ((|:), date)
import Http
import RemoteData exposing (sendRequest, RemoteData(..))

import Auth exposing (clearToken, storeToken)
import Message exposing (..)
import Model exposing (Model, User, Release, Releases, Repositories, Repository)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AttemptLogin ->
            ( { model | authenticatedUser = Loading }, fetchAuthenticatedUser model.githubBaseUrl model.oauthToken )
        UpdateOAuthToken token ->
            ( { model | oauthToken = token }, Cmd.none )
        UpdateAuthenticatedUser (Success authenticatedUser) ->
            ( { model | authenticatedUser = Success authenticatedUser, repositories = Loading }
            , Cmd.batch [ fetchRepositories model, storeToken model.oauthToken ]
            )
        UpdateAuthenticatedUser response ->
            ( { model | authenticatedUser = response }, Cmd.none )
        Logout ->
            ( { model | authenticatedUser = NotAsked, oauthToken = "", repositories = NotAsked }, clearToken () )
        UpdateRepositories response ->
            ( { model | repositories = response }, Cmd.none )
        ChooseRepository repository ->
            ( { model | repository = Just repository, releases = Loading }
            , fetchReleases model.githubBaseUrl model.oauthToken repository )
        ClearChosenRepository ->
            ( { model | repository = Nothing }, Cmd.none )
        UpdateReleases releases ->
            ( { model | releases = releases }, Cmd.none )

fetchAuthenticatedUser : String -> String -> Cmd Msg
fetchAuthenticatedUser githubBaseUrl oauthToken =
    githubRequest githubBaseUrl "/user" oauthToken decodeUsername
        |> RemoteData.sendRequest
        |> Cmd.map UpdateAuthenticatedUser

decodeUsername : Decode.Decoder User
decodeUsername =
    Decode.succeed User
        |: (Decode.field "login" Decode.string)

fetchRepositories : Model -> Cmd Msg
fetchRepositories model =
    githubRequest model.githubBaseUrl "/user/repos?affiliation=owner&sort=pushed" model.oauthToken decodeRepositories
        |> RemoteData.sendRequest
        |> Cmd.map UpdateRepositories

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
        |> RemoteData.sendRequest
        |> Cmd.map UpdateReleases

decodeReleases : Decode.Decoder Releases
decodeReleases =
    Decode.list decodeRelease

decodeRelease : Decode.Decoder Release
decodeRelease =
    Decode.succeed Release
        |: (Decode.field "name" Decode.string)
        |: (Decode.field "draft" Decode.bool)
        |: (Decode.field "prerelease" Decode.bool)
        |: (Decode.field "html_url" Decode.string)
        |: (Decode.field "tag_name" Decode.string)
        |: (Decode.field "created_at" date)


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
