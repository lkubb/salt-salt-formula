# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".minion.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}
{%- from tplroot ~ "/formulae/present.sls" import file_roots with context %}
{%- from tplroot ~ "/pillars/present.sls" import pillar_roots with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Salt minion configuration is managed:
  file.recurse:
    - name: {{ salt_.lookup.config.minion }}
    {#- This formula uses a patch to be able to use all mapstack sources for tofs config #}
    - source: {{ files_switch(["minion.d"],
                              lookup="Salt minion configuration is managed",
                              default_dir=salt_ | traverse("tofs:dirs:default")
                 )
              }}
{%- if grains["kernel"] != "Windows" %}
    - file_mode: '0600'
    - dir_mode: '0700'
{%- endif %}
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - clean: {{ salt_.minion.config_clean }}
    - exclude_pat:
      - .gitkeep
      - _*
    - require:
      - sls: {{ sls_package_install }}
    - context:
        salt_: {{ salt_ | json }}
        # for standalone and masterless minions
        file_roots: {{ file_roots | json }}
        pillar_roots: {{ pillar_roots | json }}

# TOFS does not merge matching directories, so having environment-specific
# tweaks is hard. Provide serialization from mapdata as well to allow for small tweaks.
Salt minion configuration from mapdata is managed:
  file.serialize:
    - name: {{ salt_.lookup.config.minion | path_join("_managed.conf") }}
    - serializer: yaml
{%- if grains["kernel"] != "Windows" %}
    - mode: '0600'
    - dir_mode: '0700'
{%- endif %}
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - makedirs: True
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ salt_.minion.config | json }}

{%- if salt_.minion.config_remove %}

Default minion config file is absent:
  file.absent:
    - name: {{ salt["file.dirname"](salt_.lookup.config.minion) | path_join("minion") }}
{%- endif %}
