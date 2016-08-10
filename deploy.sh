#!/bin/sh
set -e

bundle exec jekyll build
rsync -avze 'ssh -p 22' --delete --delete-after --progress _site/ abe@raw.abevoelker.com:/var/www/blog.abevoelker.com/
