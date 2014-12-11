# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require 'component_helper'
require 'fileutils'
require 'java_buildpack/container/jetty'
require 'java_buildpack/container/jetty/jetty_instance'

describe JavaBuildpack::Container::Jetty do
  include_context 'component_helper'

  let(:component) { StubJetty.new context }

  let(:configuration) do
    { 'jetty'                 => jetty_configuration }
  end

  let(:jetty_configuration) { double('jetty-configuration') }

  it 'detect WEB-INF',
     app_fixture: 'container_jetty' do

    expect(component.supports?).to be
  end

  it 'do not detect when WEB-INF is absent',
     app_fixture: 'container_main' do

    expect(component.supports?).not_to be
  end

  it 'do not detect when WEB-INF is present in a Java main application',
     app_fixture: 'container_main_with_web_inf' do

    expect(component.supports?).not_to be
  end

  it 'create submodules' do
    expect(JavaBuildpack::Container::JettyInstance)
    .to receive(:new).with(sub_configuration_context(jetty_configuration))

    component.sub_components context
  end

  it 'return command' do

    expect(component.command).to eq("JETTY_ARGS=jetty.port=$PORT JETTY_BASE=. JAVA=#{(java_home.root + '/bin/java')} "\
        "#{java_home.as_env_var} $PWD/.java-buildpack/jetty/bin/jetty.sh run")
  end

end

class StubJetty < JavaBuildpack::Container::Jetty

  public :command, :sub_components, :supports?

end

def sub_configuration_context(configuration)
  c                 = context.clone
  c[:configuration] = configuration
  c
end
