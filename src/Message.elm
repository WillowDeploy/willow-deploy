module Message exposing (..)

import Http
import RemoteData exposing (WebData)

import Model exposing (Releases, Repositories, Repository)


type Msg
    = AttemptLogin
    | UpdateOAuthToken String
    | UpdateAuthenticatedUser (Result Http.Error String)
    | UpdateRepositories (WebData Repositories)
    | ChooseRepository Repository
    | ClearChosenRepository
    | UpdateReleases (Result Http.Error Releases)
    | Logout
