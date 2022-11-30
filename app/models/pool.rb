class Pool < ApplicationRecord

  before_destroy :change_parent_pools

  belongs_to :profile
  belongs_to :pool_container

  has_closure_tree

  validates :type, presence: true

  def to_digraph_label
    "#{profile.first_name} #{profile.last_name}\n (#{profile.grade.name} / #{profile.speciality.name})"
  end

  def change_parent_pools
    pools_for_update = Pool.where(parent_id: profile.pool.id)
    pools_for_update.each {|pool| pool.update(parent_id: profile.pool.parent_id)}
  end

  def self.to_dot_digraph(tree_scope, highlight_id)
    id_to_instance = tree_scope.reduce({}) { |h, pool| h[pool.id] = pool; h }
    output = StringIO.new
    output << "digraph G {\n"
    tree_scope.each do |pool|
      if id_to_instance.key? pool._ct_parent_id
        output << "  \"#{pool._ct_parent_id}\" -> \"#{pool._ct_id}\" [label = #{pool.type}]\n"
      end

      if highlight_id == pool.profile.id  
        output << "  \"#{pool._ct_id}\" [label=\"#{pool.to_digraph_label}\" color=\"green\" fontcolor=\"green\"]\n"
      else
        output << "  \"#{pool._ct_id}\" [label=\"#{pool.to_digraph_label}\"]\n"
      end
    end
    output << "}\n"
    output.string
  end
end
