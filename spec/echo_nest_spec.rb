require File.join(File.dirname(__FILE__), '..', 'song')

describe EchoNest::Song do
  API_KEY = "ABCDEFGHIJKL"

  context "instance" do
    let(:echo) { EchoNest::Song.new }
    context "public" do
      context "search" do
        it "should search for songs" do
          echo.should_receive(:build_url).with("/song/search?", {})
          echo.search
        end
      end
      context "profile" do
        it "should request song profile" do
          echo.should_receive(:build_url).with("/song/profile?", :id => 'id')
          echo.profile(:id => 'id')
        end
      end
    end
    context "private" do
      context "build_url" do
        it "should substitute spaces with plus signs for artist name" do
          echo.send(:build_url, 'query', :artist => "some artist").should == "http://developer.echonest.com/api/v4query&artist=some+artist"
        end
        it "should add all provided options to the url string" do
          echo.send(:build_url, 'query', :key => 'val', :artist => 'bob', :sort => 'tempo-asc').should == "http://developer.echonest.com/api/v4query&key=val&artist=bob&sort=tempo-asc"
        end
      end
      context "handle_opts" do
        it "should accept good options" do
          lambda { echo.send(:handle_opts, :bucket => ["song_type"]) }.should_not raise_error(ArgumentError)
          lambda { echo.send(:handle_opts, :sort => "tempo-asc") }.should_not raise_error(ArgumentError)
        end
        it "should raise errors with bad options" do
          lambda { echo.send(:handle_opts, :bucket => ["bucket"] ) }.should raise_error(ArgumentError)
          lambda { echo.send(:handle_opts, :sort => "sort") }.should raise_error(ArgumentError)
        end
      end
      context "api_string" do
        it "should return the api string" do
          echo.send(:api_string).should == "&api_key=ABCDEFGHIJKL"
        end
      end
    end
  end
end