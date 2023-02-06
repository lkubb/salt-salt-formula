# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".api.service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_service_clean }}

Salt API key/cert is absent:
  file.absent:
    - names:
      - {{ salt_.api.cert.cert_key }}
      - {{ salt_.api.cert.cert_path }}
    - require:
      - sls: {{ sls_service_clean }}
