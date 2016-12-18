# coding: utf-8

require 'open-uri'
require 'csv'
require 'nokogiri'

master_url = 'https://moonlabo.com/cgi-bin/cln/cln_clm.cgi?OpDv=usd'

#urls = ["1910"]
urls = ["1910", "1920", "1930", "1940", "1950", "1960", "1970", \
       "1980", "1990", "2000", "2010", "2020", "2030", "2040"]

# initializing 
csv = ""
word = "月節"

# 10年単位でページが作られているので、そのページ分ループ
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
    # tr をserachしてtrの分だけループ
    node.search(".//tr").each do |tr|
      arr = Array.new()
      tds = tr.search(".//td")
      if tds[0].text != 1900 then
        # 本当にlength が9と10だけ？違ったらabort
        if tds.length == 9 or tds.length == 10 then
          # tds[5].text の中に word の文字列が含まれているか。
          # 月節が含まれていれば、その行は節入り日を表している。
          if tds[5].text.include?(word) then
            #puts "#{tds[0].text}.#{tds[1].text}.#{tds[2].text}"
            # arr に節入り日を入れて、CSVにわざわざしている。
            # 理由はまだない。
            arr.push(tds[2].text)
            csv << arr.to_csv
          end
        else
          puts "error record is: #{tds.text}"
          abort
        end
      end
    end
  end
  # 進捗を表すために付けた。
  puts "#{url_year} / 2040"
end


# Export file (File type is CSV)
File.open('export.csv', 'w') do |io|
  io.write csv
  puts "export.csv file was made"
end

puts "Done"


