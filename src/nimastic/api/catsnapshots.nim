import strutils, httpclient
import ../transport

type
    catSnapshots* = object
        Repository*: string
        #query
        Format*: string
        H*: seq[string]
        Help*: bool
        IgnoreUnavailable*: bool
        MasterTimeout*: string
        S*: seq[string]
        Time*: string
        V*: bool
        
        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]

method Do*(this: catSnapshots, c: var elClient): Response {.base.} =

    var q = ""

    # format 
    if this.Format != "" :
        q.add("&format=" & this.Format)

    if len(this.H) > 0 :
        q.add("&h=" & join(this.H,","))

    if this.Help :
        q.add("&help")

    if this.IgnoreUnavailable :
        q.add("&ignore_unavailable")

    if this.MasterTimeout != "" :
        q.add("&master_timeout=" & this.MasterTimeout)

    if len(this.S) > 0:
        q.add("&s=" & join(this.S, ","))

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

    c.Query = q
    c.Method = HttpGet
    c.Endpoint = "/_cat/snapshots"

    if this.Repository != "" :
        c.Endpoint.add("/" & this.Repository)

    return c.estransport()