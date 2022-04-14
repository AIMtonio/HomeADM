var catTipoConsulBitacora = {
	'conBitacoraFallidos':'2'
};

var parametroBean = consultaParametrosSession();

$(document).ready(function() {
	esTab = false;
	var parametroBean = consultaParametrosSession();
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
	$('#mes').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('adjuntar', 'submit');
	deshabilitaBoton('verBitacora', 'submit');
	deshabilitaBoton('ocultar', 'submit');
	deshabilitaBoton('grabar', 'submit');


	$.validator.setDefaults({
		  submitHandler: function(event) {
			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','mes','funcionExito','funcionError');
			  deshabilitaBoton('grabar', 'submit');
			}
	});

	$('#formaGenerica').validate({
		rules: {
			mes: {
				required: true
			}

		},
		messages: {
			mes: {
				required: 'Especifique Mes'
			}
		}
	});


	$('#adjuntar').click(function() {
		$('#folioCargaID').val(0);
		$('#tipoTransaccion').val(0);
		if($("#mes").val()>0 && $("#mes").val()!="" && $("#mes").val()!=null){
			subirArchivoFacturas();
		}else{
			mensajeSis('Favor de seleccionar el mes.');
			$("#mes").select();
			$("#mes").focus();
		}

	});

	$('#verBitacora').click(function() {
		$('#gridBitacoraCargaArchivo').show(500);
		deshabilitaBoton('verBitacora', 'submit');
		habilitaBoton('ocultar', 'submit');

	});

	$('#ocultar').click(function() {
		$('#gridBitacoraCargaArchivo').hide(500);
		deshabilitaBoton('ocultar', 'submit');
		habilitaBoton('verBitacora', 'submit');

	});

	$('#mes').blur(function() {
		$('#tipoTransaccion').val(0);
		$('#gridBitacoraCargaArchivo').html("");
		if($('#mes').val()!="0" && $('#mes').val()!=null){
			habilitaBoton('adjuntar', 'submit');
		}else{
			deshabilitaBoton('adjuntar', 'submit');
		}
	});


});



// Subir archivos de Pagos de Nomina
function subirArchivoFacturas() {
	var mes = $("#mes").val();
	if(mes == ''){
		mensajeSis("Especifique el Mes para el archivo que Desea Procesar");
		$('#mes').focus();
		agregaFormatoControles('formaGenerica');
		deshabilitaBoton('verBitacora', 'submit');
			event.preventDefault();
			}
	else{

	var url ="cargaMasivaFileUpload.htm?mes="+$('#mes').val()+"&fechaCarga="+$('#fechaInicio').val();
	var leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
	var topPosition = (screen.height) ? (screen.height-500)/2 : 0;
	ventanaArchivosPagosNomina = window.open(url,
			"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no," +	"addressbar=0,menubar=0,toolbar=0"+
			"left="+leftPosition+
			",top="+topPosition+
			",screenX="+leftPosition+
			",screenY="+topPosition);

		$('#gridBitacoraCargaArchivo').html("");
		$('#gridBitacoraCargaArchivo').hide(500);
	}
}

// Consultar Errores de Pagos de Nomina
function consultaGridFacturasFallidas(){
	var params = {};
	params['tipoLista'] = catTipoConsulBitacora.conBitacoraFallidos;
	params['folioCargaID'] =$('#folioCargaID').val();
	params['nombreLista'] = "ListaCargaMasiva2";

	$.post("bitArchivoFacturaGrid.htm", params, function(data){
		if(data.length >0) {
			$('#gridBitacoraCargaArchivo').html(data);
			$('#gridBitacoraCargaArchivo').show(500);
			$('#contenedorForma').unblock();
			consultaFolio($('#folioCargaID').val());
		}else{
			$('#gridBitacoraCargaArchivo').html("");
			$('#gridBitacoraCargaArchivo').show(500);
			$('#contenedorForma').unblock();
		}
	});

}


