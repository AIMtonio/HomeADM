var catTipoConsultaCredito = {
	'principal' : 1
};

$(document).ready(function() {
	esTab = false;
	parametros = consultaParametrosSession();
	$('#solicitudCreditoID').focus();

	// Declaración de constantes 
	var catTipoConsultaSolicitud = {
		'principal' : 1
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agregar', 'submit');

	$(':text').focus(function() {
		esTab = false;
	});
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$(':text').focus(function() {
		esTab = false;
	});


	$.validator.setDefaults({
		submitHandler : function(event) {
		consultaEsriesgo();

			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'SolicitudCreditoID', 'funcionExito', 'funcionError');
		}
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	
	$('#prospectoID').bind('keyup', function(e) {
		lista('prospectoID', '1', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
	});

	$('#prospectoID').blur(function() {
		if ($('#prospectoID').asNumber() > 0 && $.trim($('#prospectoID').val()) != "" && esTab == true) {
			consultaProspecto(this.id);
		} else {
			$('#prospectoID').val(0);
			$('#nombreProspecto').val('TODOS');
		}
	});

	$('#solicitudCreditoID').bind('keyup', function(e) {
		if (this.value.length >= 0) {
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#solicitudCreditoID').val();

			lista('solicitudCreditoID', '1', '15', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}
	});

	$('#solicitudCreditoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if (esTab) {
			if ($('#solicitudCreditoID').val() == 0) {
				mensajeSis("Ingrese Número de Solicitud");
				$('#solicitudCreditoID').focus();
			} else {
				validaSolicitudCredito(this.id);
			}
		}
	});

	$('#agregar').click(function() {		
		var numero = 1;
		$('#tipoTransaccion').val(numero);	
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
	rules : {
		solicitudCreditoID : 'required',
	},
	messages : {
		solicitudCreditoID : 'Especifique el Número de Solicitud.',
	}
	});

	//------------ Validaciones de Controles -------------------------------------

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 23;
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			clienteServicio.consulta(tipConForanea, numCliente, function(cliente) {
				if (cliente != null) {
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#prospectoID').val('0');
					$('#nombreProspecto').val('TODOS');
				} else {
					clienteexiste = 1;
					mensajeSis("No Existe el " + $('#alertSocio').val() + ".");
					$('#clienteID').val('0');
					$('#nombreCliente').val('TODOS');
					$('#prospectoID').val('0');
					$('#nombreProspecto').val('TODOS');
				}
			});
		}
	}


	// ------------ Validaciones de Controles-------------------------------------
		
	function consultaProspecto(idControl) {
	
		var jqProspecto = eval("'#" + idControl + "'");
		var numProspecto = $(jqProspecto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProspecto != '' && !isNaN(numProspecto) && esTab){	
			deshabilitaBoton('agrega', 'submit');
			habilitaBoton('modifica', 'submit');
			var prospectoBeanCon ={
		 		 	'prospectoID' : numProspecto 
			};		
			prospectosServicio.consulta(catTipoConsultaProspec.principal,prospectoBeanCon,function(prospectos) {
				if(prospectos!=null){		
					$('#prospectoID').val(prospectos.prospectoID);
					$('#nombreProspecto').val(prospectos.nombreCompleto);			
								
				}else{
					mensajeSis("No Existe el Prospecto");
					$('#prospectoID').val("0");
					$('#nombreProspecto').val("");
					$('#numero').val("0");
					validaCliente('numero',	$('#prospectoID').val());
				}	
			});			
		}
	} 


});

//Función muestra en el grid  el listado de los creditos de acuerdo a la búsqueda 
function consultaGridRiesgos() {
	var params = {};
	params['tipoLista'] = 1;
	params['solicitudCreditoID'] = $('#solicitudCreditoID').val();

	$.post("riesgoComunGridVista.htm", params, function(data) {
		if (data.length > 0) {
			bloquearPantallaCarga();
			$('#divGridTiposRespuesta').html(data);
			$('#divGridTiposRespuesta').show();
			$('#fieldsetLisSol').show();

			var numFilas = consultaFilas();
			if (numFilas == 0) {

				$('#divGridTiposRespuesta').html("");
				$('#divGridTiposRespuesta').hide();
				$('#fieldsetLisSol').hide();
				mensajeSis('No se Encontraron Coincidencias');
				$('#solicitudCreditoID').focus();
			} else {
				habilitaBoton('agregar', 'submit');
				consultaEsriesgo();
			}
			$('#contenedorForma').unblock(); // desbloquear
		} else {
			$('#divGridTiposRespuesta').html("");
			$('#divGridTiposRespuesta').hide();
			$('#fieldsetLisSol').hide();
			mensajeSis('No se Encontraron Coincidencias');
		}

	});
}

