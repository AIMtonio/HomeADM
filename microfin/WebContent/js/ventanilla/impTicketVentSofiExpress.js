
//----------------------------REVERSAS----------------------------------------------
function impTicketReversaCobroSeguroVida(impresionCobroSeguroBean) {
	var linea = "---------------------------------------";
	var clienteID = completaCerosIzquierda(impresionCobroSeguroBean.clienteID, 10);
	var centrado = justificaCentro(impresionCobroSeguroBean.tituloOperacion, 40, ' ');
	agregaEncabezado(impresionCobroSeguroBean.folio);
	agregaLinea(linea);
	agregaLinea(centrado);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: " + clienteID);
	agregaLinea("Nombre: " + impresionCobroSeguroBean.nombreCliente);
	agregaLinea("Monto: $" + impresionCobroSeguroBean.efectivo);

	cantidadEnLetras(impresionCobroSeguroBean.efectivo);

	agregaSaltoLinea(3);

	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();

}
/**
 * Imprime el ticket de Yanga para la op de Reversa de Abono de Cuenta
 * @param impresionAbonoCuentaBean : Bean con la información de la ope.
 */
function impTicketReversaAbonoCuenta(impresionAbonoCuentaBean) {
	var linea = "---------------------------------------";
	var centrado = justificaCentro(impresionAbonoCuentaBean.tituloOperacion, 40, ' ');
	agregaEnc(impresionAbonoCuentaBean);
	agregaLinea(linea);
	agregaLinea(centrado);
	agregaSaltoLinea(1);
	agregaLinea(impresionAbonoCuentaBean.safilocale+": " + impresionAbonoCuentaBean.clienteID);
	agregaLinea("Nombre: " + impresionAbonoCuentaBean.nombreCliente);
	agregaLinea("Cuenta: " + reemplazaCuenta(impresionAbonoCuentaBean.numCuenta));
	agregaLinea("Tipo Cuenta: " + impresionAbonoCuentaBean.tipoCuenta);
	agregaLinea("Referencia: " + impresionAbonoCuentaBean.referencia);
	agregaLinea("Monto del Deposito: $" + alinearDatoIzquierda(impresionAbonoCuentaBean.efectivo, impresionAbonoCuentaBean.efectivo));

	agregaSaltoLinea(1);
	agregaLinea("Monto Recibido:	 $" + impresionAbonoCuentaBean.efectivo);
	agregaLinea("Cambio:        	 $" + alinearDatoIzquierda(impresionAbonoCuentaBean.cambio, impresionAbonoCuentaBean.efectivo));
	agregaLinea("Forma de Pago: Efectivo");
	cantidadEnLetras(impresionAbonoCuentaBean.efectivo);
	agregaSaltoLinea(3);
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
}

/**
 * Imprime el ticket para la op de Reversa de cargo a Cuenta
 * @param ticketReversaCargoCuentaBean : Bean con la información de la ope.
 */
function imprimeTicketReversaCargoCuenta(ticketReversaCargoCuentaBean) {
	var linea = "---------------------------------------";
	var tituloOperacion = justificaCentro(ticketReversaCargoCuentaBean.tituloOperacion, 40, ' ');

	agregaEnc(ticketReversaCargoCuentaBean);
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea(ticketReversaCargoCuentaBean.safilocale+": " + ticketReversaCargoCuentaBean.clienteID);
	agregaLinea("Nombre: " + ticketReversaCargoCuentaBean.nombreCliente);
	agregaLinea("No. Cuenta: " + reemplazaCuenta(ticketReversaCargoCuentaBean.noCuenta));
	agregaLinea("Tipo de Cuenta: " + ticketReversaCargoCuentaBean.tipoCuenta);
	agregaLinea("Referencia: " + ticketReversaCargoCuentaBean.refCuenta);
	agregaLinea("Monto Retiro: $" + ticketReversaCargoCuentaBean.montoRet);
	agregaLinea("Moneda:       " + ticketReversaCargoCuentaBean.moneda);
	cantidadEnLetras(ticketReversaCargoCuentaBean.montoRet);
	agregaSaltoLinea(3);
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
}

function imprimeTicketReversaGarantiaLiq(ticketReversaGarantiaLiqBean){		
	var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(ticketReversaGarantiaLiqBean.clienteID ,10);
    var tituloOperacion=justificaCentro(ticketReversaGarantiaLiqBean.tituloOperacion,40,' '); 
	
    agregaEncabezado(ticketReversaGarantiaLiqBean.folio);	
    agregaLinea(linea);
    agregaLinea(tituloOperacion);
    agregaSaltoLinea(1);
    agregaLinea("Cliente: "+clienteID);
    agregaLinea("Nombre: "+ticketReversaGarantiaLiqBean.nombreCliente);
    agregaLinea("No. Cuenta: "+reemplazaCuenta(ticketReversaGarantiaLiqBean.noCuenta));
    if(ticketReversaGarantiaLiqBean.ciclo!=''){
    	agregaLinea("Grupo: "+ticketReversaGarantiaLiqBean.grupo);
    	agregaLinea("Ciclo: "+ticketReversaGarantiaLiqBean.ciclo);
    }
    agregaSaltoLinea(1);
    agregaLinea("No.Credito: "+ticketReversaGarantiaLiqBean.noCredito);
    agregaLinea("Monto del Deposito: $"+ticketReversaGarantiaLiqBean.montDep);	
    agregaLinea("Moneda: " +ticketReversaGarantiaLiqBean.moneda);
    agregaSaltoLinea(1);
    if(ticketReversaGarantiaLiqBean.formaPago=='Efectivo'){
	    agregaLinea("Monto Recibido:     $"+alinearDatoIzquierda(ticketReversaGarantiaLiqBean.montRec,ticketReversaGarantiaLiqBean.montDep));
	    agregaLinea("Cambio:             $"+alinearDatoIzquierda(ticketReversaGarantiaLiqBean.cambio,ticketReversaGarantiaLiqBean.montRec));
    }
    agregaLinea("Forma de Pago:   "+ticketReversaGarantiaLiqBean.formaPago);
    cantidadEnLetras(ticketReversaGarantiaLiqBean.montDep);
    agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
}

function imprimeTicketReversaDesemCredito(reversaDesemCreditoBean){		
	var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(reversaDesemCreditoBean.clienteID ,10);
    var tituloOperacion=justificaCentro(reversaDesemCreditoBean.tituloOperacion,40,' ');
     
	agregaEncabezado(reversaDesemCreditoBean.folio);	
	agregaLinea(linea);
    agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre: "+reversaDesemCreditoBean.nombreCliente);
 	agregaLinea("No. Cuenta: "+reemplazaCuenta(reversaDesemCreditoBean.noCuenta));
	agregaLinea("Tipo de Cuenta: "+reversaDesemCreditoBean.tipoCuenta);
	agregaLinea("Credito: "+reversaDesemCreditoBean.credito);
	agregaLinea("Moneda:  "+reversaDesemCreditoBean.moneda);

    agregaLinea("Monto del Credito:       $"+soloAlinearDato(reversaDesemCreditoBean.montoCred,14));
	agregaLinea("Monto Recibido Anterior: $"+soloAlinearDato(reversaDesemCreditoBean.monRecAnt,14));
	agregaLinea("Monto del Retiro:        $"+soloAlinearDato(reversaDesemCreditoBean.montRet,14));
    if(reversaDesemCreditoBean.ciclo !='' ){
		agregaLinea("Grupo: "+reversaDesemCreditoBean.grupo);	
		agregaLinea("Ciclo: "+reversaDesemCreditoBean.ciclo);
	}
    cantidadEnLetras(reversaDesemCreditoBean.montRet);
    agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
    imprimeTicketCortaPapel();
}

function imprimeTicketReversaComXapertura(comXaperturaBean){
	var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(comXaperturaBean.clienteID ,10);
    var tituloOperacion=justificaCentro(comXaperturaBean.tituloOperacion,40,' ');
     
	agregaEncabezado(comXaperturaBean.folio);	
	agregaLinea(linea);
    agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre: "+comXaperturaBean.nombreCliente);
  	agregaLinea("No. Cuenta: "+reemplazaCuenta(comXaperturaBean.noCuenta));
	agregaLinea("Tipo de Cuenta: "+comXaperturaBean.tipoCuenta);
	agregaLinea("Credito: "+comXaperturaBean.credito);
	agregaLinea("Prod.Cred: "+comXaperturaBean.prodCredito);
	if (comXaperturaBean.grupo != ''){
		agregaLinea("Grupo: "+comXaperturaBean.grupo);	
	}
	agregaLinea("          DESGLOSE" );
	agregaLinea("----------------------------" );
	agregaLinea("CONCEPTO       CANTIDAD   "    );	
	agregaLinea("----------------------------" );
	agregaLinea("Comision:"+alinearDato(comXaperturaBean.comision,14,'$'));
	agregaLinea("I.V.A:   "+alinearDato(comXaperturaBean.iva,14,'$'));
	agregaLinea("----------------------------" );
	agregaLinea("TOTAL:   "+alinearDato(comXaperturaBean.monto,14,'$'));
	 
	agregaLinea("Moneda: "+comXaperturaBean.moneda);	
    cantidadEnLetras(comXaperturaBean.monto);
    agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(2);
    imprimeTicketCortaPapel();
}



