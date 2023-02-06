# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_master_config = tplroot ~ ".master.config.file" %}
{%- set sls_cert_managed = tplroot ~ ".api.cert.managed" %}
{%- set sls_master_running = tplroot ~ ".master.service.running" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_master_config }}
  - {{ sls_cert_managed }}
  - {{ sls_master_running }}

Salt API is running:
  service.running:
    - name: {{ salt_.lookup.service.api }}
    - enable: True
    - watch:
      - sls: {{ sls_master_config }}
      - sls: {{ sls_cert_managed }}
    - require:
      - sls: {{ sls_master_running }}
