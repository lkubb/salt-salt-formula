# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.master.service.clean' %}
{%- set sls_api_clean = tplroot ~ ".api.cert.clean" %}
{%- set sls_ssh_clean = tplroot ~ ".ssh.config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_service_clean }}
  - {{ sls_api_clean }}
  - {{ sls_ssh_clean }}

Salt master configuration is absent:
  file.absent:
    - name: {{ salt_.lookup.config.master }}
    - require:
      - sls: {{ sls_service_clean }}
      - sls: {{ sls_api_clean }}
      - sls: {{ sls_ssh_clean }}
