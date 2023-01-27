# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

{%- for env, formulae in salt_.formulae.present.items() %}
{%-   set base_config = salt_.formulae.config.get(env, salt_.formulae.config.default) %}
{%-   for formula in formulae %}
{%-     set f_name = formula if formula is not mapping else formula | first %}
{%-     set f_options = {} if formula is not mapping else formula[f_name] %}
{%-     set f_options = salt["defaults.merge"](base_config, f_options, in_place=false) %}
{%-     if not f_options["basedir"].startswith("/") %}
{%-       do f_options.update({"basedir": salt_.lookup.srv | path_join(f_options["basedir"])}) %}
{%-     endif %}
{%-     set target = f_options | traverse("args:target", f_options["basedir"] | path_join(f_name)) %}

Formula {{ f_name }} in {{ env }} is absent:
  file.absent:
    - name: {{ target }}
{%-   endfor %}
{%- endfor %}
