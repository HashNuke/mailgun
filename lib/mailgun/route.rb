module Mailgun
  class Route

    def initialize(mailgun)
      @mailgun = mailgun
    end
    
    def list(options={})
      Mailgun.submit(:get, route_url, options)["items"] || []
    end

    def find(route_id)
      Mailgun.submit(:get, route_url(route_id))["route"]
    end

    def create(description, priority, filter, actions)
      data = ::Multimap.new

      data['priority']    = priority
      data['description'] = description
      data['expression']  = build_filter(filter)

      actions = build_actions(actions)

      actions.each do |action|
        data['action'] = action
      end

      # TODO: Raise an error or return false if unable to create route
      Mailgun.submit(:post, route_url, data)["route"]["id"]
    end

    def update(route_id, params)
      data = ::Multimap.new

      ['priority', 'description'].each do |key|
        data[key] = params[key] if params.has_key?(key)
      end

      data['expression'] = build_filter(params['expression']) if params.has_key?('expression')

      if params.has_key?('actions')
        actions = build_actions(params['actions'])

        actions.each do |action|
          data['action'] = action
        end
      end

      Mailgun.submit(:put, route_url(route_id), data)
    end
    
    def destroy(route_id)
      Mailgun.submit(:delete, route_url(route_id))["id"]
    end
    
    private

    def route_url(route_id=nil)
      "#{@mailgun.base_url}/routes#{'/' + route_id if route_id}"
    end

    def build_actions(actions)
      _actions = []

      actions.each do |action|
        case action.first.to_sym
        when :forward
          _actions << "forward(\"#{action.last}\")"
        when :stop
          _actions << "stop()"
        else
          raise Mailgun::Error.new("Unsupported action requested, see http://documentation.mailgun.net/user_manual.html#routes for a list of allowed actions")
        end
      end

      _actions
    end


    def build_filter(filter)
      case filter.first.to_sym
      when :match_recipient
        return "match_recipient('#{filter.last}')"
      when :match_header
        return "match_header('#{filter[1]}', '#{filter.last}')"
      when :catch_all
        return "catch_all()"
      else
        raise Mailgun::Error.new("Unsupported filter requested, see http://documentation.mailgun.net/user_manual.html#routes for a list of allowed filters")
      end
    end
  end
end
