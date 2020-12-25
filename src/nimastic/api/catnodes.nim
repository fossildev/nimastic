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

const ValidColumn: seq[string] = @[
                "ip", "i",
                "heap.percent", "hp", "heapPercent",
                "ram.percent", "rp", "ramPercent",
                "file_desc.percent", "fdp", "fileDescriptorPercent",
                "node.role", "r", "role", "nodeRole",
                "master", "m",
                "name", "n",
                "id", "nodeId",
                "pid", "p",
                "port", "po",
                "http_address", "http",
                "version", "v",
                "build", "b",
                "jdk", "j",
                "disk.total", "dt", "diskTotal",
                "disk.used", "du", "diskUsed",
                "disk.avail", "d", "disk", "diskAvail",
                "disk.used_percent", "dup", "diskUsedPercent",
                "heap.current", "hc", "heapCurrent",
                "ram.current","rc", "ramCurrent",
                "ram.max", "rm", "ramMax",
                "file_desc.current", "fdc", "fileDescriptorCurrent",
                "file_desc.max", "fdm", "fileDescriptorMax",
                "cpu",
                "load_1m", "l",
                "load_5m", "l",
                "load_15m", "l",
                "uptime", "u",
                "completion.size", "cs", "completionSize",
                "fielddata.memory_size", "fm", "fielddataMemory",
                "fielddata.evictions", "fe", "fielddataEvictions",
                "query_cache.memory_size", "qcm", "queryCacheMemory",
                "query_cache.evictions", "qce", "queryCacheEvictions",
                "query_cache.hit_count", "qchc", "queryCacheHitCount",
                "query_cache.miss_count", "qcmc", "queryCacheMissCount",
                "request_cache.memory_size", "rcm", "requestCacheMemory",
                "request_cache.evictions", "rce", "requestCacheEvictions",
                "request_cache.hit_count", "rchc", "requestCacheHitCount",
                "request_cache.miss_count", "rcmc", "requestCacheMissCount",
                "flush.total", "ft", "flushTotal",
                "flush.total_time", "ftt", "flushTotalTime",
                "get.current", "gc", "getCurrent",
                "get.time", "gti", "getTime",
                "get.total", "gto", "getTotal",
                "get.exists_time", "geti", "getExistsTime",
                "get.exists_total", "geto", "getExistsTotal",
                "get.missing_time", "gmti", "getMissingTime",
                "get.missing_total", "gmto", "getMissingTotal",
                "indexing.delete_current", "idc", "indexingDeleteCurrent",
                "indexing.delete_time", "idti", "indexingDeleteTime",
                "indexing.delete_total", "idto", "indexingDeleteTotal",
                "indexing.index_current", "iic", "indexingIndexCurrent",
                "indexing.index_time", "iiti", "indexingIndexTime",
                "indexing.index_total", "iito", "indexingIndexTotal",
                "indexing.index_failed", "iif", "indexingIndexFailed",
                "merges.current", "mc", "mergesCurrent",
                "merges.current_docs", "mcd", "mergesCurrentDocs",
                "merges.current_size", "mcs", "mergesCurrentSize",
                "merges.total", "mt", "mergesTotal",
                "merges.total_docs", "mtd", "mergesTotalDocs",
                "merges.total_size", "mts", "mergesTotalSize",
                "merges.total_time", "mtt", "mergesTotalTime",
                "refresh.total", "rto", "refreshTotal",
                "refresh.time", "rti", "refreshTime",
                "script.compilations", "scrcc", "scriptCompilations",
                "script.cache_evictions", "scrce", "scriptCacheEvictions",
                "search.fetch_current", "sfc", "searchFetchCurrent",
                "search.fetch_time", "sfti", "searchFetchTime",
                "search.fetch_total", "sfto", "searchFetchTotal",
                "search.open_contexts", "so", "searchOpenContexts",
                "search.query_current", "sqc", "searchQueryCurrent",
                "search.query_time", "sqti", "searchQueryTime",
                "search.query_total", "sqto", "searchQueryTotal",
                "search.scroll_current", "scc", "searchScrollCurrent",
                "search.scroll_time", "scti", "searchScrollTime",
                "search.scroll_total", "scto", "searchScrollTotal",
                "segments.count", "sc", "segmentsCount",
                "segments.memory", "sm", "segmentsMemory",
                "segments.index_writer_memory", "siwm", "segmentsIndexWriterMemory",
                "segments.version_map_memory", "svmm", "segmentsVersionMapMemory",
                "segments.fixed_bitset_memory", "sfbm", "fixedBitsetMemory",
                "suggest.current", "suc", "suggestCurrent",
                "suggest.time", "suti", "suggestTime",
                "suggest.total", "suto", "suggestTotal"
                ]

# check value in column valid or not
proc checkValidColumn(h: seq[string]): bool =
    
    var valid: bool

    block checkH:
        for i, val in h.pairs:
            
            var match: bool = false

            block checkColumn:
                for j, k in ValidColumn.pairs:
                    if val == k :
                        match = true
                        break checkColumn

            if match :
                valid = true
            else :
                echo "column " & val & " not valid"
                valid = false
                break checkH

    return valid

method Do*(this: catNodes, c: var elClient): Response {.base.} =

    var q = ""

    # format 
    if this.Format == "text":
        q.add("format=text")
    elif this.Format == "json" :
        q.add("format=json")
    elif this.Format == "smile":
        q.add("format=smile")
    elif this.Format == "yaml":
        q.add("format=yaml")
    elif this.Format == "cbor":
        q.add("format=cbor")

    #bytes
    if this.Bytes != "":
        case this.Bytes:
        of "b": q.add("&bytes=b")
        of "kb": q.add("&bytes=kb")
        of "mb": q.add("&bytes=mb")
        of "gb": q.add("&bytes=gb")
        of "tb": q.add("&bytes=tb")
        of "pb": q.add("&bytes=pb")
        else:
            echo this.Bytes & " not found in bytes" 

    if this.FullId:
        q.add("&full_id")

    if len(this.H) > 0:
        let valid = checkValidColumn(this.H)
        if valid:
            q.add("&h=" & join(this.H,","))
    
    #time
    if this.Time != "" :
        case this.Time:
        of "d": q.add("&time=d")
        of "h": q.add("&time=h")
        of "m": q.add("&time=m")
        of "s": q.add("&time=s")
        of "ms": q.add("&time=ms")
        of "micros": q.add("&time=micros")
        of "nanos": q.add("&time=nanos")
        else: 
            echo "not found time " & this.Time

    if this.Help :
        q.add("&help")

    if this.Local :
        q.add("&local")

    if len(this.S) > 0:
        q.add("&s=" & join(this.S,","))

    if this.V :
        q.add("&v")

    c.Query = q
    c.Method = HttpGet
    c.Endpoint = "/_cat/nodes"

    return c.estransport()