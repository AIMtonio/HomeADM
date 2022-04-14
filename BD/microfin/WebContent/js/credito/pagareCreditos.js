var huellaProductos = '';
var catFormTipoCalInt = {
		'principal'	: 1,
};
var TasaFijaID 			= 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho 	= 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var VarTasaFijaoBase 	= 'Tasa Fija'; // Texto que indica si se trata de tasa fija o tasa base actual (alert)
var diasMaximo = 0; // Indica el maximo numero dias a los que se puede desembolsar un credito antes de su fecha de inicio
var cobraAccesorios = 'N';
var frecuenciaQuincenal = 'Q';
var diaPagoQuincenalCal = '';
var labelDiaPago = '';
var textoDiaPago = '';
var esProductoNomina = 'N';
var manejaConvenio = 'N';
var noSeguirPro = false;
var existeReferencia = 'N';
var requiereReferencias = 'N';
var referenciaTelecom = '';
var referenciaBanorte = '';
var fechaNacimiento = '1900-01-01';
var estadoID = '';
var municipioID = '';
var  anio= '';
var mes = '';
var dia= '';

var catTipoTransaccionCredito = {
		'agrega':'1',
		'modifica':'2',
		'actualiza':'3',
		'actNumTraSim':'5',
	'actuaCredi':'6',
	'actTmp':'7',
		'simulador':'9'
};

catTipoActCredito = {
		'autoriza':'1',
		'autorizaPagImp':'2',
		'actualizaCred':'4',
		'actualizaCredAmor':'30',
		'actTmpPagAmor':'5',
		'actCuentaClabe':'17'
};

var catTipoConsultaCredito = {
		'principal'	: 1,
		'foranea'	: 2,
		'pagareImp' : 3,
		'ValidaCredAmor':4,
		'fechaVencimiento':14
};

var catEstatusCredito = {
	'autorizado':'A',
	'inactivo':'I',
	'procesado':'M',
};

