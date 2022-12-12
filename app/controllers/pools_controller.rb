class PoolsController < BaseController

  def index
    @pools = []
    @pool_root = nil
    @select_parents = []
    @select_children = []

    @grades = Grade.all
    @specialitys = Speciality.all
    @filter_params = filter_params

    if filter_params[:grade_id].present?
      @select_grade_name = @grades.find { |g| g.id == filter_params[:grade_id].to_i }&.name
    end

    if filter_params[:speciality_id].present?
      @select_speciality_name = @specialitys.find { |s| s.id == filter_params[:speciality_id].to_i }&.name
    end

    @current_pool = current_user.pool_container

    if current_user.has_role? :manager || current_user.profile.pool.present?

      @pools = @current_pool.filtered_pools(filter_params).order(parent_id: :asc).page(params[:page]).per(5)

      @select_parents = @current_pool.pools.includes(profile:
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

  def edit
    @pool = Pool.find(params[:id])
  end

  def update
    @pool = Pool.find(params[:id])
    @pool.update(pool_params)
    redirect_to root_path
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
    filtered_ids = []
    if current_user.has_role? :manager
      user_pool_container = current_user.pool_container
      pools = user_pool_container.pools.includes(:profile)
      if filter_params_to_graph[:grade_id].present? || filter_params_to_graph[:speciality_id].present?
        filtered_ids = user_pool_container.filtered_pools(filter_params_to_graph).pluck(:profile_id)
      end
    else
      pool = current_user.profile.pool
      if pool.present?
        pools = pool.pool_container.pools
      end
    end
    send_file ::GraphGenerator.new.call(pools, current_user.profile.id, filtered_ids)
  end

  private

  def pool_params
    params.require(:pool).permit(:id, :type, :profile_id, :parent_id, :pool_container_id)
  end

  def filter_params
    slice_params = params.slice(:grade_id, :speciality_id)

    params_to_filter = { "grade_id"=>'', "speciality_id"=>'' }

    if slice_params.present?
      params_to_filter = slice_params if slice_params.present?
    end
    params_to_filter
  end

  def filter_params_to_graph
    params.slice(:grade_id, :speciality_id).permit!
  end

  def snapshot_service
    @snaphost_service ||= SnapshotService.new
  end
end
