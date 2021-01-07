require 'sinatra/base'

class FakeApp < Sinatra::Base
  get '/' do
    status 200
    'NICE!'
  end

  get '/star.png' do
    send_file (File.dirname(__FILE__) + "/fixtures/star.png"), disposition: 'attachment', filename: 'star.png', type: 'image/png'
  end

  get '/files.txt' do
    send_file (File.dirname(__FILE__) + "/fixtures/files.txt"), disposition: 'attachment', filename: 'files.txt', type: 'text/plain'
  end
end
