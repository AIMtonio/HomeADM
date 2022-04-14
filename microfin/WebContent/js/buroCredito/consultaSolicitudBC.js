var contador=0;
var parametroBean = consultaParametrosSession();
var usuarioValidoCirculo = 'N';
var usuarioValidoBuro = 'N';
var contratoBuro = "";
var contratoCirculo = "";
$(document).ready(function() {
	$('#gridConsultas').html("");
	$('#gridConsultas').hide();
	esTab = true;
	consultaParametrosSistema();
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('generar', 'submit');
 	$('#solicitudCreditoID').focus();	// al cargar la pantalla el foco debe de estar en la primer cajita
 	consultaUsuarioCirculo(parametroBean.numeroUsuario); // consulta al usuario de círculo de credito
 	consultaUsuarioBuro(parametroBean.numeroUsuario);	 // Consulta al usuario de Buro de Credito
	$('#origenDatos').val(parametroBean.origenDatos);	 // Consulta los origenes de datos del usuario

	var cont=0;
	//Definicion de Constantes y Enums
	var catTipoTranBuro = {
		'tipoTransaccionCCyBC' : 5,
		'tipoTransaccionBC'	   : 6,
		'tipoTransaccionCC'	   : 7
	};

	var catTipoConsultaBuro = {
  		'principal':1,
  		'foranea':2,
  		'BC'	:6
	};

// Fecha : 23-marzo-2013, Bloque de funcionalidad extra para esta pantalla
// Solicitado por FCHIA para pantalla pivote (solicitud credito grupal)
// Valida en la pantalla de solicitud grupal el numero de solicitud (perteneciente al grupo)seleccionado
//no eliminar, no afecta el comportamiento de la pantalla de manera individual
	if( $('#numSolicitud').val() != "" ){
		var numSolicitud=  $('#numSolicitud').val();
		$('#solicitudCreditoID').val(numSolicitud);
		$('#solicitudCreditoID').focus();
		esTab = true;
		validaSolicitudCredito('solicitudCreditoID');
	}
// fin  Bloque de funcionalidad extra


		//------------ Metodos y Manejo de Eventos -----------------------------------------
	$.validator.setDefaults({
      submitHandler: function(event) {
    	  consultaParametrosSistema();
    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','sol','consultaGridBuroCredito','consultaGridBuroCredito');
      }
	});

	$(':text').focus(function() {
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#solicitudCreditoID').blur(function(){

		validaSolicitudCredito(this.id);
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


	$('#generar').click(function(event){
		cont=0;
		var str = "";
		var renglon 	= document.getElementsByName("renglon");
		var relacion 	= document.getElementsByName("relacion");
		var checks 		= document.getElementsByName("checkBC");
		var checksC 	= document.getElementsByName("checkCC");
		var cliente	 	= document.getElementsByName("registroID");
		var prospecto 	= document.getElementsByName("prospectoID");
		var avales		= document.getElementsByName("avalID");

		var circulo = validaParametrosCC();
		var buroCredito = validaParametrosBC();
		if(circulo > 0 || buroCredito > 0 ){
			if(circulo > 0 && contratoCirculo == ''){
				mensajeSis('No se tiene parametrizado un tipo de Contrato de Circulo de Crédito para el Producto de Crédito')
				return false;
			}
			if(buroCredito > 0 && contratoBuro == ''){
				mensajeSis('No se tiene parametrizado un tipo de Contrato de Buró de Crédito para el Producto de Crédito')
				return false;
			}
		}
		if(validaDireccion() == true){
			if(validaVigencia() == true){
				for(var i=0; i < checks.length; i++) {

					if (!(checks[i].checked == false && checksC[i].checked == false )){
						cont++;
						str += relacion[i].value + ',' +cliente[i].value + ','+prospecto[i].value+','+avales[i].value+'%%';
						if(checks[i].checked == true && checksC[i].checked == true){
							$('#tipoTransaccion').val(catTipoTranBuro.tipoTransaccionCCyBC);
						}else if(checks[i].checked == true && checksC[i].checked == false){
							$('#tipoTransaccion').val(catTipoTranBuro.tipoTransaccionBC);
						}else {
							$('#tipoTransaccion').val(catTipoTranBuro.tipoTransaccionCC);
						}
					}
				}
			}else{
				event.preventDefault();
			}
		}else{
			event.preventDefault();
		}
		$('#listaRegistros').val(str);
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			solicitudCreditoID: {
				required: true
			}
		},
		messages: {
			solicitudCreditoID: {
				required: 'Especificar Número de Solicitud de Credito'
			}
		}
	});

	//------------ Validaciones de Controles -------------------------------------
	function validaSolicitudCredito(idControl) {
		esTab=true;
		var jqSolicitud  = eval("'#" + idControl + "'");
		var solCred = $(jqSolicitud).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if( solCred != '' && !isNaN(solCred) && esTab){
			var SolCredBeanCon = {
					'solicitudCreditoID':solCred
			};
			solicitudCredServicio.consulta(10, SolCredBeanCon,function(solicitud) {
				if(solicitud!=null){
					$('#productoCreditoID').val(solicitud.productoCreditoID);
					$('#montoSolici').val(solicitud.montoSolici);
					$('#fechaRegistro').val(solicitud.fechaRegistro);
					$('#estatus').val(solicitud.estatus);
					$('#montoAutorizado').val(solicitud.montoAutorizado);
					esTab=true;
 					consultaProducCredito('productoCreditoID');
					$('#montoAutorizado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					if(usuarioValidoCirculo == 'N' && usuarioValidoBuro == 'N'){
						mensajeSis("El Usuario No Puede Realizar Consultas a Círculo de Crédito  y Buró de Crédito");
					} else {
						consultaGridBuroCredito();
					}
				}else{
					mensajeSis("No Existe la Solicitud de Crédito");
					inicializaForma('formaGenerica', 'solicitudCreditoID');
					$('#solicitudCreditoID').focus();
					$('#solicitudCreditoID').val('');
					$('#gridConsultas').html("");
					$('#gridConsultas').hide();
				}
			});
		}
	}

    function validaVigencia(){
    	var renglon 	= document.getElementsByName("renglon");
    	var diasVB	= document.getElementsByName("diasRestantesVig");
    	var diasVC	= document.getElementsByName("diasVigenciaC");
    	var checksD 	= document.getElementsByName("checkBC");
    	var checksC 	= document.getElementsByName("checkCC");
    	var rfc		= document.getElementsByName("RFC");
		var generareg	= 0;
		var stringB	="";
		var stringC	="";
		var salida	=true;

		for(var i=0; i < diasVC.length; i++) {
			if((diasVB[i].value != '0' || diasVB[i].value != '')  && checksD[i].checked == true){
				generareg++;
				stringB += rfc[i].value +",";
			}
			if((diasVC[i].value != '0' || diasVC[i].value != '') && checksC[i].checked == true){
				generareg++;
				stringC += rfc[i].value +",";;
			}
		}
		if(stringB != '' && stringC != ''){
			stringB = "de las siguientes personas a Buró de crédito "+stringB+" y a los siguientes sujetos a Circulo de Crédito "+stringC+"?.";
		}else if(stringB != '' && stringC == ''){
			stringB = "de las siguientes personas a Buró de Crédito "+stringB+".";
		}else if(stringB == '' && stringC != ''){
			stringB = "de las siguientes personas a Circulo de Crédito "+stringC+".";
		}
		if(generareg > 0){
			if(confirm("Consulta Vigente,¿Está seguro que desea realizar nuevamente la Consulta "+stringB)){
				salida = true;
			}else{
				salida = false;
			}
		}else{
			salida = true;
		}
		return salida;
	}

    // funcion para consultar el producto de crédito
	function consultaProducCredito(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();
		var ProdCredBeanCon = {
			'producCreditoID': ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred) && esTab){
			productosCreditoServicio.consulta(catTipoConsultaBuro.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred != null){
					esTab=true;

					contratoBuro = prodCred.tipoContratoBCID;
					contratoCirculo = prodCred.tipoContratoCCID;
					$('#descripProducto').val(prodCred.descripcion);
				}else{
					mensajeSis("No Existe el Producto de Credito");
					$('#producCreditoID').focus();
					$('#producCreditoID').select();
					deshabilitaBoton('generar', 'submit');
				}
			});
		}
	}

	// funcion para validar si el usuario puede realizar consultas a circulo de credito.
	function consultaUsuarioCirculo(numUsuario) {
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			var usuarioBeanCon = {
					'usuarioID':numUsuario
			};
			usuarioServicio.consulta(1,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					if(usuario.realizaConsultasCC == 'S'){
						$('#usuarioCirculo').val(usuario.usuarioCirculo);
						$('#contrasenaCirculo').val(usuario.contrasenaCirculo);
						$('#realizaConsultasCC').val('S');
						habilitaBoton('consulta');
						usuarioValidoCirculo = 'S';
					}else if(usuario.realizaConsultasCC == 'N'){
						$('#usuarioCirculo').val('');
						$('#contrasenaCirculo').val('');
						$('#realizaConsultasCC').val('N');
						usuarioValidoCirculo = 'N';
						mensajeSis("El Usuario No Puede Realizar Consultas a Círculo de Crédito ");
						deshabilitaBoton('consulta');
						usuarioValidoCirculo = 'N';
					}
				}else{
					$('#usuarioCirculo').val('');
					$('#contrasenaCirculo').val('');
					$('#realizaConsultasCC').val('N');
				}
			});

		}
	}

	// funcion para validar si el usuario puede realizar consultas a circulo de credito.
	function consultaUsuarioBuro(numUsuario) {
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			var usuarioBeanCon = {
					'usuarioID':numUsuario
			};
			usuarioServicio.consulta(1,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					if(usuario.realizaConsultasBC == 'S'){
						$('#usuarioBuroCredito').val(usuario.usuarioBuroCredito);
						$('#contraseniaBuroCredito').val(usuario.contrasenaBuroCredito);
						$('#realizaConsultasBC').val('S');
						$('#usuario').val(usuario.usuarioID);
						habilitaBoton('consulta');
						usuarioValidoBuro = 'S';
					}else if(usuario.realizaConsultasBC == 'N'){
						$('#usuarioBuroCredito').val('');
						$('#contraseniaBuroCredito').val('');
						$('#realizaConsultasBC').val('N');
						$('#usuario').val('');
						mensajeSis("El Usuario No Puede Realizar Consultas a Buró de Crédito ");
						deshabilitaBoton('consulta');
						usuarioValidoBuro = 'N';
					}

				}else{
					$('#usuarioBuroCredito').val('');
					$('#contraseniaBuroCredito').val('');
					$('#realizaConsultasBC').val('N');
					$('#usuario').val('');
				}
			});

		}
	}

	// Consulta de Parametro de sistema para obtener valor a seleccionar por default
	function consultaParametrosSistema() {
		setTimeout("$('#cajaLista').hide();", 200);
		var parametrosSisCon ={
	 		 	'empresaID' : 1
		};
		parametrosSisServicio.consulta(1,parametrosSisCon, function(varParamSistema) {
			if (varParamSistema != null) {
				if (varParamSistema.conBuroCreDefaut == 'B') {	// si tiene por default Buro

				}else{	// si tiene por default Circulo
					esTab = true;

					$('#abreviaturaCirculo').val(varParamSistema.abreviaturaCirculo);
				}
			} else {
				deshabilitaBotones();
			}
		});
	}

	function validaParametrosBC(){
		var contador = 0;
		$('input[name=checkBC]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqIdCredChe = eval("'#checkBC" + numero+ "'");
			if($(jqIdCredChe).is(':checked')){
				contador = contador +1;
			}
		});
		return contador;
	}

	function validaParametrosCC(){
		var contador = 0;

		$('input[name=checkCC]').each(function() {
			var numeroC= this.id.substr(7,this.id.length);
			var jqIdCredCheC = eval("'#checkCC" + numeroC+ "'");
			if($(jqIdCredCheC).is(':checked')){
				contador = contador +1;
			}
		});

		return contador;

	}

});// ready


