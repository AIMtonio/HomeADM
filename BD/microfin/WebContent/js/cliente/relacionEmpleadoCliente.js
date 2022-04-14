var catTipoConsultaEmpleados = {
'principal' : 1,
'sinEstatus' : 5

};

$(document).ready(function() {
	esTab = false;
	var tab2 = false;
	var contEmp = 0;
	var contParen = 0;
	var contCli = 0;

	//Definicion de Constantes y Enums  
	var catTipoTransaccionRelacion = {
	'agrega' : '1',
	'modifica' : '2'
	};

	var catTipoConsultaRelacion = {
	'principal' : 1,
	'foranea' : 2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	$('#empleadoID').focus();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler : function(event) {

			if (contCli == 0 && contParen == 0 && contPuesto == 0 && contCURP == 0 && contRFC == 0 && contnomCli == 0) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'empleadoID', 'funcionExito', 'funcionError');
			} else {
				verificarVacios();
			}

		}
	});

	$('#grabar').click(function() {
		validaFormGrid();
		var numeroEmpleado = $('#empleadoID').val();
		if(numeroEmpleado > 0){
			$('#tipoTransaccion').val(catTipoTransaccionRelacion.modifica);
		}
		else{
			$('#tipoTransaccion').val(catTipoTransaccionRelacion.agrega);
		}
		
		creaRelacionesCliente();
	});

	$('#clienteID').blur(function() {
		if (esTab) {
			consultaCliente(this.id);
		}
	});

	$('#parentescoID').blur(function() {
		consultaParentesco(this.id);
	});

	$('#clienteID').bind('keyup', function(e) {
		listaAlfanumerica('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').bind('keyup', function(e) {
		if ($('#clienteID').val().length < 3) {
			$('#cajaListaCte').hide();
		}
	});

	
	$('#CURPEmpleado').blur(function() {
		$('#porcAcciones').focus();
	});

	$('#puestoEmpleadoID').bind('keyup', function(e) {
		lista('puestoEmpleadoID', '2', '1', 'descripcionPuesto', $('#puestoEmpleadoID').val(), 'listaPuestosRelacionado.htm');
	});

	$('#puestoEmpleadoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if (isNaN($('#puestoEmpleadoID').val())) {
			$('#puestoEmpleadoID').val("");
			$('#puestoEmpleadoID').focus();
			tab2 = false;
		} else {
				esTab = true;
				if (tab2 == false && esTab) {				
					
					consultaPuestoRel();

				}

			
		}
	});

	$('#empleadoID').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreEmpleado";
			parametrosLista[0] = $('#empleadoID').val();
			listaAlfanumerica('empleadoID', '1', '1', camposLista, parametrosLista, 'listaRelacionEmpresa.htm');
		}
	});

	$('#empleadoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);

		if (isNaN($('#empleadoID').val())) {
			$('#empleadoID').val("");
			$('#empleadoID').focus();
			tab2 = false;
		} else {
			if ($('#empleadoID').asNumber() == 0 && esTab) {
				consultaRelaciones();
				$("#nombreEmpleado").val("");
				$("#CURPEmpleado").val("");
				$("#RFCEmpleado").val("");
				$("#puestoEmpleadoID").val("");
				$("#descPuestoEmpleadoID").val("");
				$("#porcAcciones").val("");
				habilitaControl('nombreEmpleado');
				habilitaControl('CURPEmpleado');
				habilitaControl('RFCEmpleado');
				habilitaControl('puestoEmpleadoID');

			} else {
				if (tab2 == false && esTab) {
					esTab = true;
					validaEmpleado(this.id);
					habilitaControl('puestoEmpleadoID');

				}

			}
		}

	});

	$('#buscarMiSuc').click(function() {
		listaCte('clienteID', '3', '19', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function() {
		listaCte('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules : {
			nombreEmpleado : {
			required : true,
			minlength : 1
			},
			CURPEmpleado : {
			required : true,
			maxlength : 18
			},
			RFCEmpleado : {
			required : true,
			maxlength : 13
			},
			porcAcciones : {
				required: true,
				range: [0, 100]
			},
			puestoEmpleadoID: {
				required: true,
			}
		},
		messages : {
			nombreEmpleado : {
			required : 'Especifique nombre ',
			minlength : 'Al menos 1 Carácter'
			},
		
			CURPEmpleado : {
			required : 'Especifique CURP ',
			minlength : 'Al menos 1 Carácter'
			},
			RFCEmpleado : {
			required : 'Especifique RFC ',
			minlength : 'Al menos 1 Carácter'
			},
			porcAcciones : {
				required:'Especifique Porcentaje Acciones',
				range: 'Solo se permiten valores del 0 al 100.'
			},
			puestoEmpleadoID:{
				required: 'Especifique el Puesto'
			}
		}
	});

	//------------ Validaciones de Controles -------------------------------------
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != '' && !isNaN(numCliente) && numCliente > 0) {
			clienteServicio.consulta(tipConForanea, numCliente, function(cliente) {
				if (cliente != null) {
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					if (cliente.estatus == 'I') {
						mensajeSis("El " + $('#varSafilocale').val() + " se encuentra Inactivo");
						$('#clienteID').val('');
						$('#nombreCliente').val('');
						$('#clienteID').focus();
						$('#clienteID').select();
						deshabilitaBoton('grabar', 'submit');
						$('#gridRelaciones').html("");
						$('#gridRelaciones').hide();
					} else {
						consultaRelaciones();
					}
				} else {
					clienteexiste = 1;
					mensajeSis("No Existe el " + $('#varSafilocale').val());
					$('#clienteID').val('');
					$('#nombreCliente').val('');
					$('#clienteID').focus();
					$('#clienteID').select();
					deshabilitaBoton('grabar', 'submit');
					$('#gridRelaciones').html("");
					$('#gridRelaciones').hide();
				}
			});
		} else {
			if (isNaN(numCliente)) {
				mensajeSis("No Existe el " + $('#varSafilocale').val());
				$('#clienteID').val('');
				$('#nombreCliente').val('');
				$('#clienteID').focus();
				$('#clienteID').select();
				deshabilitaBoton('grabar', 'submit');
				$('#gridRelaciones').html("");
				$('#gridRelaciones').hide();
			} else {
				if (numCliente == '' || numCliente == 0) {
					$('#clienteID').val('');
				}
			}

		}
	}

	function creaRelacionesCliente() {
		var contador = 1;
		$('#lisClientes').val("");
		$('#lisParentesco').val("");
		$('#lisPuestos').val("");
		$('#lisCURP').val("");
		$('#lisRFC').val("");
		$('#lisNomClientes').val("");

		contador = 1;
		$('input[name=idCliente]').each(function() {
			if (this.value == '')
				this.value = 0;
			if (contador != 1) {
				$('#lisClientes').val($('#lisClientes').val() + ',' + this.value);
			} else {
				$('#lisClientes').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=parentescoID]').each(function() {
			if (contador != 1) {
				$('#lisParentesco').val($('#lisParentesco').val() + ',' + this.value);
			} else {
				$('#lisParentesco').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=puestoID]').each(function() {
			if (contador != 1) {
				$('#lisPuestos').val($('#lisPuestos').val() + ',' + this.value);
			} else {
				$('#lisPuestos').val(this.value);
			}
			contador = contador + 1;
		});

		contador = 1;
		$('input[name=CURP]').each(function() {
			if (contador != 1) {
				$('#lisCURP').val($('#lisCURP').val() + ',' + this.value);
			} else {
				$('#lisCURP').val(this.value);
			}
			contador = contador + 1;
		});

		contador = 1;
		$('input[name=RFC]').each(function() {
			if (contador != 1) {
				$('#lisRFC').val($('#lisRFC').val() + ',' + this.value);
			} else {
				$('#lisRFC').val(this.value);
			}
			contador = contador + 1;
		});

		contador = 1;
		$('input[name=nombre]').each(function() {
			if (contador != 1) {
				$('#lisNomClientes').val($('#lisNomClientes').val() + ',' + this.value);
			} else {
				$('#lisNomClientes').val(this.value);
			}
			contador = contador + 1;
		});
	}

	function validaFormGrid() {
		var idCliente = document.getElementById('empleadoID').value;
		contCli = 0;
		$('input[name=idCliente]').each(function() {
			if (isEmpty(this.value) || isNaN(this.value)) {
				contCli++;
			}
		});

		contParen = 0;
		$('input[name=parentescoID]').each(function() {
			if (isEmpty(this.value) || isNaN(this.value)) {
				contParen++;
			}
		});

		contPuesto = 0;
		$('input[name=puestoID]').each(function() {
			if (isEmpty(this.value) || isNaN(this.value)) {
				contPuesto++;
			}
		});

		contCURP = 0;
		$('input[name=CURP]').each(function() {
			if (isEmpty(this.value)) {
				contCURP++;
			}
		});

		contRFC = 0;
		$('input[name=RFC]').each(function() {
			if (isEmpty(this.value)) {
				contRFC++;
			}
		});

		contnomCli = 0;
		$('input[name=nombre]').each(function() {
			if (isEmpty(this.value)) {
				contnomCli++;
			}
		});
	}

	function isEmpty(obj) {
		if (typeof obj == 'undefined' || obj === null || obj === '')
			return true;
		if (typeof obj == 'number' && isNaN(obj))
			return true;
		if (obj instanceof Date && isNaN(Number(obj)))
			return true;
		return false;
	}

});

