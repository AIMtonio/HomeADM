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
	deshabilitaBoton('agregar', 'submit');
	consultaSaldos();
	consultaGridRiesgos();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	

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

	
	$('#agregar').click(function() {		
		var numero = 2;
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
});

//Función muestra en el grid  el listado de los creditos de acuerdo a la búsqueda 
function consultaGridRiesgos() {
	var params = {};
	params['tipoLista'] = 2;
	params['solicitudCreditoID'] = 1148;

	$.post("monitorRiesgoComunGridVista.htm", params, function(data) {
		if (data.length > 0) {
			bloquearPantallaCarga();
			$('#divGridSolRiesgos').html(data);

			var numFilas = consultaFilas();
			if (numFilas == 0) {
				agregaNuevoDetalle();

			} else {
				consultaEsriesgo();
				consultaEsProcesado();
				consultaEstatus();
				agregaFormatoMonedaMonto();
				habilitaBoton('agregar', 'submit');
			}
			$('#contenedorForma').unblock(); // desbloquear
			var options = new GridViewScrollOptions();
			options.elementID = "gvMain";
			var tama=$(window).width();
			if(tama>300){
			tama=tama-300;
			}
			options.width = tama;
			options.height = 500;
			options.freezeColumn = true;
			options.freezeFooter = true;
			options.freezeColumnCssClass = "GridViewScrollItemFreeze";
			options.freezeColumnCount = 1;

			gridViewScroll = new GridViewScroll(options);
			gridViewScroll.enhance();
		} else {
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
					$('#clienteID').val(credito.clienteID);
					$('#nombreCliente').val(credito.nombreCompletoCliente);
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


function consultaEsProcesado() {
	$("input[name=lisProcesado]").each(function(i) {
		var numero = this.id.replace(/\D/g,'');	
		var jqIdChecked = eval("'procesado" + numero + "'");
		var esRiesgoComunR = document.getElementById(jqIdChecked).value;
		
		if (esRiesgoComunR == 'S') {
			$('#checkProc' + numero).attr('checked', 'true');
			$('#procesado' + numero).val('S');
		} else {
			$('#procesado' + numero).val('N');
		}
	});
}

function agregaFormatoMonedaMonto() {
	$("input[name=lisMontoAcumulado]").each(function(i) {
		var numero = this.id.replace(/\D/g,'');	
		var jqIdChecked = eval("'montoAcumulado" + numero + "'");
		agregaFormatoMonedaGrid(jqIdChecked);
	});
}

function consultaEstatus() {
	$("input[name=lisEstatus]").each(function(i) {
		var numero = this.id.replace(/\D/g,'');	
		var jqIdChecked = eval("'estatus" + numero + "'");
		var esRiesgoComunR = document.getElementById(jqIdChecked).value;
		
		if (esRiesgoComunR == 'R') {
			$('#estatusDes' + numero).val('REVISADO');
		} else {
			$('#estatusDes' + numero).val('PENDIENTE');
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

//Función que al dar click en un check de la lista de creditos asigna valor si es seleccionado o no
function verificaProcesado(control){	
	var numero = control.replace(/\D/g,'');
	var  si='S';
	var no='N';
	if($('#'+control).attr('checked')==true){
		document.getElementById(control).value = si;	
		$('#procesado' + numero).val('S');	
	}else{
		document.getElementById(control).value = no;
		$('#procesado' + numero).val('N');	
	}
		
}

// FUNCION AGREGA FILA EN EL GRID DE GARANTIAS
function agregaNuevoDetalle(){

	var numeroFila = 0;
	var nuevaFila = parseInt(numeroFila) + 1;		

	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon" align="center">';	
	tds += '<td colspan="11"><input type="text" id="creditoID'+nuevaFila+'" name="creditoID" readOnly="true" disabled="true" size="145"  style="text-align:center" value="No se encontraron resultados" autocomplete="off" /></td>';
	tds += '</tr>';	

	$("#miTabla").append(tds);
	agregaFormatoControles('formaGenerica');

	
	return false;		
}	

function generaSeccion(pageValor) {
	
	var params = {};
	params['tipoLista'] = 2;
	params['solicitudCreditoID'] = 0;
	params['page'] = pageValor;	

	$.post("monitorRiesgoComunGridVista.htm", params, function(data) {
		if (data.length > 0) {
			bloquearPantallaCarga();
			$('#divGridSolRiesgos').html(data);

			var numFilas = consultaFilas();
			if (numFilas == 0) {
				agregaNuevoDetalle();
				deshabilitaBoton('agregar', 'submit');

			} else {
				consultaEsriesgo();
				consultaEsProcesado();

				habilitaBoton('agregar', 'submit');
			}
			$('#contenedorForma').unblock(); // desbloquear
			var options = new GridViewScrollOptions();
			options.elementID = "gvMain";
			var tama=$(window).width();
			if(tama>300){
			tama=tama-300;
			}
			options.width = tama;
			options.height = 500;
			options.freezeColumn = true;
			options.freezeFooter = true;
			options.freezeColumnCssClass = "GridViewScrollItemFreeze";
			options.freezeColumnCount = 1;

			gridViewScroll = new GridViewScroll(options);
			gridViewScroll.enhance();
		} else {
			mensajeSis('No se Encontraron Coincidencias');
		}

	});


}


function seleccionaTodas(){

	if( $('#selecTodas').is(":checked") ){
	   	$('input[name=checkProc]').each(function() {
	   	var control = (this.id);
	   	var numero = control.replace(/\D/g,'');
		$('#'+this.id).attr('checked', true);
		$('#procesado' + numero).val('S');	
		});
	 }else{

		   	$('input[name=checkProc]').each(function() {
		   		var control = (this.id);
	   	var numero = control.replace(/\D/g,'');
			$('#'+this.id).attr('checked', false);
			$('#'+this.id).val('N');
			$('#procesado' + numero).val('N');	
			});
   	}
			
			
}


function consultaSaldos(){
		
		var tipoConDes = 36;	
		var creditoBeanCon = {
				'creditoID' : 1
			};
		setTimeout("$('#cajaLista').hide();", 200);		
			creditosServicio.consulta(tipoConDes, creditoBeanCon,function(creditos) {	
				$('#saldoInsolutoCartera').val(creditos.saldoInsolutoCartera);							
				$('#sumatoriaCreditos').val(creditos.sumatoriaCreditos); 	
				agregarFormatoMoneda('saldoInsolutoCartera');
				agregarFormatoMoneda('sumatoriaCreditos');

				
			});										

}
function validaSoloNumeros() {
	if ((event.keyCode < 48) || (event.keyCode > 57))
		event.returnValue = false;
}

function agregaFormatoMonedaGrid(controlID) {
	var jqControlID = eval("'#" + controlID + "'");
	$(jqControlID).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
}

// -------------------------------------- funcion para poner el formato de moneda a un campo --------------------------------------- //
function agregarFormatoMoneda(controlID) {
	var jqControlID = eval("'#" + controlID + "'");
	$(jqControlID).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
}

function fnc() {
			document.getElementById('table-scroll').onscroll = function() {

				document.getElementById('fixedY').style.top = document.getElementById('table-scroll').scrollTop + 'px';

			};
		}

function funcionExito(){

}

function funcionError(){
	
}


function trSelected(idControl){
	$('#gvMain tr').removeClass('itemSelected');
	$('#'+idControl).addClass('itemSelected');
}