 /*----------  Variable de codigos de teclado  ----------*/
var keysSAFI = {
            UP: 38,
            DOWN: 40,
            ENTER: 13,
            TAB: 9,
            BACKSPACE: 8,
	    LEFT: 37,
	    RIGHT: 39
        };


/*============================================
=            Mensajes del Sistema            =
============================================*/

/*inputSelectSAFI - determina el ultimo input que tenia el foco  */
var inputSelectSAFI = '';


/**
 * Contiene el código del div, donde se muestra el mensaje del sistema
 */
var mensajeAlertSAFI = '<div class="alertInfo" id="alertInfo"><div class="cabecera">Mensaje:'
					+ '<span id="btnAlertCerrar">X</span><div class="clearfix"></div></div>'
					+ '  <div class="contenido" id="mensajeContenido"></div>'
					+ '  <div class="footer"><small>Pulse la tecla [Enter] para cerrar este Mensaje </small></div>'
					+ '</div> ';

var mensajeAlertSAFIRetro = '<div class="alertInfoRetro" id="alertInfoRetro"><div class="cabecera" ><span id="safiTxtCabecera">Mensaje:</span>'
					+ '<span id="btnAlertCerrar">X</span><div class="clearfix"></div></div>'
					+ '  <div class="contenido" id="mensajeContenido"></div>'
					+ '  <div class="footer"><button id="safiBtnCancel" class="submit btnOKLogin"><span id="safiTxtCancel">Cancelar</span></button><button id="safiBtnOk" class="btnOKLogin submit "><span id="safiTxtOk">Aceptar</span></button></div>'
					+ '</div> ';

/**
 *
 * Verifica que el DIV de mensajes este visible y que se pulse la tecla ENTER
 * Activa la función del boton para cerrar el mensaje y devolver el foco al formulario.
 *
 */
$(document).keydown(function(e){

	if(e.keyCode == keysSAFI.ENTER && $('#alertInfo').is(":visible")){


		if($('.blockUI').find('#contenedorMsg').length == 0){

				$('#contenedorForma').unblock();
				if(inputSelectSAFI != ''){
					setTimeout(function(){
						inputSelectSAFI.focus();
						inputSelectSAFI = '';

						$(window).scrollTop(inputSelectSAFI);
					},100);

				}else{
					setTimeout(function(){
						$(window).scrollTop(document.activeElement);
					},100);
				}

		}

	}
});


/**
 *
 * Muestra el mensaje con el texto de validación
 * agrega los metodos de cerrar y de capturar el campo
 * que tiene el foco.
 *
 */
function mensajeSis(texto){

	if($('#alertInfo').is(":visible")){
		return false;
	}

	var posTop = $(window).scrollTop() + 100;

	$('#contenedorForma').block({
		message: mensajeAlertSAFI,
		css: {border:		'none',
			background:	'none'}
	});

	$('#mensajeContenido').html(texto);

	$(".blockMsg").css("cursor", "wait");


	var ubicaPantalla = $(".blockMsg").position();
	var sizePantalla  = $(window).height();
	setTimeout(function(){
		if(ubicaPantalla.top > sizePantalla){
			$(window).scrollTop(ubicaPantalla.top);
		}
	},100);



	$("#alertInfo").mouseover(function(){
		if(inputSelectSAFI == ''){
			inputSelectSAFI = document.activeElement;
		}

	});


	$("#btnAlertCerrar").click(function(){

		inputSelectSAFI.focus();
		$('#contenedorForma').unblock();
		inputSelectSAFI = '';
	});
}


function mensajeSisRetro(parametrosCliente){

	var parametros = {
		mensajeAlert : '',
		muestraBtnAceptar: true,
		muestraBtnCancela: true,
		muestraBtnCerrar: true,
		txtAceptar : 'Aceptar',
		txtCancelar : 'Cancelar',
		txtCabecera:  'Mensaje:',
		funcionAceptar : function(){},
		funcionCancelar : function(){},
		funcionCerrar   : function(){}

	}


	$.extend( parametros, parametrosCliente );


	$.blockUI({
			message: mensajeAlertSAFIRetro,
			css: {border:		'none',
				background:	'none',
				left: '40%'
			}
		});

	$('#mensajeContenido').html(parametros.mensajeAlert);
	$('#safiTxtOk').html(parametros.txtAceptar);
	$('#safiTxtCancel').html(parametros.txtCancelar);
	$('#safiTxtCabecera').html(parametros.txtCabecera);


	var ubicaPantalla = $(".blockMsg").position();
	setTimeout(function(){
		if($(window).height() < ubicaPantalla.top){
			$(window).scrollTop(ubicaPantalla.top);
		}
	},100);


	$("#btnAlertCerrar").click(function(){
		$.unblockUI();
		inputSelectSAFI = '';
		parametros.funcionCerrar();
	});

	if(parametros.muestraBtnCerrar){
		$('#btnAlertCerrar').show();
	}else{
		$('#btnAlertCerrar').hide();
	}

	if(parametros.muestraBtnAceptar){

			if( parametros.funcionAceptar != null){
				$('#safiBtnOk').click(function(){
					$.unblockUI();
					inputSelectSAFI = '';

					parametros.funcionAceptar();


				});
			}
	}else{
		$('#safiBtnOk').hide();
	}

	if(parametros.muestraBtnCancela){
			if( parametros.funcionCancelar != null){
				$('#safiBtnCancel').click(function(){
					$.unblockUI();
					inputSelectSAFI = '';

					parametros.funcionCancelar();
				});
			}
	}else{
		$('#safiBtnCancel').hide();
	}


}




function mensajeSisError(numeroError, mensajeError) {
	var mensajeAlertSAFI = '<div class="alertInfo" id="alertInfo">'
		+ '<div class="cabeceraError"><b><em>Error:</em> '+numeroError+'</b>'
		+ '<span id="btnAlertCerrarError">X</span><div class="clearfix"></div></div>'
		+ '  <div class="contenidoError" id="mensajeContenido">'+mensajeError+'</div>'
		+ '  <div class="footer"><small>Pulse la tecla [Enter] para cerrar este Mensaje </small></div>'
		+ '</div> ';

	if ($('.blockUI').is(":visible")) {
		return false;
	}


	$('#contenedorForma').block({
	message : mensajeAlertSAFI,
	css : {
	border : 'none',
	background : 'none'
	}
	});


	$(".blockMsg").css("cursor", "wait");

	setTimeout(function() {

	}, 100);

	$("#alertInfo").mouseover(function() {
		if (inputSelectSAFI == '') {
			inputSelectSAFI = document.activeElement;
		}

	});

	$("#btnAlertCerrarError").click(function() {
		inputSelectSAFI.focus();
		$('#contenedorForma').unblock();
		inputSelectSAFI = '';
	});

}

/*=====  Fin de Mensajes del Sistema  ======*/

//Author: FChia
//Funcion para el Manejo de Transacciones hacia la BD
//event: es el vento que se disparo (submit)
//idForma: id de la forma que se enviara
//idDivContenedor: id del contenedor de la forma
//idDivMensaje: id del div donde se mostrara el mensaje de resultado
//inicializaforma: (true, false) indica si se inicializa la forma en mensaje de exito
//idCampoOrigen: Campo desde donde se inicializa (este campo no se inicializara)

function grabaFormaTransaccion(event, idForma, idDivContenedor, idDivMensaje,
		inicializaforma, idCampoOrigen) {
	consultaSesion();
	var jqForma = eval("'#" + idForma + "'");
	var jqContenedor = eval("'#" + idDivContenedor + "'");
	var jqMensaje = eval("'#" + idDivMensaje + "'");
	var url = $(jqForma).attr('action');
	var resultadoTransaccion = 0;

	quitaFormatoControles(idForma);
	$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');
	$(jqContenedor).block({
		message: $(jqMensaje),
		css: {border:		'none',
			background:	'none'}
	});
	// Envio de la forma


	var ubicaPantalla = $(".blockMsg").position();
	var sizePantalla  = $(window).height();
	setTimeout(function(){
		if(ubicaPantalla != null){
			if(ubicaPantalla.top > sizePantalla){
				$(window).scrollTop(ubicaPantalla.top);
			}
		}

	},100);

	$.post( url, serializaForma(idForma), function( data ) {
		if(data.length >0) {
			$(jqMensaje).html(data);
			var exitoTransaccion = $('#numeroMensaje').val();
			resultadoTransaccion = exitoTransaccion;
			if (exitoTransaccion == 0 && inicializaforma == 'true' ){
				inicializaForma(idForma, idCampoOrigen);
			}
			var campo = eval("'#" + idCampoOrigen + "'");
			if($('#consecutivo').val() != 0){
				$(campo).val($('#consecutivo').val());
			}
		}
	});
	return resultadoTransaccion;
}

/*
 grabaFormaTransaccionConGrid. para transacciones de pantallas con GRID
 si algun dato del grid contiene un error y es validado dentro del stored, el mensaje
describe el error y no se borran los datos capturados del Grid.
 Si en el grid todos los datos son correctos y se valida desde el stored que lo sean
 se graba y se limpia la pantalla.

 todos los .js de cada pantalla debera tener una funsion
 que se llame : limpiaFormaGridPantalla();

 y esta funsion debera de estar fuera de: $(document).ready(function() {});

 por ejemplo:
 -----------------------------------------------
 $(document).ready(function() {
 //funciones, eventos, etc
 });

 limpiaFormaGridPantalla(){
 //aca debe ser independiente de cada pantalla
 //como eliminar los grid
 }
 ------------------------------------------------
 * */
function grabaFormaTransaccionConGrid(event, idForma, idDivContenedor, idDivMensaje,
		inicializaforma, idCampoOrigen) {
	consultaSesion();
	var jqForma = eval("'#" + idForma + "'");
	var jqContenedor = eval("'#" + idDivContenedor + "'");
	var jqMensaje = eval("'#" + idDivMensaje + "'");
	var url = $(jqForma).attr('action');
	var resultadoTransaccion = 0;

	quitaFormatoControles(idForma);
//	No descomentar la siguiente linea
	$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');

//	Envio de la forma

	var ubicaPantalla = $(".blockMsg").position();
	var sizePantalla  = $(window).height();
	setTimeout(function(){
		if(ubicaPantalla != null){
			if(ubicaPantalla.top > sizePantalla){
				$(window).scrollTop(ubicaPantalla.top);
			}
		}
	},100);

	$.post( url, serializaForma(idForma), function( data ) {
		if(data.length >0) {
			$(jqMensaje).html(data);

			var exitoTransaccion = $('#numeroMensaje').asNumber();
			resultadoTransaccion = exitoTransaccion;
			if(exitoTransaccion!=0)	{inicializaforma='false';}

			if (exitoTransaccion == 0 && inicializaforma == 'true' ){
				inicializaForma(idForma, idCampoOrigen);
				limpiaFormaGridPantalla();//si no hubo error se limpia el Grid
			}
			var campo = eval("'#" + idCampoOrigen + "'");
			if($('#consecutivo').val() != 0){
				$(campo).val($('#consecutivo').val());
			}


			$(jqContenedor).block({
				message: $(jqMensaje),
				css: {border:		'none',
					background:	'none'}
			});


		}
	});
	return resultadoTransaccion;
}

