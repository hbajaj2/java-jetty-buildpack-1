# Jetty Container
The Jetty Container allows servlet web applications to be run.  These applications are run as the root web application in a Jetty container.

<table>
  <tr>
    <td><strong>Detection Criterion</strong></td><td>Existence of a <tt>WEB-INF/</tt> folder in the application directory and <a href="container-java_main.md">Java Main</a> not detected</td>
  </tr>
  <tr>
    <td><strong>Tags</strong></td>
    <td><tt>jetty-instance=&lang;version&rang;</tt><i>(optional)</i></td>
  </tr>
</table>
Tags are printed to standard output by the buildpack detect script

## Configuration
For general information on configuring the buildpack, refer to [Configuration and Extension][].

The container can be configured by modifying the [`config/jetty.yml`][] file in the buildpack fork.  The container uses the [`Repository` utility support][repositories] and so it supports the [version syntax][] defined there.

### Additional Resources
The container can also be configured by overlaying a set of resources on the default distribution.  To do this, add files to the `resources/jetty` directory in the buildpack fork.  For example, to override the default `start.ini file to `resources/jetty/start.ini
