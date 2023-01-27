# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

salt-ssh roster is absent:
  file.absent:
    - name: {{ salt_.lookup.config.ssh }}