function consultaGridBuroCredito(){
	contador=0;
	$('#gridConsultas').html("");
	var varSolCredito = $('#solicitudCreditoID').val();
	var listaBC= 2;
	var params = {
		'solicitudCreditoID' 	: varSolCredito,
		'usuarioID'				: parametroBean.numeroUsuario,
		'tipoLista'				: listaBC
	};
	$.post("consultaSolicitudGridVista.htm", params,  function(data){
		if(data.length >0) {
			$('#gridConsultas').html(data);
			$('#gridConsultas').show();
			habilitaBoton('generar', 'submit');
			validaFolioBotonVer();
			validaBotonConsultar();
			validaPermisoUsuario();
		}else{
			$('#gridConsultas').html("");
			$('#gridConsultas').show();
			deshabilitaBoton('generar', 'submit');
		}
		if(estaProcesandoRespuesta()){
			('consultaGridBuroCredito();', 10000);
		}else{
		}
	});
}

function estaProcesandoRespuesta(){
	//en este caso es para hacer el loop va estar consultando cada 15 segundos por la respuesta que esta pendiente
	var retorno = false;
	var checks = document.getElementsByName("folioConsulta");
	var checksC = document.getElementsByName("folioConsultaC");
	for(var i=0; i < checks.length; i++) {
		if(checks[i].value == "Procesando Respuesta" || checksC[i].value == "Procesando Respuesta"){
			retorno= true;
			return retorno;
		}
	}
	return retorno;
}


