# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/test_helper')

describe Amara::Client do

  it "returns a teams api object" do
    amara = Amara::Client.new
    amara.teams.wont_be_nil
  end

  it "returns a videos api object" do
    amara = Amara::Client.new
    amara.videos.wont_be_nil
  end

  it "returns a languages api object" do
    amara = Amara::Client.new
    amara.languages.wont_be_nil
  end

end
