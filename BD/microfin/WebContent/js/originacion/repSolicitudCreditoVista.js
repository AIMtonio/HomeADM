
var catNumClienteEsp = {
	'asefimex':43
};

$(document).ready(function() {

	$("#solicitudCreditoID").focus();

	parametros = consultaParametrosSession();

	// Declaración de constantes
	var catTipoConsultaSolicitud = {
	  		'principal'		: 1,
	  		'foranea'		: 2,
	  		'solCheckList'	: 6
		};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('generar', 'submit');
	agregaFormatoControles('formaGenerica');

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
//		   	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','solicitudCreditoID',
//		    			  				'exito', 'fallo');
		}
	});


	$('#solicitudCreditoID').bind('keyup',function(e){
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
		 	parametrosLista[0] = $('#solicitudCreditoID').val();

			lista('solicitudCreditoID', '1', '1', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}
	});


	$('#solicitudCreditoID').blur(function() {
		if(isNaN($('#solicitudCreditoID').val()) ){
			$('#solicitudCreditoID').val("");
			$('#solicitudCreditoID').focus();
		 }else{
			 var longitudSolicitud=$('#solicitudCreditoID').val().length;
			 var credito=$('#solicitudCreditoID').val();
			 if(longitudSolicitud>11){
				 credito=credito.substring(0,11);
				 $('#solicitudCreditoID').val(credito);
			 }
			 validaSolicitudCredito('solicitudCreditoID');
		}
	});

	$('#generar').click(function(){
		enviaDatosRepPDF();
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			solicitudCreditoID: 'required',
		},
		messages: {
			solicitudCreditoID: 'Especifique el Número de Solicitud.',
		}
	});



	//------------ Validaciones de Controles -------------------------------------
	function validaSolicitudCredito(idControl) {
		var jqSolicitud  = eval("'#" + idControl + "'");
		var solCred = $(jqSolicitud).val();
			var SolCredBeanCon = {
				'solicitudCreditoID':solCred,
			};
			if(solCred != '' && !isNaN(solCred) &&solCred!='0'){
			setTimeout("$('#cajaLista').hide();", 200);
			solicitudCredServicio.consulta(catTipoConsultaSolicitud.principal, SolCredBeanCon,function(solicitud) {
				if(solicitud!=null){
					if(solicitud.solicitudCreditoID !=0){
					habilitaBoton('generar', 'submit');
					dwr.util.setValues(solicitud);
					agregaFormatoControles('formaGenerica');
					$('#tipoPersona').val(solicitud.tipoPersona);
					if(solicitud.estatus=='I'){
						$('#estatus').val('INACTIVA');
					}
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
					}else{
						inicializaForma('formaGenerica','solicitudCreditoID');
						alert("La Solicitud de Crédito No Existe.");
						deshabilitaBoton('generar', 'submit');
						$('#solicitudCreditoID').focus();
						$('#solicitudCreditoID').val("");
					}
				}else{
					inicializaForma('formaGenerica','solicitudCreditoID');
					alert("La Solicitud de Crédito No Existe.");
					deshabilitaBoton('generar', 'submit');
					$('#solicitudCreditoID').focus();
					$('#solicitudCreditoID').val("");
				}
			});
		}
	}


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
			});
		}
	}
	consultaParametro();
	//Funcion para consultar parametro tabla PARAMGENERALES
	function consultaParametro(){
		var tipoConsulta = 13;
		paramGeneralesServicio.consulta(tipoConsulta, function(valor){
			if(valor!=null){
				$('#numClienteEspec').val(valor.valorParametro);
			}
		});
	}

	function enviaDatosRepPDF(){
		if($('#numClienteEspec').val() == catNumClienteEsp.asefimex){
			if($('#tipoPersona').val() == 'M'){
				var tipoReporte			= 3;
				var nombreInstitucion=parametroBean.nombreInstitucion;
				var sucursal=parametroBean.sucursal;
				var fechaEmision = parametroBean.fechaSucursal;
				var pagina ='repPDFSolicitudCredito.htm?tipoReporte='+tipoReporte+
						'&solicitudCreditoID='+$('#solicitudCreditoID').val()+
						'&nombreInstitucion='+nombreInstitucion+
						'&sucursal='+sucursal+
						'&fechaActual='+fechaEmision+
						'&grupoID='+$('#grupoID').val();
					window.open(pagina,'_blank');
			}else{
				var tipoReporte			= 4;
				var nombreInstitucion=parametroBean.nombreInstitucion;
				var sucursal=parametroBean.sucursal;
				var fechaEmision = parametroBean.fechaSucursal;
				var pagina ='repPDFSolicitudCredito.htm?tipoReporte='+tipoReporte+
						'&solicitudCreditoID='+$('#solicitudCreditoID').val()+
						'&nombreInstitucion='+nombreInstitucion+
						'&sucursal='+sucursal+
						'&fechaActual='+fechaEmision+
						'&grupoID='+$('#grupoID').val();
					window.open(pagina,'_blank');

				var tipoReporte			= 2;
				var pagina ='repPDFSolicitudCredito.htm?tipoReporte='+tipoReporte;
					window.open(pagina,'_blank');
			}
		}else{
			var tipoReporte			= 1;
			var nombreInstitucion=parametroBean.nombreInstitucion;
			var sucursal=parametroBean.sucursal;
			var fechaEmision = parametroBean.fechaSucursal;
			var pagina ='repPDFSolicitudCredito.htm?tipoReporte='+tipoReporte+
					'&solicitudCreditoID='+$('#solicitudCreditoID').val()+
					'&nombreInstitucion='+nombreInstitucion+
					'&sucursal='+sucursal+
					'&fechaActual='+fechaEmision+
					'&grupoID='+$('#grupoID').val();
				window.open(pagina,'_blank');


		}
	}


});