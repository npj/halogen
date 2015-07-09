{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson
import Control.Applicative
import Control.Monad
import Data.Time.LocalTime
import Data.ByteString.Lazy

data Header = Header {
  getTitle :: String,
  getPublishAt :: ZonedTime
} deriving (Show)

instance FromJSON Header where
  parseJSON (Object json) = Header <$>
                            json .: "title" <*>
                            json .: "publish_at"
  parseJSON _ = mzero

modifyPublishAt :: Header -> ZonedTime -> Header
modifyPublishAt header time = header { getPublishAt = time }

decodeHeader :: ByteString -> TimeZone -> Maybe Header
decodeHeader json tz = toUTC <$> decode json
  where toUTC header = modifyPublishAt header $ convert $ getPublishAt header
        convert = utcToZonedTime utc . localTimeToUTC tz . zonedTimeToLocalTime

