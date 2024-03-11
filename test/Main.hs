{-# LANGUAGE OverloadedStrings #-}

import FindButton
import Test.WebDriver
import System.Process as P
import Algebra.OccasionallyScalar
import Data.Bifunctor

todo = error "TODO"

config :: WDConfig
config = useBrowser chrome $ defaultConfig { wdHost = "localhost" }

-- you need to download java and selenium-server first:
-- https://github.com/SeleniumHQ/selenium/releases/download/selenium-2.53.1/selenium-server-standalone-2.53.1.jar
main :: IO ()
main = do
  -- seleniumHandle <- P.spawnProcess "java" ["-jar", "selenium-server-standalone-2.53.1.jar"]
  -- _ <- callCommand "sleep 1.5"
  
  runSession config $ do
    maximize

    -- 1. Atsidaryti https://demoqa.com/
    openPage "https://demoqa.com/"
    maximize
    setWindowPos (50, 50)
    -- moveTo (0, 1000)
    -- moveTo (1000, 0)
    -- moveTo (-1000, 0)

    -- 2. Pasirinkti "Widgets" kortelę
    -- el <- find $ with { tagName_ = "div", attribute = Just ("class", "card-body") }
    -- _ <- elemPos el >>= moveTo . bimap ((+500) . round) round
    -- click el

    closeSession

  -- P.terminateProcess seleniumHandle
