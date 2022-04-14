var siRequiereCalculoRatios='S';
var siRequiereReferencias='S';
var clienteSocio = $("#clienteSocio").val(); // indica si el sistema maneja clientes o socios
var parametroBean = consultaParametrosSession();

//este archivo es usado por flujoIndividualCatalogoVista.jsp
$(document).ready(function() {

	$('#numSolicitud').focus();

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
			listaContenedor('numSolicitud', '1', '21', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}
	});


	$('#solic').click(function() {

		$("#selecciona").attr("href", "#_selecciona");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#autAval").attr("href" ,"#autorizaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#conceptoInver").attr("href" , "#conInver");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#autorizaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");

		if ($(this).attr("href") != undefined ){
			bloquearPantalla();
			consultaSolicitudCredito();
		}
		$(this).removeAttr("href");
	});

	$('#bc').click(function() {

		$("#selecciona").attr("href= '#_selecciona'");
		$("#solic").attr("href", "#solicitud");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href", "#asignaAval");
		$("#autAval").attr("href" ,"#autorizaAval");
		$("#garan").attr("href" , "#garantias");
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#autorizaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined ){
			bloquearPantalla();
			consultaBC() ;
		}
		$(this).removeAttr("href");
	});

	$('#check').click(function() {

		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#autAval").attr("href" ,"#autorizaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#conceptoInver").attr("href" , "#conInver");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#autorizaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");

		if ($(this).attr("href") != undefined ){
			bloquearPantalla();
			consultaCheckList();
		}
		$(this).removeAttr("href");
	});


	$('#aval').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#autAval").attr("href" ,"#autorizaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#conceptoInver").attr("href" , "#conInver");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#asignaAval').html("");
		$('#autorizaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined ){
			bloquearPantalla();
			consultaAvales();
		}
		$(this).removeAttr("href");
	});


	$('#asigAval').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#autAval").attr("href" ,"#autorizaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#conceptoInver").attr("href" , "#conInver");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#autorizaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined ){
			bloquearPantalla();
			consultaAsignaAvales();
		}
		$(this).removeAttr("href");
	});

	$('#autAval').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#conceptoInver").attr("href" , "#conInver");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined ){
			bloquearPantalla();
			consultaAutorizaAvales();
		}
		$(this).removeAttr("href");
	});


	$('#garan').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#autAval").attr("href" ,"#autorizaAval");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#conceptoInver").attr("href" , "#conInver");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#asignaGarantias').html("");
		$('#autorizaAval').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined ){
			bloquearPantalla();
			consultaGarantias();
		}
		$(this).removeAttr("href");

	});


	$('#asigGaran').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#autAval").attr("href" ,"#autorizaAval");
		$("#garan").attr("href", "#garantias");
		$("#check").attr("href" , "#checklist");
		$("#conceptoInver").attr("href" , "#conInver");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#autorizaAval').html("");
		$('#garantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined ){
			bloquearPantalla();
			consultaAsignaGarantias();
		}
		$(this).removeAttr("href");

	});

	$('#datSosEc').click(function() {
		$("#selecciona").attr("href", "#_selecciona");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#autAval").attr("href" ,"#autorizaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#conceptoInver").attr("href" , "#conInver");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#autorizaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined ){
			bloquearPantalla();
			consultaDtsSocioEc();
		}
		$(this).removeAttr("href");
	});



	$('#selecciona').click(function() {
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#autAval").attr("href" ,"#autorizaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#conceptoInver").attr("href" , "#conInver");

		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#autorizaAval').html("");
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
		$("#bc").attr("href", "#burocredito");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#autAval").attr("href" ,"#autorizaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#check").attr("href" , "#checklist");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#autorizaAval').html("");
		$('#garantias').html("");
		$('#dtsSocioEcon').html("");
		$('#asignaGarantias').html("");
		if ($(this).attr("href") != undefined ){
			bloquearPantalla();
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

    // cambiar por la Ruta de Consolidacion vvargas
	function consultaSolicitudCredito(){
		$('#solicitud').load("solicitudCreditoConsolidacionAgro.htm",function(){ setTimeout(function(){desbloquearPantalla();},3000)});
	}

	function consultaBC(){
		$('#burocredito').load("consultaSolicitudBCVista.htm",function(){ setTimeout(function(){desbloquearPantalla();},3000)});
	}

	function consultaAvales(){
		$('#contAvales').load("avalesAgroCatalogo.htm",function(){ setTimeout(function(){desbloquearPantalla();},3000)});
	}


	function consultaAsignaAvales(){
		$('#asignaAval').load("avalesPorSolicitudAgro.htm",function(){ setTimeout(function(){desbloquearPantalla();},3000)});
	}

	function consultaAutorizaAvales(){
		$('#autorizaAval').load("autorizaAvalesAgro.htm",function(){ setTimeout(function(){desbloquearPantalla();},3000)});
	}

	function consultaGarantias(){
		$('#garantias').load("registroGarantiaAgro.htm",function(){ setTimeout(function(){desbloquearPantalla();},3000)});
	}

	function consultaAsignaGarantias(){
		$('#asignaGarantias').load("asignacionGarantiaAgro.htm",function(){ setTimeout(function(){desbloquearPantalla();},3000)});
	}

	function consultaCheckList(){
		$('#checklist').load("solicitudCheckListAgro.htm",function(){ setTimeout(function(){desbloquearPantalla();},3000)});
	}

	function consultaDtsSocioEc(){
		$('#dtsSocioEcon').load("altaDatSocioEcoAgro.htm",function(){ setTimeout(function(){desbloquearPantalla();},3000)});
	}

		function consultaConInversion(){
		$('#conInver').load("conceptosInversionAgro.htm",function(){ setTimeout(function(){desbloquearPantalla();},3000)});
	}

}); // fin de documente



	function limpiaPestanias(){

		$("#solic").hide();
		$("#bc").hide();
		$("#datSosEc").hide();
		$("#check").hide();
		$("#aval").hide();
		$("#garan").hide();
		$("#asigAval").hide();
		$("#autAval").hide();
		$("#asigGaran").hide();
		$("#conceptoInver").hide();
	}



	function muestraPestanias(){
		$("#solic").show();
		$("#bc").show();
		$("#datSosEc").show();
		$("#check").show();
		$("#aval").show();
		$("#garan").show();
		$("#asigAval").show();
		$("#autAval").show();
		$("#asigGaran").show();
		$("#conceptoInver").show();


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
			$('#autAval').show('slow');

		}
		if(requiereAvales == noRequiere){
			$('#contAvales').html("");
			$('#asignaAval').html("");
			$('#autorizaAval').html("");
			$('#aval').hide('slow');
			$('#asigAval').hide('slow');
			$('#autAval').hide('slow');
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
		$('#valorReestructura').val("S");

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
				solicitudCredServicio.consulta(9, SolCredBeanCon,function(solicitud) {
					if (solicitud != null && solicitud.solicitudCreditoID != 0 && solicitud.esConsolidacionAgro == 'S') {
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
									validaProductoRequiereCheckList(prodCred.requiereCheckList);
									if(prodCred.calculoRatios == siRequiereCalculoRatios){
										$('#calculaRatios').show('slow');

									}else{
										$('#calculaRatios').hide('slow');
										$('#ratios').html("");
									}
									if(solicitud.estatus == 'I' || solicitud.estatus == 'L'  ){
										habilitaBoton('cancelar');
										habilitaBoton('liberar');
									}else{
										deshabilitaBoton('cancelar');
										deshabilitaBoton('liberar');
									}

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

						var mensajePantalla = 'La Solicitud de Crédito no Corresponde a una Consolidación.';
						if(solicitud.tipoCredito == "N"){
							mensajePantalla = "La Solicitud de Crédito " +solicitud.solicitudCreditoID +
	   	   									  " no es del Tipo Consolidación.<br>Favor de consultarla en " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualAgro.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\"> Flujo Individual Solicitud de Crédito Agro. <img src=\"images/external.png\"></a></b>";
						}
						if(solicitud.tipoCredito == 'R'){
							mensajePantalla = "La Solicitud de Crédito " +solicitud.solicitudCreditoID +
	   	   									  " no es del Tipo Consolidación.<br>Favor de consultarla en " + "<b><a onclick=\"$('#Contenedor').load('flujoIndivReestructuraAgro.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\"> Flujo Individual Reestructura Agro. <img src=\"images/external.png\"></a></b>";

						}
						if(solicitud.tipoCredito == 'O'){
							mensajePantalla = "La Solicitud de Crédito " +solicitud.solicitudCreditoID +
	   	   									  " no es del Tipo Consolidación.<br>Favor de consultarla en " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualRenovacionFiraVista.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\"> Flujo Individual Renovacion Agro. <img src=\"images/external.png\"></a></b>";
						}
						mensajeSis(mensajePantalla);
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
				$("#autAval").hide();
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


function validaProductoRequiereCheckList(requiereCheckList){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereCheckList == siRequiere){
			$('#check').show('slow');
		}
		if(requiereCheckList == noRequiere){
			$('#checklist').html("");
			$('#check').hide('slow');
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