class String
  def count_blanks

    (self.scan /_+/).length

  end

  def uniform_length_blanks

    self.gsub /_+/, "<span class='line'></span>"

  end

  def abbreviate

    self.split(" ").map{|word| word[0].upcase}.join("")

  end

  def generatePages(color)

    cards = self.split("\r").map{|line| line.strip }.select{|line| !line.empty? }

    numRows = (cards.length / 4.0).ceil
    pages = []

    (0..numRows-1).each do |i|
      if i % 5 == 0
        pages.push([])
      end
      if color == :black
        row = cards.slice(4*i,4).map do |card|
          {
            text: card.uniform_length_blanks,
            blanks: card.count_blanks
          }
        end
      else
        row = cards.slice(4*i,4).map do |card|
        {
          text: card,
          blanks: 0
        }
        end
      end
      pages[i / 5].push(row)
    end

    puts pages
    return pages

  end
end