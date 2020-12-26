import strutils, httpclient
import ../transport

type
    catDataFrameAnalytics* = object
        DataFrameAnalyticsId*: string
        #query
        Format*: string
        H*: seq[string]
        Help*: bool
        S*: seq[string]
        Time*: string
        V*: bool

        Pretty*: bool
        Human*: bool
        ErrorTrace*: bool
        FilterPath*: seq[string]

method Do*( c: var elClient, this: catDataFrameAnalytics ): Response {.base.} = 

    var q = ""

    # format 
    if this.Format != "" :
        q.add("&format=" & this.Format)

    if len(this.H) > 0 :
        let hStr = join(this.H, ",")
        q.add("&h=" & hStr)

    if this.Help :
        q.add("&help")

    if len(this.S) > 0 : 
        let sStr = join(this.S, ",")
        q.add("&s=" & sStr)

    if this.V :
        q.add("&v")

    if this.Time != "" :
        q.add("&time=" & this.Time)

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
    c.Endpoint = "/_cat/ml/data_frame/analytics"

    if this.DataFrameAnalyticsId != "" :
        c.Endpoint.add("/" & this.DataFrameAnalyticsId)

    return c.estransport()