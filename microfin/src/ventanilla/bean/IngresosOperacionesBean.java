package ventanilla.bean;

import general.bean.BaseBean;

import java.util.List;

public class IngresosOperacionesBean extends BaseBean{
	// **CONSTANTES
	public static String tipoMovCargoCuenta 	= "11";	// corresponde con la tabla TIPOSMOVSAHO 
	public static String tipoMovAbonoCuenta 	= "10"; // corresponde con la tabla TIPOSMOVSAHO 
	public static String tipoMovTraspasoCuenta	="12";	// corresponde con la tabla TIPOSMOVSAHO	
	public static String tipoMovComApertura		="83";	// corresponde con la tabla TIPOSMOVSAHO	
	public static String tipoMovDepGL			="102";	// corresponde con la tabla TIPOSMOVSAHO
	public static String tipoMovPagoRemesa		="24";	// corresponde con la tabla TIPOSMOVSAHO
	public static String tipoMovPagoOportun		="25";	// corresponde con la tabla TIPOSMOVSAHO
	public static String tipoMovCargoCtaCheque	="107";	// corresponde con la tabla TIPOSMOVAHO
	public static String tipoMovAccesCredito 	= "108"; // corresponde con la tabla TIPOSMOVSAHO 
	
	public static String cargoCta 				= "C"; 	// Naturaleza del movimientos de Cuenta de ahorro
	public static String abonoCta 				= "A"; 	// Naturaleza del movimientos de Cuenta de ahorro
	public static String altaEnPolizaSi 		= "S"; 	// Indica si se inserta en POLIZACONTABLE
	public static String altaEnPolizaNo 		= "N"; 	// Indica si se inserta en POLIZACONTABLE
	public static String concepContaDepVent 	= "30"; // corresponde con la tabla	CONCEPTOSCONTA
	public static String concepContaComApCre 	= "31"; // corresponde con la tabla CONCEPTOSCONTA
	public static String concepContaDesCreVen 	= "32"; // corresponde con la tabla CONCEPTOSCONTA
	public static String concepPagoSegVida	 	= "33"; // corresponde con la tabla CONCEPTOSCONTA pago del seguro de vida
	public static String concepCobroSegVida	 	= "34"; // corresponde con la tabla CONCEPTOSCONTA Cobro del seguro de vida
	public static String concepDevolucionGL	 	= "62"; // corresponde con la tabla CONCEPTOSCONTA Devolucion de GL
	public static String concepTransfeCuentas	= "90"; // corresponde con la tabla CONCEPTOSCONTA Transferencias Entre Cuentas Propias	
	public static String concepBloqGarLiq		= "64";	// corresponde con la tabla CONCEPTOSCONTA Bloqueo de Garantia Liquida 
	public static String concepAportacionSocio	="400"; // Corresponde con la tabla CONCEPTOSCONTA Pago Aportacion de Socio
	public static String concepDevAportacionSocio	="401"; // Corresponde con la tabla CONCEPTOSCONTA Devolucion de Aportacion de Socio
	public static String ConContaCobSegVida		="402";  //Concepto Contable de cobro seguro de vida ayuda tabla CONCEPTOSCONTA
	public static String ConContaAplSegVida		="409";    //Concepto Contable de aplicacion seguro de vida ayuda tabla CONCEPTOSCONTA
	public static String conContaPagoCancSocio	="805";		//Concepto Contable de Pago de Cancelacion de Socio tabla CONCEPTOSCONTA
	public static String conContaPagoServ		="500";		//Concepto Contable de Pago de Servicios tabla CONCEPTOSCONTA
	public static String conceptoConAnticipos	="501";		//Concepto Contable de Gastos y Anticípos tabla CONCEPTOSCONTA
	public static String concepContaAjusteFalt	="411";		//Concepto Contable de Ajuste de Faltantes tabla CONCEPTOSCONTA
	public static String concepContaAjusteSob	="410";		//Concepto Contable de Ajuste de Sobrantes tabla CONCEPTOSCONTA
	public static String concepContaPagTarDebAnual="301";	//Concepto Contable de Pago de Anualidad de Tarjetas tabla CONCEPTOSCONTA
	public static String concepContaApoyoEscolar ="803";	//Concepto Contable de Apoyo Escolar tabla CONCEPTOSCONTA
	public static String concepContaPagoServifun ="801";	//Concepto Contable de Pago Servifun tabla CONCEPTOSCONTA
	public static String concepContaRecCarteraCas="63";		//Concepto Contable de Recuperacion de Cartera Castigada tabla CONCEPTOSCONTA
	public static String concepContaAplicaCheqInt="43";		//Concepto Contable de Aplica Cheque SBC cobro CTA INTERNA tabla CONCEPTOSCONTA
	public static String concepContaAplicaCheqExt="42";		//Concepto Contable de Aplica Cheque SBC cobro CTA EXTERNA tabla CONCEPTOSCONTA
	public static String concepContaPrepagCredGrupal="54";	//Concepto Contable de Prepago de Credito Grupal tabla CONCEPTOSCONTA
	public static String conceptoContaPagArrenda	="839"; //Concepto contable de pago de arrendamiento tabla de CONCEPTOSCONTA
	public static String conceptoContaPagoServLinea	="1001"; //Concepto contable de Pago de Servicios en Linea tabla de CONCEPTOSCONTA
	public static String opeTransferEnvBanco		= "80";		//CONCEPTO CONTABLE DE TRANSFERENCIA ENTRE BANCOS ENVIO
	public static String opeTransferRecBanco		= "81";		//CONCEPTO CONTABLE DE RECEPCION DE TRANSFERENCIA ENTRE BANCOS 
	public static String contaCobroAccesoriosCre	= "68"; // Concepto contable para cobro de accesorio tabla CONCEPTOSCONTA
	public static String concepBloqGarFOGAFI		= "48";		// Concepto contable para el bloqueo de garantía FOGAFI
	public static String concepDesbGarFOGAFI		= "49";		// Concepto contable para el bloqueo de garantía FOGAFI
	//reversas
	public static String tipoMovDesemCredRev		= "300";	// corresponde con la tabla TIPOSMOVSAHO reversa de desembolso de credito
	public static String tipoMovcomAperCredRev		= "301";	// corresponde con la tabla TIPOSMOVSAHO reversa de comision por apertura del credito
	public static String tipoMovCargoCuentaRev		= "304";	// corresponde con la tabla TIPOSMOVSAHO reversa de Cargo a cuenta
	public static String tipoMovAbonoCuentaRev		= "305";	// corresponde con la tabla TIPOSMOVSAHO reversa de Abono a cuenta
	public static String tipoMovDepGarLiqRev		= "306";	// corresponde con la tabla TIPOSMOVSAHO reversa de deposito de garantia liquida			
	public static String tipoMovsAccesCreRev		= "308";	// Corresponde con la tabla TIPOSMOVSAHO para la reversa de cobro de Accesorios
	
	public static String reversaConcepCobroSegVida	= "35"; // corresponde con la tabla CONCEPTOSCONTA reversa del Cobro del seguro de vida
	public static String reversaconcepContaDepVent 	= "36"; // corresponde con la tabla CONCEPTOSCONTA reversa del deposito en ventanilla
	public static String reversaConContaAplicSegVida= "37"; // corresponde con la tabla CONCEPTOSCONTA reversa de Aplicacion de Seguro de Vida
	public static String reversaConcepContaDesCred	= "38"; // corresponde con la tabla CONCEPTOSCONTA reversa por desembolso del credito
	public static String reversaConcepContaDepGarLiq= "39"; // corresponde con la tabla CONCEPTOSCONTA reversa por deposito de garantia liquida
	public static String reversaconcepContaCargoCta = "40"; // corresponde con la tabla CONCEPTOSCONTA reversa por Cargo a Cuenta
	public static String reversaconcepContaAbonoCta = "41"; // corresponde con la tabla CONCEPTOSCONTA reversa por Abono a Cuenta
	public static String reversaconcepContaComApCre = "61"; // corresponde con la tabla CONCEPTOSCONTA reversa por Deposito Comision x apertura
	public static String reversaContaCobroAccesCre 	= "69"; // Corresponde con la tabla CONCEPTOSCONTA reversa de cobro de accesorios de crédito

	// public static String reversaconcepContaDepVent 	= "36"; // corresponde con la tabla CONCEPTOSCONTA por REVERSA del deposito en ventanilla
	//public static String reversaConcepConta
	
