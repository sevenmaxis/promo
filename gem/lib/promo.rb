require "promo/version"
require 'rest_client'
require 'json'

module Promo

  class Optin

    @@attrs = [
      :status, :message, :email, :mobile, :first_name,
      :last_name, :permission_type, :channel, :company_name 
    ]

    attr_accessor *@@attrs

    class << self

      def setup(url)
        @@url = (url[-1] == "/" ? url.chop! : url) + '/markets'
      end

      def get(email)
        resp = process_response do 
          # '/1' is a fake id to follow REST convention
          response = RestClient.get(@@url+'/1', params: {email: email}) do |response, request, result, &block|
            if 200 == response.code
              response
            elsif [404, 422].include? response.code
              response
            else
              response.return!(request, result, &block)
            end
          end
        end
        create_optin *resp
      end

      def create(email, mobile, first_name, last_name, permission_type, channel, company_name)
        params = {
          email: email, mobile: mobile, first_name: first_name, last_name: last_name, 
          permission_type: permission_type, channel: channel, company_name: company_name 
        }
        resp = process_response do 
          response = RestClient.post(@@url, :params => params) do |response, request, result, &block|
            if 200 == response.code
              response
            elsif [404, 422].include? response.code
              response
            else
              response.return!(request, result, &block)
            end
          end
        end
        create_optin *resp
      end

      def update(email, params)
        process_response do
          options = {email: email, params: params}
          # '/1' is a fake id to follow REST convention
          response = RestClient.put(@@url+'/1', options) do |response, request, result, &block|
            if 200 == response.code
              response
            elsif [404, 422].include? response.code
              response
            else
              response.return!(request, result, &block)
            end
          end
        end
      end

      def process_response      
        resp = yield
        if [200, 201].include? resp.code
          result = ['success', resp.body]
        elsif [404, 422].include? resp.code
          result = ['error', resp.body]
        else
          result = ['error', "unrecognized error,\nhttp code: #{resp.code},\nhttp body: #{resp.body}"]
        end
      rescue RestClient::RequestFailed, RestClient::ResourceNotFound, RestClient::Unauthorized,  RestClient::NotModified, StandardError => e
        result = ['error', e.message]
      end

      def create_optin(status, body)
        new.tap do |optin|
          if (optin.status = status) == 'success'
            optin.message = ""
            JSON.parse(body).each do |attr, value|
              optin.send("#{attr}=", value) if @@attrs.include? attr.to_sym
            end
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

    private_class_method :new, :process_response, :create_optin
  end
end
