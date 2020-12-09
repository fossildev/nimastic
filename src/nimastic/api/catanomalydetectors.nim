import strutils, httpclient
import ../transport

type
    catAnomalyDitectors* = object
        JobId*: string
        AllowNoMatch*: bool
        Bytes*: string
        Format*: string
        H* : seq[string]
        Help*: bool
        S*: seq[string]
        Time*: string
        V*: bool



const ValidCollumn: seq[string] = @["assignment_explanation","ae",
                        "buckets.count","bc","bucketsCount",
                        "buckets.time.exp_avg","btea","bucketsTimeExpAvg",
                        "buckets.time.exp_avg_hour","bteah","bucketsTimeExpAvgHour",
                        "buckets.time.max","btmax","bucketsTimeMax",
                        "buckets.time.min","btmin","bucketsTimeMin",
                        "buckets.time.total","btt","bucketsTimeTotal",
                        "data.buckets","db", "dataBuckets",
                        "data.earliest_record", "der", "dataEarliestRecord",
                        "data.empty_buckets", "deb", "dataEmptyBuckets",
                        "data.input_bytes", "dib", "dataInputBytes",
                        "data.input_fields", "dif", "dataInputFields",
                        "data.input_records", "dir", "dataInputRecords",
                        "data.invalid_dates", "did", "dataInvalidDates",
                        "data.last", "dl", "dataLast",
                        "data.last_empty_bucket", "dleb", "dataLastEmptyBucket",
                        "data.last_sparse_bucket", "dlsb", "dataLastSparseBucket",
                        "data.latest_record", "dlr", "dataLatestRecord",
                        "data.missing_fields", "dmf", "dataMissingFields",
                        "data.out_of_order_timestamps", "doot", "dataOutOfOrderTimestamps",
                        "data.processed_fields", "dpf", "dataProcessedFields",
                        "data.processed_records", "dpr", "dataProcessedRecords",
                        "data.sparse_buckets", "dsb", "dataSparseBuckets",
                        "forecasts.memory.avg", "fmavg", "forecastsMemoryAvg",
                        "forecasts.memory.max", "fmmax", "forecastsMemoryMax",
                        "forecasts.memory.min", "fmmin", "forecastsMemoryMin",
                        "forecasts.memory.total", "fmt", "forecastsMemoryTotal",
                        "forecasts.records.avg", "fravg", "forecastsRecordsAvg",
                        "forecasts.records.max", "frmax", "forecastsRecordsMax",
                        "forecasts.records.min", "frmin", "forecastsRecordsMin",
                        "forecasts.records.total", "frt", "forecastsRecordsTotal",
                        "forecasts.time.avg", "ftavg", "forecastsTimeAvg",
                        "forecasts.time.max", "ftmax", "forecastsTimeMax",
                        "forecasts.time.min", "ftmin", "forecastsTimeMin",
                        "forecasts.time.total", "ftt", "forecastsTimeTotal",
                        "forecasts.total", "ft", "forecastsTotal",
                        "id",
                        "model.bucket_allocation_failures", "mbaf", "modelBucketAllocationFailures",
                        "model.by_fields", "mbf", "modelByFields",
                        "model.bytes", "mb", "modelBytes",
                        "model.bytes_exceeded", "mbe", "modelBytesExceeded",
                        "model.categorization_status", "mcs", "modelCategorizationStatus",
                        "model.categorized_doc_count", "mcdc", "modelCategorizedDocCount",
                        "model.dead_category_count", "mdcc", "modelDeadCategoryCount",
                        "model.failed_category_count", "mdcc", "modelFailedCategoryCount",
                        "model.frequent_category_count", "mfcc", "modelFrequentCategoryCount",
                        "model.log_time", "mlt", "modelLogTime",
                        "model.memory_limit", "mml", "modelMemoryLimit",
                        "model.memory_status", "mms", "modelMemoryStatus",
                        "model.over_fields", "mof", "modelOverFields",
                        "model.partition_fields", "mpf", "modelPartitionFields",
                        "model.rare_category_count", "mrcc", "modelRareCategoryCount",
                        "model.timestamp", "mt", "modelTimestamp",
                        "model.total_category_count", "mtcc", "modelTotalCategoryCount",
                        "node.address", "na", "nodeAddress",
                        "node.ephemeral_id", "ne", "nodeEphemeralId",
                        "node.id", "ni", "nodeId",
                        "node.name", "nn", "nodeName",
                        "opened_time", "ot",
                        "state", "s"]


# check value in column valid or not
proc checkValidColumn(h: seq[string]): bool =
    
    var valid: bool

    block checkH:
        for i, val in h.pairs:
            
            var match: bool = false

            block checkColumn:
                for j, k in ValidCollumn.pairs:
                    if val == k :
                        match = true
                        break checkColumn

            if match :
                valid = true
            else :
                valid = false
                break checkH

    return valid             

method Do*(this: catAnomalyDitectors, c: var elClient ): Response = 

    var q = ""

    if this.Format != "":
        case this.Format:
        of "text": q.add("format=text")
        of "json": q.add("format=json")
        of "smile":  q.add("format=smile")
        of "yaml":  q.add("format=yaml")
        of "cbor": q.add("format=cbor")
        else:
            echo "not found format " & this.Format

    if this.AllowNoMatch :
        q.add("&allow_no_match")

    if this.Bytes != "":
        case this.Bytes:
        of "b": q.add("&bytes=b")
        of "kb": q.add("&bytes=kb")
        of "mb": q.add("&bytes=mb")
        of "gb": q.add("&bytes=gb")
        of "tb": q.add("&bytes=tb")
        of "pb": q.add("&bytes=pb")
        else: 
            echo this.Bytes & " " & " not found or bytes not falid"
            #add exeption in logger

    if len(this.H) > 0 :

        let valid = checkValidColumn(this.H)
        if valid :
            let hStr = join(this.H, ",")
            q.add("&h=" & hStr)

    if this.Help :
        q.add("&help")

    if len(this.S) > 0 : 
        let sStr = join(this.S, ",")
        q.add("&s=" & sStr)

    if this.V :
        q.add("&v")

    if this.Time != "":
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

    # add query to elasticsearch.Query
    c.Query = q
    # add method to elasticsearch.Method
    c.Method = HttpGet
    c.Endpoint = "/_cat/ml/anomaly_detectors"

    if this.JobId != "" :
        c.Endpoint.add("/" & this.JobId)

    return c.estransport()