	public static String altaEnDetPolizaSi 	= "S";	// Indica si se inserta en DETALLEPOLIZA
	public static String altaEnDetPolizaNo 	= "N"; 	// Indica si se inserta en DETALLEPOLIZA
	public static String conceptoAhorro 	= "1"; 	//  corresponde con la tabla CONCEPTOSAHORRO
	public static String conceptoAhorroGL 	= "30"; //  corresponde con la tabla CONCEPTOSAHORRO es el concepto de la Garantia Liquida
	public static String opeCajEntEfCta		= "1"; 	// Corresponde con la Tabla CAJATIPOSOPERA Entrada Efectivo Deposito Cuenta
	public static String opeCajSalDepCta	= "21";	// Corresponde con la Tabla CAJATIPOSOPERA Deposito Cuenta
	public static String opeCajCarCta		= "11"; // Corresponde con la Tabla CAJATIPOSOPERA Cargo Cuenta
	public static String opeCajSalEfCta		= "31"; // Corresponde con la Tabla CAJATIPOSOPERA Salida  Efectivo Por Cargo a Cuenta
	public static String opeCajEntCambio	= "6"; 	// Corresponde con la Tabla CAJATIPOSOPERA Entrada de Efectivo por Cambio
	public static String opeCajSalCambio	= "26";	// Corresponde con la Tabla CAJATIPOSOPERA Salida  de Efectivo por Cambio
	public static String opeCajEntComApCre 	= "3";	// Corresponde con la Tabla CAJATIPOSOPERA Entrada por Com x Ap Cred
	public static String opeCajSalComApCre	= "23";	// Corresponde con la Tabla CAJATIPOSOPERA Salida  por Com x Ap Cred
	public static String opeCajEntDesCre 	= "10";	// Corresponde con la Tabla CAJATIPOSOPERA Entrada por Desembolso Cred
	public static String opeCajSalDesCre	= "30";	// Corresponde con la Tabla CAJATIPOSOPERA Salida  por Desembolso Cred
	public static String opeCajEntGarLiq 	=  "2";	// corresponde con la tabla CAJATIPOSOPERA Entrada Efec Garantia Liquida
	public static String opeCajDepGarLiq 	= "22";	// corresponde con la tabla CAJATIPOSOPERA Deposito de Garantia Liquida
	public static String opeCajEntPagCre	= "8";	// Corresponde con la Tabla CAJATIPOSOPERA Entrada Efectivo 	Pago Credito
	public static String opeCajSalPagCre 	= "28";	// Corresponde con la Tabla CAJATIPOSOPERA Pago de Credito
	public static String opeCajEntDevGL 	= "15";	// corresponde con la tabla CAJATIPOSOPERA Devolucion Garantia Liquida
	public static String opeCajSalDevGL 	= "35";	// corresponde con la tabla CAJATIPOSOPERA Salida devolucion de Garantia Liquida  35	
	public static String opeCajRecBanco 	= "16";	// corresponde con la tabla CAJATIPOSOPERA Recepcion de efectivo a bancos
	public static String opeCajSalRecBanco 	= "36";	// corresponde con la tabla CAJATIPOSOPERA Salida Recepcion de efectivo a bancos
	public static String opeCajEnvBanco 	= "42";	// corresponde con la tabla CAJATIPOSOPERA Envio Efectivo a Bancos bancos
	public static String opeCajEntEnvBanco 	= "41";	// corresponde con la tabla CAJATIPOSOPERA Entrada Envio Efectivo a Bancos	
	public static String opeCajRecTransCaj 		= "19";	// corresponde con la tabla CAJATIPOSOPERA Recepcion  Transferencia entre Cajas
	public static String opeCajSalRecTransCaj	= "39";	// corresponde con la tabla CAJATIPOSOPERA Salida Recepcion Transferencia entre cajas 
	public static String opeCajEntTransCaj 		= "20";	// corresponde con la tabla CAJATIPOSOPERA Entrada Transferencia entre Cajas
	public static String opeCajTransCaj			= "40";	// corresponde con la tabla CAJATIPOSOPERA Transferencia entre cajas
	public static String opeCajEntGLAdi 		= "43";	// corresponde con la tabla CAJATIPOSOPERA ENTRADA EFECTIVO GARANTIA LIQUIDA ADICIONAL
	public static String opeCajDepGLAdic		= "44";	// corresponde con la tabla CAJATIPOSOPERA DEPOSITO GARANTIA LIQUIDA ADICIONAL 
	public static String opeCajaSalpagoseguroVida 	= "37";	// corresponde con la tabla CAJATIPOSOPERA Salida de efctivo por el pago del seguro de Vida
	public static String opeCajaEntpagoseguroVida 	= "17";	// corresponde con la tabla CAJATIPOSOPERA Entrada de efctivo por el pago del seguro de Vida	
	public static String opeCajaSalCobroseguroVida 	= "38";	// corresponde con la tabla CAJATIPOSOPERA Salida de efctivo por el COBRO del seguro de Vida
	public static String opeCajaEntCobroseguroVida 	= "18";	// corresponde con la tabla CAJATIPOSOPERA Entrada de efctivo por el COBRO del seguro de Vida	
	public static String opeCajaDesemCredito	= "10";	// corresponde con la tabla CAJATIPOSOPERA Desembolso del credito
	public static String opeCajaEntCambioEfec	= "59";	// corresponde con la tabla CAJATIPOSOPERA Entrada por Cambio de Efectivo
	public static String opeCajaSalCambioEfec	= "60";	// corresponde con la tabla CAJATIPOSOPERA Salida por Cambio de Efectivo
	public static String opeCajaDepGLCargoCta	= "61";	// corresponde con la tabla CAJATIPOSOPERA Deposito de GL 	con Cargo a Cuenta
	public static String opeEntCajaTransferCta	= "62";	// corresponde con la tabla CAJATIPOSOPERA Entrada Transferencia entre Cuentas
	public static String opeSalCajaTransferCta	= "63";	// corresponde con la tabla CAJATIPOSOPERA Salida Transferencia entre cuentas	
	public static String opeEntCajaPrepagoCred	= "78";	// corresponde con la tabla CAJATIPOSOPERA Entrada por Prepago de credito
	public static String opeSalCajaPrepagoCred	= "79";	// corresponde con la tabla CAJATIPOSOPERA Salida por Prepago de credito	
	public static String opeEntradaTransferATM	= "85";	// corresponde con la tabla CAJATIPOSOPERA Entrada por transferencia a Cajero ATM
	public static String opeSalidaTransferATM	= "86";	// corresponde con la tabla CAJATIPOSOPERA Salida por transferencia a Cajero ATM	
	public static String opeEntradaCarteraVen	= "87";	// corresponde con la tabla CAJATIPOSOPERA Entrada por Recuperacion de Cartera Vencida
	public static String opeSalidaCarteraVen	= "88";	// corresponde con la tabla CAJATIPOSOPERA Salida por Recuperacion de Cartera Vencida	

	//operaciones para la  Caja de Ahorro
	public static String opeEntAportacionSocio	="64";	// corresponde con la tabla CAJATIPOSOPERA Entrada por Aportacion Social
	public static String opeSalAportacionSocio	="65";	// corresponde con la tabla CAJATIPOSOPERA Salida por Aportacion Social
	public static String opeEntDevolucionAS		="66";	// corresponde con la tabla CAJATIPOSOPERA Entrada  devolucion de Aportacion Social
	public static String opeSalDevolucionAS		="67";	// corresponde con la tabla CAJATIPOSOPERA Salida  Devolucion de Aportacion Social
	public static String opeEntCobroSegAyuda	="68";	// corresponde con la tabla CAJATIPOSOPERA Entrada Cobro Seguro de Ayuda
	public static String opeSalCobroSegAyuda	="69";	// corresponde con la tabla CAJATIPOSOPERA Salida  Cobro Seguro de Ayuda	
	public static String opeEntCPagoSegAyuda	="70";	// corresponde con la tabla CAJATIPOSOPERA Entrada Pago Seguro de Ayuda
	public static String opeSalPagoSegAyuda		="71";	// corresponde con la tabla CAJATIPOSOPERA Salida  Pago Seguro de Ayuda		
	public static String opeEntradaPagoRemesa	="72";	// corresponde con la tabla CAJATIPOSOPERA Entrada Pago Remesas
	public static String opeSalidaPagoRemesa	="73";	// corresponde con la tabla CAJATIPOSOPERA Salida Pago Remesas
	public static String opeSalRemesaAbonoCta	="82";	// corresponde con la tabla CAJATIPOSOPERA Salida Pago Remesas con ABONO a CTA
	public static String opeEntPagoOportnidads	="74";	// corresponde con la tabla CAJATIPOSOPERA Entrada Pago Oportunidades
	public static String opeSalPagoOportnidads	="75";	// corresponde con la tabla CAJATIPOSOPERA Salida Pago Oportunidades
	public static String opeSalPagoOportAbonoCta ="83";// corresponde con la tabla CAJATIPOSOPERA Salida Pago Oportunidades ABONO a CTA
	
