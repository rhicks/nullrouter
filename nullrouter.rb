require 'open-uri'

open('http://www.spamhaus.org/drop/drop.lasso') do |drop_data|
  drop_data.each do |line|
    address, sc, sbl = line.chomp.split()
    network, mask = address.split(/\//)
    puts network
    puts mask
  end
end



class NetworkAddress
  attr_accessor :ipaddress, :netmask

  def initialize(ipaddress, netmask)
    @ipaddress = ipaddress
    @netmask   = netmask
  end
end
