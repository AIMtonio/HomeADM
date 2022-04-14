$(document).ready(function() {
	
	$("#impuestoID").focus();
	
	esTab = true;

	//Definicion de Constantes y Enums  
	var catTipoTransaccionImpuesto= {  
			'agrega':'1',
			'modifica':'2'};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#gravaRetiene').val("");
	$('#baseCalculoI').attr('checked',false);
	$('#baseCalculoS').attr('checked',false);
	$('#lblImpuestoCalculo').hide();
	$('#impuestoCalculo').hide();
	habilitaControl('baseCalculoI');
	habilitaControl('baseCalculoS');
	habilitaControl('gravaRetiene');

	consultaCalculoImpuesto();	
	



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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','impuestoID','funcionExito','funcionFallo');
		}
	});	



	$('#impuestoID').bind('keyup',function(e) {	
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "impuestoID";
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#impuestoID').val();
			listaAlfanumerica('impuestoID', '1', '1', camposLista, parametrosLista, 'listaImpuestos.htm');
		}
	});

	$('#impuestoID').blur(function() {
		if($('#impuestoID').val()!="" && esTab == true){
			validaImpuesto('impuestoID');
		}		   
	});
	
	$('#baseCalculoS').change(function(){	
		if ($('#baseCalculoS').is(':checked')){
			$('#lblImpuestoCalculo').hide();
			$('#impuestoCalculo').hide();
			$('#impuestoCalculo').val();	
		}
	});
		
		$('#baseCalculoI').change(function(){	
			if ($('#baseCalculoI').is(':checked')){
				$('#lblImpuestoCalculo').show();
				$('#impuestoCalculo').show();
				consultaCalculoImpuesto();
			}
		});
	


	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionImpuesto.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionImpuesto.modifica);
	});	

	$('#ctaEnTransito').blur(function() {
		if($('#ctaEnTransito').val()!=""){
			validaCuentaContableEnTransito('ctaEnTransito');
		}
		else{
			$('#descripcionCuenta').val('');
		}
	});

	$('#ctaEnTransito').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaEnTransito').val();
			listaAlfanumerica('ctaEnTransito', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});
	
	
	$('#ctaRealizado').blur(function() {
		if($('#ctaRealizado').val()!=""){
			validaCuentaContableRealizado('ctaRealizado');
		}
		else{
			$('#descripcionCuentaRealizado').val('');
		}
	});

	$('#ctaRealizado').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaRealizado').val();
			listaAlfanumerica('ctaRealizado', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});
	
	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules: {
			impuestoID:{
				required: true	
			},
			descripcion: {
				required: true,
				maxlength: 70
			},
			descripCorta: {
				required: true,
				maxlength: 10
			},
			tasa: {
				required: true,
				numeroPositivo : true
			},
			gravaRetiene: {
				required: true
			},
			baseCalculo: {
				required: true
			},
			impuestoCalculo: {
				required : function(){return $('#baseCalculoI').is(':checked');}
			},
			ctaEnTransito: {
				required: true,
				maxlength: 25
			},
			ctaRealizado: {
				required: true,
				maxlength: 25
			}
			
		},		
		messages: {		
			impuestoID: {
				required: 'Específique el Impuesto'
			},
			descripcion: {
				required: 'Específique la descripción del Impuesto',
				maxlength : 'Máximo 70 caracteres'
			},
			descripCorta: {
				required: 'Específique el Nombre del Impuesto',
				maxlength: 'Máximo 10 caracteres'
			},
			tasa: {
				required: 'Específique la Tasa del Impuesto',
				numeroPositivo: 'Solo Números'
			},
			gravaRetiene: {
				required: 'Específique el Tipo de Impuesto'
			},
			baseCalculo: {
				required: 'Específique la Base para el Cálculo '
			},
			impuestoCalculo: {
				required: 'Específique el Impuesto para el Cálculo '
			},
			ctaEnTransito: {
				required : 'Específique Cuenta Contable',
				maxlength: 'Máximo 25 caracteres'
			},
			ctaRealizado: {
				required : 'Específique Cuenta Contable',
				maxlength: 'Máximo 25 caracteres'
			}
		}		
	});



	//------------ Validaciones de Controles -------------------------------------


	function validaImpuesto(control) {
		var numImpuesto = $('#impuestoID').val();

		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if(numImpuesto != '' && !isNaN(numImpuesto) && esTab){
			if(numImpuesto=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','impuestoID' );
				$('#descripcion').val('');
				$('#descripCorta').val('');
				$('#tasa').val('');
				$('#gravaRetiene').val('').selected = true;
				$('#impuestoCalculo').val('').selected = true;
				$('#descripcionCuenta').val('');
				$('#descripcionCuentaRealizado').val('');
				$('#baseCalculoI').attr('checked',false);
				$('#baseCalculoS').attr('checked',false);
				$('#lblImpuestoCalculo').hide();
				$('#impuestoCalculo').hide();
				$('#impuestoCalculo').val();
				habilitaControl('baseCalculoI');
				habilitaControl('baseCalculoS');
				habilitaControl('gravaRetiene');

			} else {
				deshabilitaBoton('agrega', 'submit'); 
				habilitaBoton('modifica', 'submit');
				var conImpuestos = 3;
				var ImpuestosCon = {
						'impuestoID': numImpuesto
				};
				//////////consulta de tipo proveedores/////////////////////////////			 
				impuestoServicio.consulta(conImpuestos,ImpuestosCon,function(impuestos) {
					if(impuestos!=null){
						dwr.util.setValues(impuestos);
						$('#descripcion').val(impuestos.descripcion);
						$('#descripCorta').val(impuestos.descripCorta);
						$('#tasa').val(impuestos.tasa);
						$('#tasa').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});
						
						$('#gravaRetiene').val(impuestos.gravaRetiene).selected = true;
						
					
						if(impuestos.baseCalculo=='S'){
							$('#baseCalculoS').attr('checked','checked');
							$('#lblImpuestoCalculo').hide();
							$('#impuestoCalculo').hide();
							$('#impuestoCalculo').val();	
						}
						else if(impuestos.baseCalculo=='I') {
							$('#baseCalculoI').attr('checked','checked');
							$('#lblImpuestoCalculo').show();
							$('#impuestoCalculo').show();
							
						$('#impuestoCalculo').val(impuestos.impuestoCalculo).selected = true;
							
						}
						
						
						esTab = true;
						validaCuentaContableEnTransito('ctaEnTransito');
						validaCuentaContableRealizado('ctaRealizado');
						
						habilitaControl('baseCalculoI');
						habilitaControl('baseCalculoS');
						habilitaControl('gravaRetiene');
						
					}else{
						mensajeSis("No Existe el Impuesto");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						inicializaForma('formaGenerica','impuestoID' );
						$('#descripcion').val('');
						$('#descripCorta').val('');
						$('#tasa').val('');
						$('#gravaRetiene').val('').selected = true;
						$('#descripcionCuenta').val('');
						$('#descripcionCuentaRealizado').val('');
						$('#impuestoID').focus();
						$('#impuestoID').select();
						$('#impuestoID').val('');
						$('#baseCalculoI').attr('checked',false);
						$('#baseCalculoS').attr('checked',false);
						$('#lblImpuestoCalculo').hide();
						$('#impuestoCalculo').hide();
						$('#impuestoCalculo').val();
						deshabilitaControl('baseCalculoI');
						deshabilitaControl('baseCalculoS');
						habilitaControl('gravaRetiene');

					}
				});
				
			}

		}
	}
	
	

	function consultaCalculoImpuesto() {			
		dwr.util.removeAllOptions('impuestoCalculo'); 
		dwr.util.addOptions('impuestoCalculo', {"":'SELECCIONAR'});
		impuestoServicio.listaCombo(3, function(impuestos){
		dwr.util.addOptions('impuestoCalculo', impuestos, 'impuestoID', 'descripCorta');
		});
	}
	
	

	function validaCuentaContableEnTransito(idControl) {
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();
		var conPrincipal = 1;
		var CtaContableBeanCon = {
				'cuentaCompleta':numCtaContable
		};
		
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaContable != '' && !isNaN(numCtaContable) && esTab){  
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){
					if(ctaConta.grupo != "E"){
						$('#descripcionCuenta').val(ctaConta.descripcion);
					}else{
						mensajeSis("Sólo Cuentas Contables De Detalle");
						$('#ctaEnTransito').focus();
						$('#ctaEnTransito').val("");
						$('#descripcionCuenta').val("");
					}
				}
				else{
					mensajeSis("La Cuenta Contable no Existe.");
					$('#ctaEnTransito').focus(); 
					$('#ctaEnTransito').val(""); 
					$('#descripcionCuenta').val("");
				}
			}); 																					
		}else{
			$('#descripcionCuenta').val("");
		}
	}
	
	function validaCuentaContableRealizado(idControl) {
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();
		var conPrincipal = 1;
		var CtaContableBeanCon = {
				'cuentaCompleta':numCtaContable
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaContable != '' && !isNaN(numCtaContable) && esTab ){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){
					if(ctaConta.grupo != "E"){
						$('#descripcionCuentaRealizado').val(ctaConta.descripcion);
					}else{
						mensajeSis("Sólo Cuentas Contables De Detalle");
						$('#ctaRealizado').val("");
						$('#ctaRealizado').focus(); 
						$('#descripcionCuentaRealizado').val("");
					}		
				}
				else{
					mensajeSis("La Cuenta Contable no Existe.");
					$('#ctaRealizado').val("");
					$('#ctaRealizado').focus(); 
					$('#descripcionCuentaRealizado').val("");
				}
			}); 																					
		}else{
			$('#descripcionCuentaRealizado').val("");
		}
	}
	
		
});


function funcionExito() {
	inicializaForma('formaGenerica', 'impuestoID');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#gravaRetiene').val("");
	$('#baseCalculoI').attr('checked',false);
	$('#baseCalculoS').attr('checked',false);
	$('#lblImpuestoCalculo').hide();
	$('#impuestoCalculo').hide();
	$('#impuestoCalculo').val();
	habilitaControl('baseCalculoI');
	habilitaControl('baseCalculoS');
	habilitaControl('gravaRetiene');
	$("#impuestoID").focus();
}

function funcionFallo() {
}

