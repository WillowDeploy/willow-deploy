module View exposing (view)

import Html exposing (Html, a, button, div, h2, h3, input, label, span, text)
import Html.Attributes exposing (attribute, class, href, target)
import Html.Events exposing (onClick, onInput)

import Model exposing (..)
import Message exposing (..)


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
    let
        links = case authenticatedUser of
            Nothing ->
                text ""
            Just user ->
                div [ class "links" ]
                    [ span [ class "current-username" ] [ text user.username ]
                    , a [ class "logout-link", href "#", onClick Logout ] [ text "logout" ]
                    ]
    in
        div [ class "navigation" ]
            [ div [ class "navigation-bar" ]
                [ h2 [ class "brand" ] [ text "Willow Deploy" ]
                , links
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
        [ a [ class "name", href release.url, target "_blank" ] [ text release.name ]
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

