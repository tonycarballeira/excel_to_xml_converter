require "rubygems"
require "sinatra"
require "spreadsheet"
require "nokogiri"
require "sinatra/cookies"	

require_relative "helpers"
helpers Helpers

Spreadsheet.client_encoding = 'UTF-8'
Tilt.register Tilt::ERBTemplate, 'html.erb'


get "/"  do
	erb :index
end

post "/" do 
  File.open('uploads/' + params['myfile'][:filename], "w") do |f|
    f.write(params['myfile'][:tempfile].read)
    @file = params['myfile'][:tempfile]
    @filename = params['myfile'][:filename]
  end
    cookies[:filename] = @filename
    redirect '/xml'
end

get "/xml" do
	@file_name = cookies[:filename]
	convert_excel(@file_name)
  erb :show_image
end
