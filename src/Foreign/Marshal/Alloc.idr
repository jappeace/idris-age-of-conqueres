
-- These functions are implemented in 'Effect.Memory' but kept
-- around for example purposes.
module Foreign.Marshal.Alloc

public
malloc : Int -> IO Ptr
malloc sz = foreign FFI_C "malloc" (Int -> IO Ptr) sz

public
free : Ptr -> IO ()
free p = foreign FFI_C "free" (Ptr -> IO ()) p

public
alloc : Int -> (Ptr -> IO a) -> IO a
alloc sz action = do
  ptr <- malloc sz
  res <- action ptr
  free ptr
  return res
