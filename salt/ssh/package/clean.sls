# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.ssh.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_config_clean }}

salt-ssh is removed:
  pkg.removed:
    - name: {{ salt_.lookup.pkg.ssh.format(pyver=salt_.pyver) }}
    - require:
      - sls: {{ sls_config_clean }}
