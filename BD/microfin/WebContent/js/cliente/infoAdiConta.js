var esTab = false;
var enum_transaccion = {
	'agrega': 1,
	'modifica' :2
};
$(document).ready(function() {

	inicializa();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$('#formaGenerica').validate({
		rules: {
			acreditado: {
				required: true,
			},
			tipoEntidad: {
				required: true,
			}
		},

		messages: {
			acreditado: {
				required: 'Especifique el número del Acreditado',
			},
			tipoEntidad: {
				required: 'Seleccione el tipo de Entidad'
			}
		}
	});

	$('#idAcreditado').bind('keyup', function(e) {
		lista('idAcreditado', '3', '1', 'nombreCompleto', $('#idAcreditado').val(), 'listaCliente.htm');
	});

	$('#idAcreditado').blur(function() {
		if (esTab) {
			consultaCliente();
		}
	});

	$('#agrega').click(function(event) {
		$('#tipoTransaccion').val(enum_transaccion.agrega);
		if ($("#formaGenerica").valid()) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'idAcreditado', 'exito', 'error');
		}
	});

	$('#modifica').click(function(event) {
		$('#tipoTransaccion').val(enum_transaccion.modifica);
		if ($("#formaGenerica").valid()) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'idAcreditado', 'exito', 'error');
		}
	});
});

function inicializa() {
	$("#idAcreditado").focus();
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton("agrega", 'submit');
	deshabilitaBoton("modifica", 'submit');
}

function exito(){
	limpiaFormaCompleta('formaGenerica', true, [ 'idAcreditado']);

		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modifica', 'submit');
		$("#idAcreditado").focus();
		$("#idAcreditado").select();
}

function error(){

}

function consultarSubform(val, datos) {
	var beanSolicitudes = {
		'tipoSub' : val
	};
	bloquearPantalla();
	$.post("informacionAdiContSub.htm", beanSolicitudes, function(data) {
		if (data.length > 0) {
			$("#subform").html(data);
			dwr.util.setValues(datos);
			$("#subform").show();
			if(datos.mostrarSi == 'S'){
				mostrarElementoPorClase("mostrarSi","S");
			} else {
				mostrarElementoPorClase("mostrarSi","N");
				$("#NumeroLineasNeg").val("0");
				$("#ProcesoAuditoria").val("0");
				$("#NivelPoliticas").val("0");
				$("#PeriodosAudEdoFin").val("0");
			}
			var ConocCteBeanCon = {
				'clienteID' : $('#idAcreditado').val()
			};
			conocimientoCteServicio.consulta(1, ConocCteBeanCon, function(conocimiento) {
				if (conocimiento != null) {
					$('#capitalContable').val(conocimiento.capitalContable);
				}
			});
			if (val == 1) {
				$("#formaGenerica input[name^='procesoAuditoria']").each(function() {

					$(this).rules("add", {
					rules : {
						required : true
					},
					messages : {
						required : "Especificar Cumple conta gubernamental.",
					}
					});
					if($("input[name='competencia']:checked").val()==null || $("input[name='competencia']:checked").val()==undefined || $("input[name='competencia']:checked").val()==""){
						$('#Competencia1').attr('checked', true);
					}

					if($("input[name='proveedores']:checked").val()==null || $("input[name='proveedores']:checked").val()==undefined || $("input[name='proveedores']:checked").val()==""){
						$('#Proveedores1').attr('checked', true);
					}
				});
				$("#formaGenerica input[name^='emisionTitulos']").each(function() {
					$(this).rules("add", {
					rules : {
						required : true
					},
					messages : {
						required : "Especificar Emisión de títulos.",
					}
					});
				});
				$("#formaGenerica input[name^='procesoAuditoria']").each(function() {
					$(this).rules("add", {
					rules : {
						required : true
					},
					messages : {
						required : "Especificar Proceso auditoría.",
					}
					});
				});
				$("#formaGenerica input[name^='nivelPoliticas']").each(function() {
					$(this).rules("add", {
					rules : {
						required : true
					},
					messages : {
						required : "Especificar Nivel de políticas.",
					}
					});
				});
				$("#formaGenerica input[name^='periodosAudEdoFin']").each(function() {
					$(this).rules("add", {
					rules : {
						required : true
					},
					messages : {
						required : "Especificar Periodo Aud. Edos. Fin.",
					}
					});
				});
			}
			if(val==2){
				$("#formaGenerica input[name^='entidadRegulada']").each(function(){
				$(this).rules("add", {
					rules :{
					required : true
					},
					messages : {
					required : "Especificar Si es una Entidad regulada.",
					}
				});
				});
				$("#formaGenerica input[name^='emisionTitulos']").each(function(){
					$(this).rules("add", {
						rules :{
						required : true
						},
						messages : {
						required : "Especificar Emisión de títulos.",
						}
					});
				});
			}
			if(val==3){
				$("#formaGenerica input[name^='periodosAudEdoFin']").each(function(){
					$(this).rules("add", {
						rules :{
						required : true
						},
						messages : {
						required : "Especificar Periodo Aud. Edos. Fin.",
						}
					});
				});
			}

			agregaFormatoControles('formaGenerica');
		} else {
			$("#subform").html('');
			$("#subform").hiden();
		}
		desbloquearPantalla();
	});
}

