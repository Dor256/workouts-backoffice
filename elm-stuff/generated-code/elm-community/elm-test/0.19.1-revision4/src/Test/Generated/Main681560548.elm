module Test.Generated.Main681560548 exposing (main)

import MainSpec

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "MainSpec" [MainSpec.inputType] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 148584616200156, processes = 12, globs = [], paths = ["/Users/dor/Workspace/workouts-backoffice/tests/MainSpec.elm"]}