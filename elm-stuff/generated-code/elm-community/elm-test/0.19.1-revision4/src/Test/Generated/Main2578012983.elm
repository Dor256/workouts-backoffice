module Test.Generated.Main2578012983 exposing (main)

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
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 349720266652439, processes = 12, globs = [], paths = ["/Users/dor/Workspace/workouts-backoffice/tests/HomeSpec.elm"]}