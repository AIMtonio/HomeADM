var tipoLista = {
	'listaPrincipal': 1,
	'listaConvenios': 3
};

var tipoConsulta = {
		'principal': 1
	};

var tipoReporte = {
		'reporteExcelTodos': 1,
		'reporteExcelIndividual': 2,
		'reportePDFTodos' : 3,
		'reportePDFIndividual' : 4
};

$(document).ready(function() {

	esTab = false;
	agregaFormatoControles('formaGenerica');
	$('#radioPDF').attr("checked",true);

	var parametros = consultaParametrosSession();

	// Se cargan valores por defecto
	$('#institNominaID').val(0);
	$('#institNominaID').focus();
	$('#nombreInstit').val('TODAS');
	soloLecturaControl("nombreInstit");


	// Se cargan las fechas por defecto
	$('#fechaInicio').val(parametros.fechaSucursal);
	$('#fechaFin').val(parametros.fechaSucursal);

	$(':text, :button, :submit, textarea, select').focus(function() {
		esTab = false;
	});

	$(':text, :button, :submit, textarea, select').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#consultar').click(function() {
		$('#tipoTransaccion').val(tipoLista.listaPrincipal);
		cargaGrid();
	});

	$('#exportar').click(function() {
		if($('#radioPDF').is(':checked')){
			generarReporte(tipoReporte.reportePDFTodos);
		}
		if($('#radioExcel').is(':checked')){
			generarReporte(tipoReporte.reporteExcelTodos);
		}
	});

	$('#institNominaID').blur(function() {
		var institNominaID = $('#institNominaID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if((isNaN(institNominaID) || institNominaID == '' || institNominaID == 0)) {
			$('#institNominaID').val(0);
			$('#nombreInstit').val('TODAS');
			dwr.util.removeAllOptions('convenioNominaID');
			dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
		} else
			if (institNominaID <= 0){
				$('#institNominaID').focus();
				mensajeSis('La empresa de nómina no existe');
				$('#nombreInstit').val('');
				dwr.util.removeAllOptions('convenioNominaID');
				dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
			} else {
				funcionConsultaInstitucionNomina(this.id);
				$('#formaTabla').html("");
				$('#formaTabla').hide();
			}
	});

	$('#institNominaID').bind('keyup', function(e) {
		lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$(':text, :button, :submit, textarea, select').blur(function() {
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#institNominaID').focus();
			}, 0);
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'institNominaID', 'funcionExito', 'funcionError');
		}
	});

	$('#formaGenerica').validate({
		rules: {}, messages: {}
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Zfecha= parametros.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').focus();
				$('#fechaInicio').val(parametros.fechaSucursal);
			}
			else{
				if (mayor(Xfecha, Zfecha) ){
					mensajeSis("La Fecha Inicial es Mayor a la Fecha Actual.");
					$('#fechaInicio').focus();
					$('#fechaInicio').val(parametros.fechaSucursal);
			}
				else{
					$('#fechaFin').focus();
				}
			}
		}else{
			$('#fechaInicio').focus();
			$('#fechaInicio').val(parametros.fechaSucursal);
		}
	});

	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaFin').change(function() {
		var Xfecha= parametros.fechaSucursal;
		var Yfecha= $('#fechaFin').val();
		var Zfecha= $('#fechaInicio').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaFin').val(parametros.fechaSucursal);
			}
			else{
				if ( mayor(Zfecha,Yfecha) ){
					mensajeSis("La Fecha de Final es menor a la Fecha Inicial.")	;
					$('#fechaFin').val(parametros.fechaSucursal);
				}
				if (mayor(Yfecha, Xfecha)){
					mensajeSis("La Fecha Final es Mayor a la Fecha Actual.");
					$('#fechaFin').focus();
					$('#fechaFin').val(parametros.fechaSucursal);
				}
			}

		}else{
			$('#fechaFin').focus();
			$('#fechaFin').val(parametros.fechaSucursal);
		}
	});
}); // Fin document

