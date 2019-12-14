module Main

import Graphics.SDL2

main : IO ()
main = do 

   screen <- init 400 500
   isQuit <- pollEventsForQuit
   if isQuit then
           putStrLn "hello hello_world!"
           else main

