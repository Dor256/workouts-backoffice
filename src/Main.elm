module Main exposing (..)

import Browser exposing (Document, UrlRequest, application)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (Body)
import Page.Home as Home
import Page.Login as Login
import Route exposing (Route)
import Url exposing (Url)


main : Program () Model Msg
main =
    application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- Init


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }


type Page
    = NotFoundPage
    | LoginPage Login.Model
    | HomePage Home.Model


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = key
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, cmds ) =
    let
        ( currentPage, pageCmds ) =
            case model.route of
                Route.Login ->
                    let
                        ( loginModel, loginCmds ) =
                            Login.init model.navKey
                    in
                    ( LoginPage loginModel, Cmd.map LoginPageMsg loginCmds )

                Route.Home ->
                    let
                        ( homeModel, homeCmds ) =
                            Home.init
                    in
                    ( HomePage homeModel, Cmd.map HomePageMsg homeCmds )

                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ cmds, pageCmds ]
    )



-- Update


type Msg
    = HomePageMsg Home.Msg
    | LoginPageMsg Login.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( HomePageMsg homeMsg, HomePage homeModel ) ->
            let
                ( updatedHomeModel, updatedCmd ) =
                    Home.update homeMsg homeModel
            in
            ( { model | page = HomePage updatedHomeModel }
            , Cmd.map HomePageMsg updatedCmd
            )

        ( LoginPageMsg loginMsg, LoginPage loginModel ) ->
            let
                ( updatedLoginModel, updatedCmd ) =
                    Login.update loginMsg loginModel
            in
            ( { model | page = LoginPage updatedLoginModel }
            , Cmd.map LoginPageMsg updatedCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            ( { model | route = Route.parseUrl url }, Cmd.none )
                |> initCurrentPage

        ( _, _ ) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


view : Model -> Document Msg
view model =
    { title = "Workouts BO"
    , body = [ viewer model ]
    }


viewer : Model -> Html Msg
viewer model =
    case model.page of
        NotFoundPage ->
            div [] [ text "Oopsie looks like a 404!" ]

        LoginPage loginModel ->
            Login.view loginModel
                |> Html.map LoginPageMsg

        HomePage homeModel ->
            Home.view homeModel
                |> Html.map HomePageMsg
