class Hash
  def diff_sq(other)
    dup.delete_if { |k, v| other[k] == v }.merge!(other.dup.delete_if { |k, v| has_key?(k) })
  end
end