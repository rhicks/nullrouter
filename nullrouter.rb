require 'open-uri'
require 'ipaddr'
require 'date'

@@network_addresses = []

class NetworkAddress
  def initialize(ipaddress, cidr)
    @ipaddress = ipaddress
    @cider     = cidr
    @netmask   = cidr_to_netmask(cidr)
  end

  def cidr_to_netmask(cidr)
    IPAddr.new('255.255.255.255').mask(cidr).to_s
  end

  def to_s
    "ip route #{@ipaddress} #{@netmask} null0 description #{Date.today.to_s}_SPAMHAUS-DROP"
  end
end

#open('http://www.spamhaus.org/drop/drop.lasso') do |drop_data|
open('http://www.okean.com/chinacidr.txt') do |drop_data|
  drop_data.each do |line|
    address = line.scan(/\b(?:\d{1,3}\.){3}\d{1,3}\b\/\d{1,2}\b/)
    address.each do |cidr|
      network, mask = cidr.split(/\//)
      @@network_addresses << NetworkAddress.new(network, mask)
    end
  end
end


@@network_addresses.each do |route|
  puts route
end
