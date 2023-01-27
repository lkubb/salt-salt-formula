# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.master.config.clean' %}
{%- set sls_api_clean = tplroot ~ ".api.package.clean" %}
{%- set sls_syndic_clean = tplroot ~ ".syndic.package.clean" %}
{%- set sls_ssh_clean = tplroot ~ ".ssh.package.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_config_clean }}
  - {{ sls_api_clean }}
  - {{ sls_syndic_clean }}
  - {{ sls_ssh_clean }}

Salt master is removed:
  pkg.removed:
    - name: {{ salt_.lookup.pkg.master.format(pyver=salt_.pyver) }}
    - require:
      - sls: {{ sls_config_clean }}
      - sls: {{ sls_api_clean }}
      - sls: {{ sls_syndic_clean }}
      - sls: {{ sls_ssh_clean }}
