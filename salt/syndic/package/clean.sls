# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.syndic.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_service_clean }}

Salt syndic is removed:
  pkg.removed:
    - name: {{ salt_.lookup.pkg.syndic.format(pyver=salt_.pyver) }}
    - require:
      - sls: {{ sls_service_clean }}
