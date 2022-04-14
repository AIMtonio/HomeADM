//Definicion de Constantes y Enums
var consulta = {
	'principal'	: 1
};

var campoPantalla = '';

$(document).ready(function() {
	$('#imprimirResumen').hide();
	deshabilitaBoton('imprimirResumen', 'submit');
});

$('#imprimirResumen').click(function(){
	imprimirResumen();
});

function mostrarBotonResumen(opcionCajaID){

	var safilocale = $('#socioClienteAlert').val();
	$('#imprimirResumen').hide();
	deshabilitaBoton('imprimirResumen', 'submit');

	var resumenTicketBean = {
		'opcionCajaID' : opcionCajaID
	};

	impresionTicketResumenServicio.consulta(consulta.principal, resumenTicketBean, {
		async : false,
		callback : function(resumenTicketBeanResponse){
			if( resumenTicketBeanResponse != null ) {
				if( resumenTicketBeanResponse.mostrarBtnResumen == 'S' && 
					resumenTicketBeanResponse.impTicketResumen == 'S'){
					
					campoPantalla = resumenTicketBeanResponse.campoPantalla;
					$('#imprimirResumen').show();
					habilitaBoton('imprimirResumen', 'submit');
				}
			} else {
				mensajeSis('La operación de Ventanilla no es Valida.');
				return false;
			}
		},
		errorHandler : function(message, exception) {
			mensajeSis('Error en la consulta de Operaciones validas para la Impresión del Ticket de Resumen del '+safilocale+'.<br>' + message + ':' + exception);
			return false;
		}
	});
}