	public static String opeEntRecepChequeSBC	="9";	// corresponde con la tabla CAJATIPOSOPERA Entrada recepcion cheque SBC
	public static String opeSalRecepChequeSBC	="29";	// corresponde con la tabla CAJATIPOSOPERA Salida recepcion cheque SBC	
	public static String opeEntAplicaChequeSBC	="76";	// corresponde con la tabla CAJATIPOSOPERA Entrada Aplica cheque SBC
	public static String opeSalAplicaChequeSBC	="77";	// corresponde con la tabla CAJATIPOSOPERA Salida Aplica cheque SBC
	public static String opeEntCajaPagoServicio="80";	// corresponde con la tabla CAJATIPOSOPERA Entrada pago de servicios
	public static String opeSalCajaPagoServicio="81";	// corresponde con la tabla CAJATIPOSOPERA Salida pago de servicios
		
	public static String opeEntradaPagoServifun	= "91";	// corresponde con la tabla CAJATIPOSOPERA Entrada por Pago SERVIFUN
	public static String opeSalidaPagoServifun	= "92";	// corresponde con la tabla CAJATIPOSOPERA Salida por Pago SERVIFUN	
	public static String opeEntradaPagoApoyoEsc= "95";	// corresponde con la tabla CAJATIPOSOPERA Entrada por Pago Apoyo Escolar
	public static String opeSalidaPagoApoyoEsc	= "96";	// corresponde con la tabla CAJATIPOSOPERA Salida por Pago Apoyo Escolar
	
	public static String opeEntAjusteSobrante	= "97";	// corresponde con la tabla CAJATIPOSOPERA Salida por ajuste de Sobrante
	public static String opeSalAjusteSobrante	= "98";	// corresponde con la tabla CAJATIPOSOPERA Salida por ajuste de Sobrante
	public static String opeEntAjusteFaltante	= "99";	// corresponde con la tabla CAJATIPOSOPERA Salida por ajuste de Faltante
	public static String opeSalAjusteFaltante	= "100";	// corresponde con la tabla CAJATIPOSOPERA Salida  ajuste de Faltante
	public static String opeEntCobroAnualTarj	= "114";	// corresponde con la tabla CAJATIPOSOPERA Salida Cobro Anual tarjeta Debito
	public static String opeSalCobroAnualTarj	= "115";	// corresponde con la tabla CAJATIPOSOPERA entrada Cobro Anual tarjeta Debito
	public static String opeEntradaPagoCancelSocio = "116";// corresponde con la tabla CAJATIPOSOPERA Entrada por Pago CANCELACION DE SOCIO
	public static String opeSalidaPagoCancelSocio = "117";	// corresponde con la tabla CAJATIPOSOPERA Salida por Pago Cancelacion de socio
	
	
	
	public static String opeEntChequeFirme				= "101";	// corresponde con la tabla CAJATIPOSOPERA Entrada que Cheque en Firme
	public static String opeSalDepCtaChequeFirme		= "102";	// corresponde con la tabla CAJATIPOSOPERA Salida   Cheque en Firme
	public static String opeSalEfecCobroChequeFirme		= "103";	// corresponde con la tabla CAJATIPOSOPERA Salida Cheque en Firme
	
	public static String opeCajaChequeCargoCta			= "104";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Cargo a Cuenta
	public static String opeCajaChequeDevGarantiaLiq	= "105";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Devolucion de Garantia Liquida
	public static String opeCajaChequeDesembCredito		= "106";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Desembolso de Credito
	public static String opeCajaChequeDevAportaSocial	= "107";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Devolucion de Aportacion Social
	public static String opeCajaChequeAplicaSegAyuda	= "108";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Aplicacion de Seguro de Ayuda
	public static String opeCajaChequePagoRemesa		= "109";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Pago de Remesa
	public static String opeCajaChequePagoOportun		= "110";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Pago de Oportunidades
	public static String opeCajaChequePagoServifun		= "111";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Servifun
	public static String opeCajaChequePagoApoyoEscolar	= "112";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Apoyo Escolar
	public static String opeCajaChequePagoCobRiesgo		= "113";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Aplicacion Cobertura de Riesgo
	public static String opeCajaChequePagoCancelSocio	= "118";			// corresponde con la tabla CAJATIPOSOPERA Salida Cheque por Pago de cancelacion de socio
	public static String opeCajEntCobroAccesCre 		= "133";	// Corresponde con la tabla CAJATIPOSOPERA Entrada Efectivo por Cobro de Accesorios
	public static String opeCajSalCobroAccesCre 		= "134";	// Corresponde con la tabla CAJATIPOSOPERA Salida por Cobro de Accesorios
	
	//operaciones CAJATIPOSOPERA para reversas 
	public static String opeCajaEntCobroSegVidaReversa 	= "45";	// corresponde con la tabla CAJATIPOSOPERA Entrada reversa de Seguro de Vida
	public static String opeCajaSalCobroSegVidaReversa 	= "46";	// corresponde con la tabla CAJATIPOSOPERA Salida reversa de Seguro de Vida
	public static String opeCajEntEfCtaReversa 			= "47";	// corresponde con la tabla CAJATIPOSOPERA Entrada reversa ABONO a Cuenta
	public static String opeCajSalEfCtaReversa 			= "48";	// corresponde con la tabla CAJATIPOSOPERA Salida reversa ABONO a Cuenta
	public static String opeCajEntGarLiqReversa		 	= "49";	// corresponde con la tabla CAJATIPOSOPERA Salida reversa deposito de Garantia Liquida
	public static String opeCajSalDepGarLiqReversa	 	= "50";	// corresponde con la tabla CAJATIPOSOPERA Deposito de Garantia Liquida
	public static String opeCajEntCargoCtaReversa 		= "51";	// corresponde con la tabla CAJATIPOSOPERA Entrada reversa Cargo a Cuenta
	public static String opeCajSalCargoCtaReversa 		= "52";	// corresponde con la tabla CAJATIPOSOPERA Salida reversa Cargo a Cuenta
	public static String opeCajEntAplicSVReversa 		= "53";	// corresponde con la tabla CAJATIPOSOPERA Entrada reversa de aplicacion del seguro de Vida
	public static String opeCajSalAplicSVReversa 		= "54";	// corresponde con la tabla CAJATIPOSOPERA Salida reversa de aplicacion del seguro de vida
	public static String opeCajEntDesCreReversa		 	= "55";	// Corresponde con la Tabla CAJATIPOSOPERA Entrada reversa Desembolso Cred
	public static String opeCajSalDesCreReversa		 	= "56";	// Corresponde con la Tabla CAJATIPOSOPERA Salida reversa Desembolso Cred
	public static String opeCajEntCACReversa		 	= "57";	// Corresponde con la Tabla CAJATIPOSOPERA Entrada reversa Comicion por Apertura
	public static String opeCajSalCACReversa		 	= "58";	// Corresponde con la Tabla CAJATIPOSOPERA Salida reversa Comicion por Apertura
	public static String opeCajSalDepGLCargoCtaReversa	= "84";	// Corresponde con la Tabla CAJATIPOSOPERA Salida reversa de Deposito de Garantia Liquida con CArgo a Cuenta
	public static String opeCajEntProfun				= "93"; // Corresponde con la Tabla CAJASTIPOSOPERA Entrada  por Pago PROFUN
	public static String opeCajSalProfun				= "94"; // Corresponde con la Tabla CAJASTIOSOPERA Salida por Pago PORFUN	
	public static String opeCajEntGastos				="123"; // Corresponde con la Tabla CAJASTIPOSOPERA Entrada de gastos por comprobar
	public static String opeCajSalGastos				="120"; // Corresponde con la Tabla CAJASTIPOSOPERA Salida de Efectivo de Gastos por comprobar
	public static String opeCajSalChequeGastos			="121";	// Corresponde con la Tabla CAJASTIPOSOPERA Salida de Cheque de Gastos por Comprobar
	public static String opeCajEntDevolucion			="119"; // Corresponde con la Tabla CAJASTIPOSOPERA Entrada de efectivo por devolucion de gastos 
	public static String opeCajSalDevolucion			="122"; // Corresponde con la Tabla CAJASTIPOSOPERA Salida de Devolucion de Gastos 
	public static String opeCajSalHaberesExMenor		="124"; // Corresponde con la Tabla CAJASTIPOSOPERA Salida de Efectivo por Haberes de ExMenor
	public static String opeCajEntHaberesExMenor		="125"; // Corresponde con la tabla CAJASTIPOSOPERA Entrada Haberes ExMenor
	public static String opeCajSalCheqExMenor			="126";	// Corresponde con la tabla CAJASTIPOSOPERA Salida de Cheque Haberes ExMenor
	public static String opeCajEntPagArrendamiento	= "127";	// Corresponde con la Tabla CAJATIPOSOPERA Entrada Efectivo 	Pago Credito
	public static String opeCajSalPagArrendamiento	= "128";	// Corresponde con la Tabla CAJATIPOSOPERA Salida Efectivo 	Pago Credito
	public static String opeCajEntPagServLinea 			="129"; // 	Corresponde con la Tabla CAJATIPOSOPERA Entrada Efectivo Pago de Servicios en Linea
	public static String opeCajSalPagServLineaEfe 		="130"; // 	Corresponde con la Tabla CAJATIPOSOPERA Salida Efectivo Pago de Servicios en Linea en Efectivo
	public static String cargoCtaPagServLinea 			="131"; // 	Corresponde con la Tabla CAJATIPOSOPERA Entrada Efectivo Pago de Servicios en Linea
	public static String opeCajSalPagServLineaCCH 		="132"; // 	Corresponde con la Tabla CAJATIPOSOPERA Salida Efectivo Pago de Servicios en Linea con Cargo a Cuenta
	public static String opeCajEntRevCobroAcces			= "135";	// Corresponde con la tabla CAJATIPOSOPERA Entrada para Reversa de Cobro de Accesorios
	public static String opeCajSalRevCobroAcces			= "136";	// Corresponde con la tabla CAJAtIPOSOPERA Salida de Efectivo para Reversa de Cobro de Accesorios
	