function consultaParentesco(idControl) {

	var idControl = idControl.replace(/\D/g,'');
	var jqParentesco = eval("'#parentesco" + idControl + "'");
	var numParentesco = $(jqParentesco).val();
	var tipConPrincipal = 3;
	setTimeout("$('#cajaLista').hide();", 200);
	var ParentescoBean = {
		'parentescoID' : numParentesco
	};
	if (numParentesco != '' && !isNaN(numParentesco)) {
		parentescosServicio.consultaParentesco(tipConPrincipal, ParentescoBean, {
		async : false,
		callback : function(parentesco) {
			if (parentesco != null) {
				$('#descParen' + idControl).val(parentesco.descripcion);
				$('#tipoRelacion' + idControl).val(parentesco.tipo);
				$('#grado' + idControl).val(parentesco.grado);
				$('#linea' + idControl).val(parentesco.linea);
			} else {
				mensajeSis("No Existe el Parentesco");
				$(jqParentesco).focus();
			}
		}
		});
	}
}

function consultaPuesto(idControl) {
	var idControl = idControl.replace(/\D/g,'');

	var jqPuesto = eval("'#puestoID" + idControl + "'");
	var numPuesto = $(jqPuesto).val();
	var conPuesto = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	var PuestoBeanCon = {
		'puestoRelID' : numPuesto
	};
	if (numPuesto != '' && !isNaN(numPuesto)) {
		puestosRelacionadoServicio.consulta(conPuesto, PuestoBeanCon, {
		async : false,
		callback : function(puestos) {
			if (puestos != null) {
				$('#descPuesto' + idControl).val(puestos.descripcionPuesto);
			}
		}
		});
	}
}

