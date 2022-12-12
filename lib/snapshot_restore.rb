class SnapshotRestore

  def call(snapshot)
    reified_parent, reified_children_hash = snapshot.fetch_reified_items

    result = []
    result << reified_parent
    reified_children_hash['descendants'].each_with_index do |child, i|
      child.profile = reified_children_hash['descendants_profiles'][i]
      result << child
    end
    result
  end
end
