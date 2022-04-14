
$(document).ready(function() {
	parametros = consultaParametrosSession();
	esTab=false;
	// Declaración de constantes
	var catTipoConsultaSolicitud = {
	  		'principal'		: 9,
	  		'foranea'		: 2,
	  		'solCheckList'	: 6
		};

	var catTipoTranSolChecList = {
		'actualiza'		: 1,

	};

	$(':text').focus(function() {
		esTab = false;
   	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('grabar', 'submit');
   deshabilitaBoton('expediente', 'submit');
	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
      submitHandler: function(event) {

    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','solicitudCreditoID',
    			  				'exitoCheckLisCredito', 'falloCheckLisCredito');

      }
   });


	$('#expediente').click(function() {
		if($('#clienteID').val()==''&& $('#prospectoID').val()==''){
			mensajeSis("No existe un cliente o Prospecto");
		}else{
			consultaNumeroDocumentosPorCliente();
		}
	});


	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTranSolChecList.actualiza);
		guardarCodigos();


	});


	$('#solicitudCreditoID').bind('keyup',function(e){
		if(esTab){
			if(this.value.length >= 0){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				parametrosLista[0] = $('#solicitudCreditoID').val();

				lista('solicitudCreditoID', '1', '14', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
			}
		}
	});



	$('#solicitudCreditoID').blur(function() {
		if(isNaN($('#solicitudCreditoID').val()) ){
			$('#solicitudCreditoID').val("");
			$('#solicitudCreditoID').focus();
			//InicializarSolicitud();
		 }else{
			 validaSolicitudCredito(this.id);
		}
	});

/* *****************************************************************************************
   	Fecha : 23-marzo-2013, Bloque de funcionalidad extra para esta pantalla
 	Solicitado por FCHIA para pantalla pivote (solicitud credito grupal)
 	Valida en la pantalla de solicitud grupal el numero de solicitud (perteneciente al grupo)seleccionado
	no eliminar, no afecta el comportamiento de la pantalla de manera individual */

	if( $('#numSolicitud').val() != "" ){
		var numSolicitud=  $('#numSolicitud').val();
		$('#solicitudCreditoID').val(numSolicitud);
		//$('#solicitudCreditoID').focus();
		validaSolicitudCredito('solicitudCreditoID');

	}
	// fin  Bloque de funcionalidad extra
 /* *********************************************************************************************/

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			solicitudCreditoID: 'required',
		},
		messages: {
			solicitudCreditoID: 'Especifique el Número de Solicitud',
		}
	});



	//------------ Validaciones de Controles -------------------------------------
		function validaSolicitudCredito(idControl) {

			var jqSolicitud  = eval("'#" + idControl + "'");
			var solCred = $(jqSolicitud).val();

				var SolCredBeanCon = {
					'solicitudCreditoID':solCred
				};
			setTimeout("$('#cajaLista').hide();", 200);
			if(solCred == 0 && esTab){
				inicializaForma('formaGenerica','solicitudCreditoID');
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('expediente', 'submit');
				$('#gridSolicitudCheckList').html("");
				$('#gridSolicitudCheckList').hide();
				$('#solicitudCreditoID').focus();
				$('#solicitudCreditoID').val("");
			}
			if(solCred != 0 && !isNaN(solCred) && esTab){

				inicializaForma('formaGenerica','solicitudCreditoID');
			solicitudCredServicio.consulta(catTipoConsultaSolicitud.principal, SolCredBeanCon,function(solicitud) {
				if(solicitud!=null && solicitud.solicitudCreditoID !=0){
					dwr.util.setValues(solicitud);
					agregaFormatoControles('formaGenerica');
						if(solicitud.estatus=='I'){
							$('#estatus').val('INACTIVA');
							habilitaBoton('grabar', 'submit');
						}else{
							deshabilitaBoton('grabar', 'submit');
						}
						habilitaBoton('expediente');
						if(solicitud.estatus=='A'){
							$('#estatus').val('AUTORIZADA');
						}

						if(solicitud.estatus=='C'){
							$('#estatus').val('CANCELADA');
						}
						if(solicitud.estatus=='R'){
							$('#estatus').val('RECHAZADA');
						}
						if(solicitud.estatus=='D'){
							$('#estatus').val('DESEMBOLSADA');
						}
						if(solicitud.estatus=='L'){
							$('#estatus').val('LIBERADA');
						}

						var fechaSinHora=(solicitud.fechaRegistroGr).substr(0,10);
						$('#fechaRegistroGr').val(fechaSinHora);

						consultaProducCredito('productoCreditoID');
						consultaPromotor('promotorID');

						consultaSucursal('sucursalID');
						consultaDestinoCredito('destinoCreID');

						if (solicitud.grupoID != null){
							$('#solGrupo').show();
						}else{
							$('#solGrupo').hide();
							$('#grupoID').val('');
							$('#nombreGrupo').val('');
							$('#fechaRegistroGr').val('');
							$('#cicloActual').val('');
						}
						consultaGridCheckList();
				}else{
					inicializaForma('formaGenerica','solicitudCreditoID');
					mensajeSis("La Solicitud de Credito No Existe.");
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('expediente', 'submit');
					$('#gridSolicitudCheckList').html("");
					$('#gridSolicitudCheckList').hide();
					$('#solicitudCreditoID').focus();
					$('#solicitudCreditoID').val("");
				}

			});
		 }
	}

		//Funcion para consultar el numero de documentos por cliente. y generar reporte
		function consultaNumeroDocumentosPorCliente() {
			var  clienteArchivosBean={
				'prospectoID' :$('#prospectoID').val(),
				'clienteID' : $('#clienteID').val()
			};
			setTimeout("$('#cajaLista').hide();", 200);

			if( $('#clienteID').val() != '' || !isNaN( $('#clienteID').val())){
				clienteArchivosServicio.consulta(3,clienteArchivosBean,function(clienteArchivos) {
					if(clienteArchivos!=null){
						numeroDocumentos = 	clienteArchivos.numeroDocumentos;
						if(numeroDocumentos > 0 ){
							var parametrosBean = consultaParametrosSession();
							var fechaEmision = parametrosBean.fechaSucursal;
							var nombreUsuario = parametrosBean.nombreUsuario;
							var nombreInstitucion = parametrosBean.nombreInstitucion;
							var clienteID = $('#clienteID').val();
							clienteID=completaCerosIzquierda(clienteID,10);

							var nombre=$('#nombreCompletoCliente').val();
							var prospectoID = $('#prospectoID').val();
							var nombreProspecto=$('#nombreCompletoProspecto').val();
							var pagina='clientesFilePDF.htm?clienteID='+clienteID+'&nombreCliente='+nombre+
								'&prospectoID='+prospectoID+'&nombreProspecto='+nombreProspecto+
								'&nombreUsuario='+nombreUsuario+'&fechaEmision='+fechaEmision+'&nombreInstitucion='	+nombreInstitucion;
							window.open(pagina,'_blank');
						} else{
							mensajeSis("El cliente no tiene documentos digitalizados.");
						}
					}else{
						mensajeSis("El cliente no tiene documentos digitalizados.");
					}
				});
			}
		}

		/*Metodo nuevo */
		function completaCerosIzquierda(cadena, longitud) {
			var strPivote = '';
			var i=0;
			var longitudCadena=cadena.toString().length;
			var cadenaString=cadena.toString();

			for ( i = longitudCadena; i < longitud; i++) {
			strPivote = strPivote + '0';
			}
			return strPivote +cadenaString;
			}
		/*fin metodo nuevo */

	function consultaProducCredito(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);

			if(ProdCred != '' && !isNaN(ProdCred)){
				productosCreditoServicio.consulta(catTipoConsultaSolicitud.principal,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){
						$('#nombreProducto').val(prodCred.descripcion);
					}else{
						$('#nombreProducto').val('');
					}
				});
			}
	}  //consultaProducCreditoForanea

	function consultaPromotor(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor) ) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
					$('#nombrePromotor').val(promotor.nombrePromotor);
				}
				else{
					$('#nombrePromotor').val('');
				}
			});
		}
	}

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal)) {
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#nombreSucursal').val(sucursal.nombreSucurs);
				}
				else{
					$('#nombreSucursal').val('');
				}
			});
		}
	 }

	function consultaDestinoCredito(idControl) {
		var jqDestino  = eval("'#" + idControl + "'");
		var DestCred = $(jqDestino).val();
		var DestCredBeanCon = {
  			'destinoCreID':DestCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(DestCred != '' && !isNaN(DestCred)){
				destinosCredServicio.consulta(catTipoConsultaSolicitud.principal,DestCredBeanCon,function(destinos) {
					if(destinos!=null){
						$('#nombreDestinoCre').val(destinos.descripcion);
					}
					else {
						$('#nombreDestinoCre').val('');
					}
			});
		}
	}



	function consultaGridCheckList(){
		var params = {};
		params['tipoLista'] = 1;
		params['solicitudCreditoID'] = $('#solicitudCreditoID').val();

		$.post("solicitudCheckListGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#gridSolicitudCheckList').html(data);
				$('#gridSolicitudCheckList').show();

				if($('#numeroDocumento').val() == 0){
					$('#gridSolicitudCheckList').html("");
					$('#gridSolicitudCheckList').hide();
					deshabilitaBoton('grabar', 'submit');
				}
			}else{
				$('#gridSolicitudCheckList').html("");
				$('#gridSolicitudCheckList').hide();
			}
		});


	}


	function guardarCodigos(){
 		var mandar = verificarvacios();

 		if(mandar!=1){
			var numCodigo = $('input[name=consecutivoID]').length;

			$('#datosGrid').val("");
			for(var i = 1; i <= numCodigo; i++){
				if(i == 1){
					$('#datosGrid').val($('#datosGrid').val() +
					document.getElementById("solicitudCreditoID"+i+"").value + ']' +
					document.getElementById("clasificaTipDocID"+i+"").value + ']' +
					document.getElementById("docRecibido"+i+"").value + ']' +
					document.getElementById("tipoDocumentoID"+i+"").value + ']' +
					document.getElementById("comentarios"+i+"").value);
				}else{
					$('#datosGrid').val($('#datosGrid').val() + '[' +
					document.getElementById("solicitudCreditoID"+i+"").value + ']' +
					document.getElementById("clasificaTipDocID"+i+"").value + ']' +
					document.getElementById("docRecibido"+i+"").value + ']' +
					document.getElementById("tipoDocumentoID"+i+"").value + ']' +
					document.getElementById("comentarios"+i+"").value);
				}
			}


		}
		else{
			mensajeSis("Faltan Datos");
			//event.preinicializaFormaventDefault();
			event.preventDefault();
		}
	}


	function verificarvacios(){
		quitaFormatoControles('gridSolicitudCheckList');
		var numCodig = $('input[name=consecutivoID]').length;

		$('#datosGrid').val("");
		for(var i = 1; i <= numCodig; i++){

			var idsc = document.getElementById("solicitudCreditoID"+i+"").value;
 			if (idsc ==""){
 				document.getElementById("solicitudCreditoID"+i+"").focus();
				$(idsc).addClass("error");
 				return 1;
 			}
 			var idctd = document.getElementById("clasificaTipDocID"+i+"").value;
 			if (idctd ==""){
 				document.getElementById("clasificaTipDocID"+i+"").focus();
				$(idctd).addClass("error");
 				return 1;
 			}
 			var idDocRe = document.getElementById("docRecibido"+i+"").value;
 			if (idDocRe ==""){
 				//idDocRe=="N";
 				document.getElementById("docRecibido"+i+"").focus();
				$(idDocRe).addClass("error");
 				return 1;
 			}
			var idcr = document.getElementById("tipoDocumentoID"+i+"").value;
 			if (idcr ==""){
 				document.getElementById("tipoDocumentoID"+i+"").focus();
				$(idcr).addClass("error");
 				return 1;
 			}
			var idcde = document.getElementById("comentarios"+i+"").value;
 			if (idcde ==""){
 				if(idDocRe =="" || idDocRe =="S"){
 					document.getElementById("comentarios"+i+"").focus();
 	 				$(idcde).addClass("error");
 	 					return 1;
 				}

 				if(idDocRe =="N"){
 					document.getElementById("comentarios"+i+"").value = "X";
 				}



 			}

		}
	}

});

// -- FUNCIONES ----------------------

	// Funcion que se ejecuta cuando el resultado del submit es exitoso
	function exitoCheckLisCredito() {
	  	 deshabilitaBoton('grabar', 'submit');
	     deshabilitaBoton('expediente', 'submit');
	     $('#gridSolicitudCheckList').html("");
		$('#gridSolicitudCheckList').hide();
	     limpiaForm('formaGenerica');
	     inicializaForma('formaGenerica', 'solicitudCreditoID');
	}

	// funcion que se ejecuta cuando el resultado del submit falla
	function falloCheckLisCredito() {
		//mensajeSis("CheckList Con Errores");
	}
