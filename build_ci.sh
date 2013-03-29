#!/bin/sh

rake db:migrate RAILS_ENV=ci
rake ci
