require 'sinatra'
require 'pdfkit'
require 'wkhtmltopdf-heroku' if production?

def generatePages(list)

  cards = list.split("\r").map{|line| line.strip }.select{|line| !line.empty? }

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

  name = request['gamename']
  white_cards = generatePages(request['white_cards'])
  black_cards = generatePages(request['black_cards'])

  html = haml :cards, :locals => {:white_cards => white_cards,
                                  :black_cards => black_cards,
                                  :gamename => name}

  pdf = PDFKit.new(html, page_size: 'Letter',
                         margin_top: '0.5in',
                         margin_bottom: '0.5in',
                         margin_left: '0.25in',
                         margin_right: '0.25in').to_pdf
  pdf

end