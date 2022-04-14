var esTab = false;
var parametrosBean = consultaParametrosSession();
var catTipoConsultaCredito = {
'principal' : 1,
'foranea' : 2
};
var Enum_Transaccion = {
	'cancela': 40
};
$(document).ready(function() {
	inicializarPantalla();
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});
	$.validator.setDefaults({
		submitHandler : function(event) {
			esTab = true;
			if(llenarDetalle() && validaUsuarioAutorizacion()){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'creditoID', "exito", "error");
			}
		}
	});
	$('#formaGenerica').validate({
	rules : {
		creditoID : {
			required : true
		}
	},
	messages : {
		creditoID : {
			required : 'El Crédito es Requerido.',
		}
	}
	});

	$('#creditoID').bind('keyup', function(e) {
		lista('creditoID', '2', '11', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});
	$('#cancelar').click(function() {
		$("#tipoTransaccion").val(Enum_Transaccion.cancela);
	});
	$('#creditoID').blur(function() {
		if (esTab) {
			limpiaFormaCompleta('formaGenerica', true, ['creditoID']);
			$('#gridIntegrantes').html("");
			$('#gridIntegrantes').hide();
			consultaCredito();
		}
	});
});

function inicializarPantalla() {
	$("#creditoID").focus();
	deshabilitaBoton('cancelar', 'submit');
}
function exito() {
	limpiaFormaCompleta('formaGenerica', true, ['creditoID']);
	$("#creditoID").focus();
}
function error() {
	agregaFormatoControles('formaGenerica');
}

