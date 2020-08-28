#!/usr/bin/env ruby

# file: xinput_wrapperplus.rb


require 'sps-pub'
require 'secret_knock'
require 'xinput_wrapper'

class XInputWrapperPlus < XInputWrapper

  def initialize(host: 'sps', port: '59000', 
                 topic: 'input', verbose: true, lookup: {}, 
                 debug: false, capture_all: false, keys: [], 
                 keypress_detection: true, motion_detection: true)

    puts 'before super'
    super(verbose: verbose, lookup: lookup, 
          debug: debug, keys: keys)
    puts 'after super'
    
    @topic, @capture_all = topic, capture_all
    @keypress_detection = keypress_detection
    @motion_detection = motion_detection

    @sps = SPSPub.new host: host, port: port

    @sk = SecretKnock.new short_delay: 0.25, long_delay: 0.5, 
                              external: self, verbose: verbose, debug: debug
    @sk.detect timeout: 0.7

    @a = [] # Used to store mouse gestures
    @timer, @t2 = nil , Time.now - 30

  end

  def knock()
    puts 'knock' if @verbose
  end
  
  def message(msg, subtopic=:keyboard)
    
    puts ':: ' + msg.inspect if @verbose        
    
    return if msg.strip.empty?
    
    topic = [@topic, subtopic].compact.join('/')
    
    @sps.notice "%s: %s" % [topic, msg]
    
  end    
  
  private  
  
  def anykey_press()
    
    if @keypress_detection and (Time.now > @t2 + 30) then
      message 'keypress detected', nil
      @t2 = Time.now
    end
    
  end
  
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
    
    if @motion_detection and (Time.now > @t2 + 30) then
      message 'motion detected', nil
      @t2 = Time.now
    end
=begin    
    @timer.exit if @timer

    @a << [x,y]


    @timer = Thread.new do 
      
      sleep 0.25
      puts 'inside timer' if @debug
      
      on_gesture(@a) if @a.length > 6 and @a.length < 36
      @a = []

    end
=end    
    
  end
  
  def on_super_key()
    message 'super key pressed' 
  end
end
