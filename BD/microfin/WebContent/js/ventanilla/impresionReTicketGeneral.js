var Tamanioticket	= 'T';
var TipoImpresion=parametroBean.tipoImpTicket;

/**
 * Pago de crédito
 * @param impresionPagoCredito
 * @param contador
 * @param conGarantia
 */
function reimprimeTicketPagoCreditoReimp(impresionPagoCredito,contador,conGarantia){
	//Se deja por el momento solo la reimpresion por tamaño carta	
	imprimirTicketPagCredGrupal(impresionPagoCredito,contador,conGarantia);	
}
/**
 * Deposito de Garantia liquida
 * @param impresionGarantiaLiqBean
 * @param tipo
 */
function reimprimeTicketdepGarantLiq (impresionGarantiaLiqBean, tipo){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketGarantiaLiq(impresionGarantiaLiqBean);               
	} else {
		window.open('RepTicketVentanillaGarantiaLiq.htm?'+
				'varCreditoID='+impresionGarantiaLiqBean.noCredito+
				'&nombreInstitucion='+impresionGarantiaLiqBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+impresionGarantiaLiqBean.tipoTransaccion+
				'&direccionInstitucion='+impresionGarantiaLiqBean.direccionInstitucion+
				'&rfcInstitucion='+impresionGarantiaLiqBean.rfcInstitucion+
				'&telefonosucursal='+impresionGarantiaLiqBean.telefonosucursal+
				'&numTrans='+impresionGarantiaLiqBean.folio+
				'&grupo='+impresionGarantiaLiqBean.grupo+
				'&ciclo='+impresionGarantiaLiqBean.ciclo, '_blank');
	}
}
/**
 * Devolución de Garantia Liquida - No tiene formato Carta - Si tiene prpt pero no esta lo de java
 * @param impresionDevolucionGL
 * @param tipo
 */
function reimprimeTicketDevGL(impresionDevolucionGL, tipo){
		imprimeTicketDevGL(impresionDevolucionGL);	
}
function imprimeTicketcomApertCred(impresionComisionAperturaBean, tipo){
	//Por el momento solo se deja en formato ticket
	imprimeTicketComisionApertura(impresionComisionAperturaBean);
}
/**
 * Desembolso de crédito
 * @param impresionDesemCreditoBean
 */
function reimprimeTicketdesembolsoCred(impresionDesemCreditoBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketDesemCredito(impresionDesemCreditoBean);
	} else {
		window.open('RepTicketVentanillaDesCred.htm?'+
				'monto='+impresionDesemCreditoBean.montoCred+
				'&nombreInstitucion='+impresionDesemCreditoBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+impresionDesemCreditoBean.tipoTransaccion+
				'&numTrans='+impresionDesemCreditoBean.folio+
				'&varCreditoID='+impresionDesemCreditoBean.credito+
				'&montoCred='+impresionDesemCreditoBean.montoCred+
				'&monPorDes='+impresionDesemCreditoBean.montoPend+
				'&montoDes='+impresionDesemCreditoBean.montoCred+
				'&montoResAnt='+impresionDesemCreditoBean.monRecAnt+
				'&grupo='+impresionDesemCreditoBean.grupo+
				'&ciclo='+impresionDesemCreditoBean.ciclo, '_blank');
	}
}
/**
 * Cobro de cobertura de Riesgo
 * @param impresionCobroSegVidaBean
 * @param tipo
 */
function reimprimeTicketcobrCobertRies(impresionCobroSegVidaBean, tipo){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketCobroSegVida(impresionCobroSegVidaBean);
	} else {
		window.open('TicketVentanillaSegVida.htm?'+
		'creditoID='+impresionCobroSegVidaBean.creditoID+
		'&nombreInstitucion='+impresionCobroSegVidaBean.nombreInstitucion+
		'&numCopias='+1+
		'&tipoTransaccion='+impresionCobroSegVidaBean.tipoTransaccion+
		'&direccionInstitucion='+impresionCobroSegVidaBean.direccionInstitucion+
		'&rfcInstitucion='+impresionCobroSegVidaBean.rfcInstitucion+
		'&telefonosucursal='+impresionCobroSegVidaBean.telefonosucursal+
		'&transaccion='+impresionCobroSegVidaBean.folio,'_blank');
	}
}
/**
 * Transferencia entre cuentas -No tiene formato carta
 * @param impresionTransfCuenta
 * @param tipo
 */
