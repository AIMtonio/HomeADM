$(document).ready(function() {	
	esTab = true;
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	var tiposConsulta = {
			'anios':1
		};
  	
	consultaPeriodos();

	function consultaPeriodos(){
		var tipoConsulta=tiposConsulta.anios;
		var fecha = parametroBean.fechaAplicacion;
		dwr.util.removeAllOptions('anio');
		
		reporteISRRetenidoServicio.consulta(tipoConsulta,function(ejercicioContable){				
			var x = document.getElementById("anio");
			
			fecha=fecha.substring(0,4);
			if (ejercicioContable.length==0){
				var option = document.createElement("option");
				option.text = fecha;
				option.value = fecha;
				x.add(option);
			}
				else
			{			
				if(ejercicioContable[0].anio!=fecha){
				var option = document.createElement("option");
				option.text = fecha;
				option.value = fecha;
				x.add(option);
			}
			 for (i in ejercicioContable) { 
				var option = document.createElement("option");
				option.text = ejercicioContable[i].anio;
				option.value =  ejercicioContable[i].anio;
				x.add(option);
				 
				}

			}
					

	});
	}
		

   $('#generar').click(function() {		
	   generaReporte();
   });
   

   
   function generaReporte(){
	   	var anio = $('#anio').val();
	   	var hora = '';
	   	var nombreInstitucion=parametroBean.nombreInstitucion;
	   	var fecha = parametroBean.fechaAplicacion;
	   	var usuario=parametroBean.nombreUsuario;
	   	var horaEmision = new Date();
		hora = horaEmision.getHours();
		if(horaEmision.getMinutes()<10){
		hora = hora + ':'+ '0'+ horaEmision.getMinutes();
		}else{
		hora = hora + ':' + horaEmision.getMinutes();
		}
	   
	   var pagina='repISRRetenido.htm?anio='+anio+'&fecha='+fecha+'&hora='+hora+'&usuarionombre='+usuario+'&nombreInstitucion='+nombreInstitucion;
	   if($('#excel').is(':checked')){
		   pagina=pagina+'&tipoReporte=1';
	   }
	   window.open(pagina,'_blank');  
   };
   	

 
   
});
