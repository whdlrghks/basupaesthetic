var dev_hidden_tap = false;
var hidden = 0;
var URL = "https://web.basup-server.com";
var Dev_URL = "https://dev-web.basup-server.com";
var access_Token = "basup2022!!";
var access_Dev_Token = "skinlab2021!";


enum Gender { M, W, None }

enum DataType { SENS, TIGHT, WATER, OIL, PIG}

var CODE_OK = "CODE_3000";
var NOT_EXIST = "CODE_5002";
var NOT_PROJECT = "CODE_5004";
var EXISTED = "CODE_5006";
var SMS_OK = "SCOM_3000";
var SURVEY_RESULT_NOT_EXIST ="CODE_5017";
var NO_CARD_INFO = "CODE_5023";
var NO_REMAIN_SUBS_INFO = "CODE_5033";

var figma_width = 375;
var figma_hight = 812;


final standardDeviceHeight = 720;
var device_Width_context = 100.0;

var edit_page_component_top = 5.0;
var edit_page_component_bottom = 5.0;

var skin_data_Min = 5;
var skin_bar_data_Min = 5.0;

var send_button_height = 65.0;

var pay_button_height = 95.0;


setDevice_Width(double newWidth) {
  device_Width_context = newWidth;
}

getDevice_Width() {
  return device_Width_context;
}