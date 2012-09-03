# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RailsLtiTool::Application.initialize!

# requred by ims-lti:
OAUTH_10_SUPPORT = true