module ForemanProbingCore
  module ServiceProbes

    require 'foreman_probing_core/probes/abstract'
    require 'foreman_probing_core/probes/dns'
    require 'foreman_probing_core/probes/http'
    require 'foreman_probing_core/probes/ssh'
    require 'foreman_probing_core/probes/ping'
    require 'foreman_probing_core/probes/tcp_open'

    ALL_PROBES = [DNS, HTTP, HTTPS, SSH, TCPOpen]

  end
end