function reimprimeTicketTransferencia(impresionTransfCuenta, tipo){
	imprimeTickettransfInterna(impresionTransfCuenta, tipo);
}
/**
 * Transferencia entre cuentas
 * @param impresionTransfCuenta
 * @param tipo
 */
function imprimeTickettransfInterna(impresionTransfCuenta, tipo){
	imprimeTicketTransferencia(impresionTransfCuenta);	
}
function imprimeTicketcambiarEfect(impresionCambioEfectivo, tipo){
	imprimeTicketCambioEfectivo(impresionCambioEfectivo);			
}
/**
 * Pago de Aportacion social
 * @param impresionAportaSocioBean
 * @param tipo
 */
function reimprimeTicketpagoAportSocia(impresionAportaSocioBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketAportacionSocio(impresionAportaSocioBean);  
	} else {
		window.open('RepTicketAportacionSocio.htm?'+
				'nombreInstitucion='+impresionAportaSocioBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+impresionAportaSocioBean.tipoTransaccion+
				'&numTrans='+impresionAportaSocioBean.folio
				,'_blank');
	}
}
/**
 * Devolucion de la aportacion social del cliente 
 * @param impresionDevAportaSocioBean
 */
function reimprimeTicketdevAportSocia(impresionDevAportaSocioBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketDevAportacionSocioSocio(impresionDevAportaSocioBean);					
	} else {
		window.open('RepTicketDevAportaSocio.htm?'+
				'nombreInstitucion='+impresionDevAportaSocioBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+impresionDevAportaSocioBean.tipoTransaccion+
				'&numTrans='+impresionDevAportaSocioBean.folio,'_blank');
	}
}
/**
 * Pagare de Remesas
 * @param impresionPagoRemesaBean
 */
function reimprimeTicketpagoRemesas(impresionPagoRemesaBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketPagoServicio(impresionPagoRemesaBean);
	} else {
		window.open('RepTicketPagoRemesas.htm?'+
				'nombreInstitucion='+impresionPagoRemesaBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+impresionPagoRemesaBean.tipoTransaccion+
				'&direccionInstitucion='+impresionPagoRemesaBean.direccionInstitucion+
				'&rfcInstitucion='+impresionPagoRemesaBean.rfcInstitucion+
				'&telefonosucursal='+impresionPagoRemesaBean.telefonosucursal+
				'&transaccion='+impresionPagoRemesaBean.folio,'_blank');
	}
}
/**
 * Pago de Oportunidades
 * @param imprimeTicketPagoServicio
 * @param tipo
 */
function reimprimeTicketpagoOportun(impresionPagooportunidadesBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketPagoServicio(impresionPagooportunidadesBean);				
	} else {
		window.open('RepTicketPagoOportunidades.htm?'+
				'nombreInstitucion='+impresionPagooportunidadesBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+impresionPagooportunidadesBean.tipoTransaccion+
				'&direccionInstitucion='+impresionPagooportunidadesBean.direccionInstitucion+
				'&rfcInstitucion='+impresionPagooportunidadesBean.rfcInstitucion+
				'&telefonosucursal='+impresionPagooportunidadesBean.telefonosucursal+
				'&transaccion='+impresionPagooportunidadesBean.folio,'_blank');
	}
}
/**
 * Recepcion de Cheques SBC
 * @param impresionRecepChequeSBCBean
 */
