module Model exposing (..)

import Date exposing (Date)
import RemoteData exposing (RemoteData, WebData)


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
    , url: String
    , tag: String
    , createdOn: Date
    }

type alias Releases = List Release

type alias Model =
    { githubBaseUrl: String
    , authenticatedUser: WebData User
    , oauthToken: String
    , repositories: WebData Repositories
    , repository: Maybe Repository
    , releases: WebData Releases
    }


isDraft : Release -> Bool
isDraft release = release.draft

isPreRelease : Release -> Bool
isPreRelease release = not release.draft && release.prerelease

isRelease : Release -> Bool
isRelease release = not release.draft && not release.prerelease
