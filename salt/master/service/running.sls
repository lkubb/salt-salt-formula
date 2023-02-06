# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".master.config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_config_file }}

Salt master is running:
  service.running:
    - name: {{ salt_.lookup.service.master }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
