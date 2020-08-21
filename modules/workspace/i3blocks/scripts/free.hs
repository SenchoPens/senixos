import System.Exit

main :: IO ()
main = do
  -- Read available memory in kB
  freeMemory <- read
                <$> (!!1) <$> words
                <$> (!!2) <$> lines
                <$> readFile "/proc/meminfo"
  putStrLn $ (take 5 $ show $ (freeMemory / (2 ^ 20))) ++ "Gb"
  exitWith $ if freeMemory > (2 ^ 20) then ExitSuccess else ExitFailure 33
