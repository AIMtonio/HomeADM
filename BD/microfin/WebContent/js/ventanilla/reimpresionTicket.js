$('#tipoOpera').focus();

var Enum_OpcionCaja={
			'retiroEfectivo': 1,
			'abonoCuenta'	: 2,
			'pagoCredito'	: 3,
			'depGarantLiq'	: 4,
			'devGarantLiq'	: 5,
			'comApertCred'	: 6,
			'desembolsoCred': 7,
			'transferCtas'	: 10,
			'cambiarEfect'	: 11,
			'pagoAportSocia': 12,
			'devAportSocia'	: 13,
			'pagoRemesas'	: 16,
			'pagoOportun'	: 17,
			'recepDocSBC'	: 18,
			'aplicDocSBC'	: 19,
			'pagoServicios'	: 21,
			'recupCartCast'	: 22,
			'pagoServifun'	: 25,
			'cobroSegVidAy'	: 14,
			'aplicSegVidAy'	: 15,
			'prepagoCredito': 20,
			'ajusteSobrant'	: 27,
			'ajusteFaltant'	: 28,
			'pagoApoyoEsco'	: 26,
			'cobrCobertRies': 8,
			'pagoCancSocio'	: 30,
			'gastosAnticip'	: 38,
			'devgastosAnti'	: 39,
			'aplicPolCobRi'	: 9,
			'reclHabSocMen'	: 40,
			'transfInterna'	: 41,
			'anualidadTar'	: 29,
			'pagoArrendamiento':42,	//Pago de arrendamiento
			'cobroAccesCre' : 44,
			'depositoActivaCta' : 46
		};
var parametroBean = consultaParametrosSession();
var ticket='T';

$(document).ready(function(){
	
	var tipoCajaSesion=parametroBean.tipoCaja;
	var numeroCaja=parametroBean.cajaID;
	var montoAportaSocio=parametroBean.montoAportacion;	
	$('#tipoOpera').focus();
	
	
	
	esTab = true;	
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$(':text').focus(function(){
		esTab = false;
	});	
	
	$.validator.setDefaults({
		submitHandler: function(event) { 

		}
	});
	
	$('#formaGenerica').validate({
		rules: {
			tipoOpera:{
				required: true
			},
			numTransaccion:{
				required: true
			}
		},messages:{			
			tipoOpera: {
				required: 'Especifique un Tipo de Operación' 
			},
			numTransaccion:{
				required: 'Especifique un Numero de Transacción'
			}
		}
	});
	
	deshabilitaBoton('reimprimir');
	
	consultaOpciones();
	
	$('#numTransaccion').blur(function(){
		var numeroTransaccion=this.value;
		if(numeroTransaccion != '' && esTab){
			if(!isNaN(numeroTransaccion)){
				consultaOperaciones();
			}else{
				$('#gridReimpresion').html('');
				$('#gridReimpresion').hide(250);
				deshabilitaBoton('reimprimir');
			}
		}
	});
	
	$('#numTransaccion').bind('keyup',function(){
		var tipoOperacion = $('#tipoOpera').val();
		var numeroTransaccion = $('#numTransaccion').val();
		
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "numTransaccion"; 
		parametrosLista[0] = $('#numTransaccion').val();
		camposLista[1] = 'tipoOpera';
		parametrosLista[1] = $('#tipoOpera').val();
		
		if(tipoOperacion != '' && numeroTransaccion!=''){		
			lista('numTransaccion', '2', '1',camposLista, parametrosLista, 'reimpresionTicketLista.htm');
		}
	});
	
	$('#tipoOpera').change(function(){
		limpiarPantalla();
	});

	
	function consultaOpciones(){
		var tipoListaReimpresion = 3;
		var opcionesCaja = {
				'tipoCaja'	:tipoCajaSesion,
		};
		
		dwr.util.removeAllOptions('tipoOpera');
		dwr.util.addOptions('tipoOpera',{'':'SELECCIONAR'});
		if(numeroCaja != '' && !isNaN(numeroCaja)){
			opcionesPorCajaServicio.listaCombo(tipoListaReimpresion,opcionesCaja, function(opciones){
				if(opciones != null){					
			  		dwr.util.removeAllOptions('tipoOpera'); 
			  		dwr.util.addOptions('tipoOpera', {'':'SELECCIONAR'});	  			  		
					dwr.util.addOptions('tipoOpera', opciones, 'opcionCajaID', 'descripcion');  
					// si no necesita aportacion Social entonces no mostramos esas opciones en el combo de operaciones
					if(montoAportaSocio <= '0.0'){	
						$('#tipoOperacion').find('option[value=12]').remove(); 
						$('#tipoOperacion').find('option[value=13]').remove(); 
					}
				}else{					
					deshabilitaBoton('reimprimir', 'submit');
				}
			});
		}else{
			mensajeSis('El Usuario No tiene una Caja Asignada.');
		}
	}
	
	function limpiarPantalla(){
		$('#gridReimpresion').html('');
		$('#gridReimpresion').hide(500);
		$('#numTransaccion').val('');
		deshabilitaBoton('reimprimir');
	}
	
	function consultaOperaciones(){		
		$('#gridReimpresion').html('');
		var params = {};
		params['tipoConsulta']=2;
		params['numTransaccion']=$('#numTransaccion').val();
		params['tipoOpera']=$('#tipoOpera').val();
		$.post("gridReimpresionTicket.htm", params,function(data){
			if(data.length>0){
				$('#gridReimpresion').html(data);
				$('#gridReimpresion').show(500);
				habilitaBoton('reimprimir');
				verificaDatos();					
				agregarFormatoMoneda();							
			}
		});		
	}
	
	$('#reimprimir').click(function(){
		reimpresionTicket();
	});
	
	/* ESTA LINEA SIEMPRE DEBE DE ESTAR AL FINAL DEL DOCUMENT*/
	if(parametroBean.tipoImpTicket == ticket){
		findPrinter();
	}
	
});

function verificaDatos(){
	var jqTransaccionID = eval("'#transaccionID1'");
	if(!$(jqTransaccionID).length){
		deshabilitaBoton('reimprimir');
	}
}

function agregarFormatoMoneda(){
	$('input[name=transaccionID]').each(function(){
		var ID = this.id.substring(13);
		
		var jqMonto = eval("'#montoOperacion"+ID+"'");
		var jqEfectivo = eval("'#efectivo"+ID+"'");
		var jqCambio = eval("'#cambio"+ID+"'");
		
		$(jqMonto).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqEfectivo).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2	});
		$(jqCambio).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2	});
	});
};

