import catmaster, cataliases, catallocation, catanomalydetectors, catcount, 
        catdataframeanalytics, catdatafeeds, catfielddata, cathealth
type
    elasticsearch* = object
        CatMaster* : catMaster
        CatAliases*: catAliases
        CatAllocation*: catAllocation
        CatAnomalyDitectors*: catAnomalyDitectors
        CatCount*: catCount
        CatDataFrameAnalytics*: catDataFrameAnalytics
        CatDatafeeds*: catDatafeeds
        CatFieldData*: catFieldData
        CatHealth*: catHealth
        
        