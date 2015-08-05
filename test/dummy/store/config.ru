$LOAD_PATH << '.'
require 'config/setup'
Store::Application.init!(self)
run Store::Application
