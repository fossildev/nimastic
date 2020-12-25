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

        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]


method Do*(this: catMaster, c: var elClient): Response {.base.} =

    # query
    var q = ""
    
    # format += 
    if this.Format != "" :
        q.add("&format=" & this.Format)

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

    if this.Human :
        q.add("&human")

    if this.ErrorTrace :
        q.add("&error_trace") 

    if len(this.FilterPath) > 0 :
        q.add("&filter_path=" & join(this.FilterPath, ",") )
    
    # add query to elasticsearch.Query
    c.Query = q
    # add method to elasticsearch.Method
    c.Method = HttpGet
    c.Endpoint = "/_cat/master"

    return c.estransport()
