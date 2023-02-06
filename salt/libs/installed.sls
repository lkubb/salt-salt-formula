# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

{#- crude onedir check #}
{%- set onedir = grains["pythonexecutable"].endswith("/run") %}

{%- for lib in salt_.python_libs %}
{%-   set lib_name = lib if lib is not mapping else lib | first %}
{%-   set lib_conf = {} if lib is not mapping else lib[lib_name] %}

Python library {{ lib_name }} is installed:
{%-   if onedir or lib_conf.get("use_pip") %}
  pip.installed:
{%-   else %}
  pkg.installed:
{%-   endif %}
    - name: {{ lib_name }}
{%-   for opt, val in lib_conf.items() %}
{%-     if opt != "use_pip" %}
    - {{ opt }}: {{ val | json }}
{%-     endif %}
{%-   endfor %}
{%- endfor %}

{%- for lib in salt_.python_libs_absent %}
{%-   set lib_name = lib if lib is not mapping else lib | first %}
{%-   set lib_conf = {} if lib is not mapping else lib[lib_name] %}

Python library {{ lib_name }} is absent:
{%-   if onedir or lib_conf.get("use_pip") %}
  pip.removed:
{%-   else %}
  pkg.absent:
{%-   endif %}
    - name: {{ lib_name }}
{%-   for opt, val in lib_conf.items() %}
{%-     if opt != "use_pip" %}
    - {{ opt }}: {{ val | json }}
{%-     endif %}
{%-   endfor %}
{%- endfor %}
