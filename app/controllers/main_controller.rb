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
    user = User.get(@user_id)
    @name = user.name
  end
  
  def task
    clusters = ["D30003", "D30005", "D30010", "D30012", "D30016", "D30020", "D30025", "D30028", "D30034", "D30040","D30042", "D30044", "D30048", "D30050", "D30051", "D30056", "D31001", "D31002", "D31009", "D31010"]                 
    user_id = params[:user_id]
    @cluster = nil
    for i in 0..clusters.size-1 
      @cluster = clusters[i]
      count_anno_by_user = Annotation.by_cluster_num_and_user_id.key([@cluster, user_id]).count
      count_anno_by_all = Annotation.by_cluster_num.key(@cluster).count
      if count_anno_by_user == 0 && count_anno_by_all <= 1
        break
      end  
    end    
    @user = User.get(user_id)
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
end
