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

    if params[:commit] == "帳票出力"
      output_attendance_list(current_user)
    else
      @user = User.find(params[:user][:id])
      
      if @user.update_attributes(user_params)
        logger.unknown("UPDATE SUCCESS")
        redirect_to attendances_path(current_user)
      else
        logger.unknown("UPDATE FAILED")
        render 'index'
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,
      attendances_attributes: [:id, :attendance_date, :year, :month, :day, :wday, :start_time, :end_time,
        :byouketu, :kekkin, :hankekkein, :tikoku, :soutai, :gaisyutu, :tokkyuu, :furikyuu, :yuukyuu, :syuttyou,
        :tyouka_time, :kyujitu_time, :sinya_time, :kyuukei_time, :koujo_time, :jitudou_time, :remarks, :kyuujitu_kbn, :kaigi_kbn, :kinmu_kbn])
  end

  def output_attendance_list(user)
    report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'attendance_list.tlf')

    logger.unknown("DEBUG START")
    logger.unknown(user.name)
    logger.unknown("DEBUG END")

    report.start_new_page do |page|
      page.values project: "協和エクシオ",
      syozoku: "システム事業部2課",
      name: user.name,
      nen: "10",
      tuki: "01"
    end

    user.attendances.each do |attendance|
      
      logger.unknown("DEBUG START")
      logger.unknown(attendance.day)
      logger.unknown("DEBUG END")
      
      report.list.add_row do |row|

        temp_date = "#{attendance.day}"
        
        if "#{attendance.day}" == "1" or "#{attendance.day}" == "16" then
          temp_date = "#{attendance.month}/#{attendance.day}"
        end

        #日付
        row.item(:date).value(temp_date)

        #曜日
        row.item(:y).value(attendance.wday)
        
        #勤務区分
        row.item(:k).value(attendance.kinmu_kbn)
        
        #勤務時間(出勤)
        row.item(:s_t).value(attendance.start_time)
        
        #勤務時間(退勤)
        row.item(:e_t).value(attendance.end_time)
        
        #傷病欠
        row.item(:kb).value("#{'○' if attendance.byouketu}")

        #欠勤
        row.item(:kk).value("#{'○' if attendance.kekkin}")
        
        #半欠勤
        row.item(:hk).value("#{'○' if attendance.hankekkein}")
        
        #遅刻
        row.item(:tk).value("#{'○' if attendance.tikoku}")
        
        #早退
        row.item(:st).value("#{'○' if attendance.soutai}")
        
        #私外出
        row.item(:sg).value("#{'○' if attendance.gaisyutu}")
        
        #特休
        row.item(:k1).value("#{'○' if attendance.tokkyuu}")
        
        #振休
        row.item(:k2).value("#{'○' if attendance.furikyuu}")
        
        #有休
        row.item(:k3).value("#{'○' if attendance.yuukyuu}")
        
        #出張
        row.item(:ss).value("#{'○' if attendance.syuttyou}")
        
        #所定時間外勤務(超過時間)
        row.item(:t1).value(attendance.tyouka_time)
        
        #所定時間外勤務(休日時間)
        row.item(:t2).value(attendance.kyujitu_time)
        
        #所定時間外勤務(深夜時間)
        row.item(:t3).value(attendance.sinya_time)
        
        #所定時間外勤務(休憩時間)
        row.item(:t4).value(attendance.kyuukei_time)
        
        #所定時間外勤務(控除時間)
        row.item(:t5).value(attendance.koujo_time)
        
        #実働時間
        row.item(:j_t).value(attendance.jitudou_time)
        
        #備考
        row.item(:bko).value(attendance.remarks)
      end
    end

    send_data report.generate, filename: '勤怠表.pdf',
                               type: 'application/pdf',
                               disposition: 'attachment'
  end
end
