module Mailgun
  class Route

    def initialize(mailgun)
      @mailgun = mailgun
    end
    
    def list(limit=100, skip=0)
      response = Mailgun.submit :get, route_url, :limit => limit, :skip => skip
      if response
        return (response["items"] || [])
      end
    end

    def get(route_id)
      response = Mailgun.submit :get, route_url(route_id)
      response["route"] if response
    end

    def create(description, priority, expression, actions)
      params = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) } 
      params[:description] = description
      params[:priority] = priority
      params[:expression] = expression
      
      actions.each do |action|
        params[:action] = action
      end
      
      response = Mailgun.submit :post, route_url, params
      response["route"]["id"] if response
    end

    def update(route_id, params)
      params_to_update = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) } 

      params_to_update[:priority] = params[:priority] if params.has_key?(:priority)
      params_to_update[:description] = params[:description] if params.has_key?(:description)
      params_to_update[:expression] = params[:expression] if params.has_key?(:expression)

      if params.has_key?(:action)
        params[:action].each do |action|
          params_to_update[:action] = action
        end
      end
      Mailgun.submit :put, route_url(route_id), params_to_update
    end
    
    def destroy(route_id)
      response = Mailgun.submit :delete, route_url(route_id)
      response["id"] if response
    end
    
    private

    def route_url(route_id=nil)
      "#{@mailgun.base_url}/routes#{'/' + route_id if route_id}"
    end
  end
end
