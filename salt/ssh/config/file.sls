# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".ssh.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

salt-ssh roster is managed:
  file.managed:
    - name: {{ salt_.lookup.config.ssh }}
    - source: {{ files_switch(
                    ["roster", "roster.j2"],
                    config=salt_,
                    lookup="Salt SSH configuration is managed",
                 )
              }}
    - mode: '0600'
    - dir_mode: '0700'
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - makedirs: true
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        salt_: {{ salt_ | json }}
