class MSummary < CouchRest::Model::Base
  property :cluster_num, String
  property :paragraphs, [String]
  property :clustering_algorithm, String
  
  design do
    view :by_cluster_num
  end
end
