var tipoTransaccion = {
	'alta': 1,
	'elimina': 2,
	'actualizacion': 3,
	'modificacion': 4
};

var tipoConsulta = {
	'empleado': 3
};

var tipoLista = {
	'listaConveniosActivos': 2,
	'listaAyudaEmpleados': 3,
	'listaGridEmpleados': 4
};

var tipoActualizacion = {
	'empleado': 11
};

var tipoEmpleado=0;$('#fechaProgramada').change(function() {
		var Xfecha = $('#fechaProgramada').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha == '')$('#fechaProgramada').val(parametroBean.fechaSucursal);
			var Yfecha = parametroBean.fechaSucursal;
			if (!mayor(Xfecha, Yfecha) && Xfecha != Yfecha){
				mensajeSis("La fecha programada es menor que la fecha de sistema");
				$('#fechaProgramada').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaProgramada').val(parametroBean.fechaSucursal);
		}
	});


$('#convenioNominaID').change(function() {
	setTimeout("$('#cajaLista').hide();", 200);
	if ($('#convenioNominaID').val() !=null && $('#convenioNominaID').val()!="") {
		consultaConvenio($('#convenioNominaID').val(), true);
	}

});

function consultaConvenio(convenioID, valida) {
	var convenioBean = {
		'convenioNominaID': convenioID
	};

	conveniosNominaServicio.consulta(1, convenioBean, function(convenio) {
		if (convenio!=null && convenio !="") {
			if (convenio.manejaQuinquenios=="S"){
				$(".quinquenios").show();
			}else{
				$("#quinquenioID").val("");
				$(".quinquenios").hide();
			}

			if(valida){
				if(convenio.estatus=="V"){
					mensajeSis("El convenio se encuentra en estatus <b>VENCIDO<b>");
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('modificar', 'submit');
					$("#convenioNominaID").focus();
				}
				if(convenio.estatus=="S"){
					mensajeSis("El convenio se encuentra en estatus <b>SUSPENDIDO<b>");
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('modificar', 'submit');
					$("#convenioNominaID").focus();
				}
				if(convenio.estatus=="A"){
					if($("#nominaEmpleadoID").asNumber()==0){
						habilitaBoton('grabar', 'submit');
						deshabilitaBoton('modificar', 'submit');
					}else{
						deshabilitaBoton('grabar', 'submit');
						habilitaBoton('modificar', 'submit');
					}
					setTimeout(function(){
						$('#convenioNominaID').val(convenioID);
					},1000)
				}
			}
			listaTiposEmpleados($('#institNominaID').val(), convenioID);
		}
		else{
			mensajeSis("El convenio no existe");
			$("#convenioNominaID").val("");
			dwr.util.removeAllOptions('tipoEmpleadoID');
			dwr.util.addOptions('tipoEmpleadoID', {'': 'SELECCIONAR'});
		}

	});
}

function listaTiposEmpleados(institucionID, convenioID) {
	beanEntrada = {
		'institNominaID': institucionID,
		'convenioNominaID': convenioID
	};
	tipoEmpleadosConvenioServicio.listaCombo(2, beanEntrada, function(resultado) {
		dwr.util.removeAllOptions('tipoEmpleadoID');
		if (resultado != null && resultado.length > 0) {
			dwr.util.addOptions('tipoEmpleadoID', {'':'SELECCIONAR'});
			dwr.util.addOptions('tipoEmpleadoID', resultado, 'tipoEmpleadoID', 'descripcion');
			if (tipoEmpleado!=0) {
				$('#tipoEmpleadoID').val(tipoEmpleado);
			}
			return;
		}
		dwr.util.addOptions('tipoEmpleadoID', {'': 'NO SE ENCONTRARON TIPOS DE EMPLEADOS'});
	});
}


$('#fechaIngreso').change(function() {
	var Xfecha = $('#fechaIngreso').val();
	if(esFechaValida(Xfecha)){
		if(Xfecha == '')$('#fechaIngreso').val(parametroBean.fechaSucursal);
		var Yfecha = parametroBean.fechaSucursal;
		if (!mayor(Yfecha, Xfecha) && Xfecha != Yfecha){
			mensajeSis("La fecha de Ingreso no puede ser mayor<br> a la fecha del sistema.");
			$('#fechaIngreso').val(parametroBean.fechaSucursal);
			$('#fechaIngreso').focus();
		}
	}
	else{
		$('#fechaProgramada').val(parametroBean.fechaSucursal);
	}
});