function grabaFormaArchivo(event, idForma, idDivContenedor,idDivMensaje,
		inicializaforma, idCampoOrigen) {

	var jqForma = eval("'#" + idForma + "'");
	var jqContenedor = eval("'#" + idDivContenedor + "'");
	var jqMensaje = eval("'#" + idDivMensaje + "'");
	quitaFormatoControles(idForma);

	$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');
	$.blockUI({
		message: $(jqMensaje),
		css: {border:		'none',
			background:	'none'}
	});

	$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);


	var ubicaPantalla = $(".blockMsg").position();
	var sizePantalla  = $(window).height();
	setTimeout(function(){
		if(ubicaPantalla != null){
			if(ubicaPantalla.top > sizePantalla){
				$(window).scrollTop(ubicaPantalla.top);
			}
		}
	},100);
	// Envio de la forma
	$(jqForma).ajaxForm(function(data) {
		if(data.length >0) {
			$(jqMensaje).html(data);
			var exitoTransaccion = $('#numeroMensaje').val();
			resultadoTransaccion = exitoTransaccion;
			if (exitoTransaccion == 0 && inicializaforma == 'true' ){
				inicializaForma(idForma, idCampoOrigen);
			}
			var campo = eval("'#" + idCampoOrigen + "'");
			if($('#consecutivo').val() != 0){
				$(campo).val($('#consecutivo').val());
			}
		}
		//alert("Archivo Guardado");
	});

}
//Author: FChia
//Funcion para el Manejo de Transacciones hacia la BD
//event: es el vento que se disparo (submit)
//idForma: id de la forma que se enviara
//idDivContenedor: id del contenedor de la forma
//idDivMensaje: id del div donde se mostrara el mensaje de resultado
//inicializaforma: (true, false) indica si se inicializa la forma en mensaje de exito
//idCampoOrigen: Campo desde donde se inicializa (este campo no se inicializara)
//funcionPostEjecucionExitosa: Nombre de la Funcion a Ejecutar cuando la Respuesta de Ejecucion es Exitosa
//funcionPostEjecucionFallo: Nombre de la Funcion a Ejecutar cuando la Respuesta de Ejecucion es de Fallo o NO Exito
function grabaFormaTransaccionRetrollamada(event, idForma, idDivContenedor, idDivMensaje, inicializaforma, idCampoOrigen, funcionPostEjecucionExitosa, funcionPostEjecucionFallo) {
	consultaSesion();
	var jqForma = eval("'#" + idForma + "'");
	var jqContenedor = eval("'#" + idDivContenedor + "'");
	var jqMensaje = eval("'#" + idDivMensaje + "'");
	var url = $(jqForma).attr('action');
	var resultadoTransaccion = 0;

	quitaFormatoControles(idForma);
	//No descomentar la siguiente linea
	//event.preventDefault();
	$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');
	$(jqContenedor).block({
	message : $(jqMensaje),
	css : {
	border : 'none',
	background : 'none'
	}
	});
	// Envio de la forma
	var ubicaPantalla = $(".blockMsg").position();
	var sizePantalla = $(window).height();
	setTimeout(function() {
		if (ubicaPantalla != null) {
			if (ubicaPantalla.top > sizePantalla) {
				$(window).scrollTop(ubicaPantalla.top);
			}
		}
	}, 100);

	$.post(url, serializaForma(idForma), function(data) {
		if (data.length > 0) {
			$(jqMensaje).html(data);
			var exitoTransaccion = $('#numeroMensaje').val();
			resultadoTransaccion = exitoTransaccion;

			var campo = eval("'#" + idCampoOrigen + "'");
			if ($('#consecutivo').val() != 0) {
				$(campo).val($('#consecutivo').val());
			}
			//Ejecucion de las Funciones de CallBack(RetroLlamada)
			if (exitoTransaccion == 0 && funcionPostEjecucionExitosa != '') {
				esTab = true;

				eval(funcionPostEjecucionExitosa + '();');
			} else {
				eval(funcionPostEjecucionFallo + '();');
			}
			//TODO la de fallo
		}
	});
	return resultadoTransaccion;
}


/**
 * Ubica la lista y la adapta a la pantalla
 * @param jqControl: Elemento en el que se ubicara la lista
 * @param elemento: ID del elemento de la lista (cajaLista)
 * @param elementoLista: ID del elemento contenido en la cajaLista
 */
function posicionamiento(jqControl, elemento,elementoLista) {
	var jqElemento = eval("'#" + elemento + "'");
	var jqElementoLista = eval("'#" + elementoLista + "'");
	var position = $(jqControl).position();
	if ($(window).width() < $(jqElemento).width()) {
		var nsize = Number($(window).width()) * 0.6;
		var nssize = nsize + "px";
		$(jqElementoLista+" table").attr("width", nssize);
		$(jqElemento).position({
		my : "left bottom",
		at : "left bottom",
		of : jqControl,
		collision : "fit flip",
		});
	}
	/*Se verifica la posicion del contenedor de la lista y se vuelve a ubicar su posicion en la pantalla*/
	if ($(jqElemento).position().top < 0) {
		$(jqElemento).position({
		my : "left bottom",
		at : "left bottom",
		of : jqControl,
		collision : "fit flip",
		});
	}
	//Alinea la lista al control
	$(jqElemento).css({
		left : eval("'" + (position.left + 1) + "px'"),
		top : eval("'" + (position.top + 18) + "px'"),
		});
}

/**
 * Método para Listar
 * @param controlId: Control ID del cuál se lista
 * @param minCaracteres: Minimo de caracteres para comenzar listado
 * @param tipoListaVal: Tipo de Lista
 * @param campoLista: ID del objecto en pantalla donde se ubicara la lista
 * @param parametroLista: Lista de parametros a enviar a la lista a consultar
 * @param vista: servicio al cuál se le hara la petición de la vista
 * @returns {Boolean}
 */
function lista(controlId, minCaracteres, tipoListaVal, campoLista, parametroLista, vista) {
	var jqControl = eval("'#" + controlId + "'");
	var position = $(jqControl).position();
	var valorListar = $(jqControl).val();
	consultaSesion();
	var params = {};
	if (document.activeElement.id) {
		if (document.activeElement.id == controlId) {
			if (numLetrasSAFI == $(jqControl).val().length) {
				return false;
			} else {
				numLetrasSAFI = $(jqControl).val().length;
			}
		}
	}

	if ($(jqControl).val().length <= minCaracteres || !isNaN($(jqControl).val())) {
		$('#cajaLista').hide();
	} else {
		//Si la Variable de CampoLista es un Arreglo
		if ((typeof campoLista == 'object') && campoLista.length != null) {
			for (i = 0; i < campoLista.length; i++) {
				params[campoLista[i]] = parametroLista[i];
			}
		} else {
			params[campoLista] = parametroLista;
		}

		params['controlID'] = controlId;
		params['tipoLista'] = tipoListaVal;
		$('#cajaLista').css({
		position : 'absolute',
		collision : "fit flip"
		});

		$.post(vista, params, function(data) {
			if (data.length > 0) {
				$('#cajaLista').show();
				$('#elementoLista').html(data);
				selectPrimerRegistro('cajaLista');
				posicionamiento(jqControl, 'cajaLista','elementoLista');
			}
		});
	}
}

/**
 *  Lista para listar los Clientes
 * @param controlId: Control ID del cuál se lista
 * @param minCaracteres: Minimo de caracteres para comenzar listado
 * @param tipoListaVal: Tipo de Lista
 * @param campoLista: ID del objecto en pantalla donde se ubicara la lista
 * @param parametroLista: Lista de parametros a enviar a la lista a consultar
 * @param vista: servicio al cuál se le hara la petición de la vista
 * @returns {Boolean}
 */
function listaCte(controlId, minCaracteres, tipoListaVal, campoLista, parametroLista, vista) {
	var jqControl = eval("'#" + controlId + "'");
	var position = $(jqControl).position();
	var valorListar = $(jqControl).val();
	consultaSesion();
	var params = {};
	if (document.activeElement.id) {
		if (document.activeElement.id == controlId) {
			if (numLetrasSAFI == $(jqControl).val().length) {
				return false;
			} else {
				numLetrasSAFI = $(jqControl).val().length;
			}
		}
	}
	if ($(jqControl).val().length <= minCaracteres || !isNaN($(jqControl).val())) {
		$('#cajaListaCte').hide();
	} else {
		//Si la Variable de CampoLista es un Arreglo
		if ((typeof campoLista == 'object') && campoLista.length != null) {
			for (i = 0; i < campoLista.length; i++) {
				params[campoLista[i]] = parametroLista[i];
			}
		} else {
			params[campoLista] = parametroLista;
		}
		params['controlID'] = controlId;
		params['tipoLista'] = tipoListaVal;
		$('#cajaListaCte').css({
		position : 'absolute',
		collision : "fit flip"
		});
		$("#elementoListaCte").empty();
		$.post(vista, params, function(data) {
			if (data.length > 0) {
				$('#cajaListaCte').show();
				$('#elementoListaCte').html(data);
				selectPrimerRegistro('cajaListaCte');
				posicionamiento(jqControl, 'cajaListaCte','elementoListaCte');
			}
		});
	}
}

/**
 * Lista Alfanumerica
 * @param controlId: Control ID del cuál se lista
 * @param minCaracteres: Minimo de caracteres para comenzar listado
 * @param tipoListaVal: Tipo de Lista
 * @param campoLista: ID del objecto en pantalla donde se ubicara la lista
 * @param parametroLista: Lista de parametros a enviar a la lista a consultar
 * @param vista: servicio al cuál se le hara la petición de la vista
 * @returns {Boolean}
 */
