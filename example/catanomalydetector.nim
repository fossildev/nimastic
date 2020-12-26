import nimastic, httpclient

var client = elasticBasicClient()

let req = elasticsearch.CatAnomalyDitectors(
        Format: "json",
        Bytes: "gb",
        H: @["buckets.time.exp_avg_hour","buckets.time.max","data.input_fields"],
        Time: "s" # s to second
    )

let res = client.Do(req)

echo res.body