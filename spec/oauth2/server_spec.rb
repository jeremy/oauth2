require 'spec_helper'

describe OAuth2::Server do
  let(:strategy) { OAuth2::ServerStrategy::Memory.new }
  let(:app1)     { strategy.app!        }
  let(:app2)     { strategy.app!        }
  let(:code)     { app1.code!( :a => 1) }
  let(:token)    { app1.token!(:b => 1) }

  describe "authorizing a request" do
    subject { OAuth2::Server.new(app1.id, :strategy => strategy, :redirect_uri => app1.redirect_uri, :type => 'web_server') }

    it "returns a temporary code" do
      subject.temporary_code.should_not == nil
    end
  end

  describe "authorizing a code" do
    subject { OAuth2::Server.new(app1.id, :strategy => strategy, :redirect_uri => app1.redirect_uri, :type => 'web_server',  :code => code) }

    it "returns an access token" do
      subject.access_token.should_not == nil
    end

    it "passes code options to token" do
      strategy.access_token_options(subject.access_token).should == {:a => 1, :app => app1}
    end
  end

  describe "accessing an authorized token" do
    subject { strategy }

    it "returns token options" do
      subject.access_token_options(token).should == {:b => 1, :app => app1}
    end
  end
end