function consultaCredito() {
	var creditoBeanCon = {
		'creditoID' : $('#creditoID').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if ($('#creditoID').asNumber() > 0) {
		deshabilitaBoton("cancelar", "submit");
		bloquearPantalla();
		creditosServicio.consulta(18, creditoBeanCon, function(credito) {
			if (credito != null) {
				$("#clienteID").val(credito.clienteID);
				$("#producCreditoID").val(credito.producCreditoID);
				$("#grupoID").val(credito.grupoID);
				$("#montoCredito").val(credito.montoCredito);
				$("#estatus").val(credito.estatus);
				$("#cicloGrupo").val(credito.cicloGrupo);
				
				$("#esGrupal").val('S');
				//Consultar fecha ministrado

				if (credito.estatus == 'V') {
					habilitaBoton("cancelar", "submit");
				}
				descripcionEstatus(credito.estatus, 'estatus');
				consultaCliente();
				consultaProducCreditoForanea(credito.producCreditoID);
				if (credito.grupoID > 0) {
					mostrarElementoPorClase("grupo", true);
					mostrarElementoPorClase("credIndv", false);
					consultaGrupo();
					mostrarIntegrantesGrupo();
				} else {
					mostrarElementoPorClase("grupo", false);
					mostrarElementoPorClase("credIndv", true);
				}
				creditosServicio.consulta(1, creditoBeanCon, function(credito2) {
					if (credito2 != null) {
						$("#fechaMinistrado").val(credito2.fechaMinistrado);
						$("#montoGLAho").val(credito2.aporteCliente);
						$("#fechaInicio").val(credito2.fechaInicioAmor);
					}
				});
				creditosServicio.consulta(17, creditoBeanCon, function(credito3) {
					if (credito3 != null) {
						$("#totalInteres").val(credito3.totalInteres);
					}
				});
				creditosServicio.consulta(11, creditoBeanCon, function(credito4) {
					if (credito4 != null) {
						$("#montoComApertura").val(credito4.comAperPagado);
						$("#IVAComApertura").val(credito4.IVAComApertura);
					}
				});
				
				agregaFormatoControles('formaGenerica');
				desbloquearPantalla();
				if($("#estatus").val()=='CANCELADO'){
					mensajeSis('El Crédito se encuentra Cancelado.');
				}
				
			} else {
				mensajeSis('El Crédito No Existe.');
				$('#creditoID').focus();
			}
			
		});
	}
}

function consultaCliente() {
	var numCliente = $("#clienteID").val();
	if (numCliente != '' && !isNaN(numCliente) && numCliente != '0') {
		clienteServicio.consulta(1, numCliente, {
			callback : function(cliente) {
				if (cliente != null) {
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
				} else {
					mensajeSis("El " + $("#safilocaleCTE").val() + " No Existe.");
					$('#clienteID').val("");
					$('#nombreCliente').val("");
				}
			}
		});
	} else {
		mensajeSis("El " + $("#safilocaleCTE").val() + " No Existe.");
		$('#clienteID').val("");
		$('#nombreCliente').val("");
	}

}
function consultaProducCreditoForanea(producto) {
	var ProdCredBeanCon = {
		'producCreditoID' : producto
	};
	if (producto != '' && !isNaN(producto)) {
		productosCreditoServicio.consulta(1, ProdCredBeanCon, function(prodCred) {
			if (prodCred != null) {
				$('#nombreProducto').val(prodCred.descripcion);
			} else {
				mensajeSis("No Existe el Producto de Crédito");
				$('#nombreProducto').val("");
			}
		});
	} else {
		$('#nombreProducto').val("");
	}
}

function descripcionEstatus(value, idControl) {
	var valorDes = '';
	switch (value) {
		case 'A' :
			valorDes = 'AUTORIZADO';
			break;
		case 'I' :
			valorDes = 'INACTIVO';
			break;
		case 'P' :
			valorDes = 'PAGADO';
			break;
		case 'V' :
			valorDes = 'VIGENTE';
			break;
		case 'K' :
			valorDes = 'CASTIGADO';
			break;
		case 'D' :
			valorDes = 'DESEMBOLSADO';
			break;
		case 'M' :
			valorDes = 'AUTORIZADO';
			break;
		case 'B' :
			valorDes = 'VENCIDO';
			break;
		case 'C' :
			valorDes = 'CANCELADO';
			break;
	};
	if (idControl != null && idControl != undefined) {
		$("#" + idControl).val(valorDes);
	}
	return valorDes;
}

function consultaGrupo() {
	var tipConGrupo = 1;
	var grupoBean = {
	'grupoID' : $("#grupoID").val(),
	'cicloActual' : $('#cicloID').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if ($("#grupoID").asNumber() > 0) {
		gruposCreditoServicio.consulta(tipConGrupo, grupoBean, function(grupo) {
			if (grupo != null) {
				$("#nombreGrupo").val(grupo.nombreGrupo);
			}
		});
	} else {
		$("#grupoID").val("");
		$("#nombreGrupo").val("");
	}
}

function mostrarIntegrantesGrupo() {
	var params = {};
	params['tipoLista'] = 14;
	params['controlIntegrante'] = 1;
	params['grupoID'] = $('#grupoID').val();
	params['ciclo'] = $('#cicloGrupo').val();
	$.post("listaIntegrantesGpo.htm", params, function(data) {
		if (data.length > 0) {
			$('#gridIntegrantes').html(data);
			$('#gridIntegrantes').show();
			validarVigentes();
		} else {
			$('#gridIntegrantes').html("");
			$('#gridIntegrantes').hide();
		}
	});
}

function validaUsuarioAutorizacion(){
	var usuario = $('#usuarioAutoriza').val().trim();
	var usuarioLogeado = parametrosBean.claveUsuario;

	if(usuario != ''){
		if(usuario === usuarioLogeado && esTab){
			mensajeSis('El Usuario que Autoriza no puede ser el mismo que el Usuario Logeado.');
			deshabilitaBoton('desembolsar');
			deshabilitaBoton('cancelar');
			$('#usuarioAutoriza').val('');
			$('#usuarioAutoriza').focus();
			return false;
		} else {
			if(consultaUsuario($('#usuarioAutoriza').val())){
				validarVigentes();
			}
		}
	}
	return true;
}

function validaAutorizacion(){
	var usuario = $('#usuarioAutoriza').val().trim();
	var pass = $('#contraseniaAutoriza').val().trim();

}

function llenarDetalle() {
	quitaFormatoControles('formaGenerica');
	var grupoID = $("#grupoID").asNumber();
	if (grupoID > 0) {
		$('#tbodyIntegrantes tr').each(function(index) {
			var creditoID = $(this).find("input[name^='creditoID']").val();
			var capital = $(this).find("input[name^='capital']").val();
			var interes = $(this).find("input[name^='interes']").val();
			var garantia = $(this).find("input[name^='montoGarantia']").val();
			var montoComAp = $(this).find("input[name^='montoComApertura']").val();
			var montoIVAComAp = $(this).find("input[name^='IVAComisionApert']").val();
			var cancelar = $(this).find("input[name^='creditoIDCheck']").attr("id");
			if ($('#' + cancelar).is(':checked')) {
				if (index == 0) {
					$('#detalleCancelaCred').val($('#detalleCancelaCred').val() + creditoID + ']' 
						+ capital + ']' 
						+ interes + ']' 
						+ garantia + ']'
						+ montoComAp + ']'
						+ montoIVAComAp + ']'
						);
				} else {
					$('#detalleCancelaCred').val($('#detalleCancelaCred').val() + '[' + creditoID + ']' 
						+ capital + ']' 
						+ interes + ']' 
						+ garantia + ']'
						+ montoComAp + ']'
						+ montoIVAComAp + ']'
						);
				}
			}
		});
		if($('#detalleCancelaCred').val()==""){
			mensajeSis("Es necesario seleccionar al menos algún Crédito.");
			return false;
		}
	}
	
	return true;
}

function validarVigentes() {
	var grupoID = $("#grupoID").asNumber();
	deshabilitaBoton("cancelar", "submit");
	if (grupoID > 0) {
		$('#tbodyIntegrantes tr').each(function(index) {
			var estatus = $(this).find("input[name^='estatusCredInt']").val();
			var creditoID = $(this).find("input[name^='creditoIDCheck']").attr('id');
			var creditoIDVal = $(this).find("input[name^='creditoIDInt']").val();
			deshabilitaControl(creditoID);
			if(creditoIDVal === $("#creditoID").val()){
				$('#'+creditoID).attr('checked', true);
				if(estatus == 'V'){
					habilitaBoton("cancelar", "submit");
				}
			}
			
		});
	} else {
		var estatus = $("#estatus").val();
		if(estatus == 'VIGENTE'){
			habilitaBoton("cancelar", "submit");
		}
	}
	return true;
}

function consultaUsuario(claveUsuario) {
	if(claveUsuario != ''){
		var usuarioBeanCon = {
			'clave' : claveUsuario 
		};
		var consultaClave = 3;
		var bandera = false;
		usuarioServicio.consulta(consultaClave,usuarioBeanCon,{async:false, callback:function(usuarioBean) {
			if(usuarioBean!=null){
				bandera = true;
			} else {
				mensajeSis('El Usuario No Existe.');
				$('#usuarioAutoriza').val('');
				$('#contraseniaAutoriza').val('');
				deshabilitaBoton("cancelar", "submit");
				$('#usuarioAutoriza').focus();
			}
		}
		});
		return bandera;
	} else {
		return false;
	}
}