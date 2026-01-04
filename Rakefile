# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
rescue LoadError
  # rubocop not available in cross-compilation environment
end

begin
  require "rake/extensiontask"

  def detect_go_platform
    cpu = RbConfig::CONFIG["host_cpu"]
    os = RbConfig::CONFIG["host_os"]

    arch = case cpu
           when /aarch64|arm64/ then "arm64"
           when /x86_64|amd64/ then "amd64"
           when /arm/ then "arm"
           when /i[3-6]86/ then "386"
           else cpu
           end

    goos = case os
           when /darwin/ then "darwin"
           when /mswin|mingw/ then "windows"
           else "linux"
           end

    "#{goos}_#{arch}"
  end

  namespace :go do
    desc "Build Go archive for current platform"
    task :build do
      platform = detect_go_platform
      output_dir = "go/build/#{platform}"
      FileUtils.mkdir_p(output_dir)
      sh "cd go && CGO_ENABLED=1 go build -buildmode=c-archive -o build/#{platform}/libcharm_native.a ."
    end

    desc "Clean Go build artifacts"
    task :clean do
      FileUtils.rm_rf("go/build")
    end

    desc "Format Go source files"
    task :fmt do
      sh "gofmt -s -w go/"
    end

    desc "Download Go dependencies"
    task :deps do
      sh "cd go && go mod download"
    end
  end

  Rake::ExtensionTask.new do |ext|
    ext.name = "charm_native"
    ext.ext_dir = "ext/charm_native"
    ext.lib_dir = "lib/charm_native"
    ext.source_pattern = "**/*.c"
    ext.gem_spec = Gem::Specification.load("charm-native.gemspec")
    ext.cross_compile = false
  end
rescue LoadError => e
  desc "Compile task not available (rake-compiler not installed)"
  task :compile do
    puts e
    abort <<~MESSAGE

      rake-compiler is required for this task.

      Are you running `rake` using `bundle exec rake`?

      Otherwise:
        * try to run bundle install
        * add it to your Gemfile
        * or install it with: gem install rake-compiler
    MESSAGE
  end
end

task default: [:test, :rubocop, :compile]
