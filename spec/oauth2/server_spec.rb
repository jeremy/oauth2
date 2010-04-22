require 'spec_helper'

describe OAuth2::Server do
  let(:strategy) { OAuth2::ServerStrategy::Memory.new }
  let(:app1)     { strategy.app! }
  let(:app2)     { strategy.app! }
  let(:code)     { app1.code!    }
  let(:token)    { app1.token!   }

  it "authorizes a request for a temporary code" do
    server = OAuth2::Server.new(app1.id, :strategy => strategy, :redirect_uri => app1.redirect_uri, :type => 'web_server')
    server.temporary_code.should_not == nil
  end

  it "authorizes a code and returns an access token" do
    server = OAuth2::Server.new(app1.id, :strategy => strategy, :redirect_uri => app1.redirect_uri, :type => 'web_server',
      :code => code)
    server.access_token.should_not == nil
  end
end