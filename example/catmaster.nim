import nimastic, httpclient

var client = elasticBasicClient()

let req = elasticsearch.CatMaster(Format:"json")

let res = req.Do(client)

echo res.body