function listaAlfanumerica(controlId, minCaracteres, tipoListaVal, campoLista, parametroLista, vista) {
	var jqControl = eval("'#" + controlId + "'");
	var position = $(jqControl).position();
	var valorListar = $(jqControl).val();
	var params = {};
	if (document.activeElement.id) {
		if (document.activeElement.id == controlId) {
			if (numLetrasSAFI == $(jqControl).val().length) {
				return false;
			} else {
				numLetrasSAFI = $(jqControl).val().length;
			}
		}
	}
	if ($(jqControl).val().length <= minCaracteres) {
		$('#cajaLista').hide();
	} else {
		//Si la Variable de CampoLista es un Arreglo
		if ((typeof campoLista == 'object') && campoLista.length != null) {
			for (i = 0; i < campoLista.length; i++) {
				params[campoLista[i]] = parametroLista[i];
			}
		} else {
			params[campoLista] = parametroLista;
		}
		params['controlID'] = controlId;
		params['tipoLista'] = tipoListaVal;
		$('#cajaLista').css({
		position : 'absolute',
		collision : "fit flip"
		});
		$.post(vista, params, function(data) {
			if (data.length > 0) {
				$('#cajaLista').show();
				$('#elementoLista').html(data);
				selectPrimerRegistro('cajaLista');
				posicionamiento(jqControl, 'cajaLista','elementoLista');
			}
		});
	}
}
/**
 * Lista solo cuanso se esciben letras
 * @param controlId: Control ID del cuál se lista
 * @param minCaracteres: Minimo de caracteres para comenzar listado
 * @param tipoListaVal: Tipo de Lista
 * @param campoLista: ID del objecto en pantalla donde se ubicara la lista
 * @param parametroLista: Lista de parametros a enviar a la lista a consultar
 * @param vista: servicio al cuál se le hara la petición de la vista
 * @returns {Boolean}
 */
function listaAlfanumericaSoloLetras(controlId, minCaracteres, tipoListaVal, campoLista, parametroLista, vista) {
	var jqControl = eval("'#" + controlId + "'");
	var position = $(jqControl).position();
	var valorListar = $(jqControl).val();
	var params = {};
	if (document.activeElement.id) {
		if (document.activeElement.id == controlId) {
			if (numLetrasSAFI == $(jqControl).val().length) {
				return false;
			} else {
				numLetrasSAFI = $(jqControl).val().length;
			}
		}
	}
	if ($(jqControl).val().length <= minCaracteres || !isNaN($(jqControl).val())) {
		$('#cajaLista').hide();
	} else {
		//Si la Variable de CampoLista es un Arreglo
		if ((typeof campoLista == 'object') && campoLista.length != null) {
			for (i = 0; i < campoLista.length; i++) {
				params[campoLista[i]] = parametroLista[i];
			}
		} else {
			params[campoLista] = parametroLista;
		}
		params['controlID'] = controlId;
		params['tipoLista'] = tipoListaVal;
		$('#cajaLista').css({
		position : 'absolute',
		collision : "fit flip"
		});
		$.post(vista, params, function(data) {
			if (data.length > 0) {
				$('#cajaLista').show();
				$('#elementoLista').html(data);
				selectPrimerRegistro('cajaLista');
				posicionamiento(jqControl, 'cajaLista','elementoLista');
			}
		});
	}
}

/**
 *  Lista Alfanumerica para listar los Clientes
 * @param controlId: Control ID del cuál se lista
 * @param minCaracteres: Minimo de caracteres para comenzar listado
 * @param tipoListaVal: Tipo de Lista
 * @param campoLista: ID del objecto en pantalla donde se ubicara la lista
 * @param parametroLista: Lista de parametros a enviar a la lista a consultar
 * @param vista: servicio al cuál se le hara la petición de la vista
 * @returns {Boolean}
 */
function listaAlfanumericaCte(controlId, minCaracteres, tipoListaVal, campoLista, parametroLista, vista) {
	var jqControl = eval("'#" + controlId + "'");
	var position = $(jqControl).position();
	var valorListar = $(jqControl).val();
	var params = {};
	if (document.activeElement.id) {
		if (document.activeElement.id == controlId) {
			if (numLetrasSAFI == $(jqControl).val().length) {
				return false;
			} else {
				numLetrasSAFI = $(jqControl).val().length;
			}
		}
	}
	if ($(jqControl).val().length <= minCaracteres) {
		$('#cajaListaCte').hide();
	} else {
		//Si la Variable de CampoLista es un Arreglo
		if ((typeof campoLista == 'object') && campoLista.length != null) {
			for (i = 0; i < campoLista.length; i++) {
				params[campoLista[i]] = parametroLista[i];
			}
		} else {
			params[campoLista] = parametroLista;
		}
		params['controlID'] = controlId;
		params['tipoLista'] = tipoListaVal;
		$('#cajaListaCte').css({
		position : 'absolute',
		collision : "fit flip"
		});
		$("#elementoListaCte").empty();
		$.post(vista, params, function(data) {
			if (data.length > 0) {
				$('#cajaListaCte').show();
				$('#elementoListaCte').html(data);
				selectPrimerRegistro('cajaListaCte');
				posicionamiento(jqControl, 'cajaListaCte','elementoLista');
			}
		});
	}
}

/**
 *  Método para listar
 * @param controlId: Control ID del cuál se lista
 * @param minCaracteres: Minimo de caracteres para comenzar listado
 * @param tipoListaVal: Tipo de Lista
 * @param campoLista: ID del objecto en pantalla donde se ubicara la lista
 * @param parametroLista: Lista de parametros a enviar a la lista a consultar
 * @param vista: servicio al cuál se le hara la petición de la vista
 * @returns {Boolean}
 */
function listaContenedor(controlId, minCaracteres, tipoListaVal, campoLista, parametroLista, vista) {
	var jqControl = eval("'#" + controlId + "'");
	var position = $(jqControl).position();
	var valorListar = $(jqControl).val();
	consultaSesion();
	var params = {};
	if (document.activeElement.id) {
		if (document.activeElement.id == controlId) {
			if (numLetrasSAFI == $(jqControl).val().length) {
				return false;
			} else {
				numLetrasSAFI = $(jqControl).val().length;
			}
		}
	}
	if ($(jqControl).val().length <= minCaracteres || !isNaN($(jqControl).val())) {
		$('#cajaListaContenedor').hide();
	} else {
		//Si la Variable de CampoLista es un Arreglo
		if ((typeof campoLista == 'object') && campoLista.length != null) {
			for (i = 0; i < campoLista.length; i++) {
				params[campoLista[i]] = parametroLista[i];
			}
		} else {
			params[campoLista] = parametroLista;
		}
		params['controlID'] = controlId;
		params['tipoLista'] = tipoListaVal;
		$('#cajaListaContenedor').css({
		position : 'absolute',
		collision : "fit flip"
		});
		$("#elementoListaContenedor").empty();
		$.post(vista, params, function(data) {
			if (data.length > 0) {
				$('#cajaListaContenedor').show();
				$('#elementoListaContenedor').html(data);
				selectPrimerRegistro('cajaListaContenedor');
				posicionamiento(jqControl, 'cajaListaContenedor','elementoListaContenedor');
			}
		});
	}
}

/**
 * funciona como la lista, pero recibe de parametros caja y elemento (indican el id del div en el que se mostrara la lista)
 * @param controlId: Control ID del cuál se lista
 * @param minCaracteres: Minimo de caracteres para comenzar listado
 * @param tipoListaVal: Tipo de Lista
 * @param campoLista: ID del objecto en pantalla donde se ubicara la lista
 * @param parametroLista: Lista de parametros a enviar a la lista a consultar
 * @param vista: servicio al cuál se le hara la petición de la vista
 * @returns {Boolean}
 */
function listaGenerica(controlId, minCaracteres, tipoListaVal, campoLista, parametroLista, vista, caja, elemento) {
	var jqControl = eval("'#" + controlId + "'");
	var jqCaja = eval("'#" + caja + "'");
	var jqElemento = eval("'#" + elemento + "'");
	var position = $(jqControl).position();
	var valorListar = $(jqControl).val();
	consultaSesion();
	var params = {};
	if (document.activeElement.id) {
		if (document.activeElement.id == controlId) {
			if (numLetrasSAFI == $(jqControl).val().length) {
				return false;
			} else {
				numLetrasSAFI = $(jqControl).val().length;
			}
		}
	}
	if ($(jqControl).val().length <= minCaracteres || !isNaN($(jqControl).val())) {
		$(jqCaja).hide();
	} else {
		//Si la Variable de CampoLista es un Arreglo
		if ((typeof campoLista == 'object') && campoLista.length != null) {
			for (var i = 0; i < campoLista.length; i++) {
				params[campoLista[i]] = parametroLista[i];
			}
		} else {
			params[campoLista] = parametroLista;
		}
		params['controlID'] = controlId;
		params['tipoLista'] = tipoListaVal;
		$(jqCaja).css({
		position : 'absolute',
		collision : "fit flip"
		});
		$.post(vista, params, function(data) {
			if (data.length > 0) {
				$(jqCaja).show();
				$(jqElemento).html(data);
				selectPrimerRegistro(caja);
				posicionamiento(jqControl, caja,elemento);
			}
		});
	}
}

function cargaValorLista(control, valor) {
	consultaSesion();
	jqControl = eval("'#" + control + "'");
	$(jqControl).val(valor);
	$(jqControl).focus();
	setTimeout("$('#cajaLista').hide();", 200);
}

function cargaValorListaCte(control, valor) {
	consultaSesion();
	jqControl = eval("'#" + control + "'");
	$(jqControl).val(valor);
	$(jqControl).focus();
	setTimeout("$('#cajaListaCte').hide();", 200);
}

function cargaValorListaContenedor(control, valor) {
	consultaSesion();
	jqControl = eval("'#" + control + "'");
	$(jqControl).val(valor);
	$(jqControl).focus();
	setTimeout("$('#cajaListaContenedor').hide();", 200);
}


function deshabilitaControl(controlBtnId) {
	var jqControl = eval("'#" + controlBtnId + "'");
	$(jqControl).attr('disabled', 'disabled');
	$(jqControl).attr('deshabilitado', 'true');
}

function habilitaControl(controlBtnId) {
	var jqControl = eval("'#" + controlBtnId + "'");
	$(jqControl).attr('disabled',false);
	$(jqControl).attr('deshabilitado', 'false');
	$(jqControl).attr('readOnly',false);
}

function soloLecturaControl(controlBtnId) {
	var jqControl = eval("'#" + controlBtnId + "'");
	$(jqControl).attr('readOnly',true);
}

