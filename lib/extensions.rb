class Float
  def prettify
    to_i == self.round(2) ? to_i : self.round(2)
  end
  def prettify_to_s
    prettify.to_s
  end
end