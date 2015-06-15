require "rubygems"
require "sinatra"
require "spreadsheet"
require "nokogiri"	


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
  @book = Spreadsheet.open('uploads/'+@filename)
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

