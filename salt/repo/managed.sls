# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

{%- for reponame, config in salt_.lookup.repos.items() %}
{%-   if reponame == salt_["repo"] %}

Salt {{ reponame }} repository is available:
  pkgrepo.managed:
{%-     for conf, val in config.items() %}
    - {{ conf }}: {{ val if val is not string else val.format(major=salt_._major, minor=salt_._minor) }}
{%-     endfor %}
{%-     if salt_.lookup.pkg_manager in ['dnf', 'yum', 'zypper'] %}
    - enabled: 1
{%-     endif %}

{%-   elif "None" not in salt_.lookup.repos[reponame].name.format(major=salt_._major, minor=salt_._minor) %}

Salt {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-     for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-       set val = salt_.lookup.repos[reponame].get(conf) %}
{%-       if val is not none %}
    - {{ conf }}: {{ val if val is not string else val.format(major=salt_._major, minor=salt_._minor) }}
{%-       endif %}
{%-     endfor %}
{%-   endif %}
{%- endfor %}
