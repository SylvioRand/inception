#!/bin/bash
mkdir -p /run/php
exec php-fpm7.4 -F
