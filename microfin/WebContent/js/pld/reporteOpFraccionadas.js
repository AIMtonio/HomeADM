var esTab = false;
var parametroBean = consultaParametrosSession();
var primerDiaMes = '1900-01-01';
var catTipoReporte = {
	'PDF' : 1,
	'Excel'	: 2
};
$(document).ready(function() {
	inicializarPantalla();
	var clienteSofi = 15;  // Número de cliente que corresponde a SOFI EXPRESS.
	var numeroCliente = 0;
	numeroCliente = consultaClienteEspecifico();

	if (numeroCliente == clienteSofi) {
		$('#trOperaciones').show();
		$('#trUsuarios').show();
	}else{
		$('#trOperaciones').hide();
		$('#trUsuarios').hide();
	}
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#formaGenerica').validate({
		rules : {
			periodo : {
				required : true
			},
			clienteID : {
				required : true
			}
		},
		messages : {
			periodo : {
				required : 'Especificar el Periodo.',
			},
			clienteID : {
				required : 'Especificar '+$('#alertSocio').val()+'.'
			}
		}
	});
	$('#generar').click(function() {
		generaReporte();
	});

	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if ($('#clienteID').asNumber() > 0) {
			consultaCliente(this.id);
		} else {
			$('#clienteID').val('0');
			$('#nombresPersonaInv').val('TODOS');
		}
	});
	
	$('#usuarioServicioID').bind('keyup',function(e) { 
		lista('usuarioServicioID', '3', '1', 'nombreCompleto', $('#usuarioServicioID').val(), 'listaUsuario.htm');
	});
	
	$('#usuarioServicioID').blur(function() {
		setTimeout("$('#cajaListaCte').hide();", 200);
		if ($('#usuarioServicioID').asNumber() > 0) {
			consultaUsuarioServicio(this.value);
		} else {
			$('#usuarioServicioID').val('0');
			$('#nombreUsuario').val('TODOS');
		}
	});
	
	$('#periodo').click(function() {
	});
	
	$('#fechaInicio').blur(function() {
		$('#fechaInicio').val(primerDia());
		cargarPeriodo();
		$('#operaciones').focus();
	});
	
	$('#fechaInicio').change(function() {
		$('#fechaInicio').val(primerDia());
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaAplicacion);
			}
			if($('#fechaInicio').val() > parametroBean.fechaAplicacion) {
				mensajeSis("El Periodo es Mayor a la Fecha del Sistema.");
				$('#fechaInicio').val(parametroBean.fechaAplicacion);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaAplicacion);
		}
		cargarPeriodo();
	});
	
	$('#operaciones').change(function() {
		var operaciones = $('#operaciones').val();
		if(operaciones == ""){
			$('#trClientes').show();
			$('#clienteID').val('0');
			$('#nombresPersonaInv').val('TODOS');
			$('#trUsuarios').show();
			$('#usuarioServicioID').val('0');
			$('#nombreUsuario').val('TODOS');
		}
		if(operaciones == "C"){
			$('#trClientes').show();
			$('#clienteID').val('0');
			$('#nombresPersonaInv').val('TODOS');
			$('#trUsuarios').hide();
			$('#usuarioServicioID').val('0');
			$('#nombreUsuario').val('TODOS');
		}
		if(operaciones == "U"){
			$('#trClientes').hide();
			$('#clienteID').val('0');
			$('#nombresPersonaInv').val('TODOS');
			$('#trUsuarios').show();
			$('#usuarioServicioID').val('0');
			$('#nombreUsuario').val('TODOS');
		}
	});
	
	// Función para consultar el Cliente Especifico
	function consultaClienteEspecifico() {
		var numeroCliente = 0;
		paramGeneralesServicio.consulta(13, {
			async: false, callback: function (valor) {
				if (valor != null) {
					numeroCliente = valor.valorParametro;
				}
			}
		});
		return numeroCliente;
	}
});

function inicializarPantalla() {
	agregaFormatoControles('formaGenerica');
	$('#fechaInicio').val(parametroBean.fechaAplicacion);
	$('#periodo').val('');
	$('#clienteID').val('0');
	$('#nombresPersonaInv').val('TODOS');
	$('#fechaInicio').focus();
	cargarPeriodo();
	$('#usuarioServicioID').val('0');
	$('#nombreUsuario').val('TODOS');
}