function agregaIngoCargaArchivo(totalRegistros, noRegExito, noRegError, noRegMesSelec,
								noRegNoPerteneceMes, totalProvedores, noProvExiste, noProvNoExiste){
	var tabla  = '<table border="0" cellpadding="2" cellspacing="0" width="60%">';
	tabla += '<tr style="background-color: #05A1DB">';
	tabla += '    <td class="label"  align="center" >';
	tabla += '        <label for="" style="color:#ffffff">RESUMEN REGISTROS</label>';
	tabla += '    </td>';
	tabla += '    <td class="label"  align="center">';
	tabla += '        <label for="" id="totalRegistros" style="color:#ffffff">'+totalRegistros+'</label>';
	tabla += '    </td>';
	tabla += '</tr>';
	tabla += '<tr>';
	tabla += '    <td class="label"  align="left">';
	tabla += '        <label for="">No. Registros exitosamente cargados</label>';
	tabla += '    </td>';
	tabla += '    <td class="label"  align="center">';
	tabla += '        <label for="" id="noRegExito">'+noRegExito+'</label>';
	tabla += '    </td>';
	tabla += '</tr>';
	tabla += '<tr>';
	tabla += '    <td class="label"  align="left">';
	tabla += '        <label for="">No. Registros con error</label>';
	tabla += '    </td>';
	tabla += '    <td class="label"  align="center">';
	tabla += '        <label for=""  id="noRegError">'+noRegError+'</label>';
	tabla += '    </td>';
	tabla += '</tr>';
	tabla += '<tr>';
	tabla += '    <td class="label"  align="left">';
	tabla += '        <label for="">No. Registros que coinciden con el mes seleccionado</label>';
	tabla += '    </td>';
	tabla += '    <td class="label"  align="center">';
	tabla += '        <label for="" id="noRegMesSelec">'+noRegMesSelec+'</label>';
	tabla += '    </td>';
	tabla += '</tr>';
	tabla += '<tr>';
	tabla += '    <td class="label"  align="left">';
	tabla += '        <label for="">No. Registros que se ignoraran por no pertenecer al mes</label>';
	tabla += '    </td>';
	tabla += '    <td class="label"  align="center">';
	tabla += '        <label for="" id="noRegNoPerteneceMes">'+noRegNoPerteneceMes+'</label>';
	tabla += '    </td>';
	tabla += '</tr>';
	tabla += '<tr style="background-color: #05A1DB">';
	tabla += '    <td class="label"  align="center">';
	tabla += '        <label for="" style="color:#ffffff">PROVEEDORES</label>';
	tabla += '    </td>';
	tabla += '    <td class="label"  align="center">';
	tabla += '        <label for="" id="totalProvedores" style="color:#ffffff">'+totalProvedores+'</label>';
	tabla += '    </td>';
	tabla += '</tr>';
	tabla += '<tr>';
	tabla += '    <td class="label"  align="left">';
	tabla += '        <label for="">No Proveedores Existentes</label>';
	tabla += '    </td>';
	tabla += '    <td class="label"  align="center">';
	tabla += '        <label for="" id="noProvExiste">'+noProvExiste+'</label>';
	tabla += '    </td>';
	tabla += '</tr>';
	tabla += '<tr>';
	tabla += '    <td class="label"  align="left">';
	tabla += '        <label for=""> No. Proveedores No Existentes</label>';
	tabla += '    </td>';
	tabla += '    <td class="label"  align="center">';
	tabla += '        <label for="" id="noProvNoExiste">'+noProvNoExiste+'</label>';
	tabla += '    </td>';
	tabla += '    <td align="right">';
	tabla += '        <input type="submit" id="grabar" name="grabar" class="submit" value="Alta Proveedores" tabindex="7" />';
	tabla += '		  <a id="ligaGenerar" href="repProveedoresCargaMasiva.htm" target="_blank" >';
	tabla += '			<input type="button" id="generar" name="generar" class="submit" value="Generar Reportes" />';
	tabla += '	  	  </a>';
	tabla += '    </td>';
	tabla += '</tr>';
	tabla += '</table><br><br>';
	$('#datosResultado').prepend(tabla);
	if(noProvNoExiste>0){
		habilitaBoton('grabar', 'submit');
	}else{
		deshabilitaBoton('grabar', 'submit');
	}

	//$("#ligaGenerar").hide();
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(3);
	});

	$('#ligaGenerar').click(function() {
		generaReporteFacturas();
	});

}

//FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	inicializaForma('formaGenerica','mes');
	agregaFormatoControles('formaGenerica');
	$('#fechaInicio').val(parametroBean.fechaSucursal);

}

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	deshabilitaBoton('grabar', 'submit');
	if($("#tipoTransaccion").val()!="3"){
		inicializaPantalla();
		$('#mes').val('');
		//$("#ligaGenerar").show();
	}
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
	agregaFormatoControles('formaGenerica');
	//$("#ligaGenerar").show();
}

function habilitaBotones(folioCargaID){
	habilitaBoton('verBitacora', 'submit');
	deshabilitaBoton('ocultar', 'submit');
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
			message: $('#mensaje'),
			css: {border:		'none',
					background:	'none'}
	});

	 if(folioCargaID>0 && folioCargaID!=null){
		$('#folioCargaID').val(folioCargaID);
		consultaGridFacturasFallidas();
		deshabilitaBoton('verBitacora', 'submit');
		habilitaBoton('ocultar', 'submit');

	}else{
		$('#folioCargaID').val(0);
		deshabilitaBoton('verBitacora', 'submit');
		deshabilitaBoton('ocultar', 'submit');
		deshabilitaBoton('grabar', 'submit');
		$('#contenedorForma').unblock();
	}

}

function consultaFolio(folioCarga) {
	var FacturasBeanCon = {
		'folioCargaID':folioCarga
	};
	setTimeout("$('#cajaLista').hide();", 200);
	cargaMasivaFacturasServicio.consulta(2,FacturasBeanCon,function(facturas){
		if(facturas!=null){
			agregaIngoCargaArchivo(facturas.totalFacturas,		facturas.numFacturasExito,
								  facturas.numFacturasError,	facturas.mesCorresponde,
								  facturas.mesNoCorresponde,	facturas.totalProvedores,
								  facturas.provExiste,			facturas.provNoExiste);
		}
	});
}

function generaReporteFacturas(){
	var usuario = parametroBean.claveUsuario;
	var fechaEmision = parametroBean.fechaSucursal;
	var folioCarga = $('#folioCargaID').val();
	var nombreInst = parametroBean.nombreCortoInst;
	$('#ligaGenerar').attr('href','repProveedoresCargaMasiva.htm?folioCargaID='+folioCarga+
																'&tipoReporte=1'+
																'&usuario='+usuario+
																'&nombreInstitucion='+nombreInst+
																'&fechaEmision='+fechaEmision+
																'&tipoLista=1');

}