//Función consulta el total de creditos en la lista
function consultaFilas() {
	var totales = 0;
	$('tr[name=renglons]').each(function() {
		totales++;

	});
	return totales;
}

//funcion que bloquea la pantalla mientras se cargan los datos
function bloquearPantallaCarga() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
	message : $('#mensaje'),
	css : {
	border : 'none',
	background : 'none'
	}
	});

}

// VALIDA SOLICITUD DE CREDITO
function validaSolicitudCredito(control) {
	var numCredito = $('#solicitudCreditoID').val();
	var perfilAnalistaDeCred = 12;
	setTimeout("$('#cajaLista').hide();", 200);

	if (numCredito != '' && !isNaN(numCredito)) {
		if (numCredito == '0') {
		} else {
			var creditoBeanCon = {
				'solicitudCreditoID' : $('#solicitudCreditoID').val()
			};

			solicitudCredServicio.consulta(catTipoConsultaCredito.principal, creditoBeanCon, {
			async : false,
			callback : function(credito) {
				if (credito != null) {

					if(credito.clienteID == 0){
						$('#nombreCliente').val(credito.nombreCompletoProspecto);
						$('#clienteID').val(credito.prospectoID);
						$('#LblCliente').text('Prospecto:');
					}
					else{
						$('#nombreCliente').val(credito.nombreCompletoCliente);
						$('#clienteID').val(credito.clienteID);
						$('#LblCliente').text('Cliente:');
					}
					
					consultaGridRiesgos();

				} else {
					mensajeSis("No Existe la Solicitud de  Credito");
					$('#divGridTiposRespuesta').html("");
					$('#divGridTiposRespuesta').hide();
					$('#fieldsetLisSol').hide();
					$('#clienteID').val("");
					$('#nombreCliente').val("");
					$('#solicitudCreditoID').val('');
					$('#solicitudCreditoID').focus();

					deshabilitaBoton('agregar', 'submit');

				}
			}
			});
		}
	}
}

function consultaEsriesgo() {
	$("input[name=lisEsRiesgo]").each(function(i) {
		var numero = this.id.replace(/\D/g,'');	
		var jqIdChecked = eval("'esRiesgo" + numero + "'");
		var esRiesgoComunR = document.getElementById(jqIdChecked).value;
		if (esRiesgoComunR == 'S') {
			$('#riesgoSI' + numero).attr('checked', 'true');
			$('#esRiesgo' + numero).val('S');
		} else {
			$('#riesgoNO' + numero).attr('checked', 'false');
			$('#esRiesgo' + numero).val('N');
		}
	});
}


function seleccionaSI(idControl){
	var numero = idControl.replace(/\D/g,'');	
	var jqEsRiesgo  = eval("'#esRiesgo" + numero + "'");
	$(jqEsRiesgo).val("S");		
}

function seleccionaNO(idControl){
	var numero = idControl.replace(/\D/g,'');	
	var jqEsRiesgo  = eval("'#esRiesgo" + numero + "'");
	$(jqEsRiesgo).val("N");	
}



function generaSeccion(pageValor) {
	
		var params = {};
		params['tipoLista'] = 1;
		params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
		params['page'] = pageValor;	

		$.post("riesgoComunGridVista.htm", params, function(data){		
			if (data.length > 0) {
				bloquearPantallaCarga();
				$('#divGridTiposRespuesta').html(data);
				$('#divGridTiposRespuesta').show();
				$('#fieldsetLisSol').show();

				var numFilas = consultaFilas();
				if (numFilas == 0) {

					$('#divGridTiposRespuesta').html("");
					$('#divGridTiposRespuesta').hide();
					$('#fieldsetLisSol').hide();
					mensajeSis('No se Encontraron Coincidencias');
					$('#solicitudCreditoID').focus();
				} else {
					habilitaBoton('agregar', 'submit');
					consultaEsriesgo();
				}
				$('#contenedorForma').unblock(); // desbloquear
			} else {
				$('#divGridTiposRespuesta').html("");
				$('#divGridTiposRespuesta').hide();
				$('#fieldsetLisSol').hide();
				mensajeSis('No se Encontraron Coincidencias');
			}
		});
	

}


function funcionExito(){

}

function funcionError(){
	
}