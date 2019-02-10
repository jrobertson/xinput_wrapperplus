# Introducing the xinput_wrapperplus gem


    require 'xinput_wrapperplus'

    xiw = XInputWrapperPlus.new device: '3', topic: 'jessie/input/keyboard', 
            verbose: true, host: 'sps.home'
    xiw.listen

In the above example, whenever the *superkey* is pressed or a secret knock is detected using the *control* key a SimplePubSub message is published to the messaging broker at *sps.home*.

Output:

<pre>
keycode: 133
super key presssed
:: "super key pressed"
keycode: 37
control key presssed

1 knock
keycode: 37
control key presssed
2 knock
:: "e"

</pre>

In the above output the superkey was pressed, and then the *control* key was pressed twice in quick succession to yield the letter *e*.

## Resources

* xinput_wrapperplus https://rubygems.org/gems/xinput_wrapperplus

xinput xinputwrapperplus gem secretknock superkey
