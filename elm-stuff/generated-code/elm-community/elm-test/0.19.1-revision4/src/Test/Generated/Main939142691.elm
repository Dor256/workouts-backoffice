module Test.Generated.Main939142691 exposing (main)

import MainTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "MainTest" [MainTest.buttonPress,
    MainTest.inputType] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 209729176460073, processes = 12, globs = [], paths = ["/Users/dor/Workspace/workouts-backoffice/tests/MainTest.elm"]}