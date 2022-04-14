var siRequiereCalculoRatios='S';
var siRequiereReferencias='S';
var var_requiereDispersion = false;
var clienteSocio = $("#clienteSocio").val(); // indica si el sistema maneja clientes o socios
var var_TipoCredito= {
		"RENOVACION" 		: 'O',
		"REESTRUCTURA" 		: 'R',
		"CONSOLIDACION"		: 'N'
	};
var var_tabs = [];
		var_tabs.push
		var_tabs.push({id:'selecciona',href:"_selecciona",tabData:[]});
		var_tabs.push({id:'asignaCartas',href:"asignaCartasLiq",tabData:[]});
		var_tabs.push({id:'solic',href:"solicitud",tabData:[]});
		var_tabs.push({id:'datSosEc',href:"dtsSocioEcon",tabData:[]});
		var_tabs.push({id:'capacidadPagoPorSol',href:"capacidadPagoPorSolicitud",tabData:[]});	
		var_tabs.push({id:'buroCredito',href:"buroCred",tabData:[]});
		var_tabs.push({id:'aval',href:"contAvales",tabData:[]});
		var_tabs.push({id:'asigAval',href:"asignaAval",tabData:[]});
		var_tabs.push({id:'garan',href:"garantias",tabData:[]});
		var_tabs.push({id:'asigGaran',href:"asignaGarantias",tabData:[]});
		var_tabs.push({id:'referenciasSolicitud',href:"referenciasSol",tabData:[]});
		var_tabs.push({id:'dispersion',href:"instrucDispersion",tabData:[]});
		var_tabs.push({id:'check',href:"checklist",tabData:[]});

var var_globalFlujoConsolida = {};

var catTipoConsultaCarta = {
		  'principal'	: 1,
		  'solCred'	: 3
	};
var var_selectedTab = 'selecciona';

