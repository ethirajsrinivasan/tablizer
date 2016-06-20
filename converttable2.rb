# converttable2.rb
require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'
require 'pry'
require 'thin'



get '/' do
  erb :index
end

post '/generate_output' do
  unless params[:url].empty? && params[:input_html].empty?
    output, table_count = to_csv
    {data: output,count: table_count}.to_json
  end
end


post '/downloadcsv' do
  download("csv")
end

post '/downloadxls' do
  download("xls")
end

private

def download(format)
  file_name = params[:file_name].empty? ? "out" : params[:file_name]
  attachment "#{file_name}.#{format}"
  params[:output]
end

def to_csv
  begin
    doc = params[:url].empty? ? Nokogiri::HTML(params[:input_html]) : Nokogiri::HTML(open(params[:url]))
    tables = doc.search('table')
    tables_count = tables.count
    tables = [tables[params[:table_no].to_i]] unless params[:table_no] == "All"
    csv = CSV.generate do |csv|
      tables.each do |table|
        table.search('tr').each do |tr|
          csv << tr.search('th','td').map(&:text)
        end
      end
    end
    [csv, tables_count]
  rescue
    Array.new(2)
  end
end
