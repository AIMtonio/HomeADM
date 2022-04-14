var esTab = true;

//Definicion de Constantes y Enums  
var catTipoTransaccionOpIntPreocupantes = {
	'actualizar' : 1
};

var catTipoConsultaOpIntPreocupantes = {
	'principal' : 1

};
var tipoOperacion = 2;
$(document).ready(function() {

	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('adjuntar', 'submit');
	$('#opeInterPreoID').focus();

	$(':text').focus(function() {
		esTab = false;
	});
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#opeInterPreoID').focus(function() {
		esTab = true;
		deshabilitaBoton('grabar', 'submit');
		deshabilitaBoton('adjuntar', 'submit');
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			$('#comentarioOC').val(limpiaDeSaltosLinea('comentarioOC'));
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'opeInterPreoID');
			$('#estatus').val("-1").selected = true;
			$('#frecuencia2').attr("checked", "1");
			$('#involucraCliente2').attr("checked", "1");
			$('#involucraCliente').attr('checked', false);
			$('#descripcionF').hide(500);
			$('#desFrecuencia').hide(500);
			$('#clienteInv').hide(500);
			$('#gridArchivos').hide(500);
			$('#cteInvolucrado').hide(500);
		}
	});

	$('#opeInterPreoID').bind('keyup', function(e) {
		lista('opeInterPreoID', '2', '6', 'opeInterPreoID', $('#opeInterPreoID').val(), 'listapldOpeIntPreocupantes.htm');
	});

	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionOpIntPreocupantes.actualizar);
	});

	$('#opeInterPreoID').blur(function() {
		validaOpIntPreocupante(this.id);
	});

	$('#comentarioOC').blur(function() {
		$('#comentarioOC').val(limpiaDeSaltosLinea('comentarioOC'));
	});

	consultaEstatus();

	$('#formaGenerica').validate({
		rules : {
			catMotivPreoID : {
				required : true
			},
			catProcedIntID : {
				required : true
			},
			nomPersonaInv : {
				required : true
			},
			desOperacion : {
				required : true
			},
			comentarioOC : {
				required : function() {
					return $('#estatus').val() == 3 || $('#estatus').val() == 4;;
				},
				maxlength : 1500,
			}
		},
		messages : {
		
			catMotivPreoID : {
				required : 'Especifique Tipo de Persona'
			},
		
			catProcedIntID : {
				required : 'Especifique Categoria'
			},
		
			nomPersonaInv : {
				required : 'Especifique Nombre'
			},
		
			desOperacion : {
				required : 'Especifique una Descripcion'
			},
			comentarioOC : {
				required : 'Especifique Comentario',
				maxlength : 'Máximo 1500 Caracteres'
			}
		}
	});

	$('#adjuntar').click(function() {
		subirArchivos();
	});
});
//----------Funcion consultaCategoria---------------------//
function consultaCategoria(idControl) {
	var jqCategoria = eval("'#" + idControl + "'");
	var numCategoria = $(jqCategoria).val();
	var conCategoria = 3;
	var categoriaBeanCon = {
		'categoriaID' : numCategoria
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCategoria != '' && esTab) {
		puestosServicio.consulta(conCategoria, categoriaBeanCon, function(categorias) {
			if (categorias != null) {
				$('#descripcionCategoria').val(categorias.descripcionCategoria);

			}
		});
	}
}

//----------Funcion consultaMotivo---------------------//
function consultaMotivo(idControl) {
	var jqMotivo = eval("'#" + idControl + "'");
	var numMotivo = $(jqMotivo).val();
	var conMotivo = 1;
	var motivoBeanCon = {
		'catMotivPreoID' : numMotivo
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numMotivo != '' && esTab) {
		motivosPreoServicio.consulta(conMotivo, motivoBeanCon, function(motivos) {
			if (motivos != null) {
				$('#descripcionMotivo').val(motivos.desLarga);

			}
		});
	}
}

//----------Funcion consultaProcedimientoInterno---------------------//
function consultaProcInt(idControl) {
	var jqProc = eval("'#" + idControl + "'");
	var numProc = $(jqProc).val();
	var conProc = 1;
	var procBeanCon = {
		'catProcedIntID' : numProc
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numProc != '' && esTab) {
		procInternosServicio.consulta(conProc, procBeanCon, function(procedimientos) {
			if (procedimientos != null) {
				$('#descripcionProceso').val(procedimientos.descripcion);

			}
		});
	}
}

