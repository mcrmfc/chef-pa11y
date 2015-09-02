require 'chefspec'
require_relative 'spec_helper'

describe 'pa11y::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'includes the nodejs::npm recipe' do
    expect(chef_run).to include_recipe('nodejs::npm')
  end

  it 'includes the mongodb recipe' do
    expect(chef_run).to include_recipe('mongodb3')
  end

  it 'includes the phantomjs recipe' do
    expect(chef_run).to include_recipe('phantomjs::default')
  end

  it 'includes the git recipe' do
    expect(chef_run).to include_recipe('git')
  end

  it 'creates directory to clone pa11y into' do
    expect(chef_run).to create_directory('/usr/local/pa11y-dashboard')
  end

  it 'creates pa11y user' do
    expect(chef_run).to create_user('pa11y')
  end

  it 'creates pa11y group' do
    expect(chef_run).to create_group('pa11y')
  end

  it 'should execute git clone into the pa11y-dashboard directory' do
    expect(chef_run).to sync_git('/usr/local/pa11y-dashboard').with_user('pa11y')
  end

  it 'creates config files for production, development and test' do
    expect(chef_run).to render_file('/usr/local/pa11y-dashboard/config/test.json')
    expect(chef_run).to render_file('/usr/local/pa11y-dashboard/config/production.json')
    expect(chef_run).to render_file('/usr/local/pa11y-dashboard/config/development.json')
  end

  it 'creates pa11y service' do
    expect(chef_run).to enable_service('pa11y')
  end
end