function funcionConsultaInstitucionNomina(idControl) {
	var jqControl = eval("'#" + idControl + "'");
	var beanEntrada = {
		'institNominaID': $(jqControl).val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if($(jqControl).val() != '' && !isNaN($(jqControl).val()) && $(jqControl).val() != 0) {
		institucionNomServicio.consulta(tipoConsulta.principal, beanEntrada, function(resultado) {
			if(resultado != null) {
				dwr.util.setValues(resultado);
				listaConveniosTodos();
			} else {
				mensajeSis('La empresa de nómina no existe');
				$('#institNominaID').focus();
				dwr.util.removeAllOptions('convenioNominaID');
				dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
			}
		});
	}
}

function listaConveniosTodos() {
	beanEntrada = {
		'institNominaID': $('#institNominaID').val()
	};
	bitacoraConveniosNominaServicio.lista(tipoLista.listaConvenios, beanEntrada, function(resultado) {
		dwr.util.removeAllOptions('convenioNominaID');
		if (resultado != null && resultado.length > 0) {
			dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
			dwr.util.addOptions('convenioNominaID', resultado, 'convenioNominaID', 'descripcion');
			return;
		}
		dwr.util.addOptions('convenioNominaID', {'': 'NO SE ENCONTRARON CONVENIOS'});
	});
}

function cargaGrid() {
	var params = {};
	params['convenioNominaID'] = $('#convenioNominaID option:selected').val();
	params['institNominaID'] = $('#institNominaID').val();
	params['tipoLista'] = tipoLista.listaPrincipal;
	params['fechaInicio'] = $('#fechaInicio').val();
	params['fechaFin'] = $('#fechaFin').val();
	$.post("bitacoraCambiosInstitNomGridVista.htm", params, function(data) {
		if(data.length > 0) {
			$('#formaTabla').html(data);
			$('#formaTabla').show();
		} else {
			mensajeSis("Error al generar la lista");
			$('#formaTabla').hide();
		}
	}).fail(function() {
		mensajeSis("Error al generar el grid");
		$('#formaTabla').hide();
	});
}

function funcionExito() {

}

function funcionError() {
	cargaGrid();
}

//Función para generar el Reporte Excel de Todos los cambios
function generarReporte(tipoReporte){
	var tipoRep				= tipoReporte;
	var fechaEmision 		= parametroBean.fechaSucursal;
	var claveUsuario		= parametroBean.claveUsuario;
	var nombreInstitucion	= parametroBean.nombreInstitucion;
	var institNominaID		= 0;
	var hisConvenioNomID	= 0;
	var nombreInstitNom		= 'TODAS';
	var convenioNominaID	= 0;

	if ($('#nombreInstit').val() != 'TODAS') {
		nombreInstitNom = $('#nombreInstit').val();
	}

	if ($('#convenioNominaID option:selected').val() != '') {
		convenioNominaID = $('#convenioNominaID option:selected').val();
	}

	var paginaReporte ='repBitacoraNomInst.htm?'+
	'tipoRep='+tipoRep+
	'&hisConvenioNomID='+hisConvenioNomID+
	'&institNominaID='+$('#institNominaID').val()+
	'&convenioNominaID='+convenioNominaID+
	'&fechaInicio='+$('#fechaInicio').val()+
	'&fechaFin='+$('#fechaFin').val()+
	'&nombreUsuario='+claveUsuario+
	'&fechaSistema='+fechaEmision+
	'&rutaImagen='+parametroBean.rutaImgReportes+
	'&nombreInstitucion='+nombreInstitucion+
	'&nombreInstitNomina='+nombreInstitNom;
	window.open(paginaReporte, '_blank');
}

//Función para generar el Reporte Excel de un cambio individual
function generarExcelIndividual(convenioNomID, institNomID, hisConvenioNominaID, nombreInstit, esProg){
	var tipoRep				= tipoReporte.reporteExcelIndividual;
	var fechaEmision 		= parametroBean.fechaSucursal;
	var claveUsuario		= parametroBean.claveUsuario;
	var nombreInstitucion	= parametroBean.nombreInstitucion;
	var hisConvenioNomID	= hisConvenioNominaID;
	var nombreInstitNom		= nombreInstit;
	var convenioNominaID	= convenioNomID;
	var institNominaID		= institNomID;
	var esProgramacion		= esProg;

	var paginaReporte ='repBitacoraNomInstIndividual.htm?'+
	'tipoRep='+tipoRep+
	'&convenioNominaID='+convenioNominaID+
	'&institNominaID='+institNominaID+
	'&fechaInicio='+$('#fechaInicio').val()+
	'&fechaFin='+$('#fechaFin').val()+
	'&esProgramacion='+esProgramacion+
	'&nombreUsuario='+claveUsuario+
	'&nombreInstitucion='+nombreInstitucion+
	'&hisConvenioNomID='+hisConvenioNomID+
	'&nombreInstitNomina='+nombreInstitNom+
	'&fechaSistema='+fechaEmision;
	window.open(paginaReporte);
}

//Función para generar el Reporte Excel de un cambio individual
function generarPDFIndividual(convenioNomID, institNomID, hisConvenioNominaID, nombreInstit, esProg){
	var tipoRep				= tipoReporte.reportePDFIndividual;
	var fechaEmision 		= parametroBean.fechaSucursal;
	var claveUsuario		= parametroBean.claveUsuario;
	var nombreInstitucion	= parametroBean.nombreInstitucion;
	var hisConvenioNomID	= hisConvenioNominaID;
	var nombreInstitNom		= nombreInstit;
	var convenioNominaID	= convenioNomID;
	var institNominaID		= institNomID;
	var esProgramacion		= esProg;

	var paginaReporte ='repBitacoraNomInstIndividual.htm?'+
	'tipoRep='+tipoRep+
	'&convenioNominaID='+convenioNominaID+
	'&institNominaID='+institNominaID+
	'&fechaInicio='+$('#fechaInicio').val()+
	'&fechaFin='+$('#fechaFin').val()+
	'&esProgramacion='+esProgramacion+
	'&nombreUsuario='+claveUsuario+
	'&nombreInstitucion='+nombreInstitucion+
	'&hisConvenioNomID='+hisConvenioNomID+
	'&nombreInstitNomina='+nombreInstitNom+
	'&fechaSistema='+fechaEmision;
	window.open(paginaReporte);
}

function esFechaValida(fecha){

	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd).");
			return false;
		}

		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;

		switch(mes){
		case 1: case 3:  case 5: case 7:
		case 8: case 10:
		case 12:
			numDias=31;
			break;
		case 4: case 6: case 9: case 11:
			numDias=30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
			break;
		default:
			mensajeSis("Fecha introducida errónea.");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea.");
			return false;
		}
		return true;
	}
}

