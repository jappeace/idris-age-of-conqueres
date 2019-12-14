
module Control.Monad.Loop

import Prelude

partial public
whileM : IO Bool -> IO ()
whileM m
    = m >>= \p => if p
                    then whileM m
                    else return ()