//valida que el folio sea diferente de cero para prender el boton  de ver reporte
function validaFolioBotonVer(){
	var numero = $('input[name=folioConsulta]').length;
	for(var i = 1; i <= numero; i++){
		var jqFolio  = eval("'#folioConsulta" +i+ "'");
		var jqFolioC  = eval("'#folioConsultaC" +i+ "'");
		var folio = $(jqFolio).asNumber();
		var folioC=$(jqFolioC).asNumber();
		if(folio == '0' ){
			var botonVer='ver'+i;
			deshabilitaBoton(botonVer, 'submit');
		}
		if(folioC == '0'){
			var botonVerC='verC'+i;
			deshabilitaBoton(botonVerC, 'submit');
		}
	}
}

function validaBotonConsultar(){
	contador=0;
	var checks = document.getElementsByName("checkBC");
	var checksC = document.getElementsByName("checkCC");
    for(var i=0; i < checks.length; i++) {
    	if (checks[i].checked == true ){
    		contador++;
    	}
    }
    for(var i=0; i < checksC.length;  i++) {
    	if (checksC[i].checked == true ){
    		contador++;
    	}
    }
    if(contador<1){
    	deshabilitaBoton('generar', 'submit');
    }
}

function validaCheck(idControl){
	$('input[name=checkBC]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdCredChe = eval("'checkBC" + numero+ "'");
		if ($('#'+idControl).attr("checked")== true){
			habilitaBoton('generar', 'submit');
			contador++;
		}
	});
	validaBotonConsultar();
}

