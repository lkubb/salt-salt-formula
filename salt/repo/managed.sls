# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

{%- if salt_.lookup.bootstrap_repo_file %}

Ensure salt bootstrap repo config is removed:
  file.absent:
    - name: {{ salt_.lookup.bootstrap_repo_file }}

{%-   if grains.os_family == "RedHat" %}
{%-     set old_repos = salt["file.find"](salt["file.dirname"](salt_.lookup.bootstrap_repo_file), regex="saltstack(-3.*)?.repo$") %}
{%-   elif grains.os_family == "Debian" %}
{%-     set old_repos = salt["file.find"](salt["file.dirname"](salt_.lookup.bootstrap_repo_file), regex="saltstack_(major|minor|latest).list$") %}
{%-   endif %}
{%-   if old_repos %}
{#- Remove all old-style version-locked repo definitions on RHEL/Debian. The repo is now just named "saltstack_official" #}

Ensure old Salt repos are removed:
  file.absent:
    - names: {{ old_repos | json }}
{%-   endif %}
{%- endif %}

{%- for reponame, config in salt_.lookup.repos.items() %}
{%-   if reponame == salt_["repo"] %}

Salt {{ reponame }} repository is available:
  pkgrepo.managed:
{%-     for conf, val in config.items() %}
    - {{ conf }}: {{ val if val is not string else val.format(major=salt_._major, minor=salt_._minor) }}
{%-     endfor %}
{%-     if salt_.lookup.pkg_manager in ["dnf", "yum", "zypper"] %}
    - enabled: 1
{%-       if salt_._major %}
    - exclude: '{{ "*" + range(3006, salt_._major + 5) | reject("==", salt_._major) | join("* *") + "*" }}'
{%-       endif %}

{%-     elif salt_.lookup.pkg_manager == "apt" %}
  file.{{ "managed" if salt_._major else "absent" }}:
    - name: /etc/apt/preferences.d/salt-pin-1001
{%-       if salt_._major %}
    - contents: |
        Package: salt-*
        Pin: version {{ salt_._major }}.*
        Pin-Priority: 1001
{%-       endif %}
{%-     endif %}

{%-   elif "None" not in salt_.lookup.repos[reponame].name.format(major=salt_._major, minor=salt_._minor) %}

Salt {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-     for conf in ["name", "ppa", "ppa_auth", "keyid", "keyid_ppa", "copr"] %}
{%-       set val = salt_.lookup.repos[reponame].get(conf) %}
{%-       if val is not none %}
    - {{ conf }}: {{ val if val is not string else val.format(major=salt_._major, minor=salt_._minor) }}
{%-       endif %}
{%-     endfor %}
{%-   endif %}
{%- endfor %}
