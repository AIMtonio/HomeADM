
$(document).ready(function() {
	var tipoTransaccion= {
			'reversa'    : '1'
		};
	var parametroBean = consultaParametrosSession();

	esTab = true;

	deshabilitaBoton('reversaPagos', 'submit');

	$('#institNominaID').focus();

/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	agregaFormatoControles('formaGenerica');
	/*pone tap falso cuando toma el foco input text */
	$(':text').focus(function() {
	 	esTab = false;
	});

	/*pone tab en verdadero cuando se presiona tab */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			tipoTrans= $('#tipoTransaccion').val();
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'institucionID',
			   		'funcionExito', 'funcionError');
    	}
      });


	$('#institNominaID').bind('keyup',function(e){
		lista('institNominaID', '1', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function() {
		consultaInstitucionNomina(this.id);
	});

	$('#folioCargaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "folioCargaID";
		camposLista[1] = "institNominaID";
		parametrosLista[0] = $('#folioCargaID').val();
		parametrosLista[1] = $('#institNominaID').val();
		lista('folioCargaID', '2', '1', camposLista, parametrosLista, 'listaFolios.htm');
	});

	$('#folioCargaID').blur(function() {
		consultaFolio(this.id);
	});

	/*asigna el tipo de transaccion */
	$('#reversaPagos').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.reversa);
		var folioID = $('#folioCargaID').val();

		var confirmar = confirm("¿Está Seguro  de Realizar la Reversa de Pago de Crédito del Folio No. " + folioID);

		 if(confirmar == true){
		 	if($('#contraseniaUsuarioAutoriza').val() != ''){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID', 'funcionExito','funcionError');
				$('#statusSrvHuella').hide();
			}else{
				mensajeSis("La contraseña está vacía");
				$('#contraseniaUsuarioAutoriza').focus();
			}
		 }
		 return false;
	});

	$('#motivo').blur(function(){
		var texto = $('#motivo').val();
		texto = texto.replace(/[\n\r\t\f\b]/g, " ");
		$('#motivo').val(texto.slice(0, 200));
	});

	$('#usuarioAutorizaID').blur(function(){
		validaUsuario(this);
  	});



/* =============== VALIDACIONES DE LA FORMA ================= */
	$('#formaGenerica').validate({
		rules: {
			institNominaID :{
				required:true
				},
			folioCargaID :{
				required:true
				},
			motivoReversa :{
				required:true,
				maxlength : 400
				},
			usuarioAutorizaID : {
					required: true
				}
		},
		messages: {
			institNominaID :{
				required:'Ingrese una Empresa de Nómina.'
				},
			folioCargaID :{
				required:'Ingrese un Folio de Nómina.'
				},
			motivoReversa :{
				required:'Especificar Motivo Reversa De Pago de Crédito de Nómina',
				maxlength:'Máximo de Caracteres'
				},
			usuarioAutorizaID : {
				required: 'Especificar el Usuario'
			}
		}
	});


});// fin document.ready

/* =================== FUNCIONES ========================= */



// Consulta de Institucion de Nomina
 function consultaInstitucionNomina(idControl) {
	var jqNombreInst = eval("'#" + idControl + "'");
	var institucionID = $(jqNombreInst).val();
	var tipoConsulta = 1 ;
	var institucionBean = {
			'institNominaID': institucionID
	};
	if(institucionID != '' && !isNaN(institucionID) && esTab){
	institucionNomServicio.consulta(tipoConsulta,institucionBean,function(institNomina) {
		if(institNomina!= null){
			esTab=true;
			$('#nombreInstitucion').val(institNomina.nombreInstit);
			institNomID= $('#institNominaID').val();
			$('#folioCargaID').val('');
			$('#motivo').val("");
			$('#usuarioAutorizaID').val("");
			$('#contraseniaUsuarioAutoriza').val("");
			habilitaBoton('reversaPagos', 'submit');
			$('#divGridCreditosPagados').html("");


			}
		else {
			alert("La Empresa de Nómina No Existe");
			$('#institNominaID').focus();
			$('#institNominaID').val('');
			$('#nombreInstitucion').val('');
			$('#folioCargaID').val('');
			$('#motivo').val('');
			$('#usuarioAutorizaID').val('');
			$('#contraseniaUsuarioAutoriza').val('');
			deshabilitaBoton('reversaPagos', 'submit');
			$('#divGridCreditosPagados').html("");

		}
		});
	 }
  }

  // Consulta de Institucion de Nomina
 function consultaFolio(idControl) {
	var jqFolio = eval("'#" + idControl + "'");
	var folioID = $(jqFolio).val();
	var institucionID = $('#institNominaID').val();
	var tipoConsulta = 1 ;
	var reversaBean = {
			'institNominaID': institucionID,
			'folioCargaID': folioID
	};
	if(folioID != '' && !isNaN(folioID) && esTab){
		reversaPagoNominaServicio.consulta(tipoConsulta,reversaBean,function(folio) {
		if(folio!= null){
			var folioPendeintes = parseInt(folio.regPendientes);
			var estatusFolio = folio.estatus;
			var fechaPago	= folio.fechaApliPago;
			if(folioPendeintes == 0 && estatusFolio == 'P' && fechaPago == parametroBean.fechaAplicacion){
				esTab=true;
				$('#folioCargaID').val(folio.folioCargaID);
				consultaGridPagos();
			}else{
				if(folioPendeintes > 0){
					mensajeSis("Existen Registros por Procesar.");
				}
				if(estatusFolio != 'P'){
					mensajeSis("El Folio no se ha Procesado.");
				}
				if(fechaPago != parametroBean.fechaAplicacion){
					mensajeSis("La fecha de Procesamiento no corresponde al fecha del Sistema");
				}

				$('#folioCargaID').focus();
				$('#folioCargaID').val('');
				$('#motivo').val('');
				$('#usuarioAutorizaID').val('');
				$('#contraseniaUsuarioAutoriza').val('');
				deshabilitaBoton('reversaPagos', 'submit');
				$('#divGridCreditosPagados').html("");
			}

			}
		else {
			mensajeSis("El Folio no Coincide con la Institución de Nomina, o No Existe.");
			$('#folioCargaID').focus();
			$('#folioCargaID').val('');
			$('#motivo').val('');
			$('#usuarioAutorizaID').val('');
			$('#contraseniaUsuarioAutoriza').val('');
			deshabilitaBoton('reversaPagos', 'submit');
			$('#divGridCreditosPagados').html("");
		}
		});
	 }
  }

