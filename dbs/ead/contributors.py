#!/bin/env python
u"""Manage Archives Hub Contributors."""

import os
import sys
import hgapi

from lxml import etree
from lxml.builder import ElementMaker

from cheshire3.baseObjects import Session
from cheshire3.exceptions import ObjectDoesNotExistException
from cheshire3.internal import CONFIG_NS
from cheshire3.record import LxmlRecord
from cheshire3.server import SimpleServer

from cheshire3.commands.cmd_utils import identify_database

from archiveshub.commands.utils import BaseArgumentParser


class ContribArgumentParser(BaseArgumentParser):
    """Custom option parser for Archives Hub contributor management."""
    
    def __init__(self, *args, **kwargs):
        super(ContribArgumentParser, self).__init__(*args, **kwargs)
        self.add_argument('-d', '--database',
                          type=str, action='store', dest='database',
                          default=None, metavar='DATABASE',
                          help="identifier of Cheshire3 database")


def add_contributor(args):
    """Add data for contributor(s).
    
    Add DocumentStore configuration(s) for named contributor(s) to the
    ConfigStore for this database. 
    """
    global session, db, lgr
    # Get ConfigStore in which to store DocumentStore
    store = db.get_object(session, 'documentStoreConfigStore')
    # Sanity checking
    if len(args.dir) > 1 and args.identifier:
        lgr.log_critical(session,
                         "--id option may only be used when adding a single "
                         "contributor."
                         )
        return 1
    for dbPath in args.dir:
        # Sanity checking
        # Strip off trailing slash
        dbPath = dbPath.rstrip(os.pathsep)
        if os.path.exists(dbPath) and not os.path.isdir(dbPath):
            # Exists, but isn't a directory
            lgr.log_error(session,
                          "{0} exists but is not a directory".format(dbPath)
                          )
            continue
        elif not os.path.exists(dbPath) and not args.create:
            # Directory doesn't exist, and we've not been told to create it
            lgr.log_error(session,
                          "{0} doesn't exist. use --create option to creation "
                          "of it".format(dbPath)
                          )
            continue
        # Generate identifier for the contributor
        if args.identifier:
            contributorId = args.identifier
        else:
            contributorId = os.path.basename(dbPath)
        if not contributorId:
            lgr.log_error(session,
                          "Unable to generate an identifier for {0}"
                          "".format(dbPath)
                          )
            continue
        elif contributorId == 'hubdata':
            lgr.log_error(session,
                          "Cowardly refusing to add {0}! Use the add command "
                          "to add a single directory at a time. NOTE: you can "
                          "use wildcards e.g. {0}{1}*"
                          "".format(dbPath, os.pathsep)
                          )
            continue
        # Generate identifier for new DocumentStore
        storeId = "{0}DocumentStore".format(contributorId)
        # Check that DocumentStore does not already exists
        try:
            store.fetch_object(session, storeId)
        except ObjectDoesNotExistException:
            # This is what we want!
            pass
        else:
            lgr.log_error(session,
                          "Contributor with identifier {0} has already been "
                          "registered. If you're certain that you want to add "
                          "this contributor, you can specify an alternative "
                          "identifier using the --id option"
                          "".format(contributorId)
                          )
            continue
        # Create the directory if necessary
        if not os.path.exists(dbPath) and args.create:
            # Directory doesn't exist, but we've been told to create it
            lgr.log_debug(session,
                         "{0} does not exist, creating it".format(dbPath)
                         )
            os.makedirs(dbPath)
        # Check if it's a Mercurial repository
        repo = hgapi.Repo(dbPath)
        try:
            repo.hg_status()
        except Exception:
            # Not a Mercurial repository
            objType = "cheshire3.documentStore.DirectoryDocumentStore"
        else:
            objType = "archiveshub.documentStore.MercurialDocumentStore"
        # Create config node for the new DocumentStore
        config = CONF.config(
            {'id': storeId,
             'type': 'documentStore'},
            CONF.docs("DocumentStore for contributor {0}"
                      "".format(contributorId)),
            CONF.objectType(objType),
            # <paths>
            CONF.paths(
                CONF.path(
                    {'type': "databasePath"},
                    dbPath
                ),
                CONF.object(
                    {'type': "idNormalizer", 'ref': "IdToFilenameNormalizer"}
                ),
                CONF.object(
                    {'type': "outIdNormalizer", 'ref': "FilenameToIdNormalizer"}
                ),
            ),
        )
        xml = etree.tostring(config)
        # Store the configuration
        rec = LxmlRecord(config, xml, docId=storeId, byteCount=len(xml))
        store.begin_storing(session)
        store.store_record(session, rec)
        store.commit_storing(session)
        lgr.log_info(session, "DocumentStore for {0} located at {1} has been "
                              "added".format(contributorId, dbPath)
        )
        # TODO: write new contributor into JSON


def main(argv=None):
    global argparser
    global session, server, db, lgr
    if argv is None:
        args = argparser.parse_args()
    else:
        args = argparser.parse_args(argv)
    # Initialize Cheshire3 environment
    session = Session()
    server = SimpleServer(session, args.serverconfig)
    # Get the Database 
    if args.database is None:
        try:
            dbid = identify_database(session, os.getcwd())
        except EnvironmentError as e:
            server.log_critical(session, e.message)
            return 1
        server.log_debug(
            session, 
            "database identifier not specified, discovered: {0}".format(dbid))
    else:
        dbid = args.database
    try:
        db = server.get_object(session, dbid)
    except ObjectDoesNotExistException:
        msg = """Cheshire3 database {0} does not exist.
Please provide a different database identifier using the --database option.
""".format(dbid)
        server.log_critical(session, msg)
        return 2
    else:
        # Fetch a Logger
        lgr = db.get_path(session, 'defaultLogger')

    # Call 
    return args.func(args)


# Define the command line UI
docbits = __doc__.split('\n\n')
argparser = ContribArgumentParser(conflict_handler='resolve',
                               description=docbits[0]
                               )
subparsers = argparser.add_subparsers(help='Actions')
# Add a new contributor
parser_add = subparsers.add_parser(
    'add',
    help=add_contributor.__doc__
)
parser_add.add_argument('dir',
                        nargs='+',
                        action='store',
                        metavar='DIRECTORY',
                        help=("directory in which to find documents for "
                              "this contributor. If this directory is part of "
                              "a Mercurial version control repository, then "
                              "the system will attempt to commit any changes "
                              "made using the Cheshire3 API back to the "
                              "Mercurial repository." 
                         )
                        )
parser_add.add_argument('-i', '--id', '--identifier',
                   action='store', dest='identifier',
                   default=None,
                   help=("short identifier for contributor with which to "
                         "over-ride the default. default s the lowest level "
                         "directory name e.g., /home/user/foo --> foo"
                         )
                   )
parser_add.add_argument('-c', '--create',
                   action='store_true', dest='create',
                   help=("if DIRECTORY doesn't exist, create it")
                   )
parser_add.set_defaults(func=add_contributor)


# Set up ElementMaker for Cheshire3 config and METS namespaces
CONF = ElementMaker(namespace=CONFIG_NS,
                    nsmap={'cfg': CONFIG_NS})


if __name__ == '__main__':
    sys.exit(main())
