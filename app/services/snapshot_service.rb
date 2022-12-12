class SnapshotService
  MINIMUM_NUMBERS_OF_POOL = 2

  def create_snapshot(pool_container)

    return if pool_container.blank? || pool_container.pools.count < MINIMUM_NUMBERS_OF_POOL

      pool_root = pool_container.pools.root
      pool_root.create_snapshot!(
        "Time: #{Time.new}",
        user: pool_container.user
      )
  end
end
