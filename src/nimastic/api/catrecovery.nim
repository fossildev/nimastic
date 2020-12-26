import strutils, httpclient
import ../transport

type
    catRecovery* = object
        Target*: seq[string]
        #query
        Format*: string
        ActiveOnly*: bool
        Bytes*: string
        Detailed*: bool
        H*: seq[string]
        Help*: bool
        Index*: seq[string]
        S*: seq[string]
        Time*: string
        V*: bool

        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]

method Do*( c: var elClient, this: catRecovery ): Response {.base.} =

    var q = ""

    # format 
    if this.Format != "" :
        q.add("&format=" & this.Format)

    #bytes
    if this.Bytes != "" :
        q.add("&bytes=" & this.Bytes) 
    
    if this.Detailed :
        q.add("&detailed")

    if len(this.H) > 0 :
        q.add("&h=" & join(this.H, ","))

    if this.Help :
        q.add("&help")

    if len(this.Index) > 0 :
        q.add("&index=" & join(this.Index,","))

    if len(this.S) > 0 :
        q.add("&s=" & join(this.S,","))

    if this.Time != "" :
        q.add("&time=" & this.Time)

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
    c.Endpoint = "/_cat/recovery"

    if len(this.Target) > 0:
        c.Endpoint.add("/" & join(this.Target, ","))

    return c.estransport()  

    

    
