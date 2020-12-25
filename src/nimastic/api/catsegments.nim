import strutils, httpclient
import ../transport

type
    catSegments* = object
        Target*: seq[string]
        #query
        Format*: string
        H*: seq[string]
        Help*: bool
        S*: seq[string]
        V*: bool

        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]

method Do*(this: catSegments, c: var elClient): Response {.base.} =

    var q = ""

    # format 
    if this.Format != "" :
        q.add("&format=" & this.Format)

    if len(this.H) > 0 :
        q.add("&h=" & join(this.H,","))

    if this.Help :
        q.add("&help")

    if len(this.S) > 0:
        q.add("&s=" & join(this.S, ","))

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
    c.Endpoint = "/_cat/segments"

    if len(this.Target) > 0 :
        c.Endpoint.add("/" & join(this.Target, ","))

    return c.estransport()