module HomeSpec exposing (..)

import Expect exposing (Expectation)
import Html.Events exposing (keyCode)
import Json.Encode as Encode exposing (Value)
import Page.Home exposing (..)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


simulatedEvent : Value
simulatedEvent =
    Encode.object [ ( "keyCode", Encode.int 13 ) ]


loaderTest : Test
loaderTest =
    describe "Loader"
        [ test "Shows loader when no data is available" <|
            \() ->
                view { search = "", workouts = Nothing }
                    |> Query.fromHtml
                    |> Query.has [ Selector.class "loader" ]
        , test "Does not show loader when data is available" <|
            \() ->
                view { search = "", workouts = Just [ { name = "mockWorkout" } ] }
                    |> Query.fromHtml
                    |> Query.hasNot [ Selector.class "loader" ]
        ]


workoutListTest : Test
workoutListTest =
    describe "Workout list"
        [ test "Shows workout list when data is available" <|
            \() ->
                view { search = "", workouts = Just [ { name = "mockWorkout" } ] }
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "card" ]
                    |> Query.has [ Selector.text "mockWorkout" ]
        ]


inputTest : Test
inputTest =
    describe "Input"
        [ test "Controls type input" <|
            \() ->
                view { search = "", workouts = Just [ { name = "mockWorkout" } ] }
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "searchbar" ]
                    |> Event.simulate (Event.input "text")
                    |> Event.expect (OnChange "text")
        ]


addWorkoutTest : Test
addWorkoutTest =
    describe "Add workout"
        [ test "Adds workout" <|
            \() ->
                view { search = "mockWorkout", workouts = Just [ { name = "workout" } ] }
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "searchbar" ]
                    |> Event.simulate (Event.custom "keypress" simulatedEvent)
                    |> Event.expect (OnSubmit enterKey)
        ]
