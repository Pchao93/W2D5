class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    hashes = self.map.with_index { |el, idx| (el * idx).hash }
    hashes.reduce(:+).hash
  end
end

class String
  def hash
    hashes = self.chars.map.with_index { |char, idx| (char.ord * idx).hash }
    hashes.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    hashes = []
    self.each do |key, val|
      hashes << (key.to_s.ord.hash * val.hash)
    end
    hashes.reduce(:+).hash
  end
end
