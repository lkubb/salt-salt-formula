# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

Salt syndic is dead:
  service.dead:
    - name: {{ salt_.lookup.service.syndic }}
    - enable: False
