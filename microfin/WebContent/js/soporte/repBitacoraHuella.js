var catTipoReporte = {
		'usuario' : '2',
		'cliente' : '1'
	};
var tipoPresentacion, tipoLista, nombreUsuario, nombreInstitucion, fechaEmision;
/* Funcion para generar el reporte en Excel */
	function generaExcel(){		
		tipoPresentacion ="";
		tipoLista = "";  
		nombreUsuario=parametroBean.claveUsuario;
		nombreInstitucion=parametroBean.nombreInstitucion;
		fechaEmision=parametroBean.fechaSucursal;
		
		if($('#tipoReporte').val()==1)	{
			tipoLista = 1;
			tipoPresentacion =catTipoReporte.cliente; 
		}else if($('#tipoReporte').val()==2){
			tipoLista = 2;
			tipoPresentacion =catTipoReporte.usuario;
		}
	
		$('#ligaGenerar').attr('href','ProcesoBitacoraHuella.htm?tipoPresentacion='+tipoPresentacion+'&tipoLista='+tipoLista
				+'&fechaReporte='+$('#fechaReporte').val()+'&empresa='+$('#empresaID').val()
				+'&nombreInstitucion='+nombreInstitucion+'&nombreUsuario='+nombreUsuario
				+'&parFechaEmision='+fechaEmision+'&fechaInicio='+$('#fechaInicio').val()+'&fechaFin='+$('#fechaFin').val());
	}

	function regresarFoco(idControl){
		
		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
		 },0);
	}

	$('#excel').click(function() {
		$('#excel').attr("checked",true); 
	});

$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	parametros = consultaParametrosSession();
	$('#excel').attr("checked",true);
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
  	
	$('#fechaInicio').val(parametros.fechaAplicacion); 	
	$('#fechaFin').val(parametros.fechaAplicacion);
	$('#fechaReporte').val(parametroBean.fechaSucursal);
	$('#empresaID').val(parametroBean.numeroSucursalMatriz);

	$('#formaGenerica').validate({
		rules:{
			tipoReporte:{
				required : true
			},
			fechaReporte:{
				required: true
			}
		},
		messages:{
			tipoReporte:{
				required: 'Especifique un Tipo de Reporte'
			},
			fechaReporte:{
				required: 'Especifique una Fecha de Reporte'
			}
		}		
	});

	$(':text').focus(function() {	
	 	esTab = false;
	});
 
	//------------ Validaciones de la Forma -------------------------------------
 
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#genera').click(function() {	
		if($('#tipoReporte').val()==''){	
			mensajeSis('Especifique un tipo de Reporte');
				$('#tipoReporte').focus();
				tipoPresentacion ="";
				tipoLista = "";  
				nombreUsuario="";
				nombreInstitucion="";
				fechaEmision="";
		}else if($('#fechaInicio').val() == ''){
				mensajeSis('La fecha de Inicio está vacía');
				$('#fechaInicio').focus();
				tipoPresentacion ="";
				tipoLista = "";  
				nombreUsuario="";
				nombreInstitucion="";
				fechaEmision="";
			}else if($('#fechaFin').val() == ''){
				mensajeSis('La fecha de Fin está vacía');
				$('#fechaFin').focus();
				tipoPresentacion ="";
				tipoLista = "";  
				nombreUsuario="";
				nombreInstitucion="";
				fechaEmision="";
			}else if($('#fechaFin').val() < $('#fechaInicio').val()){
				mensajeSis("La Fecha de Fin es anterior a la Fecha de Inicio.");
				$('#fechaFin').val('');
				$('#fechaFin').focus();	
				tipoPresentacion ="";
				tipoLista = "";  
				nombreUsuario="";
				nombreInstitucion="";
				fechaEmision="";
			}else if($('#fechaInicio').val() > $('#fechaFin').val()){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
				$('#fechaInicio').val('');
				$('#fechaInicio').focus();	
				tipoPresentacion ="";
				tipoLista = "";  
				nombreUsuario="";
				nombreInstitucion="";
				fechaEmision="";
			}else if(!$('#excel').is(":checked")){
				mensajeSis("La presentación no se ha elegido");
				$('#excel').focus();	
			}
			else{	
				generaExcel();
				$('#tipoReporte').focus();		
			}
	});

});