	public static String tipoMoneda 		= "M";	// Tipo de Operacion Monedas
	public static String tipoBillete 		= "B";	// Tipo de Operacion Billetes

	public static String tipoBilleteMonedas = "BM";	// Tipo de Operacion Billetes
	public static String natBloqueo 		= "B";	//NATURALEZA bLOQUEO
	public static String natDesbloqueo 		= "D";	//NATURALEZA DESBLOQUEO
	
	public static String tipoMovBlo			= "8";	// corresponde con la tabla TIPOSBLOQUEOS POR GL
	public static String tipoMovDevGLBlo	= "9";	// corresponde con la tabla TIPOSBLOQUEOS
	public static String tipoMovBloGLAdi	= "10";	// corresponde con la tabla TIPOSBLOQUEOS POR GL adicional
	public static String desMovBloqGaranLiq = "DEPOSITO GARANTIA LIQUIDA";
	public static String descMovsDetalleGL  = "CREDITOS OTORGADOS";
	public static String descMovsDepGlCTA	= "BLOQUEO POR GARANTIA LIQUIDA";
	//public static String revdesMovBloqGaranLiq = "REVERSA DEPOSITO GARANTIA LIQUIDA"; // Reversa
	
	public static String desMovDevGaranLiq 		= "DEVOLUCION GARANTIA LIQUIDA";
	public static String depPagoCredito 		= "DEPOSITO PAGO DE CREDITO";
	public static String depComApCre 			= "DEPOSITO COMISION POR APERTURA DE CREDITO";
	public static String retDesemCre 			= "RETIRO POR DESEMBOLSO DE CREDITO";
	public static String desRetiroCuenta 		= "RETIRO DE EFECTIVO EN CUENTA";
	public static String desAbonoCuenta 		= "ABONO DE EFECTIVO EN CUENTA";
	public static String desTransACaja			= "TRANS. EFECTIVO DE CAJA A BANCO";
	public static String descTransCajBanc		= "TRANS. EFECTIVO DE BANCO A CAJA";
	public static String desRecepACaja			= "RECEP. EFECTIVO CAJA ";
	public static String desTRANACaja			= "TRANS. EFECTIVO CAJA ";
	public static String desDevGarantiaLiq 		= "RETIRO DE EFECTIVO POR GARANTIA LIQUIDA";
	public static String desMovBloqGaranLiqAdi	= "DEPOSITO POR GARANTIA LIQUIDA ADICIONAL";
	public static String cambioEfectivo		 	= "CAMBIO DE EFECTIVO";
	public static String descargoCuentaTrans 	= "TRANSFERENCIA A CUENTA";
	public static String desPrepagoCredito	 	= "PREPAGO DE CREDITO";
	public static String desAplicaSeguroVida 	= "APLICACION COBERTURA DE RIESGO";
	public static String desRevAplicaSegVida    = "REVERSA COBRO COBERTURA DE RIESGO POR SINIESTRO"; 
	public static String descPagServ			= "PAGO DE SERVICIOS";
	public static String descMovCaja			= "MOVIMIENTO DE EFECTIVO EN CAJA";
	public static String decTransferEnvBanco	="ENVIO DE EFECTIVO A BANCOS";
	public static String decTransferRecBanco	= "RECEPCION DE EFECTIVO DE BANCO";
	public static String depPagoArrendamiento	= "DEPOSITO PAGO DE ARRENDAMIENTO";
	public static String descPagoServicioLinea 	= "PAGO DE SERVICIO EN LINEA";
	public static String descAccesoriosCredito 	= "DEPOSITO COBRO ACCESORIOS";
	//Descripcion de Movimientos CAJAS de ahorro
	public static String desAportacionSocio		= 	"APORTACION SOCIAL";
	public static String desDevolucionASocio	= 	"DEVOLUCION APORTACION SOCIAL";
	public static String desCobroSegAyuda		= 	"COBRO SEGURO AYUDA";
	public static String desPagoSegAyuda		= 	"PAGO SEGURO AYUDA";
	public static String desPagoRemesas			= 	"PAGO DE REMESAS";
	public static String desPagoOportunidades	= 	"PAGO DE OPORTUNIDADES";
	public static String desPagoSERVIFUN		= 	"PAGO DE SERVIFUN";
	public static String desPagoCancelSocio		= 	"PAGO POR CANCELACION DE SOCIO";
	public static String descGastosComp			=   "SALIDA DE EFECTIVO GASTOS POR COMPROBAR";
	public static String descGastosCompCheq		= 	"SALIDA DE CHEQUE GASTOS POR COMPROBAR";
	public static String descGastosCompEnt		= 	"ENTRADA DE EFECTIVO DEVOLUCIONES POR COMPROBAR"; 
	public static String descPagoHaberesMenor	=	"PAGO HABERES EXMENOR";
	public static String descAjusteFaltante		=	"AJUSTE POR FALTANTE";
	public static String descAjusteSobrante		=	"AJUSTE POR SOBRANTE";
	public static String descPagoTarDebAnual	=	"COMISION POR ANUALIDAD DE TD";
	public static String descApoyoEscolar		=	"APOYO ESCOLAR";
	public static String descRecCarteraCast		=	"RECUPERACION DE CARTERA CASTIGADA";
	public static String descCobroChequeCtaInt  =	"COBRO CHEQUE SBC EN FIRME";
	public static String descCobroChequeCtaExt  =	"DCTOS SALVO BUEN COBRO SBC";
	public static String descAplicaChequeSBC	=	"ABONO DE EFECTIVO CHEQUE SBC";
	public static String descPrepagCredGrupal	=	"PAGO DE CREDITO";
	// Descripcion de movimientos Reversas
	public static String reversaDesCargoCuenta		= "REVERSA DE CARGO A CUENTA";
	public static String reversaAbonoCuenta			= "REVERSA ABONO DE EFECTIVO A CUENTA";
	public static String reversaDesMovBloqGaranLiq	= "REVERSA DEPOSITO DE GARANTIA LIQUIDA";
	public static String desDesemCreReversa			= "REVERSA DE DESEMBOLSO DE CREDITO";
	public static String reversaComisionApCre		= "REVERSA COMISION POR APERTURA";
	public static String BloqueoManualSaldo			= "BLOQUEO MANUAL POR GARANTIA LIQUIDA";
	public static String BloqueoManualSaldoFOGAFI	= "BLOQUEO MANUAL POR GARANTIA FOGAFI";
	public static String DesBloqueoManualSaldo		= "DESBLOQUEO MANUAL POR GARANTIA LIQUIDA";
	public static String DesCobroSeguro				= "COBRO COBERTURA DE RIESGO POR SINIESTRO";
	public static String DesAnticipoGastos			= "GASTOS Y ANTICIPOS";
	public static String DesRevCobroCobeRiesgo		="REVERSA COBRO COBERTURA DE RIESGO";
	public static String reversaAccesCredito 		= "REVERSA COBRO ACCESORIOS CREDITO";
	
