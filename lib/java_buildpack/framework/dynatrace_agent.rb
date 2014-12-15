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

require 'fileutils'
require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/framework'

module JavaBuildpack
  module Framework

    # Encapsulates the functionality for enabling zero-touch AppDynamics support.
    class DynatraceAgent < JavaBuildpack::Component::VersionedDependencyComponent

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        download_jar
        shell "unzip -qq #{@droplet.sandbox + jar_name} -d #{@droplet.sandbox} 2>&1"
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        @droplet.java_opts << ("-agentpath:$PWD/#{(@droplet.sandbox + 'agent/linux-x86-64/agent/lib64/libdtagent.so').relative_path_from(@droplet.root)}" +
            "=name=#{application_name},server=#{host}")
      end

      protected

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      def supports?
        @application.services.one_service? FILTER, 'host'
      end

      private

      FILTER = /dynatrace/.freeze

      def application_name
        if env_name.nil? || env_name.empty?
          @application.details['application_name']
        else
          "yaas_#{env_name}_#{@application.details['application_name']}"
        end
      end

      def host
        @application.services.find_service(FILTER)['credentials']['host']
      end

      def env_name
        ENV['ENV_NAME']
      end

    end

  end
end
