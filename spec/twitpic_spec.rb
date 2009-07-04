require 'rubygems'
require File.dirname(__FILE__) + '/../lib/twitpic'

describe TwitPic do
  before(:each) do
    @twitpic = TwitPic.new('test', 'password')
  end

  it 'should create body for upload' do
    file_path =File.dirname(__FILE__) + '/test.txt'
    body = @twitpic.create_body(
              {:username => 'test', :password => 'password', :media => file_path},
              file_path,
              'boundary'
            )
    body.should == <<-EOS
--boundary\r
Content-Disposition: form-data; name="media"; filename="test.txt"\r
Content-Type: text/plain\r
\r
test
test\r
--boundary\r
Content-Disposition: form-data; name="username"\r
\r
test\r
--boundary\r
Content-Disposition: form-data; name="password"\r
\r
password\r
--boundary--\r
    EOS
  end

  describe 'response data is valid' do
    before(:each) do
      @xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<rsp status="ok">
  <statusid>1111</statusid>
  <userid>11111</userid>
  <mediaid>abc123</mediaid>
  <mediaurl>http://twitpic.com/abc123</mediaurl>
</rsp>
      XML
    end

    it 'should parse xml' do
      result = @twitpic.parse_response(@xml)
      result.should == {:statusid=>"1111", :userid=>"11111", :mediaid=>"abc123", :mediaurl=>"http://twitpic.com/abc123"}
    end
  end

  describe 'response data is invalid' do
    before(:each) do
      @xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<rsp stat="fail">
  <err code="1001" msg="Invalid twitter username or password" />
</rsp>
      XML
    end

    it 'should raise error' do
      lambda {@twitpic.parse_response(@xml)}.should raise_error(TwitPic::APIError)
    end
  end

  describe 'with message' do
    it 'should call method "post"' do
      file_path = File.dirname(__FILE__) + '/test.txt'
      @twitpic.should_receive(:post).once do |url, body, boundary|
        url.should == 'http://twitpic.com/api/uploadAndPost'
      end
      @twitpic.upload(file_path, 'test')
    end
  end

  describe 'without message' do
    it 'should call method "post"' do
      file_path = File.dirname(__FILE__) + '/test.txt'
      @twitpic.should_receive(:post).once do |url, body, boundary|
        url.should == 'http://twitpic.com/api/upload'
      end
      @twitpic.upload(file_path)
    end
  end
end
