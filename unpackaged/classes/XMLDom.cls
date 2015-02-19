public class XMLDom {
    // Constructor 
    public XMLDom(string str) { parseFromString(str); } 
    public XMLDom(          ) { }
    public void parseFromString(string str) {   
        XmlStreamReader reader = new XmlStreamReader(str);
        reader.setCoalescing(true);
        parseXmlReader (root , reader); 
    } 
     
    // debugging assistance
    public void dumpAll() { root.dumpAll(); } 
    public void dumpList(Element[] l) { for(Element e:l) e.dump(); }
    
    // given a parent node and a stream reader, populates the tree below here (recursive)
    void parseXmlReader( Element parent, XmlStreamReader reader ) {
        try {
        while(reader.hasNext()) {
        
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                Element child = new Element( reader.getLocalName() );
                
                // add all attributes from this element
                for (integer i=0; i<reader.getAttributeCount(); i++) { 
                    child.attributes.put(   reader.getAttributeLocalName(i), reader.getAttributeValueAt(i) );
                }
                // add namespace info to each node/element ( for now storing on attributes map)
                for (integer j=0; j<reader.getNamespaceCount(); j++) { 
                    string prefix = 'xmlns'; 
                    if (reader.getnamespaceprefix(j)!=null)
                         prefix = reader.getnamespaceprefix(j); 
                    child.attributes.put( prefix , reader.getnamespaceuriat(j) );
                } 
                
                parent.appendChild(child); // add the new element to current parent
                reader.next();
                
                parseXmlReader(child, reader) ; // recurse
                
            } else if (reader.getEventType() == XmlTag.END_ELEMENT) {   
                reader.next();
                return; 
                
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                if ( ! reader.isWhitespace()) { 
                    parent.nodeValue += reader.getText();  // add text to current element
                }
                reader.next();
                
            }
            else { 
                reader.next(); 
            }   
        }
        } catch(Exception e) { // ParseError if we get a truncated response, allow it
            system.debug(e);
        }
    }   
    
    // access nodes in the tree using these getters
    public List<Element> getElementsByTagName(string nam) {
        return root.getElementsByTagName(nam); 
    }
    public List<Element> getElementsByPath(string path) {   
        return root.getElementsByPath( path);
    }
    public Element getElementByPath(string path) {  
        List<Element> r = root.getElementsByPath( path);
        if (r.size() == 0) return null; 
        return r[0];
    }
    public Element getElementByTagName(string nam) {
        List<Element> r = root.getElementsByTagName(nam);
        if (r.size() == 0) return null; 
        return r[0];
    }

    // utility dom functions
    public Element ownerDocument() { return root; }

    // everything in the dom is found as childNodes under this root element
    public Element root = new Element('#document');
    public integer debug =0;
        // dump out the element tree
    public String toXmlString() { return root.toXmlString(); }
    
    public class Element {
    //  Element(Element p, string n) {      parentNode = p;         nodeName = n;       } 
    public Element(string n) {  nodeName = n; } 
    public Element() {  }

    public string getAttribute(string name) { 
        return attributes.get(name); 
    }
    public void appendChild(Element e) {
        e.ParentNode = this; 
        this.childNodes.add(e);     
    }
    public void removeChild(Element e) {
        Element p = e.parentNode;
        List<Element> kids = new List<Element> {};
        for( Element ee: e.parentNode.childNodes) {
            if (ee != e) 
                kids.add(ee); 
        }
        p.childNodes = kids;
    }
    // traverse below this node, returning all matching nodes by name
    public List<Element> getElementsByTagName(string nam) { 
        List<Element> ret = new List<Element>{};
        if (nam == this.nodeName) ret.add(this);
        for (Element c: this.childNodes) { 
            ret.addAll( c.getElementsByTagName(nam) ); // decend tree
        }
        return ret;
    }
    // like above, but just returns the first one that matches  
    public Element getElementByTagName(string nam) {
        List<Element> r =   getElementsByTagName(nam);
        if (r.size() == 0) return null; 
        return r[0];
    }
    // first one that matches, just return the nodeValue
    public string getValue(string nam) {
        Element e = getElementByTagName(nam); 
        return (e==null?null:e.nodeValue); 
    }

    // some debugging help  
    public void dump() { dump('');}
    public void dump(string pre) { // just current node
        system.debug( pre + ' ' +this.nodeName + '->' + this.nodeValue + ' ' + this.attributes );  
    }
    public void dumpAll() { dumpAll('');    }
    public void dumpAll(string pre) { // node and all children
        system.debug( pre + this.nodeName + '->' + this.nodeValue + ' ' + this.attributes );  
        for (Element c: this.childNodes) { 
            c.dumpAll(pre+'   '); 
        }
    }
    public string toXmlString() {
        string ret = '<' + this.nodeName + ' ';
        for (  string a : attributes.keySet() ) {
            ret += a + '=\'' + attributes.get(a) + '\' ' ;
        }
        
        if ( nodeValue == '' && childNodes.size() == 0 ) { 
            return ret + ' />\n';   
        }
        
        ret += '>';
        if (nodeValue == '' ) 
            ret += '\n';
        
        integer hasChilds = 0;
        string tmpRet = '';
        for (Element c: this.childNodes) {  
            tmpRet += c.toXmlString() ;
            hasChilds++; 
        }   
        if (hasChilds > 0 ) ret += tmpRet;
        
        if (nodeValue != '' ) 
            ret += nodeValue;
            
        return ret + '</' + this.nodeName + '>\n'; 
    }
    
    public List<Element> getElementsByPath(string path) {   
        List<Element> ret = new List<Element>{};
        if ( Pattern.matches(path, this.path()) ) ret.add(this);
        for (Element c: this.childNodes) ret.addAll( c.getElementsByPath(path) );
        return ret;
    }    
    public string path() { 
        Element t = this;
        string ret = t.nodeName; 
        while (t.parentNode != null && t.parentNode.nodeName != '#document') { 
            t = t.parentNode;
            ret = t.nodeName + '/'+ret;
        }
        return '/'+ret;
    }
    
    // utility methods
    public Element firstChild() { 
        if ( this.childNodes.size() == 0 ) return null; 
        return this.childNodes[0]; 
    }
    public string textContent() { return this.nodeValue; } 
    public boolean hasChildNodes() { return childNodes.size()>0; }
    public boolean isEqualNode(Element comp) { return this.nodeName == comp.nodeName; } 
    public Element cloneNode() { return this.clone(); } 
    public boolean hasAttributes() { return ! attributes.isEmpty(); } 
    public boolean isSameNode(Element comp) { return this === comp; }       
    public Element ownerDocument() { 
        Element ret = this; 
        while( ret.parentNode != null) { ret = ret.parentNode; }            
        return ret; 
    } 
    
    // properties
    public Element parentNode = null; // only root has a null parent 
    public string nodeName = ''; 
    public string nodeValue = ''; 
    public List<Element> childNodes = new List<Element>();
    public map<String,String> attributes = new map<String,String>();
    
 }
}