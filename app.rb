require "rubygems"
require "sinatra"
require "spreadsheet"
require "nokogiri"
require "sinatra/cookies"	

enable :sessions

Spreadsheet.client_encoding = 'UTF-8'
Tilt.register Tilt::ERBTemplate, 'html.erb'

before do
	@file_names = []
end

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
  @book = Spreadsheet.open('uploads/'+@file_name)
  @sheets = @book.worksheets
  @rows = []
	  
	  @sheets.each do |sheet| 
		sheet.each do |row| 
			 @rows << row 
			end
		end


	@builder = Nokogiri::XML::Builder.new do |xml|
	  xml.root {
	    xml.records {
		      @rows.each do |o|
	        xml.record {
	          xml.name_   o[0]
	          xml.month_  o[1]
	          xml.day_    o[2]
	          xml.year_   o[3]
	        }
	      end
	    }
	  }
	end

  erb :show_image

end
