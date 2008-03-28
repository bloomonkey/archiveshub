#
# Script:    eadEditingHandler.py
# Version:   0.1
# Date:      ongoing
# Copyright: &copy; University of Liverpool 2007
# Description:
#            Data creation and editing interface for EAD finding aids
#            - part of Cheshire for Archives v3
#
# Author(s): JH - John Harrison <john.harrison@liv.ac.uk>
#            CS - Catherine Smith <catherine.smith@liv.ac.uk>
#
# Language:  Python
# Required externals:
#            cheshire3-base, cheshire3-web
#            Py: 
#            HTML: 
#            CSS: 
#            Javascript: 
#            Images: 
#
# Version History: # left as example
# 0.01 - 06/12/2005 - JH - Basic administration navigations and menus




from eadHandler import *
from copy import deepcopy
import datetime, glob

# script specific globals
#script = '/ead/edit/'

class EadEditingHandler(EadHandler):
    global repository_name, repository_link, repository_logo, htmlPath
    templatePath = os.path.join(htmlPath, 'template.ssi')

    htmlTitle = None
    htmlNav = None
    logger = None
    errorFields = []
    
    altrenderDict = { 'surname' : 'a',
                      'organisation' : 'a',
                      'dates' : 'y',
                      'other' : 'x',
                      'loc' : 'z'                    
                     }

    def __init__(self, lgr):
        EadHandler.__init__(self, lgr)
        self.htmlTitle = ['Data Creation and Editing']
        self.htmlNav = ['<a href="javascript: toggleKeyboard();">Character Keyboard</a>']
        self.logger = lgr

    #- end __init__


    def send_fullHtml(self, data, req, code=200):
        tmpl = read_file(self.templatePath)                                     # read the template in
        page = tmpl.replace("%CONTENT%", data)
    
        self.globalReplacements.update({
            "%TITLE%": ' :: '.join(self.htmlTitle)
            ,"%NAVBAR%": ' | '.join(self.htmlNav),
        })
    
        page = multiReplace(page, self.globalReplacements)
        req.content_type = 'text/html'
        req.content_length = len(page)
        req.send_http_header()
        if (type(page) == unicode):
          page = page.encode('utf-8')
        req.write(page)
        req.flush()
        
        #- end send_html() ---------------------------------------------------------
    

    def _validate_isadg(self, rec):
        required_xpaths = ['/ead/eadheader/eadid']
        # check record for presence of mandatory XPaths
        missing_xpaths = []
        for xp in required_xpaths:
            try: rec.process_xpath(session, xp)[0];
            except IndexError:
                missing_xpaths.append(xp)
        if len(missing_xpaths):
            self.htmlTitle.append('Error')
            newlineRe = re.compile('(\s\s+)')
            return '''
    <p class="error">Your file does not contain the following mandatory XPath(s):<br/>
    %s
    </p>
    <pre>
    %s
    </pre>
    ''' % ('<br/>'.join(missing_xpaths), newlineRe.sub('\n\g<1>', html_encode(rec.get_xml(session))))
        else:
            return None

    # end _validate_isadg()
    
    
    def preview_file(self, req):
        global session, repository_name, repository_link, repository_logo, cache_path, cache_url, toc_cache_path, toc_cache_url, toc_scripts, script, fullTxr, fullSplitTxr
        form = FieldStorage(req)
        self.htmlTitle.append('Preview File')
        self.htmlNav.append('<a href="/ead/admin/files.html" title="Preview File" class="navlink">Files</a>')
        try :
            files = glob.glob('%s/preview/%s.*' % (toc_cache_path, session.user.username))
            for f in files :
                os.remove(f)
        except:
            pass
        try:          
            files = glob.glob('%s/preview/%s*' % (cache_path, session.user.username))
            for f in files :
                os.remove(f)
        except:
            pass
        pagenum = int(form.getfirst('pagenum', 1))
        
        self.logger.log('Preview requested')

        recid=form.get('recid', None)
        if recid != None and recid != 'null' :
            rec = editStore.fetch_record(session, recid)
        if not isinstance(rec, LxmlRecord):
            return rec      
        # ensure restricted access directory exists
        try:
            os.makedirs(os.path.join(cache_path, 'preview'))
            os.makedirs(os.path.join(toc_cache_path, 'preview'))
        except OSError:
            pass # already exists

        recid = rec.id = 'preview/%s' % (session.user.username)    # assign rec.id so that html is stored in a restricted access directory
        paramDict = self.globalReplacements
        paramDict.update({'%TITLE%': ' :: '.join(self.htmlTitle)
                         ,'%NAVBAR%': ' | '.join(self.htmlNav)
                         ,'LINKTOPARENT': ''
                         ,'TOC_CACHE_URL' : toc_cache_url
                         , 'RECID': recid
                         })
        try:
            page = self.display_full(rec, paramDict)[pagenum-1]
        except IndexError:
            return 'No page number %d' % pagenum
        
        if not (os.path.exists('%s/%s.inc' % (toc_cache_path, recid))):
            page = page.replace('<!--#include virtual="%s/%s.inc"-->' % (toc_cache_url, recid), 'There is no Table of Contents for this file.')
        else:
            # cannot use Server-Side Includes in script generated pages - insert ToC manually
            try:
                page = page.replace('<!--#include virtual="%s/%s.inc"-->' % (toc_cache_url, recid), read_file('%s/%s.inc' % (toc_cache_path, recid)))
            except:
                page = page.replace('<!--#include virtual="%s/%s.inc"-->' % (toc_cache_url, recid), '<span class="error">There was a problem whilst generating the Table of Contents</span>')
 
        return page
    #- end preview_file()

    
    def send_xml(self, data, req, code=200):
        req.content_type = 'text/xml'
        req.content_length = len(data)
        req.send_http_header()
        if (type(data) == unicode):
            data = data.encode('utf-8')
        req.write(data)
        req.flush()       
    #- end send_xml()
    
    
    def build_ead(self, form):
        self.logger.log('building ead')
        ctype = form.get('ctype', None)
        level = form.get('location', None)
        collection = False;
        if (level == 'collectionLevel'):
            collection = True;
            tree = etree.fromstring('<ead><eadheader></eadheader><archdesc></archdesc></ead>')           
            header = tree.xpath('/ead/eadheader')[0]
            target = self._create_path(header, 'eadid')
            if form.get('eadid', '') != '':
                self._add_text(target, form.get('eadid', ''))
            else :
                self._add_text(target, form.get('pui', ''))
            target = self._create_path(header, 'filedesc/titlestmt/titleproper')
            self._add_text(target, form.get('did/unittitle', ''))     
            if form.get('filedesc/titlestmt/sponsor', '') != '': 
                target = self._create_path(header, 'filedesc/titlestmt/sponsor')   
                self._add_text(target, form.get('filedesc/titlestmt/sponsor', '')) 
            target = self._create_path(header, 'profiledesc/creation')
            if session.user.realName != '' :
                userName = session.user.realName
            else :
                userName = session.user.username
            self._add_text(target, 'Created by %s using the cheshire for archives ead creation tool ' % userName)
            target = self._create_path(header, 'profiledesc/creation/date')
            self._add_text(target, '%s' % datetime.date.today())
        else :
            tree = etree.fromstring('<%s id="%s"></%s>' % (ctype, level, ctype))           
        list = form.list     
        for field in list :
            if field.name not in ['ctype','location','operation','newForm','nocache','recid', 'parent', 'pui', 'eadid', 'filedesc/titlestmt/sponsor']:        
                #do did level stuff
                if (collection):
                    node = tree.xpath('/ead/archdesc')[0]
                else :
                    node = tree.xpath('/*[not(name() = "ead")]')[0]
                if field.name.find('controlaccess') == 0 :
                    self._create_controlaccess(node, field.name, field.value) 
                elif field.name.find('did/langmaterial') == 0 :
                    did = self._create_path(node, 'did')
                    self._create_langmaterial(did, field.value)
                else :
                    if (field.value.strip() != '' and field.value.strip() != ' '):
                        target = self._create_path(node, field.name)
                        self._add_text(target, field.value)
        self.logger.log('build complete')
        return tree    
    #- end build_ead    
        
            
    def _delete_path(self, startNode, nodePath):
        if not (startNode.xpath(nodePath)) :
            return 
        else :
            child = startNode.xpath(nodePath)[0]
            if nodePath.find('/') == -1 :
                parent = startNode
            else :
                parent = parent = startNode.xpath(''.join(nodePath[:nodePath.rfind('/')]))[0]
            parent.remove(child)
            if len(parent.getchildren()) > 0 :
                return
            else :
                return self._delete_path(startNode, nodePath[:nodePath.rfind('/')])
            

    def _create_path(self, startNode, nodePath):           
        self.logger.log('creating path %s ' % nodePath)    
        if (startNode.xpath(nodePath)):
            if (nodePath.find('@') == -1):
                return startNode.xpath(nodePath)[0]
            else :  
                if len(startNode.xpath(nodePath[:nodePath.rfind('/')])) > 0:
                    parent = startNode.xpath(nodePath[:nodePath.rfind('/')])[0]
                else :
                    parent = startNode
                attribute = nodePath[nodePath.rfind('@')+1:]
                return [parent, attribute]
        elif (nodePath.find('@') == 0):
            return self._add_attribute(startNode, nodePath[1:])
        elif (nodePath.find('/') == -1) :
            newNode = etree.Element(nodePath)                        
            return self._append_element(startNode, newNode)
        else :
            newNodePath = ''.join(nodePath[:nodePath.rfind('/')]) 
            nodeString = ''.join(nodePath[nodePath.rfind('/')+1:])  
            if (nodeString.find('@') != 0):      
                newNode = etree.Element(nodeString)
                return self._append_element(self._create_path(startNode, newNodePath), newNode)
            else:
                return self._add_attribute(self._create_path(startNode, newNodePath), nodeString[1:])  
            
                        
    def _append_element(self, parentNode, childNode):    
        parentNode.append(childNode)
        return childNode

    
    def _add_attribute(self, parentNode, attribute):
        self.logger.log('adding attribute')
        self.logger.log(parentNode)
        self.logger.log(attribute)
        parentNode.attrib[attribute] = ""
        return [parentNode, attribute]
 
        
    def _add_text(self, parent, textValue):
        self.logger.log('adding text with values: parent = %s textValue = %s' % (parent, textValue))
        if not (textValue.find('&') == -1):
            textValue = textValue.replace('&', '&#38;')
        textValue = textValue.lstrip()
        if isinstance(parent, etree._Element):
            self.logger.log('element')
            for c in parent.getchildren() :
                parent.remove(c)
            value = '<foo>%s</foo>' % textValue      
            try :
                nodetree = etree.fromstring(value)               
            except :
                self.errorFields.append(parent.tag)
                parent.text = textValue
            else :
                parent.text = nodetree.text
                for n in nodetree :
                    parent.append(n)
        else :
            self.logger.log('attribute')
            parent[0].attrib[parent[1]] = textValue


       
    def _delete_currentControlaccess(self, startNode, list=['subject','persname', 'famname', 'corpname', 'geogname', 'title', 'genreform']):
        if (startNode.xpath('controlaccess')):
            parent = startNode.xpath('controlaccess')[0]        
            for s in list :
                if (parent.xpath('%s' % s)) :
                    child = parent.xpath('%s' % s)
                    for c in child :
                        parent.remove(c)
            if len(parent.getchildren()) == 0 :
                startNode.remove(parent)
            
            
    def _delete_currentLangmaterial(self, startNode):
        did = startNode.xpath('did')[0]
        self.logger.log(did)
        if (did.xpath('langmaterial')):
            parent = did.xpath('langmaterial')[0]
            child = parent.xpath('language')
            if len(child) > 0 :
                for c in child :
                    parent.remove(c)
            did.remove(parent)
    
    
    def _create_langmaterial(self, startNode, value):
        self.logger.log('creating lang material')
        if not (startNode.xpath('langmaterial')):
            langmaterial = etree.Element('langmaterial')
            startNode.append(langmaterial)
            lmNode = langmaterial
        else:
            lmNode = startNode.xpath('langmaterial')[0]
        fields = value.split(' ||| ')
        language = etree.SubElement(lmNode, 'language', langcode='%s' % fields[0].split(' | ')[1])     
        text = fields[1].split(' | ')[1]
        language.text = text     
        self.logger.log(text)   
        
       
    def _create_controlaccess(self, startNode, name, value):
        if not (startNode.xpath('controlaccess')):
            controlaccess = etree.Element('controlaccess')
            #need to insert before dsc?
            startNode.append(controlaccess)
            caNode = controlaccess
        else:
            caNode = startNode.xpath('controlaccess')[0]   
        type = etree.Element(name[name.find('/')+1:])
        caNode.append(type)
        fields = value.split(' ||| ')
        for f in fields :
            if not (f == ''):
                field = f.split(' | ')
                typelabel = field[0].split('_')[0]
                fieldlabel = field[0].split('_')[1]
                if (fieldlabel == 'source' or fieldlabel == 'rules'):
                    if (field[1] != 'none') :
                        type.set(fieldlabel, field[1])               
                else :
                    if (fieldlabel == typelabel):
                        attributeValue = 'a'
                    else:
                        attributeValue = self.altrenderDict.get(fieldlabel, None)
                        if attributeValue == None :
                            attributeValue = fieldlabel
                    emph = etree.Element('emph', altrender='%s' % attributeValue)
                    emph.text = field[1]  
                    type.append(emph)    
    #- end _create_controlacess    
   
       
    def populate_form(self, recid, new, form):  
        #if its collection level give the transformer the whole record
        if (new == 'collectionLevel'):  
            retrievedDom = editStore.fetch_record(session, recid).get_dom(session)
            rec = LxmlRecord(retrievedDom)
           
        #if its a component find the component by id and just give that component to the transformer          
        else :
            retrievedXml = editStore.fetch_record(session, recid).get_xml(session)
            root = None
            tree = etree.XMLID(retrievedXml)
            node = tree[1].get(new)                
            for e in tree[0].getiterator() :
                if e == node :
                    root = deepcopy(e)
            
            if root == None :
                ctype = form.get('ctype', 'c')
                doc = StringDocument('<%s><recid>%s</recid></%s>' % (ctype, recid, ctype))
                rec = xmlp.process_document(session, doc)
            else :
                rec = LxmlRecord(root) 
        
        page = formTxr.process_record(session, rec).get_raw(session)
        page = page.replace('%PUI%', '<input type="text" onfocus="setCurrent(this);" name="pui" id="pui" size="30" disabled="true" value="%s"/>' % recid)
        return page.replace('%RECID%', '')

    
    def save_form(self, form):
        loc = form.get('location', None)
        recid = form.get('recid', None)
        parent = form.get('parent', None)
        if (loc == 'collectionLevel' and (recid == None or recid == 'None')):
            self.logger.log('new collection level')
            #save the form in any free slot
            rec = LxmlRecord(self.build_ead(form))
            rec = assignDataIdFlow.process(session, rec)
            recid = rec.id
            editStore.store_record(session, rec)
            editStore.commit_storing(session) 
            return recid
        elif (loc == 'collectionLevel'):
            list = form.list  
            #pull existing xml and make into a tree
            retrievedRec = editStore.fetch_record(session, recid)
            retrievedXml = retrievedRec.get_xml(session)
            tree = etree.fromstring(retrievedXml)
            
            node = tree.xpath('/ead/archdesc')[0]         
            #first delete current accesspoints
            self._delete_currentControlaccess(node)
            self._delete_currentLangmaterial(node)
            self.logger.log('deleted stuff')
            #change title in header 
            
            header = tree.xpath('/ead/eadheader')[0]
            if form.get('filedesc/titlestmt/sponsor', '').value.strip() != '' and form.get('filedesc/titlestmt/sponsor', '').value.strip() != ' ': 
                target = self._create_path(header, 'filedesc/titlestmt/sponsor')
                self._add_text(target, form.get('filedesc/titlestmt/sponsor', ''))
            else :
                self._delete_path(node, 'filedesc/titlestmt/sponsor')
