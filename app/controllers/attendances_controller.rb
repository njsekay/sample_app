# -*- coding: utf-8 -*-
class AttendancesController < ApplicationController
  
  def index
    # @user = current_user
    @user = User.find(101)
    @today = Time.now

    if @user.present? and ! @user.attendances.where("year = ? and month = ?", @today.year, @today.month).exists? then

      params[:new_record_flg] = "yes"

      nissuu = Time.days_in_month(@today.month, @today.year)
      @kintai_start_day = Date.new(@today.year, @today.month, 16)
      @kintai_end_day = @kintai_start_day.next_month.yesterday

      for num in 0..nissuu-1 do
        tmp_kinmu_kbn = "0"
        if 0 < @kintai_start_day.wday && @kintai_start_day.wday < 6
          tmp_kinmu_kbn = "1"
        end

        @user.attendances.build(
          attendance_date: @kintai_start_day,
          year: sprintf("%04d", @kintai_start_day.year),
          month: sprintf("%02d", @kintai_start_day.month),
          day: sprintf("%02d", @kintai_start_day.day),
          wday: %w(日 月 火 水 木 金 土)[@kintai_start_day.wday],
          kinmu_kbn: tmp_kinmu_kbn,
          start_time: "9:00",
          end_time: "17:30",
          jitudou_time: 7.50
          )
        @kintai_start_day = @kintai_start_day.tomorrow
      end
    end
  end

  def update
    @user = User.find(params[:user][:id])
    
    logger.unknown("DEBUG START")
    logger.unknown(user_params)
    logger.unknown("DEBUG END")
    
    if @user.update_attributes(user_params)
      logger.unknown("UPDATE SUCCESS")
      redirect_to attendance_path(current_user)
    else
      logger.unknown("UPDATE FAILED")
      render 'index'
    end
  end


  private

  def user_params
    params.require(:user).permit(:name,
      attendances_attributes: [:id, :attendance_date, :year, :month, :day, :wday, :start_time, :end_time,
        :byouketu, :kekkin, :hankekkein, :tikoku, :soutai, :gaisyutu, :tokkyuu, :furikyuu, :yuukyuu, :hankyuu,
        :tyouka_time, :kyujitu_time, :sinya_time, :kyuukei_time, :koujo_time, :jitudou_time, :remarks, :kyuujitu_kbn, :kaigi_kbn, :kinmu_kbn])
  end
end
