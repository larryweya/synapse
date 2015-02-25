require "synapse/service_watcher/zookeeper"

module Synapse
  class ZookeeperAuroraWatcher < ZookeeperWatcher

    def validate_discovery_opts
      raise ArgumentError, "invalid discovery method #{@discovery['method']}" \
        unless @discovery['method'] == 'aurora'
      raise ArgumentError, "missing or invalid zookeeper host for service #{@name}" \
        unless @discovery['hosts']
      raise ArgumentError, "invalid zookeeper path for service #{@name}" \
        unless @discovery['path']
    end

    # decode the data at a zookeeper endpoint
    def deserialize_service_instance(data)
      log.info "synapse: deserializing process data"
      decoded = JSON.parse(data)

      host = decoded['serviceEndpoint']['host'] || (raise ValueError, 'instance json data does not have host key')
      port = decoded['serviceEndpoint']['port'] || (raise ValueError, 'instance json data does not have port key')
      name = decoded['name'] || nil

      return host, port, name
    end
  end
end