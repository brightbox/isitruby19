require 'rubygems'
require 'spec'
require 'active_record'
require 'fileutils'

require File.join(File.dirname(__FILE__), *%w[../lib/demeters_revenge])

module Kernel
  def with_silent_output(&block)
    $stdout = StringIO.new
    yield
    $stdout = STDOUT
  end
end

module ExampleSpecHelper
  def self.create_example_database(&schema_block)
    ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3',
      :database => 'examples.db'
    )
    with_silent_output do
      ActiveRecord::Schema.define(&schema_block) if block_given?
    end
  end
  
  def self.destroy_example_database
    FileUtils.rm('examples.db')
  end
end