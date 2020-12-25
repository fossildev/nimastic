import strutils, httpclient
import ../transport

type
    catNodes* = object
        #query
        Format*: string
        Bytes*: string
        FullId*: bool
        H*: seq[string]
        Help*: bool
        Local*: bool
        S*: seq[string]
        Time*: string
        V*: bool

        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]


method Do*(this: catNodes, c: var elClient): Response {.base.} =

    var q = ""

    # format 
    if this.Format != "" :
        q.add("&format=" & this.Format)

    #bytes
    if this.Bytes != "":
        q.add("&bytes=" & this.Bytes)

    if this.FullId:
        q.add("&full_id")

    if len(this.H) > 0:
        q.add("&h=" & join(this.H,","))
    
    #time
    if this.Time != "" :
        q.add("&time=" & this.Time)

    if this.Help :
        q.add("&help")

    if this.Local :
        q.add("&local")

    if len(this.S) > 0:
        q.add("&s=" & join(this.S,","))

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

    c.Query = q
    c.Method = HttpGet
    c.Endpoint = "/_cat/nodes"

    return c.estransport()