module MainTest exposing (..)

import Expect exposing (Expectation)
import Main exposing (..)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Main exposing (Action(..))


buttonPress : Test
buttonPress =
    describe "Button"
        [ test "Presses" <|
            \() ->
                view { title = "Title", search = "", workouts = [] }
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "button" ]
                    |> Event.simulate Event.click
                    |> Event.expect (OnChange "Shmup")
        ]


inputType : Test
inputType =
    describe "Input"
        [ test "Controls type input" <|
            \() ->
                view { title = "Title", search = "", workouts = [] }
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "searchbar" ]
                    |> Event.simulate (Event.input "text")
                    |> Event.expect (OnChange "text")
        ]
