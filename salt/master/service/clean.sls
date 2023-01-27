# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}
{%- set sls_api_clean = tplroot ~ ".api.service.clean" %}
{%- set sls_syndic_clean = tplroot ~ ".syndic.service.clean" %}

include:
  - {{ sls_api_clean }}
  - {{ sls_syndic_clean }}

Salt master is dead:
  service.dead:
    - name: {{ salt_.lookup.service.master }}
    - enable: False
    - require:
      - sls: {{ sls_api_clean }}
      - sls: {{ sls_syndic_clean }}
