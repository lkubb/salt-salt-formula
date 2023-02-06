# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".minion.config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_config_clean }}
  - {{ tplroot }}.repo.clean

{%- if grains["os"] == "MacOS" %}

Salt macpackage cannot be uninstalled automatically:
  test.fail_without_changes

{%- else %}

Salt minion is removed:
  pkg.removed:
    - name: {{ salt_.lookup.pkg.minion.format(pyver=salt_.pyver) }}
    - require:
      - sls: {{ sls_config_clean }}
{%- endif %}
