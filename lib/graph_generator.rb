class GraphGenerator
  
  def call(pools, user_id, filtered_ids)
    random = SecureRandom.uuid

    File.open("/tmp/#{random}.dot", "w") { |f| f.write(Pool.to_dot_digraph(pools, user_id, filtered_ids)) }
    GraphViz.parse("/tmp/#{random}.dot", :path => "/" ).output(:png => "/tmp/#{random}.png")
    
    File.open(Rails.root.join("/tmp/#{random}.png"), 'r')
  end
end
