import strutils, httpclient
import ../transport

type
    clusterGetSettings* = object
        #query
        FlatSettings*: bool
        IncludeDefaults*: bool
        MasterTimeout*: string
        Timeout*: string

        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]

method Do*(c: var elClient, this: clusterGetSettings ): Response {.base.} =

    var q = ""

    if this.FlatSettings :
        q.add("flat_settings")

    if this.IncludeDefaults :
        q.add("&include_defaults")

    if this.MasterTimeout != "" :
        q.add("&master_timeout=" & this.MasterTimeout)

    if this.Timeout != "" :
        q.add("&timeout=" & this.Timeout)

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
    c.Endpoint = "/_cluster/settings"

    return c.estransport()