// ////////////////funcion consultar sucursal////////////////
function consultaSucursal(idControl) {
	var jqSucursal = eval("'#" + idControl + "'");
	var numSucursal = $(jqSucursal).val();
	var conSucursal = 2;

	setTimeout("$('#cajaLista').hide();", 200);
	if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
		sucursalesServicio.consultaSucursal(conSucursal, numSucursal, function(sucursal) {
			if (sucursal != null) {
				$('#descripcionSucursal').val(sucursal.nombreSucurs);

			}
		});
	}
}

// ////////////////funcion consultar empleado////////////////
function consultaEmpleado(idControl) {
	var jqEmpleado = eval("'#" + idControl + "'");
	var numEmpleado = $(jqEmpleado).val();
	var conEmpleado = 1;
	var empleadoBeanCon = {
		'empleadoID' : numEmpleado
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numEmpleado != '' && !isNaN(numEmpleado) && esTab) {
		empleadosServicio.consulta(conEmpleado, empleadoBeanCon, function(empleados) {
			if (empleados != null) {
				$('#nomPersonaInv').val(empleados.nombre);

			}
		});
	}
}
function validaOpIntPreocupante(control) {
	var numOperacion = $('#opeInterPreoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numOperacion != '' && !isNaN(numOperacion) && esTab) {
		if (numOperacion == 0) {
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('adjuntar', 'submit');
			deshabilitaControl('fechaDeteccion');
			deshabilitaControl('catMotivPreoID');
			deshabilitaControl('categoriaID');
			deshabilitaControl('sucursalID');
			deshabilitaControl('catProcedIntID');
			deshabilitaControl('clavePersonaInv');
			deshabilitaControl('nomPersonaInv');
			deshabilitaControl('frecuencia');
			deshabilitaControl('frecuencia2');
			deshabilitaControl('involucraCliente');
			deshabilitaControl('involucraCliente2');
			$('#cteInvolucrado').attr('readonly', true);
			deshabilitaControl('estatus');
			deshabilitaControl('fechaCierre');
			$('#comentarioOC').attr('readonly', true);
			inicializaForma('formaGenerica', 'opeInterPreoID');
			$('#frecuencia2').attr("checked", "1");
			$('#estatus').val("-1").selected = true;
			$('#involucraCliente').click(function() {
				if ($('#involucraCliente').is(':checked')) {
					$('#involucraCliente2').attr('checked', false);
				}
			});
			$('#involucraCliente2').click(function() {
				if ($('#involucraCliente2').is(':checked')) {
					$('#involucraCliente').attr('checked', false);
				}
			});
		} else {
			habilitaBoton('grabar', 'submit');
			habilitaBoton('adjuntar', 'submit');
			deshabilitaControl('fechaDeteccion');
			deshabilitaControl('catMotivPreoID');
			deshabilitaControl('categoriaID');
			deshabilitaControl('sucursalID');
			deshabilitaControl('catProcedIntID');
			deshabilitaControl('clavePersonaInv');
			deshabilitaControl('nomPersonaInv');
			deshabilitaControl('frecuencia');
			deshabilitaControl('frecuencia2');
			deshabilitaControl('involucraCliente');
			deshabilitaControl('involucraCliente2');
			deshabilitaControl('cteInvolucrado');
			habilitaControl('estatus');
			$('#comentarioOC').removeAttr('readOnly', true);

			var opIntPreocupantesBeanCon = {
				'opeInterPreoID' : $('#opeInterPreoID').val()

			};

			var parametroBean = consultaParametrosSession();
			var usuariosesion = parametroBean.nombreUsuario;
			opIntPreocupantesServicio.consulta(catTipoConsultaOpIntPreocupantes.principal, opIntPreocupantesBeanCon, function(opIntPreocupantes) {
				if (opIntPreocupantes != null) {
					var empleadoinvolucrado = opIntPreocupantes.nomPersonaInv;
					if (empleadoinvolucrado != usuariosesion) {
						dwr.util.setValues(opIntPreocupantes);
						esTab = true;
						consultaCategoria('categoriaID');
						consultaMotivo('catMotivPreoID');
						consultaProcInt('catProcedIntID');
						consultaSucursal('sucursalID');

						if (opIntPreocupantes.cteInvolucrado != null) {
							$('#involucraCliente').attr("checked", "1");
						} else {
							$('#involucraCliente2').attr("checked", "1");
						}
						if (opIntPreocupantes.fechaCierre == '1900-01-01') {
							$('#fechaCierre').val('');
						} else {
							$('#fechaCierre').val(opIntPreocupantes.fechaCierre);
						}
						if (opIntPreocupantes.categoriaID == '0') {
							$('#categoriaID').val('');
						} else {
							$('#categoriaID').val(opIntPreocupantes.categoriaID);
						}
						if (opIntPreocupantes.sucursalID == '0') {
							$('#sucursalID').val('');
						} else {
							$('#sucursalID').val(opIntPreocupantes.sucursalID);
						}
						if (opIntPreocupantes.clavePersonaInv == '0') {
							$('#clavePersonaInv').val('');
						} else {
							$('#clavePersonaInv').val(opIntPreocupantes.clavePersonaInv);
						}

						if (opIntPreocupantes.frecuencia == 'S') {
							$('#frecuencia').attr("checked", "1");
							$('#descripcionF').show(500);
							$('#desFrecuencia').show(500);
						} else {
							if (opIntPreocupantes.frecuencia == 'N') {
								$('#frecuencia2').attr("checked", "1");
								$('#descripcionF').hide(500);
								$('#desFrecuencia').hide(500);
							}
						}
						if (opIntPreocupantes.cteInvolucrado == '') {
							$('#involucraCliente2').attr("checked", "1");
							$('#involucraCliente').attr("checked", false);
							$('#clienteInv').hide(500);
							$('#cteInvolucrado').hide(500);
						} else {
							if (opIntPreocupantes.cteInvolucrado != '') {
								$('#involucraCliente').attr("checked", "1");
								$('#involucraCliente2').attr("checked", false);
								$('#clienteInv').show(500);
								$('#cteInvolucrado').show(500);
							}
						}

						if (opIntPreocupantes.estatus == 3 || opIntPreocupantes.estatus == 4) {
							deshabilitaBoton('grabar', 'submit');
							deshabilitaBoton('adjuntar', 'submit');
							deshabilitaControl('estatus');
							$('#comentarioOC').attr('readonly', true);
						} else {
							habilitaBoton('grabar', 'submit');
							habilitaBoton('adjuntar', 'submit');
						}
						consultaArchivos(2, 0,$('#opeInterPreoID').val());
					} else {
						mensajeSis("Su Usuario No tiene Permisos Suficientes para dar Seguimiento a esta Operación.");
						limpiaFormularioPreocu();
					}
				} else {
					mensajeSis("No Existe la Operación");
					limpiaFormularioPreocu();
				}
			});
		}
	}

}
function consultaEstatus() {
	dwr.util.removeAllOptions('estatus');
	dwr.util.addOptions('estatus', {
		0 : 'SELECCIONAR'
	});
	estadosPreocupantesServicio.listaCombo(1, function(estatus) {
		dwr.util.addOptions('estatus', estatus, 'catEdosPreoID', 'descripcion');
	});
}
function limpiaFormularioPreocu() {
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('adjuntar', 'submit');
	inicializaForma('formaGenerica', 'opeInterPreoID');
	$('#estatus').val("-1").selected = true;
	$('#descripcionF').hide(500);
	$('#desFrecuencia').hide(500);
	$('#frecuencia2').attr("checked", "1");
	$('#clienteInv').hide(500);
	$('#cteInvolucrado').hide(500);
	$('#gridArchivos').hide(500);
	$('#opeInterPreoID').val("");
	$('#opeInterPreoID').focus();
	$('#opeInterPreoID').select();
	$('#frecuencia2').attr("checked", "1");
	$('#involucraCliente2').attr("checked", "1");
	if ($('#involucraCliente2').is(':checked')) {
		$('#involucraCliente').attr('checked', false);
	}
}

function limpiaDeSaltosLinea(idControl) {
	var jqTexto = eval("'#" + idControl + "'");
	var texto = $(jqTexto).val();
	texto = texto.split("\n").join(" ");
	return texto;
}
function subirArchivos() {
	var url = "archOperacionesPLDUpload.htm?" + "proceso=2&" + "operacion=" + $('#opeInterPreoID').asNumber();

	var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
	var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;

	window.open(url, "PopUpSubirArchivo", "width=680,height=340,scrollbars=auto,status=yes,location=no,addressbar=0,menubar=0,toolbar=0" + "left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition);

}