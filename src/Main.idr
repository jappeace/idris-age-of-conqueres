module Main

import NBody
import Data.Vect
import System
import Prelude.Providers
import Data.String

%language TypeProviders

getSizeT : IO (Provider Integer)
getSizeT = do
  nbodyFUnc 
  putStrLn "I'm sorry, I don't know how big size_t is. Can you tell me, in bytes?"
  resp <- getLine
  case parseInteger resp of
     Just sizeTSize => pure (Provide sizeTSize)
     Nothing => pure (Error "I'm sorry, I don't understand.")
    -- the readInt function is left as an exercise

%provide (sizeTSize : Integer) with getSizeT

main : IO ()
main = do
    print sizeTSize
    nbodyFUnc
