   
// funcion que ingresa el encabezado.......................
function agregaEncabezadoSacimex(folio){        
	  if(applet!=null){			  
		  agregaLinea(nombreInstitucion);
		  agregaLinea(direccion);
		  agregaLinea("RFC: "+rfcInstitucion+"  Tel: "+telefono);
		  agregaLinea("Tel.Int: "+telefonoInt);
		 // agregaSaltoLinea(1); 
		  agregaLinea("Suc: "+sucursal.substring(0,15)+" "+fecha+" " +hora());
		  agregaLinea("Folio: "+folio+"    Caja: "+caja+" "+claveUsuario);    	      
	  }
	  monitorPrinting();   
	  
	}

//----------------------------REVERSAS----------------------------------------------
function impTicketReversaCobroSeguroVida(impresionCobroSeguroBean){				
	var linea="---------------------------------------";		
	var clienteID=completaCerosIzquierda(impresionCobroSeguroBean.clienteID ,10);
	var centrado=justificaCentro(impresionCobroSeguroBean.tituloOperacion,40,' ');
	agregaEncabezado(impresionCobroSeguroBean.folio);	
	agregaLinea(linea);
	agregaLinea(centrado);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre: "+impresionCobroSeguroBean.nombreCliente);
	agregaLinea("Monto: $"+impresionCobroSeguroBean.efectivo);

	cantidadEnLetras(impresionCobroSeguroBean.efectivo);		

	agregaSaltoLinea(3);
	
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();

}

function impTicketReversaAbonoCuenta(impresionAbonoCuentaBean){				
	var linea="---------------------------------------";		
	var clienteID=completaCerosIzquierda(impresionAbonoCuentaBean.clienteID ,10);	
	var centrado=justificaCentro(impresionAbonoCuentaBean.tituloOperacion,40,' ');
	agregaEncabezado(impresionAbonoCuentaBean.folio);	
	agregaLinea(linea);
	agregaLinea(centrado);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre: "+impresionAbonoCuentaBean.nombreCliente);
	agregaLinea("Cuenta: "+impresionAbonoCuentaBean.numCuenta);
	agregaLinea("Tipo Cuenta: "+impresionAbonoCuentaBean.tipoCuenta);
	agregaLinea("Referencia: "+impresionAbonoCuentaBean.referencia);	
	agregaLinea("Monto del Deposito: $"+alinearDatoIzquierda(impresionAbonoCuentaBean.efectivo,impresionAbonoCuentaBean.efectivo));
	
	agregaSaltoLinea(1);
	agregaLinea("Monto Recibido:	 $"+impresionAbonoCuentaBean.efectivo);
	agregaLinea("Cambio:        	 $"+alinearDatoIzquierda(impresionAbonoCuentaBean.cambio,impresionAbonoCuentaBean.efectivo));		
	agregaLinea("Forma de Pago: Efectivo");
	cantidadEnLetras(impresionAbonoCuentaBean.efectivo);
	agregaSaltoLinea(3);
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);		
	imprimeTicketCortaPapel();
	
	
}