function reimpresionTicket(){	
	var contador=0, creditos=1, operacion=0;
	$('input[name=transaccionID]').each( function(){
		contador++;
		operacion=0;	
		var ID = this.id.substring(13);
		var jqOpcionCaja = eval("'#opcionCajaID"+ID+"'");
		var valorOpcion = $(jqOpcionCaja).val();
		var jqCambio = eval("'#cambio"+ID+"'");
		var jqEfectivo = eval("'#efectivo"+ID+"'");
		var jqNombrePersona = eval("'#nombrePersona"+ID+"'");
		var jqTransaccionID = eval("'#transaccionID"+ID+"'");
		var jqFecha 		= eval("'#fecha"+ID+"'");
		var jqDescripcion =eval("'#descripcion"+ID+"'");
		var jqMontoOpe =eval("'#montoOperacion"+ID+"'");
		var jqNombreBenefi = eval("'#nombreBenefi"+ID+"'");
		var jqclienteID =eval("'#clienteID"+ID+"'");
		var jqProspectoID =eval("'#prospectoID"+ID+"'");
		var jqEmpleadoID =eval("'#empleadoID"+ID+"'");
		var jqNombreEmpleado =eval("'#nombreEmpleado"+ID+"'");
		var jqCuentaIDRetiro =eval("'#cuentaIDRetiro"+ID+"'");
		var jqCuentaIDDeposito =eval("'#cuentaIDDeposito"+ID+"'");
		var jqEtiquetaCtaRetiro = eval("'#etiquetaCtaRetiro"+ID+"'");
		var jqEtiquetaCtaDepo = eval("'#etiquetaCtaDepo"+ID+"'");
		var jqDesTipoCuenta =eval("'#desTipoCuenta"+ID+"'");
		var jqDesTipoCtaDepo = eval("'#desTipoCtaDepo"+ID+"'");
		var jqSaldoActualCta =eval("'#saldoActualCta"+ID+"'");
		var jqReferencia =eval("'#referencia"+ID+"'");
		var jqFormaPagoCobro =eval("'#formaPagoCobro"+ID+"'");
		var jqCreditoID =eval("'#creditoID"+ID+"'");
		var jqProducCreditoID =eval("'#producCreditoID"+ID+"'");
		var jqNombreProdCred = eval("'#nombreProdCred"+ID+"'");
		var jqMontoCredito	= eval("'#montoCredito"+ID+"'");
		var jqMontoPorDesem = eval("'#montoPorDesem"+ID+"'");
		var jqMontoDesemb 	= eval("'#montoDesemb"+ID+"'");
		var jqGrupoID =eval("'#grupoID"+ID+"'");
		var jqNombreGrupo = eval("'#nombreGrupo"+ID+"'");		
		var jqCicloActual =eval("'#cicloActual"+ID+"'");
		var jqComision = eval("'#comision"+ID+"'");
		var jqIVA =eval("'#iVA"+ID+"'");
		var jqGarantiaAdicional =eval("'#garantiaAdicional"+ID+"'");
		var jqInstitucionID =eval("'#institucionID"+ID+"'");
		var jqNumCtaInstit =eval("'#numCtaInstit"+ID+"'");
		var jqNumCheque =eval("'#numCheque"+ID+"'");
		var jqNombreInstit = eval("'#nombreInstit"+ID+"'");
		var jqPolizaID =eval("'#polizaID"+ID+"'");
		var jqTelefono =eval("'#telefono"+ID+"'");
		var jqIdentificacion =eval("'#identificacion"+ID+"'");
		var jqFolioIdentificacion =eval("'#folioIdentificacion"+ID+"'");
		var jqNombreCatalServ 	= eval("'#nombreCatalServ"+ID+"'");
		var jqMontoServicio 	= eval("'#montoServicio"+ID+"'");
		var jqIVAServicio 		=	eval("'#iVAServicio"+ID+"'");
		var jqOrigenServicio	=	eval("'#origenServicio"+ID+"'");
		var jqMontoComision		= 	eval("'#montoComision"+ID+"'");
		var jqTotalCastigado 	=	eval("'#totalCastigado"+ID+"'");
		var jqTotalRecuperado 	=	eval("'#totalRecuperado"+ID+"'");
		var jqMonto_PorRecuperar=	eval("'#monto_PorRecuperar"+ID+"'");
		var jqTipoServServifun  = 	eval("'#tipoServServifun"+ID+"'");
		var jqcobraSeguroCuota	=	eval("'#cobraSeguroCuota"+ID+"'");
		var jqmontoSeguroCuota	=	eval("'#montoSeguroCuota"+ID+"'");
		var jqiVASeguroCuota	=	eval("'#iVASeguroCuota"+ID+"'");
		/*variables de arrendamiento*/
		var jqArrendaID =eval("'#arrendaID"+ID+"'");
		var jqProducArrendaID = eval("'#prodArrendaID"+ID+"'");
		var jqNombreProdArrenda = eval("'#nomProdArrendaID"+ID+"'");
		var jqSegVida		= eval("'#seguroVida"+ID+"'");
		var jqSeguro 		=eval("'#seguro"+ID+"'");
		var jqIVASegVida	=eval("'#iVASeguroVida"+ID+"'");
		var jqIVASeg 		=eval("'#iVASeguro"+ID+"'");
		var jqIVACapital 	= eval("'#iVACapital"+ID+"'");
		var jqIVAinteres	= eval("'#iVAInteres"+ID+"'");
		var jqIVAmora 		=eval("'#iVAMora"+ID+"'");
		var jqIVAOtrasComi 	= eval("'#iVAOtrasComi"+ID+"'");
		var jqIVAFaltPag	= eval("'#iVAComFaltaPag"+ID+"'");
		var jqComisionAdmon	= eval("'#comisionAdmon"+ID+"'");
		var jqComision		= eval("'#comision"+ID+"'");
		var jqMoratorios	= eval("'#moratorios"+ID+"'");
		var jqInteres   	= eval("'#interes"+ID+"'");
		var jqCapital   	= eval("'#capital"+ID+"'");
		var jqAccesorioID 	= eval("'#accesorioID"+ID+"'");
		
		
		$(jqMontoOpe).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqEfectivo).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqCambio).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqSaldoActualCta).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqComision).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqIVA).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqGarantiaAdicional).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqMontoServicio).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqIVAServicio).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqMontoComision).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqTotalCastigado).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
		$(jqMonto_PorRecuperar).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
