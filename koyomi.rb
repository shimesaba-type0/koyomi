# coding: utf-8

require 'open-uri'
require 'csv'
require 'nokogiri'

master_url = 'https://moonlabo.com/cgi-bin/cln/cln_clm.cgi?OpDv=usd'

#urls = ["1910"]
urls = ["1910", "1920", "1930", "1940", "1950", "1960", "1970", \
        "1980", "1990", "2000", "2010", "2020", "2040"]

csv = ""
word = "月節"
urls.each do |url_year|
  # スクレイピング先の文字コードとHTMLの取得
  url = master_url + url_year
  charset = nil
  html = open(url) do |f|
    charset = f.charset
    f.read
  end

  # 取得したHTMLをパースしてDOM化
  tbody = Nokogiri::HTML.parse(html, nil, charset)

  # 必要なデータを取得し、CSV化
  tbody.xpath('//*[@id="col_main"]/article[2]/div/table/tbody').each do |node|
    #puts node.search('tr').text
    node.search(".//tr").each do |tr|
      arr = Array.new()
      tds = tr.search(".//td")

      # 本当にlength が9と10だけ？違ったらabort
      if tds.length == 9 or tds.length == 10 then
        #puts "length = #{tds.length}"
        #puts "current_month = #{current_month}"
        #puts "tds[1] = #{tds[1].text}"
        if tds[5].text.include?(word) then
        #if tds[1].text != current_month then
          #puts "-------------------------------------"
          #puts "#{tds[0].text}.#{tds[1].text}.#{tds[2].text}.#{tds[5].text}"
          #puts tds[2].text
          #puts "-------------------------------------"
          #arr.push(tds[0].text,tds[1].text,tds[2].text)
          arr.push(tds[2].text)
          csv << arr.to_csv
        end
      else
        puts "error record is: #{tds.text}"
        abort
      end

    end
  end
  puts "#{url_year} / 2040"
end


File.open('export.csv', 'w') do |io|
  io.write csv
  puts "export.csv file was made"
end

puts "Done"