/**
 * Método Imprime el ticket en formato ticket operación abono de efectivo
 * @param impresionAbonoCuentaBean : Bean con la información de la operación
 */
function imprimeTicketAbonoCuenta(impresionAbonoCuentaBean) {
	var parametroBean = consultaParametrosSession();
	var linea = "---------------------------------------";
	var tituloOperacion = justificaCentro('ABONO A CUENTA', 40, ' ');

	agregaEncabezadoSofiExpress(impresionAbonoCuentaBean.folio);
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	
	agregaLinea(impresionAbonoCuentaBean.safilocale + ": " + impresionAbonoCuentaBean.clienteID);
	agregaLinea("NOMBRE: " + impresionAbonoCuentaBean.nombreCliente);
	agregaLinea("No. CUENTA: " + reemplazaCuenta(impresionAbonoCuentaBean.noCuenta));
	agregaLinea("TIPO DE CUENTA: " + impresionAbonoCuentaBean.tipoCuentaGL);
	agregaLinea("REFERENCIA: " + impresionAbonoCuentaBean.refCuenta);
	agregaSaltoLinea(1);
	
	agregaLinea("MONTO DE DEPOSITO:      $" + impresionAbonoCuentaBean.montoDep);	
	agregaLinea("MONTO RECIBIDO:         $" + alinearDatoIzquierda(impresionAbonoCuentaBean.montoRec, impresionAbonoCuentaBean.montoDep));
	agregaLinea("CAMBIO:                 $" + alinearDatoIzquierda(impresionAbonoCuentaBean.cambio, impresionAbonoCuentaBean.montoDep, impresionAbonoCuentaBean.moneda));
	agregaSaltoLinea(1);
	
	cantidadEnLetras(impresionAbonoCuentaBean.montoDep);
	agregaLinea("FORMA DE PAGO:      " + impresionAbonoCuentaBean.formaPagoCobro);
	agregaLinea("MONEDA: " + impresionAbonoCuentaBean.moneda);
	agregaSaltoLinea(1);
	if (parametroBean.impSaldoCta == 'S') {
		agregaLinea("SALDO ACTUAL:      $" + alinearDatoIzquierda(impresionAbonoCuentaBean.saldoDispon, impresionAbonoCuentaBean.montoDep));
	}
	agregaSaltoLinea(3);

	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();

}
/**
 * Método Imprime el ticket en formato ticket operación retiro de efectivo
 * @param impresionCargoCuentaBean : Bean con la información de la operación
 */
function imprimeTicketCargoCuenta(impresionCargoCuentaBean) {
	var linea = "---------------------------------------";
	var tituloOperacion6 = justificaCentro('RETIRO DE EFECTIVO', 40, ' ');

	agregaEncabezadoSofiExpress(impresionCargoCuentaBean.folio);
	agregaLinea(linea);
	agregaLinea(tituloOperacion6);
	agregaSaltoLinea(1);
	
	agregaLinea(impresionCargoCuentaBean.safilocale + ": " + impresionCargoCuentaBean.clienteID);
	agregaLinea("NOMBRE: " + impresionCargoCuentaBean.nombreCliente);
	agregaLinea("No. CUENTA: " + reemplazaCuenta(impresionCargoCuentaBean.noCuenta));
	agregaLinea("TIPO DE CUENTA: " + impresionCargoCuentaBean.tipoCuenta);
	agregaLinea("REFERENCIA: " + impresionCargoCuentaBean.refCuenta);
	agregaSaltoLinea(1);
	
	agregaLinea("MONTO DE RETIRO: $" + impresionCargoCuentaBean.montoRet);
	agregaSaltoLinea(1);
	
	cantidadEnLetras(impresionCargoCuentaBean.montoRet);
	agregaLinea("FORMA DE PAGO: "+impresionCargoCuentaBean.formaPago);
	agregaLinea("MONEDA: " + impresionCargoCuentaBean.moneda);

	
	agregaSaltoLinea(3);
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
}

function imprimeTicketGarantiaLiq(impresionGarantiaLiqBean){		
	var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(impresionGarantiaLiqBean.clienteID ,10);
    var tituloOperacion2=justificaCentro('DEPOSITO DE GARANTIA LIQUIDA',40,' '); 
	
    agregaEncabezadoSofiExpress(impresionGarantiaLiqBean.folio);	
    agregaLinea(linea);
    agregaLinea(tituloOperacion2);
    agregaSaltoLinea(1);
    
    agregaLinea("CLIENTE: "+clienteID);
    agregaLinea("NOMBRE: "+impresionGarantiaLiqBean.nombreCliente);
    agregaLinea("No.CUENTA: "+reemplazaCuenta(impresionGarantiaLiqBean.noCuenta));
    if(impresionGarantiaLiqBean.ciclo>0){
    agregaLinea("GRUPO: "+impresionGarantiaLiqBean.grupo);
    agregaLinea("CICLO: "+impresionGarantiaLiqBean.ciclo);
    }
    agregaLinea("No.CREDITO: "+impresionGarantiaLiqBean.noCredito);
    agregaLinea("PROD.CRED: "+impresionGarantiaLiqBean.proCred);
    agregaSaltoLinea(1);
    
    	
    if(impresionGarantiaLiqBean.formaPago == 'Efectivo'){
    	agregaLinea("MONTO RECIBIDO:           $"+alinearDatoIzquierda(impresionGarantiaLiqBean.montRec,impresionGarantiaLiqBean.montDep));
    	agregaLinea("MONTO DEL DEPOSITO:       $"+impresionGarantiaLiqBean.montDep);
    	agregaLinea("CAMBIO:                   $"+ alinearDatoIzquierda(impresionGarantiaLiqBean.cambio,impresionGarantiaLiqBean.montDep));
    }else{
    	agregaLinea("MONTO DEL DEPOSITO: $"+impresionGarantiaLiqBean.montDep);
    }
    agregaSaltoLinea(1);
    
    cantidadEnLetras(impresionGarantiaLiqBean.montDep);
    agregaLinea("FORMA DE PAGO: "+impresionGarantiaLiqBean.formaPago);
    agregaLinea("MONEDA: " +impresionGarantiaLiqBean.moneda);
    
    agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();


}

function imprimeTicketComisionApertura(impresionComisionAperturaBean){		
	var linea="---------------------------------------";
	var linea2="_______________________________________";
	var clienteID=completaCerosIzquierda(impresionComisionAperturaBean.clienteID ,10);
    var tituloOperacion3=justificaCentro('COMISION POR APERTURA',40,' ');
	
    agregaEncabezadoSofiExpress(impresionComisionAperturaBean.folio);	
    agregaLinea(linea);
    agregaLinea(tituloOperacion3);
    agregaSaltoLinea(1);
    agregaLinea("CLIENTE: "+clienteID);
    agregaLinea("NOMBRE:  "+impresionComisionAperturaBean.nombreCliente);
    agregaLinea("No.CUENTA: "+ reemplazaCuenta(impresionComisionAperturaBean.noCuenta));
    agregaSaltoLinea(1);
    agregaLinea("No.CREDITO:"+impresionComisionAperturaBean.NoCredito);
    agregaLinea("PROD.CRED: "+impresionComisionAperturaBean.proCred);

    if(impresionComisionAperturaBean.ciclo!='' && impresionComisionAperturaBean.ciclo!=0){
    agregaLinea("CICLO:   "+alinearDatoIzquierda(impresionComisionAperturaBean.ciclo,impresionComisionAperturaBean.comision));
    agregaLinea("GRUPO:   "+impresionComisionAperturaBean.grupo);
    }
    agregaSaltoLinea(1);
    agregaLinea(linea2);
    agregaLinea("                DESGLOSE  ");
    agregaLinea("     CONCEPTO              CANTIDAD  ");
    agregaLinea(linea2);
    agregaLinea("COMISION:                 $"+impresionComisionAperturaBean.comision);
    agregaLinea("I.V.A:                    $"+alinearDatoIzquierda(impresionComisionAperturaBean.iva,impresionComisionAperturaBean.comision));
    agregaLinea(linea2);
    agregaLinea("TOTAL:                    $"+alinearDatoIzquierda(impresionComisionAperturaBean.total,impresionComisionAperturaBean.comision));
    agregaSaltoLinea(1);
    agregaLinea("MONTO RECIBIDO:           $" +alinearDatoIzquierda(impresionComisionAperturaBean.montoReci,impresionComisionAperturaBean.comision));
    agregaLinea("MONTO DEL PAGO:           $"+alinearDatoIzquierda(impresionComisionAperturaBean.montPago,impresionComisionAperturaBean.comision));	
    agregaLinea("CAMBIO:                   $"+alinearDatoIzquierda(impresionComisionAperturaBean.cambio,impresionComisionAperturaBean.comision));
    agregaSaltoLinea(1);
    
    cantidadEnLetras(impresionComisionAperturaBean.total);
    agregaLinea("FORMA DE PAGO: "   +  "EFECTIVO");
    agregaLinea("MONEDA: " +impresionComisionAperturaBean.moneda);
   
    agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
    agregaSaltoLinea(3);
      
	imprimeTicketCortaPapel();
     
}
 
