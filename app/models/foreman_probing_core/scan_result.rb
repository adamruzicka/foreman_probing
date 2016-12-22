module ForemanProbingCore

  class PortScanResultBuilder
    def initialize(protocol, port, optional = {})
      @protocol = protocol
      @port     = port
      @optional = optional
    end
  end

  class 

  class ScanResultBuilder

    def initialize(host)
      @exceptions = []
      @addresses  = []
      @hostnames  = []
      @ports      = []
      @state      = []
    end

    def exception(e)
      entry = {
        :class     => exception.class,
        :message   => exception.message,
        :backtrace => exception.backtrace
      }
      @exceptions << entry unless @exceptions.include?(entry)
    end

  end
end