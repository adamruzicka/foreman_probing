module ForemanProbing
  class ProxySelector

    def determine_proxy
      # TODO: Come up with something clever
      SmartProxy.first || :not_defined
    end

  end
end