function imprimeTicketCobroSegVida(impresionCobroSegVidaBean){				
	var linea="---------------------------------------";		
	var clienteID=completaCerosIzquierda(impresionCobroSegVidaBean.clienteID ,10);
    var tituloOperacion4=justificaCentro('COBRO POLIZA COBERTURA DE RIESGO',40,' ');
	agregaEncabezado(impresionCobroSegVidaBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion4);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre:  "+impresionCobroSegVidaBean.nombreCliente);
	agregaLinea("Monto:            $"+impresionCobroSegVidaBean.efectivo);
    agregaLinea("Forma de Pago:" +  "Efectivo");	
	cantidadEnLetras(impresionCobroSegVidaBean.efectivo);	
	
	agregaSaltoLinea(3);
	
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();

	}

function imprimeTicketDesemCredito(impresionDesemCreditoBean){		
	var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(impresionDesemCreditoBean.clienteID ,10);
    var tituloOperacion8=justificaCentro('DESEMBOLSO DE CREDITO',40,' ');
    var montoPendiente=cantidadFormatoMoneda(impresionDesemCreditoBean.montoPend);
    
    agregaEncabezadoSofiExpress(impresionDesemCreditoBean.folio);	
	agregaLinea(linea);
    agregaLinea(tituloOperacion8);
	agregaSaltoLinea(1);
	agregaLinea("CLIENTE: "+clienteID);
	agregaLinea("NOMBRE: "+impresionDesemCreditoBean.nombreCliente);
	agregaLinea("No. CUENTA: "+reemplazaCuenta(impresionDesemCreditoBean.noCuenta));
	agregaSaltoLinea(1);
	
	agregaLinea("No. CREDITO: "+impresionDesemCreditoBean.credito);
	agregaLinea("PROD.CRED: "+impresionDesemCreditoBean.proCred);
	agregaLinea("MONTO DEL CREDITO:      "+alinearDato(impresionDesemCreditoBean.montoCred,14,'$')); 
	agregaLinea("MONTO RECIBITO ANTERIOR:"+alinearDato(impresionDesemCreditoBean.monRecAnt,14,'$'));
	agregaLinea("MONTO DEL RETIRO:       "+alinearDato(impresionDesemCreditoBean.montRet,14,'$'));
	agregaLinea("MONTO PENDIENTE:        "+alinearDato(montoPendiente,14,'$'));
	agregaSaltoLinea(1);
	
        if(impresionDesemCreditoBean.ciclo >0 ){
	agregaLinea("GRUPO: "+impresionDesemCreditoBean.grupo);	
	agregaLinea("CICLO: "+impresionDesemCreditoBean.ciclo);
	}
        
    cantidadEnLetras(impresionDesemCreditoBean.montRet);
    agregaLinea("MONEDA:  "+impresionDesemCreditoBean.moneda);
    
    agregaSaltoLinea(3);
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
   imprimeTicketCortaPapel();
	
}

/*  Para el pago de Credito grupal e individual	 y de la garantia liquida  */		
function imprimirTicketPagCredGrupal(impresionPagoCredGrupal,numeroTicket,garantiaLiquida){
	var linea="---------------------------------------";
	var tituloOperacion=justificaCentro('COMPROBANTE PAGO DE CREDITO',38,' ');
	var parametroBean=consultaParametrosSession();
	var nombreUsuario=parametroBean.nombreUsuario;
	var numerosucursal=parametroBean.sucursal;
	var nombresucursal=parametroBean.nombreSucursal;
	var caja=parametroBean.cajaID;
	var montoTotal=suma(impresionPagoCredGrupal.montoPago,impresionPagoCredGrupal.montoGarantia);
	
	agregaEncabezadoSofiExpress(impresionPagoCredGrupal.folio);
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	
	agregaLinea("CLIENTE: "+impresionPagoCredGrupal.clienteID);
	agregaLinea("NOMBRE: "+impresionPagoCredGrupal.nombreCliente);
	agregaLinea("No. CUENTA: "+reemplazaCuenta(impresionPagoCredGrupal.cuentaID));
	agregaSaltoLinea(1);
	
	agregaLinea("No. CREDITO: "+impresionPagoCredGrupal.creditoID);
	agregaLinea("PROD.CRED: "+impresionPagoCredGrupal.producto);
	agregaLinea("CUOTAS PAGADAS: "+impresionPagoCredGrupal.cuotasPaga);
	agregaLinea("TOTAL DE CUOTAS: "+impresionPagoCredGrupal.totalcuotas);
	agregaSaltoLinea(1);
	
	agregaLinea("                DESGLOSE" );
	agregaLinea("     CONCEPTO:            CANTIDAD:     "    );	
	agregaLinea("_______________________________________" );
	agregaLinea("CAPITAL:          "+alinearDato(impresionPagoCredGrupal.capital,14,'$'));
	agregaLinea("INTERES:          "+alinearDato(impresionPagoCredGrupal.interes,14,'$'));
	agregaLinea("MORATORIOS:       "+alinearDato(impresionPagoCredGrupal.moratorios,14,'$'));
	agregaLinea("COMISION:         "+alinearDato(impresionPagoCredGrupal.comision,14,'$'));
	agregaLinea("COM.ADMON:        "+alinearDato(impresionPagoCredGrupal.comisionAdmon,14,'$'));
	agregaLinea("I.V.A:            "+alinearDato(impresionPagoCredGrupal.iva,14,'$'));
    if(garantiaLiquida == 'S'){
    	agregaLinea("DEPOSITO A GARANTIA LIQUIDA: "+alinearDato(impresionPagoCredGrupal.montoGarantia,10,'$'));
    }
	if(impresionPagoCredGrupal.cobraSeguroCuota =='S'){
		agregaLinea("SEGURO:           "+alinearDato(impresionPagoCredGrupal.montoSeguroCuota,14,'$'));
		agregaLinea("I.V.A SEG.:       "+alinearDato(impresionPagoCredGrupal.ivaSeguroCuota,14,'$'));
	}
	agregaLinea("_______________________________________" );
	agregaLinea("TOTAL:            "+alinearDato(cantidadFormatoMoneda(montoTotal,''),14,'$'));
	agregaSaltoLinea(1);
	
	agregaLinea("MONTO RECIBIDO:          $"+alinearDatoIzquierda(impresionPagoCredGrupal.montoRecibido,impresionPagoCredGrupal.cambio));
	agregaLinea("IMPORTE DEL PAGO:        $"+impresionPagoCredGrupal.montoPago);
	agregaLinea("CAMBIO:                  $"+alinearDatoIzquierda(impresionPagoCredGrupal.cambio,impresionPagoCredGrupal.montoRecibido));
	agregaSaltoLinea(1);
	
	cantidadEnLetras(impresionPagoCredGrupal.montoPago);
	agregaLinea("MONEDA:  "+impresionPagoCredGrupal.moneda);
	agregaSaltoLinea(1);
	
	
	agregaLinea("PROXIMO PAGO: "+(impresionPagoCredGrupal.proxFechaPago).toUpperCase());
	agregaLinea("PAGO MINIMO: $"+impresionPagoCredGrupal.montoProximoPago);
	
	agregaSaltoLinea(3);
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);	
	cortaPapel();
}

