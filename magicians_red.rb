class MagiciansRed
  private
    def erb(filename, locals = {})
      b = binding
      content = File.read("views/#{filename}.erb")
      locals.each {|key, value|
        eval "@#{key}=#{value}"
      }
      ERB.new(content).result(b)
    end

    def response(status, headers, body = '')
      body = yield if block_given?
      [status, headers, [body]]
    end
end