#CHECK THAT THIS IS SOMETHING WE WANT IF SO COMMENT IN AND TEST
            
            #target = self._create_path(header, 'titlestmt/titleproper')
            #self._add_text(target, form.get('did/unittitle', ''))
            
            
            #cycle through the form and replace any node that need it
            for field in list :                
                if field.name not in ['ctype','location','operation','newForm','nocache','recid', 'parent', 'pui', 'filedesc/titlestmt/sponsor']:        
                    #self.logger.log('adding %s' % field.name)                
                    #do archdesc stuff
                    if field.name.find('controlaccess') == 0 :                        
                        self._create_controlaccess(node, field.name, field.value)      
                    elif field.name.find('did/langmaterial') == 0 :
                        did = self._create_path(node, 'did')
                        self._create_langmaterial(did, field.value)
                    else :
                        if (field.value.strip() != '' and field.value.strip() != ' '):
                            target = self._create_path(node, field.name)
                            self._add_text(target, field.value)       
                        else:
                            self._delete_path(node, field.name)     
                            
            rec = LxmlRecord(tree)
            rec.id = retrievedRec.id
            editStore.store_record(session, rec)
            editStore.commit_storing(session)
            return recid       
        #check if C exists, if not add it, if so replace it
        else :
            self.logger.log('component')
            self.logger.log('loc is %s' % loc)
            #pull record from store            
            retrievedRec = editStore.fetch_record(session, recid)
            retrievedxml= retrievedRec.get_xml(session)
            tree = etree.XMLID(retrievedxml)            
            #first check there is a dsc element and if not add one (needed for next set of xpath tests)
            self.logger.log('testing dsc exists')
            
            if not (tree[0].xpath('/ead/archdesc/dsc')):
                self.logger.log('dsc does not exist')
                archdesc = tree[0].xpath('/ead/archdesc')[0]    
                dsc = etree.Element('dsc')     
                archdesc.append(dsc)    

            #if the component does not exist add it
            if not (tree[1].get(loc)):
                self.logger.log('new component')
                self.logger.log('parent is %s' % parent)
                if parent == 'collectionLevel' :
                    parentNode = tree[0].xpath('/ead/archdesc/dsc')[0]
                else :
                    parentNode = tree[1].get(parent)
                parentNode.append(self.build_ead(form))
                rec = LxmlRecord(tree[0])
                rec.id = retrievedRec.id
                editStore.store_record(session, rec)
                editStore.commit_storing(session)   
                                             
            #if the component does exist change it
            else :   
                self.logger.log('existing component')
                list = form.list
                node = tree[1].get(loc) 
                #first delete current accesspoints
                self._delete_currentControlaccess(node)
                self._delete_currentLangmaterial(node)
                self.logger.log('deleted stuff')
                for field in list :
                    if field.name not in ['ctype','location','operation','newForm','nocache','recid', 'parent']:       
                        self.logger.log('adding %s' % field.name)     
                        if field.name.find('controlaccess') == 0 :                        
                            self._create_controlaccess(node, field.name, field.value)      
                        elif field.name.find('did/langmaterial') == 0 :
                            did = self._create_path(node, 'did')
                            self._create_langmaterial(did, field.value)
                        else :
                            if (field.value.strip() != '' and field.value.strip() != ' '):
                                target = self._create_path(node, field.name)
                                self._add_text(target, field.value)       
                            else:
                                self._delete_path(node, field.name)                              
                rec = LxmlRecord(tree[0])
                rec.id = retrievedRec.id
                editStore.store_record(session, rec)
                editStore.commit_storing(session)
            return recid    
    
    
    def _add_componentIds (self, rec):
        tree = etree.fromstring(rec.get_xml(session))
        compre = re.compile('^c[0-9]*$')
        for element in tree.getiterator():
            try :
                if compre.match(element.tag):
                    if not element.get('id'):
                        #add the appropriate id!
                        posCount = 1
                        parentId = ''
                        for el in element.itersiblings(preceding=True):
                            if compre.match(el.tag):
                                posCount += 1
                        #get the parent component id and use it 
                        for el in element.iterancestors():
                            if compre.match(el.tag):
                                parentId = el.get('id')                                
                                break
                        idString = '%d-%s' % (posCount, parentId)
                        if idString[-1] == '-':
                            idString = idString[:-1]
                        element.set('id', idString)                               
            except :
                continue
        return LxmlRecord(tree)
                    
                
    def _get_depth (self, node):
        compre = re.compile('^c[0-9]*$')
        depth = 0;
        for element in node.iterancestors():
            if compre.match(element.tag) or element.tag == 'archdesc':
                depth += 1
        return depth                
    
    
    def add_form(self, form):
        recid = form.get('recid', None)
        level = int(form.get('clevel', None))
        stringLevel = '%02d' % (level)
        self.logger.log(stringLevel)
        doc = StringDocument('<c%s><recid>%s</recid></c%s>' % (stringLevel, recid, stringLevel))
        rec = xmlp.process_document(session, doc)
        htmlform = formTxr.process_record(session, rec).get_raw(session)
        htmlform = htmlform.replace('%PUI%', '<input type="text" onfocus="setCurrent(this);" name="pui" id="pui" size="30" disabled="true" value="%s"/>' % recid)
        return htmlform


    def delete_record(self, form):
        recid = form.get('recid', None)
        if not recid == None :
            editStore.delete_record(session, recid)
        return 'done'


    def navigate(self, form):    
        recid = form.get('recid', None)
        new = form.get('newForm', None)
        page = self.populate_form(recid, new, form)  
        return page 
         
         
    def generate_file(self, form):
        structure = read_file('ead2002.html')
        doc = StringDocument('<ead><eadheader></eadheader><archdesc></archdesc></ead>')         
        rec = xmlp.process_document(session, doc)
        htmlform = formTxr.process_record(session, rec).get_raw(session)
        page = structure.replace('%FRM%', htmlform) 
        page = page.replace('%RECID%', '')
        page = page.replace('%PUI%', '<input type="text" onfocus="setCurrent(this);" name="pui" id="pui" size="30" readonly="true" class="readonly"/>')
        page = page.replace('%TOC%', '<b><a id="collectionLevel" name="link" class="selected" onclick="javascript: displayForm(this.id)" href="#" style="display: inline">Collection Level</a></b>')  
        return page


    def reset(self, form):
        doc = StringDocument('<ead><eadheader></eadheader><archdesc></archdesc></ead>')         
        rec = xmlp.process_document(session, doc)
        page = formTxr.process_record(session, rec).get_raw(session)
        page = page.replace('%RECID%', '')
        page = page.replace('%PUI%', '<input type="text" onfocus="setCurrent(this);" name="pui" id="pui" size="30" readonly="true" class="readonly"/>')        
        return page
    
    
    def _add_revisionDesc(self, rec):
        tree = rec.get_dom(session)
        if session.user.realName != '' :
            userName = session.user.realName
        else :
            userName = session.user.username
        if tree.xpath('/ead/eadheader/revisiondesc'):
           
            if tree.xpath('/ead/eadheader/revisiondesc/change'):
                parent = tree.xpath('/ead/eadheader/revisiondesc')[0]
                new = etree.Element('change')
                date = etree.Element('date')
                date.text = '%s' % datetime.date.today()
                new.append(date)
                item = etree.Element('item')
                item.text = 'Edited by %s using the cheshire for archives ead creation tool' % userName
                new.append(item)
                parent.append(new)
            elif tree.xpath('/ead/eadheader/revisiondesc/list'):
                parent = tree.xpath('/ead/eadheader/revisiondesc/list')[0]
                item = etree.Element('item')
                item.text = 'Edited by %s using the cheshire for archives ead creation tool on %s'  % (userName, datetime.date.today())
                parent.append(item)
        else :
            header = tree.xpath('/ead/eadheader')[0]
            target = self._create_path(header, '/ead/eadheader/revisiondesc/change/date')
            self._add_text(target, '%s' % datetime.date.today())
            target = self._create_path(header, '/ead/eadheader/revisiondesc/change/item')
            self._add_text(target, 'Edited by %s using the cheshire for archives ead creation tool' % userName)   
        return LxmlRecord(tree)


    def load_file(self, form):
        recid = form.get('recid', None)
        if not recid == None:
            try :
                rec = editStore.fetch_record(session, recid)
            except:
                #to do - fix this
                pass
            else :
                structure = read_file('ead2002.html') 
                htmlform = formTxr.process_record(session, rec).get_raw(session)
                page = structure.replace('%FRM%', htmlform) 
                page = page.replace('%RECID%', '<input type="hidden" id="recid" value="%s"/>' % recid)
                page = page.replace('%PUI%', '<input type="text" onfocus="setCurrent(this);" name="pui" id="pui" size="30" disabled="true" value="%s"/>' % recid)
                page = page.replace('%TOC%', tocTxr.process_record(session, rec).get_raw(session))
                return page
        

    def edit_file(self, form):
        f = form.get('filepath', None)
        if not f or not len(f.value):
            #create appropriate html file - this is for admin
            return read_file('upload.html')
        ws = re.compile('[\s]+')
        xml = ws.sub(' ', read_file(f))
        rec = self._add_componentIds(self._parse_upload(xml))
                
        # TODO: handle file not successfully parsed
        if not isinstance(rec, LxmlRecord):
            return rec
        
        val = self._validate_isadg(rec)
        if (val): return val
        del val      
        
        rec1 = self._add_revisionDesc(rec)
        rec2 = assignDataIdFlow.process(session, rec1)
        recid = rec2.id
        
        editStore.store_record(session, rec2)
        editStore.commit_storing(session) 
        structure = read_file('ead2002.html') 
        htmlform = formTxr.process_record(session, rec2).get_raw(session)
        page = structure.replace('%FRM%', htmlform) 
        page = page.replace('%RECID%', '<input type="hidden" id="recid" value="%s"/>' % recid)
        page = page.replace('%PUI%', '<input type="text" onfocus="setCurrent(this);" name="pui" id="pui" size="30" disabled="true" value="%s"/><input type="hidden" id="filename" value="%s"/>' % (recid, f))
        page = page.replace('%TOC%', tocTxr.process_record(session, rec2).get_raw(session))
        self.logger.log(tocTxr.process_record(session, rec2).get_raw(session))
        return page    
    
    
    def display(self, req):
        form = FieldStorage(req)
        recid=form.get('recid', None)
        if recid != None and recid != 'null' :
            retrievedRec = editStore.fetch_record(session, recid)
            #retrievedxml= retrievedRec.get_xml(session)
            #tree = etree.fromstring(retrievedxml)
            #return etree.tostring(tree)
            #raise ValueError(orderTxr.process_record(session, retrievedRec).get_raw(session))
            return orderTxr.process_record(session, retrievedRec).get_raw(session)
        else :
            return '<p>Unable to display xml</p>'
    
       
    def checkId(self, form):
        id = form.get('id', None)
        store = form.get('store', None)
        if store == 'recordStore' :
            rs = recordStore
        elif store == 'editStore' :
            rs = editStore
        if (id != None):
            exists = 'false'
            for r in rs:
                if r.id == id :
                    exists = 'true'
                    break;
            return '<value>%s</value>' % exists
    
    
    def _get_timeStamp(self):
        return time.strftime('%Y-%m-%dT%H%M%S')
    
    
    def validate_record(self, xml):
        try :
            etree.fromstring(xml)
            return True
        except :
            return False
    
    
    def _get_genericHtml(self, fn):
        global repository_name, repository_link, repository_logo
        html = read_file(fn)
        paramDict = self.globalReplacements
        paramDict.update({'%TITLE%': ' :: '.join(self.htmlTitle)
                         ,'%NAVBAR%': ' | '.join(self.htmlNav)
                         })
        return multiReplace(html, paramDict)
    
    
    def submit(self, req, form):
        global sourceDir, ppFlow, xmlp
        req.content_type = 'text/html'
        req.send_http_header()
        head = self._get_genericHtml('header.html')
        req.write(head + '<div id="wrapper">')
        
        recid = form.get('recid', None)
        recid = recid.value
        fileName = form.get('filename', None)
        self.logger.log(fileName)
        rec = editStore.fetch_record(session, recid)
        xml = rec.get_xml(session)    
        valid = self.validate_record(xml)    
        exists = True 
        if valid :
            #delete and unindex the old version from the record store
            try : 
                oldRec = recordStore.fetch_record(session, recid)
            except :
                #this is a new record so we don't need to delete anything
                exists = False
                req.write('<span class="error">[ERROR]</span> - Record not present in recordStore<br/>\n')
            else :
                req.write('undindexing existing version of record... ')
                db.unindex_record(session, oldRec)
                req.write('record unindexed')
                db.remove_record(session, oldRec)
                req.write('<span class="ok">[OK]</span><br/>\nDeleting record from stores ...')
                
                recordStore.begin_storing(session)
                recordStore.delete_record(session, oldRec.id)
                recordStore.commit_storing(session)
                
                dcRecordStore.begin_storing(session)
                try: dcRecordStore.delete_record(session, rec.id)
                except: pass
                else: dcRecordStore.commit_storing(session)
                req.write('[OK]')
                if len(rec.process_xpath(session, 'dsc')) and exists :
                    # now the tricky bit - component records
                    compStore.begin_storing(session)
                    q = CQLParser.parse('ead.parentid exact "%s/%s"' % (oldRec.recordStore, rec.id))
                    req.write('Removing components')
                    rs = db.search(session, q)
                    for r in rs:
                        try:
                            compRec = r.fetch_record(session)
                        except (c3errors.FileDoesNotExistException, c3errors.ObjectDoesNotExistException):
                            pass
                        else:
                            db.unindex_record(session, compRec)
                            db.remove_record(session, compRec)
                            compStore.delete_record(session, compRec.id)
         
                    compStore.commit_storing(session)
                    req.write('components removed')
            #add and index new record
            req.write('indexing new record... ')
            doc = ppFlow.process(session, StringDocument(xml))
            rec = xmlp.process_document(session, doc)
            assignDataIdFlow.process(session, rec)
            
            db.begin_indexing(session)
            recordStore.begin_storing(session)
            dcRecordStore.begin_storing(session)
            
            indexNewRecordFlow.process(session, rec)
            
            recordStore.commit_storing(session)
            dcRecordStore.commit_storing(session)
            
            
            if len(rec.process_xpath(session, 'dsc')):
                compStore.begin_storing(session)
                # extract and index components
                compRecordFlow.process(session, rec)
                compStore.commit_storing(session)
                db.commit_indexing(session)
                db.commit_metadata(session)
                req.write('[OK]')
            else :
                db.commit_indexing(session)
                db.commit_metadata(session)   
                req.write('[OK]')
            # write to file
            if os.path.exists(fileName):
                os.remove(fileName)
            try :
                file = open(filename, 'w')
            except :
                file = open(os.path.join(sourceDir,recid), 'w')
            file.write(etree.tostring(rec.get_dom(session), pretty_print=True, xml_declaration=True ))
            file.close     
            editStore.delete_record(session, rec.id)
            editStore.commit_storing(session)
            req.write('\n<p><a href="/ead/admin/files.html">Back to \'File Management\' page.</a></p>')
            foot = self._get_genericHtml('footer.html')          
            req.write('</div>' + foot)
        return None 
    
    
    def validateField(self, form):
        text = form.get('text', None)
        if not text.find('<') == -1:
            try :
                test = etree.fromstring('<foo>%s</foo>' % text)
                return '<value>true</value>'
            except :
                return '<value>false</value>'
        else :
            return '<value>true</value>'
    
    
    def show_editMenu(self):
        global sourceDir
      #  self.htmlTitle.append('Edit/Create')
        self.logger.log('Create/Edit Options')
        page = read_file('editmenu.html')
        files = self._walk_directory(sourceDir, 'radio')
        recids = self._walk_store('editingStore', 'radio')
        return multiReplace(page, {'%%%SOURCEDIR%%%': sourceDir, '%%%FILES%%%': ''.join(files), '%%%RECORDS%%%': ''.join(recids)})
       
             
    def _walk_store(self, storeName, type='checkbox'):
        store = db.get_object(session, storeName)
        out = []
        for s in store :
            out.extend(['<li>'
                       ,'<span class="fileops"><input type="%s" name="recid" value="%s"/></span>' % (type, s.id)
                       ,'<span class="filename">%s</span>' % s.id
                       ,'</li>'
                       ])
        return out
                      
                
    def handle (self, req):
        global script
        form = FieldStorage(req, True)  
        tmpl = read_file(templatePath)
        content = None      
        operation = form.get('operation', None)
        if (operation) :     
            if (operation == 'add'):  
                content = self.add_form(form)   
                self.send_html(content, req)
            elif (operation == 'save'):
                content = self.save_form(form)
                self.send_xml('<recid>%s</recid>' % content, req)
            elif (operation == 'delete'):
                content = self.delete_record(form)
                self.send_xml('<recid>%s</recid>' % content, req)
            elif (operation == 'navigate'):
                content = self.navigate(form)
                self.send_html(content, req)
            elif (operation == 'display'):
                content = self.display(req)
                self.send_xml(content, req)
            elif (operation == 'preview'):
                content = self.preview_file(req)
                self.send_html(content, req)     
            elif (operation == 'checkId'):
                content = self.checkId(form)
                self.send_xml(content, req)
            elif (operation == 'validate'):
                content = self.validateField(form)
                self.send_xml(content, req)  
            elif (operation == 'reset'):
                content = self.reset(form)
                self.send_html(content, req)
            elif (operation == 'view'):
                content = self.view_file(form)   
                self.send_fullHtml(content, req)         
            elif (operation == 'submit'):
                content = self.submit(req, form)
            elif (operation == 'edit'):                
                content = self.edit_file(form)
                self.send_fullHtml(content, req) 
            elif (operation == 'load'):
                content = self.load_file(form)
                self.send_fullHtml(content, req)             
            elif (operation == 'create'):
                content = self.generate_file(form)
                self.send_fullHtml(content, req) 
        else :              
            content = self.show_editMenu()
            content = '<div id="wrapper">%s</div>' % (content)
            page = multiReplace(tmpl, {'%REP_NAME%': repository_name,
                     '%REP_LINK%': repository_link,
                     '%REP_LOGO%': repository_logo,
                     '%TITLE%': ' :: '.join(self.htmlTitle),
                     '%NAVBAR%': '',#' | '.join(self.htmlNav),
                     '%CONTENT%': content
                     })

            # send the display
            self.send_html(page, req)
                     
    
        #- end handle() ---------------------------------------------------
        
    #- end class EadEditingHandler ----------------------------------------
    