function imprimeTicketDevGL(impTicketDevGL){		
	var linea="---------------------------------------";		
 	var clienteID=completaCerosIzquierda(impTicketDevGL.clienteID ,10);
    var tituloOperacion=justificaCentro('DEVOLUCION DE GARANTIA LIQUIDA',40,' ');
    
    agregaEncabezadoSofiExpress(impTicketDevGL.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	
	agregaLinea("CLIENTE: "+clienteID);
	agregaLinea("NOMBRE:  "+impTicketDevGL.nombreCliente);
	agregaLinea("No. CUENTA: "+reemplazaCuenta(impTicketDevGL.noCuenta));
	agregaLinea("No. CREDITO:     "+impTicketDevGL.creditoID);
	agregaLinea("PROD.CRED: "+impTicketDevGL.proCred);	
	if(impTicketDevGL.ciclo > 0){
		agregaLinea("GRUPO:  "+impTicketDevGL.grupo);
		agregaLinea("CICLO:  "+impTicketDevGL.ciclo);
	}
	agregaSaltoLinea(1);
	
	agregaLinea("MONTO: $"+impTicketDevGL.monto);
	cantidadEnLetras(impTicketDevGL.monto);
	agregaLinea("MONEDA:  "+impTicketDevGL.moneda);	
	
	agregaSaltoLinea(3);	
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
   imprimeTicketCortaPapel();

}

function imprimeTicketCambioEfectivo(impresionCambioEfectivo){
	
	var linea="---------------------------------------";		
    var tituloOperacion=justificaCentro('CAMBIO DE EFECTIVO',40,' ');
    agregaEncabezadoSofiExpress(impresionCambioEfectivo.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("MONTO: $"+impresionCambioEfectivo.monto);	
	cantidadEnLetras(impresionCambioEfectivo.monto);
	agregaLinea("MONEDA: "+impresionCambioEfectivo.moneda);
	
	agregaSaltoLinea(3);	
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
	 
}

function imprimeTicketTransferencia(impresionTransfCuenta){
	var linea="---------------------------------------";		
    var tituloOperacion=justificaCentro('TRASPASO ENTRE CUENTAS',40,' ');
    
    agregaEncabezadoSofiExpress(impresionTransfCuenta.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	
	agregaLinea("CLIENTE: "+impresionTransfCuenta.clienteID);
	agregaLinea("NOMBRE: "+impresionTransfCuenta.nomCliente);
	agregaLinea("REFERENCIA: "+impresionTransfCuenta.referencia);
	agregaSaltoLinea(1);
	
	agregaLinea("No. CUENTA RETIRO: "+reemplazaCuenta(impresionTransfCuenta.cuentaRetiro));
	if(impresionTransfCuenta.etiquetaCtaRet != ''){
		agregaLinea((impresionTransfCuenta.etiquetaCtaRet).toUpperCase());
	}else{
		agregaLinea((mpresionTransfCuenta.tipoCtaRetiro).toUpperCase());
	}
	agregaSaltoLinea(1);
	
	agregaLinea("No. CUENTA DEPOSITO: "+reemplazaCuenta(impresionTransfCuenta.cuentaDeposito));
	if(impresionTransfCuenta.etiquetaCtaDep != ''){
		agregaLinea((impresionTransfCuenta.etiquetaCtaDep).toUpperCase());
	}else{
		agregaLinea((impresionTransfCuenta.tipoCtaAbono).toUpperCase());
	}
	agregaSaltoLinea(1);
	
	agregaLinea("MONTO DEL TRASPASO: $"+impresionTransfCuenta.monto);
	agregaSaltoLinea(1);
	
	cantidadEnLetras(impresionTransfCuenta.monto);
	agregaLinea("MONEDA: "+impresionTransfCuenta.moneda);
	
	agregaSaltoLinea(3);	
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
}

function imprimeTicketAportacionSocio(impresionAportaSocioBean){		
	var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(impresionAportaSocioBean.clienteID ,10);
    var tituloOperacion=justificaCentro('DEPOSITO APORTACION SOCIO',40,' ');
	
	agregaEncabezado(impresionAportaSocioBean.folio);	
	agregaLinea(linea);
    agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Socio: "+clienteID);
	agregaLinea("Nombre: "+impresionAportaSocioBean.nombreCliente);	
	agregaLinea("Monto de Deposito: $"+impresionAportaSocioBean.montoAportacion);
    agregaLinea("Moneda: "+impresionAportaSocioBean.moneda);	
    agregaLinea("Monto Recibo:      $"+alinearDatoIzquierda(impresionAportaSocioBean.montoRec,impresionAportaSocioBean.cambio));
    agregaLinea("Cambio:            $"+alinearDatoIzquierda(impresionAportaSocioBean.cambio,impresionAportaSocioBean.montoRec));
    agregaLinea("Forma de Pago:      "+"Efectivo");
    cantidadEnLetras(impresionAportaSocioBean.montoAportacion);
    agregaSaltoLinea(3);

    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();

}

function imprimeTicketDevAportacionSocioSocio(impresionDevAportaSocioBean){		
	var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(impresionDevAportaSocioBean.clienteID ,10);
    var tituloOperacion=justificaCentro('DEVOLUCION APORTACION SOCIAL',40,' ');
	
	agregaEncabezado(impresionDevAportaSocioBean.folio);	
	agregaLinea(linea);
    agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Socio: "+clienteID);
	agregaLinea("Nombre: "+impresionDevAportaSocioBean.nombreCliente);	
    agregaLinea("Monto Devolucion :      $"+impresionDevAportaSocioBean.montoDevolucion);
    agregaLinea("Moneda: "+impresionDevAportaSocioBean.moneda);	
    cantidadEnLetras(impresionDevAportaSocioBean.montoDevolucion);
    agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();

}
function imprimeTicketCobroSeguroAyuda(impresionCobroSegAyudaBean){
	var linea="---------------------------------------";		
	var clienteID=completaCerosIzquierda(impresionCobroSegAyudaBean.clienteID ,10);
	var tituloOperacion=justificaCentro('APORTACION APOYO TU AYUDA',40,' ');
	agregaEncabezado(impresionCobroSegAyudaBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Socio: "+clienteID);
	agregaLinea("Nombre:  "+impresionCobroSegAyudaBean.nombreCliente);
	agregaLinea("Monto:  $"+impresionCobroSegAyudaBean.efectivo);
	agregaLinea("Forma de Pago:" +  "Efectivo");	
	cantidadEnLetras(impresionCobroSegAyudaBean.efectivo);	
	
	agregaSaltoLinea(3);
	
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
}
function imprimeTicketAplicaSeguroAyuda(impresionAplizaSegAyudaBean){
	var linea="---------------------------------------";		
	var clienteID=completaCerosIzquierda(impresionAplizaSegAyudaBean.clienteID ,10);
	var tituloOperacion=justificaCentro('PAGO DE APOYO TU AYUDA',40,' ');
	agregaEncabezado(impresionAplizaSegAyudaBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Socio: "+clienteID);
	agregaLinea("Nombre:  "+impresionAplizaSegAyudaBean.nombreCliente);
	agregaLinea("Numero poliza: "+impresionAplizaSegAyudaBean.poliza);
	agregaLinea("Monto:  $"+impresionAplizaSegAyudaBean.efectivo);
	agregaLinea("Forma de Pago:" +  "Efectivo");	
	cantidadEnLetras(impresionAplizaSegAyudaBean.efectivo);	
	
	agregaSaltoLinea(3);
	
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
}

function imprimeTicketPagoServicio(pagoServicioBean){
	
	var parametroBean = consultaParametrosSession();
	var municipioEstado=parametroBean.edoMunSucursal;
	var fecha=parametroBean.fechaSucursal;
	var numerosucursal =parametroBean.sucursal;
	var nombresucursal =parametroBean.nombreSucursal;
	var caja=parametroBean.cajaID;
	var telefono=parametroBean.telefonoLocal;
	var tituloOperacion=justificaCentro(pagoServicioBean.tituloOperacion,40,' ');
	var linea="---------------------------------------";		
	
	var tituloOperacion=justificaCentro(pagoServicioBean.tituloOperacion,40,' ');//se arma segun el servicio
	if(pagoServicioBean.tituloOperacion =='PAGO DE REMESAS'){
	
	agregaEncabezadoSofiExpress(pagoServicioBean.folio);
	agregaLinea(linea);
	agregaLinea(justificaCentro(tituloOperacion,40,""));
	agregaSaltoLinea(1);	
	
	agregaLinea("REFERENCIA: "+pagoServicioBean.referencia);
	agregaSaltoLinea(1);
	
	agregaLinea("MONTO:                "+alinearDato(pagoServicioBean.monto,14,'$'));
	agregaSaltoLinea(1);
	
	cantidadEnLetras(pagoServicioBean.monto);
	agregaLinea("MONEDA: "+pagoServicioBean.moneda);
	agregaSaltoLinea(3);
	
	}else{
		agregaEncabezadoSofiExpress(pagoServicioBean.folio);	
		agregaLinea(linea);
		agregaLinea(tituloOperacion);
		
		agregaLinea("REFERENCIA:  "+pagoServicioBean.referencia);
		agregaSaltoLinea(1);
		
		if (pagoServicioBean.clienteID > 0 ){
			var clienteID=completaCerosIzquierda(pagoServicioBean.clienteID ,10);
			agregaLinea("CLIENTE: "+clienteID);
		}
		agregaLinea("NOMBRE:  "+pagoServicioBean.nombreCliente);
		agregaSaltoLinea(1);
		
		if (pagoServicioBean.telefonoCliente != ''){
			agregaLinea("TELEFONO:  "+pagoServicioBean.telefonoCliente);
		}
		agregaLinea("IDENTIFICACION:  "+pagoServicioBean.tipoIdentificacion);
		agregaLinea("FOLIO IDENTIFICACION: "+pagoServicioBean.folioIdentificacion);
		agregaLinea("FORMA DE PAGO: "+pagoServicioBean.formaPago);
		agregaLinea("MONTO: "+pagoServicioBean.monto);
		
		cantidadEnLetras(pagoServicioBean.monto);	
		agregaLinea("MONEDA: "+pagoServicioBean.moneda);
		agregaSaltoLinea(3);
	}
	
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
}

function reimprimirPagoRemesa(remesa){
	
	var linea="---------------------------------------";
	var tituloOperacion = 'PAGO DE REMESAS';
	
	agregaEncabezadoSofiExpress(remesa.folio);
	agregaLinea(linea);
	agregaLinea(justificaCentro(tituloOperacion,40,""));
	agregaSaltoLinea(1);
	agregaLinea("REFERENCIA:  " + remesa.referencia);
	agregaLinea("REMESADORA:  " + remesa.remesadora);
	agregaSaltoLinea(1);
	agregaLinea("MONTO: "+ remesa.monto);
	cantidadEnLetras(remesa.monto);
	agregaLinea("MONEDA: "+ remesa.moneda);
	agregaSaltoLinea(1);
	agregaLinea("BENEFICIARIO: "+ remesa.beneficiario);
	agregaLinea("FORMA PAGO: "+ remesa.formaPago);
	agregaSaltoLinea(2);
	agregaLinea("DENOMINACIONES BILLETES")
	//agregaSaltoLinea(1);
	remesa.billetes.forEach(function(k, i){
		agregaLinea(k)
	});
	agregaSaltoLinea(1);
	agregaLinea("CANTIDAD DE MONEDAS")
	agregaLinea(remesa.monedas)
	agregaSaltoLinea(3);
	
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();

}

/* SE USA PARA RECEPCION Y APLICACION */
function imprimeTicketChequeSBC(impresionChequeSBC){
	var linea="---------------------------------------";		
    var tituloOperacion=justificaCentro(impresionChequeSBC.tituloOperacion,40,' ');
    
    agregaEncabezadoSofiExpress(impresionChequeSBC.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);	
	agregaLinea("BANCO: "+impresionChequeSBC.numBanco+" "+impresionChequeSBC.nombreBanco);
	agregaLinea("CUENTA BANCO: "+reemplazaCuenta(impresionChequeSBC.cuentaEmisor));
	agregaLinea("No. CHEQUE: "+impresionChequeSBC.numCheque);	
	agregaSaltoLinea(1);
	if(impresionChequeSBC.clienteID != ''){
		agregaLinea("CLIENTE:  "+impresionChequeSBC.clienteID);
		agregaLinea("NOMBRE: "+impresionChequeSBC.nombreCliente);
		var lenght=impresionChequeSBC.numeroCuenta.length;
		var inic=lenght-4;
		var cuentaMask="*******"+impresionChequeSBC.numeroCuenta.substring(inic,lenght);
		agregaLinea("No. CUENTA: "+reemplazaCuenta(cuentaMask));
	}
	
	agregaLinea("MONTO DE DEPOSITO: $"+impresionChequeSBC.monto);
	cantidadEnLetras(impresionChequeSBC.monto);
	agregaLinea("MONEDA: "+impresionChequeSBC.moneda);
		
	agregaSaltoLinea(3);	
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
}

// funcion para imprimir el Prepago de Credito individual y grupal
function imprimirTicketPrepagoCredito(impresionPrepagoCredito,contador, tipoTicket){
	var linea="---------------------------------------";
	var clienteID=completaCerosIzquierda(impresionPrepagoCredito.clienteID ,10);
	var tituloOperacion=justificaCentro('PREPAGO DE CREDITO',40,' ');
	var PagoCreditoIndividual='I';
	
	agregaEncabezadoSofiExpress(impresionPrepagoCredito.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	
	agregaLinea("CLIENTE: "+clienteID);
	agregaLinea("NOMBRE: "+impresionPrepagoCredito.nombreCliente);
	agregaSaltoLinea(1);
	
	agregaLinea("No. CREDITO: "+impresionPrepagoCredito.creditoID);
	agregaLinea("PROD.CRED: "+impresionPrepagoCredito.proCred);
		if(impresionPrepagoCredito.ciclo > 0){
		agregaLinea("GRUPO:  "+impresionPrepagoCredito.grupo);
		agregaLinea("CICLO:  "+impresionPrepagoCredito.ciclo);
	}
	agregaSaltoLinea(1);
	
	agregaLinea("                DESGLOSE" );
	agregaLinea("     CONCEPTO             CANTIDAD   "    );	
	agregaLinea("_______________________________________" );
	agregaLinea(" CAPITAL:              "+alinearDato(impresionPrepagoCredito.capital,14,'$'));
	agregaLinea(" INTERES:              "+alinearDato(impresionPrepagoCredito.interes,14,'$'));
	agregaLinea(" MORATORIOS:           "+alinearDato(impresionPrepagoCredito.moratorios,14,'$'));
	agregaLinea(" COMISION:             "+alinearDato(impresionPrepagoCredito.comision,14,'$'));
	agregaLinea(" COM.ADMON:            "+alinearDato(impresionPrepagoCredito.comisionAdmon,14,'$'));
	agregaLinea(" I.V.A:                "+alinearDato(impresionPrepagoCredito.iva,14,'$'));
	if(impresionPrepagoCredito.cobraSeguroCuota =='S'){
		agregaLinea(" SEGURO:               "+alinearDato(impresionPrepagoCredito.montoSeguroCuota,14,'$'));
		agregaLinea(" I.V.A SEG.:           "+alinearDato(impresionPrepagoCredito.ivaSeguroCuota,14,'$'));
	}
	agregaLinea("_______________________________________" );
	agregaLinea("TOTAL:           "+alinearDato(impresionPrepagoCredito.montoPago,14,'$'));
	agregaSaltoLinea(1);
	
	if(contador==1){
		agregaLinea("MONTO RECIBIDO:         $"+alinearDatoIzquierda(impresionPrepagoCredito.montoRecibido,impresionPrepagoCredito.cambio));
		agregaLinea("IMPORTE DEL PAGO:       $"+impresionPrepagoCredito.montoPago)
		agregaLinea("CAMBIO:                 $"+alinearDatoIzquierda(impresionPrepagoCredito.cambio,impresionPrepagoCredito.montoRecibido));
		agregaSaltoLinea(1);
		
		cantidadEnLetras(impresionPrepagoCredito.montoRecibido);
		agregaLinea("FORMA DE PAGO:  EFECTIVO");
		agregaLinea("MONEDA:  "+impresionPrepagoCredito.moneda);
	}
	
	agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);	
	if (tipoTicket == PagoCreditoIndividual){
		imprimeTicketCortaPapel();
	}
}

function imprimeTicketCobroServicio(impresionPagoServicioBean){
	var linea="---------------------------------------";
	var clienteID		=completaCerosIzquierda(impresionPagoServicioBean.clienteID ,10);
	var tituloOperacion	=impresionPagoServicioBean.tituloOperacion;
	
	agregaEncabezadoSofiExpress(impresionPagoServicioBean.folio);	
	agregaLinea(linea);
	agregaLinea(justificaCentro("PAGO DE SERVICIOS",40,""));
	agregaSaltoLinea(1);
	
	agregaLinea("CONCEPTO: "+tituloOperacion);
	agregaLinea("REFERENCIA:  "+impresionPagoServicioBean.referencia);
	agregaSaltoLinea(1);
	
	if(impresionPagoServicioBean.origenServicio == 'I'){
		if(impresionPagoServicioBean.clienteID >0){
			agregaLinea("CLIENTE: "+clienteID);
			agregaLinea("NOMBRE: "+impresionPagoServicioBean.nombreCliente);
		}
		if(impresionPagoServicioBean.prospectoID >0){
			agregaLinea("PROSPECTO: "+impresionPagoServicioBean.prospectoID);			
		}
		if(impresionPagoServicioBean.creditoID >0){
			agregaLinea("No.CREDITO: "+impresionPagoServicioBean.creditoID);
		}
		agregaSaltoLinea(1);
	}
	agregaLinea("MONTO SERVICIO:  "+alinearDato(impresionPagoServicioBean.montoPagoServicio,14,'$'));
	if(impresionPagoServicioBean.origenServicio == 'I'){
		agregaLinea("IVA SERVICIO:    "+alinearDato(impresionPagoServicioBean.IvaServicio,14,'$'));
	}
	if(impresionPagoServicioBean.origenServicio == 'T'){
		agregaLinea("MONTO COMISION:  "+alinearDato(impresionPagoServicioBean.montoComision,14,'$'));
		agregaLinea("IVA COMISION:    "+alinearDato(impresionPagoServicioBean.IVAComision,14,'$'));
	}
	agregaLinea("TOTAL:           "+alinearDato(impresionPagoServicioBean.totalPagar,14,'$'));	
	agregaSaltoLinea(1);
	
	agregaLinea("MONTO RECIBIDO:  "+alinearDato(impresionPagoServicioBean.montoRecibido,14,'$'));
	agregaLinea("CAMBIO:          "+alinearDato(impresionPagoServicioBean.cambio,14,'$'));
	agregaSaltoLinea(1);
	
	cantidadEnLetras(impresionPagoServicioBean.montoRecibido);
	agregaSaltoLinea(1);
	
	agregaLinea("FORMA DE PAGO:  EFECTIVO");
	agregaLinea("MONEDA:  "+impresionPagoServicioBean.moneda);
	
	 
	
	agregaSaltoLinea(3);
	if(impresionPagoServicioBean.clienteID >0){
		agregaPiePagClienteCajero();
	}else{
		agregaPiePagCajero2();
	}
	

	agregaSaltoLinea(3);	
	cortaPapel();
	imprimeTicket();
	
}

function imprimeTicketCreditoCastigado(impresionCreditoCastigado){
	var linea="---------------------------------------";
	var clienteID=completaCerosIzquierda(impresionCreditoCastigado.clienteID ,10);
	var tituloOperacion=justificaCentro('PAGO DE CREDITO CASTIGADO',39,' ');
	var montoRecuparado= cantidadFormatoMoneda(impresionCreditoCastigado.monRecuperado,'');
	
	agregaEncabezadoSofiExpress(impresionCreditoCastigado.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	
	agregaLinea("CLIENTE: "+clienteID);
	agregaLinea("NOMBRE:  "+impresionCreditoCastigado.nombreCliente);
	agregaLinea("No.CUENTA: "+impresionCreditoCastigado.creditoID);	
	agregaSaltoLinea(1);
	
	agregaLinea("No. CREDITO: "+impresionCreditoCastigado.creditoID);
	agregaLinea("PROD.CRED:  "+impresionCreditoCastigado.descProduc);
	agregaSaltoLinea(1);
	
	agregaLinea("TOTAL CASTIGADO:     "+alinearDato(impresionCreditoCastigado.totalCastigado,14,'$'));	
	agregaLinea("TOTAL RECUPERADO:    "+alinearDato(montoRecuparado,14,'$'));
	agregaLinea("MONTO POR RECUPERAR: "+alinearDato(impresionCreditoCastigado.montoPorRecuperar,14,'$'));
	agregaLinea("MONTO DEL PAGO:      "+alinearDato(impresionCreditoCastigado.totalPagar,14,'$'));
	agregaLinea("MONTO RECIBIDO:      "+alinearDato(impresionCreditoCastigado.montoRecibido,14,'$'));	
	agregaLinea("CAMBIO:              "+alinearDato(impresionCreditoCastigado.cambio,14,'$'));	
	agregaSaltoLinea(1);
	
	cantidadEnLetras(impresionCreditoCastigado.montoRecibido);
	agregaLinea("MONEDA:  "+impresionCreditoCastigado.moneda);
		 
	agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);	
	cortaPapel();
	imprimeTicket();
	
}
/*function imprimeTicketProteccion(proteccionBean){ // creo q no se usa
	var linea="---------------------------------------";
	var clienteID=completaCerosIzquierda(proteccionBean.clienteID ,10);
	var tituloOperacion=justificaCentro(proteccionBean.tituloOperacion,39,' ');
	
	agregaEncabezado(proteccionBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre:  "+proteccionBean.nombreCliente);
	agregaLinea("No. Cuenta:  "+proteccionBean.noCuenta);
	
	agregaLinea("Beneficiario: "+proteccionBean.beneficiario);
	agregaLinea("Parentesco:   "+proteccionBean.parentesco);


	agregaSaltoLinea(1);	
	agregaLinea("Proteccion:          "+alinearDato(proteccionBean.proteccion,14,'$'));
	agregaLinea("Procentaje:          "+alinearDato(proteccionBean.porcentaje,14,'$'));
	agregaLinea("Total:               "+alinearDato(proteccionBean.totalBeneficio,14,'$'));	

	agregaSaltoLinea(1);	
	
	cantidadEnLetras(proteccionBean.totalBeneficio);
	agregaSaltoLinea(1);
		 
	agregaSaltoLinea(3);
	agregaLinea("---------------       ---------------"+"\n");
	agregaLinea("  BENEFICIARIO   "+"      "+"   CAJERO    "+"\n");
		
	agregaLinea("IMPORTANTE"+"\n");
	agregaLinea("Valido solo con la firma del cajero"+"\n");
	
	agregaSaltoLinea(3);	
	cortaPapel();
	
	
}*/
function imprimeTicketSERVIFUN(impresionPagoServifun){
	
	var linea="---------------------------------------";
	var clienteIDBen=completaCerosIzquierda(impresionPagoServifun.clienteID ,10);
	var tituloOperacion=justificaCentro('PAGO SERVIFUN',39,' ');
	var servicioCliente ='C';
	agregaEncabezado(impresionPagoServifun.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);

	
	if(impresionPagoServifun.tipoServicio == servicioCliente){
		if(impresionPagoServifun.numCteBeneficiario >0){						
			agregaLinea("Beneficiario: "+clienteIDBen);
		}
		agregaLinea("Nombre: "+impresionPagoServifun.beneficiario);	
	}else{
		agregaLinea("Cliente: "+clienteIDBen);
		agregaLinea("Nombre: "+impresionPagoServifun.beneficiario);
	}

	agregaLinea("Identificacion: "+impresionPagoServifun.tipoIdentificacion);
	agregaLinea("Folio: "+impresionPagoServifun.folioIdentificacion);
	    
	agregaSaltoLinea(1);
	agregaLinea("              DESGLOSE" );
	agregaLinea(linea);
	agregaLinea("CONCEPTO                   CANTIDAD   "    );	
	agregaLinea(linea);
	agregaLinea("BENEFICIO SERVIFUN:         "+cantidadFormatoMoneda(impresionPagoServifun.totalBeneficioNum,'$')  );	
	agregaLinea(linea );	
	agregaLinea("TOTAL:                      "+cantidadFormatoMoneda(impresionPagoServifun.totalBeneficioNum,'$')  );	
	cantidadEnLetras(impresionPagoServifun.totalBeneficio);		
	agregaSaltoLinea(1);
	//agregaLinea("El importe de este TICKET esta englobado en la factura del dia y puede ser sujeto a impuestos");	
	
	agregaSaltoLinea(3);
	agregaLinea("---------------       ---------------"+"\n");	
	if(impresionPagoServifun.tipoServicio == servicioCliente){
		agregaLinea("  BENEFICIARIO   "+"      "+"   CAJERO    "+"\n");
	}else{
		agregaLinea("    CLIENTE      "+"          "+"   CAJERO     "+"\n");
	}
	
	agregaLinea("IMPORTANTE"+"\n");
	agregaLinea("Valido solo con la firma del cajero"+"\n");
	agregaSaltoLinea(3);	
	cortaPapel();
	imprimeTicket();
	
}
function imprimeTicketPagoApoyoEscolar(impresionPagoApoyoEscolar){	
	var linea="---------------------------------------";
	var clienteApoyoEscolar=completaCerosIzquierda(impresionPagoApoyoEscolar.clienteID ,10);	
	var tituloOperacion=justificaCentro('PAGO APOYO ESCOLAR',39,' ');
	
	agregaEncabezado(impresionPagoApoyoEscolar.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);	
	

	agregaLinea("Socio: "+clienteApoyoEscolar);
	agregaLinea("Nombre: "+impresionPagoApoyoEscolar.nombreCliente);
	if(impresionPagoApoyoEscolar.personaRecibe !=''){						
		agregaLinea("Recibe Pago: "+impresionPagoApoyoEscolar.personaRecibe);
	}else{
		agregaLinea("Recibe Pago: "+impresionPagoApoyoEscolar.nombreCliente);
	}
	agregaSaltoLinea(1);
	agregaLinea("              DESGLOSE" );
	agregaLinea(linea);
	agregaLinea("CONCEPTO                   CANTIDAD   "    );	
	agregaLinea(linea);
	agregaLinea("APOYO ESCOLAR:             $"+impresionPagoApoyoEscolar.monto);	
	agregaLinea(linea );	
	agregaLinea("TOTAL:                     $"+impresionPagoApoyoEscolar.monto  );	
	cantidadEnLetras(impresionPagoApoyoEscolar.monto);		
	agregaSaltoLinea(1);

	agregaSaltoLinea(3);
	agregaPiePagSocioCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();;
	
}

//funcion que imprime ticket de pago de Anualidad de Tarjeta de Debito
function imprimeTicketAnualidad(imprimeTicketAnualTarjetaBean){
	var linea="---------------------------------------";		
	var tituloOperacion=justificaCentro('ANUALIDAD TARJETA DEBITO',38,' '); 
	var clienteID=completaCerosIzquierda(imprimeTicketAnualTarjetaBean.clienteID ,10);
	
	agregaEncabezado(imprimeTicketAnualTarjetaBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+ clienteID);
	agregaLinea("Nombre: "+ imprimeTicketAnualTarjetaBean.nombreCliente);
	agregaLinea("Tarjeta Debito: "+ imprimeTicketAnualTarjetaBean.tarjetaDebito);
	agregaLinea("No. Cuenta: "+reemplazaCuenta(imprimeTicketAnualTarjetaBean.numeroCuenta));	
	
	agregaLinea("                DESGLOSE" );
	agregaLinea("----------------------------------------" );
	agregaLinea("CONCEPTO                    CANTIDAD   "    );	
	
	agregaLinea("ANUALIDAD TARJETA DEBITO:   "+soloAlinearDato(cantidadFormatoMoneda(imprimeTicketAnualTarjetaBean.montoAnualidad,'$')),14);
	agregaLinea("I.V.A. X OTROS INGRESOS:     "+soloAlinearDato(cantidadFormatoMoneda(imprimeTicketAnualTarjetaBean.IVAMonto,'$')),14);
	agregaLinea("----------------------------------------" );
	agregaLinea("Importe Total de Movimiento:"+soloAlinearDato(cantidadFormatoMoneda(imprimeTicketAnualTarjetaBean.totalComisionTD,'$')),14);
	agregaLinea("En Efectivo:                "+soloAlinearDato(cantidadFormatoMoneda(imprimeTicketAnualTarjetaBean.montoRecibido,'$')),14);
	agregaLinea("Cambio:                       "+soloAlinearDato(cantidadFormatoMoneda(imprimeTicketAnualTarjetaBean.cambio,'$')),14);
	
	cantidadEnLetras(imprimeTicketAnualTarjetaBean.totalComisionTD.toString());
	
	
	
	agregaSaltoLinea(3);
	agregaPiePagClienteCajero();
	agregaSaltoLinea(2);
	imprimeTicketCortaPapel();
	
}

//funcion que imprime la tira auditora
function imprimeTicketTiraAuditora(valor,imprime,agregaEncabezado){
	
	if(agregaEncabezado=="S"){
	agregaEncabezadoTira();
	}
	
	agregaLinea(valor);
	if(imprime=="S"){
	
		agregaSaltoLinea(3);
		imprimeTicketCortaPapel();
	}
	   
}

//funcion que imprime cada operacion de la auditora
function impTicketDetalleTira(valor,imprime,agregaEncabezado){
	var linea="---------------------------------------";		
	if(agregaEncabezado=="S"){
	agregaEncabezadoTira();
	}
	agregaLinea(linea);
	agregaLinea(valor);
	if(imprime=="S"){
	
		agregaSaltoLinea(3);
		imprimeTicketCortaPapel();
	}
	   

}

/* FUNCION PARA TICKET DE PAGO DE CANCELACION DE SOCIO*/
function imprimeTicketPagoCancel(imprimeTicketPagoCancelBean){
	
	var linea="---------------------------------------";
	var clienteIDBen=completaCerosIzquierda(imprimeTicketPagoCancelBean.clienteID ,10);
	var tituloOperacion=justificaCentro('PAGO CANCELACION SOCIO',39,' ');
	var areaProtecciones ='Pro';
	agregaEncabezado(imprimeTicketPagoCancelBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);

	if(imprimeTicketPagoCancelBean.tipoServicio == areaProtecciones){
		agregaLinea("Nombre: "+imprimeTicketPagoCancelBean.beneficiario);	
	}else{
		agregaLinea("Cliente: "+clienteIDBen);
		agregaLinea("Nombre: "+imprimeTicketPagoCancelBean.beneficiario);
	}

	agregaLinea(linea);
	agregaLinea("Persona que recibe el Pago: "+imprimeTicketPagoCancelBean.nombreRecibe);
	
	agregaSaltoLinea(1);
	agregaLinea("              DESGLOSE" );
	agregaLinea(linea);
	agregaLinea("CONCEPTO                   CANTIDAD   "    );	
	agregaLinea(linea);
	agregaLinea("CANCELACION SOCIO:          "+cantidadFormatoMoneda(imprimeTicketPagoCancelBean.totalBeneficioNum,'$')  );
	agregaLinea(linea );	
	agregaLinea("TOTAL:                      "+cantidadFormatoMoneda(imprimeTicketPagoCancelBean.totalBeneficioNum,'$')  );	
	cantidadEnLetras(imprimeTicketPagoCancelBean.totalBeneficio);		
	agregaSaltoLinea(1);
	//agregaLinea("El importe de este TICKET esta englobado en la factura del dia y puede ser sujeto a impuestos");	
	
	agregaSaltoLinea(3);
	agregaLinea("---------------       ---------------"+"\n");	
	if(imprimeTicketPagoCancelBean.tipoServicio == areaProtecciones){
		agregaLinea("  BENEFICIARIO   "+"      "+"   CAJERO    "+"\n");
	}else{
		agregaLinea("    CLIENTE      "+"          "+"   CAJERO     "+"\n");
	}
	
	agregaLinea("IMPORTANTE"+"\n");
	agregaLinea("Valido solo con la firma del cajero"+"\n");
	agregaSaltoLinea(3);	
	cortaPapel();
	imprimeTicket();
	
}
/* FUNCION PARA TICKET  DE GASTOS O ANTICIPOS*/
function imprimeTicketGastosAnticipoSalida(imprimeTicketDevGastoAntBean){
	
	var linea="---------------------------------------";
	var tituloOperacion=justificaCentro('GASTOS/ANTICIPOS POR COMPROBAR',39,' ');
	var vacio ='';
	agregaEncabezado(imprimeTicketDevGastoAntBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	if(imprimeTicketDevGastoAntBean.empleadoID != vacio){
		agregaLinea("EMPLEADO: "+imprimeTicketDevGastoAntBean.empleadoID);
		agregaLinea("NOMBRE: "+imprimeTicketDevGastoAntBean.nombreEmpleado);
	}else{
		
	}
	agregaLinea("OPERACION: "+imprimeTicketDevGastoAntBean.operacion);
	agregaLinea("MONTO: "+cantidadFormatoMoneda(imprimeTicketDevGastoAntBean.monto,'$'));	
	agregaLinea("MONEDA: "+imprimeTicketDevGastoAntBean.moneda);
	cantidadEnLetras(imprimeTicketDevGastoAntBean.montoTotal);		
	agregaSaltoLinea(1);
	agregaSaltoLinea(3);
	
	agregaLinea("              ---------------          "+"\n");
	agregaLinea("                   RECIBI              "+"\n");	

	agregaSaltoLinea(3);	
	cortaPapel();
	imprimeTicket();
	
}

/* FUNCION PARA TICKET DE DEVOLUCION DE GASTOS O ANTICIPOS*/
function imprimeTicketDevGastosAnticipo(imprimeTicketDevGastoAntBean){
	
	var linea="---------------------------------------";
	var tituloOperacion=justificaCentro('DEVOLUCION DE GASTOS/ANTICIPOS',39,' ');
	var vacio ='';
	agregaEncabezado(imprimeTicketDevGastoAntBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	if(imprimeTicketDevGastoAntBean.empleadoID != vacio){
		agregaLinea("EMPLEADO: "+imprimeTicketDevGastoAntBean.empleadoID);
		agregaLinea("NOMBRE: "+imprimeTicketDevGastoAntBean.nombreEmpleado);
	}else{
		
	}
	agregaLinea("OPERACION: "+imprimeTicketDevGastoAntBean.operacion);
	agregaLinea("MONTO: "+cantidadFormatoMoneda(imprimeTicketDevGastoAntBean.monto,'$'));	
	agregaLinea("MONEDA: "+imprimeTicketDevGastoAntBean.moneda);
	cantidadEnLetras(imprimeTicketDevGastoAntBean.montoTotal);		
	agregaSaltoLinea(1);
	agregaSaltoLinea(3);
	
	agregaLinea("              ---------------          "+"\n");
	agregaLinea("                   CAJERO              "+"\n");	

	agregaSaltoLinea(3);	
	cortaPapel();
	imprimeTicket();
	
}

/* FUNCION PARA TICKET DE HABERES EXMENOR*/
function imprimeTicketHaberesExMenorCta(imprimeTicketHaberesExMenorBean){
	
	var linea="---------------------------------------";
	var tituloOperacion=justificaCentro('ENTREGA HABERES EXMENOR',39,' ');
	
	agregaEncabezadoSofiExpress(imprimeTicketHaberesExMenorBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("CLIENTE: "+imprimeTicketHaberesExMenorBean.menorID);
	agregaLinea("NOMBRE: "+imprimeTicketHaberesExMenorBean.nombreMenor);
	agregaLinea("No. CUENTA: "+reemplazaCuenta(imprimeTicketHaberesExMenorBean.cuentaAhoID));
	agregaSaltoLinea(1);
	
	agregaLinea("MONTO DEL RETIRO: "+imprimeTicketHaberesExMenorBean.totalHaberes);
	cantidadEnLetras(imprimeTicketHaberesExMenorBean.totalHaberes);	
	agregaLinea("MONEDA: "+imprimeTicketHaberesExMenorBean.moneda);
	
	agregaSaltoLinea(3);
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);	
	cortaPapel();
	imprimeTicket();
	
}

/* FUNCION PARA TICKET DE TRANSFERENCIA SPEI
 * 
 * */
function impTicketTransferenciaSpei(impresionTransSpeiBean){	
   var linea="---------------------------------------";		
   var tituloOperacion6=justificaCentro('TRANSFERENCIA SPEI',40,' ');
   agregaEncabezado(impresionTransSpeiBean.folio);	
   agregaLinea(linea);
   agregaLinea(tituloOperacion6);
   agregaSaltoLinea(1);
   agregaLinea("Cliente: "+impresionTransSpeiBean.clienteID);
   agregaLinea("Nombre: "+impresionTransSpeiBean.nombreCliente);
   agregaLinea("Cuenta Retiro: "+impresionTransSpeiBean.numCuenta);
   agregaSaltoLinea(1);
   
   agregaLinea("Beneficiario");
   agregaLinea("CLABE: "+impresionTransSpeiBean.cuentaBeneficiario);
   agregaLinea("Banco: "+impresionTransSpeiBean.desbancoSPEI);
   agregaLinea("Nombre: "+impresionTransSpeiBean.nombreBeneficiario);
   agregaLinea("Clave Rastreo: "+impresionTransSpeiBean.claveRastreo);	
   agregaLinea("Monto: $"+impresionTransSpeiBean.montoTransferir);
   agregaLinea("IVA: $"+impresionTransSpeiBean.pagarIVA);	
   agregaLinea("Comision SPEI: $"+impresionTransSpeiBean.comisionTrans);
   agregaLinea("IVA Comision: $"+impresionTransSpeiBean.comisionIVA);
   agregaLinea("Monto Total: $"+impresionTransSpeiBean.totalCargoCuenta);
   cantidadEnLetras(impresionTransSpeiBean.totalCargoCuenta);
   
   agregaSaltoLinea(3);
   agregaPiePagClienteCajero();
   agregaLinea("Gracias por permitirnos servirle..!");	
   agregaSaltoLinea(3);
   
  imprimeTicketCortaPapel();
}

function imprimeTicketPagoServiciosEnLinea(impresionPagoServicioBean) {
	var linea="---------------------------------------";
	var clienteID		=completaCerosIzquierda(impresionPagoServicioBean.clienteID ,10);
	var tituloOperacion	=justificaCentro(impresionPagoServicioBean.tituloOperacion,39,' ');
	var longitudAlineacion = 11;
	agregaEncabezado(impresionPagoServicioBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Monto Servicio:     "+alinearDato(impresionPagoServicioBean.montoPagoServicio,longitudAlineacion,'$'));
	agregaLinea("Comision Proveedor: "+alinearDato(impresionPagoServicioBean.comisionProveedor,longitudAlineacion,'$'));
	agregaLinea("Comision:           "+alinearDato(impresionPagoServicioBean.montoComision,longitudAlineacion,'$'));
	agregaLinea("IVA Comision:       "+alinearDato(impresionPagoServicioBean.IVAComision,longitudAlineacion,'$'))
	agregaLinea("Total:              "+alinearDato(impresionPagoServicioBean.totalPagar,longitudAlineacion,'$'));	
	agregaSaltoLinea(1);
	if(impresionPagoServicioBean.tipoFormaPago == 'E') {
		agregaLinea("Monto Recibido:     "+alinearDato(impresionPagoServicioBean.montoRecibido,longitudAlineacion,'$'));
		agregaLinea("Cambio:             "+alinearDato(impresionPagoServicioBean.cambio,longitudAlineacion,'$'));
		agregaLinea("Forma de Pago:      " + impresionPagoServicioBean.formaPago);
		agregaLinea("Moneda: " + impresionPagoServicioBean.moneda);
		cantidadEnLetras(impresionPagoServicioBean.montoRecibido);
	}
	else {
		agregaLinea("Cliente: "+clienteID);
		agregaLinea("Nombre:  "+impresionPagoServicioBean.nombreCliente);
		agregaLinea("Forma de Pago:      " + impresionPagoServicioBean.formaPago);
	}

	if(impresionPagoServicioBean.telefono != '') {
		agregaLinea("Telefono: "+impresionPagoServicioBean.telefono);	
	}

	if(impresionPagoServicioBean.referencia != '') {
		agregaLinea("Referencia: "+impresionPagoServicioBean.referencia); 
	}
	
	
	agregaSaltoLinea(3);
	if(impresionPagoServicioBean.clienteID >0){
		agregaPiePagClienteCajero();
	}else{
		agregaPiePagCajero();
	}
	
	agregaSaltoLinea(3);	
	cortaPapel();
	imprimeTicket();
}

//Funcion para mostrar los ultimos digitos de la CUENTA.
function reemplazaCuenta(cuenta){
	var cuentafinal='';
	var asteriscos="*******";
	var cuentaorigen=cuenta.substring(7,11);
	cuentafinal=asteriscos+cuentaorigen;
	return cuentafinal;
	
}

function imprimeTicketDepositoActivaCta(impresionDepositoActivaCtaBean){	
	var parametroBean = consultaParametrosSession();
	var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(impresionDepositoActivaCtaBean.clienteID ,10);    
    var tituloOperacion=justificaCentro(impresionDepositoActivaCtaBean.tituloOperacion,31,' ');//54-31
	
    agregaEncabezadoSofiExpress(impresionDepositoActivaCtaBean.folio);	
	agregaLinea(linea);    
	agregaLinea(tituloOperacion);
	
    agregaSaltoLinea(1);	
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre: "+impresionDepositoActivaCtaBean.nombreCliente);
	agregaLinea("No.Cuenta: "+impresionDepositoActivaCtaBean.noCuenta);
    agregaLinea("Producto de Cuenta: "+impresionDepositoActivaCtaBean.tipoCuenta);
	agregaLinea("Referencia: "+impresionDepositoActivaCtaBean.refCuenta);
	agregaLinea("Monto de Depósito: $"+impresionDepositoActivaCtaBean.montoDep);
    agregaLinea("Moneda: "+impresionDepositoActivaCtaBean.moneda);	
    agregaLinea("Monto Recibo:      $"+alinearDatoIzquierda(impresionDepositoActivaCtaBean.montoRec,impresionDepositoActivaCtaBean.montoDep));
    agregaLinea("Cambio:            $"+ alinearDatoIzquierda(impresionDepositoActivaCtaBean.cambio,impresionDepositoActivaCtaBean.montoDep,impresionDepositoActivaCtaBean.moneda));
    agregaLinea("Forma de Pago:      "+   "Efectivo");
    cantidadEnLetras(impresionDepositoActivaCtaBean.montoDep);
   
    agregaSaltoLinea(3);
    agregaPiePagClienteCajero();

    agregaSaltoLinea(3);	
    imprimeTicketCortaPapel();
}