.. _readme:

Salt Formula
============

|img_sr| |img_pc|

.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

Manage Salt with Salt.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Special notes
-------------
In comparison to the `official Salt formula <https://github.com/saltstack-formulas/salt-formula>`_, this one provides some benefits and drawbacks:

Benefits
^^^^^^^^
* Configuration using mapstack instead of pillar-only
* More modular configuration for the managed domains provides more control (+readability of states)
* Managed pillar repositories to avoid the git external pillar
* Managed Salt Python environment libraries
* Should actually work on macOS

Drawbacks
^^^^^^^^^
* No tests currently (!)
* No crowd knowledge/experience currently (!)
* No versatility regarding installation method (written with package installation from repo in mind)
* More control means more required knowledge

Configuration
-------------
An example pillar is provided, please see `pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in `map.jinja`.


Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``salt``
^^^^^^^^
*Meta-state*.

This includes `salt.minion`_ only.


``salt.api``
^^^^^^^^^^^^
Installs, configures and starts/enables the Salt API.
Also generates a TLS certificate.
Includes `salt.master`_ states.


``salt.api.cert``
^^^^^^^^^^^^^^^^^
Generates a TLS certificate + key for the Salt API.
Depends on `salt.api.package`_.


``salt.api.package``
^^^^^^^^^^^^^^^^^^^^
Installs Salt API only.
Depends on `salt.repo`_.


``salt.api.service``
^^^^^^^^^^^^^^^^^^^^
Enables and (re)starts the Salt API service.
Depends on `salt.api.cert`_ and `salt.master.service`_.


``salt.formulae``
^^^^^^^^^^^^^^^^^
Ensures all configured formulae are present in the
target destination and up to date, if configured.

This allows you to avoid the ``git`` fileserver backend,
which can become unbearably slow with growing number of files
and repositories.

You can import the list of file roots to include in your config
from ``salt.formulae.present``. This is done by default.


``salt.libs``
^^^^^^^^^^^^^
Ensures the current (!) Python environment Salt runs in
contains/does not contain specified modules.

Included by `salt.master`_ and `salt.minion`_.


``salt.master``
^^^^^^^^^^^^^^^
Installs, configures and starts/enables the Salt master.


``salt.master.config``
^^^^^^^^^^^^^^^^^^^^^^
Manages the Salt master configuration.
Depends on `salt.master.package`_.


``salt.master.package``
^^^^^^^^^^^^^^^^^^^^^^^
Installs the Salt master package only.
Depends on `salt.repo`_.


``salt.master.service``
^^^^^^^^^^^^^^^^^^^^^^^
Starts/enables the Salt master service at boot time.
Depends on `salt.master.config`_.


``salt.minion``
^^^^^^^^^^^^^^^



``salt.minion.config``
^^^^^^^^^^^^^^^^^^^^^^
Manages the Salt minion configuration.
Depends on `salt.minion.package`_.


``salt.minion.package``
^^^^^^^^^^^^^^^^^^^^^^^
Installs the Salt minion package only.
Depends on `salt.repo`_.


``salt.minion.service``
^^^^^^^^^^^^^^^^^^^^^^^
Starts/enables the Salt minion service at boot time.
Depends on `salt.minion.config`_.


``salt.pillars``
^^^^^^^^^^^^^^^^
Ensures all configured pillars are present in the
target destination and up to date, if configured.
This allows you to avoid the ``git`` external pillar for
performance reasons.

You can import the list of pillar roots to include in your config
from ``salt.pillars.present``. This is done by default.

Optionally, clears pillar cache on the master and instructs
selected minions to update their in-memory pillar data on changes.


``salt.repo``
^^^^^^^^^^^^^
Ensures the official SaltStack repository is present.


``salt.ssh``
^^^^^^^^^^^^
Installs Salt SSH and manages the roster.


``salt.ssh.config``
^^^^^^^^^^^^^^^^^^^
Manages Salt SSH roster configuration.


``salt.ssh.package``
^^^^^^^^^^^^^^^^^^^^
Installs Salt SSH only.


``salt.syndic``
^^^^^^^^^^^^^^^
Installs and starts/enables Salt syndic.


``salt.syndic.package``
^^^^^^^^^^^^^^^^^^^^^^^
Installs Salt syndic only.
Depends on `salt.repo`_.


``salt.syndic.service``
^^^^^^^^^^^^^^^^^^^^^^^
Starts/enables Salt syndic.
Depends on `salt.master.service`_.


``salt.clean``
^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed by states of this formula.
Will remove all managed Salt packages, configuration, formulae and pillars.
Libs are untouched.


``salt.api.clean``
^^^^^^^^^^^^^^^^^^
Stops/disables the Salt API service,
removes TLS certificate/key and the Salt API package.


``salt.api.cert.clean``
^^^^^^^^^^^^^^^^^^^^^^^



``salt.api.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.api.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.formulae.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Removes all cloned formula repositories.


``salt.libs.clean``
^^^^^^^^^^^^^^^^^^^



``salt.master.clean``
^^^^^^^^^^^^^^^^^^^^^
Stops/disables the Salt master service,
removes master configuration and the Salt master package.


``salt.master.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.master.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.master.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.minion.clean``
^^^^^^^^^^^^^^^^^^^^^
Stops/disables the Salt minion service,
removes minion configuration and the Salt minion package.


``salt.minion.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.minion.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.minion.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.pillars.clean``
^^^^^^^^^^^^^^^^^^^^^^
Removes all cloned pillar repositories.


``salt.repo.clean``
^^^^^^^^^^^^^^^^^^^
Ensures the Salt repository is not configured.


``salt.ssh.clean``
^^^^^^^^^^^^^^^^^^
Removes Salt SSH and the roster.


``salt.ssh.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the roster.


``salt.ssh.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes Salt SSH.
Depends on `salt.ssh.config.clean`_.


``salt.syndic.clean``
^^^^^^^^^^^^^^^^^^^^^
Disables/stops and removes Salt syndic.


``salt.syndic.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes Salt syndic.
Depends on `salt.syndic.service.clean`_.


``salt.syndic.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops/disables Salt syndic.



Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``salt`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