//controlBtnId es el id del boton a deshabilitar
//tipo: boton, submit
function deshabilitaBoton(controlBtnId, tipo) {
	var jqControl = eval("'#" + controlBtnId + "'");
	var claseId = 'submit';
	var claseSobreId = 'submit:hover ';

	if (tipo == 'boton'){
		claseId = "botonGral";
		claseSobreId = "botonGral:hover";
	}

	$(jqControl).attr('disabled', 'disabled');
	$(jqControl).removeClass(claseId);
	$(jqControl).removeClass(claseSobreId);
	$(jqControl).addClass("botonDeshabilitado");

}


//controlBtnId es el id del boton a habilitar
//tipo: boton, submit
function habilitaBoton(controlBtnId, tipo) {
	var jqControl = eval("'#" + controlBtnId + "'");
	var claseDeshabilitaId = 'submit';
	var claseId = 'submit';
	var claseSobreId = 'submit:hover ';
	if (tipo == 'boton'){
		claseId = "botonGral";
		claseSobreId = "botonGral:hover";
	}
	$(jqControl).removeAttr('disabled');
	$(jqControl).removeClass(claseDeshabilitaId);
	$(jqControl).addClass("submit");
	$(jqControl).addClass("submit:hover");
}


//limforma es el id de la forma  a limpiar
function limpiaForm(limforma) {
//	recorremos todos los campos que tiene el formulario
	$(':input', limforma).each(function() {
		var type = this.type;
		if (type == 'text' || type == 'password' || type == "textarea")
			this.value = "";
//		excepto de los checkboxes y radios, le quitamos el checked
//		pero su valor no debe ser cambiado
		else if (type == 'checkbox' || type == 'radio')
			this.checked = false;
//		los selects le ponemos el indice a -
		else if (type == 'select')
			this.selectedIndex = -1;
	});
}


//Author: FChia
//Funcion de inicializa los valores de una forma
//idForma: id de la forma a inicializar
//idCampoOrigen: Campo desde donde se inicializa,
//este campo no se inicializara
function inicializaForma(idForma, idCampoOrigen) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find(':input').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				var formInicializa = 'true';

				if($(jControl).attr('iniForma') != null){
					formInicializa = $(jControl).attr('iniForma');
				}

				if($(jControl).attr('id') == idCampoOrigen){
					formInicializa = 'false';
				}

				if(formInicializa=='true'){
					if(child.is(':text, textarea')){
						child.val('');
					}

					if(child.is(':password')){
						child.val('');
					}
					if(child.is(':radio')){
						$(jControl).attr('checked', true);
					}

					if(child.is(':checkbox')){
						child.attr('checked', false);
					}
				}
			}
	);
}

//funcion para convertir minusculas a mayusculas
function ponerMayusculas(nombre)
{
	nombre.value=nombre.value.toUpperCase();
}

//Author: Daniel Carrasco
/* Agrega la propiedad de readOnly a los de tipo Hidden */
window.onload = validar_oculto;
function validar_oculto(){
	var x=document.getElementsByTagName('input');
	for(var a=0;a<x.length;a++){
		if(x[a].type=='hidden'){
			x[a].setAttribute('readOnly', true);
		}
	}
	return true;
}

$(document).click(function(e){
	if($('#alertInfo').is(':visible')){
		return false;
	}

	var clicked = e.target.id;
	clicked=clicked.substring(0, 8);
	if(clicked!='buscarMi' && clicked!='buscarGe'){
		setTimeout("$('#cajaListaCte').hide();", 200);
		$('#elementoListaCte').empty();
	}
});


/* Desabilita el boton derecho del mouse*/
document.onmousedown = anularBotonDerecho;
document.oncontextmenu = new Function("return false");
function anularBotonDerecho(e) {
	var msg = "Derechos Reservados © \n EfiSys";
	if (navigator.appName == 'Netscape' && e.which == 3) {
		alert(msg);
		return false;
	}else if (navigator.appName == 'Microsoft Internet Explorer' && event.button==2) {
		alert(msg);
		return false;
	}
	return true;
}

/* Desabilita el boton F5*/
document.onkeydown =validar;
function validar(e) {
	var key;

	if(navigator.appName == 'Microsoft Internet Explorer' ) {
		key=window.event.keyCode;
		window.event.keyCode = 505;
		if(key==116 && window.event && window.event.keyCode == 505){
			alert("F5 Tecla Invalida");
			return false;
		}
	}else if(navigator.appName == 'Netscape') {
		key=e.keyCode;
		if(key==116) {
			alert("F5 Tecla Invalida");
			return false;
		}
	}
}

/* Cancela la tecla enter en los formulario*/
document.onkeypress = pulsar;
function pulsar(e) {
	tecla=(document.all) ? e.keyCode : e.which;
	if(tecla==13){
		return false;
	}
	return true;
}

function actualizaFormatosMoneda(idForma) {
	actualizaFormatoMoneda(idForma);
	actualizaFormatoTasa(idForma);
	actualizaFormatoseisDecimales(idForma);
	actualizaFormatoMonto(idForma);
	actFormatoMonedaHTML(idForma);
}

function actualizaFormatoMoneda(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[esMoneda="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				$(jControl).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			});
}

function actFormatoMonedaHTML(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('strong[esMoneda="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				$(jControl).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			});
}

function actualizaFormatoMonto(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[esMonto="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				$(jControl).formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '%n',
					roundToDecimalPlace: 2});
			});
}

function actualizaFormatoTasa(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[esTasa="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				$(jControl).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 4});
			});
}

function actualizaFormatoseisDecimales(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[seisDecimales="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				$(jControl).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 6});
			});
}

function agregaFormatoMoneda(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[esMoneda="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				$(jControl).bind('keyup',function(){
					$(jControl).formatCurrency({
						colorize: true,
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: -1
					});
				});
				$(jControl).blur(function() {
					$(jControl).formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: 2
					});
				});
				$(jControl).formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '%n',
					roundToDecimalPlace: 2
				});
			}
	);
}

function agregaFormatoTasa(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[esTasa="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				$(jControl).bind('keyup',function(){
					$(jControl).formatCurrency({
						colorize: true,
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: -1
					});
				});
				$(jControl).blur(function() {
					$(jControl).formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: 4
					});
				});
				$(jControl).formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '%n',
					roundToDecimalPlace: 4
				});

			}
	);
}

function agregaFormatoseisDecimales(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[seisDecimales="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				$(jControl).bind('keyup',function(){
					$(jControl).formatCurrency({
						colorize: true,
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: -1
					});
				});
				$(jControl).blur(function() {
					$(jControl).formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: 6
					});
				});
				$(jControl).formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '%n',
					roundToDecimalPlace: 6
				});

			}
	);
}

function agregaFormatoMonto(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[esMonto="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				$(jControl).bind('keyup',function(){
					$(jControl).formatCurrency({
						colorize: true,
						positiveFormat: '%n',
						negativeFormat: '-%n',
						roundToDecimalPlace: -1
					});
				});
				$(jControl).blur(function() {
					$(jControl).formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '-%n',
						roundToDecimalPlace: 2
					});
				});
				$(jControl).formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '-%n',
					roundToDecimalPlace: 2
				});
			}
	);
}

function agregaFormatoBigDecimal(idForma) {
        var jqForma = eval("'#" + idForma + "'");
        $(jqForma).find('input[esbigdecimal="true"]').each(

                        function(){
                                var child = $(this);

					 			var jControl = eval("'#" + child.attr('id') + "'");
                                $(jControl).bind('keyup',function(event){
                                      formatoBigDecimal(event,jControl);


                                });
                                $(jControl).blur(function() {
                                       formatoBigDecimal(event,jControl);
                                        var secciones = $(jControl).val().toString().split(".");
						                secciones[0] = secciones[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						                if(secciones.length == 1){
											secciones[1] = '00';
										}
									 	if(secciones.length >= 2){
											$(jControl).val(secciones[0]+"."+secciones[1]);
										}
                                });


                                formatoBigDecimal(event,jControl);
                                var secciones = $(jControl).val().toString().split(".");
				                secciones[0] = secciones[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				                if(secciones.length == 1){
									secciones[1] = '00';
								}
							 	if(secciones.length >= 2){
									$(jControl).val(secciones[0]+"."+secciones[1]);
								}

			}

 );
}

function formatoBigDecimal(event,jControl){
 	if(    event.keyCode != keysSAFI.LEFT &
		   event.keyCode != keysSAFI.RIGHT &
		   event.keyCode != keysSAFI.BACKSPACE &
		   event.keyCode != keysSAFI.UP &
		   event.keyCode != keysSAFI.DOWN &
		   event.keyCode != keysSAFI.TAB ){

               var bigDecimal =  $(jControl).val();
               bigDecimal = bigDecimal.replace(/[^0-9.]/g, "");

               var secciones = bigDecimal.toString().split(".");

                secciones[0] = secciones[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");

               if(secciones.length >= 2){
					secciones[1] = secciones[1].substring(0,2);
				  }

	            $(jControl).val(secciones.join("."));

    }

}



//Author: Fsanchez
//Funcion para validar el numero maximo de caracteres numericos introducidos en un input
function agregaFormatoNumMaximo(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[numMax]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				$(jControl).bind('keyup',function(){
					var texto = $(jControl).val();
					var numCaract = $(this).attr("numMax");
					if(texto.length > numCaract && !isNaN($(jControl).val())){
						texto = texto.substring(0,numCaract);
						$(jControl).val(texto);
					}
				});
			}
	);
}


function controlQuitaFormatoMoneda(control){
	var jControl = eval("'#" + control + "'");
	var valor=($(jControl).formatCurrency({
		positiveFormat: '%n',
		roundToDecimalPlace: 2
	})).asNumber();
	$(jControl).val(valor);
}

function quitaFormatoMoneda(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[esMoneda="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				var valor=($(jControl).formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				})).asNumber();
				$(jControl).val(valor);
			}
	);
}

function controlQuitaFormatoMonto(control){
	var jControl = eval("'#" + control + "'");
	var valor=($(jControl).formatCurrency({
		positiveFormat: '%n',
		negativeFormat: '-%n',
		roundToDecimalPlace: 2
	})).asNumber();
	$(jControl).val(valor);
}

function quitaFormatoMonto(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[esMonto="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				var valor=($(jControl).formatCurrency({
					positiveFormat: '%n',
					negativeFormat: '-%n',
					roundToDecimalPlace: 2
				})).asNumber();
				$(jControl).val(valor);
			}
	);
}


function quitaFormatoBigDecimal(idForma){
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[esbigdecimal="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				var valor= $(jControl).val().replace(/[^0-9.]/g, "");
				$(jControl).val(valor);
			}
	);
}


function controlQuitaFormatoTasa(control){
	var jControl = eval("'#" + control + "'");
	var valor=($(jControl).formatCurrency({
		positiveFormat: '%n',
		roundToDecimalPlace: 4
	})).asNumber();
	$(jControl).val(valor);
}

