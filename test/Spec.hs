{-# LANGUAGE OverloadedStrings #-}

import Test.WebDriver
import System.Process as P

config :: WDConfig
config = useBrowser chrome $ defaultConfig { wdHost = "localhost" }

-- you need to download selenium-server first:
-- https://github.com/SeleniumHQ/selenium/releases/download/selenium-2.53.1/selenium-server-standalone-2.53.1.jar
main :: IO ()
main = do
  seleniumHandle <- P.spawnProcess "java" ["-jar", "selenium-server-standalone-2.53.1.jar"]
  _ <- callCommand "sleep 1.5"
  
  runSession config $ do
    openPage "http://google.com"
    closeSession

  P.terminateProcess seleniumHandle