#- Some stuff to do on initialisation

rebuild = True
serv = None
session = None
db = None
baseDocFac = None
sourceDir = None
editStore = None
recordStore = None
authStore = None
assignDataIdFlow = None
compRecordFlow = None
indexNewRecordFlow = None
preParserWorkflow = None
xmlp = None
formTxr = None
tocTxr = None
orderTxr = None
logfilepath = editinglogfilepath

def build_architecture(data=None):
    global session, serv, db, editStore, recordStore, dcRecordStore, compStore, authStore, formTxr, tocTxr, orderTxr, xmlp, assignDataIdFlow, indexNewRecordFlow, compRecordFlow, ppFlow, sourceDir, baseDocFac
    #Discover objects
    session = Session()
    session.database = 'db_ead'
    session.environment = 'apache'
    session.user = None
    serv = SimpleServer(session, '/home/cheshire/cheshire3/cheshire3/configs/serverConfig.xml')
    db = serv.get_object(session, 'db_ead')
    baseDocFac = db.get_object(session, 'baseDocumentFactory')
    sourceDir = baseDocFac.get_default(session, 'data')
    editStore = db.get_object(session, 'editingStore')
    recordStore = db.get_object(session, 'recordStore')
    dcRecordStore = db.get_object(session, 'eadDcStore')
    compStore = db.get_object(session, 'componentStore')
    authStore = db.get_object(session, 'eadAuthStore')
    assignDataIdFlow = db.get_object(session, 'assignDataIdentifierWorkflow')
    compRecordFlow = db.get_object(session, 'buildComponentWorkflow')
    indexNewRecordFlow = db.get_object(session, 'indexNewRecordWorkflow')
    ppFlow = db.get_object(session, 'preParserWorkflow')
    # transformers
    xmlp = db.get_object(session, 'LxmlParser')
    formTxr = db.get_object(session, 'formCreationTxr')
    tocTxr = db.get_object(session, 'editingTocTxr')
    orderTxr = db.get_object(session, 'orderingTxr')
    rebuild = False



