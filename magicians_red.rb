require 'json'
require 'pry'

class MagiciansRed
  attr_reader :router

  def initialize
    @router = Router.new
  end


  #==========================

  # MagiciansRedがリクエストを裁くためのコントローラー
  # config.ruから呼び出す
  # フレームワーク利用者は使わない
  class Controller
    attr_reader :env

    def initialize(app)
      @app = app
    end
  
    def call(env)
      route = @app.router.route_for(env)
      
      if route
        response = route.execute(env)
        return response.rack_response
      else
        return [404, {}, []]
      end
    end
  end


  #==========================


  # 継承用コントローラー
  # フレームワーク利用者はこちらを継承する
  class BaseController 
    attr_reader :env
  
    def initialize(env)
      @env = env
    end
  end


  #==========================
  
  class Router
    def initialize
      @routes = Hash.new { |hash, key| hash[key] = [] }
    end

    attr_reader :routes

    def config(&block)
      instance_eval &block
    end

    def route_for(env)
      path   = env["PATH_INFO"]
      method = env["REQUEST_METHOD"].downcase.to_sym
      target_route = routes[method].detect do |route|
        path == "/" + route.path
      end
      return target_route
    end

    private
      def get(path, to:)
        @routes[:get] << Route.new(path, to.split("#")[0], to.split("#")[1])
      end

      def post(path, to:)
        @routes[:post] << Route.new(path, to.split("#")[0], to.split("#")[1])
      end

  end


  #==========================

  # routes.rb(現状はconfig.ruにベタ書き)のparse
  # 対応するControllerの#executeを呼び出す
  class Route
    attr_reader :path, :controller, :action

    def initialize(path, controller, action)
      @path = path
      @controller = controller
      @action = action
      require_controller_file
    end


    def execute(env)
      controller_klass.new(env).send(action.to_sym)
    end

    private
      def controller_name
        @controller + "_controller"
      end

      def controller_klass
        Module.const_get(controller_name.to_camel)
      end

      # TODO: gem化したときにディレクトリ設定がずれる
      def require_controller_file
        require File.join(File.dirname(__FILE__), "controllers", controller_filename)
      end

      def controller_filename
        controller_name.downcase + ".rb"
      end
  end


  #==========================


  # rack用のResponseに変換
  class Response
    attr_accessor :status_code, :headers, :body

    def initialize
      @headers = {}      
    end

    def rack_response
      [status_code, headers, Array(body)]
    end
  end


  #==========================


  # rackからくるリクエストをparse
  class Request
  end
end


# monkey-patch
class String
  def to_camel()
    self.split("_").map{|w| w[0] = w[0].upcase; w}.join
  end
end
