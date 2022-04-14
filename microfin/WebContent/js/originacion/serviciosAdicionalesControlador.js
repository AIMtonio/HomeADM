var esRequerido = false;

$(document).ready(function(){
	// Definicion de Constantes y Enums
	esTab = true;
	var esProductoNoNomina = 'N';
	var esProductoNomina = 'S';
	var esProductoNominaNoConfig = 'E';
	var cadenaSI = 'S';
	
	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	var catTipoConClasificacion = {
			'principal':1
	};
	
	var tipoConServicio = {
			'principal': 1
	}
	
	var tipoTransaccion = {
			'alta': 1,
			'modifica': 2,
			'elimina': 3
	}
	
	var tipoConServicioAdicional = {
			validaNomina: 3
	}
	
	var tipoLisServicioAdicional = {
			'institNomina': 3
	}
	
	$('#servicioID').focus();
	$('.lblInstitNominaID').hide();
	funcionConsultarProductoCredito();
	deshabilitarBotones();
		
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','servicioID','funcionExito','funcionError');
		}
	});	
			
	$('#formaGenerica').validate({
		rules:{
			servicioID:{
				required: true
			},
			descripcion:{
				required: true
			},	
			tipoDocumento:{
				required: function(){
					return $('#validaDocs').val() == cadenaSI
				}
			},
			producCreditoID:{
				required: true
			},
			institNominaID:{
				required: function(){
					return esRequerido;
				}
			}
		},
		messages:{
			servicioID:{
				required: 'Especifique Id del servicio'
			},
			descripcion:{
				required: 'Especifique la descripcion del servicio'
			},
			tipoDocumento:{
				required: 'Especifique el tipo de documento'
			},
			producCreditoID:{
				required: 'Seleccione el producto de crédito'
			},
			institNominaID:{
				required: 'Seleccione la empresa o institución de nómina'
			}
		}
		
	});
	
	$('#servicioID').bind('keyup',function(e){
		lista('servicioID', '2', '1', 'descripcion', $('#servicioID').val(), 'serviciosAdicionalesListaVista.htm');
	});
	
	
	$('#servicioID').blur(function(){
		
		var servicioID = $('#servicioID').val();
		if ((servicioID == '' || isNaN(servicioID)) && !esTab){
			return;
		}
		
		setTimeout("$('#cajaLista').hide();", 200);
		//Si se va a modificar una solicitud adicional
		servicioID = $('#servicioID').asNumber();
		if (servicioID != 0 && esTab){
			limpiarFormulario();
			var serviciosAdicionalesBean = {
					servicioID: $('#servicioID').asNumber()
			};
			
			serviciosAdicionalesServicio.consulta(serviciosAdicionalesBean, tipoConServicio.principal, function(servicioAdicional){
				if (servicioAdicional != null){
					setTimeout(() => {
						//Establecer los valores del servicio adicional
						$('.lblInstitNominaID').show();
						establecerServicioAdicional(servicioAdicional);
						habilitarBotonesModificarEliminar();
						deshabilitarBotonGrabar();
						
					}, 700);
				}else{
					mensajeSis("El Servicio no existe");
					$('#servicioID').focus();
					deshabilitarBotones();
					limpiarFormulario();
				}
			});
		}else if (servicioID == 0 && esTab){
			limpiarFormulario();
			habilitarBotonGrabar();
			deshabilitarBotonesModificarEliminar();
		}
	});
	
	
	
	$('#tipoDocumento').bind('keyup',function(e){		 
		lista('tipoDocumento', '2', '1', 'clasificaDesc', $('#tipoDocumento').val(), 'clasificaDocumentosListaVista.htm');
	});	
	
	$('#tipoDocumento').blur(function() {
		funcionConsultarTipoDocumento(this.id);
	});
	
	function funcionConsultarTipoDocumento(idControl){
		var jqClasificacionID  = eval("'#" + idControl + "'");
		var valorClasificacionID = $(jqClasificacionID).val();			
	
		setTimeout("$('#cajaLista').hide();", 200);
		if(valorClasificacionID != '' && !isNaN(valorClasificacionID)){		
			var clasificaDocBen = { 
					'clasificaTipDocID':valorClasificacionID
				};						
			clasificaTipDocServicio.consulta(catTipoConClasificacion.principal,clasificaDocBen,function(instance) {
				if(instance!=null){
					$('#tipoDocumento').val(instance.clasificaTipDocID);
					$('#desTipoDocumento').val(instance.clasificaDesc);
				}else{ 
					mensajeSis("El Tipo de Documento no Existe");
					$(jqClasificacionID).focus();
				}
			});		
			
		}	
		
	}
	
	$('#agregar').click(function(event){
		$('#tipoTransaccion').val(tipoTransaccion.alta);
	});
	
	$('#modificar').click(function(){
		$('#tipoTransaccion').val(tipoTransaccion.modifica);
	});
	
	$('#eliminar').click(function(){
		$('#tipoTransaccion').val(tipoTransaccion.elimina);
	});
	
	$('#validaDocs').change(function(){
		if ($('#validaDocs').val() == cadenaSI){
			$('.lblTipoDeDocumento').show();
		}else{
			$('.lblTipoDeDocumento').hide();
		}
		$('#tipoDocumento').val('');
		$('#desTipoDocumento').val('');
	});
	
	$('#producCreditoID').change(function(){
		var arrSelected = obtenerCamposSeleccionados('#producCreditoID');
		arrSelected.forEach(function(item){
    	   if (item === '0'){
    		   $('#producCreditoID option').attr('selected', 'selected');
    	   }
    	});
		
		funcionConsultarEmpresaNomina();
	});
	
	
	$('#institNominaID').change(function(){
		var arrSelected = obtenerCamposSeleccionados('#institNominaID');
		arrSelected.forEach(function(item){
    	   if (item === '0'){
    		   $('#institNominaID option').attr('selected', 'selected');
    	   }
    	});
	});
	
	function obtenerCamposSeleccionados(control){
		var selected = $(control).find("option:selected");
		var arrSelected = [];
		selected.each(function(){
			arrSelected.push($(this).val());
		});
		return arrSelected;
	}
	
	function funcionConsultarProductoCredito() {			
		dwr.util.removeAllOptions('producCreditoID'); 		
		dwr.util.addOptions('producCreditoID', {0:'TODOS'});						     
		productosCreditoServicio.listaCombo(11, function(instance){
		dwr.util.addOptions('producCreditoID', instance, 'producCreditoID', 'descripcion');
		});
	}
	
	function funcionConsultarEmpresaNomina() {		
		var listaProductosSeleccionados = obtenerCamposSeleccionados('#producCreditoID');
		var listaProductoSinCero = new Array();
		for (var i = 0; i < listaProductosSeleccionados.length; i++) {
			var producto = listaProductosSeleccionados[i];
			if (producto != 0){
				listaProductoSinCero.push(producto);
			}
		}
		var cadenaProductos = listaProductoSinCero.join(',');
		
		
		var serviciosAdicionalBean = {
				servicioID: $('#servicioID').asNumber(),
				descripcion: cadenaProductos,
		}
		
		serviciosAdicionalesServicio.consulta(serviciosAdicionalBean, tipoConServicioAdicional.validaNomina, function(servicioAdicional){
			$('#institNominaID').empty();
			var validaNomina = servicioAdicional.descripcion;
			if(validaNomina == esProductoNoNomina){
				esRequerido = false;
				$('.lblInstitNominaID').hide();
			}else if(validaNomina == esProductoNomina){
				esRequerido = true;
				dwr.util.removeAllOptions('institNominaID'); 		
				dwr.util.addOptions('institNominaID', {0:'TODOS'});
				serviciosAdicionalesServicio.lista(serviciosAdicionalBean, tipoLisServicioAdicional.institNomina, function(instituciones){
					dwr.util.addOptions('institNominaID', instituciones, 'servicioID', 'descripcion');
				});
				$('.lblInstitNominaID').show();
				if($('#servicioID').asNumber() == 0){
					mensajeSis("Seleccione al menos una institución de nómina");
				}
			}else if(validaNomina == esProductoNominaNoConfig){
				esRequerido = true;
				$('.lblInstitNominaID').show();
				mensajeSis("No existe instituciones o empresas de nómina vinculadas al producto de crédito");
			}
			
		});	
	}
	
	function funcionSeleccionarProductoCredito(instance) {
		var producCredito = instance.split(',');
		var tamanio = producCredito.length;
		for (var i=0;i<tamanio;i++) {  
			var data = producCredito[i];
			var jqproducCredito = eval("'#producCreditoID option[value="+data+"]'");  
			$(jqproducCredito).attr("selected","selected");   
		} 
	}
	
	function funcionSeleccionarEmpresaNomina(instance) {
		
		var listaProductosSeleccionados = obtenerCamposSeleccionados('#producCreditoID');
		var listaProductoSinCero = new Array();
		for (var i = 0; i < listaProductosSeleccionados.length; i++) {
			var producto = listaProductosSeleccionados[i];
			if (producto != 0){
				listaProductoSinCero.push(producto);
			}
		}
		var cadenaProductos = listaProductoSinCero.join(',');
		var serviciosAdicionalBean = {
				servicioID: $('#servicioID').asNumber(),
				descripcion: cadenaProductos,
		}
		
		dwr.util.removeAllOptions('institNominaID'); 		
		dwr.util.addOptions('institNominaID', {0:'TODOS'});
		$('.lblInstitNominaID').hide();
		serviciosAdicionalesServicio.lista(serviciosAdicionalBean, tipoLisServicioAdicional.institNomina, function(instituciones){
			if (instituciones.length > 0){
				dwr.util.addOptions('institNominaID', instituciones, 'servicioID', 'descripcion');
				var empresa = instance.split(',');
				var tamanio = empresa.length;
				for (var i=0;i<tamanio;i++) {  
					var data = empresa[i];
					var jqEmpresa = eval("'#institNominaID option[value="+data+"]'");  
					$(jqEmpresa).attr("selected","selected");   
				} 
				$('.lblInstitNominaID').show();
			}
		});
	}
	
	function habilitarBotonGrabar(){
		habilitaBoton('agregar','submit');
	}

	function deshabilitarBotonGrabar(){
		deshabilitaBoton('agregar','submit');
	}

	function habilitarBotonesModificarEliminar(){
		habilitaBoton('modificar','submit');
		habilitaBoton('eliminar','submit');
	}

	function deshabilitarBotonesModificarEliminar(){
		deshabilitaBoton('modificar','submit');
		deshabilitaBoton('eliminar','submit');
	}

	function deshabilitarBotones(){
		deshabilitaBoton('agregar','submit');
		deshabilitaBoton('modificar','submit');
		deshabilitaBoton('eliminar','submit');
	}

	
	
	function establecerServicioAdicional(servicioAdicional){
		//Establece la descripción del servicio
		$('#descripcion').val(servicioAdicional.descripcion);
		
		//Establece el valor si se valida el documentoc
		$('#validaDocs').val(servicioAdicional.validaDocs);
		if ($('#validaDocs').val() != cadenaSI){
			$('.lblTipoDeDocumento').hide();
			$('#tipoDocumento').val('');
			$('#desTipoDocumento').val('');
		}else{
			$('.lblTipoDeDocumento').show();
			$('#tipoDocumento').val(servicioAdicional.tipoDocumento);
			funcionConsultarTipoDocumento('tipoDocumento');
		}
				
		//Selecciona los productos de credito y las empresas
		funcionSeleccionarProductoCredito(servicioAdicional.listaProductosCredito);
		funcionSeleccionarEmpresaNomina(servicioAdicional.listaEmpresas);
	}
	
	function limpiarFormulario(){
		esTab = false;
		$('#descripcion').val('');
		$('#validaDocs select').val('S');
		$('#tipoDocumento').val('');
		$('#desTipoDocumento').val('');
		$('#producCreditoID').val([]);
		$('#institNominaID').val([]);
		$('.lblInstitNominaID').hide();
	}

});



function funcionExito(){
	$('#descripcion').val('');
	$('#validaDocs select').val('S');
	$('#tipoDocumento').val('');
	$('#desTipoDocumento').val('');
	$('#producCreditoID').val([]);
	$('#institNominaID').val([]);
	$('.lblInstitNominaID').hide();
	deshabilitaBoton('agregar','submit');
	deshabilitaBoton('modificar','submit');
	deshabilitaBoton('eliminar','submit');
	esTab = false;
}

function funcionError(){
	 agregaFormatoControles('formaGenerica');
	 esTab = false;
}
