class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.date :attendance_date
      t.integer :year
      t.integer :month
      t.integer :day
      t.boolean :byouketu
      t.boolean :kekkin
      t.boolean :hankekkein
      t.boolean :tikoku
      t.boolean :soutai
      t.boolean :gaisyutu
      t.boolean :tokkyuu
      t.boolean :furikyuu
      t.boolean :yuukyuu
      t.boolean :hankyuu
      t.integer :tyouka_time
      t.integer :kyujitu_time
      t.integer :sinya_time
      t.integer :kyuukei_time
      t.integer :koujo_time
      t.integer :jitudou_time
      t.string :remarks

      t.timestamps
    end
  end
end
