#!/bin/sh
set -e

rm -rf .jekyll-cache
bundle exec jekyll clean
bundle exec jekyll build -D --config _config.yml,_config_staging.yml
echo "User-agent: *\nDisallow: /" > _site/robots.txt
aws s3 sync _site/ s3://blog-staging-d8515cc297b0.abevoelker.com --delete --cache-control max-age=604800 --profile=abe
aws cloudfront create-invalidation --distribution-id E5ZEQ2LABHPU1 --paths "/*" --profile=abe
#rsync -avz --exclude _site/ ~/Sites/abes-blog/
