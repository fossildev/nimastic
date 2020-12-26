import nimastic, httpclient

var client = elasticBasicClient()

let req = elasticsearch.CatMaster(Format:"json")

let res = client.Do(req)

echo res.body