function validaPermisoUsuario(){

	$('input[name=checkBC]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdCredChe = eval("'checkBC" + numero+ "'");
		if(usuarioValidoBuro == 'S'){
			habilitaControl(jqIdCredChe);
		} else {
			deshabilitaControl(jqIdCredChe);

		}
	});

	$('input[name=checkCC]').each(function() {
		var numeroC= this.id.substr(7,this.id.length);
		var jqIdCredCheC = eval("'checkCC" + numeroC+ "'");
		if(usuarioValidoCirculo == 'S'){
			habilitaControl(jqIdCredCheC);
		} else {
			deshabilitaControl(jqIdCredCheC);

		}
	});

}
function validaCheckC(idControl){
	$('input[name=checkCC]').each(function() {
		var numeroC= this.id.substr(7,this.id.length);
		var jqIdCredCheC = eval("'checkCC" + numeroC+ "'");
		if ($('#'+idControl).attr("checked")== true){
			habilitaBoton('generar', 'submit');
			contador++;
		}
	});
	validaBotonConsultar();
}

function generaPDF(fechaConsulta, horaConsulta, folioConsulta, idControl){
	var jqligaPDF	= 	eval("'#" + idControl + "'");
	var tipoReporte	= 	2;
	var nombreInst 	= 	parametroBean.nombreInstitucion;
	var fechaCon 	= 	fechaConsulta.substring(0,10);
	var hrCon	 	=   fechaConsulta.substring(11,16);;
	var folio		=	folioConsulta;
	var usuario		= 	parametroBean.claveUsuario;
	$(jqligaPDF).attr('href','ReporteBC.htm?programaID='+nombreInst+'&fechaConsulta='+fechaCon+'&fechaActual='+hrCon+'&folioConsulta='+folio+
			'&usuario='+usuario+"&tipoReporte="+tipoReporte);
}
function generaPDFC(fechaConsulta, horaConsulta, folioConsulta, idControl){
	var jqligaPDFC	= 	eval("'#" + idControl + "'");
	var tipoReporte	= 	1;
	var nombreInst 	= 	parametroBean.nombreInstitucion;
	var fechaCon 	= 	fechaConsulta.substring(0,10);
	var hrCon	 	=   fechaConsulta.substring(11,16);;
	var folio		=	folioConsulta;
	var usuario		= 	parametroBean.claveUsuario;
	/*
	if($('#consultaCC').is(':checked')){
		$('#ligaPDF').attr('href','ReporteCC.htm?programaID='+nombreInst+'&fechaConsulta='+fechaCon+'&fechaActual='+hrCon+'&folioConsulta='+folio+
				'&usuario='+usuario+"&tipoReporte="+tipoReporteCirculo
		+"&nombreConsultado="+$('apellidoPaterno').val()+" "+$('apellidoMaterno').val()+" "+$('primerNombre').val()+" "+$('segundoNombre').val()+" "+" "+$('tercerNombre').val()+" "
		+"&direccion="+"CALLE "+$('calle').val()+" NÚMERO INTERIOR "+", NÚMERO EXTERIOR "+", PISO "+", COLONIA"
		+"&municipio="+$('#nombreMuni').val()
		+"&edocp="+tipoReporteCirculo);
	}

	*/
	$(jqligaPDFC).attr('href','ReporteCC.htm?programaID='+nombreInst+'&fechaConsulta='+fechaCon+'&fechaActual='+hrCon+'&folioConsulta='+folio
			+'&usuario='+usuario+"&tipoReporte="+tipoReporte+"&usuarioCirculo="+$('#usuarioCirculo').val()
			);
}

