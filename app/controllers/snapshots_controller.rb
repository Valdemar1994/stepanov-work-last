class SnapshotsController < BaseController

  def index
    @snapshots = current_user.pool_snapshots.page(params[:page]).per(5)
  end
  
  def show
    @snapshots = current_user.pool_snapshots.page(params[:page]).per(5)
    @snapshot = ActiveSnapshot::Snapshot.find(params[:id])
  end

  def destroy
    snapshot = ActiveSnapshot::Snapshot.find(params[:id])
    if snapshot.destroy
      redirect_to snapshots_path, notice: t('controllers.snapshots_controller.create.flash.notice')
    else
      redirect_to snapshots_path, alert: t('controllers.snapshots_controller.create.flash.alert')
    end
  end

  def snapshot_graph
    snapshot = ActiveSnapshot::Snapshot.find(params[:snapshot_id])
    restore = ::SnapshotRestore.new.call(snapshot)
    send_file ::GraphGenerator.new.call(restore, current_user.profile.id)
  end
end
