require 'grape-swagger'

class Root < Grape::API
  format :json

  before do
    header['Access-Control-Request-Method'] = '*'
  end

  
  mount API

  add_swagger_documentation mount_path: '/api/doc',
                            api_version: 'v1',
                            markdown: true,
                            hide_documentation_path: true,
                            resource_prefix: "/api/:version",
                            hide_format: true
end