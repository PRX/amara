# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/test_helper')

describe Amara::Client do

  it "returns a teams api object" do
    amara = Amara::Client.new
    amara.teams.wont_be_nil
  end

end