var catNumClienteEsp = {
	'tamazula':28,
	'santaFe':29,
	'SOFINI' : 42,
	'Consol' : 10,
	'Confiadora':46,
	'asefimex':43
};
var var_RefPayCash = "";

  $(document).ready(function() {
        
		$("#creditoID").focus();
		//Métodos para el Manejo de Convenios
            consultaManejaConvenios();
		 if(manejaConvenio=='S'){
		listaCatQuinquenios();
	     }
		  

		var parametroBean = consultaParametrosSession();
		$('#tipo').val(3);
		$('#fechaInicio').val(parametroBean.fechaSucursal);
		llenaComboPlazoCredito();
		var nombreInstitucion;
		var estatus;
		var inicioAfuturo = ''; // indica si el producto de credito permite el desembolso anticipado del credito
		var autorizado = 'A';
		var inactivo = 'I';
		var procesado = 'M';
		var modificaMontoCred = "";
		validaModificaMontoCred();

		// ============================= Definicion de Constantes y Enums   =========================

		deshabilitaBoton('grabar', 'submit');
		deshabilitaBoton('exportarPDF', 'submit');
		deshabilitaBoton('ExptablaAmorti', 'submit');
		deshabilitaBoton('caratula', 'submit');
		deshabilitaBoton('imprimir', 'submit');
		deshabilitaBoton('simular', 'submit');
		deshabilitaBoton('ExportExcel', 'submit');
		deshabilitaBoton('generarCuentaClabe','submit');
		validaEmpresaID();
		$('#pregagos').hide();
		$('#fieldOtrasComisiones').hide();



		// ==================================== MANEJO DE EVENTOS ===================================
		$('#grabar').click(function() {		//boton grabar
			var numClienteEspecifico = $('#numClienteEspec').asNumber();
			$('#tipoTransaccion').val(catTipoTransaccionCredito.actuaCredi);
			if(numClienteEspecifico == catNumClienteEsp.asefimex){
				generaReferencias();
				consultaInstitucionBanorte();
				consultaInstitucionTelecom();				
			}
		});

		$('#fechaMinistrado').blur(function() {
		var estatusCred = $('#estatus').val();
			if(this.value != '' && estatusCred == autorizado || estatusCred == inactivo || estatusCred == procesado){
				eventoBlurChangeFechaMinistrado();
			}
		});

		$('#fechaMinistrado').change(function() {
			this.focus();
		});

		$('#exportarPDF').click(function() {
			var credito = $('#creditoID').val();
			var mc = 	$('#montoCredito').asNumber();
			var tb = $('#tasaBase').asNumber();
			var ci =   $('#calcInteresID').asNumber();
			var mon=		$('#monedaID').asNumber();
			var tt= catTipoTransaccionCredito.actualiza;
			var ta= catTipoActCredito.autorizaPagImp;
			var numeroUsuario = parametroBean.numeroUsuario;
			var nombreInstitucion =  parametroBean.nombreInstitucion.toUpperCase();
			var fechaEmision = parametroBean.fechaSucursal;
			var dirInst = parametroBean.direccionInstitucion;
			var RFCInst = parametroBean.rfcInst;
			var telInst = parametroBean.telefonoLocal;
			var sucursal= parametroBean.sucursal;
			var gerente	= parametroBean.gerenteGeneral;
			var	montoCuot=  $('#montoCuota').asNumber();
			var calcInteres = $('#calcInteresID').val();
			var leyenda = encodeURI($('#lblTasaVariable').text().trim());
			var tipoPagareSOFINI = 13;
			var tipoContratoUnico = 18;


			if($('#numClienteEspec').asNumber() == catNumClienteEsp.tamazula ){
				var url = 'RepPDFPagareCredito.htm?calcInteresID=0'+
				'&tipoReporte=12'+
				'&creditoID='+credito;
				window.open(url, '_blank');
				return;
			}else{
					if($('#numClienteEspec').asNumber() == catNumClienteEsp.SOFINI && esProductoNomina == 'S'){
						var url = 'RepPDFPagareCredito.htm?calcInteresID=0'+
						'&tipoTransaccion='+tt+
						'&tipoActualizacion='+ta+
						'&tipoReporte='+tipoPagareSOFINI +
						'&creditoID='+credito+
						'&nombreInstitucion='+nombreInstitucion;
						window.open(url, '_blank');
						return;
					}else{
							if($('#numClienteEspec').asNumber() == catNumClienteEsp.Confiadora){
									var clienteID = $('#clienteID').val();
									generarPagareMicrocreditoConfiadora(credito,  clienteID);
							    }

							else{
								if($('#numClienteEspec').asNumber() == catNumClienteEsp.Consol){
									generarPagareMicrocredito(credito,  fechaEmision);
								} else{
									if($('#numClienteEspec').asNumber() == catNumClienteEsp.asefimex){
										
										var url = 'RepPDFPagareCredito.htm?creditoID='+credito+'&calcInteresID=0&tipoReporte='+tipoContratoUnico;
							    		window.open(url, '_blank');
							    		
							    		
										var url = 'RepPDFPagareCredito.htm?calcInteresID='+ci+
										'&montoCredito='+mc+
										'&tasaBase='+tb+
										'&creditoID='+credito+
										'&tipoTransaccion='+tt+
										'&tipoActualizacion='+ta+
										'&monedaID='+mon+
										'&usuario='+numeroUsuario+
										'&nombreInstitucion='+nombreInstitucion+
										'&producCreditoID='+$('#reca').val()+
										'&sucursalID='+sucursal+
										'&gerenteSucursal='+gerente+
										'&direccionInstit='+dirInst+
										'&RFCInstit='+RFCInst+
										'&telefonoInst='+telInst+
										'&fechaSistema='+fechaEmision+
										'&montoCuota='+montoCuot+
										'&calcInteres='+calcInteres+
										'&leyendaTasaVariable='+leyenda;
										window.open(url, '_blank');
										
									}else {
										var url = 'RepPDFPagareCredito.htm?calcInteresID='+ci+
										'&montoCredito='+mc+
										'&tasaBase='+tb+
										'&creditoID='+credito+
										'&tipoTransaccion='+tt+
										'&tipoActualizacion='+ta+
										'&monedaID='+mon+
										'&usuario='+numeroUsuario+
										'&nombreInstitucion='+nombreInstitucion+
										'&producCreditoID='+$('#reca').val()+
										'&sucursalID='+sucursal+
										'&gerenteSucursal='+gerente+
										'&direccionInstit='+dirInst+
										'&RFCInstit='+RFCInst+
										'&telefonoInst='+telInst+
										'&fechaSistema='+fechaEmision+
										'&montoCuota='+montoCuot+
										'&calcInteres='+calcInteres+
										'&leyendaTasaVariable='+leyenda;
										window.open(url, '_blank');
									}
									
								}
				            	}
				        }
			    }

		});

		$('#ExptablaAmorti').click(function() {
			var credito = $('#creditoID').val();
			var mc = 	$('#montoCredito').asNumber();
			var ci =   "10"; //para generar reporte solo tabla AMORTICREDITO
			var mon=		$('#monedaID').val();
			var tt= catTipoTransaccionCredito.actualiza;
			var ta= catTipoActCredito.autorizaPagImp;
			var producto = $('#nombreProd').val();
			var fechaDes = $('#fechaMinistrado').val();
			var clienteID = $('#clienteID').val();
			var calcInteres = $('#calcInteresID').val();
			var leyenda = encodeURI($('#lblTasaVariable').text().trim());
			var tabalAmorAsefimex = 17;
			
			nombreInstitucion =  parametroBean.nombreInstitucion.toUpperCase();
			var numClienteEspecifico = $('#numClienteEspec').asNumber();
			if(numClienteEspecifico == catNumClienteEsp.asefimex){
				consultaReferencias();
				if(requiereReferencias == 'S'){
					if(existeReferencia == 'S' ){
						var url = 'RepPDFPagareCredito.htm?calcInteresID=0'+
					'&creditoID='+credito+
					'&clienteID='+clienteID+
					'&tipoReporte='+tabalAmorAsefimex;
					window.open(url, '_blank');
					}else{
						mensajeSis('El Crédito no tiene capturado sus Referencias');
						$('#creditoID').focus();
						$('#creditoID').select();
					}
				}else{
					var url = 'RepPDFPagareCredito.htm?calcInteresID=0'+
					'&creditoID='+credito+
					'&clienteID='+clienteID+
					'&tipoReporte='+tabalAmorAsefimex;
					window.open(url, '_blank');
				}
				
			}else{
				var url = 'RepPDFPagareCredito.htm?clienteID='+clienteID+'&calcInteresID='+ci+'&montoCredito='+mc+
				'&fechaMinistrado='+fechaDes+'&nombreProducto='+producto+'&creditoID='+credito+
				'&tipoTransaccion='+tt+'&tipoActualizacion='+ta+'&monedaID='+mon+'&nombreInstitucion='+nombreInstitucion+
				'&calcInteres='+calcInteres+'&leyendaTasaVariable='+leyenda;
				window.open(url, '_blank');
			}
			

			
		});

		$('#caratula').click(function() {
			var credito = $('#creditoID').val();
			var producto = $('#producCreditoID').val();
			var numClienteEspecifico = $('#numClienteEspec').asNumber();
			var numeroUsuario = parametroBean.numeroUsuario;
			var sucursal      = parametroBean.sucursal;
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var dirInst = parametroBean.direccionInstitucion;
			var telInst = parametroBean.telefonoLocal;
			var fechaSistema = parametroBean.fechaSucursal;
			var solicitudCredito = $('#solicitudCreditoID').val();
			var ci = "8";
			var monedaID = $('#monedaID').asNumber();
			var montoCredito = $('#montoCredito').val();
	 		var tipoRepAnex = 1;
			 var tipoContratoSOFINI = 14;
			 var tipoCaratulaAsefimex = 15;
			 var tipoPresentacionAsefimex = 16;
			 var tipoContratoUnico = 18;
			 var RFCInst = parametroBean.rfcInst;
			 var calcInteres = $('#calcInteresID').val();


	 		if(numClienteEspecifico == catNumClienteEsp.SOFINI && esProductoNomina == 'S'){
	 			var url = 'RepPDFPagareCredito.htm?calcInteresID=0'+
				'&tipoReporte='+tipoContratoSOFINI +
				'&creditoID='+credito +
				'&nombreInstitucion='+nombreInstitucion;
	 			window.open(url, '_blank');
	 			return;
	 		}else{
				if(numClienteEspecifico == catNumClienteEsp.santaFe){
					var ci = "11";
					var_RefPayCash = "";
					var url = 'RepPDFPagareCredito.htm?creditoID='+credito+'&usuario='+numeroUsuario+'&sucursal='+sucursal+
						'&nombreInstitucion='+nombreInstitucion+'&calcInteresID='+ci+'&solicitudCreditoID='+solicitudCredito+
						'&monedaID='+monedaID+'&montoCredito='+montoCredito+'&tipoReporte='+tipoRepAnex+'&refPayCas='+var_RefPayCash;

					window.open(url, '_blank');
				}else{
					if(numClienteEspecifico == catNumClienteEsp.Consol){
						generarContratoMicrocredito(credito, producto,  monedaID, montoCredito,
							nombreInstitucion,RFCInst, dirInst, telInst, calcInteres, fechaSistema);
					}else{
						if(numClienteEspecifico == catNumClienteEsp.Confiadora){
							var clienteID = $('#clienteID').val();
							generarContratoMicrocreditoConfiadora(credito, clienteID);
					    }else{
					    	
					    	if(numClienteEspecifico == catNumClienteEsp.asefimex){
					    		var url = 'RepPDFPagareCredito.htm?creditoID='+credito+'&usuario='+numeroUsuario+'&sucursal='+sucursal+
								'&nombreInstitucion='+nombreInstitucion+'&calcInteresID=0&solicitudCreditoID='+solicitudCredito+
								'&numProducCre='+producto+'&monedaID='+monedaID+'&montoCredito='+montoCredito+'&tipoReporte='+tipoCaratulaAsefimex;
					    		
					    		window.open(url, '_blank');
					    		
					    		var url = 'RepPDFPagareCredito.htm?creditoID='+credito+'&usuario='+numeroUsuario+'&sucursal='+sucursal+
								'&nombreInstitucion='+nombreInstitucion+'&calcInteresID=0&solicitudCreditoID='+solicitudCredito+
								'&numProducCre='+producto+'&monedaID='+monedaID+'&montoCredito='+montoCredito+'&tipoReporte='+tipoPresentacionAsefimex;
					    		window.open(url, '_blank');
					    		
					    		var url = 'RepPDFPagareCredito.htm?creditoID='+credito+'&calcInteresID=0&tipoReporte='+tipoContratoUnico;
					    		window.open(url, '_blank');
					    		
					    	}else{
					    		var url = 'RepPDFPagareCredito.htm?creditoID='+credito+'&usuario='+numeroUsuario+'&sucursal='+sucursal+
								'&nombreInstitucion='+nombreInstitucion+'&calcInteresID='+ci+'&solicitudCreditoID='+solicitudCredito+
								'&numProducCre='+producto+'&monedaID='+monedaID+'&montoCredito='+montoCredito;
		
								window.open(url, '_blank');
					    	}
					    }

					}
				}
			 }


		});

		$('#creditoID').bind('keyup',function(e){
			lista('creditoID', '2', '1', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');

		});

		$('#creditoID').blur(function() {
			$('#fechaMinistrado').focus();
			$('#gridAmortizacion').html("");
			$('#contenedorSimuladorLibre').html("");
			$('#contenedorSimuladorLibre').hide();

			if(isNaN(this.value) || this.value == ''){
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('exportarPDF', 'submit');
				deshabilitaBoton('ExptablaAmorti', 'submit');
				deshabilitaBoton('caratula', 'submit');
				deshabilitaBoton('simular', 'submit');
				deshabilitaBoton('ExportExcel', 'submit');
				inicializaForma('formaGenerica','creditoID');
				deshabilitaBoton('generarCuentaClabe','submit');
				$('#creditoID').select();
				$('#creditoID').focus();
			 }else{
				 validaCredito();
			 }
		});

		$('#simular').click(function() {
			simulador();
		});

		$("#fechaInicioAmor").blur(function (){
			if(!$("#fechaInicioAmor").is('[readonly]')){
				var dias  =  restaFechas(parametroBean.fechaAplicacion, this.value);
				var diasAux;

				if(esFechaValida(this.value)== true){

						if(parseInt(dias) < 0 ){
							mensajeSis("La Fecha de Inicio No debe ser Menor a la Fecha del Sistema.");

							this.value= parametroBean.fechaAplicacion;
							this.focus();
							diasAux  = restaFechas(this.value, $("#fechaMinistrado").val());
							if(parseInt(diasAux) > 0){
								$("#fechaMinistrado").val(parametroBean.fechaAplicacion);
								$("#fechaInicio").val(parametroBean.fechaAplicacion);
							}

						}else{

								if(parseInt(dias) <= diasMaximo ){
									if(!$("#calendIrregularCheck").is(':checked')){ // Empiece a pagar en NO aplica  para pagos de capital LIBRES

										consultaFechaVencimiento('plazoID');
										diasAux = restaFechas(this.value, $("#fechaMinistrado").val());

										if(parseInt(diasAux) > 0){
											$("#fechaMinistrado").val(this.value);
											$("#fechaInicio").val(parametroBean.fechaAplicacion);
										}
									}
									else{

										if(this.value != parametroBean.fechaAplicacion){
											mensajeSis("La Fecha de Inicio de Primer Amortización \nNo Puede Ser Diferente a la Fecha Actual \nCuando el Calendario de Pagos es Irregular.");
											this.value= $("#fechaInicio").val();
											this.focus();
										}
									}

							}else{
								mensajeSis("La Fecha de Pago puede Iniciar en Máximo " + diasMaximo + " Días.");
								this.value=  parametroBean.fechaAplicacion ;
								this.focus();
								diasAux  =  restaFechas(this.value, $("#fechaMinistrado").val());

								if(parseInt(diasAux) > 0){
									$("#fechaMinistrado").val(parametroBean.fechaAplicacion);

									$("#fechaInicio").val(parametroBean.fechaAplicacion);
								}
							}

						}
				}
				else{
					this.value= parametroBean.fechaAplicacion ;
					this.focus();
				}
			}
		});

		$("#fechaInicioAmor").change(function (){
			this.focus();
		});

		$('#ExportExcel').click(function() {
			var tipoReporte 		= 2; // reporte AMORTIZACIONES en la pantalla de Pagare de Credito
			var tipoLista			= 3;
			var tituloReporte 		= 'AMORTIZACIONES - PAGARE DE CREDITO ';
			var fechaActual 		= $('#fechaActual').val();
			var creditoID			= $('#creditoID').val();
			var cobraSeguroCuota	= $('#cobraSeguroCuota').val();
			var usuario 	 		= parametroBean.claveUsuario;
			var nombreInstitucion 	= parametroBean.nombreInstitucion;

			var liga = 'repAmortizacionesCred.htm?'+
					'tituloReporte='+tituloReporte+
					'&creditoID='+creditoID+
					'&tipoReporte='+tipoReporte+
					'&tipoLista='+tipoLista+
					'&cobraSeguroCuota='+cobraSeguroCuota+
					'&fechaSistema='+fechaActual+
					'&nombreUsuario='+usuario.toUpperCase()+
					'&nombreInstitucion='+nombreInstitucion.toUpperCase();
			window.open(liga, '_blank');
		});

		$('#generarCuentaClabe').click(function() {

			$('#tipoTransaccion').val(catTipoTransaccionCredito.actualiza);
			$('#tipoActualizacion').val(catTipoActCredito.actCuentaClabe);
		});

	// ================================= Validaciones de la Forma ========================================
	agregaFormatoControles('formaGenerica');
	$.validator.setDefaults({
		submitHandler: function(event) {
			var tipoActualizacion = $('#tipoActualizacion').val();
			if(tipoActualizacion == catTipoActCredito.actCuentaClabe) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','ExitoPantalla','ErrorPantalla');
			} else {
				var procede = validaFechaMinistrado();
				if(procede == 0){
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','ExitoPantalla','ErrorPantalla');
				}else{
					return false;
				}
			}
	   }
	});
		$('#formaGenerica').validate({
			rules: {
				creditoID: {
					required: true
				},
				fechaMinistrado: {
					date: true
				}
			},
			messages: {
				creditoID: {
					required: 'Especificar Crédito',
				},
				fechaMinistrado: {
					date: 'Fecha Incorrecta'
				}
			}
		});


	// =========================================== FUNCIONES ==============================================

		function validaCredito() {
			var numCredito = $('#creditoID').val();
			var fechaAplicacion = parametroBean.fechaAplicacion;
			var numClienteEspecifico = $('#numClienteEspec').asNumber();
			setTimeout("$('#cajaLista').hide();", 200);

			if(numCredito != '' && !isNaN(numCredito) ){
				var creditoBeanCon = {
						'creditoID':$('#creditoID').val()
				};
				creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
					if(credito!=null){
						dwr.util.setValues(credito);
						$('#institucionNominaID').val(credito.institucionNominaID);
	                    $('#convenioNominaID').val(credito.convenioNominaID);
	                    $('#folioSolici').val(credito.folioSolici);
	                    $('#quinquenioID').val(credito.quinquenioID);
						var esAgropecuario;
						esAgropecuario = credito.esAgropecuario;
						if(esAgropecuario === "S"){
							mensajeSis("El Crédito es de tipo Agropecuario.<br>Consultar en el Módulo <i><u>Cartera Agro</u></i>.");
							$('#creditoID').focus();
							deshabilitaBoton('grabar', 'submit');
							deshabilitaBoton('exportarPDF', 'submit');
							deshabilitaBoton('ExptablaAmorti', 'submit');
							deshabilitaBoton('caratula', 'submit');
							deshabilitaBoton('ExportExcel', 'submit');
							deshabilitaBoton('generarCuentaClabe','submit');
						}
						$('#cat').formatCurrency({
														positiveFormat : '%n',
														roundToDecimalPlace : 1
												 });


						$('#tipoPrepago').val(credito.tipoPrepago);
						if(credito.estatus != catEstatusCredito.autorizado && credito.estatus != catEstatusCredito.inactivo && credito.estatus != catEstatusCredito.procesado){
							deshabilitaControl('tipoPrepago');
						}else{
							habilitaControl('tipoPrepago');
						}

						$('#plazoID').val(credito.plazoID).selected = true;
						$('#montoCredito').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

						fechaMinisAct = $('#fechaMinistrado').val();
						if(credito.fechaMinistrado ==  '1900-01-01' ){
							$('#fechaMinistrado').val(fechaAplicacion);
							$('#fechaMinistradoOriginal').val(fechaAplicacion);
						}else{
							$('#fechaMinistrado').val(credito.fechaMinistrado);
							$('#fechaMinistradoOriginal').val(credito.fechaMinistrado);
						}
						estatus = credito.estatus;
						var creditoID = credito.creditoID;
						if(estatus == catEstatusCredito.inactivo){
							validaModificaMontoCred();
							if(modificaMontoCred == "S"){
								consultaCredMontoAutoMod(creditoID);
							}
						}

						consultaCliente('clienteID');
						if(estatus != catEstatusCredito.autorizado && estatus != catEstatusCredito.inactivo && estatus != catEstatusCredito.procesado){
							deshabilitaControl('fechaMinistrado');
							deshabilitaBoton('grabar', 'submit');
							deshabilitaBoton('generarCuentaClabe','submit');
						}else{
									
							 if(manejaConvenio=='S')
	                    		{
			                        if(noSeguirPro!=true){
			                        	habilitaControl('fechaMinistrado');
										habilitaBoton('grabar','submit');
			                      }else{
			                    	  deshabilitaControl('fechaMinistrado');
									  deshabilitaBoton('grabar','submit');
			                      }
			                    }else{
			                    	habilitaControl('fechaMinistrado');
									habilitaBoton('grabar','submit');
			                    }
						}

						if(numClienteEspecifico == catNumClienteEsp.asefimex){
							validaRequiereReferencias();
						}
						
						consultaHuellaCliente();
						consultaLineaCredito('lineaCreditoID');
						consultaMoneda('monedaID');
						if(credito.tasaBase !=0){
							consultaTasaBase('tasaBase');
						}

						consultaProducCredito('producCreditoID', credito.grupoID, true);
						//Habilitamos el boton de Generacion de Cuenta Clabe para tipos de personas fisicas
						//o fisicas con actividad empresarial
						var tipoPersona = $("#tipoPersonaCli").val();
						var participaSPEI = $("#participaSPEI").val();
						if(participaSPEI == "S" && (tipoPersona=="F" || tipoPersona=="A")) {
							habilitaBoton('generarCuentaClabe','submit');
							$("#generarCuentaClabe").css('display','block');
						}
						else {
							deshabilitaBoton('generarCuentaClabe','submit');
							$("#generarCuentaClabe").css('display','none');
						}
						
						
						if(credito.fechaInhabil=='S'){
							$('#fechaInhabil1').attr("checked","1") ;
							$('#fechaInhabil2').attr("checked",false) ;
							$('#fechaInhabil').val("S");
						}else{
							$('#fechaInhabil2').attr("checked","1") ;
							$('#fechaInhabil1').attr("checked",false);
							$('#fechaInhabil').val("A");
						}

						if(credito.ajusFecExiVen=='S'){
							$('#ajusFecExiVen1').attr("checked","1") ;
							$('#ajusFecExiVen2').attr("checked",false);
							$('#ajusFecExiVen').val("S");
						}else{
							$('#ajusFecExiVen2').attr("checked","1");
							$('#ajusFecExiVen1').attr("checked",false);
							$('#ajusFecExiVen').val("N");
						}

						if(credito.calendIrregular=='S'){
							$('#calendIrregularCheck').attr("checked","1");
							$('#calendIrregular').val("S");
						}else{
							$('#calendIrregularCheck').attr("checked",false);
							$('#calendIrregular').val("N");
						}

						if(credito.ajusFecUlVenAmo=='S'){
							$('#ajusFecUlVenAmo1').attr("checked","1") ;
							$('#ajusFecUlVenAmo2').attr("checked",false) ;
							$('#ajusFecUlVenAmo').val("S");
						}else{
							$('#ajusFecUlVenAmo2').attr("checked","1") ;
							$('#ajusFecUlVenAmo1').attr("checked",false) ;
							$('#ajusFecUlVenAmo').val("N");
						}

						// Si no es Quincenal.
						if(credito.frecuenciaInt != frecuenciaQuincenal){
							textoDiaPago = 'Día del Mes';
							if (credito.diaPagoInteres == 'F') {
								$('#diaPagoInteres1').attr("checked","1");
								$('#diaPagoInteres2').attr("checked",false);
							} else {
								$('#diaPagoInteres2').attr("checked","1");
								$('#diaPagoInteres1').attr("checked",false);
								$('#diaMesInteres').val(credito.diaMesInteres);
							}
							$('#divDiaPagoIntMes').show();
							$('#divDiaPagoIntQuinc').hide();
						} else {// Si es Quincenal.
							textoDiaPago = 'Día de Pago';
							if (credito.diaPagoInteres == 'D') {
								$('#diaPagoInteresD').attr('checked',true);
								$('#diaPagoInteresQ').attr('checked',false);
								$('#diaDosQuincInt').val(Number(credito.diaMesInteres) + 15);
								$('#diaDosQuincInt').show();
							} else {
								$('#diaPagoInteresD').attr('checked',false);
								$('#diaPagoInteresQ').attr('checked',true);
								$('#diaDosQuincInt').val('0');
								$('#diaDosQuincInt').hide();
							}
							$('#divDiaPagoIntMes').hide();
							$('#divDiaPagoIntQuinc').show();
						}
						$('#diaPagoInteres').val(credito.diaPagoInteres);
						$('#labelDiaInteres').text(textoDiaPago+': ');

						// Si no es Quincenal.
						if(credito.frecuenciaCap != frecuenciaQuincenal){
							textoDiaPago = 'Día del Mes';
							if (credito.diaPagoCapital == 'F') {
								$('#diaPagoCapital1').attr("checked","1");
								$('#diaPagoCapital2').attr("checked",false);
							} else {
								$('#diaPagoCapital2').attr("checked","1");
								$('#diaPagoCapital1').attr("checked",false);
								$('#diaMesCapital').val(credito.diaMesCapital);
							}
							$('#divDiaPagoCapMes').show();
							$('#divDiaPagoCapQuinc').hide();
						} else {// Si es Quincenal.
							textoDiaPago = 'Día de Pago';
							if (credito.diaPagoCapital == 'D') {
								$('#diaPagoCapitalD').attr('checked',true);
								$('#diaPagoCapitalQ').attr('checked',false);
								$('#diaDosQuincCap').val(Number(credito.diaMesCapital) + 15);
								$('#diaDosQuincCap').show();
							} else {
								$('#diaPagoCapitalQ').attr('checked',true);
								$('#diaPagoCapitalD').attr('checked',false);
								$('#diaDosQuincCap').val('0');
								$('#diaDosQuincCap').hide();
							}
							$('#divDiaPagoCapMes').hide();
							$('#divDiaPagoCapQuinc').show();
						}
						$('#labelDiaCapital').text(textoDiaPago+': ');

						if(credito.tipoCredito == 'N') {
							$('#tipoCreditoDes').val("NUEVO");

						}

						if((credito.tipoCredito == 'O') && (credito.esReacreditado == "N"))  {
							$('#tipoCreditoDes').val("RENOVACIÓN");

						}

						if((credito.tipoCredito == 'O') && (credito.esReacreditado == "S"))  {
							$('#tipoCreditoDes').val("REACREDITAMIENTO");

						}

						if(credito.tipoCredito == 'R') {
							$('#tipoCreditoDes').val("REESTRUCTURA");

						}
						$('#diaPagoCapital').val(credito.diaPagoCapital);


						muestraGridAccesorios();
						agregaFormatoControles('formaGenerica');

						//Obtenemos la referencia del credito
						var_RefPayCash = credito.refPayCash;



					}else{
							mensajeSis("No Existe el Crédito.");
							$('#creditoID').focus();
							$('#creditoID').val("");
							deshabilitaBoton('grabar', 'submit');
							deshabilitaBoton('exportarPDF', 'submit');
							deshabilitaBoton('ExptablaAmorti', 'submit');
							deshabilitaBoton('caratula', 'submit');
							deshabilitaBoton('simular', 'submit');
							deshabilitaBoton('ExportExcel', 'submit');
							deshabilitaBoton('generarCuentaClabe','submit');
 							inicializaForma('formaGenerica','creditoID');
					}
				});
			}
		}






		function consultaDirCliente() {
			var direccionesCliente ={
				 'clienteID' : $('#clienteID').val(),
				 'direccionID': '0'

			};
			var numCliente = $('#clienteID').val();
			setTimeout("$('#cajaLista').hide();", 200);

			if(numCliente != '' && !isNaN(numCliente)){
				direccionesClienteServicio.consulta(3,direccionesCliente,function(direccion) {
					if(direccion!=null){
						dwr.util.setValues(direccion);
						 if(manejaConvenio=='S'){
		                        if(noSeguirPro!=true){
		                        	habilitaBoton('imprimir', 'submit');
		    						habilitaBoton('exportarPDF', 'submit');
		    						habilitaBoton('ExptablaAmorti', 'submit');
		    						habilitaBoton('caratula', 'submit');
		    						habilitaBoton('ExportExcel', 'submit');
		                      }else{
		                    	deshabilitaBoton('imprimir', 'submit');
		  						deshabilitaBoton('exportarPDF', 'submit');
		  						deshabilitaBoton('ExptablaAmorti', 'submit');
		  						deshabilitaBoton('caratula', 'submit');
		  						deshabilitaBoton('ExportExcel', 'submit');
		                      }
		                    }else{
		                    	habilitaBoton('imprimir', 'submit');
								habilitaBoton('exportarPDF', 'submit');
								habilitaBoton('ExptablaAmorti', 'submit');
								habilitaBoton('caratula', 'submit');
								habilitaBoton('ExportExcel', 'submit');
		                    }
					}else{
						mensajeSis("El cliente no cuenta con una Dirección");
						deshabilitaBoton('imprimir', 'submit');
						deshabilitaBoton('exportarPDF', 'submit');
						deshabilitaBoton('ExptablaAmorti', 'submit');
						deshabilitaBoton('caratula', 'submit');
						deshabilitaBoton('ExportExcel', 'submit');
					}
				});
			}
		}

		//Funcion para validar si se realiza modificacion del Monto de Credito
		function validaModificaMontoCred(){
			paramGeneralesServicio.consulta(30,{},function(parametro){
				if (parametro != null) {
					modificaMontoCred = parametro.valorParametro;
				}
			});
		}

		//Función para consultar los créditos con montos autorizados modificados
		function consultaCredMontoAutoMod(creditoID){
			var tipoConsulta = 43;
			var creditoBeanCon = {
				'creditoID'	:creditoID
			};

			setTimeout("$('#cajaLista').hide();", 200);

			if(creditoID != '' && !isNaN(creditoID)){
				creditosServicio.consulta(tipoConsulta,creditoBeanCon,function(creditos) {
					if(creditos != null){
						if(creditos.simulado == 'N'){
							mensajeSis("El Monto Autorizado del Crédito fue modificado.\nSe requiere volver a Grabar el Pagaré de Crédito.");
							$('#grabar').focus();
						}
					}
				});
			}

		}

		function actNumTransacSim(){
			var creditoBeanCon = {
	  				'creditoID':$('#creditoID').val(),
	  				'numTransacSim':$('#numTransacSim').val()
			 };

			creditosServicio.consulta(6,creditoBeanCon,function(credito){
				$('#numTransacSim').val(credito.numTransacSim);
			});
		}


		// funcion para llenar el combo de plazos
		function llenaComboPlazoCredito() {
			dwr.util.removeAllOptions('plazoID');
			dwr.util.addOptions('plazoID', {"":'SELECCIONAR'});
			plazosCredServicio.listaCombo(3, function(plazoCreditoBean){
				dwr.util.addOptions('plazoID', plazoCreditoBean, 'plazoID', 'descripcion');
			});
		}


		/* se ocupa al momento en que fecha ministrado cambia o pierde el foco */
		function eventoBlurChangeFechaMinistrado(){
			var fechMinis = $('#fechaMinistrado').val();
			var fechaAplicacion = parametroBean.fechaAplicacion;
			var diasAux;

			if(esFechaValida(fechMinis)){
				convertDate(fechMinis);
				convertDate(fechaAplicacion);
		  		if(fechMinis < fechaAplicacion && fechMinis != ''&& ($("#estatus").val() == catEstatusCredito.inactivo || $("#estatus").val() == catEstatusCredito.autorizado || $("#estatus").val() == catEstatusCredito.procesado)){
		  			mensajeSis("La Fecha de Desembolso no debe ser Inferior a la del Sistema.");
		  			$('#fechaMinistrado').focus();
		  			$('#fechaMinistrado').select();
		  			$('#fechaMinistrado').val(fechaAplicacion);
		  		}else{
			  		if(fechMinis == ''){
			  			mensajeSis("La Fecha de Desembolso está Vacia.");
			  			$('#fechaMinistrado').focus();
			  			$('#fechaMinistrado').select();

			  		} else{
			  			$('#fechaInicio').val(fechMinis);

						diasAux  = restaFechas(fechaAplicacion, fechMinis);
						if(parseInt(diasAux) >= 0){
							$("#fechaInicioAmor").val(fechMinis);
							$("#fechaInicioAmor").focus();
						}

				 		consultaFechaVencimientoCuotas('numAmortizacion');
			  		}
		  		}
			}else{
				$('#fechaMinistrado').val(parametroBean.fechaAplicacion);
			}
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


		
		if(manejaConvenio=='S')
		{
		   if(noSeguirPro==true){
		       
		       deshabilitaBoton('grabar');
		        deshabilitaBoton('simular');
		      }
		}



	 });


	/* Cancela las teclas [ ] en el formulario*/
	document.onkeypress = pulsarCorchete;
	function pulsarCorchete(e) {
		tecla=(document.all) ? e.keyCode : e.which;
		if(tecla==91 || tecla==93){
			return false;
		}
		return true;
	}


	function consultaFechaVencimientoCuotas(idControl){
		var jqPlazo  = eval("'#" + idControl + "'");
		var plazo = $(jqPlazo).val();
		var tipoCon=3;

		var PlazoBeanCon = {
			'plazoID' :  $('#plazoID').val(),
			'fechaActual' : $('#fechaInicioAmor').val(),
			'frecuenciaCap' : $('#frecuenciaCap').val()
		};
		if(plazo == '0'){
			$('#fechaVencimien').val("");
		}else{
			plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) {
				if(plazos!=null){
					$('#fechaVencimien').val(plazos.fechaActual);
				}
			});
		}
	}

	// funcion a ejecutar cuando la operacion fue exitosa
	 function ExitoPantalla(){
		consultaGridAmortizacionesGrabadas();

		deshabilitaBoton('generar','submit');
		deshabilitaBoton('grabar','submit');
		$('#contenedorSimuladorLibre').hide();
		$('#contenedorSimuladorLibre').html("");
		consultaCredito();
		$('#tipoTransaccion').val('0');
		$('#tipoActualizacion').val('0');
	}


	function consultaGridAmortizacionesGrabadas(){
		$('#tipo').val(3);
		var params = {};
		params['creditoID'] = $('#creditoID').val();
		params['tipoLista'] = 3;
		params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
		params['cobraIVASeguroCuota'] 	= $('#cobraIVASeguroCuota option:selected').val();
		params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
		params['cobraAccesorios']	=	cobraAccesorios;

		var numeroError = 0;
		var mensajeTransaccion = "";
		$.post("consultaCredAmortiGridVista.htm", params, function(data){
				if(data.length >0) {
					$('#gridAmortizacion').html('');
					$('#gridAmortizacion').html(data);
					if ( $("#numeroErrorList").length ) {
						numeroError = $('#numeroErrorList').asNumber();
						mensajeTransaccion = $('#mensajeErrorList').val();
					}
					if(numeroError==0){
						$('#gridAmortizacion').show();
						$('#contenedorSimuladorLibre').hide();
						$('#contenedorSimuladorLibre').html("");
						var jqAmortiza = eval("'#amortizacionID1'");
						var amortizacion1= $(jqAmortiza).val();
						// valida si el grid trae amortizaciones anteriores para habilitar boton imprimir
						if(amortizacion1 == 1){
							
							
							 if(manejaConvenio=='S')
	                    		{
			                        if(noSeguirPro!=true){
			                        	habilitaBoton('exportarPDF', 'submit');
										habilitaBoton('ExptablaAmorti', 'submit');
										habilitaBoton('caratula', 'submit');
										habilitaBoton('ExportExcel', 'submit');
										habilitaControl('ligaPDF');
										agregaFormatoControles('formaGenerica');
			                      }else{
			                    	   deshabilitaBoton('exportarPDF', 'submit');
			                    	   deshabilitaBoton('ExptablaAmorti', 'submit');
			                    	   deshabilitaBoton('caratula', 'submit');
			                    	   deshabilitaBoton('ExportExcel', 'submit');
										deshabilitaControl('ligaPDF');
			                      }
			                    }else{
			                    	habilitaBoton('exportarPDF', 'submit');
									habilitaBoton('ExptablaAmorti', 'submit');
									habilitaBoton('caratula', 'submit');
									habilitaBoton('ExportExcel', 'submit');
									habilitaControl('ligaPDF');
									agregaFormatoControles('formaGenerica');
			                    }
							
						}else{
							deshabilitaBoton('exportarPDF', 'submit');
							deshabilitaBoton('ExptablaAmorti', 'submit');
							deshabilitaBoton('caratula', 'submit');
							deshabilitaBoton('ExportExcel', 'submit');
							deshabilitaControl('ligaPDF');
						}

						if($('#tipoCreditoDes').val()== 'REESTRUCTURA'){
							
							 if(manejaConvenio=='S')
	                    		{
			                        if(noSeguirPro!=true){
			                        	habilitaBoton('exportarPDF', 'submit');
										habilitaBoton('ExptablaAmorti', 'submit');
										habilitaBoton('caratula', 'submit');
										habilitaBoton('ExportExcel', 'submit');
										habilitaBoton('ligaPDF');
			                      }else{
			                    	    deshabilitaBoton('exportarPDF', 'submit');
			                    	    deshabilitaBoton('ExptablaAmorti', 'submit');
			                    	    deshabilitaBoton('caratula', 'submit');
			                    	    deshabilitaBoton('ExportExcel', 'submit');
			                    	    deshabilitaBoton('ligaPDF');
			                      }
			                    }else{
			                    	habilitaBoton('exportarPDF', 'submit');
									habilitaBoton('ExptablaAmorti', 'submit');
									habilitaBoton('caratula', 'submit');
									habilitaBoton('ExportExcel', 'submit');
									habilitaBoton('ligaPDF');
			                    }

						}else{



							habilitaControl('ligaPDF');
							agregaFormatoControles('formaGenerica');
						}
						if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
							$('#filaTotales').hide();
						}

						if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
							$('#filaTotales').show();
						}
						muestraDescTasaVar('calcInteresID');

                        if (cobraAccesorios == 'S') {
                            desgloseOtrasComisiones($('#creditoID').val());
                        }
					}
				}else{
					$('#gridAmortizacion').hide();
					$('#gridAmortizacion').html("");
					$('#contenedorSimuladorLibre').hide();
					$('#contenedorSimuladorLibre').html("");
					deshabilitaBoton('exportarPDF', 'submit');
					deshabilitaBoton('ExptablaAmorti', 'submit');
					deshabilitaBoton('caratula', 'submit');
					deshabilitaControl('ligaPDF');
					deshabilitaBoton('ExportExcel', 'submit');
				}
				/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
				if(numeroError!=0){
					$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
					mensajeSisError(numeroError,mensajeTransaccion);
				}
				/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
		});
	}

	 function ErrorPantalla(){
		agregaFormatoControles('formaGenerica');
		$('#tipoTransaccion').val('0');
		$('#tipoActualizacion').val('0');
	}



	 /* *******************************************************************************************
	  * *****************************CALENDARIO IRREGULAR *****************************************
	  * ********************************************************************************************/
	//valida que los datos que se requieren para generar el  simulador de  amortizaciones
		function validaDatosSimulador() {
			if ($.trim($('#producCreditoID').val()) == "") {
				mensajeSis("Producto De Crédito Vací­o");
				$('#producCreditoID').focus();
				datosCompletos = false;
			} else {
				if ($.trim($('#clienteID').val()) == "") {
					mensajeSis("El Cliente Está Vacío");
					$('#clienteID').focus();
					datosCompletos = false;
				} else {
					if ($('#fechaInicioAmor').val() == '') {
						mensajeSis("Fecha de Inicio de Amortización está Vacía");
						$('#fechaInicio').focus();
						datosCompletos = false;
					} else {
						if ($('#fechaVencimien').val() == '') {
							mensajeSis("Fecha de Vencimiento Vacía");
							$('#fechaVencimien').focus();
							datosCompletos = false;
						} else {
							if ($('#tipoPagoCapital').val() == '') {
								mensajeSis("El Tipo de Pago de Capital Está Vací­o.");
								$('#tipoPagoCapital').focus();
								datosCompletos = false;
							} else {
								if ($('#frecuenciaCap').val() == 'U'
									&& $('#tipoPagoCapital').val() != 'I') {
									mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
									$('#frecuenciaCap').val("");
									$('#frecuenciaCap').focus();
									datosCompletos = false;
								} else {
									if ($('#tipoPagoCapital').val() == 'L') {
										/* se valida que si el tipo de pago de capital es libre, no se pueda escoger como frecuencia
										 * la opcion de libre */
										if ($('#frecuenciaInt').val() == 'L') {
											mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
											$('#frecuenciaInt').focus();
											$('#frecuenciaInt').val("");
											datosCompletos = false;
										}else{
											if ($('#frecuenciaCap').val() == 'L') {
												mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
												$('#frecuenciaCap').focus();
												$('#frecuenciaCap').val("");
												datosCompletos = false;
											}else{
												if ($('#calcInteresID').val() != "") {
													if ($('#calcInteresID')
															.val() == '1') {
														if ($('#tasaFija').val() == ''|| $('#tasaFija').val() == '0') {
															mensajeSis("Tasa de Interés Vací­a");
															$('#tasaFija').focus();
															datosCompletos = false;
														} else {
															if ($('#montoCredito').asNumber() <= "0") {
																mensajeSis("El Monto Está Vacío");
																$('#montoCredito').focus();
																datosCompletos = false;
															} else {
																datosCompletos = true;
															}
														}
													}
												} else {
													mensajeSis("Seleccionar Tipo Cal. Interés");
													$('#calcInteresID').focus();
													datosCompletos = false;
												}
											}
										}
									}else{
										if ($('#calcInteresID').val() != "") {
											if ($('#calcInteresID')
													.val() == '1') {
												if ($('#tasaFija').val() == ''|| $('#tasaFija').val() == '0') {
													mensajeSis("Tasa de Interés Vací­a");
													$('#tasaFija').focus();
													datosCompletos = false;
												} else {
													if ($('#montoCredito').asNumber() <= "0") {
														mensajeSis("El Monto Está Vacío");
														$('#montoCredito').focus();
														datosCompletos = false;
													} else {
														datosCompletos = true;
													}
												}
											}
										} else {
											mensajeSis("Seleccionar Tipo Cal. Interés");
											$('#calcInteresID').focus();
											datosCompletos = false;
										}
									}
								}
							}
						}
					}
				}
			}
			return datosCompletos;
		}

		// llamada al cotizador de amortizaciones
		function simulador(){
			var params = {};
			if($('#calendIrregularCheck').is(':checked')){
				mostrarGridLibresEncabezado();
			}else{
				ejecutarLlamada = validaDatosSimulador();
				if(ejecutarLlamada == true){
					if($('#calcInteresID').val()==1 ) {
						switch($('#tipoPagoCapital').val()){
							case "C": // si el tipo de pago es CRECIENTES
								tipoLista = 1;
							break;
							case "I" :// si el tipo de pago es IGUALES
								tipoLista = 2;
							break;
							case  "L": // si el tipo de pago es LIBRES
								tipoLista = 3;
							break;
							default:
								tipoLista = 1;
						}
					}else{
						//si el tipo de calculo de interes es MontoOriginal (saldos globales)se valida tipo de Lista
						if($('#tipoCalInteres').val() == '2'){
							tipoLista=11;
						}else{
							switch($('#tipoPagoCapital').val()){
								case "C": // si el tipo de pago es CRECIENTES
									mensajeSis("No se permiten pagos de capital Crecientes");
								break;
								case "I" :// si el tipo de pago es IGUALES
									tipoLista = 4;
								break;
								case  "L": // si el tipo de pago es LIBRES
									tipoLista = 5;
								break;
								default:
									tipoLista = 4;
							}
						}
					}

					params['tipoLista'] = tipoLista;

					if($.trim($('#frecuenciaCap').val())!=""){
						if(tipoLista == 1){
							// si se trata de una frecuencia de capital : MENSUAL, BIMESTRAL, TRIMESTRAL, TETRAMESTRAL, SEMESTRAL
							if($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='B' || $('#frecuenciaCap').val() =='T'
								|| $('#frecuenciaCap').val() =='R'|| $('#frecuenciaCap').val() =='S'){
								// Si el dia de pago no esta definido
								if(($('#diaPagoCapital2').is(':checked')) != true &&($('#diaPagoCapital1').is(':checked')) != true ){
									mensajeSis("Debe Seleccionar un día de pago.");
									datosCompletos = false;
								}else{
									// si el dia de pago seleccionado es dia del mes
									if(($('#diaPagoCapital2').is(':checked')) == true ){
										if($.trim($('#diaMesCapital').val()) ==''|| $('#diaMesCapital').val() ==null || $('#diaMesCapital').val() =='0'){
											mensajeSis("Especifique día del mes.");
											$('#diaMesCapital').focus();
											datosCompletos = false;
										}else{
											// valida que el numero de amortizaciones no este vacio
											if($('#numAmortizacion').asNumber() == 0){
												mensajeSis("Número de cuotas vacío");
												$('#numAmortizacion').focus();
												datosCompletos = false;
											}else{
												datosCompletos = true;
											}
										}
									}else{
										// valida que el numero de amortizaciones no este vacio
										if($('#numAmortizacion').asNumber() == 0){
											mensajeSis("Número de cuotas vacío");
											$('#numAmortizacion').focus();
											datosCompletos = false;
										}else{
											datosCompletos = true;
										}
									}
								}
							}else{
								if($('#numAmortizacion').asNumber() == 0){
									mensajeSis("Número de cuotas vacío");
									$('#numAmortizacion').focus();
									datosCompletos = false;
								}else{
									datosCompletos = true;
								}
							}
						}else{
							if(tipoLista == 2 ||tipoLista ==3||tipoLista ==4||tipoLista ==5 ||tipoLista ==11){
								if($.trim($('#frecuenciaCap').val())!=""){
									if($.trim($('#frecuenciaInt').val())!=""){
										if($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='B'
											|| $('#frecuenciaCap').val() =='T'|| $('#frecuenciaCap').val() =='R'|| $('#frecuenciaCap').val() =='S'
											|| $('#frecuenciaInt').val() =='M'|| $('#frecuenciaInt').val() =='B'|| $('#frecuenciaInt').val() =='T'
											|| $('#frecuenciaInt').val() =='R'|| $('#frecuenciaInt').val() =='S'){
										// Valida que este seleccionado el dia de pago para capital e interes
											if(($('#diaPagoCapital1').is(':checked') != true && $('#diaPagoCapital2').is(':checked') != true)
													||($('#diaPagoInteres1').is(':checked') != true && $('#diaPagoInteres2').is(':checked') != true)){
												mensajeSis('Debe Seleccionar un día de pago.');
												datosCompletos = false;
											}else {
												// si el dia de pago seleccionado es dia del mes
												if($('#diaPagoCapital2').is(':checked') == true){
													if($.trim($('#diaMesCapital').val()) ==''||$('#diaMesCapital').val() ==null || $('#diaMesCapital').val() =='0'){
														mensajeSis("Especifique día del mes capital.");
														datosCompletos = false;
													}else{
														if(($.trim($('#diaMesInteres').val()) ==''||$('#diaMesInteres').val() ==null || $('#diaMesInteres').val() =='0')
																&& $('#diaPagoInteres2').is(':checked') == true){
															mensajeSis("Especifique día del mes Interés.");
															datosCompletos = false;
														}else{
															// valida que el numero de amortizaciones no este vacio
															if($('#numAmortizacion').asNumber() == 0){
																mensajeSis("Número de cuotas vacío");
																datosCompletos = false;
															}else{
																datosCompletos = true;
															}
														}
													}
												}else{
													// valida que el numero de amortizaciones no este vacio
													if($('#numAmortizacion').asNumber() == 0){
														mensajeSis("Número de cuotas vacío");
														datosCompletos = false;
													}else{
														// valida que el nÃºmero de amortizaciones no este vacio
														if($('#numAmortInteres').asNumber() == 0){
															mensajeSis("Especificar Número de Cuotas de Interés.");
															$('#numAmortInteres').focus();
															datosCompletos =false;
														}else{
															datosCompletos =true;
														}
													}
												}
											}
										}else{
											// valida que el numero de amortizaciones no este vacio
											if($('#numAmortizacion').asNumber() == 0){
												mensajeSis("Número de cuotas vacío");
												datosCompletos = false;
											}else{
												// valida que el nÃºmero de amortizaciones no este vacio
												if($('#numAmortInteres').asNumber() == 0){
													mensajeSis("Especificar Número de Cuotas de Interés.");
													$('#numAmortInteres').focus();
													datosCompletos =false;
												}else{
													datosCompletos =true;
												}
											}
										}
									}else{
										mensajeSis("Seleccionar Frecuencia de Interés.");
										$('#frecuenciaInt').focus();
										datosCompletos = false;
									}
								}else{
									mensajeSis("Seleccionar Frecuencia de Capital.");
									$('#frecuenciaCap').focus();
									datosCompletos = false;
								}
							}
						}

						if(datosCompletos){
							params['montoCredito']		= $('#montoCredito').asNumber();
							params['tasaFija']			= $('#tasaFija').val();
							params['frecuenciaCap']		= $('#frecuenciaCap').val();
							params['frecuenciaInt']		= $('#frecuenciaInt').val();
							params['periodicidadCap'] 	= $('#periodicidadCap').val();
							params['periodicidadInt'] 	= $('#periodicidadInt').val();
							params['producCreditoID']	= $('#producCreditoID').val();
							params['clienteID'] 		= $('#clienteID').val();
							params['montoComision']		= $('#montoComision').asNumber();
							params['diaPagoCapital'] 	= $('#diaPagoCapital').val();
							params['diaPagoInteres'] 	= $('#diaPagoInteres').val();
							params['diaMesCapital'] 	= $('#diaMesCapital').val();
							params['diaMesInteres'] 	= $('#diaMesInteres').val();
							params['fechaInicio'] 		= $('#fechaInicioAmor').val();
							params['numAmortizacion'] 	= $('#numAmortizacion').asNumber();
							params['numAmortInteres'] 	= $('#numAmortInteres').asNumber();
							params['fechaInhabil']		= $('#fechaInhabil').val();

							params['ajusFecUlVenAmo']	= $('#ajusFecUlVenAmo').val();
							params['ajusFecExiVen']		= $('#ajusFecExiVen').val();
							params['numTransacSim'] 	= '0';
							params['empresaID'] 		= parametroBean.empresaID;
							params['usuario'] 			= parametroBean.numeroUsuario;
							params['fecha'] 			= parametroBean.fechaSucursal;
							params['direccionIP'] 		= parametroBean.IPsesion;
							params['sucursal'] 			= parametroBean.sucursal;
							params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
							params['cobraIVASeguroCuota'] 	= $('#cobraIVASeguroCuota option:selected').val();
							params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
							params['cobraAccesorios']	=	cobraAccesorios;
							params['convenioNominaID']	= $('#convenioNominaID').asNumber();

							bloquearPantallaAmortizacion();
							var numeroError = 0;
							var mensajeTransaccion = "";
							if($('#tipoPagoCapital').val()!="L"){
								$.post("simPagCredito.htm",params,function(data) {
									if (data.length > 0 || data != null) {
										$('#gridAmortizacion').html("");
										$('#gridAmortizacion').hide();
										$('#contenedorSimuladorLibre').html(data);
										if ( $("#numeroErrorList").length ) {
											numeroError = $('#numeroErrorList').asNumber();
											mensajeTransaccion = $('#mensajeErrorList').val();
										}
										if(numeroError==0){

											$('#contenedorSimuladorLibre').show();
											$('#numTransacSim').val($('#transaccion').val());

											// actualiza la nueva fecha de vencimiento que devuelve el cotizador
											var jqFechaVen = eval("'#fech'");
											$('#fechaVencimien').val($(jqFechaVen).val());

											// asigna el valor de cat devuelto por el cotizador
											$('#cat').val($('#valorCat').val());

											$('#cat').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 1});

											// asigna el valor de monto de la cuota devuelto por el cotizador
											$('#montoCuota').val("0.00");
											// actualiza el numero de cuotas generadas por el cotizador
											$('#numAmortInteres').val($('#valorCuotasInt').val());
											$('#numAmortizacion').val($('#cuotas').val());
											NumCuotas =  $('#cuotas').val();  // se utiliza para saber si agregar una cuota mas o restar una

											// Si el tipo de capital es iguales o saldos globales devuelve numero de cuotas de interes
											if($('#tipoPagoCapital').val() == 'I' || tipoLista== 11){
												$('#numAmortInteres').val($('#valorCuotasInt').val());
											}
											if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
												$('#filaTotales').hide();
											}

											if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
												$('#filaTotales').show();
											}
										}
									} else{
										$('#gridAmortizacion').html("");
										$('#gridAmortizacion').hide();
										$('#contenedorSimuladorLibre').html("");
										$('#contenedorSimuladorLibre').hide();
									}
									$('#contenedorForma').unblock();
									/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
									if(numeroError!=0){
										$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
										mensajeSisError(numeroError,mensajeTransaccion);
									}
									/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
								});
							}else{
								$.post("simPagLibresCapCredito.htm", params, function(data){ // todo
									if(data.length >0 || data != null) {
										$('#contenedorSimuladorLibre').html(data);
										if ( $("#numeroErrorList").length ) {
											numeroError = $('#numeroErrorList').asNumber();
											mensajeTransaccion = $('#mensajeErrorList').val();
										}
										if(numeroError==0){
											$('#contenedorSimuladorLibre').show();
											$('#gridAmortizacion').html("");
											$('#gridAmortizacion').hide();
											$('#numTransacSim').val($('#transaccion').val());
											// actualiza la nueva fecha de vencimiento que devuelve el cotizador
											var jqFechaVen = eval("'#fech'");
											$('#fechaVencimien').val($(jqFechaVen).val());

											// asigna el valor de monto de la cuota devuelto por el cotizador
											if($('#tipoPagoCapital').val() == "C"){
												$('#montoCuota').val($('#valorMontoCuota').val());

											}else{
												if($('#frecuenciaCap').val()=="U" && $('#tipoPagoCapital').val() == "I"){
													$('#montoCuota').val($('#valorMontoCuota').val());

												}else{
													$('#montoCuota').val("0.00");
												}
											}
											// actualiza el numero de cuotas generadas por el cotizador
											$('#numAmortInteres').val($('#valorCuotasInt').val());
											$('#numAmortizacion').val($('#cuotas').val());
											calculaDiferenciaSimuladorLibre();
										}
									}else{
										$('#contenedorSimuladorLibre').html("");
										$('#contenedorSimuladorLibre').hide();
										$('#gridAmortizacion').html("");
										$('#gridAmortizacion').hide();
									}
									$('#contenedorForma').unblock();
									/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
									if(numeroError!=0){
										$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
										mensajeSisError(numeroError,mensajeTransaccion);
									}
									/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
								});
							}
						}
					}else{
						mensajeSis("Seleccionar Frecuencia de Capital.");
						$('#frecuenciaCap').focus();
						datosCompletos = false;
					}
				}
			}
		}// fin funcion simulador()


	//llamada al sp que consulta el simulador de amortizaciones
	function consultaSimulador(){
		var params = {};
		if($('#calendIrregularCheck').is(':checked')){
			// calendario irregular
			tipoLista = 7;
		}else{
			if($('#calcInteresID').val()==1 ) {
				switch($('#tipoPagoCapital').val()){
					case "C": // si el tipo de pago es CRECIENTES
						tipoLista = 1;
					break;
					case "I" :// si el tipo de pago es IGUALES
						tipoLista = 2;
					break;
					case  "L": // si el tipo de pago es LIBRES
						tipoLista = 3;
					break;
					default:
						tipoLista = 1;
				}
			}else{
				//si el tipo de calculo de interes es MontoOriginal (saldos globales)se valida tipo de Lista
				if($('#tipoCalInteres').val() == '2'){
					tipoLista=11;
				}else{
					switch($('#tipoPagoCapital').val()){
						case "C": // si el tipo de pago es CRECIENTES
							mensajeSis("No se permiten pagos de capital Crecientes");
						break;
						case "I" :// si el tipo de pago es IGUALES
							tipoLista = 4;
						break;
						case  "L": // si el tipo de pago es LIBRES
							tipoLista = 5;
						break;
						default:
							tipoLista = 4;
					}
				}
			}
		}

		params['tipoLista'] = tipoLista;

		params['numTransacSim'] 	= $('#numTransacSim').asNumber();
		params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
		params['cobraIVASeguroCuota'] 	= $('#cobraIVASeguroCuota option:selected').val();
		params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
		params['cobraAccesorios']	=	cobraAccesorios;

		bloquearPantallaAmortizacion();
		var numeroError = 0;
		var mensajeTransaccion = "";
		$.post("listaSimuladorConsulta.htm",params,function(data) {
			if (data.length > 0 || data != null) {
				$('#contenedorSimuladorLibre').html(data);
				if ( $("#numeroErrorList").length ) {
					numeroError = $('#numeroErrorList').asNumber();
					mensajeTransaccion = $('#mensajeErrorList').val();
				}
				if(numeroError==0){
					$('#contenedorSimuladorLibre').show();
					$('#gridAmortizacion').html("");
					$('#gridAmortizacion').hide();
				}
			} else{
				$('#contenedorSimuladorLibre').html("");
				$('#contenedorSimuladorLibre').hide();
				$('#gridAmortizacion').html("");
				$('#gridAmortizacion').hide();
			}
			$('#contenedorForma').unblock();
			/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
			if(numeroError!=0){
				$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
				mensajeSisError(numeroError,mensajeTransaccion);
			}
			/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
		});

	}// fin funcion consultaSimulador()


	 /*simulador de pagos libres de capital*/
	 function simuladorPagosLibres(numTransac){
	 	$('#numTransacSim').val(numTransac);
	 	var procedeCalculo = validaUltimaCuotaCapSimulador();
	 	if(procedeCalculo == 0){
	 		var mandar = crearMontosCapital(numTransac);
	 		var diaHabilSig;
	 		if(mandar==2){
	 			var params = {};
	 			if($('#calcInteresID').val()==1 ) {
	 				switch($('#tipoPagoCapital').val()){
	 					case "C": // SI ES CRECIENTE
	 						tipoLista=1;
	 						break;
	 					case "I": // SI ES IGUAL
	 						tipoLista=2;
	 						break;
	 					case "L": // SI ES LIBRE
	 						tipoLista=3;
	 						break;
	 					default :
	 						tipoLista=1;
	 						break;
	 				}
	 			}else{
	 				switch($('#tipoPagoCapital').val()){
	 					case "I": // SI ES IGUAL
	 						tipoLista=4;
	 						break;
	 					case "L": // SI ES LIBRE
	 						tipoLista=5;
	 						break;
	 					default :
	 						tipoLista=4;
	 						break;
	 				}
	 			}

	 			diaHabilSig= $('#fechInhabil').val();

	 			params['tipoLista']			= tipoLista;
	 			params['montoCredito'] 		= $('#montoCredito').asNumber();
	 			params['tasaFija']			=  $('#tasaFija').val();
	 			params['producCreditoID'] 	= $('#producCreditoID').val();
	 			params['clienteID'] 		= $('#clienteID').val();
	 			params['fechaInhabil']		= diaHabilSig;
	 			params['empresaID'] 		= parametroBean.empresaID;
	 			params['usuario'] 			= parametroBean.numeroUsuario;
	 			params['fecha'] 			= parametroBean.fechaSucursal;
	 			params['direccionIP'] 		= parametroBean.IPsesion;
	 			params['sucursal'] 			= parametroBean.sucursal;
	 			params['numTransaccion']	= $('#numTransacSim').val();
	 			params['numTransacSim'] 	= $('#numTransacSim').val();
	 			params['montosCapital'] 	= $('#montosCapital').val();
	 			params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
	 			params['cobraIVASeguroCuota'] 	= $('#cobraIVASeguroCuota option:selected').val();
	 			params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
	 			params['cobraAccesorios']	=	cobraAccesorios;

	 			bloquearPantallaAmortizacion();
	 			var numeroError = 0;
				var mensajeTransaccion = "";
	 			$.post("simPagLibresCredito.htm", params, function(data){
	 				if(data.length >0) {
	 					$('#gridAmortizacion').html("");
	 					$('#gridAmortizacion').hide();
	 					$('#contenedorSimuladorLibre').html(data);
	 					if ( $("#numeroErrorList").length ) {
							numeroError = $('#numeroErrorList').asNumber();
							mensajeTransaccion = $('#mensajeErrorList').val();
						}
						if(numeroError==0){
		 					$('#contenedorSimuladorLibre').show();
		 					$('#numTransacSim').val($('#transaccion').val());
		 					if($('#transaccion').val()>0){
		 						deshabilitaBoton('simular', 'submit');
		 						 if(manejaConvenio=='S')
		                    		{
				                        if(noSeguirPro!=true){
				                        habilitaBoton('grabar', 'submit');
				                      }else{
				                          deshabilitaBoton('grabar', 'submit');
				                      }
				                    }else{
				                    	habilitaBoton('grabar', 'submit');
				                    }
		 					
								$('#fechaMinistradoOriginal').val($('#fechaInicioAmor').val());
								$('#simuladoNuevamente').val("S");
		 					}else{
		 						
		 						 if(manejaConvenio=='S')
		                    		{
				                        if(noSeguirPro!=true){
				                           habilitaBoton('simular', 'submit');
				                      }else{
				                          deshabilitaBoton('simular', 'submit');
				                      }
				                    }else{
				                    	habilitaBoton('simular', 'submit');
				                    }
		 						
		 						deshabilitaBoton('grabar', 'submit');
		 						$('#simuladoNuevamente').val("N");
		 					}
		 					$('#contenedorForma').unblock();
		 					// actualiza el numero de cuotas generadas por el cotizador
		 					$('#numAmortInteres').val($('#valorCuotasInteres').val());
		 					$('#numAmortizacion').val($('#valorCuotasCapital').val());
							var jqFechaVen = eval("'#valorFecUltAmor'");
							$('#fechaVencimien').val($(jqFechaVen).val());
		 				}
	 				}else{
	 					$('#gridAmortizacion').html("");
	 					$('#gridAmortizacion').show();
	 				}
	 				/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
	 				if(numeroError!=0){
	 					$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
	 					mensajeSisError(numeroError,mensajeTransaccion);
	 				}
	 				/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
	 			});
	 		}
	 	}

	 }// fin simuladorPagosLibres



	 function mostrarGridLibresEncabezado(){
	 	var data;

	 	data = '<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />'+
	 	'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
	 	'<legend>Simulador de Amortizaciones</legend>'+
	 	'<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">'+
	 		'<tr>'+
	 			'<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>'+
	 			'<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>'+
	 			'<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>	'+
	 			'<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>'+
	 	  		'<td class="label" align="center"><label for="lblCapital">Capital</label></td> '+
	 	 		'<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> '+
	 	 		'<td class="label" align="center"><label for="lblCargos">Iva Inter&eacute;s</label></td> '+
	 	 		'<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> '+
	 	 		'<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> '+
	 	 		'<td class="label" align="center"><label for="lblAgregaElimina"></label></td> '+
	 		'</tr>'+
	 	'</table>'+
	 	'</fieldset>';

	 	$('#contenedorSimuladorLibre').html(data);
	 	$('#contenedorSimuladorLibre').show();
	 	$('#gridAmortizacion').html("");
	 	$('#gridAmortizacion').hide();
	 	mostrarGridLibresDetalle();
	 }

	 function mostrarGridLibresDetalle(){
	 	var numeroFila = document.getElementById("numeroDetalle").value;
	 	var nuevaFila = parseInt(numeroFila) + 1;
	 	var filaAnterior = parseInt(nuevaFila) - 1;
	 	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	 	var valorDiferencia = $('#diferenciaCapital').asNumber();
	 	if(numeroFila == 0){
	 		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicioGrid" size="15" value="'+ $('#fechaInicioAmor').val()+'" readonly="true" disabled="true"/></td>';
	 		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)"  /></td>';
	 		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value=" " readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();"/></td>';
	 		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';

	 	} else{
	 		$('#trBtnCalcular').remove();
	 		$('#trDiferenciaCapital').remove();
	 		var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
	 		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="'+valor+'" autocomplete="off" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicioGrid" size="15" value="'+ $('#fechaVencim'+filaAnterior).val()+'" readonly="true" disabled="true"/></td>';
	 		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)" /></td>';
	 		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();"/></td>';
	 		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';

	 	}
	 	tds += '<td nowrap="nowrap"><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
	 	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
	 	tds += '</tr>';
	 	tds += '<tr id="trDiferenciaCapital" >'+
	 				'<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>'+
	 				'<td  id="inputDiferenciaCap">'+
	 					'<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="'+valorDiferencia+'" esMoneda="true" readonly="true" disabled="true"/>'+
	 				'</td>'+
	 				'<td colspan="5"></td>'+
	 			'</tr>';
	 	tds += '<tr id="trBtnCalcular" >'+
	 				'<td  id="btnCalcularLibre" colspan="10" align="right">'+
	 					'<input type="button" class="submit" id="calcular" tabindex="37"  onclick="simuladorLibresCapFec();" value="Calcular"  />'+
	 				'</td>'+
	 			'</tr>';

	 	document.getElementById("numeroDetalle").value = nuevaFila;
	 	$('#miTabla').append(tds);
	 	sugiereFechaSimuladorLibre();
	 }

	 function agregaNuevaAmort(){
	 	var numeroFila = document.getElementById("numeroDetalle").value;
	 	var nuevaFila = parseInt(numeroFila) + 1;
	 	var filaAnterior = parseInt(nuevaFila) - 1;
	 	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	 	var valorDiferencia = $('#diferenciaCapital').asNumber();
	 	if(numeroFila == 0){
	 		$('#trBtnCalcular').remove();
	 		$('#trDiferenciaCapital').remove();
	 		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
	 		tds += '<td align="center"><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicioGrid" size="15" value="'+ $('#fechaInicioAmor').val()+'" readonly="true" disabled="true"/></td>';
	 		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id);"  /></td>';
	 		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();" /></td>';
	 		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';

	 	} else{
	 		$('#trBtnCalcular').remove();
	 		$('#trDiferenciaCapital').remove();
	 		var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
	 		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="'+valor+'" autocomplete="off" readonly="true" disabled="true" /></td>';
	 		tds += '<td align="center"><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicioGrid" size="15" value="'+ $('#fechaVencim'+filaAnterior).val()+'" readonly="true" disabled="true"/></td>';
	 		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)" /></td>';
	 		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();"/></td>';
	 		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
	 		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
	 	}
	 	tds += '<td nowrap="nowrap"><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
	 	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
	 	tds += '</tr>';
	 	tds += '<tr id="trDiferenciaCapital" >'+
	 				'<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>'+
	 				'<td  id="inputDiferenciaCap">'+
	 					'<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="'+valorDiferencia+'" esMoneda="true" readonly="true" disabled="true"/>'+
	 				'</td>'+
	 				'<td colspan="5"></td>'+
	 			'</tr>';
	 	tds += '<tr id="trBtnCalcular" >'+
	 				'<td  id="btnCalcularLibre" colspan="10" align="right">'+
	 					'<input type="button" class="submit" id="calcular" tabindex="37"  onclick="simuladorLibresCapFec();" value="Calcular" />'+
	 				'</td>'+
	 			'</tr>';

	 	document.getElementById("numeroDetalle").value = nuevaFila;
	 	$("#miTabla").append(tds);
	 	sugiereFechaSimuladorLibre();
	 	calculaDiferenciaSimuladorLibre();

	 	return false;
	 }

	 /* funcion para eliminar una amortizacion  */
	 function eliminaAmort(control){
	 	var contador = 1;
	 	var numeroID = control.id;
	 	var jqTr = eval("'#renglon" + numeroID + "'");

	 	var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
	 	var jqFechaInicio = eval("'#fechaInicio" + numeroID + "'");
	 	var jqFechaVencim = eval("'#fechaVencim" + numeroID + "'");
	 	var jqFechaExigible = eval("'#fechaExigible" + numeroID + "'");
	 	var jqCapital = eval("'#capital" + numeroID + "'");
	 	var jqInteres = eval("'#interes" + numeroID + "'");
	 	var jqIvaInteres = eval("'#ivaInteres" + numeroID + "'");
	 	var jqTotalPago = eval("'#totalPago" + numeroID + "'");
	 	var jqSaldoInsoluto = eval("'#saldoInsoluto" + numeroID + "'");
	 	var jqElimina = eval("'#" + numeroID + "'");
	 	var jqAgrega = eval("'#agrega" + numeroID + "'");

	 	/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
	 	 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
	 	var continuar = ajustaValoresFechaElimina(numeroID,jqFechaInicio);

	 	if(continuar==1){
	 		$(jqConsecutivoID).remove();
	 		$(jqFechaInicio).remove();
	 		$(jqFechaVencim).remove();
	 		$(jqFechaExigible).remove();
	 		$(jqCapital).remove();
	 		$(jqInteres).remove();
	 		$(jqIvaInteres).remove();
	 		$(jqTotalPago).remove();
	 		$(jqSaldoInsoluto).remove();
	 		$(jqElimina).remove();
	 		$(jqAgrega).remove();
	 		$(jqTr).remove();


	 		// se asigna el numero de detalle que quedan
	 		var elementos = document.getElementsByName("renglon");
	 		$('#numeroDetalle').val(elementos.length);
	 		/*SE COMPARA SI QUEDA MAS DE UNA FILA */
	 		if($('#numeroDetalle').asNumber()>0){
	 			//Reordenamiento de Controles
	 			contador = 1;
	 			var numero= 0;
	 			$('tr[name=renglon]').each(function() {
	 				numero= this.id.substr(7,this.id.length);
	 				var jqRenglonCiclo 	= eval("'renglon" + numero+ "'");
	 				var jqNumeroCiclo = eval("'consecutivoID" + numero + "'");
	 				var jqFechaInicio	= eval("'fechaInicio" + numero + "'");
	 				var jqFechaVencim	= eval("'fechaVencim" + numero + "'");
	 				var jqAgrega		= eval("'agrega" + numero + "'");
	 				var jqFechaExigible = eval("'fechaExigible" + numero + "'");
	 				var jqCapital		= eval("'capital" + numero + "'");
	 				var jqInteres		= eval("'interes" + numero + "'");
	 				var jqIvaInteres	= eval("'ivaInteres" + numero + "'");
	 				var jqTotalPago		= eval("'totalPago" + numero + "'");
	 				var jqSaldoInsoluto = eval("'saldoInsoluto" + numero + "'");

	 				var jqElimina = eval("'" + numero + "'");

	 				document.getElementById(jqNumeroCiclo).setAttribute('value',  contador);

	 				document.getElementById(jqRenglonCiclo).setAttribute('id', "renglon" + contador);
	 				document.getElementById(jqNumeroCiclo).setAttribute('id', "consecutivoID" + contador);
	 				document.getElementById(jqFechaInicio).setAttribute('id', "fechaInicio" + contador);
	 				document.getElementById(jqFechaVencim).setAttribute('id', "fechaVencim" + contador);
	 				document.getElementById(jqAgrega).setAttribute('id', "agrega" + contador);
	 				document.getElementById(jqFechaExigible).setAttribute('id', "fechaExigible" + contador);
	 				document.getElementById(jqCapital).setAttribute('id', "capital" + contador);
	 				document.getElementById(jqInteres).setAttribute('id', "interes" + contador);
	 				document.getElementById(jqIvaInteres).setAttribute('id', "ivaInteres" + contador);
	 				document.getElementById(jqTotalPago).setAttribute('id', "totalPago" + contador);
	 				document.getElementById(jqSaldoInsoluto).setAttribute('id', "saldoInsoluto" + contador);

	 				document.getElementById(jqElimina).setAttribute('id',  contador);

	 				contador = parseInt(contador + 1);
	 			});
	 			calculaDiferenciaSimuladorLibre();
	 		}else{
	 			/*si el usuario elimina la ultima fila, se agrega una fila nueva*/
	 			agregaNuevaAmort();
	 		}
	 	}
	 }

	 /* funcion para sugerir fecha y monto de acuerdo  a lo que ya se habia indicado en el formulario.*/
	 function sugiereFechaSimuladorLibre(){
	 	var numDetalle = $('input[name=fechaVencim]').length;
	 	var varFechaVenID = eval("'#fechaVencim"+numDetalle+"'");
	 	$(varFechaVenID).val($('#fechaVencimien').val());
	 	$(varFechaVenID).focus();
	 	var varCapitalID = eval("'#capital"+numDetalle+"'");
	 	if(numDetalle>1){
	 		$(varCapitalID).val($('#diferenciaCapital').val());
	 		$('#diferenciaCapital').val("0.00");
	 		$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	 	}else{
	 		$(varCapitalID).val($('#montoCredito').val());
	 		$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	 	}
	 }

	 function verificarvaciosCapFec(){
	 	var numAmortizacion = $('input[name=capital]').length;
	 	$('#montosCapital').val("");
	 	var regresar =1;
	 	for(var i = 1; i <= numAmortizacion; i++){
	 		var jqfechaInicio = eval("'#fechaInicio" +i + "'");
	 		var jqfechaVencim = eval("'#fechaVencim" +i + "'");
	 		var valFecIni = document.getElementById("fechaInicio"+i).value;
	 		var valFecVen = document.getElementById("fechaVencim"+i).value;
	 		if (valFecIni =="" ){
	 			document.getElementById("fechaInicio"+i).focus();
	 			$(jqfechaInicio).addClass("error");
	 			regresar= 1;
	 			mensajeSis("Especifique Fecha de Inicio");
	 			i= numAmortizacion+2;
	 		}else{regresar= 3;
	 		$(jqfechaInicio).removeClass("error");
	 		}

	 		if (valFecVen =="" ){
	 			document.getElementById("fechaVencim"+i).focus();
	 			$(jqfechaVencim).addClass("error");
	 			mensajeSis("Especifique Fecha de Vencimiento");
	 			regresar= 1;
	 			i= numAmortizacion+2;
	 		}else{regresar= 4;
	 		$(jqfechaVencim).removeClass("error");
	 		}
	 	}
	 	return regresar;
	 }

	 //funcion para validar que la fecha de vencimiento indicada sea mayor a la de inicio
	 function comparaFechas(varid){
	 	var fila = varid.substr(11,varid.length);
	 	var jqFechaIni = eval("'#fechaInicio" +fila + "'");
	 	var jqFechaVen = eval("'#fechaVencim" +fila + "'");

	 	var fechaIni = $(jqFechaIni).val();
	 	var fechaVen = $(jqFechaVen).val();
	 	var xYear=fechaIni.substring(0,4);
	 	var xMonth=fechaIni.substring(5, 7);
	 	var xDay=fechaIni.substring(8, 10);
	 	var yYear=fechaVen.substring(0,4);
	 	var yMonth=fechaVen.substring(5, 7);
	 	var yDay=fechaVen.substring(8, 10);
	 	if($(jqFechaVen).val()!= ""){
	 		if(esFechaValida($(jqFechaVen).val())){
	 			if(validaFechaVencimientoGrid($(jqFechaVen).val(), $('#fechaVencimien').val(), jqFechaVen, fila)){
	 				if (yYear<xYear ){
	 					mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
	 					document.getElementById("fechaVencim"+fila).focus();
	 					$(jqFechaVen).addClass("error");
	 				}else{
	 					if (xYear == yYear){
	 						if (yMonth<xMonth){
	 							mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
	 							document.getElementById("fechaVencim"+fila).focus();
	 							$(jqFechaVen).addClass("error");
	 						}else{
	 							if (xMonth == yMonth){
	 								if (yDay<xDay||yDay==xDay){
	 									mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
	 									document.getElementById("fechaVencim"+fila).focus();
	 									$(jqFechaVen).addClass("error");
	 								}else{
	 									/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
	 									 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
	 									comparaFechaModificadaSiguiente(fila,jqFechaVen, jqFechaIni);
	 								}
	 							}else{
	 								/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
	 								 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
	 								comparaFechaModificadaSiguiente(fila,jqFechaVen, jqFechaIni);

	 							}
	 						}
	 					}else{
	 						/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
	 						 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
	 						comparaFechaModificadaSiguiente(fila,jqFechaVen, jqFechaIni);
	 					}
	 				}
	 			}else{
	 				$(jqFechaVen).focus();
	 			}
	 		}else{
	 			$(jqFechaVen).focus();
	 		}
	 	}
	 }

	 //funcion para validar que la fecha de vencimiento No sea mayor a la de vencimiento calculada por los plazos.
	 function validaFechaVencimientoGrid(fechaVenGrid, fechaVenCred, jqFechaVen, fila){
	 	var xYear=fechaVenCred.substring(0,4);
	 	var xMonth=fechaVenCred.substring(5, 7);
	 	var xDay=fechaVenCred.substring(8, 10);

	 	var yYear=fechaVenGrid.substring(0,4);
	 	var yMonth=fechaVenGrid.substring(5, 7);
	 	var yDay=fechaVenGrid.substring(8, 10);

	 	if(esFechaValida(fechaVenGrid)){
	 		if (yYear>xYear ){
	 			mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
	 			document.getElementById("fechaVencim"+fila).focus();
	 			$(jqFechaVen).addClass("error");
	 			return false;
	 		}else{
	 			if (xYear == yYear){
	 				if (yMonth>xMonth){
	 					mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
	 					document.getElementById("fechaVencim"+fila).focus();
	 					$(jqFechaVen).addClass("error");
	 					return false;
	 				}else{
	 					if (xMonth == yMonth){
	 						if (yDay>xDay){
	 							mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
	 							document.getElementById("fechaVencim"+fila).focus();
	 							$(jqFechaVen).addClass("error");
	 							return false;
	 						}
	 					}
	 				}
	 			}
	 		}
	 	}else{
	 		$(jqFechaVen).focus();
	 	}
	 	return true;
	 }

	 /* funcion para calcular la diferencia del monto con lo que se va poniendo en el grid de pagos libres.*/
	 function calculaDiferenciaSimuladorLibre(){
	 	var sumaMontoCapturado = 0;
	 	var diferenciaMonto = 0;
	 	var numero = 0;
	 	var varCapitalID = "";
	 	var muestraAlert = true;
	 	$('input[name=capital]').each(function() {
	 		numero= this.id.substr(7,this.id.length);
	 		numDetalle = $('input[name=capital]').length;
	 		varCapitalID = eval("'#capital"+numero+"'");
	 		sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();

	 		if(sumaMontoCapturado > $('#montoCredito').asNumber()){
	 			if(muestraAlert){
	 				mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
	 				muestraAlert = false;
	 			}
	 			$(varCapitalID).val("");
	 			$(varCapitalID).select();
	 			$(varCapitalID).focus();
	 			$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	 			return false;
	 		}else{
	 			diferenciaMonto = $('#montoCredito').asNumber() -  sumaMontoCapturado.toFixed(2);
	 			$('#diferenciaCapital').val(diferenciaMonto);
	 			$('#diferenciaCapital').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	 			$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	 		}
	 	});
	 }

	 //funcion para validar la fecha
	 function esFechaValida(fecha){

	 	if (fecha != undefined && fecha.value != "" ){
	 		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
	 		if (!objRegExp.test(fecha)){
	 			mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
	 			return false;
	 		}

	 		var mes=  fecha.substring(5, 7)*1;
	 		var dia= fecha.substring(8, 10)*1;
	 		var anio= fecha.substring(0,4)*1;

	 		switch(mes){
	 			case 1: case 3:  case 5: case 7: case 8: case 10: case 12:
	 				numDias=31;
	 			break;
	 		case 4: case 6: case 9: case 11:
	 			numDias=30;
	 			break;
	 		case 2:
	 			if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
	 			break;
	 		default:
	 			mensajeSis("Fecha Introducida es Errónea.");
	 		return false;
	 		}
	 		if (dia>numDias || dia==0){
	 			mensajeSis("Fecha Introducida es Errónea.");
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

	 /* Cancela las teclas [ ] en el formulario*/
	 document.onkeypress = pulsarCorchete;
	 function pulsarCorchete(e) {
	 	tecla=(document.all) ? e.keyCode : e.which;
	 	if(tecla==91 || tecla==93){
	 		return false;
	 	}
	 	return true;
	 }

	 // funcion para poner el formato de moneda en el Grid
	 function agregaFormatoMonedaGrid(controlID){
	 	jqID = eval("'#"+controlID+"'");
	 	$(jqID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	 }


	 /*Para ejecutar el simulador de pagos libres de capital y fecha cuando das clic en el boton calcular*/
	 function simuladorLibresCapFec(){
	 	var mandar = "";
	 	var procedeCalculo = validaUltimaCuotaCapSimulador();
	 	if(procedeCalculo == 0){
	 		mandar = crearMontosCapitalFecha();
	 		if(mandar==2){
	 			var params = {};
	 			if($('#calcInteresID').val()==1 ) {
	 				if($('#calendIrregularCheck').is(':checked')){
	 					tipoLista = 7;
	 				}else{
	 					switch($('#tipoPagoCapital').val()){
	 						case "C": // si el tipo de pago es CRECIENTES
	 							tipoLista = 1;
	 						break;
	 						case "I" :// si el tipo de pago es IGUALES
	 							tipoLista = 2;
	 						break;
	 						case  "L": // si el tipo de pago es LIBRES
	 							tipoLista = 3;
	 						break;
	 						default:
	 							tipoLista = 1;
	 					}
	 				}
	 			}else{
	 				if($('#calendIrregularCheck').is(':checked')){
	 					tipoLista=8;
	 				}else{
	 					switch($('#tipoPagoCapital').val()){
	 						case "I" :// si el tipo de pago es IGUALES
	 							tipoLista = 4;
	 						break;
	 						case  "L": // si el tipo de pago es LIBRES
	 							tipoLista = 5;
	 						break;
	 						default:
	 							tipoLista = 4;
	 					}
	 				}
	 			}
	 			params['tipoLista'] 	= tipoLista;
	 			params['montoCredito'] 		= $('#montoCredito').asNumber();
	 			params['tasaFija']		= $('#tasaFija').asNumber();
	 			params['fechaInhabil']	= $('#fechaInhabil').val();
	 			params['empresaID'] 	= parametroBean.empresaID;
	 			params['usuario'] 		= parametroBean.numeroUsuario;
	 			params['fecha'] 		= parametroBean.fechaSucursal;
	 			params['direccionIP'] 	= parametroBean.IPsesion;
	 			params['sucursal'] 		= parametroBean.sucursal;
	 			params['montosCapital'] = $('#montosCapital').val();
	 			params['pagaIva'] 		= $('#pagaIva').val();
	 			params['iva'] 			= $('#iva').asNumber();
	 			params['producCreditoID'] 	= $('#producCreditoID').val();
	 			params['clienteID'] 		= $('#clienteID').val();
	 			params['montoComision'] 	= $('#montoComision').asNumber();
	 			params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
	 			params['cobraIVASeguroCuota'] 	= $('#cobraIVASeguroCuota option:selected').val();
	 			params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
	 			params['cobraAccesorios']	=	cobraAccesorios;

	 			bloquearPantallaAmortizacion();
	 			var numeroError = 0;
				var mensajeTransaccion = "";
	 			$.post("simPagLibresCredito.htm", params, function(data){
	 				if(data.length >0) {
	 					$('#gridAmortizacion').html("");
	 					$('#gridAmortizacion').hide();
	 					$('#contenedorSimuladorLibre').html(data);
	 					if ( $("#numeroErrorList").length ) {
							numeroError = $('#numeroErrorList').asNumber();
							mensajeTransaccion = $('#mensajeErrorList').val();
						}
						if(numeroError==0){
		 					$('#contenedorSimuladorLibre').show();
		 					$('#numTransacSim').val($('#transaccion').val());
		 					if($('#transaccion').val()>0){
		 						deshabilitaBoton('simular', 'submit');
		 						 if(manejaConvenio=='S')
		                    		{
				                        if(noSeguirPro!=true){
				                        	habilitaBoton('grabar', 'submit');
				                      }else{
				                          deshabilitaBoton('grabar', 'submit');
				                      }
				                    }else{
				                    	habilitaBoton('grabar', 'submit');
				                    }
		 						
								$('#fechaMinistradoOriginal').val($('#fechaInicioAmor').val());
								$('#simuladoNuevamente').val("S");
		 					}else{
		 						 if(manejaConvenio=='S')
		                    		{
				                        if(noSeguirPro!=true){
				                        	habilitaBoton('simular', 'submit');
				                      }else{
				                          deshabilitaBoton('simular', 'submit');
				                      }
				                    }else{
				                    	habilitaBoton('simular', 'submit');
				                    }
		 						
		 						deshabilitaBoton('grabar', 'submit');
		 						$('#simuladoNuevamente').val("N");
		 					}
		 					// actualiza la nueva fecha de vencimiento que devuelve el cotizador
		 					var jqFechaVen = eval("'#valorFecUltAmor'");
		 					$('#fechaVencimien').val($(jqFechaVen).val());

		 					// se asigna el numero de cuotas calculadas
		 					$('#numAmortizacion').val($('#valorCuotasCapital').val());
		 					$('#numAmortInteres').val($('#valorCuotasInteres').val());

		 					// se debloquea el contenedor
		 					$('#contenedorForma').unblock();
		 					/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
		 					if(numeroError!=0){
		 						$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
		 						mensajeSisError(numeroError,mensajeTransaccion);
		 					}
		 					/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
		 				}
	 				}else{
	 					$('#gridAmortizacion').html("");
	 					$('#gridAmortizacion').hide();
	 					$('#contenedorSimuladorLibre').html("");
	 					$('#contenedorSimuladorLibre').hide();
	 				}

	 			});
	 		}
	 	}
	 }


	 function crearMontosCapitalFecha(){
	 	var mandar = verificarvaciosCapFec();
	 	var regresar = 1;
	 	if(mandar!=1){
	 		var suma =	sumaCapital();
	 		if(suma !=1){
	 			var numAmortizacion = $('input[name=capital]').length;
	 			$('#montosCapital').val("");
	 			for(var i = 1; i <= numAmortizacion; i++){
	 				var idCapital=eval("'#capital"+i+"'");
	 				if(i == 1){
	 					$('#montosCapital').val($('#montosCapital').val() +
	 							i + ']' +
	 							$(idCapital).asNumber()+ ']' +
	 							document.getElementById("fechaInicio"+i+"").value+ ']' +
	 							document.getElementById("fechaVencim"+i+"").value );
	 				}else{
	 					$('#montosCapital').val($('#montosCapital').val() + '[' +
	 							i + ']' +
	 							$(idCapital).asNumber()+ ']' +
	 							document.getElementById("fechaInicio"+i+"").value+ ']' +
	 							document.getElementById("fechaVencim"+i+"").value );
	 				}
	 			}
	 			regresar= 2;
	 		}
	 		else {regresar= 1; }
	 	}
	 	return regresar;
	 }

	 //funcion para verificar que la suma del capital sea igual que la del monto
	 function sumaCapital(){
	 	var jqCapital;
	 	var suma = 0;
	 	var contador = 1;
	 	var capital;
	 	$('input[name=capital]').each(function() {
	 		jqCapital = eval("'#" + this.id + "'");
	 		capital= $(jqCapital).asNumber();
	 		if(capital != '' && !isNaN(capital)){
	 			suma = suma + capital;
	 			contador = contador + 1;
	 			$(jqCapital).formatCurrency({
	 				positiveFormat: '%n',
	 				roundToDecimalPlace: 2
	 			});
	 		}else{
	 			$(jqCapital).val(0);
	 		}
	 	});
	 	if (suma!= $('#montoCredito').asNumber() ) {
	 		mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
	 		return 1;
	 	}
	 }

	 function crearMontosCapital(numTransac){
	 	var suma =	sumaCapital();
	 	var idCapital="";
	 	if(suma !=1){
	 		$('#montosCapital').val("");
	 		for(var i = 1; i <= $('input[name=capital]').length; i++){
	 			idCapital = eval("'#capital"+i+"'");
	 			if($(idCapital).asNumber()>="0"){
	 				if(i == 1){
	 					$('#montosCapital').val($('#montosCapital').val() +
	 							i + ']' +
	 							$(idCapital).asNumber() + ']' +
	 							numTransac);
	 				}else{
	 					$('#montosCapital').val($('#montosCapital').val() + '[' +
	 							i + ']' +
	 							$(idCapital).asNumber() + ']' +
	 							numTransac);
	 				}
	 			}
	 		}
	 		return 2;
	 	}
	 }

	 //funcion que bloque la pantalla mientras se cotiza
	 function bloquearPantallaAmortizacion() {
	 	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	 	$('#contenedorForma').block({
	 		message : $('#mensaje'),
	 		css : {
	 			border : 'none',
	 			background : 'none'
	 		}
	 	});

	 }
	 // agrega el scroll al div de simulador de pagos libres de capital
	 $('#contenedorSimuladorLibre').scroll(function() {

	 });


	 /* FUNCION PARA VALIDAR QUE LA ULTIMA CUOTA DE CAPITAL EN EL COTIZADOR DE  PAGOS LIBRES EN CAPITAL O IRREGULAR
	  * NO SEA CERO.*/
	 function validaUltimaCuotaCapSimulador(){
	 	if($('#tipoPagoCapital').val()=="L"){
	 		var numAmortizacion = $('input[name=capital]').length;
	 		for(var i = 1; i <= numAmortizacion; i++){
	 			if(i== numAmortizacion ){
	 				var idCapital = eval("'#capital"+i+"'");
	 				if($(idCapital).asNumber()==0 ){
	 					document.getElementById("capital"+i+"").focus();
	 					document.getElementById("capital"+i+"").select();
	 					$("capital"+i).addClass("error");
	 					mensajeSis("La Última Cuota de Capital no puede ser Cero.");
	 					procede = 1;
	 				}else{
	 					procede = 0;
	 				}
	 			}else{
	 				procede = 0;
	 			}
	 		}
	 	}else{
	 		procede = 0;
	 	}
	 	return procede;
	 }




	 /* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
	 function ajustaValoresFechaElimina(numeroID,jqFechaInicio){
	 	var idCajaRenom		= "";
	 	var siguiente		= 0;
	 	var anterior		= 0;
	 	var continuar		= 0;
	 	var numFilas		= $('input[name=fechaVencim]').length;

	 	if(numeroID <= numFilas ){
	 		if(numeroID == 1){
	 			siguiente = parseInt(numeroID) + parseInt(1);
	 			idCajaRenom = eval("'#fechaInicio"+siguiente+"'");
	 			$(idCajaRenom).val($(jqFechaInicio).val());
	 			continuar = 1;
	 		}else{
	 			if(numeroID < numFilas){
	 				siguiente = parseInt(numeroID) + parseInt(1);
	 				anterior = parseInt(numeroID) - parseInt(1);
	 				idCajaRenom = eval("'#fechaInicio"+siguiente+"'");
	 				jqFechaVencim = eval("'#fechaVencim"+anterior+"'");
	 				$(idCajaRenom).val($(jqFechaVencim).val());
	 				continuar = 1;
	 			}else{
	 				if(numeroID == numFilas){
	 					continuar = 1;
	 				}
	 			}
	 		}
	 	}
	 	return continuar;
	 }




	 /* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
	 function ajustaValoresFechaModifica(numeroID,jqFechaInicio){
	 	var idCajaRenom		= "";
	 	var siguiente		= 0;
	 	var continuar		= 0;
	 	var numFilas		= $('input[name=fechaVencim]').length;

	 	if(numeroID <= numFilas ){
	 		if(numeroID < numFilas){
	 			siguiente = parseInt(numeroID) + parseInt(1);
	 			idCajaRenom = eval("'#fechaInicio"+siguiente+"'");
	 			jqFechaVencim = eval("'#fechaVencim"+numeroID+"'");
	 			$(idCajaRenom).val($(jqFechaVencim).val());
	 			continuar = 1;
	 		}else{
	 			if(numeroID == numFilas){
	 				continuar = 1;
	 			}
	 		}
	 	}
	 	return continuar;
	 }


	 /* FUNCION PARA VALIDAR QUE LA FECHA DE VENCIMIENTO MODIFICADA NO SEA MAYO A LA FECHA DE VENCIMIENTO SIGUIENTE*/
	 function comparaFechaModificadaSiguiente(varid, jqFechaVen ,jqFechaInicio){
	 	var siguiente = parseInt(varid) + parseInt(1);
	 	var numFilas		= $('input[name=fechaVencim]').length;
	 	if(varid < numFilas ){
	 		var jqFechaVenSiguiente = eval("'#fechaVencim" +siguiente + "'");

	 		var fechaIni = $(jqFechaVen).val();
	 		var fechaVen = $(jqFechaVenSiguiente).val();
	 		var xYear=fechaIni.substring(0,4);
	 		var xMonth=fechaIni.substring(5, 7);
	 		var xDay=fechaIni.substring(8, 10);
	 		var yYear=fechaVen.substring(0,4);
	 		var yMonth=fechaVen.substring(5, 7);
	 		var yDay=fechaVen.substring(8, 10);
	 		if($(jqFechaVen).val()!= ""){
	 			if(esFechaValida($(jqFechaVen).val())){
	 				if(validaFechaVencimientoGrid($(jqFechaVen).val(), $('#fechaVencimien').val(), jqFechaVen, varid)){
	 					if (yYear<xYear ){
	 						mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortizazion.");
	 						document.getElementById("fechaVencim"+varid).focus();
	 						$(jqFechaVen).addClass("error");
	 					}else{
	 						if (xYear == yYear){
	 							if (yMonth<=xMonth){
	 								if (xMonth == yMonth){
	 									if (yDay<=xDay||yDay==xDay){
	 										mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortizazion.");
	 										document.getElementById("fechaVencim"+varid).focus();
	 										$(jqFechaVen).addClass("error");
	 									}else{
	 										ajustaValoresFechaModifica(varid,jqFechaInicio);
	 									}
	 								}else{
	 									ajustaValoresFechaModifica(varid,jqFechaInicio);
	 								}
	 							}else{
	 								ajustaValoresFechaModifica(varid,jqFechaInicio);
	 							}
	 						}else{
	 							ajustaValoresFechaModifica(varid,jqFechaInicio);
	 						}
	 					}
	 				}else{
	 					$(jqFechaVen).focus();
	 				}
	 			}else{
	 				$(jqFechaVen).focus();
	 			}
	 		}
	 	}
	 }  // fin comparaFechaModificadaSiguiente


	 // funcion para validar si cambia la fecha de desembolso o no .
	 function validaFechaMinistrado(){
		 var procede = 1;
		 var fechMinis = $('#fechaMinistrado').val();
		 var fechaAplicacion = parametroBean.fechaAplicacion;
		 convertDate(fechMinis);
		 convertDate(fechaAplicacion);
		 if(fechMinis < fechaAplicacion && fechMinis != '' ){
			mensajeSis("La Fecha de Desembolso no debe ser Inferior a la del Sistema.");
			$('#fechaMinistrado').focus();
			$('#fechaMinistrado').select();
			$('#fechaMinistrado').val(fechaAplicacion);
			procede = 1;
		 } else{
	  		if(fechMinis == ''){
	  			mensajeSis("La Fecha de Desembolso está Vacia.");
	  			$('#fechaMinistrado').focus();
	  			$('#fechaMinistrado').select();
	  			procede = 1;
	  		} else{
	  			if($('#frecuenciaCap').val() == 'M' ){
	  				if($('#diaPagoInteres').val() == 'A'){
						$('#diaMesInteres').val($('#fechaMinistrado').val().substring(8,10));
					}
	  				if($('#diaPagoCapital').val() == 'A'){
						$('#diaMesCapital').val($('#fechaMinistrado').val().substring(8,10));
					}
	  			}
	  			if($('#fechaMinistrado').val() != $('#fechaMinistradoOriginal').val()
	  					&& $('#tipoPagoCapital').val()=="L" ){
	  				 procede = 1;
	  				 $('#simular').show();
	  				 deshabilitaBoton('grabar', 'submit');
	  				 
	  				 if(manejaConvenio=='S'){
	                        if(noSeguirPro!=true){
	                        	habilitaBoton('simular', 'submit');
	                      }else{
	                          deshabilitaBoton('simular', 'submit');
	                      }
	                    }else{
	                    	habilitaBoton('simular', 'submit');
	                    }
	  				 
	  				 mensajeSis("Se requiere una nueva Simulación");
	  			 }else{
	  				if($('#tipoPagoCapital').val()=="L" &&  $('#numTransacSim').asNumber() ==0 ){
	  					 procede = 1;
	  	  				 $('#simular').show();
	  	  				 deshabilitaBoton('grabar', 'submit');
		  	  			 if(manejaConvenio=='S'){
		                        if(noSeguirPro!=true){
		                        	habilitaBoton('simular', 'submit');
		                      }else{
		                          deshabilitaBoton('simular', 'submit');
		                      }
		                    }else{
		                    	habilitaBoton('simular', 'submit');
		                    }
	  	  				 mensajeSis("Se requiere una nueva Simulación");
	  				}else{
	  					deshabilitaBoton('simular', 'submit');
	  	  				procede = 0;

	  	  				 if($('#simuladoNuevamente').val()=="S"){
	  	  					 $('#tipoActualizacion').val(catTipoActCredito.actualizaCredAmor);
	  	  				 }else{
	  	  					 $('#tipoActualizacion').val(catTipoActCredito.actualizaCred);
	  	  				 }
	  				}
	  			 }
	  		}
		}
		 return procede;
	 }

	 


		// Función para calcular los días transcurridos entre dos fechas
		function restaFechas(fAhora,fEvento) {

			var ahora = new Date(fAhora);
	     var evento = new Date(fEvento);
	     var tiempo = evento.getTime() - ahora.getTime();
	     var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));

			return dias;
		 }



		// consulta de la fecha de vencimiento en base al plazo
		function consultaFechaVencimiento(idControl) {

			var jqPlazo = eval("'#" + idControl + "'");
			var plazo = $(jqPlazo).val();
			var tipoCon = 3;
			var PlazoBeanCon = {
					'plazoID' : plazo,
					'fechaActual' : $('#fechaInicioAmor').val(),
					'frecuenciaCap' : $('#frecuenciaCap').val()
			};
			if (plazo == '') {
				$('#fechaVencimien').val("");

			} else {
				plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) {
					if (plazos != null) {
							$('#fechaVencimien').val(plazos.fechaActual);
							if ($('#frecuenciaCap').val() != "U") {
									$('#numAmortizacion').val(plazos.numCuotas);
									if ($('#tipoPagoCapital').val() == 'C') {
										$('#numAmortInteres').val(plazos.numCuotas);

									} else {
										$('#numAmortizacion').val(plazos.numCuotas);
										if ($('#perIgual').val() == "S") {
											$('#numAmortInteres').val(plazos.numCuotas);

										}
									}

							} else {
									$('#numAmortizacion').val("1");
							}
					}
				});
			}

		}// fin consultaFechaVencimiento


	function consultaCredito (){
		deshabilitaBoton('grabar', 'submit');
		var creditoBeanCon = {
				'creditoID':$('#creditoID').val()
		};
		creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
			if(credito!=null){
				dwr.util.setValues(credito);

				$('#tipoPrepago').val(credito.tipoPrepago);
				if(credito.estatus != catEstatusCredito.autorizado &&
						credito.estatus != catEstatusCredito.inactivo && credito.estatus != catEstatusCredito.procesado){
				deshabilitaControl('tipoPrepago');
				}else{habilitaControl('tipoPrepago');}

				$('#plazoID').val(credito.plazoID).selected = true;
				$('#montoCredito').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				var fechaAplicacion = parametroBean.fechaAplicacion;
				fechaMinisAct = $('#fechaMinistrado').val();
				if(credito.fechaMinistrado ==  '1900-01-01' ){
					$('#fechaMinistrado').val(fechaAplicacion);
					$('#fechaMinistradoOriginal').val(fechaAplicacion);
				}else{
					$('#fechaMinistrado').val(credito.fechaMinistrado);
					$('#fechaMinistradoOriginal').val(credito.fechaMinistrado);
				}
				estatus = credito.estatus;
				consultaCliente('clienteID');
				if(estatus != catEstatusCredito.autorizado &&
						   estatus != catEstatusCredito.inactivo
						   &&  estatus != catEstatusCredito.procesado){
								deshabilitaBoton('grabar', 'submit');
								deshabilitaControl('fechaMinistrado');


						}else{
							habilitaControl('fechaMinistrado');
						}
						

						consultaHuellaCliente();
						consultaLineaCredito('lineaCreditoID');
						consultaMoneda('monedaID');
						if(credito.tasaBase !=0){
							consultaTasaBase('tasaBase');
						}
						consultaProducCredito('producCreditoID', credito.grupoID, false);
						//Habilitamos el boton de Generacion de Cuenta Clabe para tipos de personas fisicas
						//o fisicas con actividad empresarial
						var tipoPersona = $("#tipoPersonaCli").val();
						var participaSPEI = $("#participaSPEI").val();
						if(participaSPEI == "S" && (tipoPersona=="F" || tipoPersona=="A")) {
							habilitaBoton('generarCuentaClabe','submit');
							$("#generarCuentaClabe").css('display','block');
						}
						else {
							deshabilitaBoton('generarCuentaClabe','submit');
							$("#generarCuentaClabe").css('display','none');
						}
						
						if(credito.fechaInhabil=='S'){
							$('#fechaInhabil1').attr("checked","1") ;
							$('#fechaInhabil2').attr("checked",false) ;
							$('#fechaInhabil').val("S");
						}else{
							$('#fechaInhabil2').attr("checked","1") ;
							$('#fechaInhabil1').attr("checked",false);
							$('#fechaInhabil').val("A");
						}

						if(credito.ajusFecExiVen=='S'){
							$('#ajusFecExiVen1').attr("checked","1") ;
							$('#ajusFecExiVen2').attr("checked",false);
							$('#ajusFecExiVen').val("S");
						}else{
							$('#ajusFecExiVen2').attr("checked","1");
							$('#ajusFecExiVen1').attr("checked",false);
							$('#ajusFecExiVen').val("N");
						}

						if(credito.calendIrregular=='S'){
							$('#calendIrregularCheck').attr("checked","1");
							$('#calendIrregular').val("S");
						}else{
							$('#calendIrregularCheck').attr("checked",false);
							$('#calendIrregular').val("N");
						}

						if(credito.ajusFecUlVenAmo=='S'){
							$('#ajusFecUlVenAmo1').attr("checked","1") ;
							$('#ajusFecUlVenAmo2').attr("checked",false) ;
							$('#ajusFecUlVenAmo').val("S");
						}else{
							$('#ajusFecUlVenAmo2').attr("checked","1") ;
							$('#ajusFecUlVenAmo1').attr("checked",false) ;
							$('#ajusFecUlVenAmo').val("N");
						}

						// Si no es Quincenal.
						if(credito.frecuenciaInt != frecuenciaQuincenal){
							textoDiaPago = 'Día del Mes';
							if (credito.diaPagoInteres == 'F') {
								$('#diaPagoInteres1').attr("checked","1");
								$('#diaPagoInteres2').attr("checked",false);
							} else {
								$('#diaPagoInteres2').attr("checked","1");
								$('#diaPagoInteres1').attr("checked",false);
								$('#diaMesInteres').val(credito.diaMesInteres);
							}
							$('#divDiaPagoIntMes').show();
							$('#divDiaPagoIntQuinc').hide();
						} else {// Si es Quincenal.
							textoDiaPago = 'Día de Pago';
							if (credito.diaPagoInteres == 'D') {
								$('#diaPagoInteresD').attr('checked',true);
								$('#diaPagoInteresQ').attr('checked',false);
								$('#diaDosQuincInt').val(Number(credito.diaMesInteres) + 15);
								$('#diaDosQuincInt').show();
							} else {
								$('#diaPagoInteresD').attr('checked',false);
								$('#diaPagoInteresQ').attr('checked',true);
								$('#diaDosQuincInt').val('0');
								$('#diaDosQuincInt').hide();
							}
							$('#divDiaPagoIntMes').hide();
							$('#divDiaPagoIntQuinc').show();
						}
						$('#diaPagoInteres').val(credito.diaPagoInteres);
						$('#labelDiaInteres').text(textoDiaPago+': ');

						// Si no es Quincenal.
						if(credito.frecuenciaCap != frecuenciaQuincenal){
							textoDiaPago = 'Día del Mes';
							if (credito.diaPagoCapital == 'F') {
								$('#diaPagoCapital1').attr("checked","1");
								$('#diaPagoCapital2').attr("checked",false);
							} else {
								$('#diaPagoCapital2').attr("checked","1");
								$('#diaPagoCapital1').attr("checked",false);
								$('#diaMesCapital').val(credito.diaMesCapital);
							}
							$('#divDiaPagoCapMes').show();
							$('#divDiaPagoCapQuinc').hide();
						} else {// Si es Quincenal.
							textoDiaPago = 'Día de Pago';
							if (credito.diaPagoCapital == 'D') {
								$('#diaPagoCapitalD').attr('checked',true);
								$('#diaPagoCapitalQ').attr('checked',false);
								$('#diaDosQuincCap').val(Number(credito.diaMesCapital) + 15);
								$('#diaDosQuincCap').show();
							} else {
								$('#diaPagoCapitalQ').attr('checked',true);
								$('#diaPagoCapitalD').attr('checked',false);
								$('#diaDosQuincCap').val('0');
								$('#diaDosQuincCap').hide();
							}
							$('#divDiaPagoCapMes').hide();
							$('#divDiaPagoCapQuinc').show();
						}
						$('#diaPagoCapital').val(credito.diaPagoCapital);
						$('#labelDiaCapital').text(textoDiaPago+': ');

						$('#cat').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 1});

						agregaFormatoControles('formaGenerica');
					}else{
						mensajeSis("No Existe el Crédito.");
							$('#creditoID').focus();
							$('#creditoID').select();
							deshabilitaBoton('grabar', 'submit');
							deshabilitaBoton('exportarPDF', 'submit');
							deshabilitaBoton('ExptablaAmorti', 'submit');
							deshabilitaBoton('caratula', 'submit');
							deshabilitaBoton('simular', 'submit');
							deshabilitaBoton('ExportExcel', 'submit');
 							inicializaForma('formaGenerica','creditoID');
						}
			});
	}

	
	function existeEsquemaQConvenio(institucionID, convenioID){
	    
	    var esquemaQBean = {
	        'institNominaID': institucionID,
	        'convenioNominaID': convenioID
	    };
	    setTimeout("$('#cajaLista').hide();", 200);
	    esquemaQuinqueniosServicio.consulta(3, esquemaQBean,{ async: false, callback: function(resultado) {
	   
	        if(resultado != null) {
	            if(resultado.cantidad > 0){
	               
	                $(".quinquenios").show();
	                noSeguirPro= false;

	            }else{
	            	
                     deshabilitaBoton('simular','submit');
                     deshabilitaBoton('grabar','submit');
	                noSeguirPro = true;
	                mensajeSis("El convenio de la Empresa Nómina no cuenta con un Esquema de Quinquenios parametrizado");
	            }
	            
	        }
	        
	    }});
	}

	// funcion que llena el combo de calcInteres
	function consultaComboCalInteres() {
		dwr.util.removeAllOptions('calcInteresID');
		formTipoCalIntServicio.listaCombo(catFormTipoCalInt.principal,function(formTipoCalIntBean){
			dwr.util.addOptions('calcInteresID', {'':'SELECCIONAR'});
			dwr.util.addOptions('calcInteresID', formTipoCalIntBean, 'formInteresID', 'formula');
		});
	}

	consultaComboCalInteres();

	consultaParametro();
	//Funcion para consultar parametro tabla PARAMGENERALES
	function consultaParametro(){
		var tipoConsulta = 13;
		paramGeneralesServicio.consulta(tipoConsulta, function(valor){
			if(valor!=null){
				$('#numClienteEspec').val(valor.valorParametro);
			}
		});
	}