function consultaCliente() {
	var numCliente = $('#idAcreditado').asNumber();
	setTimeout("$('#cajaLista').hide();", 200);
	var bean={
		'acreditado': numCliente
	};
	if (numCliente > 0) {
		infoAdiContaServicio.consulta(1, bean, {
			callback : function(cliente) {
				if (cliente != null) {
					$("#idNombreAcreditado").val(cliente.nombreAcreditado);
					$("#idTipoSociedad").val(cliente.tipoSociedad);
					if(cliente.tipoTransaccion==1){
						habilitaBoton("agrega", 'submit');
						deshabilitaBoton("modifica", 'submit');
					} else {
						deshabilitaBoton("agrega", 'submit');
						habilitaBoton("modifica", 'submit');
					}
					if(cliente.tipoSub!=0){
						consultarSubform(cliente.tipoSub, cliente);
					} else {
						deshabilitaControl('idTipoEntidad');
						$("#subform").html('');
						$("#subform").hide();
					}
					agregaFormatoControles('formaGenerica');
				}else{
					mensajeSis('El Cliente no Existe');
					$("#idNombreAcreditado").val();
					$("#idTipoSociedad").val();
					$("#idTipoEntidad").val();
					$("#idAcreditado").focus();
				}
			},
			errorHandler:function(errorString, exception){
				mensajeSis(errorString+"-"+ exception);
			}
		});
	}
}

function calculaROE(){
	var utilidadNeta = $("#utilidaNeta").asNumber();
	var capitalContable = $("#capitalContable").asNumber();
	var numCliente = $("#idAcreditado").asNumber();

	var ConocCteBeanCon = {
		'clienteID' : numCliente
	};
	conocimientoCteServicio.consulta(1, ConocCteBeanCon,  { async:false, callback : function(conocimiento) {
		if (conocimiento != null) {
			capitalContable = conocimiento.capitalContable;
			if(capitalContable>0){
				$("#ROE").val(utilidadNeta/capitalContable);
			} else {
				$("#ROE").val("0.0");
			}
			agregaFormatoControles('formaGenerica');
		}
	}});
}

function calculaMargenFin(){
	var IngresoTotales = $("#IngresosTotales").asNumber();
	var GastosAdmin = $("#GastosAdmin").asNumber();
	if(IngresoTotales>0){
		$("#margenFinan").val(IngresoTotales/GastosAdmin);
	} else {
		$("#margenFinan").val("0.0");
	}
	agregaFormatoControles('formaGenerica');
}