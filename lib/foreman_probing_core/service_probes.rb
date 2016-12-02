module ForemanProbingCore
  module ServiceProbes

    require 'foreman_probing_core/service_probes/abstract'
    require 'foreman_probing_core/service_probes/dns'
    require 'foreman_probing_core/service_probes/http'
    require 'foreman_probing_core/service_probes/ssh'
    require 'foreman_probing_core/service_probes/tcp_open'

    ALL_PROBES = [DNS, HTTP, HTTPS, SSH, TCPOpen]

  end
end