function generaReporte() {
	if ($("#formaGenerica").valid()) {
		var usuario = parametroBean.claveUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var tipoReporte = $('input:radio[name=tipoReporte]:checked').val();
		var periodo = $("#periodo").val();
		var periodoDes = $("#periodoDes").val();
		var operaciones = $("#operaciones option:selected").val();
		var clienteID = $("#clienteID").val();
		var nombresPersonaInv = $("#nombresPersonaInv").val();
		var usuarioServicioID = $("#usuarioServicioID").val();
		var nombreUsuario = $("#nombreUsuario").val();
		var fechaInicio = $("#fechaInicio").val();
		var ClienteConCaracter = nombresPersonaInv;
		nombresPersonaInv = ClienteConCaracter.replace(/\&/g, "%26");
		nombreUsuario = ClienteConCaracter.replace(/\&/g, "%26");
		
		var descOperaciones;
		if(operaciones == ""){
			descOperaciones = 'TODOS';
		}else{
			descOperaciones = $("#operaciones option:selected").html();
		}
		
		var liga = 'reporteOpeFracPLD.htm?' 
				+ 'periodo=' + (tipoReporte == catTipoReporte.Excel ? '01' : fechaInicio)
				+ '&periodoDes=' + periodoDes
				+ '&operaciones='+operaciones
				+ '&descOperaciones='+descOperaciones
				+ '&fechaInicio=' + fechaInicio 
				+ '&clienteID='+ clienteID 
				+ '&nombresPersonaInv=' + nombresPersonaInv 
				+ '&usuarioServicioID='+ usuarioServicioID 
				+ '&nombreUsuario=' + nombreUsuario 
				+ '&usuario=' + usuario
				+ '&fechaSistema=' + fechaAplicacion 
				+ '&nombreInstitucion=' + nombreInstitucion 
				+ '&tipoReporte=' + tipoReporte;
		window.open(liga, '_blank');
	}
}

function consultaCliente(idControl) {
	var jqCliente = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();
	var tipConPrincipal = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	if (Number(numCliente) != '0') {
		clienteServicio.consulta(tipConPrincipal, numCliente,
				function(cliente) {
					if (cliente != null) {
						$('#clienteID').val(cliente.numero);
						$('#nombresPersonaInv').val(cliente.nombreCompleto);
					} else {
						mensajeSis("El "+$('#alertSocio').val()+" No Existe.");
						$('#clienteID').focus();
						$('#clienteID').select();
						$('#clienteID').val("0");
						$('#nombresPersonaInv').val("TODOS");
					}
				});
	}
}// fin consulta cliente

// Consulta del Usuario de Servicio
function consultaUsuarioServicio(numUsuario){
	var conPrincipal = 1;
	
	var usuarioBean = {
		'usuarioID' : numUsuario
	};

	if(numUsuario != '' && !isNaN(numUsuario)){
		usuarioServicios.consulta(conPrincipal,usuarioBean,function(usuario){
			if (usuario != null){
				$('#nombreUsuario').val(usuario.nombreCompleto);	
			}else{
				mensajeSis('El Usuario de Servicio No Existe.');
				$('#usuarioServicioID').focus();
				$('#usuarioServicioID').select();
				$('#usuarioServicioID').val("0");
				$('#nombreUsuario').val("TODOS");
			}
		});
	}
}

function cargarPeriodo(){
	var fechainicial = $('#fechaInicio').val();
	var anio = fechainicial.substring(0, 4);
	var mes = fechainicial.substring(5, 7);
	var mesDesc = '';
	switch(Number(mes)) {
		case 1:
			mesDesc = 'ENERO';
		break;
		case 2:
			mesDesc = 'FEBRERO';
		break;
		case 3:
			mesDesc = 'MARZO';
		break;
		case 4:
			mesDesc = 'ABRIL';
		break;
		case 5:
			mesDesc = 'MAYO';
		break;
		case 6:
			mesDesc = 'JUNIO';
		break;
		case 7:
			mesDesc = 'JULIO';
		break;
		case 8:
			mesDesc = 'AGOSTO';
		break;
		case 9:
			mesDesc = 'SEPTIEMBRE';
		break;
		case 10:
			mesDesc = 'OCTUBRE';
		break;
		case 11:
			mesDesc = 'NOVIEMBRE';
		break;
		case 12:
			mesDesc = 'DICIEMBRE';
		break;
		default:
			mesDesc = 'ENERO';
	}
	$('#periodoDes').val(mesDesc + ' ' + anio);
}

function esFechaValida(fecha){
	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de Fecha Inválido (aaaa-mm-dd)");
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
			if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
			break;
		default:
			mensajeSis("Fecha Inválida.");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha Inválida.");
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
function primerDia(){
	var fechainicial = $('#fechaInicio').val();
	var anio = fechainicial.substring(0, 4);
	var mes = fechainicial.substring(5, 7);
	return primerDiaMes = anio + '-' + mes + '-01';
}
