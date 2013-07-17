require "promo/version"
require 'rest_client'
require 'json'

module Promo

  class Optin

    attrs = [
      :status, :message, :email, :mobile, :first_name,
      :last_name, :permission_type, :channel, :company_name 
    ]

    attr_accessor *attrs

    class << self

      def setup(url)
        @@url = (url[-1] == "/" ? url.chop! : url) + '/markets'
      end

      def get(email)
        # '/1' is a fake id to follow REST convention
        create_optin( *process_request { RestClient.get(@@url+'/1', params: {email: email}) })
      end

      def create(email, mobile, first_name, last_name, permission_type, channel, company_name)
        params = {
          email: email, mobile: mobile, first_name: first_name, last_name: last_name, 
          permission_type: permission_type, channel: channel, company_name: company_name 
        }
        resp = process_request do 
          RestClient.post(@@url, :params => params) do |response, request, result, &block|
            if 200 == response.code
              response
            elsif [404, 422].include? response.code
              [response.code, response]
            else
              response.return!(request, result, &block)
            end
          end
        end
        create_optin *resp
      end

      def update(email, params)
        # '/1' is a fake id to follow REST convention
        process_request do
          options = {params: {email: email, params: params}}
          RestClient.put(@@url+'/1', options) do |response, request, result, &block|
            if 200 == response.code
              response
            elsif [404, 422].include? response.code
              [response.code, response]
            else
              response.return!(request, result, &block)
            end
          end
        end
      end

      def process_request      
        resp = yield
        if [200, 201].include? resp.code
          ['success', resp.body]
        elsif [404, 422].include? resp.code
          ['error'. resp.body]
        else
          ['error', "unrecognized error,\nhttp code: #{resp.code},\nhttp body: #{resp.body}"]
        end
      rescue RestClient::RequestFailed, RestClient::ResourceNotFound, RestClient::Unauthorized,  RestClient::NotModified, StandardError => e
        ['error', e.message]
      end

      def create_optin(status, body)
        new.tap do |optin|
          if (optin.status = status) == 'success'
            optin.message = ""
            JSON.parse(body).each { |attr, value| optin.send("#{attr}=", value) }
          else
            optin.message = body
          end
        end
      end
    end

    def update(params)
      status, body = self.class.update(self.email, params)
      if (self.status = status) == 'success'
        self.message = ""
        params.each { |attr, value| self.send("#{attr}=", value) }
      else
        self.message = body
      end
      self
    end

    private_class_method :new, :process_request, :create_optin
  end
end
