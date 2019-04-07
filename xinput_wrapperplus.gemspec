Gem::Specification.new do |s|
  s.name = 'xinput_wrapperplus'
  s.version = '0.3.0'
  s.summary = 'A wrapper for the Linux utility xinput. Publishes an SPS ' + 
      'message whenever the super key is pressed as well as publishing a ' + 
      'deciphered message when the control key is pressed more than once'
  s.authors = ['James Robertson']
  s.files = Dir['lib/xinput_wrapperplus.rb']
  s.add_runtime_dependency('sps-pub', '~> 0.5', '>=0.5.5')
  s.add_runtime_dependency('secret_knock', '~> 0.3', '>=0.3.1')
  s.add_runtime_dependency('xinput_wrapper', '~> 0.4', '>=0.4.0') 
  s.signing_key = '../privatekeys/xinput_wrapperplus.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/xinput_wrapperplus'
end