def handler(req):

    global rebuild, logfilepath, cheshirePath, db, editStore, xmlp, formTxr, tocTxr, script                # get the remote host's IP
    script = req.subprocess_env['SCRIPT_NAME']
    req.register_cleanup(build_architecture)

    try :

        remote_host = req.get_remote_host(apache.REMOTE_NOLOOKUP)
        os.chdir(os.path.join(cheshirePath, 'cheshire3', 'www', 'ead', 'html'))     # cd to where html fragments are
        lgr = FileLogger(logfilepath, remote_host)                                  # initialise logger object
        eadEditingHandler = EadEditingHandler(lgr)                                      # initialise handler - with logger for this request
        try:
            eadEditingHandler.handle(req)   
        finally:
            try:
                lgr.flush()
            except:
                pass
            del lgr, eadEditingHandler                                          # handle request
    except:
        req.content_type = "text/html"
        cgitb.Hook(file = req).handle()                                         # give error info
    else :
        return apache.OK

def authenhandler(req):
    global session, authStore, rebuild
    if (rebuild):
        build_architecture()                                                    # build the architecture
    pw = req.get_basic_auth_pw()
    un = req.user
    try: session.user = authStore.fetch_object(session, un)
    except: return apache.HTTP_UNAUTHORIZED    
    if (session.user and session.user.password == crypt(pw, pw[:2])):
        return apache.OK
    else:
        return apache.HTTP_UNAUTHORIZED
#- end authenhandler()


#- end handler()