	public static String conceptoDivisa	 = "1";// corresponde con la tabla CONCEPTOSDIVISA	
	public static String natDenEntrada 	 = "1";
	public static String natDenSalida 	 = "2";

	// Forma en que se entregaron los Recursos
	public static String formaPago_Efectivo		= "R";	//Retiro en Efectivo
	public static String formaPago_Cheque	 	= "C";	//Entrega de Cheque
	public static String formaPago_AbonoCuenta	= "D";	//Depositado a Cuenta
	
	public static String naturalezaCargo = "C";
	public static String naturalezaAbono = "A";	
	public static String EsDeposito		 = "D";
	public static String BloqGar		 ="8";
	public static String SalidaEfectivo	 ="S";
	public static String empleado_SI	 ="S";
	public static String empleado_No	="N";
	public static String formaPagoAccesorio = "A"; // Indica el forma de cobro de accesorios, A: Anticipado
	
	public static String polizaAutomatica="A";
	
	//DEPOSITO ACTIVA CUENTA
	public static String depositoActivaCta 	= "34"; 	//  corresponde con la tabla CONCEPTOSAHORRO
	public static String desDepositoActivaCta		= "DEPOSITO PARA ACTIVACION DE CUENTA";
	public static String tipoMovDepositoActivaCta 	= "113"; // corresponde con la tabla TIPOSMOVSAHO 
	public static String concepContaDepActivaCta 	= "1108"; // corresponde con la tabla	CONCEPTOSCONTA
	public static String opeCajEntEfeDepActCta 		= "137";	// Corresponde con la Tabla CAJATIPOSOPERA Entrada por efectivo deposito activa cuenta
	public static String opeCajSalEfeDepActCta		= "138";	// Corresponde con la Tabla CAJATIPOSOPERA Salida  por efectivo deposito activa cuenta

	
	public String getEsDepODev() {
		return esDepODev;
	}
	public void setEsDepODev(String esDepODev) {
		this.esDepODev = esDepODev;
	}
	public static String EsDevolucion	 = "V";
	
	private String tipoOperacion;
	private String cuentaAhoID;
	private String numeroMov;	
	private String fecha;
	private String natMovimiento;
	
	private String cantidadMov;	
	private String descripcionMov;
	private String referenciaMov;
	private String tipoMov;
	private String monedaID;
	
	private String cajaID;
	private String sucursalID;
	private String altaEnPoliza;
	private String conceptoCon;
	private String altaDetPoliza;

	private String natConta;
	private String numErr;
	private String errMen;
	private String consecutivo;
	private String clienteID;
	
	private String montoEnFirme;
	private String montoSBC;
	private String instrumento;
	private String comision;
	private String iVAComision;	
	private String afectaContaSBC;
	
	private String conceptoAho;
	private String polizaID;
	private String tipoOpDivBillMon;
	private String conceptoOpDivisa;
	private String cargos;
	
	private String abonos;
	private String naturalezaDenominacion;
	private String denominacionID;
	private String cantidadDenominacion;
	private String montoDenominacion;
	
	private String valorDenominacion;
	private String totalEntrada;
	private String totalSalida;
	private String creditoID;
	private String productoCreditoID;
	
	private String arrendamientoID;
	private String montoPagadoArrendamiento;

	private String comisionApeCre;
	private String ivaComisionApeCre;
	private String formaCobroComApCre;	
	private String desMovCaja;
	private String seguroVidaID;
	private String garantiaLiqAdi; // guarda el valor cuando se trata de una garantia liquida adicional
	private String montoPagadoCredito;
	
	private String ctaGLAdiID;
	
	private List clienteIDIntegrante;
	private List garantiaAdicional;
	private List cuentaGLID;
	
	private String montoEnLetras;
	private String numeroMonedaBase;
	private String simboloMonedaBase;
	private String descrpcionMonedaBase;
	private String transaccionOperacionID;
	private String nombreCliente;
	private String formaPagoGL;
	private String cuentaCargoAbono;
	private String clienteCargoAbono;
	private String referenciaCargoAbono;
	private String polizaSeguro;
	private String referenciaPago;
	private String direccionCliente;
	private String tipoIdentifiCliente;
	private String folioIdentifiCliente;
	private String formaPago;
	private String telefonoCliente;
	private String bancoEmisor;
	private String cuentaBancos;
	private String numeroCheque;
	private String nombreEmisor;
	private String nombreBeneficiario;
	private String chequeSBCID;
	
	private String catalogoServID;
	private String IVAMonto;
	private String totalPagar;
	private String prospectoID;	
	private String monto;
	
	private String remesaCatalogoID;
	private String esEfectivo;
	private String personaRelacionID;
	private String serviFunFolioID;
	private String serviFunEntregadoID;
	private String apoyoEscSolID;
	private String usuarioAut;
	private String contraseniaAut;
	
	
	private String nombreCompleto; //-- NOMBRE PARA MOSTRAR LA LISTA
	private String numClienteTCta; //Número de Cliente de la cuenta Receptora en Transferencia/Cta
	private String formaCobro;	// Forma de Cobro
	private String tipoCuenta;
	
	private String cliCancelaEntregaID; 
	private String clienteCancelaID; 
	private String cicloGrupo;
	private String grupoID;
	
	private String empresaID; 
	private String usuario; 
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private String esDepODev;
	private String tipoBloq;
	private String tarjetaDebID;
	public  String empleadoID;
	private  String denominaciones; 
	//Variables para reimpresion de ticket
	private String totalOperacion;
	private String totalEfectivo;
	private String totalCambio;
	private String cuentaIDRetiro;
	private String cuentaIDDeposito;
	private String formaPagoCobro;
	private String tipoOperaReimpre;
	private String IVATicket;
	private String referenciaTicket;
	private String OpcionCajaID;
	private String nombreEmisorTicket;
	private String nombreRecibePago;
	private String numCuentaTar;
	private String usuarioLogueado;
	private String areaCancela;
	private String cantidadRecibir;
	private String estatus;	
	private String fechSistema;
	
	private String usuarioID;
	private String tipoChequera;
	private String tipoChequeraRecep;
	
	//Variables para pago se servicios en linea
	private String productoID;
	private String nombreProductoPSL;
	private String tipoUsuario;
	private String numeroTarjetaPSL;
	private String clienteIDPSL;
	private String nombreClientePSL;
	private String formaPagoPSL;
	private String cuentaAhorroPSL;
	private String precio;
	private String comisiProveedor;
	private String comisiInstitucion;
	private String ivaComisiInstitucion;
	private String totalComisiones;
	private String totalPagarPSL;
	private String totalEntradaPSL;
	private String servicioIDPSL;
	private String clasificacionServPSL;
	private String tipoReferencia;
	private String tipoFront;
	private String telefonoPSL;
	private String confirmTelefonoPSL;
	private String referenciaPSL;
	private String confirmReferenciaPSL;
	private String fechaHoraPSL;
	private String canalPSL;
	private String cajeroID;
	private String cobroID;
	
// atributos que se utilizan para validaciones ventanilla
	public static String estatusAutorizado = "A";
	public static String estatusRetirado = "R";
	public static String estatusPagado = "P";
	public static String estatusCapturado = "C";
	public static String estatusAplicado = "A";
	public static String estatusCancelado = "C";
	public static String estatusCobrado = "C";
	public static String enteroCero = "0";
	
	// Aportacion social
	public String montoPagadoAS;
	public String montoPendientePagoAS;
	
	// SEGUROS
	private String cobraSeguroCuota;
	private String montoSeguroCuota;
	private String iVASeguroCuota;
	
	//COMISION ANUAL
	private String saldoComAnual;//Comision de anualidad de crédito
	private String saldoComAnualIVA;//IVA Comision de anualidad de crédito
	
	// COBRO ACCESORIOS
	private String accesoriosID;
	
	// PREPAGO
	private String tipoPrepago;	// Tipo de Prepago correspondiente al Credito
	
	// REMESAS
	private String clabeCobroRemesa;

