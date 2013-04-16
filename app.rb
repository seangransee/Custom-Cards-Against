require 'sinatra'
require 'pdfkit'
require 'wkhtmltopdf-heroku' if production?

def generatePages(list)
  cards = list.map{|line| line.strip }.select{|line| !line.empty? }

  numRows = (cards.length / 4.0).ceil
  pages = []

  (0..numRows-1).each do |i|
    if i % 5 == 0
      pages.push([])
    end
    row = cards.slice(4*i,4)
    pages[i / 5].push(row)
  end

  return pages

end

get '/' do
  haml :index
end

post '/cards.pdf' do

  content_type 'application/pdf'

  list = request['cards'].split("\r")
  name = request['gamename']

  html = haml :cards, :locals => {:pages => generatePages(list),
                                  :gamename => name}
  pdf = PDFKit.new(html, page_size: 'Letter',
                         margin_top: '0.5in',
                         margin_bottom: '0.5in',
                         margin_left: '0.25in',
                         margin_right: '0.25in').to_pdf
  pdf
end