var tipoLista = {
	'principal' : 1
};

$(document).ready(function() {

	esTab = false;
	inicializaPantalla();

	var transaccion = {
		'actualizar' : 1
	};

	/**************************************************************************************************/
	/***************************** FUNCION QUE CARGAN AL INICIAR PANTALLA ******************************/
	$("#valorEmisorID").focus();

	/**************************************************************************************************/
	/*********************************** VALIDACIONES DE LA FORMA *************************************/
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','correoAutWS','funcionExito', 'funcionError');
		}
	});

	/**************************************************************************************************/
	/***************************************** MANEJO DE EVENTOS **************************************/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	/**************************************************************************************************/
	$("#guardar").click(function(event) {
		var numeroMaximoPermitido = 2147483647;
		event.preventDefault();
		$("#tipoTransaccion").val(transaccion.actualizar);
		$("#tipoActualizacion").val(transaccion.actualizar);

		var valorEmisorID = $("#valorEmisorID").val();
		var valorPrefijoEmisor = $("#valorPrefijoEmisor").val();
		var expresionRegular = /^([0-9,%])*$/;

		if (!expresionRegular.test(valorEmisorID)){
			mensajeSis("El ID de Emisor solo acepta Números.");
			$("#valorEmisorID").focus();
			return;
		}
		if(valorEmisorID == ""){
			mensajeSis("Especifique el ID Emisor.");
			$("#valorEmisorID").focus();
			return;
		}
		if(valorEmisorID > numeroMaximoPermitido){
			mensajeSis("El valor Maximo soportado por el Proveedor es de <b>2147483647</b>");
			$("#valorEmisorID").focus();
			return;
		}
		if(valorPrefijoEmisor == ""){
			mensajeSis("Especifique el Prefijo Emisior.");
			$("#valorPrefijoEmisor").focus();
			return;
		}

		//Se envia el formulario
		$('#formaGenerica').submit();
	});

	/**************************************************************************************************/
	$('#formaGenerica').validate({
		rules: {
		},
		messages: {
		}
	});

});


/************************************* FIN $(DOCUMENT).READY() ************************************/
/**************************************************************************************************/
function consultaParametros(){
	paramTarjetasServicio.lista(tipoLista.principal, {}, function(datos){
		if(datos != '' && datos != null){
			for(var i = 0; i < datos.length; i++) {
				var parametros = datos[i];
				if( parametros.llaveParametro == 'IDEmisor' ) {
					$('#llaveEmisorID').val(parametros.llaveParametro);
					$('#valorEmisorID').val(parametros.valorParametro);
				}
				if( parametros.llaveParametro == 'PrefijoEmisor' ) {
					$('#llavePrefijoEmisor').val(parametros.llaveParametro);
					$('#valorPrefijoEmisor').val(parametros.valorParametro);
				}
			}
		}
	});
}


/**************************************************************************************************/
function funcionExito() {
	inicializaPantalla();
}

/******************************** FUNCIÓN DE ERROR DE LA TRANSACCIÓN ******************************/
/**************************************************************************************************/
function funcionError() {
	agregaFormatoControles('formaGenerica');
}

/************************************** FUNCION INICIALIZA PANTALLA *******************************/
function inicializaPantalla(){
	inicializaForma('formaGenerica','tipo');
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	$("#companiaID").val(parametroBean.nombreInstitucion);
	consultaParametros();
	deshabilitaControl('companiaID');
}