/**********************************************************************************************************************************/		
		switch(parseFloat(valorOpcion)){
			case Enum_OpcionCaja.retiroEfectivo:
					reimprimeTickets(1, $(jqTransaccionID).val(), 1);
				break;
			case Enum_OpcionCaja.abonoCuenta:
					reimprimeTickets(2, $(jqTransaccionID).val(), 1);
				break;

			case Enum_OpcionCaja.pagoCredito:
				
				var conGarantia;				
				$(jqGarantiaAdicional).asNumber()>0?conGarantia = 'S' : conGarantia = 'N';
				var tipoConsulta=1;
				var numCliente=$(jqclienteID).val();
				var RFCCliente='';
				var consultaC=10;
				var CuotasP='';
				var TotalC='';

				var beanDetalle = {
						'creditoID':$(jqCreditoID).val(),
						'fechaPago':$(jqFecha).val(),
						'transaccion':$(jqTransaccionID).val()

				};

				var creditoBeanCon = { 
						'creditoID':$(jqCreditoID).val()
					};

			        clienteServicio.consulta(tipoConsulta,numCliente,
			        		{ async: false, callback:function(detalleRFC){
								if(detalleRFC != null){
								   RFCCliente= detalleRFC.RFC;
								}
			        		}});
			        
					amortizacionCreditoServicio.consulta(consultaC,creditoBeanCon,			        		
							{ async: false, callback:function(numCuotas){
						if(numCuotas != null){
							CuotasP= numCuotas.cuotasPagadas;
							TotalC= numCuotas.totalCuotas;
							}
		        		}});
				creditosServicio.consultaDetallePago(tipoConsulta,beanDetalle,{ async: false, callback: function(detallePago){
					if(detallePago != null){
						var impresionPagoCredito={							  
								   'folio' 	        	: $(jqTransaccionID).val(),
							   	   'clienteID' 			: $(jqclienteID).val(),
								   'creditoID' 			: $(jqCreditoID).val(),
								   'nombreCliente'     	: $(jqNombrePersona).val(),
								   'montoPago'         	: detallePago.montoTotal,
								   'proxFechaPago'     	: detallePago.proximaFechaPago,
								   'montoProximoPago'  	: detallePago.montoPagado,
								   'moneda' 			: parametroBean.desCortaMonedaBase,
								   'grupo'  			: $(jqNombreGrupo).val(),
								   'ciclo'  			: $(jqCicloActual).val(),
								   'capital'			: detallePago.capital,
								   'interes' 			: detallePago.interes,
								   'moratorios'			: detallePago.montoIntMora,
								   'comision'  			: detallePago.montoComision,
								   'comisionAdmon'		: detallePago.montoGastoAdmon,
								   'iva'  				: detallePago.montoIVA,
								   'total' 		 		: $(jqMontoOpe).val(),
								   'montoRecibido'	  	: $(jqEfectivo).val() ,
								   'cambio' 		 	: $(jqCambio).val(),									   									  
								   'cuentaID'			: $(jqCuentaIDRetiro).val(),			    
								   'montoGarantia'     	: $(jqGarantiaAdicional).val(),			
								   'totalAdeudoPend'   	: detallePago.totalDeudaPend,
								   'capVigente'			: suma($(jqSaldoActualCta).val(), detallePago.capital),
								   'capVigenteAct'		: $(jqSaldoActualCta).val(),
								    'rfc'               : RFCCliente, 
								    'producto'          : $(jqNombreProdCred).val(),
								    'totalcuotas'       : TotalC,
								    'cuotasPaga'        : CuotasP,
								    'direccionInstitucion'	: parametroBean.direccionInstitucion,
							        'rfcInstitucion'		: parametroBean.rfcRepresentante,
							        'telefonosucursal'		: parametroBean.telefonoLocal,
							        'nombreInstitucion'		: parametroBean.nombreInstitucion,
							        'tipoTransaccion'		: 3 ,//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
							        'cobraSeguroCuota'	:$(jqcobraSeguroCuota).val(),
								    'montoSeguroCuota'	:detallePago.montoSeguroCuota,
								    'ivaSeguroCuota'	:detallePago.iVASeguroCuota,
								    'saldoComAnual'	:detallePago.saldoComAnual,
								    'producto'           : $(jqNombreProdCred).val(),

							};					
						reimprimeTicketPagoCreditoReimp(impresionPagoCredito,contador,conGarantia);	
					}else{
						var impresionPagoCredito={							  
								   'folio' 	        	: $(jqTransaccionID).val(),
							   	   'clienteID' 			: $(jqclienteID).val(),
								   'creditoID' 			: $(jqCreditoID).val(),
								   'nombreCliente'     	: $(jqNombrePersona).val(),
								   'montoPago'         	: '0.00',
								   'proxFechaPago'     	: '',
								   'montoProximoPago'  	: '0.00',
								   'moneda' 			: parametroBean.desCortaMonedaBase,
								   'grupo'  			: $(jqNombreGrupo).val(),
								   'ciclo'  			: $(jqCicloActual).val(),
								   'capital'			: '0.00',
								   'interes' 			: '0.00',
								   'moratorios'			: '0.00',
								   'comision'  			: '0.00',
								   'comisionAdmon'		: '0.00',
								   'iva'  				: '0.00',
								   'total' 		 		: $(jqMontoOpe).val(),
								   'montoRecibido'	  	: $(jqEfectivo).val() ,
								   'cambio' 		 	: $(jqCambio).val(),									   									  
								   'cuentaID'			: $(jqCuentaIDRetiro).val(),			    
								   'montoGarantia'     	: $(jqGarantiaAdicional).val(),			
								   'totalAdeudoPend'   	: '0.00',
								   'capVigente'			: '0.00',
								   'capVigenteAct'		: '0.00',
								   'rfc'                : RFCCliente, 
								   'producto'           : $(jqNombreProdCred).val(),
								   'totalcuotas'        : TotalC,
							        'cuotasPaga'        : CuotasP,
								    'direccionInstitucion'	: parametroBean.direccionInstitucion,
							        'rfcInstitucion'		: parametroBean.rfcRepresentante,
							        'telefonosucursal'		: parametroBean.telefonoLocal,
							        'nombreInstitucion'		: parametroBean.nombreInstitucion,
							        'tipoTransaccion'		: 3, //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
							        'cobraSeguroCuota'	:$(jqcobraSeguroCuota).val(),
								    'montoSeguroCuota'	:$(jqmontoSeguroCuota).val(),
								    'ivaSeguroCuota'	:$(jqiVASeguroCuota).val(),
								    'saldoComAnual'		:'0.00'

							};
							reimprimeTicketPagoCreditoReimp(impresionPagoCredito,contador,conGarantia);	
					}
				}
				});											
				operacion=1;
				break;
			case Enum_OpcionCaja.depGarantLiq:  //OK
					var formaPago='';
					if($(jqFormaPagoCobro).val()=='R'){
						formaPago= 'Efectivo';
					}else if($(jqFormaPagoCobro).val()=='D'){
						formaPago= 'Cargo a Cuenta' ;				
					}
	
				    var impresionGarantiaLiqBean={
			         'folio' 	        :$(jqTransaccionID).val(),
				     'clienteID' 		:$(jqclienteID).val(),
				     'nombreCliente'    :$(jqNombrePersona).val(),
			         'noCuenta'        	:$(jqCuentaIDRetiro).val(),
				     'grupo'         	:$(jqGrupoID).val(),
			         'ciclo'           	:$(jqCicloActual).val(),
				     'noCredito'        :$(jqCreditoID).val(),
				     'montDep'          :$(jqMontoOpe).val(),
			         'montRec'          :$(jqEfectivo).val(),
				     'cambio'           :$(jqCambio).val(), 
			         'moneda'           :parametroBean.desCortaMonedaBase,
			         'formaPago'		:formaPago,
			         'direccionInstitucion'	: parametroBean.direccionInstitucion,
			        'rfcInstitucion'		: parametroBean.rfcRepresentante,
			        'telefonosucursal'		: parametroBean.telefonoLocal,
			        'nombreInstitucion'		: parametroBean.nombreInstitucion,
			        'tipoTransaccion'		: 4, //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
			        'proCred'		        :$(jqNombreProdCred).val() 
				    };
				    reimprimeTicketdepGarantLiq(impresionGarantiaLiqBean);               
				break;
			case Enum_OpcionCaja.devGarantLiq: //OK este ticket no tiene formato carta
					var impresionDevolucionGL={
					    'folio' 	        :$(jqTransaccionID).val(),				        
					    'clienteID' 	    :$(jqclienteID).val(),
					    'nombreCliente'     :$(jqNombrePersona).val(),
				        'noCuenta'          :$(jqCuentaIDRetiro).val(),
				        'tipoCuenta'        :$(jqDesTipoCuenta).val(),
					    'creditoID'        	:$(jqCreditoID).val(),
				        'moneda'            :parametroBean.desCortaMonedaBase,
				        'monto'		        :$(jqMontoOpe).val(),
					    'grupo'             :$(jqGrupoID).val(),
				        'ciclo'          	:$(jqCicloActual).val(),	
				        'proCred'		        :$(jqNombreProdCred).val() 
	   	       
					};
			       reimprimeTicketDevGL(impresionDevolucionGL);	
				break;
			case Enum_OpcionCaja.comApertCred:
					var impresionComisionAperturaBean={
			         	'folio'	        	:$(jqTransaccionID).val(),
	                 	'clienteID' 		:$(jqclienteID).val(),
	                 	'nombreCliente'    	:$(jqNombrePersona).val(),
	                 	'noCuenta'         	:$(jqCuentaIDRetiro).val(),
	                 	'desCuenta'        	:$(jqDesTipoCuenta).val(),
	                 	'proCred'          	:$(jqNombreProdCred).val(),
	                 	'grupo'            	:$(jqNombreGrupo).val(),
	                 	'comision'         	:$(jqComision).val(),	                 
	                 	'iva'              	:$(jqIVA).val(),  
	                 	'total'            	:$(jqMontoOpe).val(),
	                 	'montoReci'        	:$(jqEfectivo).val(),	               
	                	'cambio'           	:$(jqCambio).val(),                
	                 	'NoCredito'        	:$(jqCreditoID).val(),
	                 	'montPago'          :$(jqMontoOpe).val(),
	                 	'moneda'            :parametroBean.desCortaMonedaBase,
	                 	'ciclo'             :$(jqCicloActual).val(),									
				  	};                   
				 	imprimeTicketComisionApertura(impresionComisionAperturaBean);
				
				break;
			case Enum_OpcionCaja.desembolsoCred: //OK
					var impresionDesemCreditoBean={
					    'folio' 	        : $(jqTransaccionID).val(),				        
					    'clienteID' 	    : $(jqclienteID).val(),
					    'nombreCliente'     : $(jqNombrePersona).val(),
				        'noCuenta'          : $(jqCuentaIDRetiro).val(),
				        'tipoCuenta'        : $(jqDesTipoCuenta).val(),
					    'credito'        	: $(jqCreditoID).val(),
				        'moneda'            : parametroBean.desCortaMonedaBase,
					    'grupo'             : $(jqNombreGrupo).val(),
				        'montoCred'         : cantidadFormatoMoneda($(jqMontoCredito).val()),
				        'monRecAnt'  	    : cantidadFormatoMoneda($(jqMontoDesemb).val()),			 
				        'montRet'        	: $(jqMontoOpe).val(),
				        'montoPend'      	: ($(jqMontoPorDesem).asNumber()-$(jqMontoOpe).asNumber()),
				        'ciclo'          	: $(jqCicloActual).val(),	
				        'saldoIniAho'		:cantidadFormatoMoneda($(jqSaldoActualCta).asNumber() + $(jqMontoOpe).asNumber()),
				        'saldoActAho'		:$(jqSaldoActualCta).asNumber(),
				        'direccionInstitucion'	: parametroBean.direccionInstitucion,
				        'rfcInstitucion'		: parametroBean.rfcRepresentante,
				        'telefonosucursal'		: parametroBean.telefonoLocal,
				        'nombreInstitucion'		: parametroBean.nombreInstitucion,
				        'tipoTransaccion'		: 7, //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
				        'proCred'		        :$(jqNombreProdCred).val() 
					};

					reimprimeTicketdesembolsoCred(impresionDesemCreditoBean);
				break;
			case Enum_OpcionCaja.cobrCobertRies: //OK
					var impresionCobroSegVidaBean={
						'folio' 	        	: $(jqTransaccionID).val(),
						'clienteID' 			: $(jqclienteID).val(),
						'nombreCliente'     	: $(jqNombrePersona).val(),
						'efectivo'          	: $(jqMontoOpe).val(),
						'moneda'            	: parametroBean.desCortaMonedaBase,
						'creditoID'        		: $(jqCreditoID).val(),
						'direccionInstitucion'	: parametroBean.direccionInstitucion,
						'rfcInstitucion'		: parametroBean.rfcRepresentante,
						'telefonosucursal'		: parametroBean.telefonoLocal,
						'nombreInstitucion'		: parametroBean.nombreInstitucion,
						'tipoTransaccion'		: 8 //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};
					reimprimeTicketcobrCobertRies(impresionCobroSegVidaBean);
				break;
			case Enum_OpcionCaja.transferCtas:
			case Enum_OpcionCaja.transfInterna:
					var impresionTransfCuenta={
					    'folio' 	        : $(jqTransaccionID).val(),
				        'clienteID' 		: $(jqclienteID).val(),
				        'nomCliente' 		: $(jqNombrePersona).val(),
				        'referencia' 		: $(jqReferencia).val(),
				        'cuentaRetiro' 		: $(jqCuentaIDRetiro).val(),
				        'etiquetaCtaRet' 	: $(jqEtiquetaCtaRetiro).val(),
				        'tipoCtaRetiro' 	: $(jqDesTipoCuenta).val(),
				        'cuentaDeposito' 	: $(jqCuentaIDDeposito).val(),
					    'etiquetaCtaDep' 	: $(jqEtiquetaCtaDepo).val(),	
					    'tipoCtaAbono' 	   	: $(jqDesTipoCtaDepo).val(),				    			        
					    'monto' 	    	: $(jqMontoOpe).val(),						    
					};
			       reimprimeTicketTransferencia(impresionTransfCuenta);	
				break;
			case Enum_OpcionCaja.cambiarEfect:
					var impresionCambioEfectivo={
				    	'folio' 	        :$(jqTransaccionID).val(),
				    	'monto' 	    	:$(jqMontoOpe).val(),
					};
			       imprimeTicketCambioEfectivo(impresionCambioEfectivo);			
				
				break;
			case Enum_OpcionCaja.pagoAportSocia:
					var impresionAportaSocioBean={
					    'folio' 	        : $(jqTransaccionID).val(),
					    'clienteID' 		: $(jqclienteID).val(),
					    'nombreCliente'     : $(jqNombrePersona).val(),
				        'montoAportacion'   : $(jqMontoOpe).val(),
					    'moneda'            : parametroBean.desCortaMonedaBase,
				        'montoRec'          : $(jqEfectivo).val(),
				        'cambio'            : $(jqCambio).val(),
				        'nombreInstitucion'	: parametroBean.nombreInstitucion,
				        'tipoTransaccion'	: 11 //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};
					reimprimeTicketpagoAportSocia(impresionAportaSocioBean);
				break;
			case Enum_OpcionCaja.devAportSocia: 
					var impresionDevAportaSocioBean={
					    'folio' 	        : $(jqTransaccionID).val(),
					    'clienteID' 		: $(jqclienteID).val(),
					    'nombreCliente'     : $(jqNombrePersona).val(),
				        'montoDevolucion'   : $(jqMontoOpe).val(),
					    'moneda'            : parametroBean.desCortaMonedaBase,
				        'montoRec'          : $(jqEfectivo).val(),
				        'cambio'            : $(jqCambio).val(), 
				        'nombreInstitucion'	: parametroBean.nombreInstitucion,
				        'tipoTransaccion'	: 12 //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};	
					reimprimeTicketdevAportSocia(impresionDevAportaSocioBean);					
				break;
			case Enum_OpcionCaja.pagoRemesas:
					var titulo= "PAGO DE REMESAS";
					var formaPago='';		
					if($(jqFormaPagoCobro).val()=='R'){
						formaPago= 'Efectivo' ;		
					}else if($(jqFormaPagoCobro).val() == 'D'){
						formaPago= 'Deposito a Cuenta' ;	
					}else if($(jqFormaPagoCobro).val() == 'C'){
						formaPago= 'Cheque' ;	
					}
				
			      var impresionPagoRemesaBean={
			   	    'folio' 	        	: $(jqTransaccionID).val(), 			      
				    'clienteID' 			: $(jqclienteID).val(),
				    'nombreCliente'    	 	: $(jqNombrePersona).val(),
				    'telefonoCliente'   	: $(jqTelefono).val(),
				    'tituloOperacion'		: titulo,
				    'tipoIdentificacion'   	: $(jqIdentificacion).val(),				    
				    'folioIdentificacion'   : $(jqFolioIdentificacion).val(), 
				    'formaPago'   			: formaPago,
				    'numeroCuenta'   		: $(jqFolioIdentificacion).val(), 
				    'referencia'		 	: $(jqReferencia).val(),
				    'monto'		 			: $(jqMontoOpe).val(),
			        'moneda'           		: parametroBean.desCortaMonedaBase,
			        'direccionInstitucion'	: parametroBean.direccionInstitucion,
			        'rfcInstitucion'		: parametroBean.rfcRepresentante,
			        'telefonosucursal'		: parametroBean.telefonoLocal,
			        'nombreInstitucion'		: parametroBean.nombreInstitucion,
			        'tipoTransaccion'		: 15 //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};
			      reimprimeTicketpagoRemesas(impresionPagoRemesaBean);
				
				break;
			case Enum_OpcionCaja.pagoOportun:
					var titulo ="PAGO DE OPORTUNIDADES";
					var formaPago='';		
					if($(jqFormaPagoCobro).val() == 'R'){
						formaPago= 'Efectivo';
					}else if($(jqFormaPagoCobro).val() == 'D'){
						formaPago= 'Deposito a Cuenta';	
					}else if($(jqFormaPagoCobro).val() == 'C'){
						formaPago= 'Cheque';
					}				
				      var impresionPagooportunidadesBean={
				   	    'folio' 	        	: $(jqTransaccionID).val(),				        
					    'clienteID' 			: $(jqclienteID).val(),
					    'nombreCliente'    	 	: $(jqNombrePersona).val(),
					    'telefonoCliente'   	: $(jqTelefono).val(),
					    'tituloOperacion'		: titulo,
					    'tipoIdentificacion'   	: $(jqIdentificacion).val(),				    
					    'folioIdentificacion'   : $(jqFolioIdentificacion).val(), 
					    'formaPago'   			: formaPago,
					    'numeroCuenta'   		: $(jqCuentaIDRetiro).val(), 
					    'referencia'		 	: $(jqReferencia).val(),
					    'monto'		 			: $(jqMontoOpe).val(),
				        'moneda'           		: parametroBean.desCortaMonedaBase,
				        'direccionInstitucion'	: parametroBean.direccionInstitucion,
				        'rfcInstitucion'		: parametroBean.rfcRepresentante,
				        'telefonosucursal'		: parametroBean.telefonoLocal,
				        'nombreInstitucion'		: parametroBean.nombreInstitucion,
				        'tipoTransaccion'		: 16//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};
				   reimprimeTicketpagoOportun(impresionPagooportunidadesBean);
				break;
			case Enum_OpcionCaja.recepDocSBC:
				  var tituloOperacion = 'RECEPCION DE CHEQUE SBC';
				  if ($(jqFormaPagoCobro).val() == 'R' || $(jqFormaPagoCobro).val() == 'D'){
					  tituloOperacion = 'CAMBIO DE CHEQUE INTERNO';
				  }

			      var impresionRecepChequeSBCBean={
			   	    'folio' 	        	: $(jqTransaccionID).val(),
			        'tituloOperacion'  		: tituloOperacion,
				    'clienteID' 			: $(jqclienteID).val(),
				    'nombreCliente'    	 	: $(jqNombrePersona).val(),
				    'numeroCuenta'   		: $(jqCuentaIDDeposito).val(), 
				    'formaCobro'   			: 'CHEQUE SBC',			
				    'cuentaEmisor'   		: $(jqNumCtaInstit).val(),				    
				    'numCheque'   			: $(jqNumCheque).val(),				    
				    'monto'		 			: $(jqMontoOpe).val(),
			        'moneda'           		: parametroBean.desCortaMonedaBase,		
			        'numBanco'				: $(jqInstitucionID).val(),
					'nombreBanco'			: $(jqNombreInstit).val(),
					'direccionInstitucion'	: parametroBean.direccionInstitucion,
			        'rfcInstitucion'		: parametroBean.rfcRepresentante,
			        'telefonosucursal'		: parametroBean.telefonoLocal,
			        'nombreInstitucion'		: parametroBean.nombreInstitucion,
			        'tipoTransaccion'		: 17//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
				};
			      reimprimeTicketrecepDocSBC(impresionRecepChequeSBCBean);
				break;
			case Enum_OpcionCaja.aplicDocSBC: 
					var impresionAplicaChequeSBCBean={
					 'folio' 	        	: $(jqTransaccionID).val(),
				     'tituloOperacion'  	: 'APLICACION DE CHEQUE SBC',
					 'clienteID' 			: $(jqclienteID).val(),
					 'nombreCliente'    	: $(jqNombrePersona).val(),
					 'numeroCuenta'   		: $(jqCuentaIDRetiro).val(), 
					 'formaCobro'   		: 'CHEQUE SBC',			
					 'cuentaEmisor'   		: $(jqNumCtaInstit).val(),				    
					 'numCheque'   			: $(jqNumCheque).val(),				    
					 'monto'		 		: $(jqMontoOpe).val(),
				     'moneda'           	: parametroBean.desCortaMonedaBase,	
				     'numBanco'				: $(jqInstitucionID).val(),
					 'nombreBanco'			: $(jqNombreInstit).val(),
					 'direccionInstitucion'	: parametroBean.direccionInstitucion,
			         'rfcInstitucion'		: parametroBean.rfcRepresentante,
			         'telefonosucursal'		: parametroBean.telefonoLocal,
			         'nombreInstitucion'	: parametroBean.nombreInstitucion,
			         'tipoTransaccion'		: 18//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};
					reimprimeTicketaplicDocSBC(impresionAplicaChequeSBCBean);
				break;
			case Enum_OpcionCaja.pagoServicios: 
				      var impresionPagoServicioBean={
						  	'folio' 	        	:$(jqTransaccionID).val(),
					        'tituloOperacion'  		:('PAGO '+$(jqNombreCatalServ).val()),
						    'clienteID' 			:$(jqclienteID).val(),
						    'nombreCliente'    	 	:$(jqNombrePersona).val(),
						    'prospectoID' 			:$(jqProspectoID).val(),
						    'creditoID'				:$(jqCreditoID).val(), 	
						    
						    'montoComision'   		:$(jqMontoComision).val(), 
						    'IVAComision'   		:$(jqIVA).val(),
						    'montoPagoServicio'   	:$(jqMontoServicio).val(), 
						    'IvaServicio'   		:$(jqIVAServicio).val(), 					    
						    'totalPagar'			:$(jqMontoOpe).val(), 		
						    
						    'formaPago'   			:'Efectivo',								   
					        'moneda'           		:parametroBean.desCortaMonedaBase,
					        'montoRecibido'			:$(jqEfectivo).val(),
					        'cambio'				:$(jqCambio).val(),
					        'origenServicio'		:$(jqOrigenServicio).val(),
					        'cobroComServicio'		:'',
					        'requiereCteServicio'	:'',
					        'requiereCredServicio'	:'',
					        'referencia'			:$(jqReferencia).val()
					};
				      imprimeTicketCobroServicio(impresionPagoServicioBean);				
				break;
			case Enum_OpcionCaja.recupCartCast:				
				    var impresionCreditoCastigadoBean={
						'folio' 	        	:$(jqTransaccionID).val(),					  
						'clienteID' 			:$(jqclienteID).val(),
						'nombreCliente'    	 	:$(jqNombrePersona).val(),
						'creditoID'				:$(jqCreditoID).val(), 						    
						'productoCred'   		:$(jqProducCreditoID).val(), 
						'descProduc'   			:$(jqNombreProdCred).val(),					    
						'totalCastigado'   		:$(jqTotalCastigado).val(), 					    					    
						'monRecuperado'   		:$(jqTotalRecuperado).val(), 					    								   
					    'moneda'           		:parametroBean.desCortaMonedaBase,
					    'totalPagar'			:$(jqMontoOpe).val(),
					    'montoRecibido'			:$(jqEfectivo).val(),
					    'cambio'				:$(jqCambio).val(),
					    'montoPorRecuperar'		:$(jqMonto_PorRecuperar).val(),
						'direccionInstitucion'	: parametroBean.direccionInstitucion,
				        'rfcInstitucion'		: parametroBean.rfcRepresentante,
				        'telefonosucursal'		: parametroBean.telefonoLocal,
				        'nombreInstitucion'		: parametroBean.nombreInstitucion,
				        'tipoTransaccion'		: 19//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};
				    reimprimeTicketrecupCartCast(impresionCreditoCastigadoBean);
				break;
			case Enum_OpcionCaja.pagoServifun: 
					var imprimeTicketProteccionBean ={
						'folio' 	       	 : $(jqTransaccionID).val(),
						'clienteID'          : $(jqclienteID).val(),						  
						'beneficiario'     	 : $(jqNombrePersona).val(),	
						'numCteBeneficiario' : $(jqNombrePersona).val(),
					    'nombreRecibe'       : $(jqNombrePersona).val(),
		                'totalBeneficioNum'  : $(jqMontoOpe).asNumber(),
		                'totalBeneficio'     : $(jqMontoOpe).val(),						   
						'tipoServicio'		 : $(jqTipoServServifun).val(),
						'numCta'			 : $(jqCuentaIDRetiro).val(),
						'tipoIdentificacion' : $(jqIdentificacion).val(),
						'folioIdentificacion': $(jqFolioIdentificacion).val(),
						'direccionInstitucion'	: parametroBean.direccionInstitucion,
				        'rfcInstitucion'		: parametroBean.rfcRepresentante,
				        'telefonosucursal'		: parametroBean.telefonoLocal,
				        'nombreInstitucion'		: parametroBean.nombreInstitucion,
				        'tipoTransaccion'		: 14//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operacione
					};					
					reimprimeTicketpagoServifun(imprimeTicketProteccionBean);	
				break;
			case Enum_OpcionCaja.cobroSegVidAy: 
					var impresionCobroSegAyudaBean={
				   	    'folio' 	       		: $(jqTransaccionID).val(),				        
					    'clienteID' 			: $(jqclienteID).val(),
					    'nombreCliente'     	: $(jqNombrePersona).val(),
				        'efectivo'          	: $(jqMontoOpe).val(),
	     				'moneda'            	: parametroBean.desCortaMonedaBase,
	     				'direccionInstitucion'	: parametroBean.direccionInstitucion,
	     				'rfcInstitucion'		: parametroBean.rfcRepresentante,
	     				'telefonosucursal'		: parametroBean.telefonoLocal,
	     				'nombreInstitucion'		: parametroBean.nombreInstitucion,
	     				'tipoTransaccion'		: 13//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};
					reimprimeTicketcobroSegVidAy(impresionCobroSegAyudaBean);
				break;
			case Enum_OpcionCaja.aplicSegVidAy:
					var impresionAplicaSegAyudaBean={
				   	    'folio' 	        :$(jqTransaccionID).val(),
					    'clienteID' 		:$(jqclienteID).val(),
					    'nombreCliente'     :$(jqNombrePersona).val(),
				        'efectivo'          :$(jqMontoOpe).val(),
				        'poliza'          	:$(jqPolizaID).val(),
				        'moneda'            :parametroBean.desCortaMonedaBase,
	     				'direccionInstitucion'	: parametroBean.direccionInstitucion,
	     				'rfcInstitucion'		: parametroBean.rfcRepresentante,
	     				'telefonosucursal'		: parametroBean.telefonoLocal,
	     				'nombreInstitucion'		: parametroBean.nombreInstitucion,
	     				'tipoTransaccion'		: 14//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};
					reimprimeTicketaplicSegVidAy(impresionAplicaSegAyudaBean);
				break;
			case Enum_OpcionCaja.prepagoCredito:
				var tipoConsulta=1;
				var beanDetalle = {
						'creditoID':$(jqCreditoID).val(),
						'fechaPago':$(jqFecha).val(),
						'transaccion':$(jqTransaccionID).val()

				};	 
				creditosServicio.consultaDetallePago(tipoConsulta,beanDetalle,{ async: false, callback: function(detallePago){
						var tipoCredito='G';
						var impresionPrepagoCredito={							  
							'folio' 	        : $(jqTransaccionID).val(),
							'clienteID' 		: $(jqclienteID).val(),
							'creditoID' 		: $(jqCreditoID).val(),
							'nombreCliente'     : $(jqNombrePersona).val(),
							'montoPago'         : detallePago.montoTotal,
							'proxFechaPago'     : detallePago.proximaFechaPago,
							'montoProximoPago'  : detallePago.montoPagado,
							'moneda' 			: parametroBean.desCortaMonedaBase,
							'grupo'  			: $(jqNombreGrupo).val(),
							'ciclo'  			: $(jqCicloActual).val(),
							'capital'			: detallePago.capital,
							'interes' 			: detallePago.interes,
							'moratorios'		: detallePago.montoIntMora,
							'comision'  		: detallePago.montoComision,
							'comisionAdmon'		: detallePago.montoGastoAdmon,
							'iva'  				: detallePago.montoIVA,
							'total'				: $(jqMontoOpe).val(),
							'montoRecibido'	  	: $(jqEfectivo).val(),
							'cambio' 		 	: $(jqCambio).val(),
							'saldoCapVigenteIni':suma($(jqSaldoActualCta).val(), detallePago.capital),
							'saldoCapVigenteAct':$(jqSaldoActualCta).val(),
							'cobraSeguroCuota'	:$('#cobraSeguroCuota').val(),
						    'montoSeguroCuota'	:detallePago.montoSeguroCuota,
						    'ivaSeguroCuota'	:detallePago.montoIVASeguroCuota,
						    'saldoComAnual'	:detallePago.saldoComAnual,
						    'proCred'		        :$(jqNombreProdCred).val() 
						};			   	
						imprimirTicketPrepagoCredito(impresionPrepagoCredito,contador, tipoCredito);
					}
				});								
				operacion=1;
				break;
			case Enum_OpcionCaja.ajusteSobrant: 
					// Sin Reimpresion de ticket
				break;
			case Enum_OpcionCaja.ajusteFaltant:
				// Sin Reimpresion de ticket
				break;
			case Enum_OpcionCaja.pagoApoyoEsco: //OK
				var imprimeTicketApoyoEscolarBean ={
				    'folio' 	       	:$(jqTransaccionID).val(),			        
				    'clienteID'         :$(jqclienteID).val(),
				    'nombreCliente'     :$(jqNombrePersona).val(),
				    'personaRecibe'     :$(jqNombreBenefi).val(),
				    'monto'				:$(jqMontoOpe).val(),
				    'direccionInstitucion'	: parametroBean.direccionInstitucion,
     				'rfcInstitucion'		: parametroBean.rfcRepresentante,
     				'telefonosucursal'		: parametroBean.telefonoLocal,
     				'nombreInstitucion'		: parametroBean.nombreInstitucion,
     				'tipoTransaccion'		: 21//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
				};					
				reimprimeTicketpagoApoyoEsco(imprimeTicketApoyoEscolarBean);
				break;
			case Enum_OpcionCaja.pagoCancSocio: 
				var imprimeTicketPagoCancelBean ={
					    'folio' 	       	:$(jqTransaccionID).val(),
					    'clienteID'         :$(jqclienteID).val(),						  
					    'beneficiario'     	:$(jqNombrePersona).val(),
				        'nombreRecibe'      :$(jqNombreBenefi).val(),
			            'totalBeneficioNum' :$(jqMontoOpe).asNumber(),
			            'totalBeneficio'    :$(jqMontoOpe).val(),
			            'nombreInstitucion'	: parametroBean.nombreInstitucion,
				        'tipoTransaccion'	: 25 //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};					
				reimprimeTicketpagoCancSocio(imprimeTicketPagoCancelBean);
				break;
			case Enum_OpcionCaja.gastosAnticip: //OK
				var imprimeTicketDevGastoAntBean ={
					    'folio' 	        	:$(jqTransaccionID).val(),
					    'empleadoID'            :$(jqEmpleadoID).val(),						  
					    'nombreEmpleado'    	:$(jqNombreEmpleado).val(),
				        'operacion'      	    :$(jqReferencia).val(),
				        'montoTotal'			:$(jqMontoOpe).val(),
				        'moneda'				:parametroBean.desCortaMonedaBase,
				        'monto'					:$(jqMontoOpe).asNumber(),
				        'nombreInstitucion'	: parametroBean.nombreInstitucion,
				        'tipoTransaccion'	: 26 //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};					
				reimprimeTicketgastosAnticip(imprimeTicketDevGastoAntBean);
				break;
			case Enum_OpcionCaja.devgastosAnti: 	//OK							
					var imprimeTicketGastoAntBean ={
						    'folio' 	        	:$(jqTransaccionID).val(),					        
						    'empleadoID'            :$(jqclienteID).val(),						  
						    'nombreEmpleado'    	:$(jqNombrePersona).val(),
					        'operacion'      	    :$(jqReferencia).val(),
				            'montoTotal'			:$(jqMontoOpe).val(),
				            'moneda'				:parametroBean.desCortaMonedaBase,
				            'monto'					:$(jqMontoOpe).val(),
				            'nombreInstitucion'	: parametroBean.nombreInstitucion,
					        'tipoTransaccion'	: 27 //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
						};					
					reimprimeTicketdevgastosAnti(imprimeTicketGastoAntBean);
				break;
			case Enum_OpcionCaja.aplicPolCobRi: 
					//Sin Reimpresion ticket
				break;
			case Enum_OpcionCaja.reclHabSocMen:
					var imprimeTicketHaberesExMenorBean ={
					    'folio' 	        	:$(jqTransaccionID).val(),			        
					    'menorID'               :$(jqclienteID).val(),						  
					    'nombreMenor'    		:$(jqNombrePersona).val(),
				        'totalHaberes'      	:$(jqMontoOpe).val(),			        						 
			            'moneda'				:parametroBean.simboloMonedaBase,
			            'cuentaAhoID'			:$(jqCuentaIDRetiro).val(),
			            'descripcion'			:$(jqDesTipoCuenta).val(),
			            'monto'					:$(jqMontoOpe).val(),
			            'nombreInstitucion'		:parametroBean.nombreInstitucion,
				        'tipoTransaccion'		: 28 //De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones
					};									
					reimprimeTicketreclHabSocMen(imprimeTicketHaberesExMenorBean);
				break;
			case Enum_OpcionCaja.anualidadTar:		//OK		
				var imprimeTicketAnualidadTarjetaBean ={
					    'folio' 	       		:$(jqTransaccionID).val(),				       
					    'clienteID'         	:$(jqclienteID).val(),
					    'nombreCliente'     	:$(jqNombrePersona).val(),
					    'montoAnualidad'    	:$(jqMontoServicio).val(),
					    
					    'IVAMonto'				:$(jqIVAServicio).val(),
					    'totalComisionTD'		:$(jqMontoOpe).val(),
					    'montoRecibido'			:$(jqEfectivo).val(),
					    'cambio'				:$(jqCambio).val(),
					    'tarjetaDebito'			:$(jqCuentaIDRetiro).val(),
					    'numeroCuenta'			:$(jqCuentaIDDeposito).val(),
					    'direccionInstitucion'	: parametroBean.direccionInstitucion,
				        'rfcInstitucion'		: parametroBean.rfcRepresentante,
				        'telefonosucursal'		: parametroBean.telefonoLocal,
				        'nombreInstitucion'		: parametroBean.nombreInstitucion,
				        'tipoTransaccion'		: 23//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operacione
					};					
				reimprimeTicketAnualidadTarjeta(imprimeTicketAnualidadTarjetaBean);			

				break;
				
			case Enum_OpcionCaja.pagoArrendamiento:
				var tipoConsulta=1;
				var numCliente=$(jqclienteID).val();
				var formaPago='';
				var proxFechaPago='';
				var montoProximoPago='';
				if($(jqFormaPagoCobro).val()=='R'){
					formaPago= 'Efectivo';
				}
				var beanDetallePagArrenda = {
						'arrendaID':$(jqArrendaID).val(),
						'fechaPago':$(jqFecha).val(),
						'transaccion':$(jqTransaccionID).val()
				};
				arrendamientoServicio.consultaDetallePagoArrenda(tipoConsulta,beanDetallePagArrenda,
						{ async: false, callback:	function(detallePago){	
							if(detallePago != null){
								proxFechaPago = detallePago.fechaProxPago;
								montoProximoPago = detallePago.montoProxPago;
								}
							else{
								proxFechaPago = '1900-01-01';
								montoProximoPago = '0.00';								
							}
						}});
				var imprimeTicketPagoArrendamientoBean={	
						'folio' 	        : $(jqTransaccionID).val(),
						'tituloOperacion'   : 'COMPROBANTE DE PAGO DE ARRENDAMIENTO',
						'clienteID' 		: $(jqclienteID).val(),
						'arrendaID' 		: $(jqArrendaID).val(),
						'nombreCliente'     : $(jqNombrePersona).val(), 
						'nombreInstitucion' : parametroBean.nombreInstitucion,
						'sucursal' 	  	    : parametroBean.sucursal,  
						'nomSucursal' 	  	: parametroBean.nombreSucursal,
						'caja' 	  			: parametroBean.cajaID,
						'cajero' 	  		: $(jqNombreEmpleado).val(),
						'producto'			: $(jqProducArrendaID).val(),
						'nombreproducto'	: $(jqNombreProdArrenda).val(),
						'fechaPago'			: $(jqFecha).val(),
						'montoPago'			: $(jqMontoOpe).val(),
						'proxFechaPago'     : proxFechaPago,
						'montoProximoPago'  : montoProximoPago,
						'moneda'			: parametroBean.nombreMonedaBase,  
						'comisionFalPag'	: $(jqComisionAdmon).val(),   
						'ivaComFalPag'		: $(jqIVAFaltPag).val(),   
						'otrascomision'		: $(jqComision).val(),  
						'ivaOtrasCom'		: $(jqIVAOtrasComi).val(),
						'moratorios'		: $(jqMoratorios).val(),
						'ivaMora'			: $(jqIVAmora).val(),
						'montoSeguroInmob'	: $(jqSeguro).val(),
						'ivaSeguroInmob'	: $(jqIVASeg).val(),
						'montoSeguroVida'	: $(jqSegVida).val(),						
						'ivaSeguroVida'		: $(jqIVASegVida).val(),
						'interes' 			: $(jqInteres).val(),
						'ivaInteres'		: $(jqIVAinteres).val(),
						'capital'			: $(jqCapital).val(),
						'ivaCapital'		: $(jqIVACapital).val(),
						'total' 		 	: $(jqMontoOpe).val(),                        
						'cambio'			: $(jqCambio).val(),  
						'montoRecibido' 	: $(jqEfectivo).val(),
						'formaPago'			: formaPago,
						'tipoTransaccion'	: 42//De acuerdo a lo que se tiene en Enum_Rep_Ventanilla del servicio de Ingreso de operaciones			
			    };	
				reimprimeTicketPagoArrenda(imprimeTicketPagoArrendamientoBean);
			break;
			case Enum_OpcionCaja.cobroAccesCre:
				var IVACliente = 'N';
				var IVAAccesorio = 'N';
				var valorIVA = 0.0;
				var sucursalCliente = 0;
				var nomAcces = '';
				var comision = 0.00;
				var IVAComision = 0.00;

				if (!isNaN($(jqclienteID).val())) {
					clienteServicio.consulta(1,$(jqclienteID).val(),{
						async : false,
						callback: function(clienteBeanCon){
							if (clienteBeanCon!=null) {
								sucursalCliente = clienteBeanCon.sucursalOrigen;
								IVACliente = clienteBeanCon.pagaIVA;
							}
						}
					});
				}

				var accesorioBean = {
					'producCreditoID' : $(jqProducCreditoID).val(),
					'accesorioID' : $(jqAccesorioID).val()
				};
				if (!isNaN(accesorioBean.producCreditoID) && !isNaN(accesorioBean.accesorioID)) {
					esquemaOtrosAccesoriosServicio.consulta(1,accesorioBean,{
						async : false,
						callback : function(accesorio){
							if (accesorio!=null) {
								IVAAccesorio = accesorio.cobraIVA;
								nomAcces = accesorio.nombreCorto;
							}
						}
					});
				}

				if (!isNaN(sucursalCliente)) {
					sucursalesServicio.consultaSucursal(1,sucursalCliente,{
						async : false,
						callback : function(sucursal){
							if (sucursal!=null) {
								valorIVA = sucursal.IVA;
							}
						}
					});
				}

				if (IVACliente=='S' && IVAAccesorio=='S') {
					var montoSaldo = $(jqMontoOpe).asNumber();
					comision = (parseFloat(montoSaldo)/(parseFloat(1.0)+parseFloat(valorIVA))).toFixed(2);
					IVAComision = ((parseFloat(montoSaldo)/(parseFloat(1.0)+parseFloat(valorIVA)))*parseFloat(valorIVA)).toFixed(2);
				}else{
					comision = $(jqMontoOpe).val();
					IVAComision = 0.00;
				}

				var impresionAccesorioCreBean = {
					'folio'	        	:$(jqTransaccionID).val(),
					'tituloOperacion'	:'ACCESORIOS DE CREDITO',
					'clienteID' 		:$(jqclienteID).val(),
					'nombreCliente'   	:$(jqNombrePersona).val(),
					'noCuenta'        	:$(jqCuentaIDRetiro).val(),
					'desCuenta'       	:$(jqDesTipoCuenta).val(),
					'proCred'         	:$(jqNombreProdCred).val(),
					'grupo'           	:$(jqNombreGrupo).val(),
					'comision'        	: comision,
					'iva'             	: IVAComision,
					'total'           	:$(jqMontoOpe).val(),
					'montoReci'       	:$(jqEfectivo).val(),
					'cambio'          	:$(jqCambio).val(),
					'NoCredito'       	:$(jqCreditoID).val(),
					'montPago'        	:$(jqMontoOpe).val(),
					'moneda'            :parametroBean.desCortaMonedaBase,
					'nomAccesorio' 		: nomAcces
				};
				reimprimeTicketAccesCredito(impresionAccesorioCreBean);
				break;	
			case Enum_OpcionCaja.depositoActivaCta:				

				var impresionDepositoActivaCtaBean = {
					'folio' 			: $(jqTransaccionID).val(),
					'tituloOperacion' 	: 'DEPÓSITO PARA ACTIVACIÓN DE CTA',
					'clienteID' 		: $(jqclienteID).val(),
					'nombreCliente' 	: $(jqNombrePersona).val(),
					'noCuenta' 			: $(jqCuentaIDDeposito).val(),
					'tipoCuenta' 		: $(jqDesTipoCuenta).val(),
					'refCuenta' 		: $(jqReferencia).val(),
					
					'montoDep' 			: $(jqMontoOpe).val(),
					'moneda' 			: parametroBean.desCortaMonedaBase,
					'montoRec'       	: $(jqEfectivo).val(),
					'cambio'          	: $(jqCambio).val()				
				};
				
				imprimeTicketDepositoActivaCta(impresionDepositoActivaCtaBean);		

				break;
				
		}
	});
	if(operacion==creditos){
		imprimeTicket();
	}
};
