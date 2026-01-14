# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

namespace :workspace do
  REPOS = {
    "bubbles-ruby" => %w[bubbletea harmonica lipgloss charm-native],
    "bubbletea-ruby" => %w[bubbles glamour harmonica lipgloss charm-native],
    "glamour-ruby" => %w[charm-native],
    "huh-ruby" => %w[bubbles bubbletea glamour harmonica lipgloss charm-native],
    "lipgloss-ruby" => %w[charm-native]
  }.freeze

  desc "Clone charm-ruby sibling repos next to charm-native (set OWNER=esmarkowski)"
  task :clone do
    owner = ENV.fetch("OWNER", "esmarkowski")
    root = File.expand_path("..", __dir__)

    REPOS.keys.each do |repo|
      target = File.join(root, repo)
      next if Dir.exist?(target)

      sh "git clone https://github.com/#{owner}/#{repo}.git #{target}"
    end
  end

  desc "Configure Bundler local overrides in sibling repos (bundle config set local.* ../<repo>)"
  task :bundle_local do
    root = File.expand_path("..", __dir__)

    REPOS.each do |repo_dir, gems|
      repo_path = File.join(root, repo_dir)
      next unless File.exist?(File.join(repo_path, "Gemfile"))

      Dir.chdir(repo_path) do
        gems.each do |gem_name|
          relative_path = case gem_name
                          when "bubbles" then "../bubbles-ruby"
                          when "bubbletea" then "../bubbletea-ruby"
                          when "glamour" then "../glamour-ruby"
                          when "gum" then "../gum-ruby"
                          when "harmonica" then "../harmonica-ruby"
                          when "huh" then "../huh-ruby"
                          when "lipgloss" then "../lipgloss-ruby"
                          when "ntcharts" then "../ntcharts-ruby"
                          when "charm-native" then "../charm-native"
                          else
                            abort "Unknown gem name for local override: #{gem_name}"
                          end

          sh "bundle config set local.#{gem_name} #{relative_path}"
        end
      end
    end
  end

  desc "Clone repos and configure Bundler local overrides"
  task setup: [:clone, :bundle_local]
end

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
