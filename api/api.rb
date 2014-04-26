require 'sinatra'

class Api < Sinatra::Base

  get "/" do
    "hello world"
  end

end