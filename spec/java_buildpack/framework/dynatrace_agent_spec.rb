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
require 'java_buildpack/framework/dynatrace_agent'

describe JavaBuildpack::Framework::DynatraceAgent do
  include_context 'component_helper'

  it 'does not detect without dynatrace service available' do
    expect(component.detect).to be_nil
  end

  context do
    before do
      allow(services).to receive(:one_service?).with(/dynatrace/, 'host').and_return(true)
    end

    it 'detects with dynatrace service available' do
      expect(component.detect).to eq("dynatrace-agent=#{version}")
    end

    it 'downloads dynatrace agent JAR',
       cache_fixture: 'stub-dynatrace-agent.jar' do

      component.compile

      expect(sandbox + "dynatrace_agent-#{version}.jar").to exist
    end

    it 'updates JAVA_OPTS' do
      allow(services).to receive(:find_service).and_return('credentials' => { 'host' => '127.0.0.1'  })

      component.release

      expect(java_opts).to include("-agentpath:$PWD/.java-buildpack/dynatrace_agent/agent/linux-x86-64/agent/lib64/libdtagent.so=name=test-application-name,server=127.0.0.1")
    end

  end

end
