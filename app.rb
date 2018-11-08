require_relative 'magicians_red'

require_relative 'advice'

class App < MagiciansRed
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      # ['200', {'Content-Type' => 'text/html'}, [erb(:index)] ]
      status = "200"
      headers = {"Content-Type" => "text/html"}
      response(status, headers) do
        erb :index
      end
    when '/advice'
      advices = Advice.new.advice_list

      status = "200"
      headers = {"Content-Type" => "text/html"}
      response(status, headers) do
        erb :advice, advices: advices, names: ["Hello", "World"]
      end
    else
      status = '404'
      headers = {"Content-Type" => "text/html"}
      response(status, headers) do
        erb :not_found
      end
    end
  end
end
