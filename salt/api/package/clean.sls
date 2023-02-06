# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_cert_clean = tplroot ~ ".api.cert.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_cert_clean }}

Salt API is removed:
  pkg.removed:
    - name: {{ salt_.lookup.pkg.api.format(pyver=salt_.pyver) }}
    - require:
      - sls: {{ sls_cert_clean }}
