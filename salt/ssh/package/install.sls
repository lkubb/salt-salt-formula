# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

{%- if "repos" in salt_["lookup"] %}

include:
  - {{ tplroot }}.repo
{%- endif %}

salt-ssh is installed:
  pkg.installed:
    - name: {{ salt_.lookup.pkg.ssh.format(pyver=salt_.pyver) }}
    - version: {{ salt_.version or "null" }}
{%- if "repos" in salt_["lookup"] %}
    - require:
      - Salt repo is configured
{%- endif %}
