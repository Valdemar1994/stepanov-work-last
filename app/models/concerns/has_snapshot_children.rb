module HasSnapshotChildren
  extend ActiveSupport::Concern
  
  included do

    include ActiveSnapshot
    
    has_snapshot_children do

      instance = self.class.find(id)

      descendants = instance.descendants.includes(:profile)

      {
        descendants: descendants,
        descendants_profiles: descendants.map { |d| d.profile }
      }
    end
  end
end