function consultaPuestoRel() {

	var numPuesto = $('#puestoEmpleadoID').val()
	var conPuesto = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	var PuestoBeanCon = {
		'puestoRelID' : numPuesto
	};
	if (numPuesto != '') {
		puestosRelacionadoServicio.consulta(conPuesto, PuestoBeanCon, {
		async : false,
		callback : function(puestos) {
			if (puestos != null) {
				$('#descPuestoEmpleadoID').val(puestos.descripcionPuesto);
			} else {

				mensajeSis("No Existe el Puesto");
				$('#puestoEmpleadoID').focus();
				$('#puestoEmpleadoID').val("");
				$('#puestoEmpleadoID').select();

			}

		}
		});
	}
}

//Función que verifica que los campos no esten vacios
function verificarVacios() {

	$('tr[name=renglon]').each(function() {
		var numero = this.id.substr(7, this.id.length);
		var jqCliente = eval("'#cliente" + numero + "'");
		var jqNomCliente = eval("'#nombre" + numero + "'");
		var jqCURP = eval("'#CURP" + numero + "'");
		var jqRFC = eval("'#RFC" + numero + "'");
		var jqPuestoID = eval("'#puestoID" + numero + "'");
		var jqParantesco = eval("'#parentesco" + numero + "'");
		var numCliente = $(jqCliente).val();
		var numPuesto = $(jqPuestoID).val();
		var numParentesco = $(jqParantesco).val();

		if (isNaN(numCliente) || numCliente == '') {
			mensajeSis('Especificar un ' + $('#varSafilocale').val());
			$(jqCliente).focus();
			$(jqCliente).val("");
			return false;
		} else if ($(jqNomCliente).val() == '') {
			$(jqNomCliente).focus();
			mensajeSis('Especificar Nombre Cliente');
			return false;
		} else if ($(jqCURP).val() == '') {
			$(jqCURP).focus();
			mensajeSis('Especificar CURP');
			return false;
		} else if ($(jqRFC).val() == '') {
			$(jqRFC).focus();
			mensajeSis('Especificar RFC');
			return false;
		} else if (isNaN(numPuesto) || numPuesto == '') {
			$(jqPuestoID).focus();
			mensajeSis('Especificar Puesto');
			$(jqPuestoID).val("");
			return false;
		} else if (isNaN(numParentesco) || numParentesco == '') {
			$(jqParantesco).focus();
			mensajeSis('Especificar Parentesco');
			$(jqParantesco).val("");
			return false;
		}

	});
}

