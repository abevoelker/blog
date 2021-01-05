#!/bin/sh
set -e

rm -rf .jekyll-cache
bundle exec jekyll clean
JEKYLL_ENV=production bundle exec jekyll build

# Sync all assets with 1 week cache-control
aws s3 sync _site/ s3://abevoelker.com --delete --cache-control "public, max-age=604800" --exclude "*" --include "assets/*" --profile=abe
# Sync remaining non-asset files with no cache.
aws s3 sync _site/ s3://abevoelker.com --delete --cache-control "no-cache" --exclude "assets/*" --exclude "*.md" --profile=abe

: '
aws s3api put-object \
  --acl public-read \
  --website-redirect-location "https://abevoelker.com/feed.xml" \
  --bucket "abevoelker.com" \
  --key "/atom.xml" \
  --profile=abe
'
