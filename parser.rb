require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'sanitize'
require 'mechanize'
require 'watir-webdriver'

# Scraping
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

  def hero_page
    puts Sanitize.clean(page_after_login.search("#hero_lastitems"))
  end

  # Login in, and returns page
  def page_after_login
    agent = Mechanize.new
    page = agent.get('http://godville.net/login')
    form = page.forms.first
    form['username'] = 'lordlenoks@rambler.ru'
    form['password'] = 'orochimaru'
    pp page = agent.submit(form, form.buttons.first)
    pp page = agent.get('http://godville.net/login')

  end

  def watirz
    browser = Watir::Browser.new :firefox
    browser.goto('http://bit.ly/watir-example')
  end

end

p = Parser.new
# puts p.opinion
# p.blog_news
#p.page_after_login
#p.hero_page
puts p.watirz
