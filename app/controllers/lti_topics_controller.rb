class LtiTopicsController < ApplicationController
  
  # GET /lti_topics
  # GET /lti_topics.json
  def index
    if params[:topicId] == nil
      # the topic id is missing - render an error
      render('error', :message => 'Sorry, the topic ID is missing.')
        
    else
      # render the lti_topic 
      logger.debug("we seem to have a topic id")
      @lti_topic = LtiTopic.where(:topic_id => params[:topicId]).first
      if @lti_topic == nil
        if params[:permissions] =~ /14/
          # show the setup screen
          @lti_topic = LtiTopic.new
          @lti_topic.user_id = params[:userid]
          @lti_topic.topic_id = params[:topicId]
          render('new')
        else
          # show a message
          render('index_unconfigured')
        end
      else
        # make sure we have a user_id so we can create the link
        logger.debug("found topic with url " + @lti_topic.url) 
        
        @launch_url = @lti_topic.launch_url
        logger.debug("we have launch url : " + @launch_url)
        
        #@response = Faraday.get(@lti_topic.url)
        #logger.debug("response: " + @response.body)
        #@xmlbody = XmlSimple.xml_in(@response.body)
        #@launch_url = @xmlbody['launch_url'].first
    
        @tc = IMS::LTI::ToolConfig.new(:title => @lti_topic.name, :launch_url => @launch_url)
        @consumer = IMS::LTI::ToolConsumer.new(@lti_topic.key, @lti_topic.secret)
        @consumer.set_config(@tc)
        @consumer.resource_link_id = @lti_topic.topic_id
        @consumer.user_id = params[:userid]
        @consumer.lis_person_name_full = "colin x murtaugh"
        @consumer.lis_person_contact_email_primary = "cmurtaugh@g.harvard.edu"
    
    
        if params[:permissions] =~ /14/ 
          @consumer.roles = "instructor"
        else
          @consumer.roles = "learner"
        end
        @consumer.context_id = params[:urlRoot] + '/' + params[:keyword]
        @consumer.context_title = params[:keyword]
        @consumer.context_label = params[:keyword]
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
    #@lti_topic = LtiTopic.find(params[:id])
    @lti_topic = LtiTopic.where(:topic_id => params[:topicId]).first
    
    logger.debug("found topic with url " + @lti_topic.url) 
    logger.debug("has xml : " + @lti_topic.xml_snippet)
    #@response = Faraday.get(@lti_topic.url)
    #logger.debug("response: " + @response.body)
    #@xmlbody = XmlSimple.xml_in(@response.body)
    #@launch_url = @xmlbody['launch_url'].first

    @launch_url = @lti_topic.xml_snippet['launch_url'].first
    logger.debug("x have launch url : " + @launch_url)
    
    @tc = IMS::LTI::ToolConfig.new(:title => @lti_topic.name, :launch_url => @launch_url)
    @consumer = IMS::LTI::ToolConsumer.new(@lti_topic.key, @lti_topic.secret)
    @consumer.set_config(@tc)
    @consumer.resource_link_id = @lti_topic.topic_id
    @consumer.user_id = params[:userid]

    # need to grab the actual user attrs here...
    @consumer.lis_person_name_full = "colin x murtaugh"
    @consumer.lis_person_contact_email_primary = "cmurtaugh@g.harvard.edu"
    
    if params[:permissions] =~ /14/ 
      @consumer.roles = "instructor"
    else
      @consumer.roles = "learner"
    end
    @consumer.context_id = params[:urlRoot] + '/' + params[:keyword]
    @consumer.context_title = params[:keyword]
    @consumer.context_label = params[:keyword]
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lti_topic }
    end
  end

  # GET /lti_topics/new
  # GET /lti_topics/new.json
  def new
    @lti_topic = LtiTopic.new
    
    @lti_topic.topic_id = params[:topicId]
    @lti_topic.user_id = params[:userid]

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

    @response = Faraday.get(@lti_topic.url)
    logger.debug("response: " + @response.body)
    @lti_topic.xml_snippet = @response.body
    
    @xmlbody = XmlSimple.xml_in(@response.body)
    @lti_topic.launch_url = @xmlbody['launch_url'].first
    
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
