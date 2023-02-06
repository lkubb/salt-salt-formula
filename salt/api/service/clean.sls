# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

Salt API is dead:
  service.dead:
    - name: {{ salt_.lookup.service.api }}
    - enable: False
