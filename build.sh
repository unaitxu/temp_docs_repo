#!/bin/sh

bundle install

bundle exec jekyll  serve -w -I --config _config.yml --port 4000 --host 0.0.0.0
