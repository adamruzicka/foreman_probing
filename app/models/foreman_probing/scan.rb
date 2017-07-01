module ForemanProbing
  class Scan < ActiveRecord::Base

    belongs_to :task, :class_name => '::ForemanTasks::Task'
    has_one :targeting
    has_one :scan_host
    has_many :hosts, :through => :scan_host
    belongs_to :smart_proxy

    attr_accessor :direct, :subnet, :host, :tcp, :udp, :icmp, :ports, :use_nmap

    def available_scan_types
      ['TCP', 'UDP', 'ICMP']
    end

    def target_kinds
      ['Direct', 'Subnet', 'Host', 'Proxy']
    end

  end
end
