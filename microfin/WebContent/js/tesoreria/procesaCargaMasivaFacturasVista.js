$(document).ready(function() {
	esTab = false;

	// Definicion de Constantes y Enums
    $(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

    inicializaPantalla();
    $('#folioCargaID').focus();

	$('#folioCargaID').bind('keyup',function(e) {
		lista('folioCargaID', '3', '3', 'descripcion', $('#folioCargaID').val(), 'listaFolioFactura.htm');
	});

	$('#centroCostoID').bind('keyup',function(){
		lista(this.id, '2', '1', 'descripcion', $('#centroCostoID').val(), 'listaCentroCostos.htm');
	});

	$('#tipoGastoID').bind('keyup',function(){
		listaAlfanumerica(this.id, '1', '1', 'descripcion', $('#tipoGastoID').val(), 'listaTipoGas.htm');
	});


	$('#folioCargaID').blur('keyup',function(e) {
		if($('#folioCargaID').asNumber()>0 && $('#folioCargaID').val()!=null && esTab){
			consultaFolio();
		}else{
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('eliminar', 'submit');
		}

	});

	$('#centroCostoID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if($('#centroCostoID').val()!='' && !isNaN($('#centroCostoID').val()) && esTab){
			validaCentroCostos();
		}
	});

	$('#tipoGastoID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if($('#tipoGastoID').val()!='' && !isNaN($('#tipoGastoID').val()) && esTab){
			consultaTipoGasto();
		}
	});




	function consultaTipoGasto(){
		var numTipoGasto = $("#tipoGastoID").val();
		var tipoCon =1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoGasto != '' && !isNaN(numTipoGasto) ){

			var RequisicionTipoGastoListaBean = {
					'tipoGastoID' : numTipoGasto
			};

			requisicionGastosServicio.consultaTipoGasto(tipoCon,RequisicionTipoGastoListaBean,function(tipoGastoCon){
				if(tipoGastoCon!=null){
					$("#nombreTipoGasto").val(tipoGastoCon.descripcionTG);
				}else{
					mensajeSis("No existe el Tipo de Gasto");
					$("#tipoGastoID").focus();
					$("#nombreTipoGasto").val('');
				}
			});
		}
	}

	function validaCentroCostos(){
		var numcentroCosto = $("#centroCostoID").val();
		var tipoLista=1;

		setTimeout("$('#cajaLista').hide();", 200);
		if(numcentroCosto != '' && !isNaN(numcentroCosto) && esTab){
				var centroBeanCon = {
				'centroCostoID':numcentroCosto
			 };
			centroServicio.consulta(tipoLista,centroBeanCon,function(centro) {
					if(centro!=null){
						$("#nombreCenCosto").val(centro.descripcion);
					}else{
							mensajeSis('El Centro de Costo No Existe');
							$("#nombreCenCosto").val('');
							$("#centroCostoID").select();
							$("#centroCostoID").focus();
					}
				});
		}
	}

	function consultaFolio() {
		var FacturasBeanCon = {
			'folioCargaID':$("#folioCargaID").val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		cargaMasivaFacturasServicio.consulta(1,FacturasBeanCon,function(facturas){
			if(facturas!=null){
				dwr.util.setValues(facturas);
				if(facturas.estatus=="P"){
					$('#gridBitacoraCargaArchivo').html("");
					$('#gridBitacoraCargaArchivo').hide();
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('eliminar', 'submit');
					mensajeSis("Las facturas correspondientes al folio "+facturas.folioCargaID+ " ya fueron dadas de alta.");
					$("#folioCargaID").select();
					$("#folioCargaID").focus();
					deshabilitaControl("centroCostoID");
					deshabilitaControl("tipoGastoID");
				}else{
					habilitaControl("centroCostoID");
					habilitaControl("tipoGastoID");
					habilitaBoton('grabar', 'submit');
					habilitaBoton('eliminar', 'submit');
					consultaGridFacturasExito();
				}

			}else{
				mensajeSis("No existe el folio de carga");
				$('#folioCargaID').val('');
				$('#folioCargaID').focus();
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('eliminar', 'submit');
				inicializaPantalla();
			}
		});
	}




	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folioCargaID','funcionExito','funcionError');
		}
	});

	$('#formaGenerica').validate({
		ignore: ":hidden",
		rules: {
			folioCargaID: {
				required:  true
			},
			centroCostoID: {
				required: function() {return $("#tipoTransaccion").val()=="2";}
			},
			tipoGastoID: {
				required: function() {return $("#tipoTransaccion").val()=="2";}
			}


		},
		messages: {
			folioCargaID: {
				required: 'Especifique el folio de carga.'
			},
			centroCostoID: {
				required: 'Especifique el centro de costos.'
			},
			tipoGastoID: {
				required: 'Especifique el tipo de gasto.'
			}
		}
	});


	$('#grabar').click(function() {
		consultaBitacoraExito("check", 1);
		$("#tipoTransaccion").val(2);
		$("#nombreLista").val("ListaCargaMasiva");
	 });

	$('#eliminar').click(function() {
		var confirma = confirm("Al confirmar no podrá procesar la(s) factura(s) seleccionada(s).\n\n ¿Esta seguro que desea eliminar la(s) factura(s)?");
		if(confirma){
			consultaBitacoraExito("check", 1);
			$("#tipoTransaccion").val(4);
			$("#nombreLista").val("ListaCargaMasiva");
			return true;
		}else{
			return false;
		}

	 });



});

