module Test.Generated.Main3229344131 exposing (main)

import HomeSpec

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "HomeSpec" [HomeSpec.addWorkoutTest,
    HomeSpec.inputTest,
    HomeSpec.loaderTest,
    HomeSpec.workoutListTest] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 29521350632575, processes = 12, globs = [], paths = ["/Users/dor/Workspace/workouts-backoffice/tests/HomeSpec.elm"]}