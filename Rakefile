require 'rubygems'
require 'bundler'
require 'rake'

# appraisal
require 'appraisal'

# build, install, release
require 'bundler/gem_tasks'

# spec
require File.expand_path('../spec/suite', __FILE__)
SpecSuite.new.define_tasks(self)
task :default => ['appraisal:install', :spec]

task :package_tests do
  require File.expand_path('../lib/rr/version', __FILE__)
  require 'aws/s3'
  require 'archive/tar/minitar'
  require 'dotenv'

  Dotenv.load
  AWS.config(
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  )

  file_path = File.join(Dir.tmpdir, "rr-#{RR.version}-tests.tar")
  File.open(file_path, 'wb') do |fh|
    Zlib::GzipWriter.open(fh) do |zfh|
      Archive::Tar::Minitar.pack('spec', zfh)
    end
  end
  puts "Wrote to #{file_path}."

  remote_file_path = "v#{RR.version}.tar.gz"
  bucket_name = 'rubygem-rr/tests'
  puts "Uploading #{file_path} to s3.amazonaws.com/#{bucket_name}/#{remote_file_path} ..."
  s3 = AWS::S3.new
  bucket = s3.buckets[bucket_name]
  object = bucket.objects[remote_file_path]
  File.open(file_path, 'rb') {|f| object.write(f) }
  object.acl = :public_read
end
task :release => :package_tests
