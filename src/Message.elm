module Message exposing (..)

import Http

import Model exposing (Releases, Repositories, Repository)


type Msg
    = AttemptLogin
    | UpdateOAuthToken String
    | UpdateAuthenticatedUser (Result Http.Error String)
    | UpdateRepositories (Result Http.Error Repositories)
    | ChooseRepository Repository
    | UpdateReleases (Result Http.Error Releases)
    | Logout
