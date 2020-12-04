module Test.Generated.Main2544989680 exposing (main)

import MainSpec

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "MainSpec" [MainSpec.inputType,
    MainSpec.loaderTest] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 354071930925729, processes = 12, globs = [], paths = ["/Users/dor/Workspace/workouts-backoffice/tests/MainSpec.elm"]}