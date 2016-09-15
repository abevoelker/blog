#!/bin/sh
set -e

#bundle exec jekyll build
aws s3 sync _site/ s3://blog.abevoelker.com --delete --exclude ".git/*" --exclude "Gemfile*" --exclude "deploy.sh" --cache-control max-age=604800
aws cloudfront create-invalidation --distribution-id E2BKCSM0CO9HM4 --paths "/*"
