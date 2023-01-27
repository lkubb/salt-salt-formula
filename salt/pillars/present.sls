# -*- coding: utf-8 -*-
# vim: ft=sls

# Pillar "formulae" managed by this formula can be useful to circumvent
# limitations with git_pillar, as is done for states and the
# git fileserver backend.

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

{%- set pillar_roots = {} %}
{%- set rendered_basedirs = [] %}
{%- set clear_pillar_cache = [] %}
{%- set refresh_pillar = [] %}

{%- for env, formulae in salt_.pillars.present.items() %}
{%-   do pillar_roots.update({env: []}) %}
{%-   set base_config = salt_.pillars.config.get(env, salt_.pillars.config.default) %}
{%-   for formula in formulae %}
{%-     set f_name = formula if formula is not mapping else formula | first %}
{%-     set f_options = {} if formula is not mapping else formula[f_name] %}
{%-     set f_options = salt["defaults.merge"](base_config, f_options, in_place=false) %}
{%-     if not f_options["basedir"].startswith("/") %}
{%-       do f_options.update({"basedir": salt_.lookup.srv | path_join(f_options["basedir"])}) %}
{%-     endif %}
{%-     set target = f_options | traverse("args:target", f_options["basedir"] | path_join(f_name)) %}
{%-     do pillar_roots[env].append(target) %}
{%-     set basedir = salt["file.dirname"](target) %}
{%-     if basedir not in rendered_basedirs %}
{%-       do rendered_basedirs.append(basedir) %}

Pillar basedir for {{ f_name }} in {{ env }} exists:
  file.directory:
    - name: {{ basedir }}
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - mode: '0700'
    - makedirs: true
{%-     endif %}

{# Git states do not support git_opts, which would be useful for
   setting correct permissions. The cloned data is still not world-
   readable since the parent directory has the correct permissions.
   This could be set via `core.sharedRepository: '0600'`.
   https://github.com/saltstack/salt/issues/57452
 -#}

Pillar source {{ f_name }} in {{ env }} is present:
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
{%-     if f_options.get("clear_pillar_cache") %}
{%-       do clear_pillar_cache.append(true) %}
    - onchanges_in:
      - Pillar cache is cleared
{%-     endif %}
{%-     set opt_refresh = f_options.get("refresh_pillar") %}
{%-     if opt_refresh %}
{%-       set opt_refresh = opt_refresh if opt_refresh | is_list else [opt_refresh] %}
{%-       for refresh_tgt in opt_refresh %}
{%-         set tgt = refresh_tgt["tgt"] if opt_refresh is mapping else refresh_tgt %}
{%-         set tgt_type = refresh_tgt["tgt_type"] if opt_refresh is mapping else none %}
{%-         do refresh_pillar.append({"tgt": tgt, "tgt_type": tgt_type, "name": f_name, "env": env}) %}
{%-       endfor %}
{%-     endif %}
{%-   endfor %}
{%- endfor %}

{%- if clear_pillar_cache %}

Pillar cache is cleared:
  module.run:
    - saltutil.runner:
      - name: pillar.clear_pillar_cache
    - onchanges: []
{%- endif %}

{%- for refresh in refresh_pillar | unique %}

Update in-memory pillar after update to {{ refresh.name }} in {{ refresh.env }}:
  module.run:
    - saltutil.runner:
      - name: salt.execute
      - kwarg:
          tgt: {{ refresh.tgt }}
          fun: saltutil.refresh_pillar
          tgt_type: {{ refresh.tgt_type or "glob" }}
    - onchanges:
      - Pillar source {{ refresh.name }} in {{ refresh.env }} is present
{%- endfor %}
