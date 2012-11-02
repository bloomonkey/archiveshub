"""Setuptools command sub-classes."""

import os
import shutil
import inspect

from os.path import expanduser, abspath, dirname, join, exists, islink
from pkg_resources import normalize_path

from setuptools import Command
from setuptools.command import develop as _develop
from setuptools.command import install as _install

from cheshire3.exceptions import ConfigFileException
from cheshire3.internal import cheshire3Home, cheshire3Root
from cheshire3.server import SimpleServer
from cheshire3.session import Session

from cheshire3archives.setuptools.apache import ApacheModifier
from cheshire3archives.setuptools.exceptions import *


class unavailable_command(Command):
    """Sub-class commands that we don't want to make available."""

    description = "Command is not appropriate for this package"
    user_options = []
    boolean_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        raise NotImplementedError(self.description)


class c3_command(Command):
    """Base Class for custom commands."""
    
    user_options = [
        ("with-httpd=",
         None,
         "Set the path to Apache HTTPD installation directory"),
    ]

    def initialize_options(self):
        self.with_httpd = '/etc/httpd'

    def finalize_options(self):
        self.with_httpd = normalize_path(self.with_httpd)

    def install_apache_mods(self):
        """Install Apache HTTPD modifications."""
        # Install Apache HTTPD configuration plugin file
        am = ApacheModifier(self.with_httpd)
        am.install_apache_config()
        # Create web directory for static search pages
        # and install default landing page there
        am.install_web_landing_page()
        
    def uninstall_apache_mods(self):
        # Install Apache HTTPD configuration plugin file
        am = ApacheModifier(self.with_httpd)
        am.uninstall_apache_config()
        # Remove web directory for static search pages
        am.uninstall_web_dir()
    

class develop(_develop.develop, c3_command):
    
    user_options = _develop.develop.user_options + c3_command.user_options
    
    def initialize_options(self):
        _develop.develop.initialize_options(self)
        c3_command.initialize_options(self)

    def finalize_options(self):
        _develop.develop.finalize_options(self)
        c3_command.finalize_options(self)
        
    def install_for_development(self):
        global distropath, server, session
        # Carry out normal procedure
        _develop.develop.install_for_development(self)
        # Tell the server to register the config file
        try:
            server.register_databaseConfigFile(session, join(distropath,
                                                             'dbs',
                                                             'ead',
                                                             'config.xml'))
        except ConfigFileException as e:
            if e.reason.startswith("Database with id 'db_ead' is already "
                                   "registered."):
                # Existing install / development install
                raise DevelopException("Package is already installed. To "
                                       "install in 'develop' mode you must "
                                       "first run the 'uninstall' command.")
        else:
            server.register_databaseConfigFile(session, join(distropath,
                                                             'dbs',
                                                             'ead',
                                                             'cluster',
                                                             'config.xml'))
        # Install Apache HTTPD mods
        self.install_apache_mods()
        # New version runs from unpacked / checked out directory
        # No need to install database or web app
        
    def uninstall_link(self):
        global server, session
        # Carry out normal procedure
        _develop.develop.uninstall_link(self)
        # Uninstall Apache HTTPD mods
        self.uninstall_apache_mods()
        # Unregister the database by deleting
        # Cheshire3 database config plugin
        serverDefaultPath = server.get_path(session,
                                            'defaultPath',
                                            cheshire3Root)
        userSpecificPath = join(expanduser('~'), '.cheshire3-server')
        pluginPath = os.path.join('configs', 'databases', 'db_ead.xml')
        if exists(join(serverDefaultPath, pluginPath)):
            os.remove(join(serverDefaultPath, pluginPath))
        elif exists(os.path.join(userSpecificPath, pluginPath)):
            os.remove(os.path.join(userSpecificPath, pluginPath))
        else:
            server.log_error(session, "No database plugin file")


class install(_install.install, c3_command):
    
    user_options = _install.install.user_options + c3_command.user_options
    
    def initialize_options(self):
        _install.install.initialize_options(self)
        c3_command.initialize_options(self)

    def finalize_options(self):
        _install.install.finalize_options(self)
        c3_command.finalize_options(self)
        
    def run(self):
        # Carry out normal procedure
        _install.install.run(self)
        # Install Apache HTTPD mods
        self.install_apache_mods()
        # Install Cheshire3 database config plugin
        # Tell the server to register the config file
        try:
            server.register_databaseConfigFile(session, join(distropath,
                                                             'dbs',
                                                             'ead',
                                                             'config.xml'))
        except ConfigFileException as e:
            if e.reason.startswith("Database with id 'db_ead' is already "
                                   "registered."):
                # Existing install / development install
                raise InstallException("Package is already installed. To "
                                       "install you must first run the "
                                       "'uninstall' command.")
        else:
            server.register_databaseConfigFile(session, join(distropath,
                                                             'dbs',
                                                             'ead',
                                                             'cluster',
                                                             'config.xml'))
        # New version runs from unpacked / checked out directory
        # No need to install database or web app


class upgrade(_install.install, c3_command):
    
    user_options = _install.install.user_options + c3_command.user_options
    
    def initialize_options(self):
        _install.install.initialize_options(self)
        c3_command.initialize_options(self)

    def finalize_options(self):
        _install.install.finalize_options(self)
        c3_command.finalize_options(self)
        
    def run(self):
        # Carry out normal procedure
        _install.install.run(self)
        # Install Apache HTTPD mods
        self.install_apache_mods()
        # Upgrade database directory
        subpath = join('cheshire3',
                       'dbs',
                       'ead')
        shutil.copytree(join(distropath, 'dbs', 'ead'), 
                        join(cheshire3Home, subpath),
                        symlinks=False,
                        ignore=shutil.ignore_patterns(".git*",
                                                      "*.pyc",
                                                      "PyZ3950_parsetab.py*",
                                                      "*.bdb",
                                                      "*.log")
                        )
        # Upgrade to web app directory
        subpath = join('cheshire3', 
                       'www', 
                       'ead')
        shutil.copytree(join(distropath, 'www'), 
                        join(cheshire3Home, subpath),
                        symlinks=False,
                        ignore=shutil.ignore_patterns(".git*", 
                                                      "*.pyc", 
                                                      "PyZ3950_parsetab.py*", 
                                                      "*.bdb", 
                                                      "*.log")
                        )


class uninstall(c3_command):

    description = "Uninstall Cheshire3 for Archives"
    
    def run(self):
        # Uninstall Apache HTTPD mods
        self.uninstall_apache_mods()
        # Unregister the database by deleting
        # Cheshire3 database config plugin
        serverDefaultPath = server.get_path(session,
                                            'defaultPath',
                                            cheshire3Root)
        userSpecificPath = join(expanduser('~'), '.cheshire3-server')
        pluginPath = os.path.join('configs', 'databases', 'db_ead.xml')
        if exists(join(serverDefaultPath, pluginPath)):
            os.remove(join(serverDefaultPath, pluginPath))
        elif exists(os.path.join(userSpecificPath, pluginPath)):
            os.remove(os.path.join(userSpecificPath, pluginPath))
        else:
            server.log_error(session, "No database plugin file")


# Inspect to find current path
modpath = inspect.getfile(inspect.currentframe())
moddir = dirname(modpath)
distropath = abspath(join(moddir, '..', '..'))
serverConfig = os.path.join(cheshire3Root,
                            'configs',
                            'serverConfig.xml')
session = Session()
server = SimpleServer(session, serverConfig)