function quitaFormatoTasa(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[esMoneda="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				var valor=($(jControl).formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 4
				})).asNumber();
				$(jControl).val(valor);
			}
	);
}

function controlQuitaFormatoSeisDecimales(control){
	var jControl = eval("'#" + control + "'");
	var valor=($(jControl).formatCurrency({
		positiveFormat: '%n',
		roundToDecimalPlace: 6
	})).asNumber();
	$(jControl).val(valor);
}

function quitaFormatoSeisDecimales(idForma) {
	var jqForma = eval("'#" + idForma + "'");
	$(jqForma).find('input[seisDecimales="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				var valor=($(jControl).formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 6
				})).asNumber();
				$(jControl).val(valor);
			}
	);
}

function agregaCalendario(idForma) {
	var paramSesion = consultaParametrosSession();
	var fechaDeSistema = paramSesion.fechaSucursal;
	var jqForma = eval("'#" + idForma + "'");

	$(jqForma).find('input[esCalendario="true"]').each(
  		function(){
  			var child = $(this);
			var jControl = eval("'#" + child.attr('id') + "'");
    		$(jControl).datepicker({
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true,
				changeYear: true,
				dateFormat: 'yy-mm-dd',
				yearRange: '-100:+10',
				defaultDate: fechaDeSistema

			});

			$(jControl).datepicker($.datepicker.regional['es']);
  		}
	);
}


function agregaFormatoControles(idForma){
	agregaFormatoMoneda(idForma);
	agregaFormatoTasa(idForma);
	agregaCalendario(idForma);
	agregaFormatoNumMaximo(idForma);
	agregaFormatoseisDecimales(idForma);
    agregaFormatoBigDecimal(idForma);
    agregaFormatoMonto(idForma);
    actFormatoMonedaHTML(idForma);
}

function quitaFormatoControles(idForma){
	quitaFormatoMoneda(idForma);
	quitaFormatoTasa(idForma);
	quitaFormatoSeisDecimales(idForma);
	quitaFormatoBigDecimal(idForma);
}

function serializaDisabled(idForma){
	var jqForma = eval("'#" + idForma + "'");
	var obj={};

	$(jqForma).find('input[deshabilitado="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				obj[$(jControl).attr('id')]=$(jControl).val();
			}
	);
	$(jqForma).find('select[deshabilitado="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				obj[$(jControl).attr('id')]=$(jControl).val();
			}
	);

	$(jqForma).find('input[disabled="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				obj[$(jControl).attr('id')]=$(jControl).val();
			}
	);
	$(jqForma).find('input[disabled="disabled"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				obj[$(jControl).attr('id')]=$(jControl).val();
			}
	);

	$(jqForma).find('input[disabled]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				obj[$(jControl).attr('id')]=$(jControl).val();
			}
	);

	$(jqForma).find('text[disabled="disabled"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				obj[$(jControl).attr('id')]=$(jControl).val();
			}
	);
	$(jqForma).find('text[disabled="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				obj[$(jControl).attr('id')]=$(jControl).val();
			}
	);
	$(jqForma).find('text[deshabilitado="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				obj[$(jControl).attr('id')]=$(jControl).val();
			}
	);
	$(jqForma).find('select[disabled="true"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				obj[$(jControl).attr('id')]=$(jControl).val();
			}
	);
	$(jqForma).find('select[disabled="disabled"]').each(
			function(){
				var child = $(this);
				var jControl = eval("'#" + child.attr('id') + "'");
				obj[$(jControl).attr('id')]=$(jControl).val();
			}
	);
	return $.param(obj);
}

function serializaForma(idForma){
	var jqForma = eval("'#" + idForma + "'");
	return $(jqForma).serialize()+'&'+ serializaDisabled(idForma);

}

//Autor: Fsanchez
//funcion para intercalar colores del grid
function alternaFilas(id){
	if(document.getElementsByTagName){
		var table = document.getElementById(id);
		var rows = table.getElementsByTagName("tr");
		for(i = 0; i < rows.length; i++){
			if(i % 2 == 0){
				rows[i].className = "parcolor";
			}else{
				rows[i].className = "imparcolor";
			}
		}
	}
}

function timerSesion(){
	$.timer(60000, function(){
		consultaSesion();
	});
}
//variable clave de usuario para cambiar estatus de sesion cuando ya expiró la sesión
var parametroBean = consultaParametrosSession();
var cl =parametroBean.claveUsuario;
$('#nuClave').val(cl);

//funcion para consultar si la sesion sigue activa o ya expiró
function consultaSesion(){
	var claveUsuario = cl;
	usuarioServicio.consultaUsuarioLogeado(claveUsuario,function(usuario) {
		var estaLogeado = usuario;
		if(estaLogeado=="N"){
			alert('POR SU SEGURIDAD: Su Sesión en la Aplicación SAFI ha sido Finalizada de forma Automática por Exceder el Tiempo Límite de Inactividad Permitido.');
			location.href ='cerrarSessionUsuarios.htm?claveUsuario=' + cl;
		}
	});
}


//Consulta los Parametros de Session
function consultaParametrosSession(){
	var parSessionBean = null;
	$.ajax(
		{	type: "GET",
			url: "consultaSession.htm",
			dataType: "xml",
        	async: false,
			success: function(xmlInf) {
				parSessionBean = {
  					'fechaAplicacion':$(xmlInf).find('fechaAplicacion').text(),
  					'numeroSucursalMatriz':$(xmlInf).find('numeroSucursalMatriz').text(),
  					'nombreSucursalMatriz':$(xmlInf).find('nombreSucursalMatriz').text(),
  					'telefonoLocal':$(xmlInf).find('telefonoLocal').text(),
  					'telefonoInterior':$(xmlInf).find('telefonoInterior').text(),
  					'numeroInstitucion':$(xmlInf).find('numeroInstitucion').text(),
  					'nombreInstitucion':$(xmlInf).find('nombreInstitucion').text(),
  					'representanteLegal':$(xmlInf).find('representanteLegal').text(),
  					'rfcRepresentante':$(xmlInf).find('rfcRepresentante').text(),
  					'numeroMonedaBase':$(xmlInf).find('numeroMonedaBase').text(),
  					'nombreMonedaBase':$(xmlInf).find('nombreMonedaBase').text(),
  					'desCortaMonedaBase':$(xmlInf).find('desCortaMonedaBase').text(),
  					'simboloMonedaBase':$(xmlInf).find('simboloMonedaBase').text(),
  					'numeroUsuario':$(xmlInf).find('numeroUsuario').text(),
  					'claveUsuario':$(xmlInf).find('claveUsuario').text(),
  					'perfilUsuario':$(xmlInf).find('perfilUsuario').text(),
  					'nombreUsuario':$(xmlInf).find('nombreUsuario').text(),
  					'correoUsuario':$(xmlInf).find('correoUsuario').text(),
  					'sucursal':$(xmlInf).find('sucursal').text(),
  					'fechaSucursal':$(xmlInf).find('fechaSucursal').text(),
  					'nombreSucursal':$(xmlInf).find('nombreSucursal').text(),
  					'gerenteSucursal':$(xmlInf).find('gerenteSucursal').text(),
  					'numeroCaja':$(xmlInf).find('numeroCaja').text(),
					'loginsFallidos':$(xmlInf).find('loginsFallidos').text(),
					'tasaISR':$(xmlInf).find('tasaISR').text(),
					'diasBaseInversion':$(xmlInf).find('diasBaseInversion').text()	,
					'fechUltimAcces':$(xmlInf).find('fechUltimAcces').text(),
					'fechUltPass':$(xmlInf).find('fechUltPass').text(),
					'diasCambioPass':$(xmlInf).find('diasCambioPass').text(),
					'cambioPassword':$(xmlInf).find('cambioPassword').text(),
					'estatusSesion':$(xmlInf).find('estatusSesion').text(),
					'IPsesion':$(xmlInf).find('IPsesion').text(),
					'promotorID':$(xmlInf).find('promotorID').text(),
					'clienteInstitucion':$(xmlInf).find('clienteInstitucion').text(),
					'cuentaInstitucion':$(xmlInf).find('cuentaInstitucion').text(),
					'rutaArchivos':$(xmlInf).find('rutaArchivos').text(),
					'cajaID':$(xmlInf).find('cajaID').text(),
					'tipoCaja':$(xmlInf).find('tipoCaja').text(),
					'estatusCaja':$(xmlInf).find('estatusCaja').text(),
					'saldoEfecMN':$(xmlInf).find('saldoEfecMN').text(),
					'saldoEfecME':$(xmlInf).find('saldoEfecME').text(),
					'limiteEfectivoMN':$(xmlInf).find('limiteEfectivoMN').text(),
					'tipoCajaDes':$(xmlInf).find('tipoCajaDes').text(),
					'clavePuestoID':$(xmlInf).find('clavePuestoID').text(),
					'rutaArchivosPLD':$(xmlInf).find('rutaArchivosPLD').text(),
					'ivaSucursal':$(xmlInf).find('ivaSucursal').text(),
					'direccionInstitucion':$(xmlInf).find('direccionInstitucion').text(),
					'impTicket':$(xmlInf).find('impTicket').text(),
					'edoMunSucursal':$(xmlInf).find('edoMunSucursal').text(),
					'tipoImpTicket':$(xmlInf).find('tipoImpTicket').text(),
					'montoAportacion':$(xmlInf).find('montoAportacion').text(),
					'montoPolizaSegA':$(xmlInf).find('montoPolizaSegA').text(),
					'montoSegAyuda':$(xmlInf).find('montoSegAyuda').text(),
					'salMinDF':$(xmlInf).find('salMinDF').text(),
					'dirFiscal':$(xmlInf).find('dirFiscal').text(),
					'rfcInst':$(xmlInf).find('rfcInst').text(),
					'nombreJefeCobranza':$(xmlInf).find('nombreJefeCobranza').text(),
					'nomJefeOperayPromo':$(xmlInf).find('nomJefeOperayPromo').text(),
					'impSaldoCred':$(xmlInf).find('impSaldoCred').text(),
					'impSaldoCta':$(xmlInf).find('impSaldoCta').text(),
					'nombreCortoInst':$(xmlInf).find('nombreCortoInst').text(),
					'gerenteGeneral':$(xmlInf).find('gerenteGeneral').text(),
					'presidenteConsejo':$(xmlInf).find('presidenteConsejo').text(),
					'jefeContabilidad':$(xmlInf).find('jefeContabilidad').text(),
					'recursoTicketVent':$(xmlInf).find('recursoTicketVent').text(),
					'rolTesoreria':$(xmlInf).find('rolTesoreria').text(),  // rol tesoreria
					'rolAdminTeso':$(xmlInf).find('rolAdminTeso').text(),//rol admin tesoreria
					'mostrarSaldDisCtaYSbc':$(xmlInf).find('mostrarSaldDisCtaYSbc').text(), // mostrar estado de cuenta
					'origenDatos':$(xmlInf).find('origenDatos').text(),
					'rutaReportes':$(xmlInf).find('rutaReportes').text(),
					'rutaImgReportes':$(xmlInf).find('rutaImgReportes').text(),
					'logoCtePantalla':$(xmlInf).find('logoCtePantalla').text(),
					'mostrarPrefijo':$(xmlInf).find('mostrarPrefijo').text(),
					'funcionHuella':$(xmlInf).find('funcionHuella').text(), // mostrar validaciones por huella
					'cambiaPromotor':$(xmlInf).find('cambiaPromotor').text(), // mostrar validaciones por Cambio de Promotor
					'tipoImpresoraTicket':$(xmlInf).find('tipoImpresoraTicket').text(), // define el tipo de impresora por socket o applet
					'directorFinanzas':$(xmlInf).find('directorFinanzas').text(),
					'mostrarBtnResumen':$(xmlInf).find('mostrarBtnResumen').text()


				};
			}
	});
	return parSessionBean;
}


