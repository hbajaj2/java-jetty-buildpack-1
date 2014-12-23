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

module JavaBuildpack
  module Container

    # Encapsulates the detect, compile, and release functionality for selecting an OpenJDK-like JRE.
    class JettyInstance < JavaBuildpack::Component::VersionedDependencyComponent

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context)
        super(context) { |candidate_version| candidate_version.check_size(3) }
      end

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        download_tar
        @droplet.copy_resources
        move_to(@application.root.children, root)
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
      end

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      def supports?
        true
      end

      private

      # Link a collection of files to a destination directory, using relative paths
      #
      # @param [Array<Pathname>] source the collection of files to link
      # @param [Pathname] destination the destination directory to link to
      # @return [Void]
      def move_to(source, destination)
        FileUtils.mkdir_p destination
        source.each do |path|
          unless path.to_s =~ /.*\/.java-buildpack/
            FileUtils.cp_r(path, destination)
          end
        end
      end

      def root
        @droplet.sandbox + 'webapps/ROOT'
      end

      def web_inf_lib
        @droplet.root + 'WEB-INF/lib'
      end
    end

  end
end
