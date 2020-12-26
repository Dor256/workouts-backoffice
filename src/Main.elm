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
    = LoginPage
    | HomePage Home.Model


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        model =
            { route = Route.parseUrl url
            , page = LoginPage
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
                    ( LoginPage, Cmd.none )

                Route.Home ->
                    let
                        ( homeModel, homeCmds ) =
                            Home.init
                    in
                    ( HomePage homeModel, Cmd.map HomePageMsg homeCmds )
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

        ( LoginPageMsg loginMsg, _ ) ->
            ( { model | page = LoginPage }
            , Cmd.map LoginPageMsg (Login.onLogin loginMsg)
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
        LoginPage ->
            Login.view model.navKey
                |> Html.map LoginPageMsg

        HomePage homeModel ->
            Home.view homeModel
                |> Html.map HomePageMsg
