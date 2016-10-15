#!/bin/bash

set -o errexit -o nounset

TALKS="chennaipy-dec-2015 u-boot-meetup-sep-2016"

if [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "This commit was made against the $TRAVIS_BRANCH and not the master! No deploy!"
  exit 0
fi

rev=$(git rev-parse --short HEAD)

mkdir output
cd output
mkdir talks
for talk in $TALKS;do
    cp -rf $talk/output/* talks
done

git init
git config user.name "BabuSubashChandar"
git config user.email "babuenir@gmail.com"

git remote add upstream "https://$GH_TOKEN@github.com/babuenir/blog.git"
git fetch upstream
git reset upstream/gh-pages

#echo "babuenir.github.io" > CNAME

touch .

git add -A .
git commit -m "rebuild pages at ${rev}"
git push -q upstream HEAD:gh-pages
