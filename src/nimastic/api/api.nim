import catmaster, cataliases, catallocation, catanomalydetectors, catcount, 
        catdataframeanalytics, catdatafeeds, catfielddata, cathealth, catindices,
        catnodeattrs, catnodes, catpendingtasks, catplugins, catrecovery, catrepositories,
        catshards, catsegments, catsnapshots, cattasks, cattemplates, catthreadpool,
        cattrainedmodels, cattransforms, clusterallocationexplain, clustergetsettings,
        clusterhealth

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
        CatIndices*: catIndices
        CatNodeattrs*: catNodeattrs
        CatNodes*: catNodes
        CatPendingTasks*: catPendingTasks
        CatPlugins*: catPlugins
        CatRecovery*: catRecovery
        CatRepositories*: catRepositories
        CatShards*: catShards
        CatSegments*: catSegments
        CatSnapshots*: catSnapshots
        CatTasks*: catTasks
        CatTemplates*: catTemplates
        CatThreadPool*: catThreadPool
        CatTrainedModels*: catTrainedModels
        CatTransforms*: catTransforms
        ClusterAllocationExplain*: clusterAllocationExplain
        ClusterGetSettings*: clusterGetSettings
        ClusterHealth*: clusterHealth