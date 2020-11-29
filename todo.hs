module Todo where
import Data.List
import System.IO
import System.Directory

view :: [String] -> IO ()
view [filename] = do
    xs <- fmap lines $ readFile filename
    let x = zip [1..] xs
    mapM (\(z,y) -> putStrLn ((show z) ++ " - " ++ y)) x
    return ()

add :: [String] -> IO()
add [filename, text] = do
    todoHandle <- openFile filename ReadWriteMode
    todoContents <- hGetContents todoHandle
    (tempName, tempHandle) <- openTempFile "." "temp"
    let todoLines = text:(lines todoContents) in
        hPutStr tempHandle (unlines todoLines)
    hClose todoHandle
    hClose tempHandle
    removeFile filename
    renameFile tempName filename
    return ()

remove :: [String] -> IO()
remove [filename, itemId] = do
    (tempName, tempHandle) <- openTempFile "." "temp"
    todoHandle <- openFile filename ReadMode
    todoContents <- hGetContents todoHandle
    let tempLines = lines todoContents
    let newTemp = delete (tempLines !! ((read itemId) - 1)) tempLines
    hPutStr tempHandle (unlines newTemp)
    hClose tempHandle
    removeFile filename
    renameFile tempName filename
    return ()