require 'zeus/rails'

# This custom plan (and the zeus.json file altogether) allows us
# to use zeus and rspec without rails...
# 
# However, there is one gotcha: zeus only can execute correctly
# if we use a Gemfile with zeus and install the dependencies
# as binstubs. Otherwise, Zeus will never load the commands.
# 
# To install as binstubs, use
# 
#   bundle install --binstubs
# 
# Then, run:
# 
#   bin/zeus start
# 
# because the binstubs puts the gem executables
# into bin/ folder

class CustomPlan < Zeus::Plan

  def boot
  end
  
  def default_env
    require 'sunat/dependencies'
  end
  
  def test_helper
    require_relative 'spec/spec_helper'
  end
  
  def test(argv=ARGV)
    RSpec::Core::Runner.disable_autorun!
    exit RSpec::Core::Runner.run(argv)
  end
  
  def prerake
    require 'rake'
    require "bundler/gem_tasks"
    require 'annotations/rake_task'
  end

  def rake
    Rake.application.run
	end

end

Zeus.plan = CustomPlan.new