function imprimirResumen() {

	var safilocale = $('#socioClienteAlert').val();
	var jqControl = eval("'#" + campoPantalla + "'");
	var clienteID = $(jqControl).val();

	var impresionTicketResumenBean = {
		'clienteID'		: clienteID,
		'safilocale'	: safilocale,
		'transaccionID'	: $('#numeroTransaccion').val()
	};

	if( clienteID == 0 ){
		mensajeSis('El ' + safilocale + ' no es Valido.');
		return false;
	}

	if( clienteID != '' && !isNaN(clienteID) ){

		impresionTicketResumenServicio.resumenCliente(impresionTicketResumenBean, {
			async : false,
			callback : function(impresionTicketResumenBeanResponse){
				if( impresionTicketResumenBeanResponse != null ) {
					if( impresionTicketResumenBeanResponse.mensajeTransaccionBean.numero == 0){
						var linea 				= "---------------------------------------";
						var centrado			= justificaCentro('RESUMEN',40,' ');
						var aportacionID		= 0;
						var cedeID				= 0;
						var creditoID			= 0;
						var inversionID			= 0;
						var longitudAlineacion	= 15;
						var longitudAcompletar	= 10;
						var signoMoneda			= '$';
						var cadenaVacia			= '';
						var numeroCliente		= completaCerosIzquierda(impresionTicketResumenBeanResponse.clienteID ,longitudAcompletar);
	
						agregaEncabezado(impresionTicketResumenBeanResponse.transaccionID);
						agregaSaltoLinea(1);
						agregaLinea(linea);
						agregaLinea(centrado);
						agregaSaltoLinea(1);
						agregaLinea(safilocale+": "+numeroCliente);
						agregaLinea("Nombre: "+impresionTicketResumenBeanResponse.nombreCompleto);
						agregaSaltoLinea(1);
	
						// Seccion de Cuentas de Ahorro
						for( var iteracion = 0; iteracion < impresionTicketResumenBeanResponse.listaCuentasAhoBean.length; iteracion++ ) {
							agregaLinea(impresionTicketResumenBeanResponse.listaCuentasAhoBean[iteracion].tipoCuentaID);
							agregaLinea("Saldo:                  " + alinearDato(impresionTicketResumenBeanResponse.listaCuentasAhoBean[iteracion].saldo, longitudAlineacion, signoMoneda));
							agregaSaltoLinea(1);
						}
	
						// Seccion de Créditos
						for( var iteracion = 0; iteracion < impresionTicketResumenBeanResponse.listaCreditosBean.length; iteracion++ ) {
							creditoID = completaCerosIzquierda(impresionTicketResumenBeanResponse.listaCreditosBean[iteracion].creditoID ,longitudAcompletar);
							agregaLinea("No. Credito:            " + alinearDato(creditoID, longitudAlineacion, cadenaVacia));
							agregaLinea("Saldo Total Liq:        " + alinearDato(impresionTicketResumenBeanResponse.listaCreditosBean[iteracion].montoDesemb, longitudAlineacion, signoMoneda));
							agregaLinea("Monto Exigible:         " + alinearDato(impresionTicketResumenBeanResponse.listaCreditosBean[iteracion].pagoExigible, longitudAlineacion, signoMoneda));
							agregaLinea("Fecha Prox. Vto:        " + alinearDato(impresionTicketResumenBeanResponse.listaCreditosBean[iteracion].fechaCorte, longitudAlineacion, cadenaVacia));
							agregaLinea("Estatus:                " + alinearDato(impresionTicketResumenBeanResponse.listaCreditosBean[iteracion].estatus, longitudAlineacion, cadenaVacia));
							agregaSaltoLinea(1);
						}
	
						// Seccion de Inversiones
						for( var iteracion = 0; iteracion < impresionTicketResumenBeanResponse.listaInversionBean.length; iteracion++ ) {
							inversionID = completaCerosIzquierda(impresionTicketResumenBeanResponse.listaInversionBean[iteracion].inversionID ,longitudAcompletar);
							agregaLinea("No. Inversion:          " + alinearDato(inversionID, longitudAlineacion, cadenaVacia));
							agregaLinea("Inicio:                 " + alinearDato(impresionTicketResumenBeanResponse.listaInversionBean[iteracion].fechaInicio, longitudAlineacion, cadenaVacia));
							agregaLinea("Vencimiento:            " + alinearDato(impresionTicketResumenBeanResponse.listaInversionBean[iteracion].fechaVencimiento, longitudAlineacion, cadenaVacia));
							agregaLinea("Capital:                " + alinearDato(impresionTicketResumenBeanResponse.listaInversionBean[iteracion].montoString, longitudAlineacion, signoMoneda));
							agregaSaltoLinea(1);
						}
	
						// Seccion de Cedes
						for( var iteracion = 0; iteracion < impresionTicketResumenBeanResponse.listaCedesBean.length; iteracion++ ) {
							cedeID = completaCerosIzquierda(impresionTicketResumenBeanResponse.listaCedesBean[iteracion].cedeID ,longitudAcompletar);
							agregaLinea("No. Cede:               " + alinearDato(cedeID, longitudAlineacion, cadenaVacia));
							agregaLinea("Inicio:                 " + alinearDato(impresionTicketResumenBeanResponse.listaCedesBean[iteracion].fechaInicio, longitudAlineacion, cadenaVacia));
							agregaLinea("Vencimiento:            " + alinearDato(impresionTicketResumenBeanResponse.listaCedesBean[iteracion].fechaVencimiento, longitudAlineacion, cadenaVacia));
							agregaLinea("Capital:                " + alinearDato(impresionTicketResumenBeanResponse.listaCedesBean[iteracion].monto, longitudAlineacion, signoMoneda));
							agregaSaltoLinea(1);
						}
	
						// Seccion de Aportaciones
						for( var iteracion = 0; iteracion < impresionTicketResumenBeanResponse.listaAportacionesBean.length; iteracion++ ) {
							aportacionID = completaCerosIzquierda(impresionTicketResumenBeanResponse.listaAportacionesBean[iteracion].aportacionID ,longitudAcompletar);
							agregaLinea("No. Aportacion:         " + alinearDato(aportacionID, longitudAlineacion, cadenaVacia));
							agregaLinea("Inicio:                 " + alinearDato(impresionTicketResumenBeanResponse.listaAportacionesBean[iteracion].fechaInicio, longitudAlineacion, cadenaVacia));
							agregaLinea("Vencimiento:            " + alinearDato(impresionTicketResumenBeanResponse.listaAportacionesBean[iteracion].fechaVencimiento, longitudAlineacion, cadenaVacia));
							agregaLinea("Capital:                " + alinearDato(impresionTicketResumenBeanResponse.listaAportacionesBean[iteracion].monto, longitudAlineacion, signoMoneda));
							agregaSaltoLinea(1);
						}
	
						agregaSaltoLinea(1);
						agregaSaltoLinea(1);
						agregaSaltoLinea(1);
						agregaSaltoLinea(1);
						agregaPiePagClienteCajero();
						agregaSaltoLinea(1);
						agregaSaltoLinea(1);
						agregaSaltoLinea(1);
						imprimeTicketCortaPapel();
					} else {
						mensajeSis(impresionTicketResumenBeanResponse.mensajeTransaccionBean.descripcion);
						return false;
					}
				} else {
					mensajeSis('El '+safilocale+' No cuenta con un Resumen de Productos.');
					return false;
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis('Error en la Impresión del Ticket de Resumen del '+safilocale+'.<br>' + message + ':' + exception);
				return false;
			}
		});
	} else {
		mensajeSis('El ' + safilocale + ' no es Valido.');
		return false;
	}
}