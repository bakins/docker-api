# This class represents a Connection to a Docker server. The Connection is
# immutable in that once the host and port is set they cannot be changed.
class Docker::Connection
  attr_reader :host, :port

  # Create a new Connection. By default, the Connection points to localhost at
  # port 4243, but this can be changed via an options Hash.
  def initialize(options = {})
    unless options.is_a?(Hash)
      raise Docker::Error::ArgumentError, "Expected a Hash, got: #{options}"
    end
    self.port = options[:port] || 4243
    self.host = options[:host] || 'localhost'
  end

  # The actual client that sends HTTP methods to the docker server.
  def resource
    @resource ||= RestClient::Resource.new("#{self.host}:#{self.port}")
  end

  def to_s
    "Docker::Connection { :host => #{self.host}, :port => #{self.port} }"
  end

  def ==(other_connection)
    other_connection.is_a?(self.class) &&
      (other_connection.host == self.host) &&
        (other_connection.port == self.port)
  end

  # Delegate all HTTP methods to the resource.
  delegate :get, :put, :post, :delete, :[], :to => :resource

private
  attr_writer :host, :port
end