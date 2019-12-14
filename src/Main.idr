module Main

import Graphics.SDL2
import Effect.Random
import Effects

record Body where
   constructor MkBody
   body_x, body_y : Int

implementation Show Body where
   show (MkBody x y) = "(MkBody " <+> show x <+> "," <+> show y  <+> ")"

body : Renderer -> Body -> IO ()
body renderer (MkBody x y) = 
  filledEllipse renderer x y 10 10 255 0 0 255

nbody_count : Int
nbody_count = 30

window_width : Int
window_width = 400

window_height : Int
window_height = 500

draw : Renderer -> List Body -> IO ()
draw renderer bodys =  do
   filledRect renderer 0 0 900 900 255 255 254 254
   traverse_ (body renderer) bodys 

update : List Body -> List Body
update = id 

windowLoop : Renderer -> List Body -> IO ()
windowLoop renderer bodys = do 
   renderClear renderer 
   draw renderer bodys 
   renderPresent renderer 
   isQuit <- pollEventsForQuit
   if isQuit then
           putStrLn "hello hello_world!"
           else windowLoop renderer $ update bodys

randomNumbers : Int -> Integer -> Int -> IO (List Integer)
randomNumbers 0 _ _ = pure empty
randomNumbers depth x max = do
    out <- run (do
            srand x
            rndInt 0 (cast max)
            )
    res <- randomNumbers (depth -1) out max 
    pure $ res <+> pure out

makeBodys : List Integer -> List Integer -> List Body
makeBodys rngIntWidth rngInthHeights = do
    (width, height) <- zip rngIntWidth rngInthHeights
    pure $ MkBody (fromInteger width) (fromInteger height)

main : IO ()
main = do
    rngIntWidth <- randomNumbers nbody_count 21 window_width
    rngInthHeights <- randomNumbers nbody_count 22 window_height
    initialRender <- init window_width window_height
    windowLoop initialRender (makeBodys rngIntWidth rngInthHeights) 
