"""Start an HTTP server for Archives Hub.

Start a CherryPy HTTP server to expose Cheshire3 databases via the web
services and web application for development and demonstration purposes.


usage: cherrypy_serve [-h] [-s PATH] [--hostname HOSTNAME] [-p PORT]
                      [--no-browser] [-d]

"""
import cherrypy
import sys
import socket
import signal

from os.path import expanduser

from pkg_resources import Requirement, resource_filename

from cheshire3.server import SimpleServer
from cheshire3.session import Session
from cheshire3.web.sruWsgi import SRUWsgiHandler, get_configsFromServer
from cheshire3.web.oaipmhWsgi import OAIPMHWsgiApplication
from cheshire3.web.oaipmhWsgi import get_databasesAndConfigs

from archiveshub.deploy.utils import WSGIAppArgumentParser

from archiveshub.apps.ead.search import application as ead_search_app
from archiveshub.apps.ead.record import application as ead_data_app
from archiveshub.apps.contribute.admin import application as admin_app
from archiveshub.apps.contribute.edit import application as edit_app
from archiveshub.apps.contribute.console import application as console_app
from archiveshub.apps.ead.oaipmh import application as oaipmh_app


def main(argv=None):
    """Start up a CherryPy server to serve the SRU application."""
    global argparser, c3_session, c3_server
    global sru_app, ead_search_app, ead_data_app  # WSGI Apps
    if argv is None:
        args = argparser.parse_args()
    else:
        args = argparser.parse_args(argv)
    c3_session = Session()
    c3_server = SimpleServer(c3_session, args.serverconfig)
    # Init SRU App
    sru_configs = get_configsFromServer(c3_session, c3_server)
    sru_app = SRUWsgiHandler(c3_session, sru_configs)
    # Init OAI-PMH App
    dbs, oaipmh_configs = get_databasesAndConfigs(c3_session, c3_server)
    #oaipmh_app = OAIPMHWsgiApplication(c3_session, oaipmh_configs, dbs)
    # Prepare CherryPy Engine
    cherrypy.config.update({'server.socket_host': args.hostname,
                            'server.socket_port': args.port,
                            'tools.trailing_slash.on': True,
                            'tools.trailing_slash.missing': True,
                            'tools.trailing_slash.extra': True})
    cherrypy.tree.graft(sru_app, '/api/sru')
    cherrypy.tree.graft(oaipmh_app, '/api/OAI-PMH/2.0')
    cherrypy.tree.graft(ead_data_app, '/data')
    cherrypy.tree.graft(ead_search_app, '/search')
    cherrypy.tree.graft(admin_app, '/admin')
    cherrypy.tree.graft(edit_app, '/edit')
    cherrypy.tree.graft(console_app, '/contribute')
    root_conf = {
        'tools.staticdir.on': True,
        'tools.staticdir.dir': expanduser('~/mercurial/archiveshub/htdocs'),
        'tools.staticdir.index': 'index.html'
    }
    config = {
        '/': root_conf
    }
    cherrypy.tree.mount(None, '/', config=config)
    edit_config = {
        '/': {
            'tools.staticdir.on': True,
            'tools.staticdir.dir': resource_filename(
                Requirement.parse('archiveshub'),
                'www/hubedit/js'
            )
        }
    }
    cherrypy.tree.mount(None, '/edit/js', edit_config)
    # Write startup message to stdout
    sys.stdout.write(
        "Starting CherryPy HTTP server for ArchivesHub.\n"
        "If running in foreground Ctrl-C will stop the server.\n"
        "You will be able to access the applications from:\n"
        "http://{0}:{1}\n""".format(args.hostname, args.port)
    )
    sys.stdout.flush()
    # Register signal handler for shutdown

    def signal_handler(signal, frame):
        cherrypy.engine.stop()
        sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)
    # Daemonize the process?
    if args.daemonic:
        sys.stdout.write("Daemonizing...\n""")
        sys.stdout.flush()
        access_log = resource_filename(
            Requirement.parse('archiveshub'),
            'www/ead/logs/access.log'
        )
        error_log = resource_filename(
            Requirement.parse('archiveshub'),
            'www/ead/logs/error.log'
        )
        cherrypy.process.plugins.Daemonizer(
            cherrypy.engine,
            stdout=access_log,
            stderr=error_log
        ).subscribe()
    cherrypy.engine.start()
    cherrypy.engine.block()


c3_session = None
c3_server = None

# Set up argument parser
argparser = WSGIAppArgumentParser(
    conflict_handler='resolve',
    description=__doc__.splitlines()[0]
)
argparser.add_argument('-d', '--daemonic',
                       dest='daemonic',
                       action='store_true',
                       help=("Start the server in daemon mode. Default is to "
                             "start in the foreground of the current process "
                             "for development and debugging."
                             )
                       )


if __name__ == '__main__':
    main()
