# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_master_config = tplroot ~ '.master.config.file' %}
{%- set sls_master_running = tplroot ~ '.master.service.running' %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_master_config }}
  - {{ sls_master_running }}

Salt syndic is running:
  service.running:
    - name: {{ salt_.lookup.service.syndic }}
    - enable: True
    - watch:
      - sls: {{ sls_master_config }}
    - require:
      - sls: {{ sls_master_running }}