function imprimeTicketReversaCargoCuenta(ticketReversaCargoCuentaBean){		
     var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(ticketReversaCargoCuentaBean.clienteID ,10);
    var tituloOperacion=justificaCentro(ticketReversaCargoCuentaBean.tituloOperacion,40,' ');
	
    agregaEncabezado(ticketReversaCargoCuentaBean.folio);	
    agregaLinea(linea);
    agregaLinea(tituloOperacion);
    agregaSaltoLinea(1);
    agregaLinea("Cliente: "+clienteID);
    agregaLinea("Nombre: "+ticketReversaCargoCuentaBean.nombreCliente);
    agregaLinea("No.Cuenta: "+ticketReversaCargoCuentaBean.noCuenta);
    agregaLinea("Tipo de Cuenta: "+ticketReversaCargoCuentaBean.tipoCuenta);
    agregaLinea("Referencia: "+ticketReversaCargoCuentaBean.refCuenta);
    agregaLinea("Monto Retiro: "+ticketReversaCargoCuentaBean.montoRet);
    agregaLinea("Moneda:       "+ticketReversaCargoCuentaBean.moneda);	
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
    agregaLinea("No.Cuenta: "+ticketReversaGarantiaLiqBean.noCuenta);
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
	agregaLinea("No.Cuenta: "+reversaDesemCreditoBean.noCuenta);
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
	agregaLinea("No.Cuenta: "+comXaperturaBean.noCuenta);
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



//--------------------INGRESOS DE OPERACIONES---------------------------------
function imprimeTicketAbonoCuenta(impresionAbonoCuentaBean){	
	var parametroBean=consultaParametrosSession();
	var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(impresionAbonoCuentaBean.clienteID ,10);    
    var tituloOperacion=justificaCentro('ABONO A CUENTA',40,' ');

	
	agregaEncabezado(impresionAbonoCuentaBean.folio);	
	agregaLinea(linea);
    agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre: "+impresionAbonoCuentaBean.nombreCliente);
	agregaLinea("No.Cuenta: "+impresionAbonoCuentaBean.noCuenta);
    agregaLinea("Tipo de Cuenta: "+impresionAbonoCuentaBean.tipoCuentaGL);
	agregaLinea("Referencia: "+impresionAbonoCuentaBean.refCuenta);

	agregaLinea("Monto de Deposito: $"+impresionAbonoCuentaBean.montoDep);

    agregaLinea("Moneda: "+impresionAbonoCuentaBean.moneda);	
    agregaLinea("Monto Recibo:      $"+alinearDatoIzquierda(impresionAbonoCuentaBean.montoRec,impresionAbonoCuentaBean.montoDep));
    agregaLinea("Cambio:            $"+ alinearDatoIzquierda(impresionAbonoCuentaBean.cambio,impresionAbonoCuentaBean.montoDep,impresionAbonoCuentaBean.moneda));
    agregaLinea("Forma de Pago:      "+   "Efectivo");
    cantidadEnLetras(impresionAbonoCuentaBean.montoDep);
    if(parametroBean.impSaldoCta =='S'){
    agregaLinea("Saldo Actual:      $"+alinearDatoIzquierda(impresionAbonoCuentaBean.saldoDispon,impresionAbonoCuentaBean.montoDep));
    }
    agregaSaltoLinea(3);

    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();

}

function imprimeTicketCargoCuenta(impresionCargoCuentaBean){		
     var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(impresionCargoCuentaBean.clienteID ,10);
    var tituloOperacion6=justificaCentro('RETIRO DE EFECTIVO',40,' ');

	
    agregaEncabezado(impresionCargoCuentaBean.folio);	
    agregaLinea(linea);
    agregaLinea(tituloOperacion6);
    agregaSaltoLinea(1);
    agregaLinea("Cliente: "+clienteID);
    agregaLinea("Nombre: "+impresionCargoCuentaBean.nombreCliente);
    agregaLinea("No.Cuenta: "+impresionCargoCuentaBean.noCuenta);
    agregaLinea("Tipo de Cuenta: "+impresionCargoCuentaBean.tipoCuenta);
    agregaLinea("Referencia: "+impresionCargoCuentaBean.refCuenta);
    agregaLinea("Monto Retiro: "+impresionCargoCuentaBean.montoRet);
    agregaLinea("Moneda:       "+impresionCargoCuentaBean.moneda);	

    cantidadEnLetras(impresionCargoCuentaBean.montoRet);
    agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
    agregaSaltoLinea(3);
    imprimeTicketCortaPapel();
}


function imprimeTicketGarantiaLiq(impresionGarantiaLiqBean){		
	var linea="---------------------------------------";		
    var clienteID=completaCerosIzquierda(impresionGarantiaLiqBean.clienteID ,10);
    var tituloOperacion2=justificaCentro('DEPOSITO DE GARANTIA LIQUIDA',40,' '); 
	
    agregaEncabezado(impresionGarantiaLiqBean.folio);	
    agregaLinea(linea);
    agregaLinea(tituloOperacion2);
    agregaSaltoLinea(1);
    agregaLinea("Cliente: "+clienteID);
    agregaLinea("Nombre: "+impresionGarantiaLiqBean.nombreCliente);
    agregaLinea("No.Cuenta: "+impresionGarantiaLiqBean.noCuenta);
    if(impresionGarantiaLiqBean.ciclo>0){
    agregaLinea("Grupo: "+impresionGarantiaLiqBean.grupo);
    agregaLinea("Ciclo: "+impresionGarantiaLiqBean.ciclo);
}
    agregaSaltoLinea(1);
    agregaLinea("No.Credito: "+impresionGarantiaLiqBean.noCredito);
    agregaLinea("Monto del Deposito: $"+impresionGarantiaLiqBean.montDep);	
    agregaLinea("Moneda: " +impresionGarantiaLiqBean.moneda);
    agregaSaltoLinea(1);
    if(impresionGarantiaLiqBean.formaPago == 'Efectivo'){
    	agregaLinea("Monto Recibo:       $"+alinearDatoIzquierda(impresionGarantiaLiqBean.montRec,impresionGarantiaLiqBean.montDep));
    	agregaLinea("Cambio:             $"+ alinearDatoIzquierda(impresionGarantiaLiqBean.cambio,impresionGarantiaLiqBean.montDep));
    }
    	agregaLinea("Forma de Pago: "+impresionGarantiaLiqBean.formaPago);
    cantidadEnLetras(impresionGarantiaLiqBean.montDep);
    agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();


}

function imprimeTicketComisionApertura(impresionComisionAperturaBean){		
	var linea="---------------------------------------";		
	var clienteID=completaCerosIzquierda(impresionComisionAperturaBean.clienteID ,10);
    var tituloOperacion3=justificaCentro('COMISION POR APERTURA',40,' ');
	
    agregaEncabezado(impresionComisionAperturaBean.folio);	
    agregaLinea(linea);
    agregaLinea(tituloOperacion3);
    agregaSaltoLinea(1);
    agregaLinea("Cliente: "+clienteID);
    agregaLinea("Nombre:  "+impresionComisionAperturaBean.nombreCliente);
    agregaLinea("No.Cuenta: "+ impresionComisionAperturaBean.noCuenta+ "  " +impresionComisionAperturaBean.desCuenta);
    agregaLinea("No.Credito:"+impresionComisionAperturaBean.NoCredito);
    agregaLinea("Prod.Cred: "+impresionComisionAperturaBean.proCred);

    if(impresionComisionAperturaBean.ciclo!=''){
    agregaLinea("Ciclo:   "+alinearDatoIzquierda(impresionComisionAperturaBean.ciclo,impresionComisionAperturaBean.comision));
    agregaLinea("Grupo:   "+impresionComisionAperturaBean.grupo);}
    agregaSaltoLinea(1);
    agregaLinea("          DESGLOSE  ");
    agregaLinea("-------------------------------");
    agregaLinea("CONCEPTO             CANTIDAD  ");
    agregaLinea("-------------------------------");
    agregaLinea("Comision:           $"+impresionComisionAperturaBean.comision);
    agregaLinea("I.V.A:              $"+alinearDatoIzquierda(impresionComisionAperturaBean.iva,impresionComisionAperturaBean.comision));
    agregaLinea("-------------------------------");
    agregaLinea("TOTAL:              $"+alinearDatoIzquierda(impresionComisionAperturaBean.total,impresionComisionAperturaBean.comision));
    agregaSaltoLinea(1);
    agregaLinea("Monto del Pago:     $"+alinearDatoIzquierda(impresionComisionAperturaBean.montPago,impresionComisionAperturaBean.comision));	
    agregaLinea("Monto Recibo:       $" +alinearDatoIzquierda(impresionComisionAperturaBean.montoReci,impresionComisionAperturaBean.comision));
    agregaLinea("Cambio:             $"+alinearDatoIzquierda(impresionComisionAperturaBean.cambio,impresionComisionAperturaBean.comision));
    agregaLinea("Moneda:             " +alinearDatoIzquierda(impresionComisionAperturaBean.moneda,impresionComisionAperturaBean.comision));
    agregaLinea("Forma de Pago:"   +  "Efectivo");
    cantidadEnLetras(impresionComisionAperturaBean.total);
   
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
    
	agregaEncabezado(impresionDesemCreditoBean.folio);	
	agregaLinea(linea);
    agregaLinea(tituloOperacion8);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre: "+impresionDesemCreditoBean.nombreCliente);
	agregaLinea("No.Cuenta: "+impresionDesemCreditoBean.noCuenta);
	agregaLinea("Tipo de Cuenta: "+impresionDesemCreditoBean.tipoCuenta);
	agregaLinea("Credito: "+impresionDesemCreditoBean.credito);
	agregaLinea("Moneda:  "+impresionDesemCreditoBean.moneda);
   	
    agregaLinea("Monto del Credito:      $"+soloAlinearDato(impresionDesemCreditoBean.montoCred,14));
	agregaLinea("Monto Recibido Anterior:$"+soloAlinearDato(impresionDesemCreditoBean.monRecAnt,14));
	agregaLinea("Monto del Retiro:       $"+soloAlinearDato(impresionDesemCreditoBean.montRet,14));

	agregaLinea("Monto Pendiente:        $"+soloAlinearDato(montoPendiente,14));
        if(impresionDesemCreditoBean.ciclo >0 ){
	agregaLinea("Grupo: "+impresionDesemCreditoBean.grupo);	
	agregaLinea("Ciclo: "+impresionDesemCreditoBean.ciclo);
	}
    cantidadEnLetras(impresionDesemCreditoBean.montRet);
    agregaSaltoLinea(3);
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
   imprimeTicketCortaPapel();
	
}




/*  Para el pago de Credito grupal e individual	 y de la garantia liquida  */		
function imprimirTicketPagCredGrupal(impresionPagoCredGrupal,numeroTicket,garantiaLiquida){
	var linea="---------------------------------------";
	var clienteID=completaCerosIzquierda(impresionPagoCredGrupal.clienteID ,10);
	var tituloOperacion=justificaCentro('COMPROBANTE PAGO DE CREDITO',38,' ');
	var parametroBean=consultaParametrosSession();
	var montoTotal=suma(impresionPagoCredGrupal.montoPago,impresionPagoCredGrupal.montoGarantia);
	var totalAdeudo=(impresionPagoCredGrupal.totalAdeudoPend).replace(',','');


	agregaEncabezadoSacimex(impresionPagoCredGrupal.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaLinea("Cliente: "+clienteID+"  Credito: "+impresionPagoCredGrupal.creditoID);
	if(garantiaLiquida == 'S'){
		agregaLinea("Cta: "+impresionPagoCredGrupal.cuentaID);
	}
	agregaLinea("Nombre: "+impresionPagoCredGrupal.nombreCliente);
	agregaLinea("Monto Recibido: $"+impresionPagoCredGrupal.montoRecibido+" Cambio:$"+impresionPagoCredGrupal.cambio);	
	// fecha: 14-11-2013 se descomentarizan estas 2 lineas a peticion de FCHIA
	if (parametroBean.impSaldoCred =='S'){
	agregaLinea("Monto Proximo Pago: $"+impresionPagoCredGrupal.montoProximoPago);
	agregaLinea("Fecha Proximo Pago: "+impresionPagoCredGrupal.proxFechaPago);
	agregaLinea("Total Adeudo: "+cantidadFormatoMoneda(totalAdeudo,'$'));
	}
	agregaLinea("Forma Pago: Efectivo"+"    Moneda: "+impresionPagoCredGrupal.moneda);	
	//agregaLinea("Monto del Pago: "+cantidadFormatoMoneda(montoTotal,'$')); se comentó esta linea a peticion de Sandra
	if(impresionPagoCredGrupal.ciclo > 0){
		agregaLinea("Grupo:"+impresionPagoCredGrupal.grupo+" "+"Ciclo:"+impresionPagoCredGrupal.ciclo);
	}
	agregaLinea("          DESGLOSE" );
	agregaLinea("----------------------------" );
	agregaLinea("CONCEPTO       CANTIDAD   "    );	
	agregaLinea("----------------------------" );
	agregaLinea("Capital:   "+alinearDato(impresionPagoCredGrupal.capital,14,'$'));
	agregaLinea("Interes:   "+alinearDato(impresionPagoCredGrupal.interes,14,'$'));
	agregaLinea("Moratorios:"+alinearDato(impresionPagoCredGrupal.moratorios,14,'$'));
	agregaLinea("Comision:  "+alinearDato(impresionPagoCredGrupal.comision,14,'$'));
	agregaLinea("Com.Admon: "+alinearDato(impresionPagoCredGrupal.comisionAdmon,14,'$'));
	agregaLinea("I.V.A:     "+alinearDato(impresionPagoCredGrupal.iva,14,'$'));
	if(garantiaLiquida == 'S'){
		agregaLinea("Dep. Garantia: "+alinearDato(impresionPagoCredGrupal.montoGarantia,10,'$'));
	}	
	agregaLinea("----------------------------" );
	agregaLinea("TOTAL:     "+alinearDato(cantidadFormatoMoneda(montoTotal,''),14,'$'));
	cantidadEnLetras(montoTotal.toString());
	agregaSaltoLinea(1);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(1);	
	cortaPapel();

}

function imprimeTicketDevGL(impTicketDevGL){		
	var linea="---------------------------------------";		
 	var clienteID=completaCerosIzquierda(impTicketDevGL.clienteID ,10);
    var tituloOperacion=justificaCentro('DEVOLUCION DE GARANTIA LIQUIDA',40,' ');
    
	agregaEncabezado(impTicketDevGL.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre:  "+impTicketDevGL.nombreCliente);
	agregaLinea("No.Cuenta:  "+impTicketDevGL.noCuenta);
	agregaLinea("Tipo de Cuenta: "+impTicketDevGL.tipoCuenta);
	agregaLinea("No.Credito:     "+impTicketDevGL.creditoID);		
	
	if(impTicketDevGL.ciclo > 0){
		agregaLinea("Grupo:  "+impTicketDevGL.grupo);
		agregaLinea("Ciclo:  "+impTicketDevGL.ciclo);
	}
	agregaSaltoLinea(1);
	agregaLinea("Monto: $"+impTicketDevGL.monto);	
	agregaLinea("Moneda:  "+impTicketDevGL.moneda);	
	cantidadEnLetras(impTicketDevGL.monto);
	agregaSaltoLinea(3);	
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
   imprimeTicketCortaPapel();

}

function imprimeTicketCambioEfectivo(impresionCambioEfectivo){
	var linea="---------------------------------------";		
    var tituloOperacion=justificaCentro('CAMBIO DE EFECTIVO',40,' ');
    
	agregaEncabezado(impresionCambioEfectivo.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Monto: $"+impresionCambioEfectivo.monto);	
	cantidadEnLetras(impresionCambioEfectivo.monto);
	agregaSaltoLinea(3);	
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
	 
}

function imprimeTicketTransferencia(impresionTransfCuenta){
	var linea="---------------------------------------";		
    var tituloOperacion=justificaCentro('TRASPASO ENTRE CUENTAS',40,' ');
    
	agregaEncabezado(impresionTransfCuenta.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+impresionTransfCuenta.clienteID);
	agregaLinea("Nombre: "+impresionTransfCuenta.nomCliente);
	agregaLinea("Referencia: "+impresionTransfCuenta.referencia);
	agregaSaltoLinea(1);
	agregaLinea("Cuenta Retiro:   "+impresionTransfCuenta.cuentaRetiro);
	
	if(impresionTransfCuenta.etiquetaCtaRet != ''){
		agregaLinea(impresionTransfCuenta.etiquetaCtaRet);
	}else{
		agregaLinea(mpresionTransfCuenta.tipoCtaRetiro);
	}
	
	agregaLinea("Cuenta Deposito: "+ completaCerosIzquierda(impresionTransfCuenta.cuentaDeposito, 11));	
	
	if(impresionTransfCuenta.etiquetaCtaDep != ''){
		agregaLinea(impresionTransfCuenta.etiquetaCtaDep);
	}else{
		agregaLinea(impresionTransfCuenta.tipoCtaAbono);
	}
	
	agregaLinea("Monto: $"+impresionTransfCuenta.monto);
	cantidadEnLetras(impresionTransfCuenta.monto);
	
	
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
	var linea="---------------------------------------";		
	
	var tituloOperacion=justificaCentro(pagoServicioBean.tituloOperacion,40,' ');
	agregaEncabezado(pagoServicioBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	//agregaSaltoLinea(1);
	
	agregaLinea("Referencia:  "+pagoServicioBean.referencia);
	if (pagoServicioBean.clienteID > 0 ){
		var clienteID=completaCerosIzquierda(pagoServicioBean.clienteID ,10);
		agregaLinea("Socio: "+clienteID);
	}
	
	agregaLinea("Nombre:  "+pagoServicioBean.nombreCliente);
	if (pagoServicioBean.telefonoCliente != ''){
		agregaLinea("Telefono:  "+pagoServicioBean.telefonoCliente);
	}
	
	agregaLinea("Identificacion:  "+pagoServicioBean.tipoIdentificacion);
	agregaLinea("Folio identificacion: "+pagoServicioBean.folioIdentificacion);
	
	agregaLinea("Forma de Pago: "+pagoServicioBean.formaPago);
	if(pagoServicioBean.formaPago == "Deposito a Cuenta"){
		agregaLinea("No.Cuenta: "+pagoServicioBean.numeroCuenta);
	}
	agregaLinea("Monto: $"+pagoServicioBean.monto);
	agregaLinea("Moneda: "+pagoServicioBean.moneda);
	cantidadEnLetras(pagoServicioBean.monto);	
	agregaSaltoLinea(3);
	
	agregaPiePagClienteCajero();
	agregaSaltoLinea(3);
	imprimeTicketCortaPapel();
}

function imprimeTicketChequeSBC(impresionChequeSBC){
	var linea="---------------------------------------";		
    var tituloOperacion=justificaCentro(impresionChequeSBC.tituloOperacion,40,' ');
    
	agregaEncabezado(impresionChequeSBC.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);	
	agregaLinea("Banco: "+impresionChequeSBC.numBanco+" "+impresionChequeSBC.nombreBanco);
	agregaLinea("Cuenta Banco: "+impresionChequeSBC.cuentaEmisor);
	agregaLinea("No. Cheque: "+impresionChequeSBC.numCheque);	
	//agregaLinea("Emisor: "+impresionChequeSBC.emisor);
	agregaSaltoLinea(1);
	agregaLinea("Socio:  "+impresionChequeSBC.clienteID);
	agregaLinea("Nombre: "+impresionChequeSBC.nombreCliente);	
	agregaLinea("Cuenta: "+impresionChequeSBC.numeroCuenta);
	
	agregaLinea("Monto: $"+impresionChequeSBC.monto);
	cantidadEnLetras(impresionChequeSBC.monto);
		
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
	
	agregaEncabezado(impresionPrepagoCredito.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre: "+impresionPrepagoCredito.nombreCliente);
	agregaLinea("No.Credito: "+impresionPrepagoCredito.creditoID);
	agregaLinea("Monto del Pago:     $"+impresionPrepagoCredito.montoPago);	
	agregaLinea("Moneda:  "+impresionPrepagoCredito.moneda);

	if(impresionPrepagoCredito.ciclo > 0){
		agregaLinea("Grupo:  "+impresionPrepagoCredito.grupo);
		agregaLinea("Ciclo:  "+impresionPrepagoCredito.ciclo);
	}
	agregaSaltoLinea(1);
	agregaLinea("          DESGLOSE" );
	agregaLinea("----------------------------" );
	agregaLinea("CONCEPTO       CANTIDAD   "    );	
	agregaLinea("----------------------------" );
	agregaLinea("Capital:   "+alinearDato(impresionPrepagoCredito.capital,14,'$'));
	agregaLinea("Interes:   "+alinearDato(impresionPrepagoCredito.interes,14,'$'));
	agregaLinea("Moratorios:"+alinearDato(impresionPrepagoCredito.moratorios,14,'$'));
	agregaLinea("Comision:  "+alinearDato(impresionPrepagoCredito.comision,14,'$'));
	agregaLinea("Com.Admon: "+alinearDato(impresionPrepagoCredito.comisionAdmon,14,'$'));
	agregaLinea("I.V.A:     "+alinearDato(impresionPrepagoCredito.iva,14,'$'));
	agregaLinea("----------------------------" );
	agregaLinea("TOTAL:     "+alinearDato(impresionPrepagoCredito.montoPago,14,'$'));
	cantidadEnLetras(impresionPrepagoCredito.montoPago);
	agregaSaltoLinea(1);

	if(contador==1){
		agregaLinea("Monto Recibido: $"+alinearDatoIzquierda(impresionPrepagoCredito.montoRecibido,impresionPrepagoCredito.cambio));
		agregaLinea("Cambio:         $"+alinearDatoIzquierda(impresionPrepagoCredito.cambio,impresionPrepagoCredito.montoRecibido));
		agregaLinea("Forma de Pago:  Efectivo");
		cantidadEnLetras(impresionPrepagoCredito.montoRecibido);
	}
		 
	agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);	
	cortaPapel();
	if (tipoTicket == PagoCreditoIndividual){
		imprimeTicket();
	}
	
}


function imprimeTicketCobroServicio(impresionPagoServicioBean){
	var linea="---------------------------------------";
	var clienteID		=completaCerosIzquierda(impresionPagoServicioBean.clienteID ,10);
	var tituloOperacion	=justificaCentro(impresionPagoServicioBean.tituloOperacion,39,' ');
	
	agregaEncabezado(impresionPagoServicioBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	if(impresionPagoServicioBean.origenServicio == 'I'){
		if(impresionPagoServicioBean.clienteID >0){
			agregaLinea("Cliente: "+clienteID);
			agregaLinea("Nombre: "+impresionPagoServicioBean.nombreCliente);
		}
		if(impresionPagoServicioBean.prospectoID >0){
			agregaLinea("Prospecto: "+impresionPagoServicioBean.prospectoID);			
		}
		if(impresionPagoServicioBean.creditoID >0){
			agregaLinea("No.Credito: "+impresionPagoServicioBean.creditoID);
		}
		agregaSaltoLinea(1);
	}
	agregaLinea("Monto Servicio:  "+alinearDato(impresionPagoServicioBean.montoPagoServicio,14,'$'));
	if(impresionPagoServicioBean.origenServicio == 'I'){
		agregaLinea("IVA Servicio:    "+alinearDato(impresionPagoServicioBean.IvaServicio,14,'$'));
	}
	if(impresionPagoServicioBean.origenServicio == 'T'){
		agregaLinea("Monto Comision:  "+alinearDato(impresionPagoServicioBean.montoComision,14,'$'));
		agregaLinea("IVA Comision:    "+alinearDato(impresionPagoServicioBean.IVAComision,14,'$'));
	}
	agregaLinea("Total:           "+alinearDato(impresionPagoServicioBean.totalPagar,14,'$'));	
	agregaSaltoLinea(1);
	agregaLinea("Monto Recibido:  "+alinearDato(impresionPagoServicioBean.montoRecibido,14,'$'));
	agregaLinea("Cambio:          "+alinearDato(impresionPagoServicioBean.cambio,14,'$'));
	agregaLinea("Forma de Pago:  Efectivo");
	agregaLinea("Moneda:  "+impresionPagoServicioBean.moneda);
	cantidadEnLetras(impresionPagoServicioBean.montoRecibido);
	agregaLinea("Referencia:  "+impresionPagoServicioBean.referencia); 
	
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

function imprimeTicketCreditoCastigado(impresionCreditoCastigado){
	var linea="---------------------------------------";
	var clienteID=completaCerosIzquierda(impresionCreditoCastigado.clienteID ,10);
	var tituloOperacion=justificaCentro('PAGO DE CREDITO CASTIGADO',39,' ');
	var montoRecuparado= cantidadFormatoMoneda(impresionCreditoCastigado.monRecuperado,'');
	agregaEncabezado(impresionCreditoCastigado.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+clienteID);
	agregaLinea("Nombre:  "+impresionCreditoCastigado.nombreCliente);
	agregaLinea("No.Credito: "+impresionCreditoCastigado.creditoID);	
	agregaLinea("Producto Credito:  "+impresionCreditoCastigado.descProduc);
	agregaSaltoLinea(1);
	agregaLinea("Total Castigado:     "+alinearDato(impresionCreditoCastigado.totalCastigado,14,'$'));	
	agregaLinea("Total Recuperado:    "+alinearDato(montoRecuparado,14,'$'));
	agregaLinea("Monto por Recuperar: "+alinearDato(impresionCreditoCastigado.montoPorRecuperar,14,'$'));
	agregaLinea("Monto del Pago:      "+alinearDato(impresionCreditoCastigado.totalPagar,14,'$'));
	
	agregaLinea("Monto Recibido:      "+alinearDato(impresionCreditoCastigado.montoRecibido,14,'$'));	
	agregaLinea("Cambio:              "+alinearDato(impresionCreditoCastigado.cambio,14,'$'));	
	agregaLinea("Moneda:  "+impresionCreditoCastigado.moneda);

	agregaSaltoLinea(1);	
	cantidadEnLetras(impresionCreditoCastigado.montoRecibido);
	agregaSaltoLinea(1);
		 
	agregaSaltoLinea(3);
    agregaPiePagClienteCajero();
	agregaSaltoLinea(3);	
	cortaPapel();
	imprimeTicket();
	
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
	agregaLinea("No. Cuenta: "+ imprimeTicketAnualTarjetaBean.numeroCuenta);	
	
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
/* FUNCION PARA TICKET  DE GASTOS O ANTICIPOS*/
function imprimeTicketGastosAnticipoSalida(imprimeTicketDevGastoAntBean){
	
	var linea="---------------------------------------";
	var tituloOperacion=justificaCentro('GASTOS/ANTICIPOS POR COMPROBAR',39,' ');
	var vacio ='';
	console.log("anticipos de salida");
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
	console.log("anticipos de entrada");
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
	
	agregaEncabezado(imprimeTicketHaberesExMenorBean.folio);	
	agregaLinea(linea);
	agregaLinea(tituloOperacion);
	agregaSaltoLinea(1);
	agregaLinea("Cliente: "+imprimeTicketHaberesExMenorBean.menorID);
	agregaLinea("Nombre: "+imprimeTicketHaberesExMenorBean.nombreMenor);
	agregaLinea("No.Cuenta: "+imprimeTicketHaberesExMenorBean.cuentaAhoID);
	agregaLinea("Tipo de Cuenta: "+imprimeTicketHaberesExMenorBean.descripcion);	
	agregaLinea("Ahorro: "+cantidadFormatoMoneda(imprimeTicketHaberesExMenorBean.monto,'$'));
	agregaLinea("Moneda: "+imprimeTicketHaberesExMenorBean.moneda);
	cantidadEnLetras(imprimeTicketHaberesExMenorBean.totalHaberes);		
	agregaSaltoLinea(1);
	agregaSaltoLinea(3);
	agregaLinea("---------------       ---------------"+"\n");	
	agregaLinea("    CLIENTE      "+"          "+"   CAJERO     "+"\n");
	agregaLinea("IMPORTANTE"+"\n");
	agregaLinea("Valido solo con la firma del cajero"+"\n");
	agregaSaltoLinea(3);	
	cortaPapel();
	imprimeTicket();
	
}




