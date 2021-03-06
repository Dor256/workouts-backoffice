module Test.Generated.Main4286130248 exposing (main)

import MainSpec

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "MainSpec" [MainSpec.inputType,
    MainSpec.loaderTest,
    MainSpec.workoutListTest] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 348866247386282, processes = 12, globs = [], paths = ["/Users/dor/Workspace/workouts-backoffice/tests/MainSpec.elm"]}