/**
 * Función para Seleccionar Todos
 */
	function seleccionarTodos(){
	var contador = 0;
	if($("#selecTodos").is(':checked')) {
		$('input[name=seleccionadoCheck]').each(function(x, y){
			numero= x+1;
			contador = contador +1;
			$('#seleccionadoCheck'+numero).attr('checked', true);
			$('#estatus'+numero).val('S');
			$('#seleccionadoCheck'+numero).val("S");
		});
		habilitaBoton('grabar', 'submit');

	}else{
		$('input[name=seleccionadoCheck]').each(function(x, y) {
			numero= x+1;
			contador = contador +1;
			$('#seleccionadoCheck'+numero).attr('checked', false);
			$('#estatus'+numero).val('N');
			$('#seleccionadoCheck'+numero).val("N");

		});
	}

	consultaBitacoraExito("check", 1);


}

	//FUNCION INICIALIZA PANTALLA
	function seleccionIndividual(campoID, estatusID){
		if ($("#"+campoID).is(':checked')){
			$("#"+campoID).val("S");
			$("#"+estatusID).val("S");
		}else{
			$("#"+campoID).val("N");
			$("#"+estatusID).val("N");
		}
		//consultaBitacoraExito("check", 1);

	}

	function consultaBitacoraExito(pageValor, tipoLista){

		var params = {
		};

		var listaFolioCargaID = '';
		var listaEstatus = '';
		var listaEsSeleccionado = '';

		// Se agregan los elementos para conservar el valor en el cambio de pagina
		$("input[name='lfolioCargaID']").each(function(){
			listaFolioCargaID = listaFolioCargaID+","+$(this).val();
		});


		$("input[name='estatus']").each(function(){
				listaEstatus = listaEstatus+","+$(this).val();
		});

		$("input[name='seleccionadoCheck']").each(function(){
			if($(this).val() == ''){
				listaEsSeleccionado = listaEsSeleccionado+","+pratronVacio;
			} else{
				listaEsSeleccionado = listaEsSeleccionado+","+$(this).val();
			}
		});

		params['tipoLista'] = tipoLista;
		params['page'] 	= pageValor;
		params['listaFolioCargaID'] = listaFolioCargaID;
		params['listaEsSeleccionado'] = listaEsSeleccionado;
		params['listaEstatus'] = listaEstatus;
		params['nombreLista'] = "ListaCargaMasiva";

		$.post("bitArchivoFacturaGrid.htm", params, function(data){
			if(data.length >0) {
				agregaFormatoControles('formaGenerica');
				$('#gridBitacoraCargaArchivo').html(data);
				$('#gridBitacoraCargaArchivo').show();

				$("input[name='seleccionadoCheck']").each(function(){
					if($(this).val() == 'S'){
						$(this).attr('checked', true);
					} else{
						$(this).attr('checked', false);
					}
				});

			}else{
				$('#gridBitacoraCargaArchivo').html("");
				$('#gridBitacoraCargaArchivo').show();
			}
		});
		desbloquearPantalla();
	}



// Consultar Errores de Pagos de Nomina
function consultaGridFacturasExito(){
	var params = {};
	params['tipoLista'] = 1;
	params['folioCargaID'] =$('#folioCargaID').val();
	params['nombreLista'] = "ListaCargaMasiva";

	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
			message: $('#mensaje'),
			css: {border:		'none',
					background:	'none'}
	});
	$.post("bitArchivoFacturaGrid.htm", params, function(data){
		if(data.length >0) {
			$('#gridBitacoraCargaArchivo').html(data);
			$('#gridBitacoraCargaArchivo').show(500);
			desbloquearPantalla();
		}else{
			$('#gridBitacoraCargaArchivo').html("");
			$('#gridBitacoraCargaArchivo').show(500);
			desbloquearPantalla();
		}
	});

}


//FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	deshabilitaBoton('grabar', 'submit');
	$('#gridBitacoraCargaArchivo').html("");
	$('#gridBitacoraCargaArchivo').hide(500);
	$('#nombreLista').val('');
	$('#mes').val('');
	$('#usuario').val('');
	$('#totalFacturas').val('');
	$('#numFacturasExito').val('');
	$('#numFacturasError').val('');
	$('#fechaCarga').val('');
	$('#folioCargaID').focus();
	$("#nombreCenCosto").val('');
	$("#centroCostoID").val('');
	$("#tipoGastoID").val('');
	$("#nombreTipoGasto").val('');
	$("#descripcionEstatus").val('');

}

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	inicializaPantalla();
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
	inicializaPantalla();
}