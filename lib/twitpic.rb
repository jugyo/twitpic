require "net/https"
require "uri"
require 'mime/types'
require "rexml/document"

class TwitPic
  VERSION = '0.3.1'

  class APIError < StandardError; end

  def initialize(username, password)
    @username = username
    @password = password
  end

  def upload(file_path, message = nil, boundary = "----------------------------TwitPic#{rand(1000000000000)}")
    parts = {
      :username => @username,
      :password => @password
    }
    parts[:message] = message if message && !message.empty?

    body = create_body(parts, file_path, boundary)

    url = 
      if parts[:message]
        'http://twitpic.com/api/uploadAndPost'
      else
        'http://twitpic.com/api/upload'
      end

    post(url, body, boundary)
  end

  def post(url, body, boundary)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    xml = http.start do |http|
      headers = {"Content-Type" => "multipart/form-data; boundary=" + boundary}
      response = http.post(uri.path, body, headers)
      response.body
    end
    parse_response(xml)
  end

  def parse_response(xml)
    doc = REXML::Document.new(xml)
    error_element = REXML::XPath.match(doc, "/rsp/err").first
    if error_element
      raise APIError, error_element.attribute('code').value + ': ' + error_element.attribute('code').value
    else
      result = {}
      [:statusid, :userid, :mediaid, :mediaurl].each do |key|
        result[key] = REXML::XPath.match(doc, "/rsp/#{key}").first.text rescue nil
      end
      result
    end
  end

  def content_type
    type = MIME::Types.type_for(file_path).first
    if type
      type.content_type
    else
      'image/png'
    end
  end

  def create_body(parts, file_path, boundary)
    parts[:media] = open(file_path, 'rb').read
    body = ''
    [:media, :username, :password, :message].each do |key|
      value = parts[key]
      next unless value
      body << "--#{boundary}\r\n"
      if key == :media
        body << "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{File.basename(file_path)}\"\r\n"
        body << "Content-Type: #{content_type}\r\n"
      else
        body << "Content-Disposition: form-data; name=\"#{key}\"\r\n"
      end
      body << "\r\n"
      body << "#{value}\r\n"
    end
    body << "--#{boundary}--\r\n"
  end
end
