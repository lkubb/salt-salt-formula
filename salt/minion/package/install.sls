# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ tplroot }}.repo
  - {{ tplroot }}.libs

{%- if grains["os"] == "MacOS" %}
{%-   set repo = {} %}
{%-   if salt_.lookup.pkg_src.repo_json %}
{%-     set repo_json = salt["http.query"](salt_.lookup.pkg_src.repo_json, decode=true)["dict"] %}
{%-     set version_match = [] %}
{%-     for version in repo_json %}
{%-       if salt["match.glob"](salt_.version, version or "latest") %}
{%-         do version_match.append(version) %}
{%-       endif %}
{%-     endfor %}
{%-     if version_match %}
{%-       set repodata = repo_json[version_match | sort(reverse=true) | first].values() | first %}
{#- path_join removes scheme prefix double-slash #}
{%-       do repo.update({
            "source": salt["file.dirname"](salt_.lookup.pkg_src.repo_json) ~ "/" ~ repodata["version"] ~ "/" ~ repodata["name"],
            "source_hash": repodata["SHA3_512"],
          }) %}
{%-     endif %}
{%-   endif %}

Salt macOS package is present:
  file.managed:
    - name: /tmp/salt.pkg
    - source: {{ repo.get("source", salt_.lookup.pkg_src.source.format(version=salt_.version, arch="x86_64")) }}
    - source_hash: {{ repo.get("source_hash", salt_.lookup.pkg_src.source_hash.format(version=salt_.version, arch="x86_64")) }}
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - mode: '0600'
{%-   if salt_.version != "latest" %}
    - unless:
      - /opt/salt/bin/salt-minion --version | grep -E '{{ salt_.version | replace(".", "\.") | replace("*", ".*") }}$'
{%-   endif %}

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

Salt minion is installed:
  pkg.installed:
    - name: {{ salt_.lookup.pkg.minion.format(pyver=salt_.pyver) }}
    - version: {{ salt_.version or "null" }}
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
