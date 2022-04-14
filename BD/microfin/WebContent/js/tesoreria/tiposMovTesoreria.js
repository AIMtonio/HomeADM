$(document).ready(function() {
	$('#tipoMovTesoID').focus();
	var catTipoTransaccion = {
			'agrega':'1',
			'modifica':'2'
	};	

	var catTipoConsulta  = {
			'principal':1
	};

	var catTipoLista = {
			'principal':1
	};	


	/*POST*/

	$.validator.setDefaults({


		submitHandler: function(event) { 

			if( $('#naturaContable').val() =='' ){
				mensajeSis("No ha seleccionado la Naturaleza Contable.");
			}
			else{
				grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'tipoMovTesoID');
				$('#descripcionCta').val('');
			}

		}

	});	

	/*INICIALIZACIONES*/		
	// $('#trCtaContable').hide();
	deshabilitaBoton('agrega');
	deshabilitaBoton('modifica');


	//LISTAS
	$('#cuentaContable').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#cuentaContable').val();
			listaAlfanumerica('cuentaContable', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 


	$('#tipoMovTesoID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#tipoMovTesoID').val();
			listaAlfanumerica('tipoMovTesoID', '1', '1', camposLista, parametrosLista, 'listaTiposMovTesoreria.htm');
		}
	}); 

	// FIN LISTAS

	// EVENTOS 

	$('#cuentaContable').blur(function() {
		if($('#cuentaContable').val()!=""){
			validaCuentaContable('cuentaContable');
		}
		else{
			$('#cuentaContable').val(""); 
			$('#descripcionCta').val("");
			$('#cuentaMayor').val("");

		}

	});

	$('#tipoMovTesoID').blur(function() {
		if($('#tipoMovTesoID').val()!=""){
			validaConcepto('tipoMovTesoID');
		}  		    
	});

	$('#agrega').click(function() {
		validaVacioCuentaContable(catTipoTransaccion.agrega);
	});

	$('#modifica').click(function() {
		validaVacioCuentaContable(catTipoTransaccion.modifica);
	});

	//RADIOS
	$('#naturaContableCargo').click(function() {	
		if(document.getElementById('naturaContableCargo').checked){
			$('#naturaContable').val("C");//C= Cargo
		}			
	});		
	$('#naturaContableAbono').click(function() {	

		if(document.getElementById('naturaContableAbono').checked){
			$('#naturaContable').val("A");//A= Abono
		}			
	});		

	$('#cuentaEditableChek').click(function() {	
		if(document.getElementById('cuentaEditableChek').checked){
			$('#cuentaEditable').val("S");//S= Si

		}	
		else{
			$('#cuentaEditable').val("N");//N= No
		}

	});	
	//FIN EVENTOS


	/*    FUNCIONES / CONSULTAS */


	function validaCuentaContable(idControl) { 
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();
		var conPrincipal = 1;
		var CtaContableBeanCon = {
				'cuentaCompleta':numCtaContable
		};

		setTimeout("$('#cajaLista').hide();", 200);



		if(numCtaContable != '' && !isNaN(numCtaContable) ){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){
					if(ctaConta.grupo != "E"){
						$('#descripcionCta').val(ctaConta.descripcion);
					}else{
						mensajeSis("Sólo Cuentas Contables De Detalle");
						$('#cuentaContable').val("");
						$('#cuentaContable').focus(); 
						$('#descripcionCta').val("");
					}
				} 
				else{
					mensajeSis("No Existe la Cuenta Contable.");

					$('#cuentaContable').val(""); 
					$('#descripcionCta').val("");
				}
			}); 

		}  
	}


	function validaConcepto(idControl) { 
		var jqCtaConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqCtaConcepto).val();
		var tipoConciliado= 'C';
		var tesoMovTipoBean = {
				'tipoMovTesoID':numConcepto,
				'tipoMovimiento':tipoConciliado
		};

		setTimeout("$('#cajaLista').hide();", 200);

		if(numConcepto != '' && !isNaN(numConcepto) && numConcepto==0){
			habilitaBoton('agrega');
			deshabilitaBoton('modifica');
			limpiaFormulario();
		}
		else{
			if(numConcepto != '' && !isNaN(numConcepto) ){
				TiposMovTesoServicioScript.conTiposMovTeso(catTipoConsulta.principal,tesoMovTipoBean,function(tipoBean){
					if(tipoBean!=null){ 
						dwr.util.setValues(tipoBean);	
						validaCuentaContable('cuentaContable');

						$('#cuentaEditable').val(tipoBean.cuentaEditable);
						if(tipoBean.cuentaEditable=='S'){
							$('#cuentaEditableChek').attr('checked',true);

						}	
						if(tipoBean.cuentaEditable=='N'){
							$('#cuentaEditableChek').removeAttr('checked');
						}

						if(tipoBean.naturaContable=='C'){
							$('#naturaContableCargo').attr('checked',true);
						}
						if(tipoBean.naturaContable=='A'){
							$('#naturaContableAbono').attr('checked',true);
						}
						habilitaBoton('modifica');
						deshabilitaBoton('agrega');
					} 
					else{
						mensajeSis("No Existe el Tipo de Movimiento.");

						$('#tipoMovTesoID').val("");
						limpiaFormulario();
						//function limpiapantalla
					}
				}); 

			}else{
				mensajeSis("No Existe el Tipo de Movimiento.");
				$('#tipoMovTesoID').val("");
				limpiaFormulario();
			}  

		}	
	}


	function limpiaFormulario(){
		$('#descripcion').val('');
		$('#cuentaContable').val('');
		$('#cuentaMayor').val('');
		$('#descripcionCta').val('');
		$('#cuentaEditableChek').removeAttr('checked');
		$('#cuentaEditable').val("N");
		$('#naturaContableAbono').removeAttr('checked');
		$('#naturaContableCargo').removeAttr('checked');
		$('#naturaContable').val('');
	}
	/*FIN FUNCIONES/CONSULTAS*/


	/* VALIDACIONES */

	$('#formaGenerica').validate({
		rules: {
			tipoMovTesoID: {
				required: true
			},

			descripcion:{
				required: true			 
			},		

			cuentaContable : {
				required : function() {return $('#cuentaEditable').val() == 'S';},
			},


		},

		messages: {
			tipoMovTesoID: {
				required: "El concepto es requerido"
			},

			descripcion:{
				required: "La descripcion es requerida"			 
			},		
			cuentaContable:{
				required: "La cuenta contable es requerida"
			},
		}		
	});


});


function validaVacioCuentaContable(tipoTransaccion){
	if($('#cuentaContable').val() == '' || isNaN($('#cuentaContable').val())){
		mensajeSis("El registro de Tipo de Movimiento no se ha completado.");
		$('#cuentaContable').focus();
		$('#cuentaContable').val("");
		$('#descripcionCta').val("");
		}
		else{
			$('#tipoTransaccion').val(tipoTransaccion);
		}
}

