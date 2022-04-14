var esMenorEdad = '';
var huellaProductos = '';


listaPersBloqBean = {
		'estaBloqueado'	:'N',
		'coincidencia'	:0
};

consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente 			='CTE';

$(document).ready(function() {
	
	$("#cuentaAhoID").focus();
	
		var parametroBean = consultaParametrosSession();

		esTab = false;
		var resultadoTransaccion = 99;
		
		// Definicion de Constantes y Enums
		var catTipoConsultaTipoCtaAho = {
			'principal' : 1,
			'foranea' : 2,
			'tipoPersona':9,
			'fiscal':11,
			'timbrado':6
		};

		var catTipoActTipoCtaAho = {
			'apertura' : 1
		};
		var catTipoTransaccionCtaAho = {
			'agrega' : '1',
			'modifica' : '2',
			'actualiza' : '3'
		};

		// ------------ Metodos y Manejo de Eventos
		// -----------------------------------------
		deshabilitaBotones();
		inicializaForma('formaGenerica', 'cuentaAhoID');
		$('#usuarioApeID').val(parametroBean.numeroUsuario);
		$('#nombreUsuario').val(parametroBean.nombreUsuario);
		$('#fechaApertura').val(parametroBean.fechaSucursal);
		validaEmpresaID();
		$(':text').focus(function() {
			esTab = false;
		});

		$.validator.setDefaults({
			submitHandler : function(event) {
				resultadoTransaccion =
				grabaFormaTransaccion(event,'formaGenerica', 'contenedorForma','mensaje', 'true', 'cuentaAhoID',
		    			'exitoTransaccion','falloTransaccion'); 					
				
			}
		});

		$(':text').bind('keydown', function(e) {
			if (e.which == 9 && !e.shiftKey) {
				esTab = true;
			}
		});

		$('#activa').click(function() {
			$('#tipoActualizacion').val(catTipoActTipoCtaAho.apertura);
			$('#tipoTransaccion').val(catTipoTransaccionCtaAho.actualiza);
		});

		$('#PDF').click(function() {
			var ctaAho = $('#cuentaAhoID').val();
			var tp = $('#tipoPersona').val();
			var nombreInstitucion=parametroBean.nombreInstitucion;
			var dirInst = parametroBean.direccionInstitucion;
			var RFCInst = parametroBean.rfcInst;
			var telInst = parametroBean.telefonoLocal;
			var fechaEmision = parametroBean.fechaSucursal;
			var sucursal = parametroBean.sucursal;
			var nombreSucursal = parametroBean.nombreSucursal;
			var representanteLegal = parametroBean.representanteLegal;
			$('#ligaPDF').attr('href','PortadaContratoCtaPDF.htm?cuentaAhoID='+ctaAho+'&tipoPersona='+tp 
							+'&nombreInstitucion='+nombreInstitucion+'&dirInst='+dirInst+'&RFCInst='+RFCInst+'&telInst='+telInst
							+'&fechaEmision='+fechaEmision+'&representanteLegal='+representanteLegal
							+'&sucursalID='+sucursal+'&nombreSucursal='+nombreSucursal);
		});

		$('#anexoPDF').click(function() {
					var ctaAho = $('#cuentaAhoID').val();
					$('#ligaPDF2').attr(
							'href',
							'AnexoPortadaContratoCtaPMPDF.htm?cuentaAhoID='
									+ ctaAho);

		});
		
		$('#formatoDecCte').click(function() {
			var ctaAho = $('#cuentaAhoID').val();
			var nombreInstitucion = parametroBean.nombreInstitucion;
			var fecha = parametroBean.fechaSucursal;
			var usuario = parametroBean.claveUsuario;
			$('#ligaPDF3').attr(
					'href',
					'repDeclaracionCliente.htm?cuentaAhoID='
							+ ctaAho + '&usuario=' + usuario
							+ '&nombreInstitucion=' + nombreInstitucion
							+ '&fecha=' +fecha);
		});
		
		$('#activa').attr('tipoActualizacion', '1');

		$('#cuentaAhoID').blur(function() {
			var cadena = $('#cuentaAhoID').val();
			expresionRegular = /^([0-9,%])*$/;

			if (esTab && !expresionRegular.test(cadena)){
				limpiarCampos();
				$('#cuentaAhoID').val('');
				setTimeout("$('#cajaLista').hide();", 200);
				mensajeSis("No Existe la Cuenta de Ahorro");		
			}else{
				consultaCtaAho(this.id);
			}	

			
		});

		$('#cuentaAhoID').bind('keyup',function(e) {
					if (this.value.length >= 2) {
						var camposLista = new Array();
						var parametrosLista = new Array();
						camposLista[0] = "clienteID";
						parametrosLista[0] = $('#cuentaAhoID').val();
						lista('cuentaAhoID', '2', '3', camposLista,
								parametrosLista,
								'cuentasAhoListaVista.htm');
					}
		});

		$('#clienteID').blur(function() {			
			consultaCliente(this.id);
		});

		$('#usuarioApeID').bind(
				'keyup',
				function(e) {
					// TODO Agregar Libreria de Constantes Tipo Enum
					lista('usuarioApeID', '4', '1', 'nombre', $(
							'#usuarioApeID').val(),
							'listaUsuarios.htm');
		});

		$('#usuarioApeID').blur(function() {
			consultaUsuario(this.id);
		});

		// ------------ Validaciones de la Forma
		// -------------------------------------
		$('#formaGenerica').validate({
			rules : {
				clienteID : 'required',
				usuarioApeID : 'required',
				fechaApertura : 'required'
			},

			messages : {
				clienteID : 'Especifique numero de cliente',
				usuarioApeID : 'Especifique el Usuario',
				fechaApertura : 'Especifique Fecha de registro'
			}
		});

		// ------------ Validaciones de Controles
		// -------------------------------------

		function consultaCtaAho(idControl) {
			var jqCtaAho = eval("'#" + idControl + "'");
			var numCtaAho = $(jqCtaAho).val();
			var CuentaAhoBeanCon = {
				'cuentaAhoID' : numCtaAho
			};
			var conCtaAho = 3;
			var var_estatus;
			setTimeout("$('#cajaLista').hide();", 200);
			if (numCtaAho != '' && !isNaN(numCtaAho) && esTab) {
				cuentasAhoServicio.consultaCuentasAho(conCtaAho,CuentaAhoBeanCon,function(ctaAho) {
					if (ctaAho != null) {
						//El estatus 1 es que la cuenta requiere un deposito, si es cero no requiere y si es mayor a 1 ya realizo el deposito
						if(ctaAho.estatusDepositoActiva == "1"){
							mensajeSis("La Cuenta de Ahorro requiere un Depósito en Ventanilla para Activación.");
							limpiarCampos();
						}else{
							$('#cuentaAhoID').val(ctaAho.cuentaAhoID);
							$('#clienteID').val(ctaAho.clienteID);
							var_estatus = (ctaAho.estatus);
							consultaCliente('clienteID');
							validaEstatus(var_estatus);
							$('#usuarioApeID').val(parametroBean.numeroUsuario);
							$('#nombreUsuario').val(parametroBean.nombreUsuario);
							$('#fechaApertura').val(parametroBean.fechaSucursal);
							$('#estatusDepositoActiva').val(ctaAho.estatusDepositoActiva);							
						}
					} else {
						mensajeSis("No Existe la Cuenta de Ahorro");
						limpiarCampos();
					}
				});
			}else{
				limpiarCampos();
				$('#clienteID').focus();		
				
			}		
		}

		function limpiarCampos(argument) {
			inicializaForma('formaGenerica', 'cuentaAhoID');			
			deshabilitaBoton('activa','submit');
			$('#anexoPDF').hide();
			$('#PDF').hide();
			$('#formatoDecCte').hide();
			$('#usuarioApeID').val(parametroBean.numeroUsuario);
			$('#nombreUsuario').val(parametroBean.nombreUsuario);
			$('#fechaApertura').val(parametroBean.fechaSucursal);
			$('#estatusDepositoActiva').val('');
			$('#cuentaAhoID').focus();	
		}

		function consultaCliente(idControl) {
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();
			var conCliente = 1;
			var rfc = ' ';
			setTimeout("$('#cajaLista').hide();", 200);
			if (numCliente != '' && !isNaN(numCliente)) {
				clienteServicio.consulta(conCliente, numCliente,
						rfc, function(cliente) {
							if (cliente != null) {
								listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
								consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB',esCliente);
								if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
								$('#nombreCte').val(
										cliente.nombreCompleto);
								var tp = cliente.tipoPersona;
								var Menor="E";
								$('#tipoPersona').val(tp);

								$('#PDF').show();
								if (tp == 'M') {
									$('#anexoPDF').show();
								} else {
									deshabilitaBoton('anexoPDF','submit');
									$('#anexoPDF').hide();
								}
								if (tp == 'F' || tp == 'A') {
									$('#formatoDecCte').show();
								} else {
									deshabilitaBoton('formatoDecCte','submit');
									$('#formatoDecCte').hide();
								}
								
								if(cliente.esMenorEdad=='S'){
									$('#tipoPersona').val(Menor);
									esMenorEdad = cliente.esMenorEdad;
								}else{
									esMenorEdad = '';
								}
								 if (cliente.estatus=="I"){
										deshabilitaBoton('activa','submit');
										$('#cuentaAhoID').focus();
										$('#anexoPDF').hide();
										$('#PDF').hide();
										$('#formatoDecCte').hide();
										mensajeSis("El Cliente se encuentra Inactivo");
								 }
								}else{
									mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
									limpiarCampos();
									inicializaForma('formaGenerica', 'clienteID');
									$('#cuentaAhoID').focus();
									$('#cuentaAhoID').val('');
								}
							} else {
								mensajeSis("No Existe el Cliente");
								$(jqCliente).focus();
							}
						});
			}
		}

		function consultaUsuario(idControl) {
			
			var jqUsuario = eval("'#" + idControl + "'");
			var numUsuario = $(jqUsuario).val();
			var conUsuario = 2;
			setTimeout("$('#cajaLista').hide();", 200);
			if (numUsuario != '' && !isNaN(numUsuario)) {
				
				var usuarioBeanCon = {
						'usuarioID':numUsuario 
				};	
				usuarioServicio.consulta(conUsuario,usuarioBeanCon,function(usuario) {
							if (usuario != null) {
								$('#usuarioApeID').val(usuario.usuarioID);
								$('#nombreUsuario').val(usuario.nombreCompleto);
							} else {
								mensajeSis("No Existe el Usuario");
								$(jqUsuario).focus();
							}
						});
			}
		}

		function validaEstatus(var_estatus) {
			var estatusActivo = "A";
			var estatusBloqueado = "B";
			var estatusCancelada = "C";
			var estatusInactivo = "I";
			var estatusRegistrada = "R";
			setTimeout("$('#cajaLista').hide();", 200);
			if (var_estatus == estatusActivo) {
				deshabilitaBoton('activa', 'submit');
				habilitaBoton('PDF', 'button');
				habilitaBoton('formatoDecCte','button');
				$('#estatus').val('ACTIVO');
				$('#anexoPDF').hide();
			}
			if (var_estatus == estatusBloqueado) {
				deshabilitaBoton('activa', 'submit');
				$('#estatus').val('BLOQUEADO');
			}
			if (var_estatus == estatusCancelada) {
				deshabilitaBoton('activa', 'submit');
				$('#estatus').val('CANCELADO');
			}
			if (var_estatus == estatusInactivo) {
				deshabilitaBoton('activa', 'submit');
				$('#estatus').val('INACTIVO');
			}
			if (var_estatus == estatusRegistrada) {
				habilitaBoton('activa', 'submit');
				deshabilitaBoton('PDF', 'button');
				deshabilitaBoton('anexoPDF', 'button');
				deshabilitaBoton('formatoDecCte','button');
				$('#estatus').val('REGISTRADO');
				$('#anexoPDF').hide();
				$('#formatoDecCte').hide();
			}
		}
		
		function estaRegistradoFiscal() {			
			setTimeout("$('#cajaLista').hide();", 200);
			var parametrosSisCon ={
		 		 	'empresaID' : 1 
			};				
			parametrosSisServicio.consulta(catTipoConsultaTipoCtaAho.timbrado,parametrosSisCon, function(timbrado) {
				if (timbrado != null) {										
					if (timbrado.timbraEdoCta == 'S') {						
						clienteServicio.consulta( catTipoConsultaTipoCtaAho.tipoPersona,$('#clienteID').val()," ",function(cliente){
							if(cliente!=null){								
								if (cliente.tipoPersona == 'M' || cliente.tipoPersona == 'A') {
									var direccionesClienteCon ={
								 		 	'clienteID' : $('#clienteID').val()
									};										
									direccionesClienteServicio.consulta(catTipoConsultaTipoCtaAho.fiscal,direccionesClienteCon,function(fiscalPersona) {
										if (fiscalPersona == null ){
											mensajeSis("El Cliente No Tiene Dirección Fiscal");
											deshabilitaBotones();
										}else{
										}
									});
								}else{
								}
								
							}
						});
					}
				} else {
					deshabilitaBotones();
				}
			});
		}

		function tieneDirOficial() {
			var tipoConsulta = 4;
			var direccionesCliente = {
				'clienteID' : $('#clienteID').val()
			};
			setTimeout("$('#cajaLista').hide();", 200);
			direccionesClienteServicio
					.consulta(
							tipoConsulta,
							direccionesCliente,
							function(direccion) {
								if (direccion != null) {
									if (direccion.oficial != 'N') {
										estaRegistradoFiscal();
									} else {
										mensajeSis('El Cliente No Tiene Dirección Oficial');
										deshabilitaBotones();
									}
								} else {
									mensajeSis('El Cliente No Tiene Dirección Oficial');
									deshabilitaBotones();
								}
							});
		}

		function deshabilitaBotones(){
			deshabilitaBoton('activa','submit');
			deshabilitaBoton('PDF','button');
			deshabilitaBoton('anexoPDF','button');
			deshabilitaBoton('formatoDecCte', 'button');
			$('#anexoPDF').hide();
			$('#PDF').hide();
			$('#formatoDecCte').hide();
		}

		
		//Consulta para ver si se requiere que el cliente tenga registrada su huella Digital
		function validaEmpresaID() {
			var numEmpresaID = 1;
			var tipoCon = 1;
			var ParametrosSisBean = {
					'empresaID'	:numEmpresaID
			};
			parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
				if (parametrosSisBean != null) {
					if(parametrosSisBean.reqhuellaProductos !=null){
							huellaProductos=parametrosSisBean.reqhuellaProductos;
					}else{
						huellaProductos="N";
					}
				}
			});
		}
		
		
});

function exitoTransaccion(){
	habilitaBoton('anexoPDF', 'submit');
	habilitaBoton('PDF', 'submit');
	habilitaBoton('formatoDecCte','submit');
	$('#anexoPDF').show();
	$('#PDF').show();
	$('#formatoDecCte').show();
}

function falloTransaccion (){	
}	