function esFechaValida(str) {
	var regEx = /^\d{4}-\d{2}-\d{2}$/;
	if(!str.match(regEx)) return false;  // Formato Invalido
	var d = new Date(str);
	if(!d.getTime() && d.getTime() !== 0) return false; // Fecha Invalida
	return d.toISOString().slice(0,10) === str;
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

$(document).ready(function() {
	esTab = false;
	agregaFormatoControles('formaGenerica');
	$('#clienteID').focus();
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('eliminar', 'submit');
	listaTiposPuestos();
	listaCatQuinquenios();
	tipoEmpleado=0;
	consultaFlujoCliente();
	$('.quinquenios').hide();
	$('#quinquenioID').val("");

	$(':text, :button, :submit, select').focus(function() {
		esTab = false;
	});

	$(':text, :button, :submit, select').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#grabar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.alta);
	});

	$('#modificar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.modificacion);
		$('#tipoActualizacion').val(tipoActualizacion.empleado);
	});

	$('#eliminar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.elimina);
	});

	$('#nominaEmpleadoID').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = 'clienteID';
		camposLista[1] = 'nombreInstNomina';
		parametrosLista[0] = $('#clienteID').val();
		parametrosLista[1] = $('#nominaEmpleadoID').val();
		lista('nominaEmpleadoID', '2', tipoLista.listaAyudaEmpleados, camposLista, parametrosLista, 'nominaEmpleadosListaVista.htm');
	});

	$('#nominaEmpleadoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		habilitaControl('institNominaID');
		habilitaControl('convenioNominaID');
		if((isNaN($('#nominaEmpleadoID').val()) || $('#nominaEmpleadoID').val() == '')) {
			$('#nominaEmpleadoID').val('');
			var valorCliID = $('#clienteID').val();
			var valorCliNombre = $('#nombreCompleto').val();
			$('#formaGenerica')[0].reset();
			$('#clienteID').val(valorCliID);
			$('#nombreCompleto').val(valorCliNombre);
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('modificar', 'submit');
			deshabilitaBoton('eliminar', 'submit');
			habilitaControl('noEmpleado');
			tipoEmpleado=0;
			$("#institNominaID").focus();
		} else {
			if ($('#nominaEmpleadoID').val() == 0) {
				habilitaBoton('grabar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('eliminar', 'submit');
				var valorID = $('#nominaEmpleadoID').val();
				var valorCliID = $('#clienteID').val();
				var valorCliNombre = $('#nombreCompleto').val();
				$('#formaGenerica')[0].reset();
				$('#nominaEmpleadoID').val(valorID);
				$('#clienteID').val(valorCliID);
				$('#nombreCompleto').val(valorCliNombre);
				habilitaControl('noEmpleado');
				tipoEmpleado=0;
				$('#institNominaID').focus();
			} else {
				funcionConsultaEmpleadoNomina(this.id);
				tipoEmpleado=0;
			}
		}
	});

	$('#clienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if((isNaN($('#clienteID').val()) || $('#clienteID').val() == '' || $('#clienteID').val() == 0)) {
			$('#clienteID').val('');
			$('#formaGenerica')[0].reset();
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('eliminar', 'submit');
			$('#formaTabla').hide();
			return;
		}
		funcionConsultaCliente(this.id);
	});

	$('#institNominaID').bind('keyup', function(e) {
		lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		dwr.util.removeAllOptions('tipoEmpleadoID');
		dwr.util.addOptions('tipoEmpleadoID', {'': 'SELECCIONAR'});
		if((isNaN($('#institNominaID').val()) || $('#institNominaID').val() == '' || $('#institNominaID').val() == 0)) {
			$('#institNominaID').val('');
			$('#nombreInstNomina').val('');
			dwr.util.removeAllOptions('convenioNominaID');
			dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
			return;
		}
		funcionConsultaInstitucionNomina(this.id);
	});

	$('#clienteID').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = 'nombreCompleto';
		parametrosLista[0] = $('#clienteID').val();
		lista('clienteID', '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
	});

	$(':text, :button, :submit, textarea, select').blur(function() {
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#clienteID').focus();
			}, 0);
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('modificar', 'submit');
			deshabilitaBoton('eliminar', 'submit');
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'nominaEmpleadoID', 'funcionExito', 'funcionError');
		}
	});

	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true
			},
			nominaEmpleadoID: {
				required: true
			},
			institNominaID: {
				required: function () {
					return $('#nominaEmpleadoID').asNumber() ==  0;
				}
			},
			convenioNominaID: {
				required: function () {
					return $('#nominaEmpleadoID').asNumber() ==  0;
				}
			},
			tipoEmpleadoID: {
				required: true
			},
			puestoOcupacionID: {
				required: true
			},
			noEmpleado: {
				required: true
			},
			fechaIngreso:{
				required: true
			}
		}, messages: {
			clienteID: {
				required: 'Especifique cliente'
			},
			nominaEmpleadoID: {
				required: 'Especifique empleado'
			},
			institNominaID: {
				required: 'Especifique empresa'
			},
			convenioNominaID: {
				required: 'Especifique convenio'
			},
			tipoEmpleadoID: {
				required: 'Especifique tipo'
			},
			puestoOcupacionID: {
				required: 'Especifique puesto'
			},
			noEmpleado:{
				required: 'Especifique número empleado'
			},
			fechaIngreso:{
				required: 'Especifique fecha de ingreso'
			}
		}
	});
});