	public String getDesMovCaja() {
		return desMovCaja;
	}
	public void setDesMovCaja(String desMovCaja) {
		this.desMovCaja = desMovCaja;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getNumeroMov() {
		return numeroMov;
	}
	public void setNumeroMov(String numeroMov) {
		this.numeroMov = numeroMov;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public String getCantidadMov() {
		return cantidadMov;
	}
	public void setCantidadMov(String cantidadMov) {
		this.cantidadMov = cantidadMov;
	}
	public String getDescripcionMov() {
		return descripcionMov;
	}
	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
	}
	public String getReferenciaMov() {
		return referenciaMov;
	}
	public void setReferenciaMov(String referenciaMov) {
		this.referenciaMov = referenciaMov;
	}
	public String getTipoMov() {
		return tipoMov;
	}
	public void setTipoMov(String tipoMov) {
		this.tipoMov = tipoMov;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getCajaID() {
		return cajaID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getAltaEnPoliza() {
		return altaEnPoliza;
	}
	public void setAltaEnPoliza(String altaEnPoliza) {
		this.altaEnPoliza = altaEnPoliza;
	}
	public String getConceptoCon() {
		return conceptoCon;
	}
	public void setConceptoCon(String conceptoCon) {
		this.conceptoCon = conceptoCon;
	}
	public String getAltaDetPoliza() {
		return altaDetPoliza;
	}
	public void setAltaDetPoliza(String altaDetPoliza) {
		this.altaDetPoliza = altaDetPoliza;
	}
	public String getNatConta() {
		return natConta;
	}
	public void setNatConta(String natConta) {
		this.natConta = natConta;
	}
	public String getNumErr() {
		return numErr;
	}
	public void setNumErr(String numErr) {
		this.numErr = numErr;
	}
	public String getErrMen() {
		return errMen;
	}
	public void setErrMen(String errMen) {
		this.errMen = errMen;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	
	public String getMontoEnFirme() {
		return montoEnFirme;
	}
	public void setMontoEnFirme(String montoEnFirme) {
		this.montoEnFirme = montoEnFirme;
	}
	public String getMontoSBC() {
		return montoSBC;
	}
	public void setMontoSBC(String montoSBC) {
		this.montoSBC = montoSBC;
	}
	public String getInstrumento() {
		return instrumento;
	}
	public void setInstrumento(String instrumento) {
		this.instrumento = instrumento;
	}
	public String getComision() {
		return comision;
	}
	public void setComision(String comision) {
		this.comision = comision;
	}
	public String getiVAComision() {
		return iVAComision;
	}
	public void setiVAComision(String iVAComision) {
		this.iVAComision = iVAComision;
	}
	public String getConceptoAho() {
		return conceptoAho;
	}
	public void setConceptoAho(String conceptoAho) {
		this.conceptoAho = conceptoAho;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getTipoOpDivBillMon() {
		return tipoOpDivBillMon;
	}
	public void setTipoOpDivBillMon(String tipoOpDivBillMon) {
		this.tipoOpDivBillMon = tipoOpDivBillMon;
	}
	public String getConceptoOpDivisa() {
		return conceptoOpDivisa;
	}
	public void setConceptoOpDivisa(String conceptoOpDivisa) {
		this.conceptoOpDivisa = conceptoOpDivisa;
	}
	public String getCargos() {
		return cargos;
	}
	public void setCargos(String cargos) {
		this.cargos = cargos;
	}
	public String getAbonos() {
		return abonos;
	}
	public void setAbonos(String abonos) {
		this.abonos = abonos;
	}
	public String getNaturalezaDenominacion() {
		return naturalezaDenominacion;
	}
	public void setNaturalezaDenominacion(String naturalezaDenominacion) {
		this.naturalezaDenominacion = naturalezaDenominacion;
	}
	public String getCantidadDenominacion() {
		return cantidadDenominacion;
	}
	public void setCantidadDenominacion(String cantidadDenominacion) {
		this.cantidadDenominacion = cantidadDenominacion;
	}
	public String getMontoDenominacion() {
		return montoDenominacion;
	}
	public void setMontoDenominacion(String montoDenominacion) {
		this.montoDenominacion = montoDenominacion;
	}
	public String getDenominacionID() {
		return denominacionID;
	}
	public void setDenominacionID(String denominacionID) {
		this.denominacionID = denominacionID;
	}
	public String getValorDenominacion() {
		return valorDenominacion;
	}
	public void setValorDenominacion(String vtipoReferenciaalorDenominacion) {
		this.valorDenominacion = valorDenominacion;
	}
	public String getTotalEntrada() {
		return totalEntrada;
	}
	public void setTotalEntrada(String totalEntrada) {
		this.totalEntrada = totalEntrada;
	}
	public String getTotalSalida() {
		return totalSalida;
	}
	public void setTotalSalida(String totalSalida) {
		this.totalSalida = totalSalida;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getComisionApeCre() {
		return comisionApeCre;
	}
	public void setComisionApeCre(String comisionApeCre) {
		this.comisionApeCre = comisionApeCre;
	}
	public String getIvaComisionApeCre() {
		return ivaComisionApeCre;
	}
	public void setIvaComisionApeCre(String ivaComisionApeCre) {
		this.ivaComisionApeCre = ivaComisionApeCre;
	}
	public String getFormaCobroComApCre() {
		return formaCobroComApCre;
	}
	public void setFormaCobroComApCre(String formaCobroComApCre) {
		this.formaCobroComApCre = formaCobroComApCre;
	}
	public String getSeguroVidaID() {
		return seguroVidaID;
	}
	public void setSeguroVidaID(String seguroVidaID) {
		this.seguroVidaID = seguroVidaID;
	}
	public String getGarantiaLiqAdi() {
		return garantiaLiqAdi;
	}
	public void setGarantiaLiqAdi(String garantiaLiqAdi) {
		this.garantiaLiqAdi = garantiaLiqAdi;
	}
	public String getCtaGLAdiID() {
		return ctaGLAdiID;
	}
	public void setCtaGLAdiID(String ctaGLAdiID) {
		this.ctaGLAdiID = ctaGLAdiID;
	}
	public List getClienteIDIntegrante() {
		return clienteIDIntegrante;
	}
	public void setClienteIDIntegrante(List clienteIDIntegrante) {
		this.clienteIDIntegrante = clienteIDIntegrante;
	}
	public List getCuentaGLID() {
		return cuentaGLID;
	}
	public void setCuentaGLID(List cuentaGLID) {
		this.cuentaGLID = cuentaGLID;
	}
	public List getGarantiaAdicional() {
		return garantiaAdicional;
	}
	public void setGarantiaAdicional(List garantiaAdicional) {
		this.garantiaAdicional = garantiaAdicional;
	}
	public String getMontoEnLetras() {
		return montoEnLetras;
	}
	public void setMontoEnLetras(String montoEnLetras) {
		this.montoEnLetras = montoEnLetras;
	}
	public String getNumeroMonedaBase() {
		return numeroMonedaBase;
	}
	public void setNumeroMonedaBase(String numeroMonedaBase) {
		this.numeroMonedaBase = numeroMonedaBase;
	}

	public String getDescrpcionMonedaBase() {
		return descrpcionMonedaBase;
	}
	public void setDescrpcionMonedaBase(String descrpcionMonedaBase) {
		this.descrpcionMonedaBase = descrpcionMonedaBase;
	}
	public String getSimboloMonedaBase() {
		return simboloMonedaBase;
	}
	public void setSimboloMonedaBase(String simboloMonedaBase) {
		this.simboloMonedaBase = simboloMonedaBase;
	}
	public String getTransaccionOperacionID() {
		return transaccionOperacionID;
	}
	public void setTransaccionOperacionID(String transaccionOperacionID) {
		this.transaccionOperacionID = transaccionOperacionID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getMontoPagadoCredito() {
		return montoPagadoCredito;
	}
	public void setMontoPagadoCredito(String montoPagadoCredito) {
		this.montoPagadoCredito = montoPagadoCredito;
	}
	public String getFormaPagoGL() {
		return formaPagoGL;
	}
	public void setFormaPagoGL(String formaPagoGL) {
		this.formaPagoGL = formaPagoGL;
	}
	public String getCuentaCargoAbono() {
		return cuentaCargoAbono;
	}
	public void setCuentaCargoAbono(String cuentaCargoAbono) {
		this.cuentaCargoAbono = cuentaCargoAbono;
	}
	public String getClienteCargoAbono() {
		return clienteCargoAbono;
	}
	public void setClienteCargoAbono(String clienteCargoAbono) {
		this.clienteCargoAbono = clienteCargoAbono;
	}
	public String getReferenciaCargoAbono() {
		return referenciaCargoAbono;
	}
	public void setReferenciaCargoAbono(String referenciaCargoAbono) {
		this.referenciaCargoAbono = referenciaCargoAbono;
	}
	public String getPolizaSeguro() {
		return polizaSeguro;
	}
	public void setPolizaSeguro(String polizaSeguro) {
		this.polizaSeguro = polizaSeguro;
	}
	public String getReferenciaPago() {
		return referenciaPago;
	}
	public void setReferenciaPago(String referenciaPago) {
		this.referenciaPago = referenciaPago;
	}
	public String getDireccionCliente() {
		return direccionCliente;
	}
	public void setDireccionCliente(String direccionCliente) {
		this.direccionCliente = direccionCliente;
	}
	public String getTipoIdentifiCliente() {
		return tipoIdentifiCliente;
	}
	public void setTipoIdentifiCliente(String tipoIdentifiCliente) {
		this.tipoIdentifiCliente = tipoIdentifiCliente;
	}
	public String getFolioIdentifiCliente() {
		return folioIdentifiCliente;
	}
	public void setFolioIdentifiCliente(String folioIdentifiCliente) {
		this.folioIdentifiCliente = folioIdentifiCliente;
	}
	public String getFormaPago() {
		return formaPago;
	}
	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}
	public String getTelefonoCliente() {
		return telefonoCliente;
	}
	public void setTelefonoCliente(String telefonoCliente) {
		this.telefonoCliente = telefonoCliente;
	}
	public String getBancoEmisor() {
		return bancoEmisor;
	}
	public void setBancoEmisor(String bancoEmisor) {
		this.bancoEmisor = bancoEmisor;
	}
	public String getNumeroCheque() {
		return numeroCheque;
	}
	public void setNumeroCheque(String numeroCheque) {
		this.numeroCheque = numeroCheque;
	}
	public String getNombreEmisor() {
		return nombreEmisor;
	}
	public void setNombreEmisor(String nombreEmisor) {
		this.nombreEmisor = nombreEmisor;
	}
	public String getChequeSBCID() {
		return chequeSBCID;
	}
	public void setChequeSBCID(String chequeSBCID) {
		this.chequeSBCID = chequeSBCID;
	}
	public String getCatalogoServID() {
		return catalogoServID;
	}
	public String getIVAMonto() {
		return IVAMonto;
	}
	public String getTotalPagar() {
		return totalPagar;
	}
	public String getProspectoID() {
		return prospectoID;
	}

	public void setCatalogoServID(String catalogoServID) {
		this.catalogoServID = catalogoServID;
	}
	public void setIVAMonto(String iVAMonto) {
		IVAMonto = iVAMonto;
	}
	public void setTotalPagar(String totalPagar) {
		this.totalPagar = totalPagar;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getRemesaCatalogoID() {
		return remesaCatalogoID;
	}
	public void setRemesaCatalogoID(String remesaCatalogoID) {
		this.remesaCatalogoID = remesaCatalogoID;
	}
	public String getEsEfectivo() {
		return esEfectivo;
	}
	public void setEsEfectivo(String esEfectivo) {
		this.esEfectivo = esEfectivo;
	}

	public String getPersonaRelacionID() {
		return personaRelacionID;
	}
	public void setPersonaRelacionID(String personaRelacionID) {
		this.personaRelacionID = personaRelacionID;
	}
	public String getServiFunFolioID() {
		return serviFunFolioID;
	}
	public void setServiFunFolioID(String serviFunFolioID) {
		this.serviFunFolioID = serviFunFolioID;
	}
	public String getServiFunEntregadoID() {
		return serviFunEntregadoID;
	}
	public void setServiFunEntregadoID(String serviFunEntregadoID) {
		this.serviFunEntregadoID = serviFunEntregadoID;
	}
	public String getApoyoEscSolID() {
		return apoyoEscSolID;
	}
	public void setApoyoEscSolID(String apoyoEscSolID) {
		this.apoyoEscSolID = apoyoEscSolID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getUsuarioAut() {
		return usuarioAut;
	}
	public String getContraseniaAut() {
		return contraseniaAut;
	}
	public void setUsuarioAut(String usuarioAut) {
		this.usuarioAut = usuarioAut;
	}
	public void setContraseniaAut(String contraseniaAut) {
		this.contraseniaAut = contraseniaAut;
	}
	public String getNumClienteTCta() {
		return numClienteTCta;
	}
	public void setNumClienteTCta(String numClienteTCta) {
		this.numClienteTCta = numClienteTCta;
	}
	public String getFormaCobro() {
		return formaCobro;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setFormaCobro(String formaCobro) {
		this.formaCobro = formaCobro;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
		
	public String getTipoBloq() {
		return tipoBloq;
	}
	public void setTipoBloq(String tipoBloq) {
		this.tipoBloq = tipoBloq;
	}
	public String getCuentaBancos() {
		return cuentaBancos;
	}
	public void setCuentaBancos(String cuentaBancos) {
		this.cuentaBancos = cuentaBancos;
	}
	public String getNombreBeneficiario() {
		return nombreBeneficiario;
	}
	public void setNombreBeneficiario(String nombreBeneficiario) {
		this.nombreBeneficiario = nombreBeneficiario;
	}
	public String getTarjetaDebID() {
		return tarjetaDebID;
	}
	public void setTarjetaDebID(String tarjetaDebID) {
		this.tarjetaDebID = tarjetaDebID;
	}
	public String getCliCancelaEntregaID() {
		return cliCancelaEntregaID;
	}
	public void setCliCancelaEntregaID(String cliCancelaEntregaID) {
		this.cliCancelaEntregaID = cliCancelaEntregaID;
	}
	public String getClienteCancelaID() {
		return clienteCancelaID;
	}
	public void setClienteCancelaID(String clienteCancelaID) {
		this.clienteCancelaID = clienteCancelaID;
	}

	public String getEmpleadoID() {
		return empleadoID;
	}
	public void setEmpleadoID(String empleadoID) {
		this.empleadoID = empleadoID;
	}
	public String getTotalEfectivo() {
		return totalEfectivo;
	}
	public void setTotalEfectivo(String totalEfectivo) {
		this.totalEfectivo = totalEfectivo;
	}
	public String getTotalCambio() {
		return totalCambio;
	}
	public void setTotalCambio(String totalCambio) {
		this.totalCambio = totalCambio;
	}
	public String getCuentaIDRetiro() {
		return cuentaIDRetiro;
	}
	public void setCuentaIDRetiro(String cuentaIDRetiro) {
		this.cuentaIDRetiro = cuentaIDRetiro;
	}
	public String getCuentaIDDeposito() {
		return cuentaIDDeposito;
	}
	public void setCuentaIDDeposito(String cuentaIDDeposito) {
		this.cuentaIDDeposito = cuentaIDDeposito;
	}
	public String getFormaPagoCobro() {
		return formaPagoCobro;
	}
	public void setFormaPagoCobro(String formaPagoCobro) {
		this.formaPagoCobro = formaPagoCobro;
	}
	public String getTipoOperaReimpre() {
		return tipoOperaReimpre;
	}
	public void setTipoOperaReimpre(String tipoOperaReimpre) {
		this.tipoOperaReimpre = tipoOperaReimpre;
	}
	public String getTotalOperacion() {
		return totalOperacion;
	}
	public void setTotalOperacion(String totalOperacion) {
		this.totalOperacion = totalOperacion;
	}
	public String getIVATicket() {
		return IVATicket;
	}
	public void setIVATicket(String iVATicket) {
		IVATicket = iVATicket;
	}
	public String getCicloGrupo() {
		return cicloGrupo;
	}
	public void setCicloGrupo(String cicloGrupo) {
		this.cicloGrupo = cicloGrupo;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getReferenciaTicket() {
		return referenciaTicket;
	}
	public void setReferenciaTicket(String referenciaTicket) {
		this.referenciaTicket = referenciaTicket;
	}
	public String getOpcionCajaID() {
		return OpcionCajaID;
	}
	public void setOpcionCajaID(String opcionCajaID) {
		OpcionCajaID = opcionCajaID;
	}
	public String getNombreEmisorTicket() {
		return nombreEmisorTicket;
	}
	public void setNombreEmisorTicket(String nombreEmisorTicket) {
		this.nombreEmisorTicket = nombreEmisorTicket;
	}
	public String getNombreRecibePago() {
		return nombreRecibePago;
	}
	public void setNombreRecibePago(String nombreRecibePago) {
		this.nombreRecibePago = nombreRecibePago;
	}
	public String getNumCuentaTar() {
		return numCuentaTar;
	}
	public void setNumCuentaTar(String numCuentaTar) {
		this.numCuentaTar = numCuentaTar;
	}
	public String getAfectaContaSBC() {
		return afectaContaSBC;
	}
	public void setAfectaContaSBC(String afectaContaSBC) {
		this.afectaContaSBC = afectaContaSBC;
	}
	public String getDenominaciones() {
		return denominaciones;
	}
	public void setDenominaciones(String denominaciones) {
		this.denominaciones = denominaciones;
	}
	public String getUsuarioLogueado() {
		return usuarioLogueado;
	}
	public void setUsuarioLogueado(String usuarioLogueado) {
		this.usuarioLogueado = usuarioLogueado;
	}
	public String getAreaCancela() {
		return areaCancela;
	}
	public void setAreaCancela(String areaCancela) {
		this.areaCancela = areaCancela;
	}
	public String getCantidadRecibir() {
		return cantidadRecibir;
	}
	public void setCantidadRecibir(String cantidadRecibir) {
		this.cantidadRecibir = cantidadRecibir;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}	
	public String getFechSistema() {
		return fechSistema;
	}
	public void setFechSistema(String fechSistema) {
		this.fechSistema = fechSistema;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	
	public String getMontoPagadoAS() {
		return montoPagadoAS;
	}
	public void setMontoPagadoAS(String montoPagadoAS) {
		this.montoPagadoAS = montoPagadoAS;
	}
	public String getMontoPendientePagoAS() {
		return montoPendientePagoAS;
	}
	public void setMontoPendientePagoAS(String montoPendientePagoAS) {
		this.montoPendientePagoAS = montoPendientePagoAS;
	}
	public String getCobraSeguroCuota() {
		return cobraSeguroCuota;
	}
	public void setCobraSeguroCuota(String cobraSeguroCuota) {
		this.cobraSeguroCuota = cobraSeguroCuota;
	}
	public String getMontoSeguroCuota() {
		return montoSeguroCuota;
	}
	public void setMontoSeguroCuota(String montoSeguroCuota) {
		this.montoSeguroCuota = montoSeguroCuota;
	}
	public String getiVASeguroCuota() {
		return iVASeguroCuota;
	}
	public void setiVASeguroCuota(String iVASeguroCuota) {
		this.iVASeguroCuota = iVASeguroCuota;
	}
	public String getSaldoComAnual() {
		return saldoComAnual;
	}
	public void setSaldoComAnual(String saldoComAnual) {
		this.saldoComAnual = saldoComAnual;
	}
	public String getSaldoComAnualIVA() {
		return saldoComAnualIVA;
	}
	public void setSaldoComAnualIVA(String saldoComAnualIVA) {
		this.saldoComAnualIVA = saldoComAnualIVA;
	}
	public String getArrendaID() {
		return arrendamientoID;
	}
	public void setArrendaID(String arrendaID) {
		this.arrendamientoID = arrendaID;
	}
	public String getMontoPagadoArrendamiento() {
		return montoPagadoArrendamiento;
	}
	public void setMontoPagadoArrendamiento(String montoPagadoArrendamiento) {
		this.montoPagadoArrendamiento = montoPagadoArrendamiento;
	}
	public String getTipoChequera() {
		return tipoChequera;
	}
	public void setTipoChequera(String tipoChequera) {
		this.tipoChequera = tipoChequera;
	}
	public String getTipoChequeraRecep() {
		return tipoChequeraRecep;
	}
	public void setTipoChequeraRecep(String tipoChequeraRecep) {
		this.tipoChequeraRecep = tipoChequeraRecep;
	}
	
	
	public String getProductoID() {
		return productoID;
	}
	public void setProductoID(String productoID) {
		this.productoID = productoID;
	}
	public String getNombreProductoPSL() {
		return nombreProductoPSL;
	}
	public void setNombreProductoPSL(String nombreProductoPSL) {
		this.nombreProductoPSL = nombreProductoPSL;
	}
	public String getTipoUsuario() {
		return tipoUsuario;
	}
	public void setTipoUsuario(String tipoUsuario) {
		this.tipoUsuario = tipoUsuario;
	}
	public String getNumeroTarjetaPSL() {
		return numeroTarjetaPSL;
	}
	public void setNumeroTarjetaPSL(String numeroTarjetaPSL) {
		this.numeroTarjetaPSL = numeroTarjetaPSL;
	}
	public String getClienteIDPSL() {
		return clienteIDPSL;
	}
	public void setClienteIDPSL(String clienteIDPSL) {
		this.clienteIDPSL = clienteIDPSL;
	}
	public String getNombreClientePSL() {
		return nombreClientePSL;
	}
	public void setNombreClientePSL(String nombreClientePSL) {
		this.nombreClientePSL = nombreClientePSL;
	}
	public String getCuentaAhorroPSL() {
		return cuentaAhorroPSL;
	}
	public void setCuentaAhorroPSL(String cuentaAhorroPSL) {
		this.cuentaAhorroPSL = cuentaAhorroPSL;
	}
	public String getPrecio() {
		return precio;
	}
	public void setPrecio(String precio) {
		this.precio = precio;
	}
	public String getComisiProveedor() {
		return comisiProveedor;
	}
	public void setComisiProveedor(String comisiProveedor) {
		this.comisiProveedor = comisiProveedor;
	}
	public String getComisiInstitucion() {
		return comisiInstitucion;
	}
	public void setComisiInstitucion(String comisiInstitucion) {
		this.comisiInstitucion = comisiInstitucion;
	}
	public String getIvaComisiInstitucion() {
		return ivaComisiInstitucion;
	}
	public void setIvaComisiInstitucion(String ivaComisiInstitucion) {
		this.ivaComisiInstitucion = ivaComisiInstitucion;
	}
	public String getTotalComisiones() {
		return totalComisiones;
	}
	public void setTotalComisiones(String totalComisiones) {
		this.totalComisiones = totalComisiones;
	}
	public String getTotalPagarPSL() {
		return totalPagarPSL;
	}
	public void setTotalPagarPSL(String totalPagarPSL) {
		this.totalPagarPSL = totalPagarPSL;
	}
	public String getTotalEntradaPSL() {
		return totalEntradaPSL;
	}
	public void setTotalEntradaPSL(String totalEntradaPSL) {
		this.totalEntradaPSL = totalEntradaPSL;
	}
	public String getServicioIDPSL() {
		return servicioIDPSL;
	}
	public void setServicioIDPSL(String servicioIDPSL) {
		this.servicioIDPSL = servicioIDPSL;
	}
	public String getClasificacionServPSL() {
		return clasificacionServPSL;
	}
	public void setClasificacionServPSL(String clasificacionServPSL) {
		this.clasificacionServPSL = clasificacionServPSL;
	}
	public String getTipoReferencia() {
		return tipoReferencia;
	}
	public void setTipoReferencia(String tipoReferencia) {
		this.tipoReferencia = tipoReferencia;
	}
	public String getTipoFront() {
		return tipoFront;
	}
	public void setTipoFront(String tipoFront) {
		this.tipoFront = tipoFront;
	}
	public String getTelefonoPSL() {
		return telefonoPSL;
	}
	public void setTelefonoPSL(String telefonoPSL) {
		this.telefonoPSL = telefonoPSL;
	}
	public String getReferenciaPSL() {
		return referenciaPSL;
	}
	public void setReferenciaPSL(String referenciaPSL) {
		this.referenciaPSL = referenciaPSL;
	}
	public String getFormaPagoPSL() {
		return formaPagoPSL;
	}
	public void setFormaPagoPSL(String formaPagoPSL) {
		this.formaPagoPSL = formaPagoPSL;
	}
	public String getFechaHoraPSL() {
		return fechaHoraPSL;
	}
	public void setFechaHoraPSL(String fechaHoraPSL) {
		this.fechaHoraPSL = fechaHoraPSL;
	}
	public String getCanalPSL() {
		return canalPSL;
	}
	public void setCanalPSL(String canalPSL) {
		this.canalPSL = canalPSL;
	}
	public String getCajeroID() {
		return cajeroID;
	}
	public void setCajeroID(String cajeroID) {
		this.cajeroID = cajeroID;
	}
	public String getConfirmTelefonoPSL() {
		return confirmTelefonoPSL;
	}
	public void setConfirmTelefonoPSL(String confirmTelefonoPSL) {
		this.confirmTelefonoPSL = confirmTelefonoPSL;
	}
	public String getConfirmReferenciaPSL() {
		return confirmReferenciaPSL;
	}
	public void setConfirmReferenciaPSL(String confirmReferenciaPSL) {
		this.confirmReferenciaPSL = confirmReferenciaPSL;
	}
	public String getCobroID() {
		return cobroID;
	}
	public void setCobroID(String cobroID) {
		this.cobroID = cobroID;
	}
	public String getAccesoriosID() {
		return accesoriosID;
	}
	public void setAccesoriosID(String accesoriosID) {
		this.accesoriosID = accesoriosID;
	}
	public String getTipoPrepago() {
		return tipoPrepago;
	}
	public void setTipoPrepago(String tipoPrepago) {
		this.tipoPrepago = tipoPrepago;
	}
	public String getClabeCobroRemesa() {
		return clabeCobroRemesa;
	}
	public void setClabeCobroRemesa(String clabeCobroRemesa) {
		this.clabeCobroRemesa = clabeCobroRemesa;
	}
}
