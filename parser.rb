require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'sanitize'

# Parser task
class Parser
  def from(url)
    Nokogiri::HTML(open(url), nil, 'UTF-8')
  end

  # Concatenates mas of titles and text to an article
  def concat(title, text)
    (0..title.length - 1).each do |i|
      puts '-------------------------------------'
      puts title[i] + "\n\s"
      puts text[i]
    end
  end

  # Show opinion on main page
  def opinion
    h = from('https://godville.net/')
    h.css('#q_opinion').text + "\n" + h.css('#q_author').text
  end

  # Show latest blog news
  def blog_news
    h = from('https://godville.net/blog/rss')
    titles = []
    articles = []
    h.css('//title').to_a.each_with_index { |t, i| titles[i] = t.text }
    titles.delete_at(0)
    h.css('//summary').to_a.each_with_index do |t, i|
      articles[i] = Sanitize.clean(t.text)
    end
    concat(titles, articles)
  end
end

p = Parser.new
puts p.opinion
p.blog_news
