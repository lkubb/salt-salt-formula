# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".master.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

{#- crude onedir check #}
{%- set onedir = grains["pythonexecutable"].startswith("/opt/saltstack") %}

{%- for lib in salt_.python_libs %}
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
