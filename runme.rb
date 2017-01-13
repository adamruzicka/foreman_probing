require 'foreman_probing_core'
require 'pry'
p = ForemanProbingCore::ServiceProbes::TCPOpen.new('127.0.0.1', [22])
binding.pry
