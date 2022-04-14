$(document).ready(function() {
	esTab = false;
    $('#anio').focus();
	var parametroBean = consultaParametrosSession();      
	var fechaSucursal =parametroBean.fechaSucursal;  
	var mesSucursal = fechaSucursal.substr(5,2);
	var anioSucursal = fechaSucursal.substr(0,4);
	limpiarDatos();
	
	
	var catTipoTransaccion = {
			'grabar':1
	}; 

	
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	agregaFormatoControles('formaGenerica');
	llenarAnio();
	
	// se selecciona el mes actual
	$('#mes').val(mesSucursal).selected = true;
	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
  	
  	inicializaForma('formaGenerica', 'numCliente');
 
  	
  	 $.validator.setDefaults({     
         submitHandler: function(event) {          
               grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 
                 'contenedorForma', 'mensaje','true','periodo', 
                 'funcionExito','funcionError');
       }
   }); 
   

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	
	$('#anio').blur(function(){
		$('#periodo').val('');
	});
	

	$('#mes').blur(function(){
		
		consultaPeriodo();
	});


	
	$('#enviar').click(function() {
		  
		subirArchivo();
		
	});
	
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.grabar);
	
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
					
		},
		
		messages: {
			
		}		
	});
	
	
	//------------ Validaciones de Controles -------------------------------------
	
	//Función para poder ingresar solo números o letras 

		function llenarAnio(){
		var i=0;
		document.forms[0].anio.clear;
		document.forms[0].anio.length = 5;
		for (i=0; i < (document.forms[0].anio.length); i++){
			document.forms[0].anio[i].text = anioSucursal-i;
			document.forms[0].anio[i].value = anioSucursal-i;			
		} 
		document.forms[0].anio[0].selected = true;
	    }
		
		function consultaPeriodo() {
			
			limpiarDatos();
		    var anio = $('#anio').val();
		    var mes = $('#mes').val();
			var consultaP =2;
			var PeriodoBeanCon = { 
					'anio':anio,
			        'mes':mes
			};
			setTimeout("$('#cajaLista').hide();", 200);	
			
			edoCtaPeriodoEjecutadoServicio.consulta(consultaP,PeriodoBeanCon,function(periodo){
					if(periodo!=null){
						agregaFormatoControles('formaGenerica');
						$('#periodo').val(periodo.anioMes);
						habilitaBoton('enviar', 'submit');
					}else{
						mensajeSis("El Periodo Seleccionado aún no se a ejecutado para generar el Estado de Cuenta.");
						$('#periodo').focus();
						$('#periodo').val(0);
						$('#anio').focus();
						deshabilitaBoton('enviar', 'submit');
					}    						
				});
		
		}
		
	
		
		function subirArchivo() {
			var url = "cargosObjFileUploadVista.htm?" ;
			var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
			var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;
			ventanaArchivosCliente = window.open(url, "PopUpSubirArchivo", "width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0" + "left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition);
		}
		
	
});

function resultadoCargaArchivo(bean){
	$('#layout').val(bean.campoGenerico);
	habilitaBoton('grabar', 'submit');
}

function limpiarDatos(){
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('enviar', 'submit');
	$('#layout').val('');
	$('#periodo').val('');
}

//funcion que se ejecuta cuando el resultado fue exito
function funcionExito(){
	limpiarDatos();
  
}


function funcionError(){
	limpiarDatos();
}

