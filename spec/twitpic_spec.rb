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
