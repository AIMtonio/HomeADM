var parametros = consultaParametrosSession();
var claveUsuario = (parametros.claveUsuario).toUpperCase();
var esTab=false;
$(document).ready(function (){
	$('#nombreUsuario').val(parametros.nombreUsuario); // parametros del sesion para el reporte
	$('#nombreInstitucion').val(parametros.nombreInstitucion);
	$('#fechaEmision').val(parametroBean.fechaSucursal);
	$('#primerRango').val(0); // rango tipo de instrumento
	$('#segundoRango').val(0); // rango tipo deinstrumento
	$('#primerCentroCostos').val(0);
	$('#segundoCentroCostos').val(0);
	$('#descripcionCenCosIni').val('TODOS');
	$('#descripcionCenCosFin').val('TODOS');
	$('#usuarioID').val(0);
	$('#nomUsuario').val('TODOS');
	deshabilitaControl('primerRango');
	deshabilitaControl('segundoRango');
	habilitaControl('generar');
	$("#fechaInicial").focus();
	
	var hora = '';
	var horaEmision = new Date();
	hora = horaEmision.getHours();
	if (horaEmision.getMinutes() < 10) {
		hora = hora + ':' + '0' + horaEmision.getMinutes();
	} else {
		hora = hora + ':' + horaEmision.getMinutes();
	}

	$('#hora').val(hora);
	consultaTipoInstrumentos();
	var tipoInstrumento = 0;
	var tipoInstrCliente = 0;

	// Definicion de Constantes y Enums
	var catTipoListaMoneda = {
		'principal' : 3
	};

	var catTipoListaSucursal = {
		'combo' : 2
	};
	var catTipoListaInversion = {
		'principal' : 1
	};
	var catStatusInversion = {
		'alta' : 'A'
	};
	var catTipoConsultaCentro = {
	'principal' : 1,
	'foranea' : 2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$.validator.setDefaults({
		submitHandler : function(event) {

		}
	});
	agregaFormatoControles('formaGenerica');
	cargaMonedas();

	$('#fechaInicial').val(parametros.fechaAplicacion);
	$('#fechaFinal').val(parametros.fechaAplicacion);

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	

		$('#generar').click(function() {
		if (validaParametrosReporte() == 0) {
			if ($('#pdf').is(':checked')) {
				enviaDatosRepPDF();
			} else if ($('#excel').is(':checked')) {
				enviaDatosRepExcel();
			}
		}
	});
	$('#fechaInicial').change(function() {
		var fechaInicial = validacion.esFechaValida($('#fechaInicial').val()) == true ? $('#fechaInicial').val() : '1900-01-01';
		var fechaFinal = validacion.esFechaValida($('#fechaFinal').val()) == true ? $('#fechaFinal').val() : '1900-01-01';

		if (!validacion.esFechaValida($('#fechaInicial').val())) {
			$('#fechaInicial').val(parametroBean.fechaSucursal);
		}
		if (fechaInicial > fechaFinal) {
			$('#fechaFinal').val($('#fechaInicial').val());
		}
	});

	$('#fechaFinal').change(function() {
		var fechaInicial = validacion.esFechaValida($('#fechaInicial').val()) == true ? $('#fechaInicial').val() : '1900-01-01';
		var fechaFinal = validacion.esFechaValida($('#fechaFinal').val()) == true ? $('#fechaFinal').val() : '1900-01-01';

		if (!validacion.esFechaValida($('#fechaFinal').val())) {
			$('#fechaFinal').val(parametroBean.fechaSucursal);
		}
		if (fechaInicial > fechaFinal) {
			$('#fechaFinal').val($('#fechaInicial').val());
		}

	});

	$('#usuarioID').blur(function() {
		if (!isNaN($('#usuarioID').val()) && $('#usuarioID').val() > 0) {
			consultaUsuario($('#usuarioID').val());
		} else {
			$('#usuarioID').val(0);
			$('#nomUsuario').val('TODOS');
		}
	});

	$('#polizaID').blur(function() {
		if (!isNaN($('#polizaID').val()) && $('#polizaID').val() > 0) {
			$('#usuarioID').val(0);
			$('#nomUsuario').val('TODOS');
		} else {
			$('#polizaID').val(0);
		}
	});

	$('#usuarioID').bind('keyup', function(e) {
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});

	$('#primerRango').blur(function() {
		validaPrimerRango(this.id);
	});
	$('#segundoRango').blur(function() {
		validaSegundoRango(this.id);
	});

	$('#primerCentroCostos').bind('keyup', function(e) {
		lista('primerCentroCostos', '2', '1', 'descripcion', $('#primerCentroCostos').val(), 'listaCentroCostos.htm');
	});
	$('#segundoCentroCostos').bind('keyup', function(e) {
		lista('segundoCentroCostos', '2', '1', 'descripcion', $('#segundoCentroCostos').val(), 'listaCentroCostos.htm');
	});

	$('#primerCentroCostos').blur(function() {
		valPrimerCentroCosto(this.id);
		consultaCentroCostosIni(this.id);
	});
	$('#segundoCentroCostos').blur(function() {
		validaSegudoCentro(this.id);
		consultaCentroCostosFin(this.id);
	});

	$('#tipoInstrumentoID').change(function() {
		validaTipoInstrumento(this.id);
	});

	$('#primerRango').blur(function() {
		if (tipoInstrumento == tipoInstrCliente) {
			$('#segundoRango').val($('#primerRango').val());
		}
	});

	$('#primerCentroCostos').blur(function() {
		ponerCerosCCostos();
	});
	$('#segundoCentroCostos').blur(function() {
		ponerCerosCCostos();
	});

	$('#primerRango').blur(function() {
		ponerCerosRangosIntrumentos();
		ocultaLista();
	});
	$('#segundoRango').blur(function() {
		ponerCerosRangosIntrumentos();
		ocultaLista();
	});
	
	//	------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({	
		rules: {
			polizaID: {
				required: true,
				numeroPositivo: true

			},
			fechaInicial: {
				date: true

			},
			fechaFinal: {
				date: true

			},
			numeroTransaccion: {
				required: true,
				numeroPositivo: true
			},
			primerRango: {
				required: function() {
					return $('#segundoRango').val() != "";}
			}
			
		},		
		messages: {
			polizaID: {
				required:'Especificar No. de Póliza',
				numeroPositivo: 'Solo Números'
			},
			fechaInicial: {
				date: 'Fecha Incorrecta'

			},
			fechaFinal: {
				date: 'Fecha Incorrecta'

			},
			numeroTransaccion: {
				required:'Especificar No. de Transación',
				numeroPositivo: 'Solo Números'
			},
			primerRango: {
				required:'Especificar Primer rango'
			}
		}		
	});

	function enviaDatosRepExcel(){
		var nombreusuario 		= claveUsuario;
		var nombreInstitucion	= $('#nombreInstitucion').val();
		var fechaEmision 		= $('#fechaEmision').val();
		var sucursal			= 0;
		var poliza 				= $('#polizaID').val();
		var transaccion 		= $('#numeroTransaccion').val();
		var moneda 				= $("#monedaID option:selected").val();
		var nombreSucursal		= '';
		var descripMoneda		= $("#monedaID option:selected").val();
		var primerRango			= $('#primerRango').val();
		var segundoRango		= $('#segundoRango').val();
		var primerCentroCostos	= $('#primerCentroCostos').val();
		var segundoCentroCostos	= $('#segundoCentroCostos').val();
		var tipoInstrumentoID 	= $('#tipoInstrumentoID').val();
		var valorPoliza			= 'TODAS';
		var valorTransaccion	= 'TODAS';
		var tipoReporte			= 2;
		var descTipoInstrumento = $("#tipoInstrumentoID option:selected").val();
		var hora		 		= $('#hora').val();
		var usuarioRep=0;
		if ($('#usuarioID').val() == '') {
			usuarioRep = 0;
		} else {
			if (!isNaN($('#usuarioID').val())) {
				usuarioRep = $('#usuarioID').val();
			}
		}

		if ($('#fechaFinal').val() < $('#fechaInicial').val()) {
			mensajeSis("La Fecha Final no debe ser menor que la Fecha Inicial.");
			$('#fechaFinal').focus();
		} else {
			if (isNaN($("#polizaID").val())) {
				mensajeSis("Sólo números");
				$("#polizaID").focus();
			} else {
				if ($("#polizaID").val() == '') {
					mensajeSis("La Póliza está vacía");
					$("#polizaID").focus();
				} else {
					if ($("#numeroTransaccion").val() == '') {
						mensajeSis("El número de Transacción está vacío");
						$("#numeroTransaccion").focus();
					} else {
						if (poliza == '0') {
							poliza = 'TODAS';
						} else {
							poliza = $('#polizaID').val();
							valorPoliza = poliza;
						}
						if (transaccion == '0') {
							transaccion = 'TODAS';
						} else {
							transaccion = $('#numeroTransaccion').val();
							valorTransaccion = transaccion;
						}
						if (descripMoneda == '0') {
							descripMoneda = 'TODAS';
						} else {
							descripMoneda = $("#monedaID option:selected").html();
						}

						if ($('#tipoInstrumentoID').val() == '') {
							tipoInstrumentoID = '0';
						}
						if ($('#primerRango').val() == '') {
							primerRango = '0';
						}
						if ($('#segundoRango').val() == '') {
							segundoRango = '0';
						}
						if (descTipoInstrumento == '0') {
							descTipoInstrumento = 'INDISTINTO';
						} else {
							descTipoInstrumento = $("#tipoInstrumentoID option:selected").html();
						}

						var pagina = 'PolizaContableRepPDF.htm?tipoReporte=' + tipoReporte + '&nombreUsuario=' + nombreusuario + '&nombreInstitucion=' + nombreInstitucion + '&fechaInicial=' + $('#fechaInicial').val() + '&fechaFinal=' + $('#fechaFinal').val() + '&fechaEmision=' + fechaEmision + '&sucursalID=' + sucursal + '&polizaID=' + poliza + '&numeroTransaccion=' + transaccion + '&monedaID=' + moneda + '&descripMoneda=' + descripMoneda + '&nombreSucursal=' + nombreSucursal + '&valorTransaccion=' + valorTransaccion + '&valorPoliza=' + valorPoliza + '&primerRango=' + primerRango + '&segundoRango=' + segundoRango + '&primerCentroCostos=' + primerCentroCostos + '&segundoCentroCostos=' + segundoCentroCostos + '&tipoInstrumentoID=' + tipoInstrumentoID + '&descTipoInstrumento=' + descTipoInstrumento + '&hora=' + hora + '&usuarioID=' + usuarioRep;
						window.open(pagina, '_blank');
					}
				}
			}
		}
	}

	function consultaUsuario(numUsuario) {
		var usuarioBeanCon = {
			'usuarioID' : numUsuario
		};

		usuarioServicio.consulta(1, usuarioBeanCon, function(usuario) {
			if (usuario != null) {
				$('#nomUsuario').val(usuario.nombreCompleto);
				$('#polizaID').val(0);
			} else {
				mensajeSis('El Usuario no Existe.');
				$('#usuarioID').val(0);
				$('#nomUsuario').val('TODOS');
			}
		});
	}

		
	function validaParametrosReporte() {
		var error = 0;
		if ($('#primerRango').asNumber() > 0 && $('#segundoRango').asNumber() <= 0) {
			mensajeSis("El Segundo Rango se encuentra Vacío.");
			$('#segundoRango').focus();
			error = 1;
		} else {
			if ($('#primerRango').asNumber() <= 0 && $('#segundoRango').asNumber() > 0) {
				mensajeSis("El Primer Rango se encuentra Vacío.");
				$('#primerRango').focus();
				error = 1;
			} else {
				if ($('#primerCentroCostos').asNumber() > 0 && $('#segundoCentroCostos').asNumber() <= 0) {
					mensajeSis("El Centro de Costos Final se encuentra Vacío.");
					$('#segundoCentroCostos').focus();
					error = 1;
				} else {
					if ($('#primerCentroCostos').asNumber() <= 0 && $('#segundoCentroCostos').asNumber() > 0) {
						mensajeSis("El Centro de Costos Inicial se encuentra Vacío.");
						$('#primerCentroCostos').focus();
						error = 1;
					}
				}
			}
		}
		if (($('#primerRango').asNumber() > $('#segundoRango').asNumber()) && $('#segundoRango').asNumber() != 0) {
			mensajeSis("El Primer Rango No puede ser Mayor al Segundo.");
			$('#segundoRango').focus();
			error = 1;
		}
		if (error == 0) {
			if ($('#primerCentroCostos').asNumber() > $('#segundoCentroCostos').asNumber()) {
				mensajeSis("El Primer Centro de Costos No puede ser Mayor al Segundo.");
				$('#segundoCentroCostos').focus();
				error = 1;
			}
		}
		return error;
	}
	
	
	function enviaDatosRepPDF(){
		var nombreusuario 		= claveUsuario;
		var nombreInstitucion	= $('#nombreInstitucion').val();
		var fechaEmision 		= $('#fechaEmision').val();
		var sucursal			= 0;
		var poliza 				= $('#polizaID').val();
		var transaccion 		= $('#numeroTransaccion').val();
		var moneda 				= $("#monedaID option:selected").val();
		var nombreSucursal		= '';
		var descripMoneda		= $("#monedaID option:selected").val();
		var primerRango			= $("#primerRango").val(); //  primer rango tipo de instrumento
		var segundoRango		= $('#segundoRango').val(); // segundo rango tipo de instrumento
		var primerCentroCostos	= $('#primerCentroCostos').val();
		var segundoCentroCostos	= $('#segundoCentroCostos').val();
		var tipoInstrumentoID	= $('#tipoInstrumentoID').val();
		var valorPoliza			= 'TODAS';
		var valorTransaccion	= 'TODAS';
		var tipoReporte			= 1;
		var descTipoInstrumento = $("#tipoInstrumentoID option:selected").val();
		var usuarioRep			= 0;
		var nomUsuario			= $('#usuarioID').val()+" - "+$('#nomUsuario').val();
		if ($('#usuarioID').val() == '') {
			usuarioRep = 0;
		} else {
			if (!isNaN($('#usuarioID').val())) {
				usuarioRep = $('#usuarioID').val();
			}
		}

		if ($('#fechaFinal').val() < $('#fechaInicial').val()) {
			mensajeSis("La Fecha Final no debe ser menor que la Fecha Inicial.");
			$('#fechaFinal').focus();
		} else {
			if (isNaN($("#polizaID").val())) {
				mensajeSis("sólo números");
				$("#polizaID").focus();
			} else {
				if ($("#polizaID").val() == '') {
					mensajeSis("La Póliza está vacía");
					$("#polizaID").focus();
				} else {
					if ($("#numeroTransaccion").val() == '') {
						mensajeSis("El número de Transacción está vacío");
						$("#numeroTransaccion").focus();
					} else {
						if (poliza == '0') {
							poliza = 'TODAS';
						} else {
							poliza = $('#polizaID').val();
							valorPoliza = poliza;
						}
						if (transaccion == '0') {
							transaccion = 'TODAS';
						} else {
							transaccion = $('#numeroTransaccion').val();
							valorTransaccion = transaccion;
						}
						if (descripMoneda == '0') {
							descripMoneda = 'TODAS';
						} else {
							descripMoneda = $("#monedaID option:selected").html();
						}
						if (descTipoInstrumento == '0') {
							descTipoInstrumento = 'INDISTINTO';
						} else {
							descTipoInstrumento = $("#tipoInstrumentoID option:selected").html();
						}

						if ($('#tipoInstrumentoID').val() == '') {
							tipoInstrumentoID = '0';
						}

						var pagina = 'PolizaContableRepPDF.htm?tipoReporte=' + tipoReporte + '&nombreUsuario=' + nombreusuario + '&nombreInstitucion=' + nombreInstitucion + '&fechaInicial=' + $('#fechaInicial').val() + '&fechaFinal=' + $('#fechaFinal').val() + '&fechaEmision=' + fechaEmision + '&sucursalID=' + sucursal + '&polizaID=' + poliza + '&numeroTransaccion=' + transaccion + '&monedaID=' + moneda + '&descripMoneda=' + descripMoneda + '&nombreSucursal=' + nombreSucursal + '&valorTransaccion=' + valorTransaccion + '&valorPoliza=' + valorPoliza + '&primerRango=' + primerRango + '&segundoRango=' + segundoRango + '&primerCentroCostos=' + primerCentroCostos + '&segundoCentroCostos=' + segundoCentroCostos + '&tipoInstrumentoID=' + tipoInstrumentoID + '&descTipoInstrumento=' + descTipoInstrumento + '&usuarioID=' + usuarioRep + '&nomUsuario=' + nomUsuario;
						window.open(pagina, '_blank');
					}
				}
			}
		}
	}	



		function cargaMonedas() {
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions('monedaID', {
			'0' : 'TODAS'
		});
		monedasServicio.listaCombo(catTipoListaMoneda.principal, function(monedas) {
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function consultaTipoInstrumentos() {
		var tipoLista = 1;

		dwr.util.removeAllOptions('tipoInstrumentoID');
		dwr.util.addOptions('tipoInstrumentoID', {
			'' : 'INDISTINTO'
		});
		tipoInstrumentosServicio.listaCombo(tipoLista, function(instrumento) {
			dwr.util.addOptions('tipoInstrumentoID', instrumento, 'tipoInstrumentoID', 'descripcion');

		});
	}

	function ocultaLista() {
		setTimeout("$('#cajaLista').hide();", 200);
	}

	$('#tipoInstrumentoID').change(function() {
		$('#primerRango').val(0);
		$('#segundoRango').val(0);
		//Tipos de Instrumentos
		var cuentasAhorro = parseFloat(2);
		var cliente = parseFloat(4);
		var empleado = parseFloat(5);
		var proveedor = parseFloat(6);
		var usuario = parseFloat(7);
		var servicio = parseFloat(8); //pago de servicios
		var chequeSBC = parseFloat(9);//cheque SBC(Banco)
		var cajeroATM = parseFloat(10);
		var creditos = parseFloat(11);
		var fondeador = parseFloat(12);
		var inversionesPlazo = parseFloat(13);
		var numeroTarjeta = parseFloat(14);
		var cajasVentanilla = parseFloat(15);
		var polizaManual = parseFloat(17);
		var cuentaBancaria = parseFloat(19);
		var banco = parseFloat(21);
		var remesas = parseFloat(22);
		var tipoInstrumento = $('#tipoInstrumentoID option:selected').val();

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == cuentasAhorro) {
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "clienteID";
				parametrosLista[0] = $('#primerRango').val();
				listaAlfanumerica('primerRango', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
			}
		});

		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == cuentasAhorro) {
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "clienteID";
				parametrosLista[0] = $('#segundoRango').val();
				listaAlfanumerica('segundoRango', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
			}
		});

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == cliente) {
				lista('primerRango', '2', '1', 'nombreCompleto', $('#primerRango').val(), 'listaCliente.htm');
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == cliente) {
				lista('segundoRango', '2', '1', 'nombreCompleto', $('#segundoRango').val(), 'listaCliente.htm');
			}
		});

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').val() == empleado) {
				if (this.value.length >= 2) {
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "nombreCompleto";
					parametrosLista[0] = $('#primerRango').val();
					listaAlfanumerica('primerRango', '2', '1', camposLista, parametrosLista, 'listaEmpleados.htm');
				}
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == empleado) {
				if (this.value.length >= 2) {
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "nombreCompleto";
					parametrosLista[0] = $('#segundoRango').val();
					listaAlfanumerica('segundoRango', '2', '1', camposLista, parametrosLista, 'listaEmpleados.htm');
				}
			}
		});

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == proveedor) {
				if (this.value.length >= 2) {
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "apellidoPaterno";
					parametrosLista[0] = $('#primerRango').val();
					listaAlfanumerica('primerRango', '2', '1', camposLista, parametrosLista, 'listaProveedores.htm');
				}
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == proveedor) {
				if (this.value.length >= 2) {
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "apellidoPaterno";
					parametrosLista[0] = $('#segundoRango').val();
					listaAlfanumerica('segundoRango', '2', '1', camposLista, parametrosLista, 'listaProveedores.htm');
				}
			}
		});

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == usuario) {
				lista('primerRango', '2', '1', 'nombreCompleto', $('#primerRango').val(), 'listaUsuarios.htm');
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == usuario) {
				lista('segundoRango', '2', '1', 'nombreCompleto', $('#segundoRango').val(), 'listaUsuarios.htm');
			}
		});

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == servicio) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "catalogoServID";
				camposLista[1] = "nombreServicio";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#primerRango').val();
				lista('primerRango', '2', '1', camposLista, parametrosLista, 'listaCatalogoServicios.htm');
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == servicio) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "catalogoServID";
				camposLista[1] = "nombreServicio";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#segundoRango').val();
				lista('segundoRango', '2', '1', camposLista, parametrosLista, 'listaCatalogoServicios.htm');
			}
		});
		// En el instrumento se alamcena el numero de cheque asi que esta lista no aplica
		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').val() == chequeSBC) {
				setTimeout("$('#cajaLista').hide();", 200);

			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').val() == chequeSBC) {
				setTimeout("$('#cajaLista').hide();", 200);

			}
		});

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == cajeroATM) {
				lista('primerRango', '2', '2', 'nombreCompleto', $('#primerRango').val(), 'listaCajerosATM.htm');
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == cajeroATM) {
				lista('segundoRango', '2', '2', 'nombreCompleto', $('#segundoRango').val(), 'listaCajerosATM.htm');
			}
		});

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == creditos) {
				lista('primerRango', '2', '1', 'creditoID', $('#primerRango').val(), 'ListaCredito.htm');
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == creditos) {
				lista('segundoRango', '2', '1', 'creditoID', $('#segundoRango').val(), 'ListaCredito.htm');
			}
		});
		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == fondeador) {
				lista('primerRango', '2', '1', 'nombreInstitFon', $('#primerRango').val(), 'intitutFondeoLista.htm');
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == fondeador) {
				lista('segundoRango', '2', '1', 'nombreInstitFon', $('#segundoRango').val(), 'intitutFondeoLista.htm');
			}
		});

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == inversionesPlazo) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombreCliente";
				camposLista[1] = "estatus";
				parametrosLista[0] = $('#primerRango').val();
				parametrosLista[1] = catStatusInversion.alta;
				lista('primerRango', 2, catTipoListaInversion.principal, camposLista, parametrosLista, 'listaInversiones.htm');
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == inversionesPlazo) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombreCliente";
				camposLista[1] = "estatus";
				parametrosLista[0] = $('#segundoRango').val();
				parametrosLista[1] = catStatusInversion.alta;
				lista('segundoRango', 2, catTipoListaInversion.principal, camposLista, parametrosLista, 'listaInversiones.htm');
			}
		});

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == numeroTarjeta) {
				if (this.value.length >= 2 && isNaN($('#primerRango').val())) {
					lista('primerRango', '2', '8', 'tarjetaDebID', $('#primerRango').val(), 'tarjetasDevitoLista.htm');
				}
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == numeroTarjeta) {
				if (this.value.length >= 2 && isNaN($('#segundoRango').val())) {
					lista('segundoRango', '2', '8', 'tarjetaDebID', $('#segundoRango').val(), 'tarjetasDevitoLista.htm');
				}
			}
		});
		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == cajasVentanilla) {
				if (this.value.length >= 2) {
					lista('primerRango', '2', '2', 'cajaID', $('#primerRango').val(), 'listaCajaVentanilla.htm');
				}
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == cajasVentanilla) {
				if (this.value.length >= 2) {
					lista('segundoRango', '2', '2', 'cajaID', $('#segundoRango').val(), 'listaCajaVentanilla.htm');
				}
			}
		});
		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == polizaManual) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "concepto";
				parametrosLista[0] = $('#primerRango').val();
				listaAlfanumerica('primerRango', '2', '1', camposLista, parametrosLista, 'polizaContListaVista.htm');
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == polizaManual) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "concepto";
				parametrosLista[0] = $('#segundoRango').val();
				listaAlfanumerica('segundoRango', '2', '1', camposLista, parametrosLista, 'polizaContListaVista.htm');
			}
		});

				
		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == banco) {
				lista('primerRango', '1', '1', 'nombre', $('#primerRango').val(), 'listaInstituciones.htm');
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == banco) {
				lista('segundoRango', '1', '1', 'nombre', $('#segundoRango').val(), 'listaInstituciones.htm');
			}
		});

		$('#primerRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == remesas) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombre";
				parametrosLista[0] = $('#primerRango').val();
				listaAlfanumerica('primerRango', '1', '1', camposLista, parametrosLista, 'listaCatalogoRemesadora.htm');
			}
		});
		$('#segundoRango').bind('keyup', function(e) {
			if ($('#tipoInstrumentoID').asNumber() == remesas) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombre";
				parametrosLista[0] = $('#segundoRango').val();
				listaAlfanumerica('segundoRango', '1', '1', camposLista, parametrosLista, 'listaCatalogoRemesadora.htm');
			}
		});

		if ($('#tipoInstrumentoID').val() != '') {
			if ($('#tipoInstrumentoID').val() != 4) {
				habilitaControl('primerRango');
				habilitaControl('segundoRango');
			} else {
				habilitaControl('primerRango');
			}
		} else {
			deshabilitaControl('primerRango');
			deshabilitaControl('segundoRango');
		}

	});

	// funcion para validar el rango entre las listas de centro de costos
	function valPrimerCentroCosto(idControl) {
		var jqCentro = eval("'#" + idControl + "'");
		var primerCentro = $('#primerCentroCostos').asNumber();
		var segundoCentro = $('#segundoCentroCostos').asNumber();
		if (esTab == true) {
			if (primerCentro > 0 && segundoCentro > 0) {
				if (primerCentro > segundoCentro) {
					mensajeSis("El Primer Centro de Costos No puede ser Mayor al Segundo.");
					$('#primerCentroCostos').val('');
					$('#descripcionCenCosIni').val('');
					$(jqCentro).focus();
				}
			}
		}//estab
	}

	function validaSegudoCentro(idControl) {
		var jqCentro = eval("'#" + idControl + "'");
		var primerCentro = $('#primerCentroCostos').asNumber();
		var segundoCentro = $('#segundoCentroCostos').asNumber();
		if (esTab == true) {
			if (primerCentro > 0 && segundoCentro > 0) {
				if (primerCentro > segundoCentro) {
					mensajeSis("El Primer Centro de Costos No puede ser Mayor al Segundo.");
					$('#segundoCentroCostos').val('');
					$('#descripcionCenCosFin').val('');
					$(jqCentro).focus();
				}
			}
		}//estab
	}
	
	// funcion para validar el rango entre las listas de tipo de Instrumentos
	function validaPrimerRango(idControl) {
		var jqRango = eval("'#" + idControl + "'");
		var primerRango = $('#primerRango').asNumber();
		var segundoRango = $('#segundoRango').asNumber();
		if (esTab == true) {
			if (primerRango > 0 && segundoRango > 0) {
				if (primerRango > segundoRango) {
					mensajeSis('El Primer Rango del Instrumento No puede ser Mayor que el Segundo.');
					$('#segundoRango').val('');
					$(jqRango).focus();
				}
			}
		}// estab
	}

	function validaSegundoRango(idControl) {
		var jqRango = eval("'#" + idControl + "'");
		var primerRango = $('#primerRango').asNumber();
		var segundoRango = $('#segundoRango').asNumber();
		if (esTab == true) {
			if (primerRango >= 0 && segundoRango >= 0) {
				if (primerRango > segundoRango) {
					mensajeSis('El Primer Rango del Instrumento No puede ser Mayor que el Segundo.');
					$('#segundoRango').val('');
					$(jqRango).focus();
				}
			}
		}//estab
	}

	// Valida si el tipo de instrumento es cliente 		
	function validaTipoInstrumento(idControl) {
		var jqPrimerRango = eval("'#" + idControl + "'");
		tipoInstrumento = parseInt($(jqPrimerRango).val());
		tipoInstrCliente = 4;
		if (tipoInstrumento == tipoInstrCliente) {
			deshabilitaControl('segundoRango');
		} else {
			habilitaControl('segundoRango');
		}
	}
	// Consulta centro de costos inicial
	function consultaCentroCostosIni(control) {
		var numcentroCosto = $('#primerCentroCostos').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (numcentroCosto != '' && !isNaN(numcentroCosto) && numcentroCosto > 0 && esTab) {
			var centroBeanCon = {
				'centroCostoID' : $('#primerCentroCostos').val()
			};
			centroServicio.consulta(catTipoConsultaCentro.principal, centroBeanCon, function(centro) {
				if (centro != null) {
					$('#descripcionCenCosIni').val(centro.descripcion);
				} else {
					mensajeSis("El Centro de Costos no existe ");
					$('#primerCentroCostos').val(0);
					$('#descripcionCenCosIni').val('');
					$('#primerCentroCostos').focus();
				}
			});
		} else {
			if (numcentroCosto == '' || numcentroCosto == 0) {
				$('#primerCentroCostos').val(0);
				$('#descripcionCenCosIni').val('TODOS');
			}
		}
	}
	// consulta centro de costos final
	function consultaCentroCostosFin(control) {
		var numcentroCosto = $('#segundoCentroCostos').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (numcentroCosto != '' && !isNaN(numcentroCosto) && numcentroCosto > 0 && esTab) {
			var centroBeanCon = {
				'centroCostoID' : $('#segundoCentroCostos').val()
			};
			centroServicio.consulta(catTipoConsultaCentro.principal, centroBeanCon, function(centro) {
				if (centro != null) {
					$('#descripcionCenCosFin').val(centro.descripcion);
				} else {
					mensajeSis("El Centro de Costos No Existe.");
					$('#segundoCentroCostos').val('0');
					$('#descripcionCenCosFin').val('');
					$('#segundoCentroCostos').focus();
				}
			});
		} else {
			if (numcentroCosto == '' || numcentroCosto == 0) {
				$('#segundoCentroCostos').val('0');
				$('#descripcionCenCosFin').val('TODOS');
			}
		}
	}

	function ponerCerosCCostos() {
		if ($('#primerCentroCostos').val() == '') {
			$('#primerCentroCostos').val(0);
			$('#descripcionCenCosIni').val('');
		} else {
			if ($('#segundoCentroCostos').val() == '') {
				$('#segundoCentroCostos').val(0);
				$('#descripcionCenCosFin').val('');
			}
		}
	}

	function ponerCerosRangosIntrumentos() {
		if ($('#primerRango').val() == '') {
			$('#primerRango').val('0');
		} else {
			if ($('#segundoRango').val() == '') {
				$('#segundoRango').val('0');

			}
		}
	}	
	

}); // Fin Document

