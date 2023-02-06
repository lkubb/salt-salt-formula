# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ tplroot }}.libs
{%- if "repos" in salt_["lookup"] %}
  - {{ tplroot }}.repo
{%- endif %}

Salt master is installed:
  pkg.installed:
    - name: {{ salt_.lookup.pkg.master.format(pyver=salt_.pyver) }}
    - version: {{ salt_.version or "null" }}
{%- if "repos" in salt_["lookup"] %}
    - require:
      - Salt repo is configured
{%- endif %}
