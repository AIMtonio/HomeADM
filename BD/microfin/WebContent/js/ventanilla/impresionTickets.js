var Tamanioticket = 'T';
var formatoImpresion = parametroBean.tipoImpTicket;
var safilocale = $("#socioClienteAlert").val();
var nombreInstitucion = parametroBean.nombreInstitucion;
var Enum_impresion_Tickets = {
'cargoCuenta' : 1,
'abonoCuenta' : 2,
'rev_cargoCuenta' : 31,
'rev_abonoCuenta' : 32
};
/**
 * Método para realizar la reimpresión de los tickets de la ventanilla.
 * @param tipoOperacion :  Tipo de Operación
 * @param numTransaccion : Número de Transacción de la operación del ticket.
 * @param numCopias : Número de Copias
 */
function reimprimeTickets(tipoOperacion, numTransaccion, numCopias) {
	var ticketBean = {
	'tipoOpera' : tipoOperacion,
	'transaccionID' : numTransaccion
	};
	if (Tamanioticket == formatoImpresion) {
		reimpresionTicketServicio.consulta(ticketBean, {
		async : false,
		callback : function(reimprimeBean) {
			if (reimprimeBean != null) {
				switch (tipoOperacion) {
					case Enum_impresion_Tickets.cargoCuenta :
						imprimeTicketCargo(reimprimeBean, formatoImpresion, numTransaccion, numCopias);
						break;
					case Enum_impresion_Tickets.abonoCuenta :
						imprimeTicketAbono(reimprimeBean, formatoImpresion, numTransaccion, numCopias);
						break;
					case Enum_impresion_Tickets.rev_cargoCuenta :
						imprimeTicketRevCargo(reimprimeBean, formatoImpresion, numTransaccion, numCopias);
						break;
					case Enum_impresion_Tickets.rev_abonoCuenta :
						imprimeTicketRevAbono(reimprimeBean, formatoImpresion, numTransaccion, numCopias);
						break;
				}
			} else {
				mensajeSis("Error al realizar la impresión del Ticket.");
				return null;
			}
		}
		});
	} else {
		switch (tipoOperacion) {
			case Enum_impresion_Tickets.cargoCuenta :
				imprimeTicketCargo(null, formatoImpresion, numTransaccion, numCopias);
				break;
			case Enum_impresion_Tickets.abonoCuenta :
				imprimeTicketAbono(null, formatoImpresion, numTransaccion, numCopias);
				break;
			case Enum_impresion_Tickets.rev_cargoCuenta :
				imprimeTicketRevCargo(null, formatoImpresion, numTransaccion, numCopias);
				break;
			case Enum_impresion_Tickets.rev_abonoCuenta :
				imprimeTicketRevAbono(null, formatoImpresion, numTransaccion, numCopias);
				break;
		}
	}

}
/**
 * Método que realiza la impresión del ticket de la operación Abono a Cuenta.
 * @param ticketBean : Bean con la información del ticket a imprimir.
 * @param formato : Formato en el que se imprimira el ticket.
 * @param numTransaccion : Número de transacción
 * @param numCopias : Número de Copias
 */
function imprimeTicketAbono(ticketBean, formato, numTransaccion,numCopias) {
	if (Tamanioticket == formato) {
		var impresionAbonoCuentaBean = {
		'folio' : ticketBean.transaccionID,
		'tituloOperacion' : 'ABONO A CUENTA',
		'clienteID' : ticketBean.clienteID,
		'nombreCliente' : ticketBean.nombrePersona,
		'noCuenta' : ticketBean.cuentaIDDeposito,
		'refCuenta' : ticketBean.referencia,
		'tipoCuentaGL' : ticketBean.tipoCuenta,
		'tipoCuenta' : ticketBean.tipoCuenta,
		'montoDep' : ticketBean.montoOperacion,
		'moneda' : ticketBean.moneda,
		'montoRec' : ticketBean.efectivo,
		'cambio' : ticketBean.cambio,
		'saldoDispon' : ticketBean.saldoActualCta,
		'saldoIni' : ticketBean.saldoInicial,
		'fecha': ticketBean.fecha,
		'hora': ticketBean.hora,
		'caja': ticketBean.cajaID,
		'claveUsuario':ticketBean.clave,
		'nombreSucursal': ticketBean.nombreSucursal,
		'formaPagoCobro':ticketBean.formaPagoCobro,
		'safilocale': safilocale
		};
		imprimeTicketAbonoCuenta(impresionAbonoCuentaBean);
	} else {
		window.open('RepTicketVentanillaAbonoCuenta.htm?'
			+ 'tipoTransaccion=' +2
			+ '&nombreInstitucion=' + nombreInstitucion 
			+ '&numCopias=' + numCopias 
			+ '&numTrans=' + numTransaccion, '_blank');
	}
}
/** Método para la impresión del ticket de la operación de cargo a cta
 * @param ticketBean : Bean con la información del ticket a imprimir.
 * @param formato : Formato en el que se imprimira el ticket.
 * @param numTransaccion : Número de transacción
 * @param numCopias : Número de Copias
 */