function validaTelefono(tel){

	var telefono = eval("'#" + tel + "'");
	var RegExPatternX = new RegExp('^[0-9]{10}$');
	//'^([0-9]{2}-?){2}[0-9]{3}-?[0-9]-?([0-9]{2}-?){2}$'
	var errorMessage = 'Numero de telefono incorrecto';
	if($(telefono).val()!= ''){
		if ($(telefono).val().match(RegExPatternX)) {
		}
		else {
			alert(errorMessage);
			$(telefono).focus();
			$(telefono).select();

		}
	}
}

function convertDate(stringdate)
{
	// Internet Explorer does not like dashes in dates when converting,
	// so lets use a regular expression to get the year, month, and day
	var DateRegex = /([^-]*)-([^-]*)-([^-]*)/;
	var DateRegexResult = stringdate.match(DateRegex);
	var DateResult;
	var StringDateResult = "";

	// try creating a new date in a format that both Firefox and Internet Explorer understand
	try
	{
		DateResult = new Date(DateRegexResult[2]+"/"+DateRegexResult[3]+"/"+DateRegexResult[1]);
	}
	// if there is an error, catch it and try to set the date result using a simple conversion
	catch(err)
	{
		DateResult = new Date(stringdate);
	}

	// format the date properly for viewing
	StringDateResult = (DateResult.getMonth()+1)+"/"+(DateResult.getDate()+1)+"/"+(DateResult.getFullYear());

	return StringDateResult;
}

//Consulta el tiempo del expediente del cliente
function consultaExpedienteCliente(clienteID){
	var expedienteBean = null;
	$.ajax(
		{	type: "GET",
			url: "consultaExpediente.htm",
			data: { clienteID: clienteID },
			dataType: "xml",
        	async: false,
			success: function(xmlInf) {
				expedienteBean = {
  					'clienteID':$(xmlInf).find('clienteID').text(),
  					'fechaExpediente':$(xmlInf).find('fechaExpediente').text(),
  					'tiempo':$(xmlInf).find('tiempo').text()
				};
			}
	});
	return expedienteBean;
}

//Consulta si la persona se encuentra en la lista de pers. bloq.
function consultaListaPersBloq(personaBloqID, tipoPers, cuentaAhoID, creditoID){
	var listaPersBloqBean = null;
	$.ajax(
		{	type: "GET",
			url: "consultaPersBloq.htm",
			data: { personaBloqID	: personaBloqID,
					tipoPers		: tipoPers,
					cuentaAhoID		: cuentaAhoID,
					creditoID		: creditoID },
			dataType: "xml",
        	async: false,
			success: function(xmlInf) {
				listaPersBloqBean = {
  					'estaBloqueado':$(xmlInf).find('estaBloqueado').text(),
  					'coincidencia':$(xmlInf).find('coincidencia').text()
				};
			}
	});
	return listaPersBloqBean;
}

/**
 * @author avelasco
 * Agrega el formato moneda a el valor de una variable, no a un campo
 * @param numero : Monto
 * @returns {String}
 */
function formatoMonedaVariable(numero){
	numero = Number(numero);
	return '$'+(numero.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
}
/**
 * @author pmontero
 * Método que bloquea la pantalla
 */
function bloquearPantalla(){
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message: $('#mensaje'),
		css: {border:		'none',
			background:	'none'}
	});
}

/**
 * @author pmontero
 * Desbloqueo de la pantalla
 */
function desbloquearPantalla(){
	$("#contenedorForma").unblock();
}

/**
 * @author pmontero
 * Agrega formato de error a un elemento
 * @param id : id del elemento
 */
function agregarFormaError(id){
	$(id).addClass("error");
}

/** Valida que el dato sea solo entero, evento keypress
 * @author pmontero
 * @param evento keypress
 * @returns {Boolean} Si es valido o no
 */
function validaSoloNumero(evento){//Recibe al evento
	var key;
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = evento.keyCode;
	} else if(evento.which){//Firefox , Opera Netscape
			key = evento.which;
	}

	 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja
	 	return false;
	 return true;
}

/**
 * Muestra elementos de acuerdo a la etiqueta HTML de class
 * @param idClase : Nombre de la Clase del Elemento a Ocultar
 * @param mostrar : Muestra o no el elemento valor para S:Muestra el elemento o true, cualquier otro valor ocultara el elemento
 * @author pmontero
 */
function mostrarElementoPorClase(idClase,mostrar){
	if(mostrar=='S' || mostrar==true){
		$('.'+idClase).show();
	} else {
		$('.'+idClase).hide();
	}
}

/**
 * Regresa un valor boleano si el control esta deshabilitado o es solo lectura
 * @param idControl ID del control
 * @returns {Boolean}
 */
function estaDeshabilitado(idControl){
	var jqControl = eval("'#" + idControl + "'");
	var eshabilitado=false;
	if($(jqControl).length!=0){
		eshabilitado=$(jqControl).is(':disabled');//Esta deshabilitado
		if(!eshabilitado){
			eshabilitado=$(jqControl).attr('readonly')=="readonly";//Es solo lectura;
		}
		if(!eshabilitado){
			eshabilitado=$(jqControl).attr('readonly');//Es solo lectura;
		}
		if(!eshabilitado){
			eshabilitado=$(jqControl).attr('deshabilitado')=='true';//Esta deshabilitado;
		}
	}
	return eshabilitado;
}

/**
 * Habilita o Deshabilita todos los elementos de la forma excepto botones si estan deshabilitados
 * originalmente no los tomara en cuenta.
 * @param idForma
 * @param deshabilita
 * @returns
 */
function deshabilitarForma(idForma, deshabilita, arrayIDOmitir) {
	var jqForma = eval("'#" + idForma + "'");

	if (deshabilita) {
		$(jqForma).find(':input').each(function() {
			var child = $(this);
			var jControl = eval("'#" + child.attr('id') + "'");
			var tipo=child.attr('type');
			if(tipo!="hidden" && tipo!="button" && tipo!="submit"){
				if (!estaDeshabilitado(child.attr('id')) && (arrayIDOmitir== null || arrayIDOmitir.indexOf(child.attr('id'))==-1)) {
					$(jControl).attr("esDeshabilitado", "true");
					$(jControl).attr("disabled", "disabled");
				}
			}
		});
	} else {
		$(jqForma).find(':input').each(function() {
			var child = $(this);
			var jControl = eval("'#" + child.attr('id') + "'");
			var tipo=child.attr('type');

			if(tipo!="hidden" && tipo!="button" && tipo!="submit"){
				if (estaDeshabilitado(child.attr('id'))) {
					$(jControl).removeAttr("esDeshabilitado");
					$(jControl).removeAttr("disabled");
				}
			}
		});
	}
}
function existeValorSelect(controlID, valor){
	var existe = false;
	$("#"+controlID+" >option").each(function(){
		if(!existe){
			if ($(this).val() === valor ){
				existe = true;
			} else {
				existe = false;
			}
		}
	});
	return existe;
}
function primerValorSelect(controlID){
	var valor = false;
	$("#"+controlID+" >option").each(function(index){
		if(index==0){
			valor = $(this).val();
		}
	});
	return valor;
}
/**
 * Función para limpiar todos los campos de pantalla, esta funcion desmarca todos los radiobutton y checkbox
 * @param idformaGenerica Id del form
 * @param limpiaHiddens True: Limpia tambien los campos de tipo hidden
 * @param arrayIDOmitir Array de id de campos a omitir en la limpieza ej.['numCliente', 'nombreCliente', 'sucursalID', 'nombreSucursal']
 * @author pmontero
 */
function limpiaFormaCompleta(idformaGenerica,limpiaHiddens,arrayIDOmitir){
	var jqForma = eval("'#" + idformaGenerica + "'");
	$(jqForma).find(':input').each(function() {
		var child = $(this);
		var jControl = eval("'#" + child.attr('id') + "'");
		var tipo=child.attr('type');
		var continuarLimpia=true;

		if(tipo=="button" || tipo=="submit"){
			continuarLimpia=false;
		}

		if(tipo=="hidden" && limpiaHiddens ==false){
			continuarLimpia = false;
		}

		if(continuarLimpia && (arrayIDOmitir== null || arrayIDOmitir.indexOf(child.attr('id'))==-1)){
			if(tipo=="checkbox" || tipo=="radio"){
				$(jControl).attr("checked",false);
			} else if(tipo=="select-one"){
				$(jControl).val(primerValorSelect(child.attr('id')));
			} else {
				$(jControl).val("");
			}
		}
	});
}

function consultaPaisesGAFI(paisesBean,arrayIDBotones) {
	var PairNoCooperante = "N"; // Paises No Cooperantes
	var PaisEnMejora = "M"; //Paises en Mejora
	paisesGAFIPLDServicio.consultaPaisesGAFI(paisesBean, { async:false,
	callback : function(pais) {
		if (pais != null) {
			if (pais.estaEnCatalogo == "S" && pais.tipoPais == PairNoCooperante) {
				mensajeSis("El País "+pais.nombre+" Se encontró en los paises No Cooperantes GAFI");
				for(var i=0;i<arrayIDBotones.length;i++){
					deshabilitaBoton(arrayIDBotones[i], 'submit');
				}
				return false;
			} else {
				return true;
			}
		}
	},
	errorHandler : function(message) {
		mensajeSis("Error en Consulta Paises GAFI. ");
		return false;
	}
	});

	return true;
}
/**
 * Función que evitar el autocompletado en un input, debido a que la propiedad autocomplete="off" no siempre funciona en todos los
 * navegadores. Para su buen funcionamiento se deberá agregar en el jsp la propiedad readonly.
 * Ejem.: <input id="contraseniaAutoriza" name="contraseniaAutoriza" readonly onfocus="evitaAutocompletado(this);" ...
 * @param control : el input (this).
 * @author avelasco pmontero
 */
