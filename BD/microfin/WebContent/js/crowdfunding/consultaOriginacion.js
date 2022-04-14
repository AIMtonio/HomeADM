esTab = true;

//Definicion de Constantes y Enums
var catTipoTransaccionSolCred = {
		'agrega':'1',
		'modifica':'2',
};

var catTipoConsultaSolCred = {
		'principal':1,
		'foranea':2
};

var parametroBean;
$(document).ready(function() {

	parametroBean = consultaParametrosSession();
	$('#creditoID').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('planAmortizacion', 'submit');

	$(':text').focus(function() {
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '1', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});

	$('#creditoID').blur(function() {
		validaCredito(this.id);
	});

	$('#solicitudCreditoID').bind('keyup',function(e){

		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#solicitudCreditoID').val();

			listaAlfanumerica('solicitudCreditoID', '1', '1', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}

	});


	$('#solicitudCreditoID').blur(function() {

		consultaSolicitudCred(this.id);
	});

	$('#reportePdf').click(function() {
		if($('#solicitudCreditoID').val()=="" && $('#creditoID').val()==""){
			mensajeSis("Indique el Número de Solicitud o de Crédito.");
		}else{
			enviarDatosPDF();
		}

	});

	$('#planAmortizacion').click(function() {
		fondeoInver();
	});

	agregaFormatoControles('formaGenerica');
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({

		rules: {
			creditoID: 'required'
		},

		messages: {

			clienteID: 'Especifique numero de cliente'
		}
	});

});

function validaCredito(control) {
	$('#gridInversionistas').html("");
	$('#gridCalendarioInv').html("");
	var numCredito = $('#creditoID').val();
	setTimeout("$('#cajaLista').hide();", 200);

	if(numCredito=='0' || numCredito == ''){
		$('#solicitudCreditoID').focus();
		habilitaBoton('planAmortizacion', 'submit');
	}
	if(numCredito != '' && !isNaN(numCredito) && esTab){
		habilitaBoton('planAmortizacion', 'submit');
		var creditoBeanCon = {
				'creditoID':$('#creditoID').val()
		};
		creditosServicio.consulta(catTipoConsultaSolCred.principal,creditoBeanCon,function(credito) {
			if(credito!=null){
				esTab=true;
				$('#solicitudCreditoID').val(credito.solicitudCreditoID);
				$('#clienteID').val(credito.clienteID);
				$('#cuentaID').val(credito.cuentaID);
				$('#fechaIniCre').val(credito.fechaInicio);
				$('#fechaVenCre').val(credito.fechaVencimien);
				$('#montoAutorizado').val(credito.montoCredito);
				$('#estatus').val(credito.estatus);
				$('#productoCreditoID').val(credito.producCreditoID);
				consultaCliente('clienteID');
				consultaProducCredito('productoCreditoID');
				fondeoInver();
			}else{
				if(numCredito!='0'){
					deshabilitaBoton('planAmortizacion', 'submit');
					mensajeSis("No Existe el Crédito.");
					$('#creditoID').focus();
					$('#creditoID').select();
				}
			}
		});

	}

}



function consultaCliente(idControl) {
	var jqCliente = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);

	if(numCliente != '' && !isNaN(numCliente) && esTab){
		clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
			if(cliente!=null){
				$('#clienteID').val(cliente.numero);
				$('#nombreCliente').val(cliente.nombreCompleto);
			}else{
				mensajeSis("No Existe el "+$('#safilocaleCTE').val()+'.');
				$('#clienteID').focus();
				$('#clienteID').select();
			}
		});
	}
}


