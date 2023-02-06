# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".ssh.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

salt-ssh roster is managed:
  file.managed:
    - name: {{ salt_.lookup.config.ssh }}
    {#- This formula uses a patch to be able to use all mapstack sources for tofs config #}
    - source: {{ files_switch(["roster", "roster.j2"],
                              lookup="Salt master configuration is managed",
                              default_dir=salt_ | traverse("tofs:dirs:default")
                 )
              }}
    - mode: '0600'
    - dir_mode: '0700'
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        salt_: {{ salt_ | json }}
