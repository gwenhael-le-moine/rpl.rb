# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
end

task :gem do
  sh 'gem build rpl.gemspec'
end

task :run do
  sh 'ruby -Ilib bin/rpl'
end
