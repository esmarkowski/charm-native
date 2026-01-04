# frozen_string_literal: true

require_relative "native/version"

begin
  major, minor, _patch = RUBY_VERSION.split(".") #: [String, String, String]
  require_relative "../charm_native/#{major}.#{minor}/charm_native"
rescue LoadError
  require_relative "../charm_native/charm_native"
end

module Charm
  module Native
    class Error < StandardError; end
  end
end