function comprobarSiBisisesto(anio){
	if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	}
	else {
		return false;
	}
}

function mayor(fecha, fecha2){
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
	var xMes=fecha.substring(5, 7);
	var xDia=fecha.substring(8, 10);
	var xAnio=fecha.substring(0,4);

	var yMes=fecha2.substring(5, 7);
	var yDia=fecha2.substring(8, 10);
	var yAnio=fecha2.substring(0,4);

	if (xAnio > yAnio){
		return true;
	}else{
		if (xAnio == yAnio){
			if (xMes > yMes){
				return true;
			}
			if (xMes == yMes){
				if (xDia > yDia){
					return true;
				}else{
					return false;
				}
			}else{
				return false;
			}
		}else{
			return false ;
		}
	}
}


function cambioPaginaGrid(valorPagina) {
	var params = {};
	params['convenioNominaID'] = $('#convenioNominaID option:selected').val();
	params['institNominaID'] = $('#institNominaID').val();
	params['tipoLista'] = tipoLista.listaPrincipal;
	params['fechaInicio'] = $('#fechaInicio').val();
	params['fechaFin'] = $('#fechaFin').val();
	params['page'] = valorPagina;
	$.post("bitacoraCambiosInstitNomGridVista.htm", params, function(data) {
		if(data.length > 0) {
			$('#formaTabla').html(data);
			$('#formaTabla').show();
		} else {
			mensajeSis("Error al generar la lista");
		}
	}).done(function() {
		asignaTabIndex();
	}).fail(function(xhr, status, error) {
	mensajeSis("Error al generar el grid");
	});
}

function asignaTabIndex() {
	$(":input:enabled:not(:hidden)").each(function(i) {
		$(this).attr('tabindex', i + 1);
	});
}