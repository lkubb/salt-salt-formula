# -*- coding: utf-8 -*-
# vim: ft=yaml
---
salt:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    enablerepo:
      stable: true
    config:
      master: /etc/salt/master.d
      minion: /etc/salt/minion.d
      ssh: /etc/salt/roster
    pip_pkg: python3-pip
    pkg:
      api: salt-api
      cloud: salt-cloud
      master: salt-master
      minion: salt-minion
      ssh: salt-ssh
      syndic: salt-syndic
    rootuser: root
    service:
      api: salt-api
      master: salt-master
      minion: salt-minion
      syndic: salt-syndic
    srv: /srv
  api:
    cert:
      ca_server: null
      cert_key: /etc/salt/pki/api/netapi.key
      cert_path: /etc/salt/pki/api/netapi.crt
      cn: null
      days_remaining: 3
      days_valid: 7
      intermediate: []
      root: ''
      signing_cert: null
      signing_policy: null
      signing_private_key: null
      signing_private_key_passphrase: null
  formulae:
    config:
      default:
        args:
          parallel: true
        basedir: formula
        baseurl: https://github.com/saltstack-formulas
        update: true
    present:
      base: []
  master:
    config: {}
    config_clean: false
    config_remove: false
  minion:
    config: {}
    config_clean: false
    config_remove: false
  pillars:
    config:
      default:
        args:
          parallel: true
        basedir: pillars
        baseurl: null
        clear_pillar_cache: false
        refresh_pillar: false
        update: true
    present:
      base: []
  python_libs: []
  python_libs_absent: []
  pyver: py39
  repo: major
  ssh:
    roster: {}
  version: 3005*

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://salt/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   salt-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      salt-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
