# -*- encoding: utf-8 -*-

class HatenaController < ApplicationController

  API_URL = "http://b.hatena.ne.jp/entry/json/"
  #STAR = "http://s.st-hatena.com/entry.count.image?uri="

  def search
    require 'open-uri'
    require 'json'

    parsed=['']
    @url = params[:url]
    @timestamps = Array.new(parsed.length)
    @comments = Array.new(parsed.length)
    @users = Array.new(parsed.length)
    @tags = Array.new(parsed.length)
    
    

    if @url.blank?
      @url = ""
      @alert = "URLを入力してください。"
      return
    end
    
    

    # 入力されたURLをJSONで展開する
    begin
      @url =URI.decode(@url)
      html = open(API_URL+@url).read
      json = JSON.parser.new(html)
      hash=json.parse()
    rescue
      @alert="まだブックマークされていないかURLが間違っています。\n正しく入力してください。"
      return
    end

    if hash.present?
      parsed = hash['bookmarks']
      @title = hash['title']
      @entry_url = hash['entry_url']
      

    else
      @alert="データがありません。"
      return
    end
    
    begin
    parsed.each_with_index do |item, i|
      @timestamps[i] = item['timestamp']
      @comments[i] = item['comment']
      @users[i] = item['user']
      @tags[i] = item['tags']
    end  
    rescue
      @alert="コメント一覧を非表示に設定されているみたいです。"
    return
    end
  end


  def display
    @scraps = Scrap.all
  end
end