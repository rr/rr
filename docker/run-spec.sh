#!/bin/bash

set -eux

cd /rr
export BUNDLE_GEMFILE=$PWD/Gemfile.rspec
gem install bundler -v 1.16.6
bundle _1.16.6_ install
bundle exec rake spec:rspec_2
