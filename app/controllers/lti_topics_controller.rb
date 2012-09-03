class LtiTopicsController < ApplicationController
  def index
    if params[:topic_id] == nil
      # the topic id is missing - render an error
      render('error', :message => 'Sorry, the topic ID is missing.')
        
    else
      # render the lti_topic 
      @lti_topic = LtiTopic.where(:topic_id => params[:topic_id]).first
      if @lti_topic == nil
        if params[:permissions] == 'admin'
          # show the setup screen
          @lti_topic = LtiTopic.new
          render('new')
        else
          # show a message
          render('index_unconfigured')
        end
      else
        # make sure we have a user_id so we can create the link
        render('show')
      end
    end
  end

  def error
  end
  

  def index_unconfigured
  end

  # GET /lti_topics
  # GET /lti_topics.json
  def oldindex
    @lti_topics = LtiTopic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lti_topics }
    end
  end

  # GET /lti_topics/1
  # GET /lti_topics/1.json
  def show
    @lti_topic = LtiTopic.find(params[:id])
     
    @response = Faraday.get(@lti_topic.url)
    @xmlbody = XmlSimple.xml_in(@response.body)
    @launch_url = @xmlbody['launch_url'].first
    
    @tc = IMS::LTI::ToolConfig.new(:title => @lti_topic.name, :launch_url => @launch_url)
    @consumer = IMS::LTI::ToolConsumer.new(@lti_topic.key, @lti_topic.secret)
    @consumer.set_config(@tc)
    @consumer.resource_link_id = @lti_topic.topic_id
    @consumer.user_id = "12345"
    @consumer.lis_person_name_full = "colin x murtaugh"
    @consumer.lis_person_contact_email_primary = "cmurtaugh@g.harvard.edu"
    
    
    if params[:permissions] == 'admin' 
      @consumer.roles = "instructor"
    else
      @consumer.roles = "learner"
    end
    @consumer.context_id = "k123"
    @consumer.context_title = "Some sample course"
    @consumer.context_label = "SAMP101"
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lti_topic }
    end
  end

  # GET /lti_topics/new
  # GET /lti_topics/new.json
  def new
    @lti_topic = LtiTopic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lti_topic }
    end
  end

  # GET /lti_topics/1/edit
  def edit
    @lti_topic = LtiTopic.find(params[:id])
  end

  # POST /lti_topics
  # POST /lti_topics.json
  def create
    @lti_topic = LtiTopic.new(params[:lti_topic])

    respond_to do |format|
      if @lti_topic.save
        format.html { redirect_to @lti_topic, notice: 'Lti topic was successfully created.' }
        format.json { render json: @lti_topic, status: :created, location: @lti_topic }
      else
        format.html { render action: "new" }
        format.json { render json: @lti_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lti_topics/1
  # PUT /lti_topics/1.json
  def update
    @lti_topic = LtiTopic.find(params[:id])

    respond_to do |format|
      if @lti_topic.update_attributes(params[:lti_topic])
        format.html { redirect_to @lti_topic, notice: 'Lti topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lti_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lti_topics/1
  # DELETE /lti_topics/1.json
  def destroy
    @lti_topic = LtiTopic.find(params[:id])
    @lti_topic.destroy

    respond_to do |format|
      format.html { redirect_to lti_topics_url }
      format.json { head :no_content }
    end
  end
end