function consultaSolicitudCred(idControl) {
	var jqSolCred = eval("'#" + idControl + "'");
	var numSolicitud = $(jqSolCred).val();
	var tipConAlta = 4;
	var SolicitudBeanCon = {
			'solicitudCreditoID':numSolicitud,
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if(numSolicitud != '' && !isNaN(numSolicitud) && esTab){
		solicitudCredServicio.consulta(tipConAlta,SolicitudBeanCon,function(solicitudCred) {
			if(solicitudCred!=null){
				esTab=true;
			}else{
				mensajeSis("No Existe la Solicitud.");
				$('#solicitudCreditoID').focus();
				$('#solicitudCreditoID').select();
				habilitaBoton('planAmortizacion', 'submit');
			}
		});
	}
}

function lisCalendarioFondeador(){
	var params = {};

	params['solFondeoID'] = $('#numFondKubo').val();
	params['tipoLista'] = 2;
	params['empresaID'] = parametroBean.empresaID;
	params['usuario'] = parametroBean.numeroUsuario;
	params['fecha'] = parametroBean.fechaSucursal;
	params['direccionIP'] = parametroBean.IPsesion;
	params['sucursal'] = parametroBean.sucursal;
	params['numTransaccion'] = parametroBean.NumTransaccion;

	$.post("calendarioInversionistasGrid.htm", params, function(data){
		if(data.length >0) {
			$('#gridCalendarioInv').html(data);
			$('#gridCalendarioInv').show();
			agregaFormatoControles('gridCalendarioInv');
		}else{
			$('#gridCalendarioInv').html("");
			$('#gridCalendarioInv').show();
		}
	});
}


function fondeoInver() {
	$('#gridInversionistas').html("");
	$('#gridCalendarioInv').html("");
	var tipoLista=3;
	var params = {};
	params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
	params['tipoLista'] = tipoLista;
	params['empresaID'] = parametroBean.empresaID;
	params['usuario'] = parametroBean.numeroUsuario;
	params['fecha'] = parametroBean.fechaSucursal;
	params['direccionIP'] = parametroBean.IPsesion;
	params['sucursal'] = parametroBean.sucursal;
	params['numTransacSim'] = parametroBean.NumTransaccion;

	$.post("originacionCat.htm", params, function(data){
		if(data.length >0) {
			$('#gridInversionistas').html(data);
			$('#gridInversionistas').show();
			$('input[name=estatus]').click(function() {
				$('#gridCalendarioInv').html("");
				$('#gridDetalleMovFondeo').html("");
				$('#gridSaldosYpagos').html("");
				validarRadio();
			});
		}else{
			$('#gridInversionistas').html("");
			$('#gridInversionistas').show();
		}
	});
}


function validarRadio(){
	habilitaBoton('planAmortizacion', 'submit');
	$('input[name=estatus]').each(function() {
		var jqname = eval("'#" + this.id + "'");
		if ($(this).is(':checked')){
			var jqfondeo = eval("'#" + this.id + "'");
			var numFondeo = 	$(this).val();
			$('#numFondKubo').val(numFondeo);
		}
	});
	$('#planAmortizacion').click(function() {
		$('#gridDetalleMovFondeo').hide();
		$('#gridSaldosYpagos').hide();
		lisCalendarioFondeador();

	});

	$('#detMovimientos').click(function() {
		$('#gridCalendarioInv').hide();
		$('#gridSaldosYpagos').hide();
		detalleMovimientosFondeador();
	});

	$('#saldosYpagos').click(function() {
		$('#gridDetalleMovFondeo').hide();
		$('#gridCalendarioInv').hide();
		saldosYpagosFondeador();
	});

}


function detalleMovimientosFondeador(){
	var params = {};

	params['solFondeoID'] = $('#numFondKubo').val();
	params['tipoLista'] = 1;
	params['empresaID'] = parametroBean.empresaID;
	params['usuario'] = parametroBean.numeroUsuario;
	params['fecha'] = parametroBean.fechaSucursal;
	params['direccionIP'] = parametroBean.IPsesion;
	params['sucursal'] = parametroBean.sucursal;
	params['numTransaccion'] = parametroBean.NumTransaccion;

	$.post("crwFondeoMovsGrid.htm", params, function(data){
		if(data.length >0) {
			$('#gridDetalleMovFondeo').html(data);
			$('#gridDetalleMovFondeo').show();
			agregaFormatoControles('gridDetalleMovFondeo');
		}else{
			$('#gridDetalleMovFondeo').html("");
			$('#gridDetalleMovFondeo').show();
		}
	});
}

function saldosYpagosFondeador(){
	var params = {};

	params['solFondeoID'] = $('#numFondKubo').val();
	params['tipoLista'] = 4;
	params['empresaID'] = parametroBean.empresaID;
	params['usuario'] = parametroBean.numeroUsuario;
	params['fecha'] = parametroBean.fechaSucursal;
	params['direccionIP'] = parametroBean.IPsesion;
	params['sucursal'] = parametroBean.sucursal;
	params['numTransaccion'] = parametroBean.NumTransaccion;

	$.post("pagosYsaldosFondeoCRWGrid.htm", params, function(data){
		if(data.length >0) {
			$('#gridSaldosYpagos').html(data);
			$('#gridSaldosYpagos').show();
			agregaFormatoControles('gridSaldosYpagos');
		}else{
			$('#gridSaldosYpagos').html("");
			$('#gridSaldosYpagos').show();
		}
	});
}

function consultaProducCredito(idControl) {
	var jqProdCred  = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();
	var ProdCredBeanCon = {
			'producCreditoID':ProdCred
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if(ProdCred != '' && !isNaN(ProdCred) && esTab){
		productosCreditoServicio.consulta(catTipoConsultaSolCred.principal,ProdCredBeanCon,function(prodCred) {
			if(prodCred!=null){
				//esTab=true;
				$('#descripProducto').val(prodCred.descripcion);

			}else{
				mensajeSis("No Existe el Producto de Crédito.");
			}
		});
	}
}

//	-----------funcion para enviar datos al reportePDF---------
function enviarDatosPDF(){
	var pagina='DetalleInversionRepPDF.htm?creditoID='+$('#creditoID').val()+
		'&solicitudCreditoID='	+ $('#solicitudCreditoID').val()+
		'&clienteID='			+ $('#clienteID').val()+
		'&nombreCliente='		+ $('#nombreCliente').val()+
		'&montoAutorizado='		+ $('#montoAutorizado').val()+
		'&estatus='				+ $('#estatus option:selected').text()+
		'&fechaIniCre='			+ $('#fechaIniCre').val()+
		'&productoCreditoID='	+ $('#productoCreditoID').val()+
		'&descripProducto='		+ $('#descripProducto').val()+
		'&descripcionCta='		+ $('#decripcioncta').val()+
		'&fechaVenCre='			+ $('#fechaVenCre').val();
	window.open(pagina, '_blank');
}
