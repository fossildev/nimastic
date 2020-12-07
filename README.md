# nimastic

Elasticsearch client for nim-lang


## install [develop]

``` bash
git clone https://github.com/fossildev/nimastic.git

cd nimastic

nimble develop
```

## example


check connection with elasticsearch

``` nim
import nimastic, httpclient

#create connection
var client = elasticBasicClient()

let res = client.check()

echo res.body
```

 response 

``` json
{
  "name" : "chan",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "WTHS1qV4RUS7RC61H1Y5Yw",
  "version" : {
    "number" : "7.10.0",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "51e9d6f22758d0374a0f3f5c6e8f3a7997850f96",
    "build_date" : "2020-11-09T21:30:33.964949Z",
    "build_snapshot" : false,
    "lucene_version" : "8.7.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```


example cat master

``` nim
import nimastic, httpclient

var client = elasticBasicClient()

var req = elasticsearch.CatMaster(Format:"json")

let resMaster = req.Do(client)

echo resMaster.body
```


response

``` json
[
    {
        "id": "D5TAWTIORlCWVCToEZvMKw",
        "host": "localhost",
        "ip": "127.0.0.1",
        "node": "chan"
    }
]
```