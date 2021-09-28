class CourierInvoiceData {
  String doc_no;		      // 주문번호
  String prod_des;		    // 품목명
  String doc_qty;		      // 주문상품수량
  String doc_name;		    // 주문자이름
  String doc_telephone;		// 주문자전화
  String doc_cellphone;		// 주문자핸드폰
  String cust_name;		    // 수취인이름
  String cust_telephone;	// 수취인전화
  String cust_cellphone;	// 수취인핸드폰
  String cust_zip;		    // 주소2 우편번호
  String cust_address;		// 주소2
  String track_id;		    // 송장번호
  String track_memo;		  // 배송메시지
  String p_remarks2;      // 배송비
  String carrierURL;      // 택배사 배송 조회 URL
  bool isCheck;
}