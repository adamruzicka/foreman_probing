module ForemanProbingCore
  module Probes
    require 'foreman_probing_core/probes/abstract'
    require 'foreman_probing_core/probes/nmap'
    require 'foreman_probing_core/probes/tcp'
    require 'foreman_probing_core/probes/udp'
    require 'foreman_probing_core/probes/icmp'
  end
end
