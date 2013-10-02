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
    
    if @user.update_attributes(user_params)
      logger.unknown("UPDATE SUCCESS")
      redirect_to attendances_path(current_user)
    else
      logger.unknown("UPDATE FAILED")
      render 'index'
    end
  end

  def print
    respond_to do |format|
      format.pdf { output_attendance_list(current_user)}
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,
      attendances_attributes: [:id, :attendance_date, :year, :month, :day, :wday, :start_time, :end_time,
        :byouketu, :kekkin, :hankekkein, :tikoku, :soutai, :gaisyutu, :tokkyuu, :furikyuu, :yuukyuu, :hankyuu,
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
        
        row.values date: temp_date, #日付
        y: attendance.wday, #曜日
        k: attendance.kinmu_kbn, #勤務区分
        s_t: attendance.start_time, #勤務時間(出勤)
        e_t: attendance.end_time, #勤務時間(退勤)
        kb: "○", #傷病欠
        kk: "○", #欠勤
        hk: "○", #半欠勤
        tk: "○", #遅刻
        st: "○", #早退
        sg: "○", #私外出
        k1: "○", #特休
        k2: "○", #振休
        k3: "○", #有休
        ss: "○", #出張
        t1: "9.50", #所定時間外勤務(超過時間)
        t2: "9.50", #所定時間外勤務(休日時間)
        t3: "9.50", #所定時間外勤務(深夜時間)
        t4: "9.50", #所定時間外勤務(休憩時間)
        t5: "9.50", #所定時間外勤務(控除時間)
        j_t: "9.50", #実働時間
        bko: "夏季休暇" #備考
      end
    end

    send_data report.generate, filename: '勤怠表.pdf',
                               type: 'application/pdf',
                               disposition: 'attachment'
  end
end