function reimprimeTicketrecepDocSBC(impresionRecepChequeSBCBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketChequeSBC(impresionRecepChequeSBCBean);		
	} else {
		window.open('RepTicketRecepChequeSBC.htm?'+
				'nombreInstitucion='+impresionRecepChequeSBCBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+impresionRecepChequeSBCBean.tipoTransaccion+
				'&direccionInstitucion='+impresionRecepChequeSBCBean.direccionInstitucion+
				'&rfcInstitucion='+impresionRecepChequeSBCBean.rfcInstitucion+
				'&telefonosucursal='+impresionRecepChequeSBCBean.telefonosucursal+
				'&transaccion='+impresionRecepChequeSBCBean.folio,'_blank');
	}
}
/**
 * Aplicacion de Cheques SBC
 * @param impresionAplicaChequeSBCBean
 */
function reimprimeTicketaplicDocSBC(impresionAplicaChequeSBCBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketChequeSBC(impresionAplicaChequeSBCBean);						
	} else {
		window.open('RepTicketAplicaChequeSBC.htm?'+
				'nombreInstitucion='+impresionAplicaChequeSBCBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+impresionAplicaChequeSBCBean.tipoTransaccion+
				'&direccionInstitucion='+impresionAplicaChequeSBCBean.direccionInstitucion+
				'&rfcInstitucion='+impresionAplicaChequeSBCBean.rfcInstitucion+
				'&telefonosucursal='+impresionAplicaChequeSBCBean.telefonosucursal+
				'&transaccion='+impresionAplicaChequeSBCBean.folio,'_blank');
	}
}
/**
 * Pago de servicios - No tiene formato carta
 * @param impresionPagoServicioBean
 * @param tipo
 */
function imprimeTicketpagoServicios(impresionPagoServicioBean, tipo){
		imprimeTicketCobroServicio(impresionPagoServicioBean);				
}
/**
 * Recuperacion de cartera castigada
 * @param impresionCreditoCastigadoBean
 * @param tipo
 * @returns
 */
function reimprimeTicketrecupCartCast(impresionCreditoCastigadoBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketCreditoCastigado(impresionCreditoCastigadoBean);
	} else {
		window.open('RepTicketCredCastigado.htm?'+
			'creditoID='+impresionCreditoCastigadoBean.creditoID+
			'&numTrans='+impresionCreditoCastigadoBean.folio+
			'&tipoTransaccion='+impresionCreditoCastigadoBean.tipoTransaccion+
			'&nombreInstitucion='+impresionCreditoCastigadoBean.nombreInstitucion+
			'&numCopias='+1+
			'&direccionInstitucion='+impresionCreditoCastigadoBean.direccionInstitucion+
			'&rfcInstitucion='+impresionCreditoCastigadoBean.rfcInstitucion+
			'&telefonosucursal='+impresionCreditoCastigadoBean.telefonosucursal
			,'_blank');
	}
}
/**
 * Pago SERVIFUN Servicios funeriarios
 * @param imprimeTicketProteccionBean
 */
function reimprimeTicketpagoServifun(imprimeTicketProteccionBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketSERVIFUN(imprimeTicketProteccionBean);	
	} else {
		window.open('TicketPagoServifun.htm?'+				
					'transaccion='+imprimeTicketProteccionBean.folio+
					'&tipoTransaccion='+imprimeTicketProteccionBean.tipoTransaccion+
					'&nombreInstitucion='+imprimeTicketProteccionBean.nombreInstitucion+
					'&numCopias='+1+
					'&direccionInstitucion='+imprimeTicketProteccionBean.direccionInstitucion+
					'&rfcInstitucion='+imprimeTicketProteccionBean.rfcInstitucion+
					'&telefonosucursal='+imprimeTicketProteccionBean.telefonosucursal
					,'_blank');
	}
}
/**
 * Cobro de Seguro de Ayuda
 * @param impresionCobroSegAyudaBean
 */
