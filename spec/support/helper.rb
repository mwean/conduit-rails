module Helper
  def request_attributes
    {
      foo: "value for foo",
      bar: "value for bar",
      baz: "value for baz"
    }
  end

  def read_support_file(name)
    IO.read(File.join(File.dirname(__FILE__), name))
  end
end
