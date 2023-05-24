# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".master.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}
{%- from tplroot ~ "/formulae/present.sls" import file_roots with context %}
{%- from tplroot ~ "/pillars/present.sls" import pillar_roots with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Salt master configuration is managed:
  file.recurse:
    - name: {{ salt_.lookup.config.master }}
    - source: {{ files_switch(
                    ["master.d"],
                    config=salt_,
                    lookup="Salt master configuration is managed",
                 )
              }}
    - file_mode: '0600'
    - dir_mode: '0700'
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - makedirs: true
    - template: jinja
    - clean: {{ salt_.master.config_clean }}
    - exclude_pat:
      - .gitkeep
      - _*
    - require:
      - sls: {{ sls_package_install }}
    - context:
        salt_: {{ salt_ | json }}
        file_roots: {{ file_roots | json }}
        pillar_roots: {{ pillar_roots | json }}

# TOFS does not merge matching directories, so having environment-specific
# tweaks is hard. Provide serialization from mapdata as well to allow for small tweaks.
Salt master configuration from mapdata is managed:
  file.serialize:
    - name: {{ salt_.lookup.config.master | path_join("_managed.conf") }}
    - serializer: yaml
    - mode: '0600'
    - dir_mode: '0700'
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ salt_.master.config | json }}

{%- if salt_.master.config_remove %}

Default master config file is absent:
  file.absent:
    - name: {{ salt["file.dirname"](salt_.lookup.config.master) | path_join("master") }}
{%- endif %}
