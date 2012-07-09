require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'bio-alignment'

require 'rspec/expectations'

log = Bio::Log::LoggerPlus.new 'bio-alignment'

Bio::Log::CLI.logger('stderr')
Bio::Log::CLI.trace('info')

