var siRequiereCalculoRatios='S';
var siRequiereReferencias='S';
var clienteSocio = $("#clienteSocio").val(); // indica si el sistema maneja clientes o socios
var var_TipoCredito= {
		"RENOVACION" 		: 'O',
		"REESTRUCTURA" 		: 'R'
	};

listaPersBloqBean = {
        'estaBloqueado' :'N',
        'coincidencia'  :0
};

consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente           ='CTE';
var esProspecto			='PRO';

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

			listaContenedor('numSolicitud', '1', '16', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}				       
	});
	
	
	$('#solic').click(function() {

		$("#selecciona").attr("href", "#_selecciona");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");	
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");		
		$('#ratios').html("");
		$('#referenciasSol').html("");
		
		if ($(this).attr("href") != undefined ){  
			consultaSolicitudCredito();
		}
		$(this).removeAttr("href");
	});
	
	
	
	$('#check').click(function() {

		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$('#solicitud').html(""); 
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaCheckList();
		}
		$(this).removeAttr("href");
	});

	
	$('#aval').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");	
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$('#solicitud').html(""); 
		$('#checklist').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html(""); 
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaAvales(); 
		}
		$(this).removeAttr("href");		
	});
	
	
	$('#asigAval').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaAsignaAvales(); 
		}
		$(this).removeAttr("href");			
	});
	
	
	$('#garan').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaGarantias();  
		}
		$(this).removeAttr("href");
		
	});
	

	$('#asigGaran').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#check").attr("href" , "#checklist");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");		
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaAsignaGarantias();
		}
		$(this).removeAttr("href");

	});
	
	
	$('#datSosEc').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");	
		$('#asignaGarantias').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaDtsSocioEc();
		}
		$(this).removeAttr("href");		
	});
	
		
	
	$('#selecciona').click(function() {
		$("#solic").attr("href", "#solicitud");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");	
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html(""); 
		$('#ratios').html("");
		$('#referenciasSol').html("");
		esTab=true; 
		consultaDatosSolicitud();
	});
	
	
	$('#calculaRatios').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");
		$('#dtsSocioEcon').html("");
		$('#asignaGarantias').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaRatios();
		}
		$(this).removeAttr("href");		
	});
	
	$('#referenciasSolicitud').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");
		$('#dtsSocioEcon').html("");
		$('#asignaGarantias').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaReferencias();
		}
		$(this).removeAttr("href");		
	});

	

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
		$('#solicitud').load("solicitudCreditoReacreditamiento.htm"); 
	}	
	
	function consultaBC(){
		$('#burocredito').load("consultaSolicitudBCVista.htm");
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
	function consultaReferencias(){
		$('#referenciasSol').load("referenciaCliente.htm");
	}
	
}); // fin de documento



	function limpiaPestanias(){
		$("#solic").hide();
		$("#bc").hide();	
		$("#datSosEc").hide();	
		$("#check").hide();	
		$("#aval").hide();
		$("#garan").hide();			
		$("#asigAval").hide();	
		$("#asigGaran").hide();		
		$("#capacidadPag").hide();	
		$("#calculaRatios").hide();
		$("#referenciasSolicitud").hide();
	}



	function muestraPestanias(){
		$("#solic").show();
		$("#bc").show();	
		$("#datSosEc").show();	
		$("#check").show();	
		$("#aval").show();
		$("#garan").show();			
		$("#asigAval").show();	
		$("#asigGaran").show();		
		$("#calculaRatios").show();
		$("#referenciasSolicitud").show();
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
						if(solicitud.prospectoID =='0'){
							listaPersBloqBean = consultaListaPersBloq(solicitud.clienteID, esCliente, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(solicitud.clienteID,'LPB',esCliente);
						}else{
							listaPersBloqBean = consultaListaPersBloq(solicitud.prospectoID, esProspecto, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(solicitud.prospectoID,'LPB',esProspecto);
						}
						if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
							if(solicitud.tipoCredito == var_TipoCredito.RENOVACION && solicitud.esReacreditado == "S"){
									var ProdCredBeanCon = {
											'producCreditoID':solicitud.productoCreditoID 
									}; 
									setTimeout("$('#cajaLista').hide();", 200);
									
									productosCreditoServicio.consulta(1,ProdCredBeanCon,function(prodCred) {
										if(prodCred!=null){
											if(prodCred.esGrupal == 'N'){
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
												validaProductoRequiereReferencias(prodCred.requiereReferencias);
												validaContieneComentario(solicitud.comentarioEjecutivo);
												validaNuevosComentarios(solicitud.estatus,$('#nuevosComentarios1').val());
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
												
											}else{
												mensajeSis("La Solicitud de Crédito Seleccionada debe ser Individual.");
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
								mensajeSis('El Número Indicado No Corresponde a una Solicitud de Crédito de Reacreditación.');
								inicializaForma('contenedorForma', 'numSolicitud');
								$('#numSolicitud').focus().select();
								deshabilitaBoton('cancelar');
								deshabilitaBoton('liberar');
								deshabilitaBoton('agregarComent');
								limpiaPestanias();
							}
					}else{
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
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
				$("#solic").show();
				$('#solic').click();
				$("#bc").hide();	
				$("#datSosEc").hide();	
				$("#check").hide();	
				$("#aval").hide();
				$("#garan").hide();			
				$("#asigAval").hide();	
				$("#asigGaran").hide();		
				$("#capacidadPag").hide();	
				$("#calculaRatios").hide();
				
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
	}
	
	function accionInicializaRegresoFallo(){
		$('#montSolicit').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#montoAutori').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	}	
