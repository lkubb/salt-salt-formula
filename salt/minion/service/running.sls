# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".minion.config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_config_file }}

Salt minion is enabled:
  service.enabled:
    - name: {{ salt_.lookup.service.minion }}
    - require:
      - sls: {{ sls_config_file }}

Restart Salt minion:
  cmd.run:
{%- if grains["kernel"] == "Windows" %}
    - name: salt-call.bat service.restart salt-minion
{%- else %}
    - name: sleep 10; salt-call service.restart salt-minion 2>&1 >/dev/null
{%- endif %}
    - bg: true
    - order: last
    - onchanges:
      - sls: {{ sls_config_file }}
