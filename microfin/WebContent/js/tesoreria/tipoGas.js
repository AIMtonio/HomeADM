$(document).ready(function() {
	esTab = false;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionTipoGas = {
  		'agrega':'1',
  		'modifica':'2'	,
  		'elimina':'3'};
	
	var catTipoConsultaTipoGas = {
  		'principal'	: 1
  		
	};	
	
	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('agrega', 'submit');
    deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('elimina', 'submit');
    $('#tipoGastoID').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoGastoID','funcionExito', 'funcionError');
		}
    });	
    	
	$('#tipoGastoID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#tipoGastoID').val();
			listaAlfanumerica('tipoGastoID', '2', '1', camposLista, parametrosLista, 'listaTipoGas.htm');
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTipoGas.agrega);
		$("#cuentaCompleta").rules("add", {
			required: true,
	 		messages: {
				required: "Especificar No. Cuenta Contable"
	 		}
		});
		validaVacioCuentaContable();
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTipoGas.modifica);
		$("#cuentaCompleta").rules("add", {
	 		required: true,
	 		messages: {
	 			required: "Especificar No. Cuenta Contable"
	 		}
		});
		validaVacioCuentaContable();
	});	
	
	$('#elimina').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTipoGas.elimina);
		$("#cuentaCompleta").rules("remove");
	});	

	$('#tipoGastoID').blur(function() { 
  		validaTipoGas(this.id); 
	});
	
	$('#descripcion').focus(function() { 
	});
	
	$('#cuentaCompleta').blur(function() {
		if($('#cuentaCompleta').val()!="" && esTab){
		    validaCuentaContable('cuentaCompleta');
		}
		setTimeout("$('#cajaLista').hide();", 200);
	});
	
	$('#cuentaCompleta').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#cuentaCompleta').val();
			listaAlfanumerica('cuentaCompleta', '2', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});
	
	$('#tipoActivoID').bind('keyup', function(e){
		lista('tipoActivoID', '2', '3', 'descripcion', $('#tipoActivoID').val(),'listaTiposActivos.htm');
	});
	
	$('#tipoActivoID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);	
		if(esTab){
			consultaTipoActivo(this.id);
		}
	});
	
	$('#representaActivo').change(function(){
		if($('#representaActivo').val() == 'S'){
			$('#trTipoActivo').show();				
		}else{
			$('#trTipoActivo').hide();	
			$('#tipoActivoID').val(0);	
			$('#descripcionActivo').val('');		
		}
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({	
		rules: {
			tipoGastoID: {
				required: true,
				numeroPositivo: true
			},
			descripcion: {
				required: true,
				maxlength: 100,
				minlength: 5
			},
			cuentaCompleta: {
				required: true,
				numeroPositivo: true,
				maxlength: 25,
				minlength: 1
			},
			cajaChica:{
				required: true
			},
			representaActivo:{
				required: true
			},
			tipoActivoID:{
				required: function() {return $('#representaActivo').val() == 'S';},
			},
			estatus:{
				required: true
			}
		},		
		messages: {
			tipoGastoID: {
				required: 'Especificar No. de Tipo Gasto.',
				numeroPositivo: 'Solo Números'
			},
			
			descripcion: {
				required: 'Especificar Descripción.',
				maxlength: 'maximo 100 caracteres',
				minlength: 'minimo 5 caracteres'
			},
			cuentaCompleta: {
				required: 'Especificar No. de Cuenta Contable.',
				numeroPositivo: 'Solo Números',
				maxlength: 'maximo 25 números',
				minlength: 'minimo 1 número'
			},
			cajaChica: {
				required: 'Especificar Si o No. '
			},
			representaActivo: {
				required: 'Especificar Si o No. '
			},
			tipoActivoID: {
				required: 'Especificar Tipo Activo. '
			},
			estatus: {
				required: 'Especificar Estatus. '
			}
			
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	function validaTipoGas(control) {
		var tipoGas = $('#tipoGastoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoGas != '' && !isNaN(tipoGas)){
			if(tipoGas=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('elimina', 'submit');
				$('#descripcion').val("");
				$('#cuentaCompleta').val("");
				$('#descripcionCuenta').val("");
				$('#cajaChica').val("");
				$('#representaActivo').val("");
				$('#trTipoActivo').hide();
				$('#tipoActivoID').val("");
				$('#descripcionActivo').val("");
				$('#estatus').val("A");
				deshabilitaControl("estatus");
			} else {
				deshabilitaBoton('agrega', 'submit'); 
				habilitaBoton('modifica', 'submit');
				habilitaBoton('elimina', 'submit');
				var tipoGasBeanCon = { 
  					'tipoGastoID':$('#tipoGastoID').val()
				};
				 
				tipoGasServicio.consulta(catTipoConsultaTipoGas.principal,tipoGasBeanCon,function(gastos) {
					if(gastos!=null){	
						$('#descripcion').val(gastos.descripcion);
						$('#cuentaCompleta').val(gastos.cuentaCompleta);
						$('#cajaChica').val(gastos.cajaChica).selected = true;
						if(gastos.cuentaCompleta !=null){
							validaCuentaContable('cuentaCompleta');
						}else{
							$('#descripcionCuenta').val("");																
						}

						$('#representaActivo').val(gastos.representaActivo);
						if(gastos.representaActivo == 'S'){
							$('#tipoActivoID').val(gastos.tipoActivoID);
							consultaTipoActivo('tipoActivoID');
							$('#trTipoActivo').show();				
						}else{
							$('#trTipoActivo').hide();	
							$('#tipoActivoID').val('');	
							$('#descripcionActivo').val('');		
						}
						$('#estatus').val(gastos.estatus);
						
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');
						habilitaBoton('elimina', 'submit');	
						habilitaControl("estatus");
					}else{
						mensajeSis("No Existe el Tipo de Gasto");				
						$('#descripcion').val("");
						$('#cuentaCompleta').val("");	
						$('#descripcionCuenta').val("");
						$('#cajaChica').val("");
						$('#tipoGastoID').focus();
						$('#tipoGastoID').val("");
						$('#tipoGastoID').select();
						$('#representaActivo').val("");
						$('#trTipoActivo').hide();
						$('#tipoActivoID').val("");
						$('#descripcionActivo').val("");
						$('#estatus').val("");
						habilitaControl("estatus");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('elimina', 'submit');
					}
				});
			}
		}
	}
		
	function consultaTipoGas(control) {
		var tipoGas = $('#tipoGastoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoGas != '' ){
			if(tipoGas=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('elimina', 'submit');
				$('#descripcion').val("");
			} else {
				deshabilitaBoton('agrega', 'submit'); 
				habilitaBoton('modifica', 'submit');
				habilitaBoton('elimina', 'submit');
				var tipoGasBeanCon = { 
  					'tipoGastoID':$('#tipoGastoID').val()
				};
				 
				tipoGasServicio.consulta(catTipoConsultaTipoGas.principal,tipoGasBeanCon,function(gastos) {
					if(gastos!=null){	
						$('#descripcion').val(gastos.descripcion);
						$('#cuentaCompleta').val(gastos.cuentaCompleta);
						$('#cajaChica').val(gastos.cajaChica).selected = true;
						
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');
						habilitaBoton('elimina', 'submit');	
							
					}else{
						mensajeSis("No Existe el Tipo de Gasto");
						$('#descripcion').val("");
						$('#cuentaCompleta').val("");
						$('#cajaChica').val("");	
						$('#descripcionCuenta').val("");
						$('#tipoGastoID').focus();
						$('#tipoGastoID').val("");
						$('#tipoGastoID').select();
							
						deshabilitaBoton('modifica', 'submit');
   						deshabilitaBoton('agrega', 'submit');
   						deshabilitaBoton('elimina', 'submit');
					}
				});
			}							
		}
	}
		
	function validaCuentaContable(idControl) {
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();
		var conPrincipal = 1;
		var CtaContableBeanCon = {
				'cuentaCompleta':numCtaContable
		};
		setTimeout("$('#cajaLista').hide();", 200);	
		
		if(numCtaContable != '' && !isNaN(numCtaContable)){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){ 
					$('#descripcionCuenta').val(ctaConta.descripcion); 
					
					if(ctaConta.grupo != 'D') { 
						mensajeSis("La Cuenta Contable no es de Tipo Detalle.");
						$('#cuentaCompleta').focus();
						$('#cuentaCompleta').val("");
						$('#descripcionCuenta').val("");
					
						}
				}
				else{
					mensajeSis("No Existe la Cuenta Contable.");
					$('#descripcionCuenta').val("");
					$('#cuentaCompleta').focus();
					$('#cuentaCompleta').val("");
				}
			}); 																					
		}
	}
	
	//FUNCIÓN CONSULTA LOS DATOS DEL TIPO DE ACTIVO
	function consultaTipoActivo(idControl) {
		var jqNumero = eval("'#" + idControl + "'");
		var tipoActivoID = $(jqNumero).val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		var numCon=1;
		var BeanCon = {
				'tipoActivoID':tipoActivoID 
			};	
		
		if(tipoActivoID != '' && !isNaN(tipoActivoID) && tipoActivoID > 0){
			tiposActivosServicio.consulta(numCon,BeanCon,function(tipoActivoBean) { 
				if(tipoActivoBean!=null){
					$('#descripcionActivo').val(tipoActivoBean.descripcion);
				}else{
					$(jqNumero).val('');
					$('#descripcionActivo').val('');				
					$(jqNumero).focus();
					mensajeSis('No Existe el Tipo de Activo');
				}
			});
		}else{
			if(isNaN(tipoActivoID)){
				$(jqNumero).val('');	
				$('#descripcionActivo').val('');				
				$(jqNumero).focus();
				mensajeSis('No Existe el Tipo de Activo');	
			}else{
				if(tipoActivoID == '' || tipoActivoID == 0){
					$(jqNumero).val('');	
					$('#descripcionActivo').val('');						
				}
			}
		}
	}

}); // DOCUMENT READY FIN


//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	inicializaForma('formaGenerica','tipoGastoID');
	$('#cajaChica').val("");
	$('#representaActivo').val("");
	$('#trTipoActivo').hide();
	$('#tipoActivoID').val("");
	$('#descripcionActivo').val("");
	$('#estatus').val("");
	habilitaControl("estatus");
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
} 

function validaVacioCuentaContable(){
	if($('#cuentaCompleta').val() == '' || isNaN($('#cuentaCompleta').val())){
		mensajeSis("El registro de Tipo de Gasto no se ha completado.");
		$('#cuentaCompleta').focus();
		$('#cuentaCompleta').val("");
		$('#descripcionCuenta').val("");
	}
}