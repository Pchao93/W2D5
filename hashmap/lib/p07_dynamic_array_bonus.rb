class StaticArray
  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  include Enumerable
  attr_reader :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    if i < 0
      (i = count + i)
      if i < 0
        return nil
      else
        return @store[i]
      end
    end


    begin
      @store[i]
    rescue RuntimeError
      nil
    end
  end

  def []=(i, val)
    begin
      @store[i] = val
    rescue RuntimeError
      resize!(i.abs * 2)
      @store[i] = val
    end
  end

  def capacity
    @store.length
  end

  def include?(val)
    i = 0
    while i < count
      return true if @store[i] == val
      i += 1
    end
    false
  end

  def push(val)
    resize! if count == capacity
    @store[count] = val
    @count += 1
    self
  end

  def unshift(val)
    old_store = @store
    old_count = count
    @store = StaticArray.new(old_store.length * 2)
    @count = 0

    self.push(val)
    i = 0

    while i < old_count
      self.push(old_store[i])
      i += 1
    end
    self
  end

  def pop
    if @count == 0
      return nil
    else
      @count -= 1
      result = @store[count]
      @store[count] = nil
    end
    result
  end

  def shift
    i = 0
    j = 1
    result = @store[0]
    while j < count


      @store[i] = @store[j]
      i += 1
      j += 1
    end

    if count != 0
      @count -= 1
      @store[count] = nil
      result
    else
      nil
    end
  end

  def first
    @store[0]
  end

  def last
    if count == 0
      nil
    else
      @store[count - 1]
    end
  end

  def each(&prc)

    i = 0
    while i < count
      prc.call(self[i])
      i += 1
    end
    self

  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    self.each_with_index do |el, idx|
      return false if el != other[idx]
    end
    true

    # ...
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!(n = capacity * 2)
    old_store = @store
    @store = StaticArray.new(n)
    i = 0
    while i < old_store.length
      @store[i] = old_store[i]
      i += 1
    end
  end
end
