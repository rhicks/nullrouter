class NetworkAddress
  attr_accessor :ipaddress, :netmask

  def initialize(ipaddress, netmask)
    @ipaddress = ipaddress
    @netmask   = netmask
  end