//Simula folio de consolidación
var var_consolidacion = {};
//    consolidaCartaID : 1,
//    clienteID : 8,
//    solicitudCreditoID:5279,
//    estatus:'A',
//    esConsolidado:'S',
//    flujoOrigen:'C',
//    tipoCredito:'O',
//    relacionado:100010569,
//	solicitudRelacionado:5156,
//    montoConsolida:1226000.00
//};
//este archivo es usado por flujoIndividualCatalogoVista.jsp
$(document).ready(function() {
	
	$('#numSolicitud').focus();

	
	var parametroBean = consultaParametrosSession(); 
		esTab = true;
		solicitudActual="";

	var catTipoTranCredito = {
  		'actualiza':3
  		};
	
	var catTipoActCredito = {
	  		 'rechazar':4,
	  		'liberar':5,
	  		'agregaComentario':7
	  };

	
	//------------ -------------------Metodos y Manejo de Eventos -----------------------------------------
    deshabilitaBoton('agregar', 'submit');
	agregaFormatoControles('formaMenu');
	deshabilitaBoton('cancelar');
	deshabilitaBoton('liberar');
	deshabilitaBoton('agregarComent');
	limpiaPestanias();
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$( '#tabs' ).tabs({
		ajaxOptions: {
			error: function( xhr, status, index, anchor ) {
				$( anchor.hash ).html("No fue posible mostrar el contenido. Estamos trabajando para corregir la falla. ");
			}
		}
    });				

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	
	
	$.validator.setDefaults({
			submitHandler: function(event) {
						grabaFormaTransaccionRetrollamada(event, 'formaMenu', 'contenedorForma', 'mensaje','true','numSolicitud',
								 'accionInicializaRegresoExitoso', 'accionInicializaRegresoFallo');	
			}
				
	});	
	
	$('#liberar').click(function() {
		$('#tipoTransaccion').val(catTipoTranCredito.actualiza);
		$('#tipoActualizacion').val(catTipoActCredito.liberar);
	});
	
	$('#cancelar').click(function() {		
		var motivoRechazo=''; 
		
		var comentarioEjec = $('#nuevosComents').val();
		var comentario = $.trim(comentarioEjec);
		if(comentario==''){
			motivoRechazo = prompt("Favor de Agregar el Motivo del Rechazo.");
			
			if(motivoRechazo != null){
				var motivoR = $.trim(motivoRechazo);
				motivoR = motivoR.toUpperCase();
				$('#motivoRechazo').val(motivoR);
			
			}else{
				return false;
			}	
			
		}else{
			motivoRechazo = confirm('Está Seguro que Este es el Motivo del Rechazo: "' +comentario+ '".');
			
			if(motivoRechazo == true){			
				$('#motivoRechazo').val(comentario);			
			}else{
				return false;
			}	
		}
		 
		$('#tipoTransaccion').val(catTipoTranCredito.actualiza);
		$('#tipoActualizacion').val(catTipoActCredito.rechazar);
	
	});
	
	
	$('#agregarComent').click(function() {		
		var comentarioEjec = $('#nuevosComents').val();
		var comentario = $.trim(comentarioEjec);
		if(comentario==''){
			mensajeSis("Agregue un Comentario.");
			return false;
		}
		
		$('#tipoTransaccion').val(catTipoTranCredito.actualiza);
		$('#tipoActualizacion').val(catTipoActCredito.agregaComentario);
		
	});
	
		
	$('#numSolicitud').blur(function() {
		if(esTab==true){
		consultaDatosSolicitud();
			}
	});

	$('#numSolicitud').bind('keyup',function(e){
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#numSolicitud').val();

			listaContenedor('numSolicitud', '1', '22', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}				       
	});
	
	
	$('#solic').click(function() {
		if(var_consolidacion.relacionado=='0')
		{
			var jqCred = $('#tbParametrizacion2 input[id="creditoIDInt1"]');
			if(jqCred.length > 0)
			{
			var_consolidacion.relacionado = jqCred.val();	
			}
			if(Number(var_consolidacion.montoConsolida)==0)
			{
				var montoConsolida = 0;
				$('#tbParametrizacion input[name="monto"]').each(function() {  // replace name based on mapping
    			montoConsolida = montoConsolida + Number(this.value);
				});
				$('#tbParametrizacion2 input[name="monto"]').each(function() {  // replace name based on mapping
    			montoConsolida = montoConsolida + Number(this.value);
				});
				var_consolidacion.montoConsolida = montoConsolida.toFixed(2);
			}
		}
		funcionCambiaTab(this);
		$("#solic").show();
		if ($(this).attr("href") != undefined ){  
			consultaSolicitudCredito();
		}
		$(this).removeAttr("href");
	});
	
	
	
	$('#check').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaCheckList();
		}
		$(this).removeAttr("href");
	});

	
	$('#aval').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaAvales(); 
		}
		$(this).removeAttr("href");		
	});
	
	
	$('#asigAval').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaAsignaAvales(); 
		}
		$(this).removeAttr("href");			
	});
	
	
	$('#garan').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaGarantias();  
		}
		$(this).removeAttr("href");
		
	});
	

	$('#asigGaran').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaAsignaGarantias();
		}
		$(this).removeAttr("href");

	});
	
	
	$('#datSosEc').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaDtsSocioEc();
		}
		$(this).removeAttr("href");		
	});
	
		
	
	$('#selecciona').click(function() {
		funcionCambiaTab(this);
		esTab=false; 
		consultaDatosSolicitud();
	});
	
	
	$('#calculaRatios').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaRatios();
		}
		$(this).removeAttr("href");		
	});
	
	$('#referenciasSolicitud').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaReferencias();
		}
		$(this).removeAttr("href");		
	});
	$('#obligadosSolidarios').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaObligadosSolidarios();
			
		}
		$(this).removeAttr("href");		
	});
	
	$('#asigObligado').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaAsignaObligados();
			
		}
		$(this).removeAttr("href");		
	});

	$('#asignaCartas').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaAsignaCartas();
			$("#asignaCartas").show();
			//consultaSolicitudCredito()
		} 
		$(this).removeAttr("href");
	});
	
	
		$('#buroCredito').click(function() {
		funcionCambiaTab(this);		
		$('#capacidadPagoPorSolicitud').html("");
		if ($(this).attr("href") != undefined ){  
			consultaBC();
		}
		$(this).removeAttr("href");		
	});
	
		$('#dispersion').click(function() {
		funcionCambiaTab(this);
		if ($(this).attr("href") != undefined ){  
			consultaInstruccionesDispersion();
		}
		$(this).removeAttr("href");		
	});
		
		$('#capacidadPagoPorSol').click(function() {
			funcionCambiaTab(this);
			if ($(this).attr("href") != undefined ){  
				consultaCapacidadPagoPorSol();
			}
			$(this).removeAttr("href");		
		});
	
	
	function funcionCambiaTab(tab)
	{
		funcionObtieneDatosTab(var_selectedTab);
		var_selectedTab = tab.id;
		for(var i=0;i<var_tabs.length;i++)
		{
			$("#"+var_tabs[i].id).attr("href" , "#"+var_tabs[i].href);
			if(var_tabs[i].id!="selecciona" && var_tabs[i].id!=tab.id)
			$("#"+var_tabs[i].href).html("");
		}
	}
	

		$('#formaMenu').validate({
			rules: {
			
			},

			messages: {
				 
			}		
		});
	
		
		
	// ===================================== FUNCIONES ============================================			
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =1;
		var rfc = ' ';
		setTimeout("$('#cajaListaContenedor').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){							
					$('#nombreCliente').val(cliente.nombreCompleto);
				}else{
					mensajeSis("No Existe el " + clienteSocio + ".");
					$(jqCliente).focus();
				}    						
			});
		}
	}
	

	function consultaSolicitudCredito(){
		$('#creditoRelacionadoID').val(var_consolidacion.relacionado);
		$('#solicitudRelacionadoID').val(var_consolidacion.solicitudRelacionado);
		$('#solicitud').load("solicitudCreditoConsolidacion.htm");
	}	
	
	function consultaAsignaCartas()
	{
		$('#asignaCartasLiq').load("asignaCartaLiq.htm"); 
	}
	
	function consultaBC(){
		$('#buroCred').load("consultaSolicitudBCVista.htm");
	}
	
	function consultaInstruccionesDispersion()
	{
		$('#instrucDispersion').load("instruccionDispersion.htm");
//		$('#instrucDispersion').html("<h2>En construcci&oacute;n</h2>");

	}
	
	function consultaAvales(){	
		$('#contAvales').load("avalesCatalogo.htm");
	}

	
	function consultaAsignaAvales(){
		$('#asignaAval').load("avalesPorSolicitud.htm");
	}
	
	function consultaGarantias(){
		$('#garantias').load("registroGarantia.htm");
	}

	function consultaAsignaGarantias(){
		$('#asignaGarantias').load("asignacionGarantia.htm");
	}
	
	function consultaCheckList(){
		$('#checklist').load("solicitudCheckList.htm");
	}
	
	function consultaDtsSocioEc(){
		$('#dtsSocioEcon').load("altaDatosSocioeconomicos.htm");
	}
	
	function consultaCapacidadPago(){
		 $('#capacidadPago').load("capacidadPagoVista.htm");
	}
	function consultaRatios(){
		$('#ratios').load("generacionRatios.htm");
	}
	function consultaAsignaObligados(){
		$('#asignaObligados').load("obligadosSolidSoliciCatalogoVista.htm");
	}
	function consultaReferencias(){
		$('#referenciasSol').load("referenciaCliente.htm");
	}
	function consultaObligadosSolidarios(){
		$('#obligadosSolidarios').load("obligadosSolidariosCatalogo.htm");
		
	}
	function consultaCapacidadPagoPorSol(){
		$('#capacidadPagoPorSolicitud').load("datosSocioEconomicocapacidadPagoSol.htm");
	}
}); // fin de documente



	function limpiaPestanias(){	
		for(var i=0;i<var_tabs.length;i++)
		{
			if(var_tabs[i].id!="selecciona")
			$("#"+var_tabs[i].id).hide();
		}
	}
	



	function muestraPestanias(){
		if($('#numSolicitud').val() == '0')
		{
			limpiaPestanias();
			$("#asignaCartas").show();
			//$("#solic").show();
		}
		else
		{
			for(var i=0;i<var_tabs.length;i++)
			{
				if(var_tabs[i].id=="dispersion")
				{
				 if(!var_requiereDispersion)
					 continue;
				}
				if(var_tabs[i].id!="selecciona")
				$("#"+var_tabs[i].id).show();
			}
				var tipoCon = 5;
		var opcionMenuID = 491;//491 es el numero de recurso en OPCIONESMENU para reporte de estimacion capacidad pago;
		var bean = {
				'rolID'	: parametroBean.perfilUsuario,
				'opcionMenuID': opcionMenuID
		};
		
		opRolServicio.consultaRolesPorOpcion(tipoCon, bean, function(datos) {
			if(datos.length >0){
				if(datos[0].opcionMenuID != undefined &&  datos[0].opcionMenuID == opcionMenuID ){
					$("#capacidadPag").show();
				}else{
					$("#capacidadPag").hide();				
				}
			}
		});	
		}
	
	}
	
	function validaNuevosComentarios(estatusSolicitud, jqComentarioNuevo){
		var inactiva = 'I';
		if(estatusSolicitud == inactiva){
			 habilitaBoton('agregarComent', 'submit');
			 $('#nuevosComents').removeAttr('disabled');
		}else{
			deshabilitaBoton('agregarComent', 'submit');
			$('#nuevosComents').attr('disabled',true);
			$('#nuevosComents').val('');
		}
	}
	
	
	function validaProductoRequiereGarantia(requiereGarantia){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereGarantia == siRequiere){
			$('#garan').show('slow');
			$('#asigGaran').show('slow');
		}
		if(requiereGarantia == noRequiere){
			$('#garantias').html("");				
			$('#asignaGarantias').html(""); 
			$('#garan').hide('slow');
			$('#asigGaran').hide('slow');
		}
	}
	
	function validaProductoRequiereAvales(requiereAvales){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereAvales == siRequiere){
			$('#aval').show('slow');
			$('#asigAval').show('slow');
			
		}
		if(requiereAvales == noRequiere){
			$('#contAvales').html("");	
			$('#asignaAval').html("");
			$('#aval').hide('slow');
			$('#asigAval').hide('slow');
		}
	}

	function validaProductoRequiereObligadosSolidarios(requiereObligadosSolidarios){
		var siRequiere = 'S';
		var noRequiere = 'N';	
		var indistinto = 'I';
		var cadena_vacia = '';
		if(requiereObligadosSolidarios == siRequiere){
			$('#obligado').show('slow');
			$('#asigObligado').show('slow');
			
		}
		if(requiereObligadosSolidarios == indistinto){
			$('#obligado').show('slow');
			$('#asigObligado').show('slow');
			
		}
		if(requiereObligadosSolidarios == noRequiere){
			$('#contObligados').html("");	
			$('#asignaObligados').html("");
			$('#obligado').hide('slow');
			$('#asigObligado').hide('slow');
		}
		if(requiereObligadosSolidarios == cadena_vacia){
			$('#contObligados').html("");	
			$('#asignaObligados').html("");
			$('#obligado').hide('slow');
			$('#asigObligado').hide('slow');
		}
	}
	function validaProductoRequiereReferencias(requiereReferencias){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereReferencias == siRequiere){
			$('#referenciasSolicitud').show('slow');			
		}
		if(requiereReferencias == noRequiere){
			$('#referenciasSol').html("");	
			$('#referenciasSolicitud').hide('slow');
		}
	}
	
	
	function validaContieneComentario(comentario){
		var comentarioEjecutivo =  $.trim(comentario);
		if(comentarioEjecutivo !=''){
			$('#comentEjecut').val(comentarioEjecutivo);
			$('#comentDeEjecutivo').show('slow');			
			$('#labelHistorialCom').show('slow');
		}else{
			$('#comentEjecut').val('');
			$('#comentDeEjecutivo').hide('slow');
			$('#labelHistorialCom').hide('slow');
		}
	}
	
	
	 
	function validaProductoEsNominaRequiereCapPago(requiereCapacidadPago){
		var siRequiere='S';

		if (requiereCapacidadPago == siRequiere){

			var solicitudCreditoID = $('#numSolicitud').val();

			if(solicitudCreditoID != '' && !isNaN(solicitudCreditoID)){

				var solicitudBean = { 
					'solicitudCreditoID': solicitudCreditoID
				};

				solicitudCredServicio.consulta(16,solicitudBean, { async: false, callback: function(solicitudCred) {
					if(solicitudCred != null){
						if(solicitudCred.manejaCapPago == 'S'){
							$('#capacidadPagoPorSol').show('slow');
						}

						if(solicitudCred.manejaCapPago == 'N'){
							$('#capacidadPagoPorSolicitud').html("");
							$('#capacidadPagoPorSol').hide('slow');
						}
					}else{
						$('#capacidadPagoPorSolicitud').html("");
						$('#capacidadPagoPorSol').hide('slow');
					}
				}});
			}
		}else{
			$('#capacidadPagoPorSolicitud').html("");
			$('#capacidadPagoPorSol').hide('slow');
		}
	}

	function consultacicloCliente(idControlCicloCliente, par_Cliente, par_Prospecto, par_ProductoCredito, par_Grupo){
		var sqCicloCliente = eval("'#"+idControlCicloCliente+"'");
		var CicloCreditoBean = {
				'clienteID':par_Cliente,
				'prospectoID':par_Prospecto,
				'productoCreditoID':par_ProductoCredito,
				'grupoID':par_Grupo
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		solicitudCredServicio.consultaCiclo(CicloCreditoBean,function(cicloCreditoCte) {
			if(cicloCreditoCte !=null){
				$(sqCicloCliente).val(cicloCreditoCte.cicloCliente);
			}	
			else{
				mensajeSis('No hay Ciclo para el ' + clienteSocio + '.');
			}
		});

	}
	
	function consultaProducCredito(idControlDecripcion, valor) {
		var jqProdCred  = eval("'#" + idControlDecripcion + "'");
		var ProdCredBeanCon = {
				'producCreditoID':valor 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		if(valor != '' && !isNaN(valor) ){		
			productosCreditoServicio.consulta(2,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$(jqProdCred).val(prodCred.descripcion);
				}else{							
					mensajeSis('No Existe el Producto de Crédito.');
					$(jqProdCred).val('');
				}
			});
		}				 					
	}
	
	function consultaDatosSolicitud(){
		var_requiereDispersion = false;
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		$('#nuevosComents').val('');
		
		if(isNaN($('#numSolicitud').val()) ){
			inicializaForma('contenedorForma', 'numSolicitud');
			$('#numSolicitud').focus().select();
			deshabilitaBoton('cancelar');
			deshabilitaBoton('liberar');
			deshabilitaBoton('agregarComent');
			limpiaPestanias();
		}else{
			if( $.trim($('#numSolicitud').val())!= "" && $.trim($('#numSolicitud').val())!= "0" ){
				var SolCredBeanCon = {
						'solicitudCreditoID':$('#numSolicitud').val(),
						'usuario': parametroBean.numeroUsuario
				}; 
				solicitudCredServicio.consulta(1, SolCredBeanCon,function(solicitud) {
					if (solicitud != null && solicitud.solicitudCreditoID != 0) {
						if(solicitud.tipoCredito == var_TipoCredito.CONSOLIDACION || solicitud.tipoCredito == var_TipoCredito.RENOVACION){
								var ProdCredBeanCon = {
										'producCreditoID':solicitud.productoCreditoID 
								}; 
								setTimeout("$('#cajaLista').hide();", 200);
								
								productosCreditoServicio.consulta(1,ProdCredBeanCon,function(prodCred) {
									if(prodCred!=null){
										if(prodCred.esGrupal == 'N'){
											if(prodCred.instruDispersion=='S')
												{
													var_requiereDispersion = true;
												}
											muestraPestanias();
											$('#Integrantes').show();
											$('#numSolicitud').val(solicitud.solicitudCreditoID);
											consultacicloCliente('cicloActual', solicitud.clienteID, solicitud.prospectoID, solicitud.productoCreditoID, '');
											$('#fechaRegistro').val(solicitud.fechaRegistro);
											$('#productoCredito').val(	solicitud.productoCreditoID);
											$('#nombreProducto').val(prodCred.descripcion);
											
											
											switch(solicitud.estatus){
												case 'I':$('#nombreEstatus').val('INACTIVA');break;
												case 'L':$('#nombreEstatus').val('LIBERADA');break;
												case 'A':$('#nombreEstatus').val('AUTORIZADA');break;
												case 'C':$('#nombreEstatus').val('CANCELADA');break;
												case 'R':$('#nombreEstatus').val('RECHAZADA');break;
												case 'D':$('#nombreEstatus').val('DESEMBOLSADA');break;
												default:$('#nombreEstatus').val('Estatus No identificado');
											}
											
											$('#solicitudCre1').val(solicitud.solicitudCreditoID);
											$('#creditoID1').val(solicitud.creditoID);
											$('#prospectIDGrupal').val(solicitud.prospectoID);
											$('#clientIDGrupal').val(solicitud.clienteID);
											
											
											if($('#prospectIDGrupal').val()=='0'){
												$('#nomb1').val(solicitud.nombreCompletoCliente);
											}else{
												$('#nomb1').val(solicitud.nombreCompletoProspecto);
											}
											$('#montSolicit').val(solicitud.montoSolici);
											$('#montoAutori').val(solicitud.montoAutorizado);
											$('#fechaIni1').val(solicitud.fechaInicio);
											$('#fechaVencimiento1').val(solicitud.fechaVencimiento);
											
											validaProductoRequiereGarantia(prodCred.requiereGarantia);
											validaProductoRequiereAvales(prodCred.requiereAvales);
											validaProductoRequiereObligadosSolidarios(prodCred.requiereObligadosSolidarios);
											validaProductoRequiereReferencias(prodCred.requiereReferencias);
											validaContieneComentario(solicitud.comentarioEjecutivo);
											validaNuevosComentarios(solicitud.estatus,$('#nuevosComentarios1').val());
											validaProductoEsNominaRequiereCapPago(prodCred.productoNomina);
											if(prodCred.calculoRatios == siRequiereCalculoRatios){
												$('#calculaRatios').show('slow');
												
											}else{
												$('#calculaRatios').hide('slow');
												$('#ratios').html("");	
											}	
											
											habilitaBoton('cancelar');
											habilitaBoton('liberar');
											
											$('#montSolicit').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
											$('#montoAutori').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
											
											var_consolidacion.solicitudCreditoID = solicitud.solicitudCreditoID;
											
											if( var_consolidacion.solicitudCreditoID !== undefined && var_consolidacion.solicitudCreditoID !== '0')
											{
													var asignaCartaBean = {
														'solicitudCreditoID': var_consolidacion.solicitudCreditoID
													}
													asignaCartaLiqServicio.consulta(catTipoConsultaCarta.solCred, asignaCartaBean, function(asigCartaLiq) {
													if(asigCartaLiq != null) {
														var_consolidacion.consolidaCartaID = asigCartaLiq.consolidacionID;
														var_consolidacion.consolidacionCartaID =  asigCartaLiq.consolidacionID;
														$('#consolidacionCartaID').val(asigCartaLiq.consolidacionID);
													}
												});
											}
											
										}else{
											mensajeSis("La Solicitud de Crédito Seleccionada debe ser de Consolidación.");
											inicializaForma('contenedorForma', 'numSolicitud');
											$('#numSolicitud').focus().select();
											deshabilitaBoton('cancelar');
											deshabilitaBoton('liberar');
											deshabilitaBoton('agregarComent');
											limpiaPestanias();
										}
										
									}else{							
										mensajeSis('No Existe el Producto de Crédito.');
										inicializaForma('contenedorForma', 'numSolicitud');
										$('#numSolicitud').focus().select();
										deshabilitaBoton('cancelar');
										deshabilitaBoton('liberar');
										deshabilitaBoton('agregarComent');
										limpiaPestanias();
									}
								});
					
						}else{
							mensajeSis('El Número Indicado No Corresponde a una Solicitud de Consolidación.');
							inicializaForma('contenedorForma', 'numSolicitud');
							$('#numSolicitud').focus().select();
							deshabilitaBoton('cancelar');
							deshabilitaBoton('liberar');
							deshabilitaBoton('agregarComent');
							limpiaPestanias();
						}
						
					}else{
						mensajeSis('No Existe la Solicitud de Crédito.');
						inicializaForma('contenedorForma', 'numSolicitud');
						$('#numSolicitud').focus().select();
						deshabilitaBoton('cancelar');
						deshabilitaBoton('liberar');
						deshabilitaBoton('agregarComent');
						limpiaPestanias();
					}
				});
				
			}else if ($.trim($('#numSolicitud').val()) == "0"){
				inicializaForma('formaMenu', 'numSolicitud');
				muestraPestanias();
				var_consolidacion = {};
				deshabilitaBoton('cancelar');
				deshabilitaBoton('liberar');
				if(esTab)
				$('#asignaCartas').click();
			}else{
					inicializaForma('contenedorForma', 'numSolicitud');
					deshabilitaBoton('cancelar');
					deshabilitaBoton('liberar');
					deshabilitaBoton('agregarComent');
					limpiaPestanias();					
				
			}
		}
	}



	function accionInicializaRegresoExitoso(){
		$('#montSolicit').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#montoAutori').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#selecciona').click();
	}
	
	function accionInicializaRegresoFallo(){
		$('#montSolicit').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#montoAutori').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	}	
	
	function funcionObtieneDatosTab(tabId)
	{
	 var elementsToSearch = ['input','select'];
	 var element = {};
	 var elements = [];
	 var tab = {};
	 var html = $('#'+tabId).html();
	 var length = html.length;
	 var index = -1;
	 var closingIndex = 0;
	 var line = '';
	 var selector = '';
	 var contador = 0;
	 tab.id = tabId;
	 for(var i=0;i<elementsToSearch.length;i++)
	 {	
	 	index = html.indexOf(elementsToSearch[i]);
	 	closingIndex = 0;
	 	line = '';
	    contador =  0;
		 while(index > -1)
	 	{
	        contador ++;
	    	element = {};
	  		closingIndex = html.indexOf('>',index);
	        if(contador>100)
	        break;
	  		line = html.substring(index,closingIndex);
	  		index = line.indexOf('id');
	  		if(index>-1)
	  		{
	    	element.id = line.substring(index+4,line.indexOf('"',index+4));
	        if(elementsToSearch[i]=='select')
	        {
	        selector = 'div[id^='+divId+'] > #'+element.id+' option:selected';
	        element.value = $(selector).text();
	        }
	        else
	        {
	        selector = 'div[id^='+divId+'] > '+elementsToSearch[i]+'[id^='+element.id+']';
	        element.value = $(selector).val();
	        }
	 	 	}
	        elements.push(element);
	  		index = html.indexOf(elementsToSearch[i],closingIndex+2);
	 	}
	 }
	 tab.elements = elements;

	 for(var j=0;j<var_tabs.length;j++)
		{
			if(var_tabs[j].id == tab.id)
			{
				var_tabs[j].tabData = tab.elements;
			}
		}
	}


	function funcionMuestraDatosTabs()
	{
	  var html = '';
     
		for(var j=0;j<var_tabs.length;j++)
		{	
			  html = html + '<h3>'+var_tabs[j].id+'</h3><table><tr><th>id</th><th>value</hh></tr>';
			  for(var i=0;i<var_tabs[j].tabData.length;i++)
			  {
			   html = html + '<tr>';
			      html = html + '<td>'+var_tabs[j].tabData[i].id+'</td><td>'+var_tabs[j].tabData[i].value+'</td>';
			   html = html + '</tr>';   
			  }
			  $('#pruebaDatos').html($('#pruebaDatos').html()+html);
	 	}
	}
	
	function funcionCambiaTab(tab)
	{
		funcionObtieneDatosTab(var_selectedTab);
		var_selectedTab = tab.id;
		for(var i=0;i<var_tabs.length;i++)
		{
			$("#"+var_tabs[i].id).attr("href" , "#"+var_tabs[i].href);
			if(var_tabs[i].id!="selecciona" && var_tabs[i].id!=tab.id)
			$("#"+var_tabs[i].href).html("");
		}
	}
	
	function consultaAsignaCartas()
	{
		$('#asignaCartasLiq').load("asignaCartaLiq.htm"); 
	}
