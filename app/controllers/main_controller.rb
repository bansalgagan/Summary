class MainController < ApplicationController
  layout 'basic'
  def index
    if params[:wrong] == "true"
      flash[:alert] = 'Wrong access code'
    end
  end
  
  def save_user
    @user_name = params[:name].to_s
    puts @user_name
    code = params[:code]   
    if code!="wow"
      redirect_to :controller=>"main", :action=>"index", :wrong=>"true"
    else
      user = User.by_name.key(@user_name).first
      if user.nil?
        user = User.new(:name=>@user_name)
        user.save
      end
      redirect_to :action=>"inst", :user_id=>user.id
    end
  end
  
  def inst
    @user_id = params[:user_id]
    # user = User.get(@user_id)
    # @name = user.name
  end
  
  def task
    # clusters = ["D30005"]
    # user_id = params[:user_id]
    # @cluster = nil
    # for i in 0..clusters.size-1
    #   @cluster = clusters[i]
    #   count_anno_by_user = Annotation.by_cluster_num_and_user_id.key([@cluster, user_id]).count
    #   count_anno_by_all = Annotation.by_cluster_num.key(@cluster).count
    #   if count_anno_by_user == 0 && count_anno_by_all <= 1
    #     break
    #   end
    # end  
    @cluster = "D30005"
    # @user = User.get(user_id)
    @summaries = MSummary.by_cluster_num.key(@cluster).all
  end
  
  def save_response
    user = User.get(params[:user_id])
    summary_id = params[:response]
    summary = MSummary.get(summary_id)
    desc = params[:description]
    anno = Annotation.new(:user => user, :cluster_num => summary.cluster_num, :best_algo => summary.clustering_algorithm, :reason=>desc)
    anno.save
    redirect_to :action => "task", :user_id=>user.id
  end
  
  def passage
    @algo = params[:algoName]
    @cluster = params[:clusterName]
    puts @algo
    puts @cluster
    @summary = MSummary.by_cluster_num_and_clustering_algorithm.key([@cluster, @algo]).first
  end
end
