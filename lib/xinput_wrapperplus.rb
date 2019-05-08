#!/usr/bin/env ruby

# file: xinput_wrapperplus.rb


require 'sps-pub'
require 'secret_knock'
require 'xinput_wrapper'

class XInputWrapperPlus < XInputWrapper

  def initialize(device: '3', host: 'sps', port: '59000', 
                 topic: 'input', verbose: true, lookup: {}, 
                 debug: false, capture_all: false)

    super(device: device, verbose: verbose, lookup: lookup, 
          debug: debug)
    @topic, @capture_all = topic, capture_all
    @sps = SPSPub.new host: host, port: port
    @sk = SecretKnock.new short_delay: 0.25, long_delay: 0.5, 
                              external: self, verbose: verbose, debug: debug
    @sk.detect timeout: 0.7

    @a = [] # Used to store mouse gestures
    @timer = nil

  end


  def knock()
    puts 'knock' if @verbose
  end

  def message(msg, subtopic=:keyboard)
    
    puts ':: ' + msg.inspect if @verbose        
    
    return if msg.strip.empty?
    
    topic = [@topic, subtopic].join('/')
    
    @sps.notice "%s: %s" % [topic, msg]
    
  end  
  
  protected
  
  def on_control_key()
    puts 'inside on_control_key' if @debug
    @sk.knock
  end
  
  def on_gesture(a)
    
    puts 'inside on_gesture' if @debug    
    points = @a.map {|coords| coords.map {|x| x}.join(',') }.join(' ')
    message points, 'motion'
    
  end
  
  def on_key_press(key, keycode, modifier=[])
    
    puts 'inside on_key_press' if @debug
    
    message format_key(key, modifier) if @capture_all
    
    @sk.reset if @lookup[keycode] != :control
    
  end
  
  def on_mousemove(x,y)
    
    if @debug then
      puts "on_mousemove() x: %s y: %s" % [x, y]
    end
    
    @timer.exit if @timer

    @a << [x,y]


    @timer = Thread.new do 
      
      sleep 0.25
      puts 'inside timer' if @debug
      
      on_gesture(@a) if @a.length > 6 and @a.length < 36
      @a = []

    end
    
    
  end
  
  def on_super_key()
    message 'super key pressed' 
  end
end