function reimprimeTicketcobroSegVidAy(impresionCobroSegAyudaBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketCobroSeguroAyuda(impresionCobroSegAyudaBean);	
	} else {
		window.open('TicketVentanillaSegVida.htm?'+
				'nombreInstitucion='+impresionCobroSegAyudaBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+impresionCobroSegAyudaBean.tipoTransaccion+
				'&direccionInstitucion='+impresionCobroSegAyudaBean.direccionInstitucion+
				'&rfcInstitucion='+impresionCobroSegAyudaBean.rfcInstitucion+
				'&telefonosucursal='+impresionCobroSegAyudaBean.telefonosucursal+
				'&transaccion='+impresionCobroSegAyudaBean.folio,'_blank');
	}
}
/**
 * Temporalmente no tendra formato carta para la reimpresion del ticket
 * @param impresionAplicaSegAyudaBean
 */
function reimprimeTicketaplicSegVidAy(impresionAplicaSegAyudaBean){
		imprimeTicketAplicaSeguroAyuda(impresionAplicaSegAyudaBean);	
}

function imprimeTicketprepagoCredito(impresionPrepagoCredito, tipo){
	//Por el momento solo se reimprime por formato ticket
	imprimirTicketPrepagoCredito(impresionPrepagoCredito,contador, tipoCredito);
}
/**
 * Ticket para apoyo escolar
 * @param imprimeTicketApoyoEscolarBean
 */
function reimprimeTicketpagoApoyoEsco(imprimeTicketApoyoEscolarBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketPagoApoyoEscolar(imprimeTicketApoyoEscolarBean);
	} else {
		window.open('TicketPagoApoyoEscolar.htm?'+
				'nombreRecibePago='+imprimeTicketApoyoEscolarBean.personaRecibe+
		'&transaccion='+imprimeTicketApoyoEscolarBean.folio+
		'&tipoTransaccion='+imprimeTicketApoyoEscolarBean.tipoTransaccion+
		'&nombreInstitucion='+imprimeTicketApoyoEscolarBean.nombreInstitucion+
		'&numCopias='+1+
		'&direccionInstitucion='+imprimeTicketApoyoEscolarBean.direccionInstitucion+
		'&rfcInstitucion='+imprimeTicketApoyoEscolarBean.rfcInstitucion+
		'&telefonosucursal='+imprimeTicketApoyoEscolarBean.telefonosucursal,
		'_blank');	
	}
}
function reimprimeTicketpagoCancSocio(imprimeTicketPagoCancelBean, tipo){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketPagoCancel(imprimeTicketPagoCancelBean);	
	} else {
		window.open('ticketPagoCancelacionSocio.htm?'+
				'nombreInstitucion='+$('#nombreInstitucion').val()+
				'&transaccion='+$('#numeroTransaccion').val()+
				'&nombreBeneficiario='+$(jqNombreBenef).val()+
				'&nombreRecibePago='+$(jqNombreRecibePago).val()+
				'&tipoTransaccion='+imprimeTicketGastoAntBean.tipoTransaccion+
				'&direccionInstitucion='+imprimeTicketGastoAntBean.direccionInstitucion+
				'&telefonosucursal='+imprimeTicketGastoAntBean.telefono+
				'&porcentaje=100%'+
				'&numCopias='+1+
				'&folioSolicitud='+$('#serviFunFolioID').val(),
				'_blank');	
	}
}
/**
 * Gastos y Anticipos
 * @param imprimeTicketDevGastoAntBean
 */
function reimprimeTicketgastosAnticip(imprimeTicketGastoAntBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketGastosAnticipoSalida(imprimeTicketGastoAntBean);				
	} else {
		window.open('RepTicketVentanillaGastos.htm?'+
				'nombreInstitucion='+imprimeTicketGastoAntBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+imprimeTicketGastoAntBean.tipoTransaccion+
				'&numTrans='+imprimeTicketGastoAntBean.folio,'_blank');
	}
}
/**
 * Devolucion de gastos y anticipo
 * @param imprimeTicketGastoAntBean
 */
