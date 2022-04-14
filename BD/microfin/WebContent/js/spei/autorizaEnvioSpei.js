	$(document).ready(function() {
		esTab = true;
		var tab2=false;

		var parametrosBean = consultaParametrosSession();
		$('#fecha').val(parametroBean.fechaSucursal);
		$('#usuarioVerifica').val(parametroBean.numeroUsuario);
		deshabilitaBoton('procesar');
		agregaFormatoControles('formaGenerica');

		//Definicion de Constantes y Enums
		var catTipoTransaccion = {
				'procesar':'9',



		};

		//------------ Metodos y Manejo de Eventos -----------------------------------------
		deshabilitaBoton('autorizar');
		$('#tipoBusqueda').focus();
		origenesSpeiCombo();

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
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','false',
						'funcionExitoAutoriza','funcionErrorAutoriza');


			}
		});

		$('#procesar').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccion.procesar);
			guardarDatosAutoriza();

		});

		$('#buscar').click(function() {
			if ($('#tipoBusqueda').val() == '') {
				deshabilitaBoton('procesar', 'submit');
				$('#gridAutorizaEnvioSPEI').html("");
				$('#gridAutorizaEnvioSPEI').hide();
				mensajeSis("Seleccionar un Tipo de Búsqueda.");
				$('#tipoBusqueda').focus();
			}else{
				consultaSpeiPendiente();
				$('#montoAurotizar').val('0.00');
				$('#cantAurotizar').val('0');
			}

		});


		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {

			},
			messages: {


			}
		});



		//------------ Validaciones de Controles -------------------------------------


	});

	// funcion para consultar spei con estatus autorizado
	function consultaSpeiPendiente(){

		var params = {};
		params['tipoBusqueda'] = $('#tipoBusqueda').val();
		params['tipoLista'] = 3;
		$.post("gridAutorizaEnvio.htm", params, function(data){

			if(data.length >0) {
				agregaFormatoControles('gridAutorizaEnvioSPEI');
				$('#gridAutorizaEnvioSPEI').html(data);
				$('#gridAutorizaEnvioSPEI').show();
				if($('#folioSpeiID1').val() == undefined ){
					mensajeSis("No Existen Transferencias SPEI por Verificar.");

				}

			}else{
				$('#gridAutorizaEnvioSPEI').html("");
				$('#gridAutorizaEnvioSPEI').hide();
				mensajeSis("No Existen Transferencias SPEI por Verificar.");

			}
		});

	}


	function consultaSpeiPendienteExito(){

		var params = {};
		params['tipoLista'] = 3;
		$.post("gridAutorizaEnvio.htm", params, function(data){

			if(data.length >0) {
				agregaFormatoControles('gridAutorizaEnvioSPEI');
				$('#gridAutorizaEnvioSPEI').html(data);
				$('#gridAutorizaEnvioSPEI').show();

			}else{
				$('#gridAutorizaEnvioSPEI').html("");
				$('#gridAutorizaEnvioSPEI').hide();
				mensajeSis("No Existen Transferencias SPEI por Verificar.");

			}
		});

	}



	function guardarDatosAutoriza(){

		var numCodigo = $('input[name=consecutivoID]').length;
		$('#datosGrid').val("");

		for(var i = 1; i <= numCodigo; i++){

			if($('#'+"enviar"+i+"").attr('checked')==true){

				if(i == 1){

					$('#datosGrid').val($('#datosGrid').val() +
							document.getElementById("usuarioVerifica").value + ']' +
							document.getElementById("folioSpeiID"+i+"").value + ']' +
							document.getElementById("claveRastreo"+i+"").value + ']' +
							document.getElementById("cuentaOrd"+i+"").value + ']' +
							document.getElementById("cuentaBeneficiario"+i+"").value + ']' +
							document.getElementById("nombreBeneficiario"+i+"").value + ']' +
							document.getElementById("monto"+i+"").value);

				}else{
					$('#datosGrid').val($('#datosGrid').val() + '[' +
							document.getElementById("usuarioVerifica").value + ']' +
							document.getElementById("folioSpeiID"+i+"").value + ']' +
							document.getElementById("claveRastreo"+i+"").value + ']' +
							document.getElementById("cuentaOrd"+i+"").value + ']' +
							document.getElementById("cuentaBeneficiario"+i+"").value + ']' +
							document.getElementById("nombreBeneficiario"+i+"").value + ']' +
							document.getElementById("monto"+i+"").value);

				}
			}
		}

	}

	//valida que exista comentario en caso de cancelacion
	function validaComentario(){

		var numCodigo = $('input[name=consecutivoID]').length;
		var error = 0;
		for(var i = 1; i <= numCodigo; i++){

			if($('#'+"enviar"+i+"").attr('checked')==true){
				var jsCometario = document.getElementById("comentario"+i+"").value;
				if (jsCometario == ''){
					mensajeSis("Especificar Comentario.");
					$('#comentario'+i).focus();
					error = 1;

				}
			}

			if(error != 0){
				return 1;
			}

		}

	}


	//seleccion todos los checkouts
	function selecTodoCheckout(idControl){
		var jqSelec  = eval("'#" + idControl + "'");
		var cont = 0;

		if ($(jqSelec).is(':checked')){
			$('input[name=enviar]').each(function () {
				$(this).attr('checked', 'true');
				cont ++;
			});
		}else {
			$('input[name=enviar]').each(function () {
				$(this).removeAttr('checked');
			});
		}
		if (cont != 0) {
			habilitaBoton('procesar');
		}else{
			deshabilitaBoton('procesar');

		}
	}


	//habilita/ deshabilita botones
	function habilitaLimpiar(idControl){
		var cont = 0;
		var numReg = ($('#miTabla >tbody >tr').length) - 1;

		$('input[name=enviar]').each(function () {
			if ($(this).is(':checked')){
				cont ++;
			}
		});
		if (cont == numReg) {
			$('#seleccionaTodos').attr('checked', 'true');
		}else {
			$('#seleccionaTodos').removeAttr('checked');
		}
		if (cont > 0 ) {
			habilitaBoton('procesar');

		}else{
			deshabilitaBoton('procesar');

		}
	}


	// suma el total de los montos seleccionados
	function sumaMonto(){
		var numCodigo = $('input[name=consecutivoID]').length;
		var cont = 0;
		var montoTotal = 0;
		for(var i = 1; i <= numCodigo; i++){
			if($('#'+"enviar"+i+"").attr('checked')==true){
				var jsMonto = $('#'+"monto"+i+"").asNumber();
				montoTotal = parseInt(montoTotal) + parseInt(jsMonto);
				cont ++;
				$('#montoAurotizar').val(montoTotal);
				$('#cantAurotizar').val(cont);
				$('#montoAurotizar').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
			}
		}
		if(cont < 1){
			$('#montoAurotizar').val('0.00');
			$('#cantAurotizar').val('0');
		}

	}

	// sula el total de los montos seleccionados
	function checkTodosSumaMonto(){
		var numCodigo = $('input[name=consecutivoID]').length;
		var cont = 0;
		var montoTotal =0;
		for(var i = 1; i <= numCodigo; i++){
			if($('#seleccionaTodos').attr('checked')==true){
				var jsMonto = $('#'+"monto"+i+"").asNumber();
				montoTotal = parseFloat(montoTotal) + parseFloat(jsMonto);
				cont ++;
				$('#montoAurotizar').val(montoTotal);
				$('#cantAurotizar').val(cont);
				$('#montoAurotizar').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});

			}else{
				$('#montoAurotizar').val('0.00');
				$('#cantAurotizar').val('0');

			}
		}
	}



	function funcionExitoAutoriza (){
		consultaSpeiPendienteExito();
		deshabilitaBoton('procesar');
		$('#montoAurotizar').val('0.00');
		$('#cantAurotizar').val('0');

	}

	function funcionErrorAutoriza (){
		deshabilitaBoton('procesar');


	}

	function origenesSpeiCombo(){
		dwr.util.removeAllOptions('tipoBusqueda');
		origenesSpeiServicio.lista(1,function(origenesBean){
			dwr.util.addOptions('tipoBusqueda', {'':'SELECCIONAR'});
			dwr.util.addOptions('tipoBusqueda', origenesBean, 'origenSpeiID', 'nombreCompleto');
		});
	}