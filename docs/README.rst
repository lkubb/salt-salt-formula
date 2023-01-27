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

Each state directory also includes a ``<state_dir>.clean`` state that
tries to reverse what this formula configures to its best abilities.

.. contents::
   :local:

``salt``
^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This includes ``salt.minion`` only.

``salt.api``
^^^^^^^^^^^^^^^

Manages the Salt API. Includes ``salt.master``.
Substates are ``salt.api.package``, ``salt.api.cert``, ``salt.api.service``.

``salt.formulae``
^^^^^^^^^^^^^^^

Clones formula repositories into file roots and manages them.
If you override the default configuration files, you will need
to make sure your configuration includes the file_roots as well.
This allows you to avoid the ``git`` fileserver backend, which can become unbearably slow with growing number of files and repositories.

``salt.libs``
^^^^^^^^^^^^^^^

Manages Python libraries in the current Salt Python environment.
Included by ``salt.master`` and ``salt.minion``.

``salt.minion``
^^^^^^^^^^^^^^^

Manages a Salt minion.
Substates are ``salt.minion.package``, ``salt.minion.config``, ``salt.minion.service``.

``salt.pillars``
^^^^^^^^^^^^^^^

Clones pillar repositories into pillar roots and manages them.
This allows you to avoid the ``git`` external pillar for performance reasons.
If you override the default configuration files, you will need
to make sure your configuration includes the pillar_roots as well.

``salt.repo``
^^^^^^^^^^^^^^^

Ensures the official SaltStack repository is present.

``salt.ssh``
^^^^^^^^^^^^^^^

Manages Salt SSH.
Substates are ``salt.ssh.package``, ``salt.ssh.config``,

``salt.syndic``
^^^^^^^^^^^^^^^

Manages Salt Syndic. Includes ``salt.master``.
Substates are ``salt.syndic.package``, ``salt.syndic.service``.

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

Linux testing is done with ``kitchen-salt``. Other than for show, the tests currently have
no value since they are not implemented (boilerplate from the template formula atm).

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
