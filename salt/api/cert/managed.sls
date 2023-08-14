# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".api.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as salt_ with context %}

include:
  - {{ sls_package_install }}

Salt API certificate private key is managed:
  x509.private_key_managed:
    - name: {{ salt_.api.cert.cert_key }}
    - algo: rsa
    - keysize: 2048
    - new: true
{%- if salt["file.file_exists"](salt_.api.cert.cert_key) %}
    - prereq:
      - Salt API certificate is managed
{%- endif %}
    - makedirs: true
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - require:
      - sls: {{ sls_package_install }}

Salt API certificate is managed:
  x509.certificate_managed:
    - name: {{ salt_.api.cert.cert_path }}
    - ca_server: {{ salt_.api.cert.ca_server or "null" }}
    - signing_policy: {{ salt_.api.cert.signing_policy or "null" }}
    - signing_cert: {{ salt_.api.cert.signing_cert or "null" }}
    - signing_private_key: {{ salt_.api.cert.signing_private_key or
                              (salt_.api.cert.cert_key if not salt_.api.cert.ca_server and not salt_.api.cert.signing_cert
                              else "null") }}
    - private_key: {{ salt_.api.cert.cert_key }}
    - days_remaining: {{ salt_.api.cert.days_remaining or "null" }}
    - days_valid: {{ salt_.api.cert.days_valid or "null" }}
    - authorityKeyIdentifier: keyid:always
    - basicConstraints: critical, CA:false
    - subjectKeyIdentifier: hash
    - subjectAltName:
      - dns: {{ salt_.api.cert.cn or grains.fqdns | reject("==", "localhost.localdomain") | first | d(grains.id) }}
    - CN: {{ salt_.api.cert.cn or grains.fqdns | reject("==", "localhost.localdomain") | first | d(grains.id) }}
    - mode: '0600'
    - user: root
    - group: {{ salt_.lookup.rootgroup }}
    - makedirs: true
    - append_certs: {{ salt_.api.cert.intermediate | json }}
    - require:
      - sls: {{ sls_package_install }}
{%- if not salt["file.file_exists"](salt_.api.cert.cert_key) %}
      - Salt API certificate private key is managed
{%- endif %}