function muestraGridAccesorios(){

	var numCredito = $('#creditoID').val();
	var params = {};
	params['tipoLista'] = 3;
	params['solicitudCreditoID'] =  $('#solicitudCreditoID').val();

	if(numCredito > 0){
		params['creditoID'] =  numCredito;

	}

	$.post("accesoriosGridVista.htm", params, function(data) {
		if (data.length > 0) {
			$('#divAccesoriosCred').html(data);
			var numFilas = consultaFilasAccesorios();
			if (numFilas == 0) {
				$('#divAccesoriosCred').html("");
				$('#divAccesoriosCred').show();
				$('#fieldOtrasComisiones').hide();

			} else {

				$('#divAccesoriosCred').show();
				$('#fieldOtrasComisiones').show();
				agregaFormatoControles('gridDetalleDiv');
				asignaValoresAccesorios();
			}

		} else {
			$('#divAccesoriosCred').html("");
			$('#divAccesoriosCred').show();
			$('#fieldOtrasComisiones').hide();


		}
	});


}

function asignaValoresAccesorios() {

	$("input[name=formaCobro]").each(function(i) {
		var numero = this.id.replace(/\D/g,'');
		var jqIdChecked = eval("'formaCobro" + numero + "'");


		var formaCobro = document.getElementById(jqIdChecked).value;
		if (formaCobro == 'F') {
			$('#formaCobro' + numero).val('FINANCIAMIENTO');
		}
		if (formaCobro == 'A') {
			$('#formaCobro' + numero).val('ANTICIPADO');
		}
		if (formaCobro == 'D') {
			$('#formaCobro' + numero).val('DEDUCCION');
		}
	});


	$("input[name=montoAccesorio]").each(function(i) {
		var numero = this.id.replace(/\D/g,'');
		var jqIdChecked = eval("'montoAccesorio" + numero + "'");
		
		
		agregaFormatoMonedaGrid(jqIdChecked)
	});

	$("input[name=montoIVAAccesorio]").each(function(i) {
		var numero = this.id.replace(/\D/g,'');
		var jqIdChecked = eval("'montoIVAAccesorio" + numero + "'");
		
		
		agregaFormatoMonedaGrid(jqIdChecked)
	});

}

