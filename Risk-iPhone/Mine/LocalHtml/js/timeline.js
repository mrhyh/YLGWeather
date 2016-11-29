$(function(){
//	var httpLink = "http://192.168.0.128:8080/ubirth/";
	$.ajax({
		type: "GET",
		url: "http://risk.51ysyy.com/ubirth/rest/riskcontent/getRiskAddRecord",
		data: { type: 2 },
		dataType: "json",
		async: true,
		beforeSend:function (request) {
            request.setRequestHeader("version","1.0");
            request.setRequestHeader("token",localStorage.getItem("token"));
        },
		success: function(data){
			console.log(data);
			var len = data.content.length;
			if(data.status==200){
				if(len!=0){
					for(var i=0; i<len; i++){
						$(".time-line-wrapper").append('<div class="time-line-info">' +
													   '<city class="city">' + '更新' +'</city>' +
													   '<time class="time">' + data.content[i].updateTime.substring(0,10) +'</time>' +
													   '<div class="clear"></div>' +
													   '</div>' +
													   '<div class="time-line-content">' +
													   '<div class="new-cent">' +
													   '<p>' + data.content[i].updateContent.replace(/\n/g,"<br/>") +'</p>' +
													   '</div></div>');
					};
				}else{
					$("body").html('<div class="no-data" style="height: 30px; font-size: 14px; color: #666; text-align: center; line-height: 30px;">无更新</div>');
				};
			}else{
				
			}
		},
		error: function(jqXHR){
			alert("错误"+jqXHR);
		}
	});
});
