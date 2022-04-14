var varError = 0;
var Var_TipoBeneficiario	='';
var Var_FechaInicioReinversion ='';
var proceso= false;
var estatusISR ='';
var funcionHuella = 'N';
var autorizaHuellaCliente = 'N';
var huellaCliente = 'N';

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
	esTab = true;
	$('#statusSrvHuella').hide();

	var serverHuella = new HuellaServer({
		fnHuellaValida:	function(datos){
			grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','true','inversionID','exito','error');
		},
		fnHuellaInvalida: function(datos){
			mensajeSis("La huella del cliente/firmante no corresponde con el registro en el sistema.");
			deshabilitaBoton("grabar");
			return false;
		}
	});

	 validaAutorizacionHuellaCliente();
	var parametroBean = consultaParametrosSession();
	var funcionHuella = parametroBean.funcionHuella;
	var diasBase = parametroBean.diasBaseInversion;
	var reinvertirInv	='';
	var pusoFecha=0;


	deshabilitaBoton('reinvertirBoton', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	deshabilitaBoton('imprime', 'submit');
	$('#personasRelacionadas').hide();
	$('#botonImprimir').val("");

	agregaFormatoControles('formaGenerica');

	if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
		$('#statusSrvHuella').show();
	}

	//Validacion para mostrarar boton de calcular CURP Y RFC
	permiteCalcularCURPyRFC('generarc','generar',3);

	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#inversionID').focus();

	var catHuellaDigital = {
		'noHuellas' : 4
	};

	var catTipoConsultaCliente = {
		'paraInversiones': 6
	};

	var catTipoConsultaInversion = {
		'principal' : 1
	};

	var catTipoTransaccionInsersion = {
  		'agrega'		:1,
  		'cancela'		:2,
  		'reinversion'	:3,
  		'cancelaReinversion'	:4
	};

	var catOperacFechas = {
  		'sumaDias'		:1,
  		'restaFechas'	:2
	};

	var catTipoConsultaCuentas = {
		'conSaldo': 5
	};

	var catTipoConsultaTipoInversion = {
		'principal':1,
		'general':3
	};

	var catStatusCuenta = {
		'activa':	'A'
	};
	var catStatusInversion = {
	  		'alta':		'A',
	  		'cargada': 	'N',
	  		'pagada': 	'P',
			'cancelada':'C'
	};
	var catTipoListaInversion = {
		'principal': 1,
		'reinversion': 5
	};

	$.validator.setDefaults({
		submitHandler: function(event) {
			if(!proceso){
					proceso = true;
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','inversionID','exito','error');
				}
				else{
					return false;
				}
			}
	});

	$('#fecha').html(parametroBean.fechaSucursal);
	$('#fechaInicio').val(parametroBean.fechaSucursal);

	$('#reinvertirBoton').click(function() {
		if($('#beneficiarioInver').is(':checked')){
			$("#beneficiario").val('I');
		}else{
			$("#beneficiario").val('S');
		}
		$('#tipoTransaccion').val(catTipoTransaccionInsersion.reinversion);
		$('#botonImprimir').val("S");

	});

	$('#cancelar').click(function() {

		if($('#beneficiarioInver').is(':checked')){
			$("#beneficiario").val('I');
		}else{
			$("#beneficiario").val('S');
		}

		$('#tipoTransaccion').val(catTipoTransaccionInsersion.cancelaReinversion);
		if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
			if( $('#formaGenerica').valid() ){
				consultaHuellaCliente();
				if(huellaCliente == 'S'){
					$('#botonImprimir').val("S");
					serverHuella.muestraFirmaAutorizacion();
					$('#botonImprimir').val("N");
					proceso = true;
					return false;
				}
			}
		}else{
			$('#botonImprimir').val("S");
			$('#statusSrvHuella').hide();
			$('#botonImprimir').val("N");
		}
	});

	/* Busca o Graba*/

	$('#inversionID').blur(function(){
		validaInversion(this.id);
	});

	$('#inversionID').bind('keyup',function(e){
		if(this.value.length >= 3){

			var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "nombreCliente";
			 camposLista[1] = "estatus";
			 parametrosLista[0] = $('#inversionID').val();
			 parametrosLista[1] = catStatusInversion.cargada;

			lista('inversionID', 2, catTipoListaInversion.reinversion, camposLista,
					 parametrosLista, 'listaInversiones.htm');
		}
	});




	$('#monto').blur(function(){
		pusoFecha=2;
		CalculaValorTasa('monto');

	});

	$('#plazo').change(function(){
		if($('#fechaInicio').val()!= ''){
			if($('#plazo').val() != 0){
				var opeFechaBean = {
					'primerFecha':parametroBean.fechaSucursal,
					'numeroDias':$('#plazo').val()
				};
				operacionesFechasServicio.realizaOperacion(opeFechaBean,catOperacFechas.sumaDias,
																		  function(data) {
					if(data!=null){
						$('#fechaVencimiento').val(data.fechaResultado);
						pusoFecha=1;
						//Calcula la Fecha Habil y la Tasa de Inversion

						fechaHabil($('#fechaVencimiento').val(), 'plazo');
					}else{
						mensajeSis("A ocurrido un error Interno al Consultar Fechas...");
					}
				});
			}
		}else{
			mensajeSis("Error al Consultar la Fecha de la Sucursal.");
			$('#inversionID').focus();
			$('#inversionID').select();
		}
	});

	$('#fechaVencimiento').change(function(){
		if(esTab==true){
			pusoFecha=2;
		}
		if($('#fechaInicio').val()!= ''){
			if($('#fechaVencimiento').val() != ''){
				if(esFechaValida($('#fechaVencimiento').val())){
					if($('#fechaVencimiento').val()< $('#fechaInicio').val()){
						mensajeSis('La Fecha de Vencimiento No Puede ser Menor a la Fecha Actual');
						$('#fechaVencimiento').val("");
						$('#fechaVencimiento').focus();
						$('#plazo').val("");
					}else{
						fechaHabil($('#fechaVencimiento').val(), 'fechaVencimiento');
					}
				}else{
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').val('');
					$('#plazo').val('');
				}
			}
		}else{
			mensajeSis("Error al Consultar la Fecha de la Sucursal.");
			$('#inversionID').focus();
			$('#inversionID').select();
		}
	});

	$('#claveUsuarioAut').blur(function() {
  		validaUsuario(this);
	});

	$('#imprime').click(function() {
		deshabilitaBoton('imprime', 'submit');
		if( parseInt($('#numeroMensaje').val()) == 0){
			var inversionID = $('#inversionID').val();
			var monedaID = $('#monedaID').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var monto =  ($('#montoConsulta').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
								})).asNumber();
			var fechaEmision = parametroBean.fechaSucursal;
			var dirInst = parametroBean.direccionInstitucion;
			var RFCInst = parametroBean.rfcInst;
			var telInst = parametroBean.telefonoLocal;
			var gerente	= parametroBean.gerenteGeneral;
			var presidente = parametroBean.presidenteConsejo;
			var usuario	= parametroBean.nombreUsuario;
			var sucursalID = parametroBean.sucursal;

			var liga = 'pagareInversionRep.htm?inversionID='+inversionID +
						  '&monedaID=' + monedaID + '&nombreInstitucion=' + nombreInstitucion + '&monto=' + monto
						  +'&direccionInstit='+dirInst+'&RFCInstit='+RFCInst+'&telefonoInst='+telInst+'&fechaActual='+fechaEmision
						  +'&nombreGerente='+gerente+'&nombrePresidente='+presidente+'&nombreUsuario='+usuario+'&sucursalID='+sucursalID;
			$('#enlace').attr('href',liga);
		}else{
			mensajeSis("Existieron Errores al Grabar la Inversión.");
			$('#inversionID').focus();
			$('#inversionID').select();
			return false;
		}
	});

	$('#beneficiarioSocio').click(function() {
		$('#personasRelacionadas').hide();
		$('#divGridBeneficiarios').hide();
	});
	$('#beneficiarioInver').click(function() {
		if($('#inversionID').val()>0  && Var_FechaInicioReinversion == parametroBean.fechaSucursal){  // XX.XX
			inicializaForma('formaGenerica2','');
			$('#personasRelacionadas').show();
		}else{
			$('#personasRelacionadas').hide();
		}
		consultaBeneficiariosGrid();
	});

	//-------------FUNCIONES ----------------------------------------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true
			},
			cuentaAhoID: {
				required: true
			},
			tipoInversionID: {
				required: true
			},
			monto: {
				required: true
			},
			plazo: {
				required: true
			},
			fechaVencimiento: {
				required: true
			}
		},
		messages: {
			clienteID: {
				required: 'Especifique número de cliente'
			},
			cuentaAhoID: {
				required: 'Especifique la cuenta del cliente'
			},
			tipoInversionID: {
				required: 'Especifique el tipo de Inversión'
			},
			monto: {
				required: 'La cantidad a invertir esta vacia'
			},
			plazo: {
				required: 'Indicar el plazo de la inversión'
			},
			fechaVencimiento: {
				required: 'Indicar fecha de vencimiento'
			}
		}
	});

	function obtenDia(){
	    return parametroBean.fechaSucursal;
	}

	function fechaHabil(fechaPosible, idControl){
		var diaFestivoBean = {
				'fecha':fechaPosible,
				'numeroDias':0,
				'salidaPantalla':'S'
		};
		setTimeout("$('#cajaLista').hide();", 200);
		diaFestivoServicio.calculaDiaFestivo(1,diaFestivoBean, function(data) {
				if(data!=null){
					$('#fechaVencimiento').val(data.fecha);
					var opeFechaBean = {
						'primerFecha':$('#fechaVencimiento').val(),
						'segundaFecha': parametroBean.fechaSucursal
					};

					operacionesFechasServicio.realizaOperacion(opeFechaBean,catOperacFechas.restaFechas,
																			  function(data) {
						if(data!=null){
							$('#plazo').val(data.diasEntreFechas);
							CalculaValorTasa(idControl);
						}else{
							mensajeSis("A ocurrido un error Interno al Consultar Fechas...");
						}
					});
				}else{
					mensajeSis("A ocurrido un error Interno...");
				}
		});
	}

	function validaInversion(idControl){
		var jqInversion = eval("'#" + idControl + "'");
		var numInversion = $(jqInversion).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numInversion != 0  && numInversion != '' && numInversion >0 && esTab == true){

			var InversionBean = {
				'inversionID' : numInversion
			};

			inversionServicioScript.consulta(catTipoConsultaInversion.principal,
														InversionBean, function(inversionCon){


				if(inversionCon!=null){
					var estatus = inversionCon.estatus;
					$('#estatus').val(inversionCon.estatus);
					varError = 0;
					Var_TipoBeneficiario = inversionCon.beneficiario;
					estatusISR = inversionCon.estatusISR;
					dwr.util.setValues(inversionCon);
					if(estatus == catStatusInversion.cancelada){
						mensajeSis("La Inversión se Encuentra Cancelada.");
						varError = 1;
						$('#personasRelacionadas').hide();
					}
					if(estatus == catStatusInversion.pagada){
						mensajeSis("La Inversión ya fue Pagada (Abonada a Cuenta).");
						$('#interesConsulta').val(inversionCon.interesRecibir);
						$('#montoConsulta').val(inversionCon.monto);
						$('#montoConsulta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
						consultaCtaAho(inversionCon.cuentaAhoID);
						consultaCliente(inversionCon.cuentaAhoID);
						consultaDireccion(inversionCon.cuentaAhoID);
						validaTipoInversion();
						varError = 1;
						$('#personasRelacionadas').hide();
					}
					if(estatus == catStatusInversion.alta){
						mensajeSis("La Inversión No ha sido Autorizada.");
						varError = 1;
						$('#personasRelacionadas').hide();
					}
					if(estatus == catStatusInversion.cargada){
						if(inversionCon.fechaVencimiento != parametroBean.fechaSucursal){
							mensajeSis("La Fecha de Vencimiento de la Inversión No es el Día de Hoy.");
							varError = 1;
							$('#personasRelacionadas').hide();
						}
						esTab = true;

						$('#clienteID').val(inversionCon.clienteID);
						$('#cuentaAhoID').val(inversionCon.cuentaAhoID);
						$('#tipoInversionID').val(inversionCon.tipoInversionID);
						$('#montoConsulta').val(inversionCon.monto);
						$('#tasaISR').val(inversionCon.tasaISR);
						$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
						$('#interesConsulta').val(inversionCon.interesRecibir);
						$('#plazo').val(inversionCon.plazo);
						$('#etiqueta').val(inversionCon.etiqueta);
						$('#fechaInicio').val(parametroBean.fechaSucursal);

						if(inversionCon.beneficiario=='S'){
							//carga el valor que trae la consulta
							$('#beneficiarioSocio').attr("checked",true);
							$('#beneficiarioInver').attr("checked",false);
						}else if(inversionCon.beneficiario=='I'){
							$('#beneficiarioInver').attr("checked",true);
							$('#beneficiarioSocio').attr("checked",false);
						}

						reinvertirInv=inversionCon.reinvertir;
						CalculaFechaVencimiento();//Calcula la Fecha de Vencimiento en Base al Plazo
						$('#montoConsulta').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#interesConsulta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});

						consultaCtaAho(inversionCon.cuentaAhoID);
						consultaCliente(inversionCon.cuentaAhoID);
						consultaDireccion(inversionCon.cuentaAhoID);

						if(varError == 0){
							habilitaBoton('reinvertirBoton', 'submit');
							habilitaBoton('cancelar', 'submit');
							habilitaControl('etiqueta');
							habilitaControl('fechaVencimiento');
							habilitaControl('plazo');
						}
						Var_FechaInicioReinversion =parametroBean.fechaSucursal; // setteamos la fecha de inicio de la Reinversion
						if(inversionCon.fechaInicio == parametroBean.fechaSucursal){
							if(inversionCon.beneficiario == 'S' ){
								$('#personasRelacionadas').hide();
								$('#divGridBeneficiarios').hide();
							}else{
								$('#personasRelacionadas').show();
								consultaBeneficiariosGrid();
							}
						}else{
							if(inversionCon.beneficiario == 'S' ){
								$('#personasRelacionadas').hide();
								$('#divGridBeneficiarios').hide();
							}else{
								$('#personasRelacionadas').hide();
								consultaBeneficiariosGrid();
							}
						}


					}// Inversion Vigente
					reiniciaCombos2();
					agregaFormatoControles('formaGenerica');
					$("#inversionIDBen").val($("#inversionID").val());
					$("#clienteIDBen").val(inversionCon.clienteID);
					$('#telefono').setMask('phone-us');
					if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
						consultaHuellaCliente();
					}
					if(varError != 0){
						consultaCtaAho();
						consultaCliente();
						consultaDireccion();
						deshabilitaBoton('reinvertirBoton', 'submit');
						deshabilitaBoton('cancelar', 'submit');
						deshabilitaControl('etiqueta');
						deshabilitaControl('fechaVencimiento');
						deshabilitaControl('tipoReinversion');
						deshabilitaControl('plazo');
					}
				}else{ //Consulta sin resultados
					inicializaForma('formaGenerica','inversionID');
					mensajeSis("La Inversión no Existe.");
					$(jqInversion).focus();
					$(jqInversion).val('');
				}
			});
		}
	}
	function CalculaFechaVencimiento(){
		//Calcula la Fecha de Vencimiento en Base al Plazo
		var opeFechaBean = {
			'primerFecha':parametroBean.fechaSucursal,
			'numeroDias':$('#plazo').val()
		};
		operacionesFechasServicio.realizaOperacion(opeFechaBean,catOperacFechas.sumaDias,
																	function(data) {
			if(data!=null){
				$('#fechaVencimiento').val(data.fechaResultado);
				//Calcula la Fecha Habil y la Tasa de Inversion
				fechaHabil($('#fechaVencimiento').val(), 'plazo');
			}else{
				mensajeSis("A ocurrido un error Interno al Consultar Fechas...");
			}
		});
	}

	function consultaCliente() {
		var numCliente = $('#clienteID').val();
		var rfc = ' ';
		var NOPagaISR = 'N';

		if(numCliente!='0' && esTab){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente) && esTab){
				clienteServicio.consulta(catTipoConsultaCliente.paraInversiones,
												 numCliente,rfc,function(cliente){
							if(cliente!=null){
								listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
								consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB',esCliente);
								if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
								$('#clienteID').val(cliente.numero);
								$('#nombreCompleto').val(cliente.nombreCompleto);
								$('#telefono').val(cliente.telefonoCasa);
								$('#telefono').setMask('phone-us');
								if(cliente.pagaISR == NOPagaISR){
									$('#tasaISR').val(0);
								}else{
									$('#tasaISR').val(parametroBean.tasaISR);
								}
								$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
								}else{
									mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
									
									$('#clienteID').focus();
									$('#clienteID').val('');
									$('#nombreCompleto').val('');
									$('#direccion').val('');
									$('#telefono').val('');
					
								}
							}else{
								mensajeSis("No Existe el Cliente.");
								$('#clienteID').focus();
								$('#clienteID').val('');
								$('#nombreCompleto').val('');
								$('#direccion').val('');
								$('#telefono').val('');
							}
					});
				}
		}
	}


	function consultaDireccion() {
		var numCliente = $('#clienteID').val();
		var conOficial = 3;
		var direccionCliente = {
  			'clienteID':numCliente
		};
		setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente) && esTab){
				direccionesClienteServicio.consulta(conOficial,direccionCliente,function(direccion) {
						if(direccion!=null){
							$('#direccion').val(direccion.direccionCompleta);
						}else{
							$('#direccion').val('');
						}
				});
			}
	}

	function consultaCtaAho(control) {
		var numCta = $('#cuentaAhoID').val();
		var CuentaAhoBeanCon = {
			'cuentaAhoID':numCta,
			'clienteID':$('#clienteID').val()
		};
		if(numCta != '' && !isNaN(numCta) && esTab){
          cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCuentas.conSaldo,
          													CuentaAhoBeanCon, function(cuenta) {
          	if(cuenta.saldoDispon!=null){
          			$('#cuentaAhoID').val(cuenta.cuentaAhoID);
          			$('#totalCuenta').val(cuenta.saldoDispon);
              		$('#totalCuenta').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
              		$('#tipoMoneda').html(cuenta.descripcionMoneda);
              		$('#tipoMonedaInv').html(cuenta.descripcionMoneda);
              		$('#monedaID').val(cuenta.monedaID);

              		if(cuenta.estatus != catStatusCuenta.activa){
            			mensajeSis("La Cuenta no esta Activa.");
		          		$('#cuentaAhoID').focus();
							$('#cuentaAhoID').select();
              		}else{
							var totalInversion = $('#montoConsulta').asNumber() +
														$('#interesConsulta').asNumber();

							$('#totalDisponible').val(totalInversion + $('#totalCuenta').asNumber());
							$('#totalDisponible').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
							$('#monto').val(totalInversion.toFixed(2));
							$('#monto').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
              			validaTipoInversion();
              			//Para que Realizae los Calculos Disparamos el Evento change del Control Plazo
							$('#plazo').change();
              		}
          	}else{
          		mensajeSis("La Cuenta no Existe.");
          		$('#totalCuenta').val("");
          		$('#inversionID').focus();
					$('#inversionID').select();
          	}
			});
		}
	}

	function validaTipoInversion(){
		var tipoInver = $('#tipoInversionID').val();
		var TipoInversionBean ={
			'tipoInvercionID' :tipoInver,
			'monedaId': $('#monedaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoInver != '' && !isNaN(tipoInver) && esTab){
			if(tipoInver != 0){

				tipoInversionesServicio.consultaPrincipal(catTipoConsultaTipoInversion.principal,
																		TipoInversionBean, function(tipoInversion){
					if(tipoInversion!=null){
						seleccionaTipoReinversion(tipoInversion.reinvertir);
						$('#descripcion').val(tipoInversion.descripcion);
						$('#tipoInversionID').val(tipoInversion.tipoInvercionID);
					}else{
						seleccionaTipoReinversion('');
						$('#descripcion').val('');
						mensajeSis("El tipo de Inversión no Existe o no Corresponde con la Moneda de la Cuenta.");
						$('#inversionID').focus();
						$('#inversionID').select();
					}
				});
			}
		}
	}

	/**
	 * Función para consultar el Estatus del Tipo de Inversión
	 */
	function consultaEstatusTipoInversion(){
		var tipoInver = $('#tipoInversionID').val();
		var TipoInversionBean ={
			'tipoInvercionID' :tipoInver,
			'monedaId': 0
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoInver != '' && !isNaN(tipoInver)){
			if(tipoInver != 0){
				tipoInversionesServicio.consultaPrincipal(catTipoConsultaTipoInversion.general,TipoInversionBean,{ async: false, callback: function(tipoInversion){
					if(tipoInversion!=null){
						if(tipoInversion.estatus == "I"){
							mensajeSis("No se puede reinvertir debido a que el Producto "+ tipoInversion.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
							$('#inversionID').focus();
							$('#inversionID').select();
							deshabilitaBoton('reinvertirBoton', 'submit');
						}else{
							habilitaBoton('reinvertirBoton', 'submit');
						}
					}
				}});
			}
		}
	}

	function seleccionaTipoReinversion(opcion){

		switch(opcion){
			case('C'):
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL' });
				break;
			case('CI'):
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions( "tipoReinversion", {'CI':'CAPITAL MAS INTERESES'});
				break;
			case('I'):
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions( "tipoReinversion", {'C':'SOLO CAPITAL','CI':'CAPITAL MAS INTERESES'});
				break;
			case('N'):
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions( "tipoReinversion", {'N':'NO SE REALIZARÁ REINVERSIÓN'});
				break;
		}
		$('#tipoReinversion').val(reinvertirInv).selected = true;// Seleccionamos por default el tipo de reinverion seleccionada en la inversion inicial

	}

	function CalculaValorTasa(idControl){
		var jqControl = eval("'#" + idControl + "'");
		var tipoCon = 4;
		var cantidad = creaBeanTasaInversion();
		if(cantidad.monto.toFixed(2) <= $('#totalDisponible').asNumber()){
				if($('#plazo').val() != '' && $('#plazo').val() != 0
					 && $('#monto').val() != '' && $('#monto').val() != 0){
					var variables = creaBeanTasaInversion();
					tasasInversionServicio.consultaPrincipal(tipoCon,variables, function(porcentaje){
						if(porcentaje.conceptoInversion!=0){
							$('#tasa').val(porcentaje.conceptoInversion);
							$('#tasa').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
							$('#valorGat').val(porcentaje.valorGat);
							$('#valorGatReal').val(porcentaje.valorGatReal);

							if(pusoFecha==1 && esTab==false){
								$('#fechaVencimiento').focus();
							}
							pusoFecha=0;
							//Habilita los Botones de Grabar o Modificar
							if(!isNaN($('#inversionID').val())){
								if(varError == 0){
									consultaEstatusTipoInversion();
								}
								else{
									deshabilitaBoton('cancelar','submit');
									deshabilitaBoton('reinvertirBoton', 'submit');
								}
							}
								calculaCondicionesInversion();
						}else{
							mensajeSis("No Existe una Tasa Anualizada.");
							$(jqControl).focus();
							$('#fechaVencimiento').val('');
							$('#plazo').val('');
						}
					});

				}
		}else{
			mensajeSis("El Monto de la Inversión es superior al Saldo de la Cuenta.");
			$(jqControl).focus();
			$(jqControl).select();
		}
	}

	function calculaCondicionesInversion(){
		if(estatusISR != 'A'){
			var interGenerado;
			var interRetener;
			var interRecibir;
			var total;

			if($('#tasaISR').asNumber()<=$('#tasa').asNumber()){
				$('#tasaNeta').val( $('#tasa').asNumber() - $('#tasaISR').asNumber());
			}else{
				$('#tasaNeta').val(0.00);
			}
			$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});

			interGenerado = (($('#monto').asNumber() * $('#tasa').asNumber() * $('#plazo').asNumber()) / (diasBase*100));
			$('#interesGenerado').val(interGenerado);
			$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

			diasBase = parametroBean.diasBaseInversion;
			salarioMinimo = parametroBean.salMinDF;
			var salarioMinimoGralAnu = parametroBean.salMinDF * 5 * parametroBean.diasBaseInversion; // Salario minimo General Anualizado
			// SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
			//entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
			// si no es CERO
			// Al pagar intereses a una persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exención alguna.
			var vartipoPersona = '';

			clienteServicio.consulta(1,$('#clienteID').val(),{ async: false, callback:function(cliente) {
				if(cliente!=null){
					vartipoPersona=cliente.tipoPersona;
				}
			}});

			if($('#monto').asNumber()> salarioMinimoGralAnu || vartipoPersona == 'M'){
				if(vartipoPersona == 'M'){
					interRetener = (($('#monto').asNumber() * $('#tasaISR').val() * $('#plazo').val()) / (diasBase*100));
				}else{
					interRetener = ((($('#monto').asNumber()-salarioMinimoGralAnu ) * $('#tasaISR').val() * $('#plazo').val()) / (diasBase*100));
				}
			}else{
				interRetener = 0.00;
			}

			$('#interesRetener').val(interRetener);
			$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

			interRecibir = interGenerado - interRetener;
			$('#interesRecibir').val(interRecibir);
			$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

			total = $('#monto').asNumber() + interRecibir;

			$('#granTotal').val(total);
			$('#granTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		}
	}

	function creaBeanTasaInversion(){
		var tasasInversionBean = {
				'tipoInvercionID' : $('#tipoInversionID').val(),
				'diaInversionID' : $('#plazo').val(),
				'monto' : $('#monto').asNumber()
		};
		return tasasInversionBean;
	}


	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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

	/***********************************/
	//FUNCION PARA MOSTRAR O OCULTAR BOTONES CALCULAR CURP o RFC
	//PRIMER PARAMETRO ID BOTON CURP
	//SEGUNDO PARAMETRO ID BOTON RFC
	//TERCER PARAMETRO 1= SOLO CURP, 2= SOLO RFC, 3= AMBOS
	function permiteCalcularCURPyRFC(idBotonCURP,idBotonRFC,tipo) {
		var jqBotonCURP = eval("'#" + idBotonCURP + "'");
		var jqBotonRFC = eval("'#" + idBotonRFC + "'");
		var numEmpresaID = 1;
		var tipoCon = 17;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				//Validacion para mostrarar boton de calcular CURP Y RFC
				if(parametrosSisBean.calculaCURPyRFC == 'S'){
					if(tipo == 3){
						$(jqBotonCURP).show();
						$(jqBotonRFC).show();
					}else{
						if(tipo == 1){
							$(jqBotonCURP).show();
						}else{
							if(tipo == 2){
								$(jqBotonRFC).show();
							}
						}
					}
				}else{
					if(tipo == 3){
						$(jqBotonCURP).hide();
						$(jqBotonRFC).hide();
					}else{
						if(tipo == 1){
							$(jqBotonCURP).hide();
						}else{
							if(tipo == 2){
								$(jqBotonRFC).hide();
							}
						}
					}
				}
			}
		});
	}

	function validaAutorizacionHuellaCliente(){
		paramGeneralesServicio.consulta(35,{},{async: false, callback:function(parametro) {
			if (parametro != null) {
				autorizaHuellaCliente = parametro.valorParametro;
			} else {
				autorizaHuellaCliente = 'N';
				mensajeSis('Ha ocurrido un error al consultar los parámetros del sistema.');
			}
		}});
	}

	// función para consultar si el cliente ya tiene huella digital registrada
	function consultaHuellaCliente(){

		var numCliente=$('#clienteID').val();
		if(numCliente != '' && !isNaN(numCliente )){
			var huellaDigitalBean = {
				'personaID'	  :$('#clienteID').val(),
				'cuentaAhoID' :$('#cuentaAhoID').val()
			};

			huellaDigitalServicio.consulta(catHuellaDigital.noHuellas, huellaDigitalBean, {
				async: false,
				callback:function(huellaDigitalBeanResponse) {
					if (huellaDigitalBeanResponse != null){
						if (huellaDigitalBeanResponse.noHuellas == 0 || huellaDigitalBeanResponse.noHuellas == '0'){
							mensajeSis("No es posible realizar la operación:<br> <b>No Reinvertir(Abonar Inversión)</b>.<br>El cliente no tiene una huella registrada.");
							huellaCliente = 'N';
							deshabilitaBoton('cancelar', 'submit');
						}else {
							huellaCliente = 'S';
							habilitaBoton('cancelar', 'submit');
						}
					}else {
						mensajeSis("Ha ocurrido un error al consultar el No. de Huellas del cliente y los firmantes.");
					}
				},
				errorHandler : function(message, exception) {
					mensajeSis("Error en Consulta de Huellas Digitales del Cliente.<br>" + message + ":" + exception);
				}
			});
		}
	}
});//fin documen ready

function exito(){

	if($('#numeroMensaje').val()){
		deshabilitaBoton('reinvertirBoton', 'submit');
		deshabilitaBoton('cancelar', 'submit');
		soloLecturaControl('etiqueta');
		soloLecturaControl('fechaVencimiento');
		soloLecturaControl('plazo');
		soloLecturaControl('monto');
		if($('#botonImprimir').val()=="S"){
			habilitaBoton('imprime', 'boton');
		}else{
			deshabilitaBoton('imprime', 'boton');
		}
	}
	proceso = false;
}

function error(){
	deshabilitaBoton('reinvertirBoton', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	deshabilitaBoton('imprime', 'boton');
	proceso = false;
}