function funcionConsultaEmpleadoNomina(idControl) {
	var jqControl = eval("'#" + idControl + "'");
	var beanEntrada = {
		'clienteID': $('#clienteID').val(),
		'nominaEmpleadoID': $(jqControl).val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if($(jqControl).val() != '' && !isNaN($(jqControl).val()) && $(jqControl).val() != 0){
		nominaEmpleadosServicio.consulta(tipoConsulta.empleado, beanEntrada, function(resultado) {
			if(resultado != null) {
				dwr.util.setValues(resultado);
				tipoEmpleado=resultado.tipoEmpleadoID;

				if (resultado.quinquenioID!="" && resultado.quinquenioID!=null && resultado.quinquenioID!="0") {
					$('#quinquenioID').val(resultado.quinquenioID);
					$('.quinquenios').show();
				}

				listaConveniosActivos();
				if (resultado.institNominaID!="" && resultado.institNominaID!=0
					&& resultado.convenioNominaID!="" && resultado.convenioNominaID!=0) {
					listaTiposEmpleados(resultado.institNominaID, resultado.convenioNominaID);
					consultaConvenio(resultado.convenioNominaID, true);
				}


				setTimeout(function() {
					$('#convenioNominaID option[value="' + resultado.convenioNominaID + '"]').attr('selected', 'selected');
				}, 450);

				if (resultado.estatusEmp =="B") {
					deshabilitaBoton('modificar', 'submit');
					habilitaBoton('eliminar', 'submit');
				}
				else{
					habilitaBoton('modificar', 'submit');
					deshabilitaBoton('eliminar', 'submit');
				}
				deshabilitaBoton('grabar', 'submit');
				deshabilitaControl('institNominaID');
			} else {
				$('#nominaEmpleadoID').focus();
				mensajeSis('El empleado de nómina no existe');
				var valorID = $('#nominaEmpleadoID').val();
				var valorCliID = $('#clienteID').val();
				var valorCliNombre = $('#nombreCompleto').val();
				$('#formaGenerica')[0].reset();
				$('#nominaEmpleadoID').val(valorID);
				$('#clienteID').val(valorCliID);
				$('#nombreCompleto').val(valorCliNombre);
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('eliminar', 'submit');
				habilitaControl('noEmpleado');
				tipoEmpleado=0;
				$('#quinquenioID').val("");
				$('.quinquenios').hide();
				$('#noPension').val('');

			}
		});
	}
}

function funcionConsultaInstitucionNomina(idControl) {
	var jqControl = eval("'#" + idControl + "'");
	var beanEntrada = {
		'institNominaID': $(jqControl).val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if($(jqControl).val() != '' && !isNaN($(jqControl).val()) && $(jqControl).val() != 0) {
		institucionNomServicio.consulta(1, beanEntrada, function(resultado) {
			if(resultado != null) {
				$('#nombreInstNomina').val(resultado.nombreInstit);
				listaConveniosActivos();
			} else {
				mensajeSis('La empresa de nómina no existe');
				dwr.util.removeAllOptions('convenioNominaID');
				dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
			}
		});
	}
}

function listaConveniosActivos() {
	beanEntrada = {
		'institNominaID': $('#institNominaID').val()
	};

	conveniosNominaServicio.lista(tipoLista.listaAyudaEmpleados, beanEntrada, function(resultado) {
		dwr.util.removeAllOptions('convenioNominaID');
		if (resultado != null && resultado.length > 0) {
			dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
			dwr.util.addOptions('convenioNominaID', resultado, 'convenioNominaID', 'descripcion');
			return;
		}
		dwr.util.addOptions('convenioNominaID', {'': 'NO SE ENCONTRARON CONVENIOS ACTIVOS'});
	});
}

function funcionConsultaCliente(idControl) {
	var jqCliente  = eval("'#" + idControl + "'");
	var varClienteID = $(jqCliente).val();
	var conCliente = 1;
	var rfc = ' ';
	setTimeout("$('#cajaLista').hide();", 200);
	if(varClienteID != '' && !isNaN(varClienteID) && varClienteID != 0){
		clienteServicio.consulta(conCliente, varClienteID, rfc, function(cliente) {
			if (cliente != null) {
				var tipo = (cliente.tipoPersona);
				$('#nombreCompleto').val(cliente.nombreCompleto);
				if (tipo != 'F') {
					mensajeSis('El ' + $('#tipoUsuario').val() + ' no es una persona física');
					$('#clienteID').val('');
					$('#nombreCompleto').val('');
					setTimeout(function() {$('#clienteID').focus();}, 0);
					$('#formaTabla').hide();
					return;
				}
				listaGrid();
			} else {
				mensajeSis('El ' + $('#tipoUsuario').val() + ' no existe');
				$('#nombreCompleto').val('');
				setTimeout(function() {$('#clienteID').focus();}, 0);
				$('#formaTabla').hide();
			}
		});
	}
}

function listaGrid() {
	var params = {};
	params['clienteID'] = $('#clienteID').val();
	params['tipoLista'] = tipoLista.listaGridEmpleados;
	$.post("relacionClientesEmpresaNominaGridVista.htm", params, function(data) {
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


function listaTiposPuestos() {
	dwr.util.removeAllOptions('puestoOcupacionID');

	var tipoLista  = 1;
	dwr.util.addOptions('puestoOcupacionID',{'':'SELECCIONAR'});
	tiposPuestosServicio.listaCombo(tipoLista, function(tipoPuestos){
		dwr.util.addOptions('puestoOcupacionID', tipoPuestos, 'tipoPuestoID', 'descripcion');

	});
}


function listaCatQuinquenios() {
	dwr.util.removeAllOptions('quinquenioID');
	var catQinqueniosBean ={
		'descripcion': "",
		'descripcionCorta' : ""
	}
	var tipoLista  = 1;
	dwr.util.addOptions('quinquenioID',{'':'SELECCIONAR'});
	catQuinqueniosServicio.lista(tipoLista, catQinqueniosBean, function(quinquenios){
		dwr.util.addOptions('quinquenioID', quinquenios, 'quinquenioID', 'descripcionCorta');

	});
}

function funcionExito() {
	$('#formaGenerica')[0].reset();
	$('#clienteID').val($('#consecutivo').val());
	$('#formaTabla').hide();
	habilitaControl('institNominaID');
	habilitaControl('convenioNominaID');
	listaGrid();
}

function funcionError() {
	if($('#tipoTransaccion').val() == tipoTransaccion.alta) {
		habilitaBoton('grabar', 'submit');
	}
	if($('#tipoTransaccion').val() == tipoTransaccion.elimina) {
		habilitaBoton('eliminar', 'submit');
	}
	if($('#tipoTransaccion').val() == tipoTransaccion.modificacion) {
		habilitaBoton('modificar', 'submit');
	}
	listaGrid();
}

function consultaFlujoCliente() {
	if($('#flujoCliNumCli').val() != undefined) {
		if(!isNaN($('#flujoCliNumCli').val())) {
			var numCliFlu = Number($('#flujoCliNumCli').val());
			if (numCliFlu > 0) {
				$('#clienteID').val($('#flujoCliNumCli').val());
			}
		}
	}
}
