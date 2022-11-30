class PoolsController < BaseController

  def index
    @pools = []
    @pool_root = nil
    @select_parents = []
    @select_children = []

    if current_user.has_role? :manager || current_user.profile.pool.present?
    
      @pools = current_user.pool_container.pools.order(parent_id: :asc).page(params[:page]).per(5)
        
      @pool_root = current_user.pool_container.pools.root
      
      @select_parents = current_user.pool_container.pools.includes(profile:
        [:grade]).decorate.map { |pool| [pool.full_name_and_grade, pool.id] }

      @select_children = Profile.includes(:grade).available.decorate.map do |profile|
        [profile.full_name_and_grade, profile.id]
      end
    end
  end

  def create
    params = pool_params.merge(pool_container_id: current_user.pool_container.id)

    @pool = Pool.new(params)

    authorize @pool, policy_class: PoolPolicy
    if @pool.save
      snapshot_service.create_snapshot(current_user.pool_container)
      redirect_to root_path, notice: t('controllers.pools_controller.create.flash.notice')
    else
      redirect_to root_path, alert: t('controllers.pools_controller.create.flash.alert')
    end
  end

  def destroy
    @pool = Pool.find(params[:id])

    authorize @pool, policy_class: PoolPolicy

    if @pool.parent_id.present?
      @pool.destroy!
      snapshot_service.create_snapshot(current_user.pool_container)
      redirect_to root_path, notice: t('controllers.pools_controller.destroy.flash.notice')
    else
      redirect_to root_path, alert: t('controllers.pools_controller.destroy.flash.alert')
    end
  end

  def pool_graph
    pools = []
    if current_user.has_role? :manager
      pools = current_user.pool_container.pools.includes(:profile)
    else
      pool = current_user.profile.pool
      if pool.present?
        pools = pool.pool_container.pools
      end
    end
    send_file ::GraphGenerator.new.call(pools, current_user.profile.id)
  end

  private

  def pool_params
    params.require(:pool).permit(:id, :type, :profile_id, :parent_id)
  end

  def snapshot_service
    @snaphost_service ||= SnapshotService.new
  end
end