function imprimeTicketCargo(ticketBean, formato, numTransaccion,numCopias) {
	if (Tamanioticket == formato) {
		var impresionCargoCuentaBean = {
		'folio' : ticketBean.transaccionID,
		'tituloOperacion6' : 'RETIRO DE EFECTIVO',
		'tituloOperacion' : 'RETIRO DE EFECTIVO',
		'clienteID' : ticketBean.clienteID,
		'nombreCliente' : ticketBean.nombrePersona,
		'noCuenta' : ticketBean.cuentaIDRetiro,
		'refCuenta' : ticketBean.referencia,
		'tipoCuenta' : ticketBean.tipoCuenta,
		'montoRet' : ticketBean.montoOperacion,
		'moneda' : ticketBean.moneda,
		'saldoAct' : ticketBean.saldoActualCta,
		'saldoIni' : ticketBean.saldoInicial,
		'fecha' : ticketBean.fecha,
		'hora' : ticketBean.hora,
		'caja' : ticketBean.cajaID,
		'claveUsuario' : ticketBean.clave,
		'nombreSucursal' : ticketBean.nombreSucursal,
		'safilocale': safilocale,
		'formaPago':ticketBean.formaPagoCobro,
		};

		imprimeTicketCargoCuenta(impresionCargoCuentaBean);
	} else {
		window.open('RepTicketVentanillaCargoCuenta.htm?'
			+ 'tipoTransaccion=' +1
			+ '&nombreInstitucion=' + nombreInstitucion 
			+ '&numCopias=' + numCopias 
			+ '&numTrans=' + numTransaccion, '_blank');
	}
}
/**
 * Método que realiza la impresión del ticket para la Reversa de la op Cargo a Cta
 * @param ticketBean : Bean con la información del ticket a imprimir.
 * @param formato : Formato en el que se imprimira el ticket.
 * @param numTransaccion : Número de transacción
 * @param numCopias : Número de Copias
 */
function imprimeTicketRevCargo(ticketBean, formato, numTransaccion,numCopias) {
	if (Tamanioticket == formato) {
		var impresionCargoCuentaBean = {
		'folio' : ticketBean.transaccionID,
		'tituloOperacion6' : 'RETIRO DE EFECTIVO',
		'tituloOperacion' : 'RETIRO DE EFECTIVO',
		'clienteID' : ticketBean.clienteID,
		'nombreCliente' : ticketBean.nombrePersona,
		'noCuenta' : ticketBean.cuentaIDRetiro,
		'refCuenta' : ticketBean.referencia,
		'tipoCuenta' : ticketBean.tipoCuenta,
		'montoRet' : ticketBean.montoOperacion,
		'moneda' : ticketBean.moneda,
		'saldoAct' : ticketBean.saldoActualCta,
		'saldoIni' : ticketBean.saldoInicial,
		'fecha' : ticketBean.fecha,
		'hora' : ticketBean.hora,
		'caja' : ticketBean.cajaID,
		'claveUsuario' : ticketBean.clave,
		'nombreSucursal' : ticketBean.nombreSucursal,
		'safilocale': safilocale
		};

		imprimeTicketReversaCargoCuenta(impresionCargoCuentaBean);
	} else {
		window.open('ReversaCargoCta.htm?'
			+ 'tipoTransaccion=' +1
			+ '&nombreInstitucion=' + nombreInstitucion 
			+ '&numCopias=' + numCopias 
			+ '&numTrans=' + numTransaccion, '_blank');
	}
}
/**
 * Método que realiza la impresión del ticket para la Reversa de la op Cargo a Cta
 * @param ticketBean : Bean con la información del ticket a imprimir.
 * @param formato : Formato en el que se imprimira el ticket.
 * @param numTransaccion : Número de transacción
 * @param numCopias : Número de Copias
 */
function imprimeTicketRevAbono(ticketBean, formato, numTransaccion,numCopias) {
	if (Tamanioticket == formato) {
		var  impresionAbonoCuentaBean = {
			'folio'				: ticketBean.transaccionID,
			'clienteID' 		: ticketBean.clienteID,
			'nombreCliente'		: ticketBean.nombrePersona,
			'efectivo'			: ticketBean.efectivo,
			'tituloOperacion'	:'REVERSA ABONO A CUENTA',
			'referencia'		: ticketBean.referencia,
			'numCuenta'			: ticketBean.cuentaIDDeposito,
			'cambio'			: ticketBean.cambio,
			'moneda'			: ticketBean.moneda,
			'tipoCuenta'		: ticketBean.tipoCuenta,
			'nombreSucursal'	: ticketBean.nombreSucursal,
			'saldoIni'			: ticketBean.saldoInicial,
			'refCuenta'			: ticketBean.referencia,
			'tipoCuentaGL'		: ticketBean.tipoCuenta,
			'montoDep'			: ticketBean.montoOperacion,
			'saldoDispon'		: ticketBean.saldoActualCta,
			'hora'				: ticketBean.hora,
			'fecha'				: ticketBean.fecha,
			'caja'				: ticketBean.cajaID,
			'claveUsuario'		: ticketBean.clave,
			'safilocale'		: safilocale
		};

		impTicketReversaAbonoCuenta(impresionAbonoCuentaBean);
	} else {
		window.open('ReversaAbonoCuentaTicket.htm?'
			+ 'tipoTransaccion=' +2
			+ '&nombreInstitucion=' + nombreInstitucion
			+ '&numCopias=' + numCopias 
			+ '&numTrans=' + numTransaccion, '_blank');
	}
}