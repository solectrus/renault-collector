#!/usr/bin/env ruby

require 'dotenv/load'
require 'influxdb-client'

require_relative 'renault_loop'

# Flush output immediately
$stdout.sync = true

RenaultLoop.start
