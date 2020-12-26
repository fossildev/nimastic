import strutils, httpclient, json
import ../transport

type
    clusterAllocationExplain* = object
        #query
        IncludeDiskInfo*: bool
        IncludeYesDecisions*: bool
        #body
        CurrentNode*: string
        Index*: string
        Primary*: bool
        Shard*: int

method Do*(this: clusterAllocationExplain, c: var elClient): Response {.base.} =

    var q = ""
    var body = %*{}

    #query
    if this.IncludeDiskInfo :
        q.add("include_disk_info")

    if this.IncludeYesDecisions:
        q.add("&include_yes_decisions")

    #body
    if this.CurrentNode != "":
        body["current_node"] = %* this.CurrentNode

    if this.Index != "" :
        body["index"] = %* this.Index

    if this.Primary :
        body["primary"] = %* true

    body["shard"] = %* this.Shard

    c.Query = q
    c.Body = $body
    c.Method = HttpGet
    c.Endpoint = "/_cluster/allocation/explain"

    return c.estransport()
    