function consultaClienteRel(idControl) {
	var idControl = idControl.replace(/\D/g,'');
	var jqCliente = eval("'#cliente" + idControl + "'");
	var numCliente = $(jqCliente).val();
	var tipConForanea = 1;
	setTimeout("$('#cajaLista').hide();", 200);

	if (numCliente != '' && !isNaN(numCliente) && esTab) {
		clienteServicio.consulta(tipConForanea, numCliente, function(cliente) {
			if (cliente != null) {
				$('#nombre' + idControl).val(cliente.nombreCompleto);
				$('#CURP' + idControl).val(cliente.CURP);
				$('#RFC' + idControl).val(cliente.RFC);
			} else {
				clienteexiste = 1;
				mensajeSis("No Existe el " + $('#varSafilocale').val());
			}
		});
	}
}

function validaEmpleado(control) {
	var numEmpleado = $('#empleadoID').val();
	var empleadoBeanCon = {
		'empleadoID' : $('#empleadoID').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numEmpleado != '' && !isNaN(numEmpleado) && esTab) {
		relacionEmpleadoClienteServicio.consultaRelacion(catTipoConsultaEmpleados.principal, empleadoBeanCon, function(empleados) {
			if (empleados != null) {

				var nombreCompleto = empleados.nombreEmpleado;
				$('#nombreEmpleado').val(nombreCompleto);
				$('#CURPEmpleado').val(empleados.CURPEmpleado);
				$('#RFCEmpleado').val(empleados.RFCEmpleado);
				$('#puestoEmpleadoID').val(empleados.puestoEmpleadoID);
				$('#porcAcciones').val(empleados.porcAcciones);
				consultaPuestoRel();

				consultaRelaciones();

			} else {
				if (esTab = true) {
					mensajeSis("No Existe el Empleado");
					$('#empleadoID').select();
				}
			}
		});

	}
}

function consultaRelaciones() {
	var numEmpleado = $('#empleadoID').val();

	if (numEmpleado != '' && !isNaN(numEmpleado)) {
		var params = {};
		params['tipoLista'] = 3;
		params['empleadoID'] = numEmpleado;
		params['nombreEmpleado'] = "";

		$.post("gridRelacionEmpleadoCliente.htm", params, function(data) {
			if (data.length > 0) {
				$('#gridRelaciones').html(data);
				$('#gridRelaciones').show();
				habilitaBoton('grabar', 'submit');

				

				if ($('#numeroRelaciones').val() == 0) {
					deshabilitaBoton('grabar', 'submit');
				}

			} else {

				$('#gridRelaciones').html("");
				$('#gridRelaciones').show();
				deshabilitaBoton('grabar', 'submit');
			}
		});
	} else {
		$('#gridRelaciones').hide();
		$('#gridRelaciones').html('');
		deshabilitaBoton('grabar', 'submit');
	}
}

function limpiaGrid() {
	$('input[name=idCliente]').each(function() {
		if (this.value == 0) {
			$(this).val('');
		}
	});
	$('input[name=idEmpleado]').each(function() {
		if (this.value == 0) {
			$(this).val('');
		}
	});

}

//Función de éxito en la transación
function funcionExito() {

	var jQmensaje = eval("'#ligaCerrar'");
	if ($(jQmensaje).length > 0) {
		mensajeAlert = setInterval(function() {
			if ($(jQmensaje).is(':hidden')) {
				clearInterval(mensajeAlert);

				$('#gridRelaciones').html("");
				$('#gridRelaciones').hide();
				$('#empleadoID').focus();

				$('#nombreEmpleado').val("");
				$('#puestoEmpleadoID').val("");
				$('#descPuestoEmpleadoID').val("");
				$('#nombreEmpleado').val("");
				$('#CURPEmpleado').val("");
				$('#RFCEmpleado').val("");
				$("#porcAcciones").val("");
				

				deshabilitaBoton('grabar', 'submit');
			}
		}, 50);
	}

}

//función de error en la transacción
function funcionError() {

}
