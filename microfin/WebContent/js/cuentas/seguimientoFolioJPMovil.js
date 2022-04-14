	//Definicion de Constantes y Enums
	var tipoTransaccion= {
			'validar': '3',
			'enviarCometario': '4',
			'cancelaFolio': '5',
			'finalizaFolio': '6'
	}
	var Constantes = {
		"SI" 			: "S",
		"NO" 			: "N",
		"CADENAVACIA" 	: "",
		"ENTEROCERO"  	: 0,
	};

	var Estatus = {
			'enProceso': 'P',
			'cancelado': 'C',
			'resuelto' : 'R'
	}

	var EstatusTxt = {
			'enProcesoTxt'	: 'EN PROCESO',
			'canceladoTxt'	: 'CANCELADO',
			'resueltoTxt'	: 'RESUELTO'
	}

	var nombreServicio = "";

	var conParametroBean = {  
		'principal' : 1	
	};

	

	
$(document).ready(function() {
	esTab = false;


	consultaNombreServicio();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('consultar', 'submit');
	deshabilitaBoton('validar', 'submit');
	deshabilitaBoton('enviar', 'submit');
	$('#validar').hide();
	$('#usuarioID').val(parametroBean.numeroUsuario);
	$('#seccionSeguimiento').hide();
	$('#seguimientoID').focus();


	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','clienteID', 'funcionExito',
				'funcionError');
		}
	});

	$('#seguimientoID').bind('keyup',function(){
		lista('seguimientoID','2','1','seguimientoID',$('#seguimientoID').val(),'listaFoliosSeguimiento.htm');
	});

	$('#seguimientoID').blur(function(){
		if(esTab){

			consultaFolio(this.id);
			inicializaForma('formaGenerica','seguimientoID');
			deshabilitaBoton('consultar', 'submit');
			deshabilitaBoton('validar', 'submit');
			$('#gridPreguntasSeguridad').html("");
			$('#gridPreguntasSeguridad').hide();
			$('#datosGridPreguntas').val('');
			$('#validar').hide();
			$('#resAprobadas').val("");
			$('#seccionSeguimiento').hide();
		}
	});



	// Numero de Telefono del Cliente
	$("#numeroTelefono").setMask('phone-us');


	// Consultar datos del cliente
	$('#consultar').click(function() {
		if($('#numeroTelefono').val()== Constantes.CADENAVACIA){
			mensajeSis("Especifique Número de Teléfono.");
			$('#numeroTelefono').focus();
			} else {
				if($('#fechaNacimiento').val() == Constantes.CADENAVACIA){
					mensajeSis("Especifique Fecha de Nacimiento.");
					$('#fechaNacimiento').focus();
				} 
			else{
				consultaDatosCliente('clienteID');
				}
			}
	});

	// Validar Respuestas Preguntas Seguridad
	$('#validar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.validar);
		validaCaracteresEspeciales();
		guardarPreguntasSeguridad();
	});

	// Envia comentarios del seguimiento
	$('#enviarComentario').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.enviarCometario);
		validaTextArea();
	});

	// Cancela el folio de seguimiento
	$('#cancelarFolio').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.cancelaFolio);
	});

	// Termina el folio de seguimiento
	$('#terminarFolio').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.finalizaFolio);
	});

	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			comentarioUsuario:{
				
				maxlength:150	
			},
			comentarioCliente:{
				maxlength:150
			}
		},
		messages: {
			comentarioUsuario:{
				maxlength: 'Solo se permite 150 caracteres'
			},
			comentarioCliente:{
				maxlength: 'Solo se permite 150 caracteres'
			}
		}
	});



});	// FIN DOCUMENT READY


