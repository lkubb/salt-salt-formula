# vim: ft=sls

{#-
    Ensures the Salt repository is not configured.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

{%- if salt_.lookup.pkg_manager not in ["apt", "dnf", "yum"] %}
{%-   if salt["state.sls_exists"](slsdotpath ~ "." ~ salt_.lookup.pkg_manager ~ ".clean") %}

include:
  - {{ slsdotpath ~ "." ~ salt_.lookup.pkg_manager ~ ".clean" }}
{%-   endif %}

{%- else %}
{%-   set reponame = salt_["repo"] %}
{%-   set key_file_name = config.get("key_file", {}).get(salt_._major) or config.get("key_file", {}).get("default", "") %}

Salt {{ reponame }} repository is absent:
  pkgrepo.absent:
{%-   for conf in ["name", "ppa", "ppa_auth", "keyid", "keyid_ppa", "copr"] %}
{%-     if conf in salt_.lookup.repos[reponame] %}
{%-       set val = salt_.lookup.repos[reponame][conf] %}
    - {{ conf }}: {{ val if val is not string else val.format(major=salt_._major, minor=salt_._minor, key_file_name=key_file_name) }}
{%-     endif %}
{%-   endfor %}
{%- endif %}
