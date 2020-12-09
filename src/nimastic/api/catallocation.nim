import strutils, httpclient
import ../transport

type
    catAllocation* = object
         #query params
        NodeId*:            seq[string]
        Bytes*:             string
        Format*:            string
        H*:                 seq[string]
        Help*:              bool
        Local*:             bool
        S*:                 seq[string]
        V*:                 bool
        MasterTimeout*:     int
        Pretty*:            bool
        Human:              bool
        ErrorTrace:         bool
        FilterPath:         seq[string]

method Do*(this: catAllocation, c: var elClient): Response = 

    # querz
    var q = ""
    
    # format += 
    if this.Format == "text":
        q.add("format=text")
    elif this.Format == "json" :
        q.add("format=json")
    elif this.Format == "smile":
        q.add("format=smile")
    elif this.Format == "yaml":
        q.add("format=yaml")
    elif this.Format == "cbor":
        q.add("format=cbor")

    if this.Bytes != "":
        case this.Bytes:
        of "b": q.add("&bytes=b")
        of "kb": q.add("&bytes=kb")
        of "mb": q.add("&bytes=mb")
        of "gb": q.add("&bytes=gb")
        of "tb": q.add("&bytes=tb")
        of "pb": q.add("&bytes=pb")
        else: 
            echo "not found"
            #add exeption in logger

    #h (Optional, string) Comma-separated list of column names to display.    
    if len(this.H) > 0 :
        let hStr = join(this.H, ",")
        q.add("&h=" & hStr)
    
    #help  If true, the response includes help information. Defaults to false.
    if this.Help :
        q.add("&help")

    if this.Local :
        q.add("&local")

    if len(this.S) > 0 :
        let sStr = join(this.S, ",")
        q.add("&s=" & sStr)

    if this.V :
        q.add("&v")

    if this.Pretty :
        q.add("&pretty")
    
    # add query to elasticsearch.Query
    c.Query = q
    # add method to elasticsearch.Method
    c.Method = HttpGet
    c.Endpoint = "/_cat/aliases"

    if len(this.NodeId) > 0 :
        let aStr = join(this.NodeId, ",")
        c.Endpoint.add("/" & aStr)
    

    return c.estransport()