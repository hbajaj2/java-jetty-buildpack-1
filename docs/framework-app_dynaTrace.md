# DynaTrace Agent Framework
The DynaTrace Agent Framework causes an application to be automatically configured to work with a bound DynaTrace Service.

<table>
  <tr>
    <td><strong>Detection Criterion</strong></td><td>Existence of a single bound DynaTrace service. The existence of an DynaTrace service defined by the <a href="http://docs.cloudfoundry.com/docs/using/deploying-apps/environment-variable.html#VCAP_SERVICES"><code>VCAP_SERVICES</code></a> payload containing a service name, label or tag with <code>dynatrace</code> as a substring.
</td>
  </tr>
</table>

## User-Provided Service
When binding DynaTrace using a user-provided service, it must have name or tag with `dynatrace` in it.  The credential payload can contain the following entries:

| Name | Description
| ---- | -----------
| `host` | The collector host name

## Configuration
For general information on configuring the buildpack, refer to [Configuration and Extension][].

The framework can be configured by modifying the [`config/dynatrace_agent.yml`][] file in the buildpack fork.  The framework uses the [`Repository` utility support][repositories] and so it supports the [version syntax][] defined there.

| Name | Description
| ---- | -----------
| `repository_root` | The URL of the AppDynamics repository index ([details][repositories]).
| `version` | The version of AppDynamics to use. Candidate versions can be found in [this listing][].
