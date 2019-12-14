#! /bin/sh


set -x

(sleep 1 && touch src/Lib.idr) & # makes it go the first time
# TODO make this with tmux http://man7.org/linux/man-pages/man1/tmux.1.html
# we can leave the nix shells open in that for faster builds
# (loading currenlty takes quite a bit of time)

# TODO use: https://github.com/schell/steeloverseer#readme
# I think it does this better
while inotifywait -r -e modify -e create -e attrib ./src
do
    # since ghc needs to compile both backend, frontend and run the tests,
    # ghcjs should 'win' the race, I noticed some dangling ghcjs'es after a while
    make build 
     # && \
    # make enter EXTRA="--run \"make haddock\""
done
