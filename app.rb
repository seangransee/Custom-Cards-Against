require 'sinatra'
require 'pdfkit'
require './core_ext/string.rb'
require 'wkhtmltopdf-heroku' if production?

get '/' do
  haml :index
end

post '/cards.:ext' do

  html = haml :cards, :locals => {
    gamename: request['gamename'],
    abbr: request['gamename'].abbreviate,
    cards: [
      request['white_cards'].generatePages(:white),
      request['black_cards'].generatePages(:black)
    ]
  }

  if params[:ext] == "html"

    return html

  elsif params[:ext] == "pdf"

    content_type 'application/pdf'

    return PDFKit.new(html, page_size: 'Letter',
                            margin_top: '0.5in',
                            margin_bottom: '0.5in',
                            margin_left: '0.25in',
                            margin_right: '0.25in').to_pdf

  end

end