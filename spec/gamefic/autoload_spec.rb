# frozen_string_literal: true

RSpec.describe Gamefic::Autoload do
  it 'has a version number' do
    expect(Gamefic::Autoload::VERSION).not_to be nil
  end

  it 'encodes setups' do
    require_relative '../fixtures/example/project'
    codes = Gamefic::Autoload.encode_all
    expect(codes).to include("require 'sidepiece'")
    expect(codes).to include("require 'project/submodule'")
    expect(codes).to include('module Project::Unnamed; end')
    expect(codes).to include("require 'project/unnamed/shortnamed'")
  end
end
