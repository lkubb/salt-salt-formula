# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

{%- if "repos" in salt_["lookup"] %}

include:
  - {{ tplroot }}.repo
{%- endif %}

{%- if grains["kernel"] not in ["Windows", "Darwin"] %}

Salt API is installed:
  pkg.installed:
    - name: {{ salt_.lookup.pkg.api.format(pyver=salt_.pyver) }}
    - version: {{ salt_.version or "null" }}
    - hold: {{ salt_._minor is not none }}
{%-   if "repos" in salt_["lookup"] %}
    - require:
      - Salt repo is configured
{%-   endif %}
{%- endif %}
