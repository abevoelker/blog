#!/bin/sh
set -e

JEKYLL_ENV=production bundle exec jekyll build
aws s3 sync _site/ s3://blog.abevoelker.com --delete --cache-control max-age=604800 --profile=abe
aws cloudfront create-invalidation --distribution-id E2BKCSM0CO9HM4 --paths "/*" --profile=abe
rsync -avz --exclude _site/ ~/Sites/abes-blog/