function reimprimeTicketdevgastosAnti(imprimeTicketGastoAntBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketDevGastosAnticipo(imprimeTicketGastoAntBean);															
	} else {
		window.open('RepTicketVentanillaDevGastos.htm?'+
				'nombreInstitucion='+imprimeTicketGastoAntBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+imprimeTicketGastoAntBean.tipoTransaccion+
				'&numTrans='+imprimeTicketGastoAntBean.folio,'_blank');
	}
}
/**
 * Entrega de Haberes Ex-Menor
 * @param imprimeTicketHaberesExMenorBean
 * @param tipo
 */
function reimprimeTicketreclHabSocMen(imprimeTicketHaberesExMenorBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketHaberesExMenorCta(imprimeTicketHaberesExMenorBean);				
	} else {
		window.open('RepTicketVentanillaHaberesExMenor.htm?'+
				'nombreInstitucion='+imprimeTicketHaberesExMenorBean.nombreInstitucion+
				'&numCopias='+1+
				'&tipoTransaccion='+imprimeTicketHaberesExMenorBean.tipoTransaccion+
				'&numTrans='+imprimeTicketHaberesExMenorBean.folio,'_blank');
	}
}
/**
 * Cobro Anual de Tarjeta de Debito
 * @param imprimeTicketAnualidadTarjetaBean
 * @param tipo
 */
function reimprimeTicketAnualidadTarjeta (imprimeTicketAnualidadTarjetaBean){
	if(Tamanioticket==TipoImpresion){				
			imprimeTicketAnualidad(imprimeTicketAnualidadTarjetaBean);
	} else {
		window.open('AnualidadTD.htm?'+
				'transaccion='+imprimeTicketAnualidadTarjetaBean.folio+
				'&tipoTransaccion='+imprimeTicketAnualidadTarjetaBean.tipoTransaccion+
				'&nombreInstitucion='+imprimeTicketAnualidadTarjetaBean.nombreInstitucion+
				'&numCopias='+1+
				'&direccionInstitucion='+imprimeTicketAnualidadTarjetaBean.direccionInstitucion+
				'&rfcInstitucion='+imprimeTicketAnualidadTarjetaBean.rfcInstitucion+
				'&telefonosucursal='+imprimeTicketAnualidadTarjetaBean.telefonosucursal
				,'_blank');
	}
}

/**
 * Pago de Arrendamiento
 * @param imprimeTicketPagoArrendamientoBean
 */
function reimprimeTicketPagoArrenda(imprimeTicketPagoArrendamientoBean){
	
	if(Tamanioticket==TipoImpresion){
		imprimeTicketArrendamiento(imprimeTicketPagoArrendamientoBean);
	} else {
		window.open('RepTicketVentanillaPagArrendamiento.htm?'+
					'fechaSistemaP='+imprimeTicketPagoArrendamientoBean.fechaPago+
					'&nombreInstitucion='+imprimeTicketPagoArrendamientoBean.nombreInstitucion+
					'&numeroSucursal='+imprimeTicketPagoArrendamientoBean.sucursal+
					'&nombreSucursal='+imprimeTicketPagoArrendamientoBean.nomSucursal+
					'&varCaja='+imprimeTicketPagoArrendamientoBean.caja+
					'&nomCajero='+imprimeTicketPagoArrendamientoBean.cajero+
					'&varArrendamientoID='+imprimeTicketPagoArrendamientoBean.arrendaID+
					'&numCopias='+1+
					'&sumTotalEnt='+imprimeTicketPagoArrendamientoBean.montoRecibido+
					'&diferencia='+imprimeTicketPagoArrendamientoBean.cambio+
					'&varFormaPago='+imprimeTicketPagoArrendamientoBean.formaPago+
					'&tipoTransaccion='+imprimeTicketPagoArrendamientoBean.tipoTransaccion+
					'&numTrans='+imprimeTicketPagoArrendamientoBean.folio+
					'&moneda='+imprimeTicketPagoArrendamientoBean.moneda,
					'_blank');
	}
}

function reimprimeTicketAccesCredito(impresionAccesCredBean){
	if(Tamanioticket==TipoImpresion){
		imprimeTicketAccesoriosCredito(impresionAccesCredBean);
	}
}