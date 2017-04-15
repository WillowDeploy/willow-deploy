module View exposing (view)

import Date exposing (Date)
import Date.Extra exposing (toUtcFormattedString)
import Html exposing (Html, a, button, div, dl, dd, h2, h3, input, label, span, text)
import Html.Attributes exposing (attribute, class, disabled, href, target)
import Html.Events exposing (onClick, onInput)
import RemoteData exposing (RemoteData(..), WebData)

import Model exposing (..)
import Message exposing (..)


view : Model -> Html Msg
view model =
    let
        page = case model.authenticatedUser of
            Success user ->
                case model.repository of
                    Nothing ->
                        viewRepositoriesPage model.repositories
                    Just _ ->
                        viewRepositoryPage model.repository model.releases
            _ ->
                viewLoginPage model.authenticatedUser
    in
        div []
            [ viewNavigation model.authenticatedUser
            , page
            ]

viewNavigation : WebData User -> Html Msg
viewNavigation authenticatedUser =
    let
        links = case authenticatedUser of
            Success user ->
                div [ class "links" ]
                    [ span [ class "current-username" ] [ text user.username ]
                    , a [ class "logout-link", href "#", onClick Logout ] [ text "logout" ]
                    ]
            _ ->
                text ""
    in
        div [ class "navigation" ]
            [ div [ class "navigation-bar" ]
                [ h2 [ class "brand" ] [ text "Willow Deploy" ]
                , links
                ]
            ]

viewRepositoriesPage : WebData Repositories -> Html Msg
viewRepositoriesPage repositories =
    case repositories of
        Loading ->
            div [ class "repositories-page" ]
                [ h2 [ class "heading" ] [ text "Repositories" ]
                , text "Loading..."
                ]
        Success repositories ->
            div [ class "repositories-page" ]
                [ h2 [ class "heading" ] [ text "Repositories" ]
                , repositories
                    |> List.map (\(repo) -> div [ class "repository", onClick (ChooseRepository repo)] [ text repo.fullName ])
                    |> div [ class "repositories" ]
                ]
        _ ->
            div [ class "repositories-page" ]
                [ h2 [ class "heading" ] [ text "Repositories" ]
                ]

viewRepositoryPage : Maybe Repository -> WebData Releases -> Html Msg
viewRepositoryPage repository releases =
    let
        heading = case repository of
            Nothing ->
                [ a [ onClick ClearChosenRepository, href "#" ] [ text "Repositories" ]
                ]
            Just repo ->
                [ a [ onClick ClearChosenRepository, href "#" ] [ text "Repositories" ]
                , text " / "
                , text repo.fullName
                ]
        content = case releases of
            Loading ->
                [ text "Loading... " ]
            Success releases ->
                [ viewReleaseBoard releases ]
            _ ->
                [ ]
    in
        div [ class "repository-page" ]
            (( h2 [ class "heading" ] heading ) :: content)

viewReleaseBoard : Releases -> Html Msg
viewReleaseBoard releases =
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

viewDate : Date -> String
viewDate date = toUtcFormattedString "yyyy-MM-ddTHH:mm:ssX" date

viewRelease : Release -> Html Msg
viewRelease release =
    div [ class "release" ]
        [ a [ class "name", href release.url, target "_blank" ] [ text release.name ]
        , dl [ class "details" ]
            [ dd [ class "created-on" ] [ text <| viewDate release.createdOn ]
            , dd [ class "tag" ] [ text release.tag ]
            ]
        ]

viewLoginPage : WebData User -> Html Msg
viewLoginPage user =
    let
        (loading, buttonText) = case user of
            Loading -> (True, "Authenticating...")
            _ -> (False, "Login")
    in
        div [ class "login-page" ]
            [ div [ class "login-form" ]
                [ label [] [ text "Personal Access Token" ]
                , input [ attribute "placeholder" "Token", onInput UpdateOAuthToken ] []
                , div [ class "buttons" ]
                    [ button [ onClick AttemptLogin, disabled loading ] [ text buttonText ]
                    ]
                ]
            ]
