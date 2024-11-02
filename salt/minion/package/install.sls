# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ tplroot }}.repo
  - {{ tplroot }}.libs

{%- if grains["os"] == "MacOS" %}
{%-   if salt_._major %}
{%-     if salt_._minor %}
{%-       set version = "{}.{}".format(salt_._major, salt_._minor) %}
{#- There are no more official macOS releases after these versions, TODO: provide alternative installation #}
{%-     elif salt_._major == 3006 %}
{%-       set version = "3006.9" %}
{%-     else %}
{%-       set version = "3007.1" %}
{%-     endif %}
{%-   else %}
{%-     set version = "3007.1" %}
{%-   endif %}

Salt macOS package is present:
  file.managed:
    - name: /tmp/salt.pkg
    - source: {{
                  salt_.lookup.pkg_src.source.format(
                    version=version,
                    arch=grains.osarch,
                  )
              }}
{%-   if salt_.lookup.pkg_src.source_hash %}
    - source_hash: {{
                  salt_.lookup.pkg_src.source_hash.format(
                    version=version,
                    arch=grains.osarch,
                  )
              }}
{%-   else %}
    - skip_verify: true
{%-   endif %}
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - mode: '0600'
    - unless:
      - /opt/salt/salt-minion --version | grep -E '{{ version.replace(".", "\.") if salt_._minor else "{}\.".format(salt_._major) }}.*$'

Salt minion is installed:
  macpackage.installed:
    - name: /tmp/salt.pkg
    - target: /
    - force: true # version detection is done during download
    - onchanges:
      - file: /tmp/salt.pkg

{%- else %}
{%-   if grains["os_family"] == "Debian" %}

# Make sure a package upgrade does not interrupt
# state execution on Debian derivatives
# https://docs.saltproject.io/en/latest/faq.html#what-is-the-best-way-to-restart-a-salt-minion-daemon-using-salt-after-upgrade
Disable starting services:
  file.managed:
    - name: /usr/sbin/policy-rc.d
    - user: root
    - group: root
    - mode: '0755'
    - contents:
      - '#!/bin/sh'
      - exit 101
    - replace: False
    - prereq:
      - Salt minion is installed
{%-   endif %}

{%- if salt_.lookup.sys_deps %}

Salt system dependencies are installed:
  pkg.installed:
    - pkgs: {{ salt_.lookup.sys_deps | json }}
    - require_in:
      - Salt minion is installed
{%- endif %}

Salt minion is installed:
  pkg.installed:
    - name: {{ salt_.lookup.pkg.minion.format(pyver=salt_.pyver) }}
    - version: {{ salt_.version or "null" }}
    - hold: {{ salt_._minor is not none }}
{%-   if "repos" in salt_["lookup"] %}
    - require:
      - Salt repo is configured
{%-   endif %}

{%-   if grains["os_family"] == "Debian" %}

Enable starting services:
  file.absent:
    - name: /usr/sbin/policy-rc.d
    - onchanges:
      - Salt minion is installed
{%-   endif %}
{%- endif %}
