import Todo (add, view, remove)
import System.Environment

fromJust (Just x) = x

helpText :: [(String, String)]
helpText = [
             ("action", "Usage : main {action} {todo file} {arguments}\naction is either \"add\" , \"remove\" or \"view\"")
           , ("add", "add {todo file} {text} : Adds an item to the todo file")
           , ("remove", "remove {todo file} {id} : Removes an item by id from the todo file")
           , ("view", "view {todo file} : Show all todo items in the todo file")
           ]

help :: [String] -> IO ()
help [command] =
    putStrLn (fromJust $ lookup command helpText)

dispatch :: [(String, [String] -> IO ())]
dispatch = [ ("add", add)
           , ("view", view)
           , ("remove", remove)
           , ("--help", help)
           , ("-h", help)
           ]

main :: IO ()
main = do
    (command:args) <- getArgs
    case (command:args) of (command:[]) -> (help ["action"])
                           (_) -> (fromJust (lookup command dispatch)) $ args
    return ()