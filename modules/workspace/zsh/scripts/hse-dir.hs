import Data.Time
import Data.List

currentHseDirectory year 7 day = ""
currentHseDirectory year 8 day = ""
currentHseDirectory year month day =
    let formatDir (course, mod) = "course" ++ show course ++ "/mod" ++ show mod
        yearEntered = 2020
        dYear = year - yearEntered
    in case (findIndex ((month, day) <=) [(4, 4), (6, 30), (10, 25), (12, 31)]) of
        Just x -> formatDir $ case x of
            0 -> (dYear, 3)
            1 -> (dYear, 4)
            2 -> (dYear + 1, 1)
            3 -> (dYear + 1, 2)
        Nothing -> ""

main :: IO ()
main = do
    c <- getCurrentTime              
    let (year, month, day) = toGregorian $ utctDay c
    putStrLn $ currentHseDirectory year month day
