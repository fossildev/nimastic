import strutils, httpclient
import ../transport

type
    catTransforms* = object
        Transform*: string
        #query
        Format*: string
        AllowNoMatch*: bool
        From*: int
        H*: seq[string]
        Help*: bool
        S*: seq[string]
        Size*: string
        Time*: string
        V*: bool

        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]

method Do*( c: var elClient, this: catTransforms ): Response {.base.} =

    var q = ""

    # format 
    if this.Format != "" :
        q.add("&format=" & this.Format)

    if this.AllowNoMatch :
        q.add("&allow_no_match")

    if this.From != 0 :
        q.add("&from=" & intToStr(this.From))

    if this.Help :
        q.add("&help")

    if len(this.S) > 0:
        q.add("&s=" & join(this.S, ","))

    if this.Size != "":
        q.add("&size=" & this.Size)

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
    c.Endpoint = "/_cat/transforms"

    if this.Transform != "" :
        c.Endpoint.add("/" & this.Transform)

    return c.estransport()