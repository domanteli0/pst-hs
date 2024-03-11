{-# LANGUAGE QuasiQuotes #-}
module FindButton(with, find, FindButtonLocator(..)) where

import Test.WebDriver hiding (tagName)
import Test.WebDriver.Class
import Data.String.Interpolate ( __i, i )
import Data.Maybe as M
import qualified Data.Text as T
import GHC.Stack.Types

data Option a = None | Some a

instance (Show a) => Show (Option a) where
  show None = ""
  show (Some a) = show a

fromMaybe_ :: Maybe a -> Option a
fromMaybe_ Nothing  = None
fromMaybe_ (Just a) = Some a

data FindButtonLocator = FindButtonLocator {
    tagName_   :: String
  , attribute  :: Maybe (String, String)
  , label      :: Maybe String
  }

with :: FindButtonLocator
with = FindButtonLocator {
    tagName_  = "button"
  , attribute = Nothing
  , label     = Nothing
  }
find :: (GHC.Stack.Types.HasCallStack, Test.WebDriver.Class.WebDriver wd) =>
  FindButtonLocator ->
  wd Element
find = findElem . toSelector

toSelector :: FindButtonLocator -> Selector
toSelector FindButtonLocator {
    tagName_  = tagName
  , attribute = maybeAttr
  , label     = maybeLabel
  } = ByXPath final
  where
    base :: T.Text
    base = [__i|//#{tagName}|]

    fromMaybe_ :: Maybe (String, String) -> String
    fromMaybe_ = maybe "" (\(key, value) -> [i|[./@#{key} = "#{value}"]|])
    
    fromMaybe__ :: Maybe String -> String
    fromMaybe__ = maybe "" (\label_ -> [i|[contains(.,'#{label_}')]|])

    final :: T.Text
    final = [i|#{base}#{fromMaybe__ maybeLabel}#{fromMaybe_ maybeAttr}|]

    --         By.XPath(
                -- $"//{withTagName}{((withLabel is null) ? "" : $"[contains(.,'{withLabel}')]")}{((withId is null) ? "" : $"[./@id = \"{withId}\"]")}{((withValue is null) ? "" : $"[./@value = \"{withValue}\"]")}{((withName is null) ? "" : $"[./@name = \"{withName}\"]")}{((withAttribute is null) ? "" : $"[./@{withAttribute.Value.Item1} = \"{withAttribute.Value.Item2}\"]")}");