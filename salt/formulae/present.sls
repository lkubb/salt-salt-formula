# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

{%- set file_roots = {} %}
{%- set rendered_basedirs = [] %}

{%- for env, formulae in salt_.formulae.present.items() %}
{%-   do file_roots.update({env: []}) %}
{%-   set base_config = salt_.formulae.config.get(env, salt_.formulae.config.default) %}
{%-   for formula in formulae %}
{%-     set f_name = formula if formula is not mapping else formula | first %}
{%-     set f_options = {} if formula is not mapping else formula[f_name] %}
{%-     set f_options = salt["defaults.merge"](base_config, f_options, in_place=false) %}
{%-     if not f_options["basedir"].startswith("/") %}
{%-       do f_options.update({"basedir": salt_.lookup.srv | path_join(f_options["basedir"])}) %}
{%-     endif %}
{%-     set target = f_options | traverse("args:target", f_options["basedir"] | path_join(f_name)) %}
{%-     do file_roots[env].append(target) %}
{%-     set basedir = salt["file.dirname"](target) %}
{%-     if basedir not in rendered_basedirs %}
{%-       do rendered_basedirs.append(basedir) %}

Basedir for {{ f_name }} in {{ env }} exists:
  file.directory:
    - name: {{ basedir }}
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - mode: '0755'
    - makedirs: true
{%-     endif %}

Formula {{ f_name }} in {{ env }} is present:
  git.{{ "latest" if f_options.get("update", true) else "cloned" }}:
    - name: {{ f_options | traverse("args:name", f_options["baseurl"] ~ "/" ~ f_name ~ ".git") }}
    - target: {{ target }}
{%-     for arg, val in f_options.get("args", {}).items() %}
{%-       if arg in ["name", "target"] %}
{%-         continue %}
{%-       endif %}
    - {{ arg }}: {{ val | json }}
{%-     endfor %}
    - require:
      - file: {{ basedir }}
{%-   endfor %}
{%- endfor %}