function evitaAutocompletado(control) {
	if (control.hasAttribute('readonly')) {
		control.removeAttribute('readonly');
		// fix for mobile safari to show virtual keyboard
		control.blur();
		control.focus();
	}
}

/**
 * Funcion para mostrar/ocultar la leyenda en el label para  la tasa variable (Creditos-Simulador)
 * @param idCalculoInteres : id del control del input type select del tipo de calculo de interes
 * @author pmontero
 */
function muestraDescTasaVar(idCalculoInteres) {
	if(idCalculoInteres!="" && $( "#"+idCalculoInteres).length ){
		var leyendaTasaVariable = "* Los montos están sujetos a la variación de la tasa.";
		// Si se trata de un calculo de intereses por tasa fija se oculta la descripcion
		if ($('#' + idCalculoInteres).val() == TasaFijaID) {
			$('td[name=tdTasaVariable]').hide();
		} else { // En cualquier otro caso se muestra
			if ($('#' + idCalculoInteres).val() == TasaBasePisoTecho) {
				leyendaTasaVariable = leyendaTasaVariable + " Con piso del " + $('#pisoTasa').val().trim() + "% y techo del " + $('#techoTasa').val().trim() + "%.";
			}
			$('#lblTasaVariable').text(leyendaTasaVariable);
			$('td[name=tdTasaVariable]').show();
		}
	}
}

function mostrarAlertaExpiraDocs() {
	var tipoCon = 1;
	var ParametrosSisBean = {
		'empresaID' : 1
	};
	var parametroBean = consultaParametrosSession();
	var numeroUsuario = parametroBean.numeroUsuario;
	var sucursalCliente = 0;

	parametrosSisServicio.consulta(tipoCon, ParametrosSisBean, function(parametrosSisBean) {
		if (parametrosSisBean != null) {
			var oficial = parametrosSisBean.oficialCumID;
			if (Number(oficial) == Number(numeroUsuario)) {
				sucursalCliente = 0;
			} else {
				sucursalCliente = parametroBean.sucursal;
			}
			var bean = {
			'sucursal' : sucursalCliente,
			'usuario' : numeroUsuario
			};
			alertNotificacionesServicio.alertaExpiraDocs(1, bean, function(alerta) {
				if (alerta != null) {
					if (alerta.numero != 0) {
						var mensajeNoticacion = '<div class="alertInfoRetro" id="alertInfoRetro"><div class="cabecera" ><span id="safiTxtCabecera">Mensaje:</span>' + '<span id="btnAlertCerrar">X</span><div class="clearfix"></div></div>' + '  <div class="contenido" id="mensajeContenido"></div>' + '</div> ';
						$('body').block({
						message : mensajeNoticacion,
						css : {
						border : 'none',
						background : 'none'
						}
						});
						$("#btnAlertCerrar").click(function() {
							$.unblockUI();
						});
						$('#mensajeContenido').html(alerta.descripcion);
						$('body').keydown(function(e) {
							if (e.keyCode == keysSAFI.ENTER) {
									$('body').unblock();
							}
						});
					}
				}
			});
		}
	});
}

