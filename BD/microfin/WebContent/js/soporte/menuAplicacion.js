var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	
	var clav= parametroBean.claveUsuario;
	consultaSesion();
	$('#listaMenu').menuTree({
		animation: true,
		handler: 'slideToggle',
		anchor: 'a[href="javascript:"]',
		trace: false
	});
	
	$(window).bind('beforeunload', function(){
		 window.location='logout';  
		//return 'Vas a abandonar esta pagina. Si has hecho algun cambio sin grabar vas a perder todos los datos';		
	});

	
	verLogoCliente();
	// funcion para mostrar logo del cliente
	function verLogoCliente() {
		parametroBean = consultaParametrosSession();
		var varVerImgCte="logoClientePantalla.htm?rutaLogoCliente="+parametroBean.logoCtePantalla;
		$('#imgLogoClientePantalla').attr("src",varVerImgCte); 
	}


	if(parametroBean.tipoImpresoraTicket == 'S'){
		$('#spanPrinter').show();

		if(typeof applet == 'object'){
			if(applet.getEstatus() == 'C'){				
				if($('#lookAndFeel').asNumber()>0){
					$('#imgPrinterSAFI').attr('src','images/impresora/01/conectado_2.png');
				} else {
				$('#imgPrinterSAFI').attr('src','images/impresora/conectado_2.png');
				}
				$('#imgPrinterSAFI').attr('title','Conectado');
			}else{
				applet.conectar();
			}
		}else{
			if($('#lookAndFeel').asNumber()>0){
					$('#imgPrinterSAFI').attr('src','images/impresora/01/desconectado_2.png');
			} else {
				$('#imgPrinterSAFI').attr('src','images/impresora/desconectado_2.png');
			}
			$('#imgPrinterSAFI').attr('title','Desconectado');
		}
		
	}else{
		$('#spanPrinter').hide();
	}

});


function cerrarSession(){ 

	var clave = ''; 
	var parametroBean = consultaParametrosSession();
	if(parametroBean!=null){
		clave = parametroBean.claveUsuario;
	}
	if(clave==''){
		alert('POR SU SEGURIDAD: su sesión en la Aplicación SAFI ha sido finalizada de forma automática por exceder el tiempo límite de inactividad permitido');
		location.href ='cerrarSessionUsuarios.htm?claveUsuario=' + cl;
	}else{
		location.href ='logout?claveUsuario=' + cl;
	}	
	
			
} 


function confirmarCerrar() {
	var confirmar = false;
	confirmar=confirm("¿Esta seguro que desea salir de la aplicación?"); 
	if (confirmar == true) {
		cerrarSession();			  	
	}	
}

if(parametroBean.cajaID > 0 ){	
	var rutaImpTicket=parametroBean.recursoTicketVent;

	var pluginSocket = parametroBean.tipoImpresoraTicket == 'A' ? "" : "js/WebSocketImpresion.js";
	var tipoImpresoraTicket = parametroBean.tipoImpresoraTicket == 'A' ? "js/soporte/impresoraTicket.js" : "js/soporte/impresoraTicketSck.js";

	var arregloVentanilla = new Array(
			"dwr/interface/cuentasAhoServicio.js",
			"dwr/interface/clienteServicio.js",
			"dwr/interface/creditosServicio.js",
			"dwr/interface/amortizacionCreditoServicio.js",
			"dwr/interface/monedasServicio.js",
			"dwr/interface/tiposCuentaServicio.js",
			"dwr/interface/ingresosOperacionesServicio.js",
			"dwr/interface/gruposCreditoServicio.js",
			"dwr/interface/productosCreditoServicio.js",
			"dwr/interface/seguroVidaServicio.js",
			"dwr/interface/cajasVentanillaServicio.js",
			"dwr/interface/bloqueoSaldoServicio.js",
			"dwr/interface/utileriaServicio.js",
			"dwr/interface/opcionesPorCajaServicio.js",
			"dwr/interface/aportacionSocial.js",
			"dwr/interface/seguroCliente.js",
			"dwr/interface/catalogoServicios.js",
			"dwr/interface/tiposIdentiServicio.js",
			"dwr/interface/identifiClienteServicio.js",
			"dwr/interface/direccionesClienteServicio.js",
			"dwr/interface/institucionesServicio.js",
			"dwr/interface/abonoChequeSBCServicio.js",
			"dwr/interface/prospectosServicio.js",
			"dwr/interface/catalogoRemesasServicio.js",
			"dwr/interface/cuentasTransferServicio.js",
			"dwr/interface/castigosCarteraServicio.js",
			"dwr/interface/promotoresServicio.js",
			"dwr/interface/sucursalesServicio.js",
			"dwr/interface/apoyoEscolarSolServicio.js",
			"dwr/interface/socioMenorServicio.js",
			"dwr/interface/parametrosCajaServicio.js",
			"dwr/interface/sucursalesServicio.js",
			"dwr/interface/promotoresServicio.js",
			"dwr/interface/serviFunFoliosServicio.js",
			"dwr/interface/serviFunEntregadoServicio.js",
			"dwr/interface/chequesEmitidosServicio.js",
			"dwr/interface/asignarChequeSucurServicio.js",
			"dwr/interface/cuentaNostroServicio.js",
			"dwr/interface/tarjetaDebitoServicio.js",
			"dwr/interface/clientesCancelaServicio.js",
			"dwr/interface/catalogoGastosAntServicios.js",
			"dwr/interface/empleadosServicio.js",
			"dwr/interface/clienteExMenorServicio.js",
			"dwr/interface/motivActivacionServicio.js",
			"dwr/interface/opcionesPorCajaServicio.js",
			"dwr/interface/fileServicio.js",
			"dwr/interface/parametrosSisServicio.js",
			"dwr/interface/cuentasFirmaServicio.js",
			"dwr/interface/opRolServicio.js",
			"dwr/interface/clientesPROFUNServicio.js",
			"dwr/interface/paramFaltaSobraServicio.js",
			"dwr/interface/creditoDevGLServicio.js",
			"dwr/interface/usuarioServicios.js",
		
			"js/soporte/mascara.js",

			"js/jquery.lightbox-0.5.pack.js",
			pluginSocket,
			tipoImpresoraTicket,
			rutaImpTicket	);
	
	for (var i=0; i<arregloVentanilla.length; i++) { 
		importarScript( arregloVentanilla[i] ) ;
	}
	
	

}



function importarScript(nombre) {
    var s = document.createElement("script");
    s.setAttribute("type", "text/javascript");
    s.setAttribute("src",nombre);
    document.getElementsByTagName("head")[0].appendChild(s);
}



mostrarAlertaExpiraDocs();


