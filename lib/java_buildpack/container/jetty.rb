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

require 'java_buildpack/component/modular_component'
require 'java_buildpack/container'
require 'java_buildpack/container/jetty/jetty_instance'


module JavaBuildpack
  module Container

    # Encapsulates the detect, compile, and release functionality for Jetty applications.
    class Jetty < JavaBuildpack::Component::ModularComponent

      protected

      # (see JavaBuildpack::Component::ModularComponent#command)
      def command
        [
          "JETTY_ARGS=jetty.port=$PORT",
          "JETTY_BASE=.",
          "JAVA=#{@droplet.java_home.root}/bin/java",
          @droplet.java_home.as_env_var,
          "$PWD/#{(@droplet.sandbox + 'bin/jetty.sh').relative_path_from(@droplet.root)}",
          'run'
        ].flatten.compact.join(' ')
      end

      # (see JavaBuildpack::Component::ModularComponent#sub_components)
      def sub_components(context)
        [
          JettyInstance.new(sub_configuration_context(context, 'jetty')),
        ]
      end

      # (see JavaBuildpack::Component::ModularComponent#supports?)
      def supports?
        web_inf? && !JavaBuildpack::Util::JavaMainUtils.main_class(@application)
      end

      private

      def web_inf?
        (@application.root + 'WEB-INF').exist?
      end

    end

  end
end
