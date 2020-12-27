import strutils, httpclient
import ../transport

type
    clusterHealth* = object
        Target*: seq[string]
        #query
        Level*: string
        Local*: bool
        MasterTimeout*: string
        Timeout*: string
        WaitForActiveShards*: string
        WaitForEvents*: string
        WaitForNoInitializingShards*: bool
        WaitForNoRelocatingShards*: bool
        WaitForNodes*: string
        WaitForStatus*: string

        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]


method Do*(c: var elClient, this: clusterHealth): Response {.base.} =

    var q = ""

    if this.Level != "" :
        q.add("level=" & this.Level)

    if this.Local :
        q.add("&local")

    if this.MasterTimeout != "" :
        q.add("&master_timeout=" & this.MasterTimeout)

    if this.Timeout != "" :
        q.add("&timeout=" & this.Timeout)

    if this.WaitForActiveShards != "" :
        q.add("&wait_for_active_shards=" & this.WaitForActiveShards)

    if this.WaitForEvents != "" :
        q.add("&wait_for_events=" & this.WaitForEvents)

    if this.WaitForNoInitializingShards :
        q.add("&wait_for_no_initializing_shards")

    if this.WaitForNoRelocatingShards :
        q.add("&wait_for_no_relocating_shards")

    if this.WaitForNodes != "" :
        q.add("&wait_for_nodes=" & this.WaitForNodes)

    if this.WaitForStatus != "" :
        q.add("&wait_for_status=" & this.WaitForStatus)

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
    c.Endpoint = "/_cluster/health/"

    if len(this.Target) > 0 :
        c.Endpoint.add("/" & join(this.Target, ","))

    return c.estransport()
