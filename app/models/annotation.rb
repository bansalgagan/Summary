class Annotation < CouchRest::Model::Base
  belongs_to :user
  
  property :cluster_num, String
  property :best_algo, String
  property :reason, String
  
  design do
    view :by_user_id
    view :by_cluster_num
  end
end
