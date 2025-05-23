#!/bin/bash

set -e

mkdir -p /run/php
exec php-fpm7.4 -F