//Función consulta el total de creditos en la lista
function consultaFilasAccesorios() {
	var totales = 0;
	$('tr[name=renglonAccesorio]').each(function() {
		totales++;

	});
	return totales;
}


//Metodo Para consultar si se maneja convenios
function consultaManejaConvenios(){
    var tipoConsulta = 36;
    var bean = {
            'empresaID'     : 1
        };

    paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
            if (parametro != null){
                manejaConvenio = parametro.valorParametro;
            }else {
                manejaConvenio = 'N';
            }

    }});
}


if(manejaConvenio=='S')
{
   if(noSeguirPro==true){
       
       deshabilitaBoton('grabar');
        deshabilitaBoton('simular');
      }
}


function consultaCliente(idControl) {
	var jqCliente = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();
	var tipConForanea = 1;
	setTimeout("$('#cajaLista').hide();", 200);

	if(numCliente != '' && !isNaN(numCliente)){
		clienteServicio.consulta(tipConForanea,numCliente, { async: false, callback: function(cliente) {
					if(cliente!=null){
						$('#clienteID').val(cliente.numero);
						$('#nombreCliente').val(cliente.nombreCompleto);
						$('#tipoPersonaCli').val(cliente.tipoPersona);
						fechaNacimiento = cliente.fechaNacimiento;
						  if (cliente.estatus=="I"){
								deshabilitaBoton('grabar','submit');
								mensajeSis("El Cliente se Encuentra Inactivo.");
								$('#creditoID').focus();
						  }
					}else{
						mensajeSis("No Existe el Cliente.");
						$('#clienteID').focus();
						$('#clienteID').select();
					}
			}});
		}
}

