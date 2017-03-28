module Model exposing (..)


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


isDraft : Release -> Bool
isDraft release = release.draft

isPreRelease : Release -> Bool
isPreRelease release = not release.draft && release.prerelease

isRelease : Release -> Bool
isRelease release = not release.draft && not release.prerelease
