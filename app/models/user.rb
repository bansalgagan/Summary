class User < CouchRest::Model::Base
  property :name, String
  
  design do
    view :by_name 
  end
end
