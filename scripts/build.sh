#!/bin/bash
set -ev

function buildlib {
  cd $1
  $CABALINSTALL --only-dependencies --dry-run > plan.txt
  if grep -Fq microlens plan.txt
  then
    cat plan.txt
    echo "installing $lib led to downloading some microlens package!"
    exit 1
  fi
  rm plan.txt
  if [ "$GHCVER" == "head" ]
  $CABALINSTALL --ghc-options "-Werror"
  fi
  cabal haddock
  # cabal check
  cabal sdist
  cd ..
}

# We install packages in the order specified in install-order.txt;
# if installing any package leads to *downloading* some microlens package,
# it's a bug.
while read lib; do buildlib $lib; done < install-order.txt
