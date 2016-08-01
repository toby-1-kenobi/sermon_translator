require 'uri'

class EverythingController < ApplicationController

  def home

  end

  def translation
    sermon_chunks = chunk_text_by_sentence(params[:sermon], 3000)
    g_translate_url = 'https://www.googleapis.com/language/translate/v2'
    g_translate_source = 'en'
    g_translate_target = 'de'
    @translation = ''
    sermon_chunks.each do |chunk|
      response = HTTParty.get(
          "#{g_translate_url}?" +
              "key=#{Rails.application.secrets.G_TRANSLATE_KEY}" +
              "&source=#{g_translate_source}" +
              "&target=#{g_translate_target}" +
              "&q=#{URI.encode chunk}"
      )
      @translation += ' ' + response['data']['translations'][0]['translatedText']
    end
  end

  private

  def chunk_text_by_sentence(text, char_limit)
    sentences = text.split('.')
    chunks = Array.new
    chunk = ''
    sentences.each do |sentence|
      if chunk.size + sentence.size > char_limit
        chunks << chunk
        chunk = ''
      end
      chunk += sentence
    end
    if chunk.present?
      chunks << chunk
    end
    return chunks
  end

end
