require_relative 'p02_hashing'
require_relative 'p04_linked_list'

class HashMap
  include Enumerable
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).each do |node|
      return true if node.key == key
    end
    false
  end

  def set(key, val)
    resize! if count == num_buckets
    if !include?(key)
      bucket(key).append(key, val)
      @count += 1
    else
      bucket(key).update(key, val)
    end
  end

  def get(key)
    bucket(key).each do |node|
      return node.val if node.key == key
    end
    nil
  end

  def delete(key)
    if include?(key)
      bucket(key).remove(key)
      @count -= 1
    end

  end

  def each(&prc)
    @store.each do |linkedlist|
      linkedlist.each do |node|
        prc.call(node.key, node.val)
      end
    end
  end


  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    old_store = @store
    @store = Array.new(num_buckets * 2) { LinkedList.new }
    @count = 0
    old_store.each do |linkedlist|
      linkedlist.each { |node| self.set(node.key, node.val) }
    end
  end

  def bucket(key)
    @store[key.hash % num_buckets]
    # optional but useful; return the bucket corresponding to `key`
  end
end
