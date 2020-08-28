# Using XInputWrapperPlus to trigger upon a key press and more


## Example

    require "socket"
    require 'xinput_wrapperplus'

    hostname =  Socket.gethostname
    keys = %i(control super f6)

    xiw = XInputWrapperPlus.new topic: hostname + '/input', 
             lookup:  {105 => :control, 37 => :control, 134 => :super}, 
             host: 'sps.home', keys: keys
    xiw.listen

The above example is intended to run in the background to listen for key presses or mouse movement.
When either the ctrl key, super key (windows logo key), or F6 key is pressed a message is published to the SimplePubSub broker at *sps.home* on port 59000. In addition, it publishes the detection of any key or mouse movent to the broker, ever 30 seconds.

xinputwrapperplus xinput
