 
$(document).ready(function() {
		 
	 	
	//Definicion de Constantes y Enums  
	var catTipoConsultaDatosVivienda = {
  		'principal':1,
  		'foranea':2
	};	
 
	
	var catTipoTranDatosVivienda = {
  		'graba':1
	};
	
	var parametroBean = consultaParametrosSession();  
	 
 	 
 	 
	agregaFormatoControles('formaGenerica4');
	 

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccion(event, 'formaGenerica4', 'contenedorForma', 'mensaje','false','dependEconom');
			agregaFormatoControles('formaGenerica4');
		}
	});	
	 
	 

	llenaTipoComboMatVivienda('tipoMaterialID');
	llenaTipoComboTiposVivienda('tipoViviendaID');
	 
	
	$('#grabarViv').click(function() {	
		$('#tipoTransaccionViv').val(catTipoTranDatosVivienda.graba);
	});
	
	$('#drenajeSi').click(function() {	
			$('#conDrenaje').val('S');
	});
	$('#drenajeNo').click(function() {	
		$('#conDrenaje').val('N');
	});
	
	
	$('#pavimentoSi').click(function() {	
			$('#conPavimento').val('S');
	});
	$('#pavimentoNo').click(function() {	
		$('#conPavimento').val('N');
	});
	
	
	$('#gasSi').click(function() {	
			$('#conGas').val('S');
	});
	$('#gasNo').click(function() {	
		$('#conGas').val('N');
	});
 
	
	
	$('#electricidadSi').click(function() {	
			$('#conElectricidad').val('S');
	});
	$('#electricidadNo').click(function() {	
		$('#conElectricidad').val('N');
	});
 
	
	
	$('#aguaSi').click(function() {	
			$('#conAgua').val('S');
	});
	$('#aguaNo').click(function() {	
		$('#conAgua').val('N');
	});
 
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica4').validate({
		rules: {
			tipoDomicilioID: { 
				required: true
			},
			 
			
			tipoMaterialID: { 
				required: true
			},
						 
			descripcion: { 
				required: true,
				maxlength: 500
			}
			
			
		},
		
		messages: {
			tipoDomicilioID: { 
				required: 'Seleccione tipo de Vivienda'
			},
			 
			
			tipoMaterialID: { 
				required: 'Seleccione el tipo de material'
			},
						
			descripcion: { 
				required: 'Agregue una descripción de la vivienda',
				maxlength: 'M&aacute;ximo 500 caracteres'
			}
			
		}		
	});
	
 
   
	
 

	
	 
	 
	 function llenaTipoComboMatVivienda(idControl){
			var todos=0;
			var datSocDemogBean = {
			  		'tipoMaterialID':todos
				};	
			
			var tipoListaPrincipal=1;
			dwr.util.removeAllOptions(idControl); 
			socDemoViviendaServicio.comboMaterialVivienda(tipoListaPrincipal,datSocDemogBean ,function(lisMaterialViv){
			 
				dwr.util.addOptions(idControl, lisMaterialViv, 'tipoMaterialID', 'descripMaterial');
			});
		}
 
	 
	 function llenaTipoComboTiposVivienda(idControl){
			var todos=0;
			var datSocDemogBean = {
			  		'tipoMaterialID':todos
				};	
			
			var tipoListaPrincipal=1;
			dwr.util.removeAllOptions(idControl); 
			socDemoViviendaServicio.comboTiposVivienda(tipoListaPrincipal,datSocDemogBean ,function(lisTiposViv){
			 
				dwr.util.addOptions(idControl, lisTiposViv, 'tipoViviendaID', 'descripVivienda');
			});
		}
 
	
});// fin de document ready
		


 
	
 
	
	
 
	
 
	 
	
	
	