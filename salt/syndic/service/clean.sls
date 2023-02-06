# vim: ft=sls

{#-
    Stops/disables Salt syndic.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

Salt syndic is dead:
  service.dead:
    - name: {{ salt_.lookup.service.syndic }}
    - enable: False