//Función muestra en el grid
 function consultaGridPagos() {
	 var params = {};
		params['institNominaID'] = $('#institNominaID').val();
		params['folioCargaID'] = $('#folioCargaID').val();
		params['tipoLista'] = 1;
		$('#divGridCreditosPagados').show();
		$.post("reversaPagossGrid.htm", params, function(data) {
	 		if (data.length > 0) {
	 			bloquearPantallaCarga();

	 			$('#divGridCreditosPagados').html(data);
	 			numFilas = consultaFilas();
	 			/*habilitaBotonesGrid();
	 			formatoMonedaGrid();*/


	 			$('#contenedorForma').unblock(); // desbloquear
	 			var options = new GridViewScrollOptions();
	 			options.elementID = "gvMain";
	 			var tama=$(window).width();
	 			if(tama>300){
	 			tama=tama-300;
	 			}
	 			options.width = tama;
	 			options.height = 500;
	 			options.freezeColumn = true;
	 			options.freezeFooter = true;
	 			options.freezeColumnCssClass = "GridViewScrollItemFreeze";
	 			options.freezeColumnCount = 1;

	 			gridViewScroll = new GridViewScroll(options);
	 			gridViewScroll.enhance();
	 		} else {
	 			mensajeSis('No se Encontraron Coincidencias');
	 		}
	 });

 }

 // Function de Paginacion
 function generaSeccion(pageValor) {

		var params = {};
		params['institNominaID'] = $('#institNominaID').val();
		params['folioCargaID'] = $('#folioCargaID').val();
		params['tipoLista'] = 1;
		params['page'] = pageValor;

		$.post("reversaPagossGrid.htm", params, function(data) {
			if (data.length > 0) {
				bloquearPantallaCarga();
				$('#divGridCreditosPagados').html(data);

				var numFilas = consultaFilas();

				$('#contenedorForma').unblock(); // desbloquear
				var options = new GridViewScrollOptions();
				options.elementID = "gvMain";
				var tama=$(window).width();
				if(tama>300){
				tama=tama-300;
				}
				options.width = tama;
				options.height = 500;
				options.freezeColumn = true;
				options.freezeFooter = true;
				options.freezeColumnCssClass = "GridViewScrollItemFreeze";
				options.freezeColumnCount = 1;

				gridViewScroll = new GridViewScroll(options);
				gridViewScroll.enhance();
			} else {
				mensajeSis('No se Encontraron Coincidencias');
			}

		});


	}
 // Validacion de Usuario
 function validaUsuario(control) {
	var claveUsuario = $('#usuarioAutorizaID').val();
	if(claveUsuario != ''){
		var usuarioBean = {
			'clave':claveUsuario
		};
		usuarioServicio.consulta(3, usuarioBean, function(usuario) {
			if(usuario!=null){

			}else{
				mensajeSis('El Usuario Ingresado No Existe');
				$('#usuarioAutorizaID').val();
				$('#usuarioAutorizaID').focus();
			}
		});
	}
}

//funcion que bloquea la pantalla mientras se cargan los datos
 function bloquearPantallaCarga() {
 	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
 	$('#contenedorForma').block({
 	message : $('#mensaje'),
 	css : {
 	border : 'none',
 	background : 'none'
 	}
 	});

 }

//Función consulta el total de creditos en la lista
 function consultaFilas() {
 	var totales = 0;
 	$('tr[name=renglons]').each(function() {
 		totales++;

 	});
 	return totales;
 }


 function agregaMonedaFormat(){
	 $('input[name=listaMontoPagos]').each(function() {
			numero= this.id.substr(10,this.id.length);
			varCapitalID = eval("'#montoPagos"+numero+"'");
			$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		});

 }

 function funcionExito(){
		$('#divGridCreditosPagados').html("");
		$('#institNominaID').focus();
		$('#nombreInstitucion').val('');
		$('#folioCargaID').val('');
		$('#motivo').val('');
		$('#usuarioAutorizaID').val('');
		$('#contraseniaUsuarioAutoriza').val('');

		deshabilitaBoton('reversaPagos');

	}
  function funcionError(){
	  agregaFormatoControles('formaGenerica');
	}
