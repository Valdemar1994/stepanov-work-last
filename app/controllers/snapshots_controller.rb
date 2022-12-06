class SnapshotsController < BaseController

  def index
    @today = Date.today

    year = params.dig(:date, :year)
    month = Date::ABBR_MONTHNAMES[params.dig(:date, :month).to_i]

    if year.present? && month.present?
      date = "#{month} #{year}"
      @snapshots = current_user.pool_snapshots_by_date(date).page(params[:page]).per(5)
    else
      @snapshots = current_user.pool_snapshots.page(params[:page]).per(5)
    end
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
