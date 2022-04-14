var esTab;
var tab2 = false;
$(document).ready(function() {
	$('#iva').focus();
	consultaImpuestos();

	esTab = true;

	
	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	//Definicion de Constantes y Enums  
	var tipoTransaccion = {  
			'modificar':'1'
	};

	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoProveedorID','funcionExitoImpuestos','funcionErrorImpuestos');
			
		}
	});	

	
	$('#modificar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.modificar);
	});
	
	$('#iva').bind('keyup',function(e) {	
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "impuestoID";
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#iva').val();
			listaAlfanumerica('iva', '1', '1', camposLista, parametrosLista, 'listaImpuestos.htm');
		}
	});

	$('#retIVA').bind('keyup',function(e) {	
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "impuestoID";
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#retIVA').val();
			listaAlfanumerica('retIVA', '1', '1', camposLista, parametrosLista, 'listaImpuestos.htm');
		}
	});

	$('#iva').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
				
		if (isNaN($('#iva').val())) { 			
			$('#iva').val("");
			$('#iva').focus();
			tab2 = false;
		} else {
			if ($('#iva').asNumber()==0 && esTab) {		
				$('#descripIVA').val("");
						
			}else{
				if (tab2 == false  && esTab) { 
					validaIVA('iva');
					
				}

			}
		}
	});

	$('#retIVA').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
				
		if (isNaN($('#retIVA').val())) { 			
			$('#retIVA').val("");
			$('#retIVA').focus();
			tab2 = false;
		} else {
			if ($('#retIVA').asNumber()==0 && esTab) {		
				$('#descripRetIVA').val("");
						
			}else{
				if (tab2 == false && esTab) { 
					esTab = true;
					validaRetIVA('retIVA');
					
				}

			}
		}
	});


	
	
	//------------ Validaciones de la Forma -------------------------------------
  	
	$('#formaGenerica').validate({

		rules: {
			
		},		
		messages: {		
			

		}		
	});
});

	function validaIVA(control) {
		var TipoConsulta = 3;
		var jq = eval("'#" + control + "'");
		var numImpuesto = $(jq).val();
		var ImpuestosCon = {
				'impuestoID': numImpuesto
		};
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
	
		if(numImpuesto != 0){
			if(numImpuesto != '' && !isNaN(numImpuesto)&& esTab){
			impuestoServicio.consulta(TipoConsulta,ImpuestosCon,function(impuestos) {
					if(impuestos!=null){
						$('#descripIVA').val(impuestos.descripCorta);
						habilitaBoton('modificar', 'submit');
						
					}else{

						mensajeSisRetro({
						mensajeAlert : 'No Existe el Impuesto',
						muestraBtnAceptar: true,
						muestraBtnCancela: false,
						txtAceptar : 'Aceptar',
						txtCancelar : 'Cancelar',
						txtCabecera:  'Mensaje:',
						funcionAceptar : limpiaCamposIVA,
						funcionCerrar : limpiaCamposIVA
					});
						
						
						
					}

				});
			}
		}
		else{
			$('#descripIVA').val('');
		}
		
	}

	function limpiaCamposIVA(){
				$('#descripIVA').val("");
				$('#iva').val("");
				$('#iva').focus();
				deshabilitaBoton('modificar', 'submit');
	}


	function validaRetIVA(control) {
		var TipoConsulta = 3;
		var jq = eval("'#" + control + "'");
		var numImpuesto = $(jq).val();
		var ImpuestosCon = {
				'impuestoID': numImpuesto
		};
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;

		if(numImpuesto != 0){
			if(numImpuesto != '' && !isNaN(numImpuesto)&& esTab){
				impuestoServicio.consulta(TipoConsulta,ImpuestosCon,function(impuestos) {
						if(impuestos!=null){
							$('#descripRetIVA').val(impuestos.descripCorta);
							habilitaBoton('modificar', 'submit');
							
						}else{
							mensajeSisRetro({
								mensajeAlert : 'No Existe el Impuesto',
								muestraBtnAceptar: true,
								muestraBtnCancela: false,
								txtAceptar : 'Aceptar',
								txtCancelar : 'Cancelar',
								funcionAceptar :limpiaCamposRetIVA,
								funcionCerrar : limpiaCamposRetIVA
							});
							
							
						}

					});
				}
		}
		else{
			$('#descripRetIVA').val('');
		}
	}
	
	function limpiaCamposRetIVA(){
				$('#retIVA').val("");
				$('#retIVA').focus();
				deshabilitaBoton('modificar', 'submit');
	}

	
	function consultaImpuestos() {
		var conPrincipal = 1;			
		parametrosDIOTServicio.consulta(conPrincipal,function(impuestos) {
			if(impuestos!=null){
				$('#iva').val(impuestos.iva);
				validaIVA('iva');
				$('#retIVA').val(impuestos.retIVA);
				validaRetIVA('retIVA');
				habilitaBoton('modificar','submit');
			}else{

				mensajeSis("No Existe el Impuesto");
				$('#iva').val('');
				$('#descripIVA').val('');
				$('#retIVA').val('');	
				$('#descripRetIVA').val('');
				deshabilitaBoton('modificar','submit');
			}
		});
		
	}
	
	function funcionExitoImpuestos (){
		consultaImpuestos();
		$('#iva').focus();

	}
	
	function funcionErrorImpuestos(){
		
	}
	
	

	
