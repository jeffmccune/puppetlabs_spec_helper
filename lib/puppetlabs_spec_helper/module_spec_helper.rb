require 'rspec-puppet'
require 'puppetlabs_spec_helper/puppet_spec_helper'

# We need to require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_seams' so
# that all Puppet modules have easy access to
# PuppetlabsSpec::PuppetSeams.new.scope_for_test_harness  The expectation is
# that all Puppet modules require puppetlabs_spec_helper/module_spec_helper
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_seams'

def param_value(subject, type, title, param)
  subject.resource(type, title).send(:parameters)[param.to_sym]
end

def verify_contents(subject, title, expected_lines)
  content = subject.resource('file', title).send(:parameters)[:content]
  (content.split("\n") & expected_lines).should == expected_lines
end

fixture_path = File.expand_path(File.join(Dir.pwd, 'spec/fixtures'))

env_module_path = ENV['MODULEPATH']
module_path = File.join(fixture_path, 'modules')

module_path = [module_path, env_module_path].join(':') if env_module_path

RSpec.configure do |c|
  c.module_path = module_path
  c.manifest_dir = File.join(fixture_path, 'manifests')
  # The hiera config file seems to drop the top path component
  # from this option, so we need to add a dummy component to 
  # make everything work correctly
  c.config = File.join(fixture_path, 'heira')
end
