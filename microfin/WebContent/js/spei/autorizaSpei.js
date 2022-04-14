	$(document).ready(function() {
		esTab = true;
		var tab2=false;

		var parametrosBean = consultaParametrosSession();
		$('#fecha').val(parametroBean.fechaSucursal);
		$('#usuarioVerifica').val(parametroBean.numeroUsuario);

		//Definicion de Constantes y Enums
		var catTipoTransaccion = {
				'autorizar':'7',
				'cancelar':'8',


		};

		//------------ Metodos y Manejo de Eventos -----------------------------------------
		deshabilitaBoton('autorizar');
		deshabilitaBoton('cancelar');




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
				var transaccion = $('#tipoTransaccion').val();
				if(transaccion == '8'){
					var validar = guardarDatosCancela();
					if(validar != 1){
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','false',
								'funcionExitoAutoriza','funcionErrorAutoriza');

					}
				}else{
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','false',
							'funcionExitoAutoriza','funcionErrorAutoriza');
				}

			}
		});

		$('#autorizar').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccion.autorizar);
			guardarDatosAutoriza();

		});

		$('#cancelar').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccion.cancelar);

		});-

		consultaSpeiPendiente();

		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {

			},
			messages: {


			}
		});



		//------------ Validaciones de Controles -------------------------------------


	});

	// funcion para consultar spei pendientes
	function consultaSpeiPendiente(){

		var params = {};
		params['tipoLista'] = 1;
		$.post("gridAutorizaSpei.htm", params, function(data){

			if(data.length >0) {
				agregaFormatoControles('gridAutorizaSPEI');
				$('#gridAutorizaSPEI').html(data);
				$('#gridAutorizaSPEI').show();

				if($('#folioSpeiID1').val() == undefined ){
					mensajeSis("No Existen Transferencias SPEI Pendientes.");

				}
			}else{
				$('#gridAutorizaSPEI').html("");
				$('#gridAutorizaSPEI').hide();
				mensajeSis("No Existen Transferencias SPEI Pendientes.");

			}
		});

	}

	// funcion para consultar spei pendientes
	function consultaSpeiPendienteExito(){

		var params = {};
		params['tipoLista'] = 1;
		$.post("gridAutorizaSpei.htm", params, function(data){

			if(data.length >0) {
				agregaFormatoControles('gridAutorizaSPEI');
				$('#gridAutorizaSPEI').html(data);
				$('#gridAutorizaSPEI').show();

			}else{
				$('#gridAutorizaSPEI').html("");
				$('#gridAutorizaSPEI').hide();
				mensajeSis("No Existen Transferencias SPEI Pendientes.");

			}
		});

	}


	function guardarDatosAutoriza(){

		var numCodigo = $('input[name=consecutivoID]').length;
		$('#datosGrid').val("");

		for(var i = 1; i <= numCodigo; i++){

			if($('#'+"enviar"+i+"").attr('checked')==true){

				if($('#'+"comentario"+i+"").val() == ''){
					$('#'+"comentario"+i+"").val('SIN COMENTARIO');
				}

				if(i == 1){

					$('#datosGrid').val($('#datosGrid').val() +
							document.getElementById("usuarioVerifica").value + ']' +
							document.getElementById("folioSpeiID"+i+"").value + ']' +
							document.getElementById("claveRastreo"+i+"").value + ']' +
							document.getElementById("clienteID"+i+"").value + ']' +
							document.getElementById("comentario"+i+"").value);


				}else{
					$('#datosGrid').val($('#datosGrid').val() + '[' +
							document.getElementById("usuarioVerifica").value + ']' +
							document.getElementById("folioSpeiID"+i+"").value + ']' +
							document.getElementById("claveRastreo"+i+"").value + ']' +
							document.getElementById("clienteID"+i+"").value + ']' +
							document.getElementById("comentario"+i+"").value);

				}
			}
		}

	}



	function guardarDatosCancela(){

		var validado = validaComentario();
		if(validado!=1){
			var numCodigo = $('input[name=consecutivoID]').length;
			$('#datosGrid').val("");

			for(var i = 1; i <= numCodigo; i++){

				if($('#'+"enviar"+i+"").attr('checked')==true){
					if(i == 1){

						$('#datosGrid').val($('#datosGrid').val() +
								document.getElementById("usuarioVerifica").value + ']' +
								document.getElementById("folioSpeiID"+i+"").value + ']' +
								document.getElementById("claveRastreo"+i+"").value + ']' +
								document.getElementById("clienteID"+i+"").value + ']' +
								document.getElementById("comentario"+i+"").value);


					}else{
						$('#datosGrid').val($('#datosGrid').val() + '[' +
								document.getElementById("usuarioVerifica").value + ']' +
								document.getElementById("folioSpeiID"+i+"").value + ']' +
								document.getElementById("claveRastreo"+i+"").value + ']' +
								document.getElementById("clienteID"+i+"").value + ']' +
								document.getElementById("comentario"+i+"").value);

					}
				}
			}
		}
		else{
			return 1;
		}

	}



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
			habilitaBoton('autorizar');
			habilitaBoton('cancelar');
		}else{
			deshabilitaBoton('autorizar');
			deshabilitaBoton('cancelar');
		}
	}



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
			habilitaBoton('autorizar');
			habilitaBoton('cancelar');
		}else{
			deshabilitaBoton('autorizar');
			deshabilitaBoton('cancelar');
		}
	}

	function funcionExitoAutoriza (){
		consultaSpeiPendienteExito();
		deshabilitaBoton('autorizar');
		deshabilitaBoton('cancelar');
	}

	function funcionErrorAutoriza (){
		deshabilitaBoton('autorizar');
		deshabilitaBoton('cancelar');

	}