//------------ Validaciones de Controles -------------------------------------

	// Funcion para consultar datos del Cliente
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();

		var conPrincipal = 1;

		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != Constantes.CADENAVACIA && !isNaN(numCliente)) {
			clienteServicio.consulta(conPrincipal, numCliente, {async: false, callback:function(cliente) {
				if (cliente != null) {
					$('#clienteID').val(cliente.numero);
					$('#nombreCompleto').val(cliente.nombreCompleto);
					habilitaBoton('consultar', 'submit');
				} else {
					mensajeSis("El Cliente No Existe.");
					inicializaForma('formaGenerica','clienteID');
					$('#clienteID').focus();
					$('#clienteID').val('');
					deshabilitaBoton('consultar', 'submit');
					deshabilitaBoton('validar', 'submit');
					$('#tipoSoporteID').val('');
					$('#telefonoCelular').val('');
				}
			}});
			
		}
	}

	// Funcion para consultar Datos del cliente
	function consultaDatosCliente(idControl){

		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();

		var conPrincipal = 1;

		setTimeout("$('#cajaLista').hide();", 200);

		var numeroTelefono = $('#numeroTelefono').val();
		var fechaNacimiento = $('#fechaNacimiento').val();

		if (numCliente != Constantes.CADENAVACIA && !isNaN(numCliente)) {
			clienteServicio.consulta(conPrincipal, numCliente, function(cliente) {
				if (cliente != null) {
					$('#clienteID').val(cliente.numero);

					consultaCuentaCliente();

					$("#telefonoCelular").setMask('phone-us');

					var telefonoCelular = $('#telefonoCelular').val();

					if(telefonoCelular == Constantes.CADENAVACIA){
						mensajeSis("El Cliente No Tiene un Número de Teléfono Celular Registrado.");
						$('#numeroTelefono').focus();
						$('#numeroTelefono').val('');
							} else {
								if(telefonoCelular != numeroTelefono){
									mensajeSis("El Número de Teléfono Ingresado No Coincide con el Número de Teléfono Registrado de la Cuenta del Cliente.");
									$('#numeroTelefono').focus();
									$('#numeroTelefono').val('');
								} else {

									if(cliente.fechaNacimiento == Constantes.CADENAVACIA){
										mensajeSis("El Cliente No Tiene una Fecha de Nacimiento Registrada.");
										$('#fechaNacimiento').focus();
										$('#fechaNacimiento').val('');
									} else {

										if(cliente.fechaNacimiento != fechaNacimiento){
											mensajeSis("La Fecha de Nacimiento Ingresado No Coincide con la Fecha de Nacimiento Registrada del Cliente.");
											$('#fechaNacimiento').focus();
											$('#fechaNacimiento').val('');
										}
									else{
										consultaPreguntasSeguridad();
								}
							}
						}
					}
				}
			});
		}

	}

	// Funcion para consultar el Numero de Telefono celular de la cuenta del Cliente
	function consultaCuentaCliente(){
		var numCliente = $('#clienteID').val();
		var tipConTelefono = 4;

		var CuentasBeanCon = {
				'clienteID' : numCliente
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)){
			cuentasBCAMovilServicio.consulta(tipConTelefono, CuentasBeanCon,{ async: false, callback:
				function(cliente){
					if (cliente != null){
						$("#telefonoCelular").val(cliente.telefono);
					}
					else
					$("#telefonoCelular").val('');
				}
			});
		}
	}




	//Funcion para la consulta de Preguntas de Seguridad en el Grid
	function consultaPreguntasSeguridad(){
		var numCte =$('#clienteID').val();
		var params = {};
		params['tipoLista'] = 1;
		params['clienteID'] = numCte;

		$.post("gridVerificacionPreguntas.htm", params, function(data){
			if(data.length >0) {
				$('#gridPreguntasSeguridad').html(data);
				$('#gridPreguntasSeguridad').show();
				habilitaBoton('validar', 'submit');
				$('#validar').show();
			}else{
				$('#gridPreguntasSeguridad').html("");
				$('#gridPreguntasSeguridad').hide();
				deshabilitaBoton('validar', 'submit');
			}
		});
	}

	// Funcion para guardar Preguntas de Seguridad
	function guardarPreguntasSeguridad(){
 		var mandar = verificarVacios();
 		if(mandar!=1){
			var numCodigo = $('input[name=consecutivoID]').length;
			$('#datosGridPreguntas').val("");
			for(var i = 1; i <= numCodigo; i++){
				if(i == 1){
					$('#datosGridPreguntas').val($('#datosGridPreguntas').val() +
					document.getElementById("preguntaID"+i+"").value + ']' +
					document.getElementById("respuesta"+i+"").value);
				}else{
					$('#datosGridPreguntas').val($('#datosGridPreguntas').val() + '[' +
					document.getElementById("preguntaID"+i+"").value + ']' +
					document.getElementById("respuesta"+i+"").value);
				}
			}
		}
		else{
			mensajeSis("Faltan Respuestas.");
			event.preventDefault();
		}
	}



	function consultaFolio(idControl){
		var jqFolio = eval("'#" + idControl + "'");
		var seguimientoID = $(jqFolio).val();

		var conPrincipal = 1;
		var seguimientoFolioJPMovilBean = {
				'seguimientoID' : seguimientoID
			};

		setTimeout("$('#cajaLista').hide();", 200);
		if (seguimientoID != Constantes.CADENAVACIA && !isNaN(seguimientoID)) {
			verificacionPreguntasServicio.consultaFolio(conPrincipal,seguimientoFolioJPMovilBean,function(folioBean){
				if(folioBean != null){
					$('#clienteID').val(folioBean.clienteID);
					$('#cliente').val(folioBean.clienteID);
					$('#numeroTelefono').val(folioBean.numeroTelefono);
					$("#numeroTelefono").setMask('phone-us');
					$('#telefonoCelular').val(folioBean.numeroTelefono);

					$('#fechaNacimiento').val(folioBean.fechaNacimiento);
					$('#fechaNac').val(folioBean.fechaNacimiento);
					$('#tipoSoporteID').val(folioBean.tipoSoporteID);
					
					consultaCliente('clienteID');
					var estatus = validaEstatus(folioBean.estatus);
					$('#estatus').val(estatus);
				}else{
					mensajeSis("El Folio No existe.");
					$(jqFolio).focus();
				}
			});
		}
	}


	//funcion para validar el estatus
	function validaEstatus(estatus){
		var salida = '';
		switch(estatus){
			case  Estatus.enProceso:
				$('#seccionRespuestas').show();
				habilitaBoton('cancelarFolio','submit');
				habilitaBoton('terminarFolio','submit');
				salida = EstatusTxt.enProcesoTxt;
				break;
			case Estatus.cancelado:
				$('#seccionSeguimiento').show();
				$('#seccionRespuestas').hide();
				mostrarComentarios();
				deshabilitaBoton('cancelarFolio','submit');
				deshabilitaBoton('terminarFolio','submit');
				deshabilitaBoton('consultar','button');
				salida = EstatusTxt.canceladoTxt;
				
				break;
			case Estatus.resuelto:
				$('#seccionSeguimiento').show();
				$('#seccionRespuestas').hide();
				mostrarComentarios();
				deshabilitaBoton('cancelarFolio','submit');
				deshabilitaBoton('terminarFolio','submit');
				deshabilitaBoton('consultar','button');
				salida = EstatusTxt.resueltoTxt;
				break;
		}
		return salida;
	}


	// Funcion para verificar vacios
	function verificarVacios(){
		quitaFormatoControles('gridPreguntasSeguridad');
		var numCodig = $('input[name=consecutivoID]').length;

		$('#datosGridPreguntas').val("");
		for(var i = 1; i <= numCodig; i++){
			var idcr = document.getElementById("preguntaID"+i+"").value;
 			if (idcr ==""){
 				document.getElementById("preguntaID"+i+"").focus();
				$(idcr).addClass("error");
 				return 1;
 			}
			var idcde = document.getElementById("respuesta"+i+"").value;
 			if (idcde ==""){
 					document.getElementById("respuesta"+i+"").focus();
 	 				$(idcde).addClass("error");
 	 				return 1;
 			}
 		}
	}

	// Funcion para eliminar caracteres especiales
	function validaCaracteresEspeciales(){
		$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqRespuesta= eval("'#respuesta" + numero + "'");

		var respuesta = $(jqRespuesta).val();

		var valorRespuesta = respuesta.replace(/[%&(=?¡'@,{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\][°|!#|$|%|/|()|=|?|:|;|-|¡|¿|\¬|+*{}|[]|_|]/gi, '');
			valorRespuesta = valorRespuesta.replace(/[_]/gi,'');
			respuesta = valorRespuesta;

			$(jqRespuesta).val(respuesta);

		});
	}

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
				$('#fechaNacimiento').focus();
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}


	function comprobarSiBisisesto(anio){
		if ((( anio % 100 != 0) && (anio % 4 == 0)) || (anio % 400 == 0)) {
			return true;
		}
		else {
			return false;
		}
	}


	function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		}
	}

	//funcion para obtener el numero de caracteres en un textArea
	function contadorTextArea(idtextarea, idcontador, max){
		var contador = eval("'#"+idcontador+"'");
		var textArea = eval("'#"+idtextarea+"'");
		$(contador).text("0/"+max);

		$(contador).text($(textArea).val().length+"/"+max);
		if(parseInt($(textArea).val().length)>max){
			$(textArea).val($(textArea).val().substring(0,max-1));
			$(contador).text(max+"/"+max);
		}
	}
	
	function validaTextArea(){
		if ($('#comentarioUsuario').val()==''
				&& $('#comentarioCliente').val()==''
					&& $('#seccionSeguimiento').is(':visible')){
			mensajeSis("Debe ingresar almenos un comententario ya sea de cliente o de usuario.");
		}
	}
	
	//Funcion para mostrar el historial de comentarios
	function mostrarComentarios(){
		var seguimientoID =$('#seguimientoID').val();
		var params = {};
		params['tipoLista'] = 2;
		params['seguimientoID'] = seguimientoID;
		
		$.post("gridComentaFolioSeguimiento.htm", params, function(data){
			if(data.length >0) {	
				$('#historialComentarios').html(data);		
			}else{				
				$('#historialComentarios').html("");
			}
		});
	}
	
	// Funcion pra consultar el nombre del Servicio
	function consultaNombreServicio(){
		var numEmpresaID = 1;

		var parametrosBean = {
  				'empresaID':numEmpresaID	
  		};

		setTimeout("$('#cajaLista').hide();", 200);
		if (numEmpresaID != '' && !isNaN(numEmpresaID)) { 
			
			parametrosPDMServicio.consulta(parametrosBean,conParametroBean.principal,function(data) { 	
				//si el resultado obtenido de la consulta regreso un resultado
				if (data != null) {				
					//coloca los valores del resultado en sus campos correspondientes
					nombreServicio = data.nombreServicio;
					agregaServicio(nombreServicio);
				}
			});
		}
	}

	// Funcion para obtener el nombre del servicio para mostrarlo en el titulo de la Pantalla
	function agregaServicio(nombreServicio){
		document.getElementById('nombreServicio').innerHTML = nombreServicio;
	}
	
	// Funcion de Exito
	function funcionExito() {
		
		deshabilitaBoton('consultar', 'submit');

		if($('#campoGenerico').val()=='si'){
			habilitaBoton('enviar', 'submit');
			deshabilitaBoton('validar', 'submit');
			$('#gridPreguntasSeguridad').html("");
			$('#gridPreguntasSeguridad').hide();
			$('#validar').hide();
			$('#resAprobadas').val('1');
			$('#seccionSeguimiento').show();
			mostrarComentarios();
		}else{
			
			$('#resAprobadas').val('0');
			if($('#tipoTransaccion').val()!=tipoTransaccion.enviarCometario){
				$('#comentarioUsuario').val('');
				$('#comentarioCliente').val('');
				$('#seccionSeguimiento').hide();
			}else{
				$('#comentarioUsuario').val('');
				$('#comentarioCliente').val('');
				$('#contadorUsuario').text('0/150');
				$('#contadorCliente').text('0/150');
				mostrarComentarios();
			}
		}

	}

	// Funcion de Error
	function funcionError() {
		deshabilitaBoton('consultar', 'submit');
		if($('#resAprobadas').val()=='1'){
			habilitaBoton('enviar', 'submit');
			deshabilitaBoton('validar', 'submit');
			$('#gridPreguntasSeguridad').html("");
			$('#gridPreguntasSeguridad').hide();
			$('#validar').hide();
		}else{
			habilitaBoton('validar', 'submit');
			deshabilitaBoton('enviar', 'submit');
		}

	}

