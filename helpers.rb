module Helpers
	def convert_excel(file_name) 
		@book = Spreadsheet.open('uploads/'+file_name)
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
	end
end