module Main

import Graphics.SDL2
import Effect.Random
import Effects
import Data.Vect

record Body where
   constructor MkBody
   body_x, body_y : Int
   body_vel_x, body_vel_y, body_remainder_x, body_remainder_y : Double

-- TODO make vectors in Body
somePos : Vect 2 Int
somePos = [0,0]

implementation Show Body where
        show body = "(MkBody " <+> show (body_x body)
                    <+> "," <+> show (body_y body)
                    <+> "," <+> show (body_vel_x body)
                    <+> "," <+> show (body_vel_y body) 
                    <+> "," <+> show (body_remainder_x body)
                    <+> "," <+> show (body_remainder_y body) 
                    <+> ")"

body : Renderer -> Body -> IO ()
body renderer body =  do
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
findMassCenter = snd . foldl centerFunc (0, 0, 0)

change : Double
change = 0.9
  
updateWithVel : Double -> Double -> Int -> Int
updateWithVel x y d = (cast x) + (cast y) + d
  
stripDecimals : Double -> Int
stripDecimals = cast

recordUpdate : (Double, Double) -> Body -> Body 
recordUpdate center body =
    let  xchange = ((fst center) - (cast $ body_x body)) 
         ychange = ((fst center) - (cast $ body_y body)) 

         new_x_vel : Double = (((if xchange /= 0.0 then 1.0 / xchange else 0.0) *
                   (1- change) +
                    (body_vel_x body) * change))
         new_y_vel = ((if ychange /= 0 then 1.0 / ychange else 0) *
                   (1- change) +
                    (body_vel_y body) * change)

         new_body_remainder_x = (new_x_vel - (cast $ stripDecimals new_x_vel)) + body_remainder_x body
         new_body_remainder_y = (new_y_vel - (cast $ stripDecimals new_y_vel)) + body_remainder_x body
         new_body_remainder_x' = if abs new_body_remainder_x > 1 then 0.0 else  new_body_remainder_x
         new_body_remainder_y' = if abs new_body_remainder_y > 1 then 0.0 else  new_body_remainder_y

    in
        (record { body_vel_x = new_x_vel,
                  body_vel_y = new_y_vel,
                  body_remainder_x = new_body_remainder_x',
                  body_remainder_y = new_body_remainder_y',
                  body_x $= updateWithVel (body_vel_x body) new_body_remainder_x,
                  body_y $= updateWithVel (body_vel_y body) new_body_remainder_y
               } body)

update : List Body -> List Body
update bodies = 
  let center = findMassCenter bodies
  in map (recordUpdate center) bodies
                
windowLoop : Renderer -> List Body -> IO ()
windowLoop renderer bodys = do 
   renderClear renderer 
   draw renderer bodys 
   renderPresent renderer 
   isQuit <- pollEventsForQuit
   case bodys of
        (x :: _)  => putStrLn $ show x
        [] => pure ()
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
    pure $ MkBody (fromInteger width) (fromInteger height) 0 0 0 0

main : IO ()
main = do
    rngIntWidth <- randomNumbers nbody_count 21 window_width
    rngInthHeights <- randomNumbers nbody_count 22 window_height
    initialRender <- init window_width window_height
    windowLoop initialRender (makeBodys rngIntWidth rngInthHeights) 
