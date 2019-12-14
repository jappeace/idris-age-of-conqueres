{- | Idris Project Template

        ____    __     _
       /  _/___/ /____(_)____
       / // __  / ___/ / ___/
     _/ // /_/ / /  / (__  )
    /___/\\__,_/_/  /_/____/


-}
module Lib

%include C "../cbits/Lib.h"
%link C "Lib.o"

ffiFun : String -> IO Int
ffiFun str = foreign FFI_C "idr_ctest" (String -> IO Int) str

someFun : IO ()
someFun = do
  putStrLn "Testing idris via idris"
  i <- ffiFun "Testing idris via ffi"
  print i
