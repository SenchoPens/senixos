import System.Exit

main :: IO ()
main = do
  freeMemory <- read
                <$> (!!1) <$> words
                <$> (!!2) <$> lines
                <$> readFile "/proc/meminfo"
  putStrLn $ (take 3 $ show $ freeMemory / (2 ^ 30)) ++ "Gb"
  exitWith $ if freeMemory > (2 ^ 30) then ExitSuccess else ExitFailure 33