function alertaCte(clienteID, idControl) {
	var bean = {
	'clienteID' : clienteID
	};
	alertNotificacionesServicio.alertaExpiraDocs(2, bean,{asyn:false, callback:function(alerta) {
		if (alerta != null) {
			if (alerta.numero != 0) {
				var mensajeNoticacion = '<div class="alertInfoRetro" id="alertInfoRetro"><div class="cabecera" ><span id="safiTxtCabecera">Mensaje:</span>' + '<span id="btnAlertCerrar">X</span><div class="clearfix"></div></div>' + '  <div class="contenido" id="mensajeContenido"></div>' + '</div> ';
				$('body').block({
				message : mensajeNoticacion,
				css : {
				border : 'none',
				background : 'none'
				}
				});
				$("#btnAlertCerrar").click(function() {
					$.unblockUI();
				});
				$('#mensajeContenido').html(alerta.descripcion);
				$('body').keydown(function(e) {
					if (e.keyCode == keysSAFI.ENTER) {
							$('body').unblock();
					}
				});
				return alerta.numero;//999 no dejara continuar la operacion
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	}, errorHandler : function(message) {
		return 0;
	}
	});
}

function cargarCuestionarioPLD(clienteID){
	$('#Contenedor').load('identidadCliente.htm',function(response, status, xhr){
		if(status == 'error') {
			$('#Contenedor').html(response);
		}
		$("#clienteID").val(clienteID);
	});
	$.unblockUI();

}

function descripcionEstatus(value, idControl) {
	var valorDes = '';
	switch (value) {
		case 'A' :
			valorDes = 'AUTORIZADO';
			break;
		case 'I' :
			valorDes = 'INACTIVO';
			break;
		case 'P' :
			valorDes = 'PAGADO';
			break;
		case 'V' :
			valorDes = 'VIGENTE';
			break;
		case 'K' :
			valorDes = 'CASTIGADO';
			break;
		case 'D' :
			valorDes = 'DESEMBOLSADO';
			break;
		case 'M' :
			valorDes = 'AUTORIZADO';
			break;
		case 'B' :
			valorDes = 'VENCIDO';
			break;
		case 'C' :
			valorDes = 'CANCELADO';
			break;
	};
	if (idControl != null && idControl != undefined) {
		$("#" + idControl).val(valorDes);
	}
	return valorDes;
}


function importarScriptSAFI(nombre) {
    var s = document.createElement("script");
    s.setAttribute("type", "text/javascript");
    s.setAttribute("src",nombre);
    document.getElementsByTagName("head")[0].appendChild(s);
}
/**
 * Genera un link externo para mostrarlo en un mensajeSis().
 * @param tituloLiga nombre del título a mostrar en la liga. Por ejemplo: Registro de Clientes.
 * @param vistaHTML nombre de la vista html. Por ejemplo: catalogoCliente.htm.
 * @returns {String} liga generada.
 * @autor pmontero
 */
function cargaLinkExterno(tituloLiga, vistaHTML){
	var liga =
		"<b> " +
		"<a onclick=\"$('#Contenedor').load('"+vistaHTML+"',function(response, status, xhr){ " +
			"if(status == 'error'){ " +
				"$('#Contenedor').html(response); " +
			"} " +
		"}); " +
		"consultaSesion();\"> " + tituloLiga +
		"<img src=\"images/external.png\"></a></b> ";
	return liga;
}

function limpiarCaracterEscape(control, tamanioCampo) {
	var jqControl = eval("'#" + control + "'");
	var texto = $(jqControl).val();
	texto = texto.trim();
	texto = texto.replace(/[\n\r\t\f\b]/g, " ");
	texto = texto.replace(/^\s+|\s+$|\s+(?=\s)/g, "");
	$(jqControl).val(texto.slice(0, tamanioCampo));
}

function cargaValorListaParticipante(control,  valor, controlTipoPersona, valorTipoPersona) {
	consultaSesion();
	// Creacion de controles
	jqControl = eval("'#" + control + "'");
	jqcontrolTipoPersona = eval("'#" + controlTipoPersona + "'");

	var persona = '';

	switch(valorTipoPersona){
		case 'CLIENTE':
			persona = 'C';
		break;
		case 'PROSPECTO':
			persona = 'P';
		break;
		default:
			persona = 'C';
		break;
	}

	// Asignacion de controles
	$(jqControl).val(valor);
	$(jqcontrolTipoPersona).val(persona);
	$(jqControl).focus();

	setTimeout("$('#cajaLista').hide();", 200);
}

function cargaValorListaGrdVal(control,  valor, controlArchivo, valorArchivo) {
	consultaSesion();
	// Creacion de controles
	jqControl = eval("'#" + control + "'");
	jqControlArchivo = eval("'#" + controlArchivo + "'");

	// Asignacion de controles
	$(jqControl).val(valor);
	$(jqControlArchivo).val(valorArchivo);
	$(jqControl).focus();

	setTimeout("$('#cajaLista').hide();", 200);
}

function limpiarCajaTexto(control){
	// Creacion de controles
	var jqControl = eval("'#" + control + "'");
	var texto = $(jqControl).val();
	var longitud = document.getElementById(control).maxLength;

	if(longitud <= 0){
		longitud = 100;
	}

	texto = texto.replace(/[\n\r\t\f\b]/g, " ");
	$(jqControl).val(texto.slice(0, longitud));
}


function listaCredito(controlId, minCaracteres, tipoListaVal, campoLista, parametroLista, vista) {
	var jqControl = eval("'#" + controlId + "'");
	var position = $(jqControl).position();
	var valorListar = $(jqControl).val();
	consultaSesion();
	var params = {};
	if (document.activeElement.id) {
		if (document.activeElement.id == controlId) {
			if (numLetrasSAFI == $(jqControl).val().length) {
				return false;
			} else {
				numLetrasSAFI = $(jqControl).val().length;
			}
		}
	}

	if ($(jqControl).val().length <= minCaracteres) {
		$('#cajaLista').hide();
	} else {
		//Si la Variable de CampoLista es un Arreglo
		if ((typeof campoLista == 'object') && campoLista.length != null) {
			for (i = 0; i < campoLista.length; i++) {
				params[campoLista[i]] = parametroLista[i];
			}
		} else {
			params[campoLista] = parametroLista;
		}

		params['controlID'] = controlId;
		params['tipoLista'] = tipoListaVal;
		$('#cajaLista').css({
		position : 'absolute',
		collision : "fit flip"
		});

		$.post(vista, params, function(data) {
			if (data.length > 0) {
				$('#cajaLista').show();
				$('#elementoLista').html(data);
				selectPrimerRegistro('cajaLista');
				posicionamiento(jqControl, 'cajaLista','elementoLista');
			}
		});
	}
}



//Consulta si la persona se tiene permitido  operar si esta en listas de personas bloquedas
function consultaPermiteOperaSPL(numRegistro, listaDeteccion,tipoLista){
	var listaSPLBean = null;
	$.ajax(
		{	type: "GET",
			url: "conPermiteOperacionSPL.htm",
			data: { numRegistro	: numRegistro,
					listaDeteccion		: listaDeteccion,
					tipoLista : tipoLista
					},
			dataType: "xml",
        	async: false,
			success: function(xmlSPL) {
				listaSPLBean = {
  					'opeInusualID':$(xmlSPL).find('opeInusualID').text(),
  					'numRegistro':$(xmlSPL).find('numRegistro').text(),
  					'permiteOperacion':$(xmlSPL).find('permiteOperacion').text(),
  					'fechaDeteccion':$(xmlSPL).find('fechaDeteccion').text()
				};
			}
	});
	return listaSPLBean;
}

/// FUNCION PARA SELECCIONAR TODOS LOS CHECK DE UN GRID
function seleccionarChecks(idControl, idCampoSelectTodos, consecutivoID){
	// idControl = Nombre del campo para hacer el ciclo
	// idCampoSelectTodos = ID del campo que al hacer clic seleccionara todos los demas columnas
	// consecutivoID = consecutivo del GRID

	if(consecutivoID>0){
		var tamanio = idControl.length;
		var totalReg = $('input[name='+idControl+']').length;
		var consecutivoFor = 0;
		var contadorCheck = 0;

		$('input[name='+idControl+']').each(function(){
			evalJQ=eval("'#"+this.id+"'");
			consecutivoFor = evalJQ.substring(tamanio+1);

			if ($(this).is(':checked')) {
				contadorCheck++;
				$(evalJQ).val("S");
			}else{
				contadorCheck--;
				$(evalJQ).val("N");
			}
			if(totalReg==consecutivoFor && totalReg!= contadorCheck){
				$('#'+idCampoSelectTodos).removeAttr("checked");
			}
			if(totalReg==consecutivoFor && totalReg == contadorCheck){
				$('#'+idCampoSelectTodos).attr("checked","checked");
			}
		});

	}else{
		$('input[name='+idControl+']').each(function(){
			evalJQ=eval("'#"+this.id+"'");
			if($('#'+idCampoSelectTodos).is(':checked')){
				$(evalJQ).attr("checked","checked");
				$(evalJQ).val("S");
			}else{
				$(evalJQ).removeAttr("checked");
				$(evalJQ).val("N");

			}
		});
	}
}


//FUNCION PARA VALIDAR VACIO DE UN GRID
function validaCamposVaciosGrid(lcamposValida, validaCheck, idControlCheck, separador){
	// lcamposValida = ID'S CONTROL DE LOS CAMPOS A CALIDAR SI ESTAN VACIOS
	// validaCheck	= Indica si valida un check S.-SI, N.-NO
	// idControlCheck = Control del campo tipo CHECK
	// separador = Separador de los campos a validar 'lcamposValida'
	var arrayDeCadenas = lcamposValida.split(separador);
	var control	= 0;
	var i = 0;
	var controlAuxiliar = "";
	var element = "";
	for(var x=0; x < arrayDeCadenas.length; x++) {
		control = arrayDeCadenas[x];
		if(controlAuxiliar!=control){
			i ++;
			controlAuxiliar = control;
			element = document.getElementById(control+(i));
			var elementType =element.tagName;

			var contador = 0;
			$(elementType+'[name='+control+']').each(function(){
				evalJQ=eval("'#"+this.id+"'");
				var tamanio = control.length;
				var consecutivo = evalJQ.substring(tamanio+1);
				var totalReg = $(elementType+'[name='+control+']').length;
				if(consecutivo == totalReg){
					i = 0;
				}
				if(validaCheck=="S"){
					if($("#"+idControlCheck+consecutivo).is(':checked') && ($(evalJQ).val()=='' || $(evalJQ).val()=='0')){
						mensajeSis("Existe campos vacios");
						$(evalJQ).select();
						$(evalJQ).focus();
						return false;
					}else{
						if($("#"+idControlCheck+consecutivo).is(':checked')){
							contador --;
						}else{
							contador ++;
						}
					}
					if(consecutivo == totalReg && contador==totalReg){
						mensajeSis("Favor de selecionar la información que desea procesada.");
						$("#"+control+1).select();
						$("#"+control+1).focus();
					}
				}else{
					if($(evalJQ).val()=='' || $(evalJQ).val()=='0'){
						mensajeSis("Existe campos vacios");
						$(evalJQ).select();
						$(evalJQ).focus();
						return false;
					}
				}
			});
		}

	}
}

// FUNCION PARA SELECCIONAR CHECKS
function seleccionarChecks(idControl, idCampoSelectTodos, consecutivoID, campoAuxiliarCheck){
	// idControl = Nombre del campo para hacer el ciclo
	// idCampoSelectTodos = ID del campo que al hacer clic seleccionara todos los demas columnas
	// consecutivoID = consecutivo del GRID

	if(consecutivoID>0){
		var tamanio = idControl.length;
		var totalReg = $('input[name='+idControl+']').length;
		var consecutivoFor = 0;
		var contadorCheck = 0;

		$('input[name='+idControl+']').each(function(){
			evalJQ=eval("'#"+this.id+"'");
			var consecutivo = $(evalJQ).attr("numReg");

			consecutivoFor = evalJQ.substring(tamanio+1);
			if ($(this).is(':checked')) {
				contadorCheck++;
				$("#"+campoAuxiliarCheck+consecutivo).val("S");
			}else{
				contadorCheck--;
				$("#"+campoAuxiliarCheck+consecutivo).val("N");
			}

			if(totalReg==consecutivoFor && totalReg!= contadorCheck){
				$('#'+idCampoSelectTodos).removeAttr("checked");
			}
			if(totalReg==consecutivoFor && totalReg == contadorCheck){
				$('#'+idCampoSelectTodos).attr("checked","checked");
			}
		});

	}else{
		$('input[name='+idControl+']').each(function(){
			evalJQ=eval("'#"+this.id+"'");
			var consecutivo = $(evalJQ).attr("numReg");
			if($('#'+idCampoSelectTodos).is(':checked')){
				$(evalJQ).attr("checked","checked");
				$("#"+campoAuxiliarCheck+consecutivo).val("S");
			}else{
				$(evalJQ).removeAttr("checked");
				$("#lseleccionadoCheck"+consecutivo).val("N");
			}
		});
	}
}


//FUNCION PARA LIMPIAR GRID
function limpiaGrid(idDiv, ocultaGrid){
	// idDiv =ID del DIV donde se encuetra el grid a LIMPIAR
	// ocultaGrid = S.-SI OCULTA N.-NO OCULTA
	$('#'+idDiv).html("");
	if(ocultaGrid=="S"){
		$('#'+idDiv).hide();
	}

}

// FUNCION PARA INICIALIZAR EL CANDADO, CONSIDERANDO B.-BLOQUEADO D.-DESBLOQUEDO
function inicializaImgCandado(idTabla, checkNameSelect, buttonEstatus){
	// idTabla= ID de la tabla donde se encuentra el grid
	// checkNameSelect= nombre del checkbox del GRID
	// buttonEstatus= nombre del INPUT-TEXT del GRID
	$('#'+idTabla+' tr').each(function(index){
		if(index>0){
			var seleccionado = "#"+$(this).find("input:checkbox	[name^='"+checkNameSelect+"']").attr("id");
			var bloqBoton = "#"+$(this).find("input:button[name^='"+buttonEstatus+"']").attr("id");
			var estaSelecionado = $(seleccionado).val().trim();
			if(estaSelecionado=="D"){
				$(seleccionado).attr('checked', true);
				estiloDesbloqueado(bloqBoton, checkNameSelect);
			} else {
				$(seleccionado).attr('checked', false);
				estiloBloqueado(bloqBoton, checkNameSelect);
			}
		}
	});
}

// FUNCION PARA DESBLOQUEAR O BLOQUEAR
function accionImgCandado(idTabla, checkNameSelect, buttonEstatus, idCampo, idDivGrid){
	// idTabla= ID de la tabla donde se encuentra el grid
	// checkNameSelect= nombre del checkbox del GRID
	// buttonEstatus= nombre del INPUT-TEXT del GRID
	// idCampo = ID consicutivo del GRID para desbloquear y bloquear los desmas datos del GRID
	// idDivGrid = ID del DIV a limpiar
	var numcaracter = parseInt(buttonEstatus.length)+1;
	var totalReg = $('input[name='+checkNameSelect+']').length;
	$('#'+idTabla+' tr').each(function(index){
		if(index>0){
			var seleccionado = "#"+$(this).find("input:checkbox	[name^='"+checkNameSelect+"']").attr("id");
			var bloqBoton = "#"+$(this).find("input:button[name^='"+buttonEstatus+"']").attr("id");
			var IDConsecutivo = bloqBoton.substring(numcaracter);
			var estaSelecionado = $(seleccionado).val().trim();
			var contadorB = 0;
			if(idCampo==IDConsecutivo && estaSelecionado=="B"){
				$(seleccionado).attr('checked', true);
				$(seleccionado).val("D");
				estiloDesbloqueado(bloqBoton, checkNameSelect);

			}else{
				$(seleccionado).attr('checked', false);
				$(seleccionado).val("B");
				estiloBloqueado(bloqBoton, checkNameSelect);
				contadorB ++;
			}

			if(totalReg==IDConsecutivo && contadorB==totalReg){
				limpiaGrid(idDivGrid,"S");
			}
		}
	});

}

// FUNCION DE ESTILO PARA DESBLOQUEO
function estiloDesbloqueado(idControl, checkNameSelect){
	// idControl= id DEL CAMPO A DESBLOQUEAR
	// checkNameSelect= ID de checkbox para cambiar el estatus a DESBLOQUEADO
	habilitaControl(checkNameSelect);
	$(idControl).css({'background' :'url(images/unlock.png) no-repeat '});
	$(idControl).css({'border' :' none'});
	$(idControl).css({'width' :' 21px'});
	$(idControl).css({'height' :' 21px'});
	$(checkNameSelect).val("D");
}

// FUNCION DE ESTILO PARA BLOQUEO
function estiloBloqueado(idControl, checkNameSelect){
	// idControl= id DEL CAMPO A DESBLOQUEAR
	// checkNameSelect= ID de checkbox para cambiar el estatus a BLOQUEADO
	$(idControl).removeAttr('checked');
	deshabilitaControl(checkNameSelect);
	$(idControl).css({'background' :'url(images/lock.png) no-repeat '});
	$(idControl).css({'border' :' none'});
	$(idControl).css({'width' :' 21px'});
	$(idControl).css({'height' :' 21px'});
	$(idControl).val("B");
}

