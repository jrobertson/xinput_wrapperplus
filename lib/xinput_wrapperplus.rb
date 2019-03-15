#!/usr/bin/env ruby

# file: xinput_wrapperplus.rb


require 'sps-pub'
require 'secret_knock'
require 'xinput_wrapper'

class XInputWrapperPlus < XInputWrapper

  def initialize(device: '3', host: 'sps', port: '59000', 
                 topic: 'input/keyboard', verbose: true, lookup: {}, 
                 debug: false, capture_all: false)

    super(device: device, verbose: verbose, lookup: lookup, 
          debug: debug)
    @topic, @capture_all = topic, capture_all
    @sps = SPSPub.new host: host, port: port
    @sk = SecretKnock.new short_delay: 0.25, long_delay: 0.5, 
                              external: self, verbose: verbose, debug: debug
    @sk.detect timeout: 0.7

  end


  def knock()
    puts 'knock' if @verbose
  end

  def message(msg)
    
    puts ':: ' + msg.inspect if @verbose        
    
    return if msg.strip.empty?
    
    @sps.notice "%s: %s" % [@topic, msg]
    
  end  
  
  protected
  
  def on_control_key()
    puts 'inside on_control_key' if @debug
    @sk.knock
  end
  
  def on_key_press(key, keycode)
    puts 'inside on_key_press' if @debug
    message key.to_s if @capture_all
    @sk.reset if @lookup[keycode] != :control
  end
  
  def on_super_key()
    message 'super key pressed' 
  end
end
