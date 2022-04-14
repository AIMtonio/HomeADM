$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	
	var parametroBean = consultaParametrosSession();
	$('#fecha').val(parametroBean.fechaSucursal);
	
	var catTipoListaTipoInversion = {
		'principal':1
	};

	var catTipoConsultaTipoInversion = {
		'secundaria' : 2
	};
	
	var parametroBean = consultaParametrosSession();
	$('#fecha').val(parametroBean.fechaSucursal);
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
      submitHandler: function(event) { 
      	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoInversionID');
      }
   });					
   
	  //------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fecha: 'required',
			tipoInversionID: 'required'
		},
		
		messages: {
			fecha: 'Especifique una fecha',
			tipoInversionID: 'Especifique el tipo de Inversión'
		}		
	});
			
	$('#tipoInversionID').bind('keyup',function(e){
		if(this.value.length >= 3){
			
			var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "monedaId";
			 camposLista[1] = "descripcion";
			 parametrosLista[0] = 0;
			 parametrosLista[1] = $('#tipoInversionID').val();
			
			lista('tipoInversionID', 3, catTipoListaTipoInversion.principal, camposLista,
					 parametrosLista, 'listaTipoInversiones.htm');
		}
	});
		
	$('#tipoInversionID').blur(function() {
	
		var tipoInversion = $('#tipoInversionID').val();		
		var tipoConsulta = catTipoConsultaTipoInversion.secundaria;		
		setTimeout("$('#cajaLista').hide();", 200);
		
		var tipoInversionBean = {
      	'tipoInvercionID':tipoInversion,
         'monedaId':0
      };		
		
		if(tipoInversion != '' && !isNaN(tipoInversion) && esTab){
			
			habilitaBoton('agregaInv', 'submit');
									
			tipoInversionesServicio.consultaPrincipal(tipoConsulta, tipoInversionBean, function(tipoInver){
				
				if(tipoInver!=null){
					$('#tipoInversionID').val(tipoInver.tipoInvercionID);							
					$('#descripcionTipoInversion').val(tipoInver.descripcion);
				}else{
					alert("No Existe el Tipo de Inversion");
					$('#tipoInversionID').focus();					
				}
			});
		}
	
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
});