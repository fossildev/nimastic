import strutils, httpclient
import ../transport

type
    catIndices* = object
        Target*: seq[string]
        #query
        Bytes*: string
        Format*: string
        H*: seq[string]
        Health*: string
        Help*: bool
        IncludeUnloadedSegments*: bool
        Local*: bool
        MasterTimeout*: string
        Pri*: bool
        S*: seq[string]
        Time*: string
        V*: bool
        ExpandWildcards*: seq[string]

        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]


method Do* (this: catIndices, c: var elClient): Response {.base.} =

    var q = ""

    # format 
    if this.Format != "" :
        q.add("&format=" & this.Format)
    
     #bytes
    if this.Bytes != "" :
        q.add("&bytes=" & this.Bytes)    

    if len(this.H) > 0:
        let hStr = join(this.H,",")
        q.add("&h=" & hStr)

    if this.Health != "":
        q.add("&health=" & this.Health)

    if this.Help :
        q.add("&help")

    if this.IncludeUnloadedSegments:
        q.add("&include_unloaded_segments")

    if this.Local:
        q.add("&local")

    if this.MasterTimeout != "" :
        q.add("&master_timeout=" & this.MasterTimeout)

    if this.Pri:
        q.add("&pri")

    if len(this.S) > 0 :
        let sStr = join(this.S, ",")
        q.add("&s=" & sStr)

    if this.Time != "" :
        q.add("&time=" & this.Time)

    if this.V:
        q.add("&v")

    if len(this.ExpandWildcards) > 0 :
        q.add("&expand_wildcards=" & join(this.ExpandWildcards,","))

    if this.Pretty :
        q.add("&pretty")

    if this.Human :
        q.add("&human")

    if this.ErrorTrace :
        q.add("&error_trace") 

    if len(this.FilterPath) > 0 :
        q.add("&filter_path=" & join(this.FilterPath, ",") )

    c.Query = q
    c.Method = HttpGet
    c.Endpoint = "/_cat/indices"

    if len(this.Target) > 0:
        let targetStr = join(this.Target, ",")
        c.Endpoint.add("/" & targetStr)

    return c.estransport()
    

    