function validaDireccion(){
	validaDir=true;
	var renglon 	= document.getElementsByName("renglon");
	var calle  	= document.getElementsByName("calle");
	var estados 	= document.getElementsByName("estadoID");
	var municipios 	= document.getElementsByName("municipioID");
	var cps		= document.getElementsByName("CP");
	var checksD 	= document.getElementsByName("checkBC");
	var cliente	= document.getElementsByName("registroID");
	var checksC 	= document.getElementsByName("checkCC");
	var oficiales 	= document.getElementsByName("oficial");
	var rfc 	= document.getElementsByName("RFC");
	var cadena	="";

	for(var i=0; i < checksD.length; i++) {

		if (checksD[i].checked == true || checksC[i].checked == true ){
			if((calle[i].value=='')||( estados[i].value=='0' || estados[i].value=='' ) ||( municipios[i].value =='0' || municipios[i].value =='') || (cps[i].value == '0' || cps[i].value =='')){
				validaDir =false;
				cadena+=rfc[i].value+ '\n';
			}
			if(cliente[i].value != '0' && oficiales[i].value!='S'){
				validaDir=false;
				cadena+=rfc[i].value+ '\n';
			}
		}
	}// fin for

	if(validaDir== false){
		mensajeSis('Verifique la dirección de las personas con RFC :'+ cadena);
	}else{
		validaDir=true;
	}
	return validaDir;
}


