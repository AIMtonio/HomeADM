$(document).ready(function(){
	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	
	var catTipoRep = {
		'pdf' : '1'		
	};
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$(':text').focus(function() {
		esTab = false; 
	});
	
	function realizaProceso(valorCaja1, valorCaja2){
		var autorizacion = "Bearer 4/mpO7zQvLT4EA0iRCSZzLwbb_8f_l.ctF_g3HgVZoXmmS0T3UFEsNQJKR8gwI";
        var parametros = {
        		"address" : "747+6th+St+S%2C+Kirkland+WA+98033",
        		"lat" : "47.670188&",
        		"lng" : "-122.196335",
        		"title" : "Maintenance+appointment",
        		"assignee" : "mike%40example.com"
        };
        $.ajax({
        		type:'POST',
        		url: "www.googleapis.com",
        		beforeSend: function (request)
                {
                    request.setRequestHeader("Authorization", autorizacion);
                },
                data:  parametros,
                success:  function (response) {
                        $("#mensaje").html(response);
                }
        });
	}	
});