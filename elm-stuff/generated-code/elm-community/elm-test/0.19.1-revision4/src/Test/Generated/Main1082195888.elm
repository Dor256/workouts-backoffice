module Test.Generated.Main1082195888 exposing (main)

import Main

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Main" [Main.initialTest] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 403752214274866, processes = 12, globs = [], paths = ["/Users/dor/Workspace/workouts-backoffice/tests/Main.elm"]}