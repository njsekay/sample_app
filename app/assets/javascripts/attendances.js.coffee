# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@syousuu_format = (name) ->
  n = $(name).val()
  n = n + "."
  n = n.split(".")[0] + "." + (n.split(".")[1] + "00").substring(0,2)
  $(name).val(n)

@zero_padding = (name, length) ->
  number = document.getElementById(name).value
  document.getElementById(name).value = (Array(length).join('0') + number).slice(-length)

@submitWithValueAndConfirm = (formid, commitValue, text) ->
  if text != ""
    if window.confirm(text)
      objForm = document.getElementById(formid)
      objForm.commit_value.value = commitValue
      objForm.submit()
    else
      false
  else
    objForm = document.getElementById(formid)
    objForm.commit_value.value = commitValue
    objForm.submit()

$ ->
  for i in [0..$('#attendances').data("attendances-size")]
    syousuu_format('#user_attendances_attributes_' + i + '_tyouka_time');
    syousuu_format('#user_attendances_attributes_' + i + '_kyujitu_time');
    syousuu_format('#user_attendances_attributes_' + i + '_sinya_time');
    syousuu_format('#user_attendances_attributes_' + i + '_kyuukei_time');
    syousuu_format('#user_attendances_attributes_' + i + '_koujo_time');
    syousuu_format('#user_attendances_attributes_' + i + '_jitudou_time');

$ ->
  $('.timepicker').timepicker({minuteStep: 15, showSeconds: false, showMeridian: false})