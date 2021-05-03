{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import Data.Attoparsec.Text as A
import qualified Data.Text
import qualified Data.Text.IO
import System.Directory
import System.Environment
import System.FilePath.Find

search =
  find
    always
    ( (extension ==? ".hs" ||? extension ==? ".hs-boot")
        &&? filePath ~~? "**/src/BlockfrostAPI**"
    )

main = do
  dir <- getCurrentDirectory
  files <- search dir
  forM_ files $ \f -> do
    --print f
    Data.Text.IO.readFile f >>= Data.Text.IO.writeFile f . fixColliding

-- type Something = [Something]
colliding = do
  "type"
  space
  typeName <- A.takeWhile (/= ' ')
  " = "
  "[" *> string typeName <* "]"

fixColliding =
  Data.Text.unlines
    . concatMap
      ( \line -> case parseOnly colliding line of
          Right typ -> ["-- XXX: collision", "-- " <> line, "type " <> typ <> "' = [" <> typ <> "]"]
          Left _ -> pure line
      )
    . Data.Text.lines
