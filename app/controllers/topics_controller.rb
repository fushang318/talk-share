class TopicsController < ApplicationController
  before_filter :pre_load

  def pre_load
    @talk_group = TalkGroup.find(params[:id]) if params[:id]

    file = Rails.root.join('config', 'share_tags.yaml')
    @tags = YAML::load_documents(File.open(file))
    @titles = @tags.map {|t| t.keys[0]}
    
  end

  def topic_params
    params.require(:talk_group).permit(:user_id, topics_attributes: [:title, :title_tag])
  end

  def index
    @talk_groups = TalkGroup.page params[:page]
  end

  def new
    @talk_group = TalkGroup.new
    @talk_group.topics.build
  end

  def create
    @talk_group = TalkGroup.new(topic_params)

    return redirect_to "/topics" if @talk_group.save

    @talk_group.topics = TalkGroup.new.topics
    @talk_group.topics.build

    return render 'new'
  end


  def show
  end

  def edit
    # @talk_group.topics = TalkGroup.new.topics
    @talk_group.topics.build
  end


  def update
    if @talk_group.update_attributes(topic_params)
      return redirect_to "/topics" if @talk_group.save
    end

    @talk_group.topics = TalkGroup.new.topics
    @talk_group.topics.build

    render 'edit'
  end


  def search
    @topic = Topic.find(params[:tid])
    @topic_by_tags = Topic.by_tag(@topic.title_tag)
  end


end