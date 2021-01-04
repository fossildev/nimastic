import strutils, httpclient
import ../transport

type
    clusterStateApi* = object
        #path
        Metrics*: seq[string]
        Target*: string
        #query
        AllowNoIndices* : bool
        ExpandWildcards*: string
        FlatSettings*: bool
        IgnoreUnavailable*: bool
        Local*: bool
        MasterTimeout*: string
        WaitForMetadataVersion*: int
        WaitForTimeout*: string
       

        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]

method Do*(c: var elClient, this: clusterStateApi): Response {.base.} =

    var q = ""

    if this.AllowNoIndices :
        q.add("allow_no_indices")

    if this.ExpandWildcards != "" :
        q.add("&expand_wildcards=" & this.ExpandWildcards)

    if this.FlatSettings :
        q.add("&flat_settings")

    if this.IgnoreUnavailable :
        q.add("&ignore_unavailable")

    if this.Local :
        q.add("&local")

    if this.MasterTimeout != "" :
        q.add("&master_timeout=" & this.MasterTimeout)   

    q.add("&wait_for_metadata_version=" & intToStr(this.WaitForMetadataVersion))

    if this.WaitForTimeout != "" :
        q.add("&wait_for_timeout=" & this.WaitForTimeout)


    c.Query = q
    c.Method = HttpGet
    c.Endpoint = "/_cluster/state/"


    if len(this.Metrics) > 0 :
        c.Endpoint.add("/" & join(this.Metrics, ","))

    if this.Target != "" :
        c.Endpoint.add("/" & this.Target)

    return c.estransport()