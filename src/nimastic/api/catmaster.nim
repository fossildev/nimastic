import strutils, httpclient
import ../transport

type
    catMaster* = object
        #query params
        Format*:            string
        H*:                 seq[string]
        Help*:              bool
        Local*:             bool
        S*:                 seq[string]
        V*:                 bool
        ExpandWildcards*:   string

        Pretty*:    bool
        Human:      bool
        ErrorTrace: bool
        FilterPath: seq[string]


method Do*(this: catMaster, c: var elClient): Response {.base.} =

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
    c.Endpoint = "/_cat/master"

    return c.estransport()
