{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson
import Control.Applicative
import Control.Monad

data Header = Header {
  getTitle :: String,
  getPublishAt :: String
} deriving (Show)

instance FromJSON Header where
  parseJSON (Object json) = Header <$>
                            json .: "title" <*>
                            json .: "publish_at"

  parseJSON _ = mzero
