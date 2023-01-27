# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
{%- if salt_.lookup.pkg_manager in ['apt', 'dnf', 'yum'] %}
  - {{ slsdotpath }}.managed
{%- elif salt['state.sls_exists'](slsdotpath ~ '.' ~ salt_.lookup.pkg_manager) %}
  - {{ slsdotpath }}.{{ salt_.lookup.pkg_manager }}
{%- else %}
  []
{%- endif %}

# Make this file itself requirable
Salt repo is configured:
{%- if salt_.lookup.pkg_manager in ['apt', 'dnf', 'yum'] %}
  test.nop:
  - require:
    - sls: {{ slsdotpath }}.managed
{%- elif salt['state.sls_exists'](slsdotpath ~ '.' ~ salt_.lookup.pkg_manager) %}
  test.nop:
  - require:
    - sls: {{ slsdotpath }}.{{ salt_.lookup.pkg_manager }}
{%- else %}
  test.nop
{%- endif %}
