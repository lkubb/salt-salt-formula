# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.minion.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_service_clean }}

Salt minion configuration is absent:
  file.absent:
    - name: {{ salt_.lookup.config.minion }}
    - require:
      - sls: {{ sls_service_clean }}
