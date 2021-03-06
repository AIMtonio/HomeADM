var siRequiereCalculoRatios='S';
var siRequiereReferencias='S';
var clienteSocio = $("#clienteSocio").val(); // indica si el sistema maneja clientes o socios
var var_TipoCredito= {
		"RENOVACION" 		: 'O',
		"REESTRUCTURA" 		: 'R'
	};
var SolicitudCreditoCon = {
 		 'Con_RenovacionesAgro': 15
 };

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
			motivoRechazo = confirm('Est?? Seguro que Este es el Motivo del Rechazo: "' +comentario+ '".');
			
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
		consultaDatosSolicitud();
	});

	$('#numSolicitud').bind('keyup',function(e){
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#numSolicitud').val();

			listaContenedor('numSolicitud', '1', '18', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}				       
	});
	
	
	$('#solic').click(function() {
		
	  	$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");	
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");		
		$('#conInver').html("");


		if ($(this).attr("href") != undefined ){  
			consultaSolicitudCredito();
		}
		$(this).removeAttr("href");
	});
	
	
	
	$('#check').click(function() {

	  	$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");	
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");		
		$('#conInver').html("");


		if ($(this).attr("href") != undefined ){  
			consultaCheckList();
		}
		$(this).removeAttr("href");
	});

	
	$('#aval').click(function() {
	  	$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");	
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");		
		$('#conInver').html("");


		if ($(this).attr("href") != undefined ){  
			consultaAvales(); 
		}
		$(this).removeAttr("href");		
	});
	
	
	$('#asigAval').click(function() {
	  	$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");	
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");		
		$('#conInver').html("");


		if ($(this).attr("href") != undefined ){  
			consultaAsignaAvales(); 
		}
		$(this).removeAttr("href");			
	});
	
	
	$('#garan').click(function() {
		
	  	$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");	
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");		
		$('#conInver').html("");


		if ($(this).attr("href") != undefined ){  
			consultaGarantias();  
		}
		$(this).removeAttr("href");
		
	});
	

	$('#asigGaran').click(function() {
	  	$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");	
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");		
		$('#conInver').html("");


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
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");		
		$('#conInver').html("");


		if ($(this).attr("href") != undefined ){  
			consultaDtsSocioEc();
		}
		$(this).removeAttr("href");		
	});
	
		
	
	$('#selecciona').click(function() {
	  	$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");	
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");		
		$('#conInver').html("");


		esTab=true; 
		consultaDatosSolicitud();
	});
	

	$('#conceptoInver').click(function() {
	  	$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");	
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#asignaAval').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");		
		$('#conInver').html("");


		if ($(this).attr("href") != undefined ){  
			consultaConInversion();
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
		$('#solicitud').load("solicitudCreditoRenovacionFira.htm"); 
	}	
	
	function consultaBC(){
		$('#burocredito').load("consultaSolicitudBCVista.htm");
	}
	
	function consultaAvales(){	
		$('#contAvales').load("avalesAgroCatalogo.htm");
	}

	
	function consultaAsignaAvales(){
		$('#asignaAval').load("avalesPorSolicitudAgro.htm");
	}
	
	function consultaGarantias(){
		$('#garantias').load("registroGarantiaAgro.htm");
	}

	function consultaAsignaGarantias(){
		$('#asignaGarantias').load("asignacionGarantiaAgro.htm");
	}
	
	function consultaCheckList(){
		$('#checklist').load("solicitudCheckListAgro.htm");
	}
	
	function consultaDtsSocioEc(){
		$('#dtsSocioEcon').load("altaDatSocioEcoAgro.htm");
	}
	
	function consultaCapacidadPago(){
		 $('#capacidadPago').load("capacidadPagoVista.htm");
	}
	function consultaConInversion(){
		$('#conInver').load("conceptosInversionAgro.htm");
	}
}); // fin de documente



	function limpiaPestanias(){
		//$("#selecciona").html("");
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
		$("#obligadosSolidarios").hide();
		$("#asigObligado").hide();
		$("#conceptoInver").hide();

	}
	



	function muestraPestanias(){
		//$("#selecciona").html("");
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
		$("#obligadosSolidarios").show();
		$("#asigObligado").show();
		$("#conceptoInver").show();

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

	function validaProductoRequiereObligadosSolidarios(requiereObligadosSolidarios){
			$('#contObligados').html("");	
			$('#asignaObligados').html("");
			$('#obligado').hide('slow');
			$('#asigObligado').hide('slow');
	}
	function validaProductoRequiereReferencias(requiereReferencias){
			$('#referenciasSol').html("");	
			$('#referenciasSolicitud').hide('slow');
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
					mensajeSis('No Existe el Producto de Cr??dito.');
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
				
				solicitudCredServicio.consulta(SolicitudCreditoCon.Con_RenovacionesAgro, SolCredBeanCon,function(solicitud) {
					if (solicitud != null && solicitud.solicitudCreditoID != 0) {
						
						if(solicitud.tipoCredito == var_TipoCredito.RENOVACION){
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
											
											validaContieneComentario(solicitud.comentarioEjecutivo);
											validaNuevosComentarios(solicitud.estatus,$('#nuevosComentarios1').val());
	
											
											habilitaBoton('cancelar');
											habilitaBoton('liberar');
											
											$('#montSolicit').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
											$('#montoAutori').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
											
										}else{
											mensajeSis("La Solicitud de Cr??dito Seleccionada debe ser Individual.");
											inicializaForma('contenedorForma', 'numSolicitud');
											$('#numSolicitud').focus().select();
											deshabilitaBoton('cancelar');
											deshabilitaBoton('liberar');
											deshabilitaBoton('agregarComent');
											limpiaPestanias();
										}
										
									}else{							
										mensajeSis('No Existe el Producto de Cr??dito.');
										inicializaForma('contenedorForma', 'numSolicitud');
										$('#numSolicitud').focus().select();
										deshabilitaBoton('cancelar');
										deshabilitaBoton('liberar');
										deshabilitaBoton('agregarComent');
										limpiaPestanias();
									}
								});
					
						}else{
							mensajeSis('El N??mero Indicado No Corresponde a una Solicitud de Cr??dito Renovaci??n.');
							inicializaForma('contenedorForma', 'numSolicitud');
							$('#numSolicitud').focus().select();
							deshabilitaBoton('cancelar');
							deshabilitaBoton('liberar');
							deshabilitaBoton('agregarComent');
							limpiaPestanias();
						}
						
					}else{
						mensajeSis('No Existe la Solicitud de Renovaci??n de Cr??dito Agro.');
						inicializaForma('contenedorForma', 'numSolicitud');
						$('#numSolicitud').focus().select();
						deshabilitaBoton('cancelar');
						deshabilitaBoton('liberar');
						deshabilitaBoton('agregarComent');
						limpiaPestanias();
					}
				});
				
			}else if ($.trim($('#numSolicitud').val()) == "0"){
				limpiaPestanias();
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
