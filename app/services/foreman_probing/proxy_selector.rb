module ForemanProbing
  class ProxySelector

    def determine_proxy
      # TODO: Come up with something clever
      return :not_defined # xxx
      SmartProxy.first || :not_defined
    end

  end
end