function consultaPagareImp(idControl) {
	var creditoBeanCon = {
				'creditoID':$('#creditoID').val()
			};
	creditosServicio.consulta(catTipoConsultaCredito.pagareImp,creditoBeanCon,function(credito) {
			if(credito.pagareImpreso=='S'){
				deshabilitaBoton('imprimir', 'submit');
				deshabilitaBoton('exportarPDF', 'submit');
				deshabilitaBoton('ExptablaAmorti', 'submit');
				deshabilitaBoton('caratula', 'submit');
				deshabilitaBoton('ExportExcel', 'submit');
				deshabilitaBoton('simular', 'submit');
			}
	});

	$('#tipoPrepago').val(credito.tipoPrepago);
	if(credito.estatus != catEstatusCredito.autorizado && credito.estatus != catEstatusCredito.inactivo && credito.estatus != catEstatusCredito.procesado){
		deshabilitaControl('tipoPrepago');
	}else{
		habilitaControl('tipoPrepago');
	}
}



function consultaSaldoLinea(idControl) {
	var jqNum = eval("'#" + idControl + "'");
	var numLin = $(jqNum).val();
	setTimeout("$('#cajaLista').hide();", 200);

	if(numLin != '' && !isNaN(numLin)){
	var lineaFondBeanCon = {
				'lineaFondeoID':$('#lineaFondeo').val()
			};
	lineaFonServicio.consulta(catTipoConsultaCredito.principal,lineaFondBeanCon,function(lineaFond) {
				if(lineaFond!=null){
					$('#nombrelineaFond').val(lineaFond.descripLinea);
					$('#saldoLinea').val(lineaFond.saldoLinea);

				}else{
					mensajeSis("No Existe la Línea Fondeador");
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('agrega', 'submit');
					$('#lineaFondeoID').focus();
					$('#lineaFondeoID').select();
				}
		});
	}
}



