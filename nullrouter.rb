#!/usr/bin/env ruby

require 'open-uri'
require 'ipaddr'
require 'date'
require 'optparse'

@@network_addresses = []

class NetworkAddress
  def initialize(ipaddress, cidr)
    @ipaddress = ipaddress
    @cidr      = cidr
    @netmask   = cidr_to_netmask(cidr)
  end

  def cidr_to_netmask(cidr)
    IPAddr.new('255.255.255.255').mask(cidr).to_s
  end

  def to_s
    "ip route #{@ipaddress} #{@netmask} null0 description #{Date.today.to_s}_SPAMHAUS-DROP"
  end
end


ARGV.each do|a|
  puts "Argument: #{a}"
end

#open('http://www.okean.com/chinacidr.txt') do |drop_data|
open('http://www.spamhaus.org/drop/drop.lasso') do |drop_data|
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

# This hash will hold all of the options
# parsed from the command-line by
# OptionParser.
options = {}
 
optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: nullrouter.rb -input -output"

  # define the options, and what they do
  options[:spamhaus] = false
  opts.on( '-s', '--spamhaus', 'Input: Use Spamhaus DROP data (http://www.spamhaus.com/drop)' ) do
    options[:spamhaus] = true
  end
  
  options[:china] = false
  opts.on( '-c', '--china', 'Input: Use Okean China data (http://www.okean.com/antispam/china.html)' ) do
    options[:china] = true
  end

  options[:korea] = false
  opts.on( '-k', '--korea', 'Input: Use Okean Korea data (http://www.okean.com/antispam/korea.html)' ) do
    options[:korea] = true
  end

  options[:custom] = nil
  opts.on( '-z', '--custom url', 'Input: Use a custom URL for data input' ) do|url|
    options[:custom] = url 
  end

  options[:null] = false
  opts.on( '-n', '--null description', 'Output: Cisco Null Routes with descriptions' ) do|desc|
    options[:null] = desc 
  end

  # this displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'display this screen' ) do
    puts opts
    exit
  end
end
 
# Parse the command-line. Remember there are two forms
# of the parse method. The 'parse' method simply parses
# ARGV, while the 'parse!' method parses ARGV and removes
# any options found there, as well as any parameters for
# the options. What's left is the list of files to resize.
optparse.parse!
puts opts if AGRV.size == nil
 
puts "Using Spamhaus DROP for input" if options[:spamhaus]
puts "Using Okean China for input" if options[:china] 
puts "Using Okean Korea for input" if options[:korea] 
puts "Using #{options[:custom]} for input" if options[:custom]
puts "Outputing Null Routes with a custom description of: #{options[:null]}" if options[:null]


