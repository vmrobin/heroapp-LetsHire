#!/bin/sh

RAILS_ENV=ci rake db:migrate
rake ci
