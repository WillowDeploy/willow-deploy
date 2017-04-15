module Message exposing (..)

import Http
import RemoteData exposing (WebData)

import Model exposing (Releases, Repositories, Repository, User)


type Msg
    = AttemptLogin
    | UpdateOAuthToken String
    | UpdateAuthenticatedUser (WebData User)
    | UpdateRepositories (WebData Repositories)
    | ChooseRepository Repository
    | ClearChosenRepository
    | UpdateReleases (WebData Releases)
    | Logout
