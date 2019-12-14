module Main

import Graphics.SDL2
import Effect.Random
import Effects

record Body where
   constructor MkBody
   body_x, body_y : Int
   body_vel_x, body_vely_y : Double

implementation Show Body where
   show body =
    "(MkBody " <+> show (body_x body) <+> "," <+> show (body_y body)  <+> ")"

body : Renderer -> Body -> IO ()
body renderer body = 
  filledEllipse renderer (body_x body) (body_y body) 10 10 255 0 0 255

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

centerFunc : (Int, (Double, Double)) -> Body -> (Int, (Double, Double))
centerFunc (0, _) body = (1, cast $ body_x body, cast $ body_y body)
centerFunc (ix, (prev_x, prev_y)) body =
    (1,
    prev_x * prevFrac + fraction * (cast $ body_x body),
    prev_y * prevFrac + fraction * (cast $ body_y body))
           where
              fraction = 1 / cast ix
              prevFrac = 1 - fraction
   
findMassCenter : List Body -> (Double, Double)
findMassCenter x = snd $ foldl centerFunc (0, 0, 0) x 

change : Double
change = 0.9

update : List Body -> List Body
update bodies = 
  let center = findMassCenter bodies
  in map (\body => body
        -- let  xchange = fst center - body_x body in
        -- (record { body_vel_x =
          --          (if xchange /= 0 then 1 / xchange else 0) *
           --         (1- change) +
            --        (body_vel_x body) * change 
             --   } body)
             )
             bodies
                


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
    pure $ MkBody (fromInteger width) (fromInteger height) 0 0

main : IO ()
main = do
    rngIntWidth <- randomNumbers nbody_count 21 window_width
    rngInthHeights <- randomNumbers nbody_count 22 window_height
    initialRender <- init window_width window_height
    windowLoop initialRender (makeBodys rngIntWidth rngInthHeights) 