function consultaInstituFondeo(idControl) {
	var jqInst = eval("'#" + idControl + "'");
	var numInst = $(jqInst).val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numInst != '' && !isNaN(numInst)){
		var instFondeoBeanCon = {
				'institutFondID':numInst
		};
		fondeoServicio.consulta(catTipoConsultaCredito.principal,instFondeoBeanCon,function(instFondeo) {
			if(instFondeo!=null){
				$('#nombreInst').val(instFondeo.nombreInstitFon);
			}else{
				mensajeSis("No Existe la Institución de Fondeo.");
			}
		});
	}
}



function consultaMoneda(idControl) {
	var jqMoneda = eval("'#" + idControl + "'");
	var numMoneda = $(jqMoneda).val();
	var conMoneda=2;
	setTimeout("$('#cajaLista').hide();", 200);
	if(numMoneda != '' && !isNaN(numMoneda)){
		monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){
					$('#monedaDes').val(moneda.descripcion);
				}else{
					mensajeSis("No Existe el Tipo de Moneda");
					$('#monedaDes').val('');
					$(jqMoneda).focus();
				}
		});
	}
}


function consultaLineaCredito(idControl) {
	var jqLinea  = eval("'#" + idControl + "'");
	var lineaCred = $(jqLinea).val();
	var lineaCreditoBeanCon = {
		'lineaCreditoID'	:lineaCred
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if(lineaCred != '' && !isNaN(lineaCred)){
		lineasCreditoServicio.consulta(catTipoConsultaCredito.principal,lineaCreditoBeanCon,function(linea) {

				if(linea!=null){
					$('#saldoDisponible').val(linea.saldoDisponible);
					$('#saldoDeudor').val(linea.saldoDeudor);
				}
		});
	}
}


//Consulta Tasa Base
	function consultaTasaBase(idControl) {
	var jqTasa  = eval("'#" + idControl + "'");
	var tasaBase = $(jqTasa).val();
	var TasaBaseBeanCon = {
			'tasaBaseID':tasaBase
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if(tasaBase != '' && !isNaN(tasaBase)){
			tasasBaseServicio.consulta(1,TasaBaseBeanCon ,function(tasasBaseBean) {
				if(tasasBaseBean!=null){
		           $('#desTasaBase').val(tasasBaseBean.nombre);
				}else{
					mensajeSis("No Existe la Tasa Base.");
					$('#tasaBaseID').focus();
					$('#tasaBaseID').selected();
				}
			});
		}
	}


function consultaProducCredito(idControl, grupoID, controlSimulador) {
	var jqProdCred  = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();
	var ProdCredBeanCon = {
			'producCreditoID':ProdCred
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if(ProdCred != '' && !isNaN(ProdCred)){
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,{ async: false, callback: function(prodCred) {
				if(prodCred!=null){
					cobraAccesorios = prodCred.cobraAccesorios;
					esProductoNomina = prodCred.productoNomina;
					$("#participaSPEI").val(prodCred.participaSpei);
					if(prodCred.productoNomina=="S") {
						 if(manejaConvenio=='S'){
                    	consultaNomInstit();
						consultaConvenioNomina();
						$('#datosNomina').show();
					
					    }else{
					    	$('#datosNomina').hide();
					    	$('.quinquenios').hide();
					    }
                    }else{
                    	$('#datosNomina').hide();
					    $('#institucionNominaID').val("");
					    $('#nombreInstit').val("");
					    $('#convenioNominaID').val("");
    					$('#desConvenio').val("");
    					$('.quinquenios').hide();
    					$('.folioSolici').hide();
					    $('#folioSolici').val("");
					    dwr.util.removeAllOptions('quinquenioID');
					    dwr.util.addOptions('quinquenioID',{'':'SELECCIONAR'});
                    }
					if(prodCred.permitePrepago =='S'){
						$('#pregagos').show();
					}else{
						$('#pregagos').hide();
					}
					if(prodCred.modificarPrepago == 'S'){
						habilitaControl('tipoPrepago');
					}else{
						deshabilitaControl('tipoPrepago');
					}
			 		if(estatus != catEstatusCredito.autorizado &&  estatus != catEstatusCredito.inactivo &&  estatus != catEstatusCredito.procesado){
				       deshabilitaControl('tipoPrepago');
					}
					$('#nombreProd').val(prodCred.descripcion);
					$('#reca').val(prodCred.registroRECA);

					if(prodCred.esGrupal == 'S' && grupoID > 0){
						mensajeSis("Producto de Crédito Reservado para Créditos Grupales.");
						deshabilitaBoton('grabar', 'submit');
						deshabilitaBoton('exportarPDF', 'submit');
						deshabilitaBoton('ExptablaAmorti', 'submit');
						deshabilitaBoton('caratula', 'submit');
						deshabilitaBoton('ExportExcel', 'submit');
						$('#gridAmortizacion').html("");
						$('#contenedorSimuladorLibre').html("");
						inicializaForma('formaGenerica','creditoID');
						$('#creditoID').focus();

					}else{
						if (controlSimulador){
							consultaGridAmortizacionesGrabadas();
						}
						
					}


					// valida si el producto de credito puede tener un desembolso anticipado
					if(prodCred.inicioAfuturo == 'S' && ($("#estatus").val() == catEstatusCredito.inactivo || $("#estatus").val() == catEstatusCredito.autorizado || $("#estatus").val() == catEstatusCredito.procesado)){
						$("#fechaInicioAmor").attr('readonly',false);
						$("#fechaInicioAmor").datepicker({
			    			showOn: "button",
			    			buttonImage: "images/calendar.png",
			    			buttonImageOnly: true,
							changeMonth: true,
							changeYear: true,
							dateFormat: 'yy-mm-dd',
							yearRange: '-100:+10'
						});

						inicioAfuturo = 'S';
						diasMaximo = prodCred.diasMaximo;
					}else{
						$("#fechaInicioAmor").attr('readonly',true);
						$("#fechaInicioAmor").datepicker("destroy");

						inicioAfuturo = 'N';
						diasMaximo = 0;
					}
				}else{
					mensajeSis("No Existe el Producto de Crédito.");
				}
		}});
	}
}

// función para consultar si el cliente ya tiene huella digital registrada
function consultaHuellaCliente(){
	var numCliente=$('#clienteID').val();
	if(numCliente != '' && !isNaN(numCliente )){
		var clienteIDBean = {
			'personaID':$('#clienteID').val()
			};
		huellaDigitalServicio.consulta(1,clienteIDBean,function(cliente) {
			if (cliente==null){
				var huella=parametroBean.funcionHuella;
				if(huella =="S" && huellaProductos=="S"){
					mensajeSis("El Cliente no tiene Huella Registrada.\nFavor de Verificar.");
					$('#creditoID').focus();
					deshabilitaBoton('grabar','submit');
				}
			}
		});
	}
}
//CONVENIOS
	function consultaFechaLimite(institucionID, convenioID){
		var calendarioIngresosBean = {
			'institNominaID': institucionID,
			'convenioNominaID': convenioID,
			'anio': 0,
			'estatus': "",
		};
		setTimeout("$('#cajaLista').hide();", 200);
		calendarioIngresosServicio.consulta(3, calendarioIngresosBean, function(resultado) {
			if(resultado != null) {
				$("#fechaLimEnvIns").val(resultado.fechaLimiteEnvio);
				$(".fechaLimiteEnvio").show();
			}else{
				$(".fechaLimiteEnvio").hide();
				$("#fechaLimEnvIns").val("");
				$("#institucionNominaID").focus();
				mensajeSis("El convenio de la institución seleccionada <b>no cuenta con un esquema de calendario autorizado</b> del presente año.");
			}
		});
	}


	function consultaConvenioNomina(convenioID) {
	    var convenioBean = {
	        'convenioNominaID': $('#convenioNominaID').val()
	    };
	    var convenioID = $('#convenioNominaID').val();
	    var institucion = $('#institucionNominaID').val();
	    setTimeout("$('#cajaLista').hide();", 200);
	    conveniosNominaServicio.consulta(1, convenioBean, function(resultado) {
			if (resultado != null) {
				$("#desConvenio").val(resultado.descripcion);
				if (resultado.requiereFolio=="S") {
					 $('.folioSolici').show();
				}
				else{
					$('.folioSolici').hide();
					$('#folioSolici').val("");
				}
				if (resultado.manejaQuinquenios=="S") {
					existeEsquemaQConvenio(institucion,convenioID);
				}
				else{
					$(".quinquenios").hide();
					$("#quinquenioID").val("");
				}

				consultaFechaLimite();
			} else {
				$("#convenioNominaID").val("");
				$("#desConvenio").val("");
				$(".fechaLimiteEnvio").hide();
				$("#fechaLimEnvIns").val("");
				$(".quinquenios").hide();
				$('.folioSolici').hide();
				$('#folioSolici').val("");
				dwr.util.removeAllOptions('quinquenioID');
				dwr.util.addOptions('quinquenioID',{'':'SELECCIONAR'});
			}
		});
	}

	function consultaNomInstit() {
		var tipoCon = 1;
		var institucion = $('#institucionNominaID').val();
		if (institucion != ''  && !isNaN(institucion) && institucion >0){
			var institNominaBean = {
					'institNominaID' : institucion
			};
			institucionNomServicio.consulta(tipoCon, institNominaBean, function(institucionNomina) {
				if (institucionNomina != null){
					$('#nombreInstit').val(institucionNomina.nombreInstit);
				}
				else {
					mensajeSis("La Empresa de Nómina no Existe.");
					$("#fechaLimEnvIns").val("");
					$(".fechaLimiteEnvio").hide();
					$('#nombreInstit').val('');
					$('#institucionNominaID').val('');
					$('#institucionNominaID').focus();
				}
			});
		} else {
			$('#nombreInstit').val('');
		}
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


	function consultaFechaLimite(){
		var calendarioIngresosBean = {
			'institNominaID': $('#institucionNominaID').val(),
			'convenioNominaID': $('#convenioNominaID').val(),
			'anio': 0,
			'estatus': "",
		};
		setTimeout("$('#cajaLista').hide();", 200);
		calendarioIngresosServicio.consulta(3, calendarioIngresosBean, function(resultado) {
			if(resultado != null) {
				$("#fechaLimEnvIns").val(resultado.fechaLimiteEnvio);
				$(".fechaLimiteEnvio").show();
			}else{
				$(".fechaLimiteEnvio").hide();
				$("#fechaLimEnvIns").val("");
				$("#institucionNominaID").focus();
				mensajeSis("El convenio de la institución seleccionada <b>no cuenta con un esquema de calendario autorizado</b> del presente año.");
			}
		});
	}
//FIN DE CONVENIOS

function consultaReferencias(){
	var numCredito = $('#creditoID').val();
	var creditoBeanCon = { 
			'instrumentoID':numCredito
			
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numCredito != '' ){
		referenciasPagosServicio.consulta(creditoBeanCon,3,{ async: false, callback: function(referencia) {
			if(referencia!=null){
				if(referencia.existe == 'N'){					
					existeReferencia = 'N';
				}else{
					existeReferencia = 'S';
				}
			}
		},
		ErrorHandler : function(message) {
			mensajeSis("Error al Consultar: " + message);
		}});
	}
}

function generaReferencias(){
	consultaDirOficial();
	fecha(fechaNacimiento);
	

	referenciaBanorte = $('#creditoID').val();
	referenciaTelecom = estadoID + municipioID + dia + mes + anio + cerosIzq2($('#creditoID').val(),8);

	$("#referenciaBanorte").val(referenciaBanorte); 
	$("#referenciaTelecom").val(referenciaTelecom);
}

function consultaDirOficial() {
	var direccionesCliente ={
		 'clienteID' : $('#clienteID').val(),
		 'direccionID': '0'

	};
	var numCliente = $('#clienteID').val();
	setTimeout("$('#cajaLista').hide();", 200);

	if(numCliente != '' && !isNaN(numCliente)){
		direccionesClienteServicio.consulta(7,direccionesCliente,{ async: false, callback: function(direccion) {
			if(direccion!=null){
				estadoID = direccion.estadoID;
				municipioID = direccion.municipioID;

				estadoID = cerosIzq2(estadoID,2);
				municipioID = cerosIzq2(municipioID,3);

			}else{
				estadoID = 'XX';
				municipioID = 'XXX';
			
			}
		}});
	}
}


function cerosIzq2(valor, longitud) {
	expr = /\s/;
	var valor2 = valor.replace(expr,"0");
	if (valor2 == "")
		valor2 = 0;
	if (isNaN(valor2) == true)
		valor2 = 0;
	else
	while (valor2.length < longitud) {
		valor2 = "0" + valor2;
	}
	return valor2;
}

function fecha(cadena) {

	var separador = "-";

	if (cadena.indexOf(separador) != -1) {

		var pos1 = 2;
		var pos2 = cadena.indexOf(separador, pos1 + 1);
		var pos3 = cadena.indexOf(separador, pos2 + 2);

		anio= cadena.substring(pos1, pos2);
		mes = cadena.substring(pos2 + 1, pos3);
		dia= cadena.substring(pos3 + 1, cadena.length);


	} else {
		anio= 'XX';
		mes = 'XX';
		dia= 'XX';
	}
}


function consultaInstitucionBanorte(){
	var tipoConsulta = 59;
	paramGeneralesServicio.consulta(tipoConsulta, { async: false, callback: function(valor){
		if(valor!=null){
			$('#institucionBanorte').val(valor.valorParametro);
		}
	}});
}

function consultaInstitucionTelecom(){
	var tipoConsulta = 60;
	paramGeneralesServicio.consulta(tipoConsulta, { async: false, callback: function(valor){
		if(valor!=null){
			$('#institucionTelecom').val(valor.valorParametro);
		}
	}});
}

function desgloseOtrasComisiones(par_creditoID){
	var listaDesglose = 6;
	var beanEntrada = {
			'creditoID':par_creditoID,
			'numTransacSim':0
	};
	esquemaOtrosAccesoriosServicio.lista(listaDesglose, beanEntrada, function(resultado) {
		if (resultado != null && resultado.length > 0) {
			
			var numRegistros = resultado.length;
			//var encabezadoLista = resultado[0].encabezadoLista;
			var numAmorAcc = resultado[0].numAmortizacion;
			var numAccesorios = resultado[0].contadorAccesorios;
			//var encabezados = encabezadoLista.split(',');
			// AGREGAR CONDICIONES DE SALDOS GLOBALES Y GENERA ACCESORIOS
			if (parseInt(numAccesorios) > 0){
				$('#tdLabelOtrasComis').remove();
				$('#tdLabelIvaOtrasComis').remove();
				$('#tdtotalOtrasComisiones').remove();
				$('#tdtotalIVAOtrasComisiones').remove();
			}

			var contadorItera = 0;

			// Itera por accesorio
			for (var contAcc = 0; contAcc < numAccesorios; contAcc++){

				var encabezadoLista = resultado[contadorItera].encabezadoLista;
				var encabezados = encabezadoLista.split(',');
				var numEncabezados = encabezados.length;

				// Se inserta el encabezado por comision
				for (var enc = 0; enc < numEncabezados; enc++){
					var elemento = encabezados[enc];
					var encabezado = '<td class="label" align="center"><label for="lblDesglose">'+ elemento +'</label></td>';
					$(encabezado).insertBefore("#tdEncabezadoAccesorios");
				}

				// Se insertan los montos por concepto y por cuota
				for (var amorAcc = 0; amorAcc < numAmorAcc; amorAcc++){

					var renglonID = amorAcc + 1;

					$('#tdOtrasComisiones' + renglonID).remove();
					$('#tdIvaOtrasComisiones' + renglonID).remove();					

					var montoCuotaAcc = resultado[contadorItera].montoCuota;
					var colMontoCuotaAcc = '<td><input id="montoCuotaAcc' + contadorItera +'"  size="18" style="text-align: right;" type="text" value="' + montoCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
					$(colMontoCuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);
					var montoIVACuotaAcc = resultado[contadorItera].montoIVACuota;
					var colMontoIVACuotaAcc = '<td><input id="montoIVACuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIVACuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
					$(colMontoIVACuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);

					if (resultado[contadorItera].generaInteres == 'S'){
						var montoIntCuotaAcc = resultado[contadorItera].montoIntCuota;
						var colMontoIntCuotaAcc = '<td><input id="montoIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIntCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colMontoIntCuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);
						var montoIvaIntCuotaAcc = resultado[contadorItera].montoIVAIntCuota;
						var colMontoIvaIntCuotaAcc = '<td><input id="montoIvaIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIvaIntCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colMontoIvaIntCuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);
					}

					// Insercion de totales
					if ((amorAcc + 1) == numAmorAcc) {
						var montoTotalAcc = resultado[contadorItera].montoAccesorio;
						var colTotalMontoCuotaAcc = '<td><input id="totalMontoCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colTotalMontoCuotaAcc).insertBefore("#tdTotalVacio");
						var ivaTotalAcc = resultado[contadorItera].montoIVAAccesorio;
						var colTotalMontoIVACuotaAcc = '<td><input id="totalMontoIVACuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + ivaTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colTotalMontoIVACuotaAcc).insertBefore("#tdTotalVacio");

						if (resultado[contadorItera].generaInteres == 'S'){
							var interesTotalAcc = resultado[contadorItera].montoInteres;
							var colTotalMontoIntCuotaAcc = '<td><input id="totalMontoIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + interesTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
							$(colTotalMontoIntCuotaAcc).insertBefore("#tdTotalVacio");
							var ivaInteresTotalAcc = resultado[contadorItera].montoIVAInteres;
							var colTotalMontoIvaIntCuotaAcc = '<td><input id="totalMontoIvaIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + ivaInteresTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
							$(colTotalMontoIvaIntCuotaAcc).insertBefore("#tdTotalVacio");
						}
					}

					contadorItera += 1;
				}	
			}
		}
	});
}


//Consulta para ver si se requiere que el cliente tenga registrada su huella Digital
function validaRequiereReferencias() {
	var numEmpresaID = 1;
	var tipoCon = 1;
	var ParametrosSisBean = {
			'empresaID'	:numEmpresaID
	};
	parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
		if (parametrosSisBean != null) {
			if(parametrosSisBean.reqhuellaProductos !=null){
					requiereReferencias = parametrosSisBean.validaRef;


			}else{
				huellaProductos="N";
			}
		}
	});
}

