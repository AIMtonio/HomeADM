
	// Tipo de Reporte a Generar
    var catTipoRepContrato = { 
			'PDF'	: 1
	};

$(document).ready(function() {
	esTab = true;

	//Definicion de Constantes y Enums  
	var tipoActualizacion= {
			'ninguna': '0',
			'bloquear': '1',
			'desbloquear': '2',
			'guardar': '4'	
		};
	
	var tipoTransaccion= {			
			'agregar': '1',
			'actualizar': '2'					
		};
				
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('guardar', 'submit');
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('bloquear', 'submit');			
	deshabilitaBoton('desbloquear', 'submit');
	deshabilitaBoton('contrato', 'submit');
	$('#btnGuardar').hide();
	$('#cuentasBcaMovID').focus();

	
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
			var valorTransaccion = $('#tipoTransaccion').val();
			var valorActualizacion = $('#tipoActualizacion').val();
			
			if(valorTransaccion == 2 && valorActualizacion == 4) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'false','', 'funcionExitoPreguntas',
							'funcionError');	
			} else {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','cuentasBcaMovID', 'funcionExito',
					'funcionError');
			}
		}
	});
	
	$('#registroPDM').change(function(){
		if($('#registroPDM').val()=='S'){
			$('#altaPIN').show();
			
			$("#nip").rules("add", {
					required:true,
				messages: {
					required: "Especificar un NIP",
				}
			});
			
			$("#cnip").rules("add", {
					equalTo: "#nip",
				messages: {
					equalTo:"Por favor, introduzca el mismo valor de nuevo",
				}
			});
		
		}else{
			$("#nip").rules("remove");
			$("#cnip").rules("remove");
			$("#admin").rules("remove");
			$("#nipadmin").rules("remove");
			$("#nip").val('');
			$("#cnip").val('');
			$('#altaPIN').hide();
			
		}
	});
	
	$('#agregar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.agregar);
		$('#tipoActualizacion').val(tipoActualizacion.ninguna);
	});
	
	$('#bloquear').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.actualizar);
		$('#tipoActualizacion').val(tipoActualizacion.bloquear);
	});
	
	$('#desbloquear').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.actualizar);
		$('#tipoActualizacion').val(tipoActualizacion.desbloquear);
	});
	
	$('#guardar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.actualizar);
		$('#tipoActualizacion').val(tipoActualizacion.guardar); 
		validaCaracteresEspeciales();
		guardarPreguntasSeguridad(); 
	});
	
	$('#contrato').click(function() { 
		generaContratoMediosElectronicos();
	});

	$('#cuentasBcaMovID').bind('keyup',function(e) {
		var camposLista = new Array(); 
	    var parametrosLista = new Array(); 
	    	camposLista[0] = "nombreCompleto";
	    	parametrosLista[0] = $('#cuentasBcaMovID').val();
	    	
		lista('cuentasBcaMovID', '2', '1', camposLista, parametrosLista, 'listaUsuarioBCAMovil.htm');
	});
	
	$('#cuentasBcaMovID').blur(function() {
		if(isNaN($('#cuentasBcaMovID').val())){
			inicializaForma('formaGenerica', 'cuentasBcaMovID');
			$('#cuentasBcaMovID').val('');
			$('#cuentasBcaMovID').focus();
			$('#altaPIN').hide();
			$('#gridUsuariosPDM').html("");
			$('#gridUsuariosPDM').hide();
			$('#usuarioPDM').hide();
			$('#btnGuardar').hide();
			$('#gridPreguntasSeguridad').html("");
			$('#gridPreguntasSeguridad').hide();
			$('#registroPDM').val('S');
			deshabilitaBoton('guardar', 'submit');
			deshabilitaBoton('agregar', 'submit');
			deshabilitaBoton('bloquear', 'submit');			
			deshabilitaBoton('desbloquear', 'submit');
			deshabilitaBoton('contrato', 'submit');
		}else{
			consultaUsuariPDM();
		}
	});
	
	// Lista de Clientes
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	// Consulta de Clientes
	$('#clienteID').blur(function() {
		if(isNaN($('#clienteID').val())){
			$('#clienteID').focus();
			
		}else{
			consultaClientePantalla();
		}	
	});	
	
	// Lista Cuentas del Cliente
	$('#cuentaAhoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		lista('cuentaAhoID', '2', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');		       
	});

	// Consulta las Cuentas del Cliente
	$('#cuentaAhoID').blur(function() {
		consultaCuentaAho(this.id);
	});
	 
	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			cuentaAhoID: {
				required: true
			}
		},		
		messages: {		
			cuentaAhoID: {
				required: "Especifique el Número de Cuenta."
			}
		}		
	});

	//------------ Validaciones de Controles -------------------------------------

});		
	// Funcion para consultar informacion del cliente
	function consultaClientePantalla(){	
		var numCliente = $('#clienteID').val();		
		var tipConPantalla = 5;
		var rfc = ' ';
		
		if(numCliente == ''){
			$('#nombreCompleto').val('');
		}
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente) && esTab) { 
			clienteServicio.consulta(tipConPantalla,numCliente,rfc,{ async: false, callback:function(cliente){					
					if (cliente != null){										
						$('#clienteID').val(cliente.numero);
						$('#nombreCompleto').val(cliente.nombreCompleto);						
						
						if(cliente.estatus == 'I'){
							mensajeSis('El Cliente se encuentra Inactivo');
							inicializaForma('formaGenerica','cuentasBcaMovID');
							$('#cuentasBcaMovID').focus();
							$('#cuentasBcaMovID').val('');	
							$('#altaPIN').hide();
							$('#gridUsuariosPDM').html("");
							$('#gridUsuariosPDM').hide();
							$('#usuarioPDM').hide();
							$('#btnGuardar').hide();
							$('#gridPreguntasSeguridad').html("");
							$('#gridPreguntasSeguridad').hide();
							$('#registroPDM').val('S');
							deshabilitaBoton('guardar');
							deshabilitaBoton('agregar');
							deshabilitaBoton('contrato');
							deshabilitaControl('clienteID');
						}						
						if(cliente.estatus == 'C'){
							mensajeSis('El Cliente se encuentra Cancelado');
							inicializaForma('formaGenerica','cuentasBcaMovID');
							$('#cuentasBcaMovID').focus();
							$('#cuentasBcaMovID').val('');	
							$('#altaPIN').hide();
							$('#gridUsuariosPDM').html("");
							$('#gridUsuariosPDM').hide();
							$('#usuarioPDM').hide();
							$('#btnGuardar').hide();
							$('#gridPreguntasSeguridad').html("");
							$('#gridPreguntasSeguridad').hide();
							$('#registroPDM').val('S');
							deshabilitaBoton('guardar');
							deshabilitaBoton('agregar');
							deshabilitaBoton('contrato');
							deshabilitaControl('clienteID');
						}
						
						if(cliente.estatus == 'B'){
							mensajeSis('El Cliente se encuentra Bloqueado');
							inicializaForma('formaGenerica','cuentasBcaMovID');
							$('#cuentasBcaMovID').focus();
							$('#cuentasBcaMovID').val('');	
							$('#altaPIN').hide();
							$('#gridUsuariosPDM').html("");
							$('#gridUsuariosPDM').hide();
							$('#usuarioPDM').hide();
							$('#btnGuardar').hide();
							$('#gridPreguntasSeguridad').html("");
							$('#gridPreguntasSeguridad').hide();
							$('#registroPDM').val('S');
							deshabilitaBoton('guardar');
							deshabilitaBoton('agregar');
							deshabilitaBoton('contrato');
							deshabilitaControl('clienteID');
						}						
	
					} else {
						mensajeSis("No Existe el Cliente");
						inicializaForma('formaGenerica','cuentasBcaMovID');
						$('#cuentasBcaMovID').focus();
						$('#cuentasBcaMovID').val('');	
						$('#altaPIN').hide();
						$('#gridUsuariosPDM').html("");
						$('#gridUsuariosPDM').hide();
						$('#usuarioPDM').hide();
						$('#btnGuardar').hide();
						$('#gridPreguntasSeguridad').html("");
						$('#gridPreguntasSeguridad').hide();
						$('#registroPDM').val('S');
						deshabilitaBoton('guardar');
						deshabilitaBoton('agregar');
						deshabilitaBoton('contrato');
						deshabilitaControl('clienteID');					
					}	
				}
			});	
		}
	}

	// Funcion para consultar la cuenta del cliente
	function consultaCuentaAho(idControl){	
		var numUsua = $('#cuentasBcaMovID').val();
		
		var jqCuenta  = eval("'#" + idControl + "'");
		var numCuenta = $(jqCuenta).val();	
				
		var tipConCampos= 30;
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCuenta
		};
		if(numCuenta != '' && !isNaN(numCuenta)&& esTab){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuentas){			
				if (cuentas != null){				
					if(numUsua == '0'){
						if(cuentas.telefonoCelular !=''){						
							$('#cuentaAhoID').val(cuentas.cuentaAhoID);
							$('#telefono').val(cuentas.telefonoCelular);
							$('#telefono').setMask('phone-us');
							
							habilitaBoton('agregar', 'submit');
							
							habilitaBoton('guardar', 'submit');
							habilitaBoton('contrato', 'submit');
														
							consultaNumeroPreguntas();
							
							if($('#registroPDM').val()=='S'){
								$('#altaPIN').show();
								
								$('#nip').focus();
								
								
									$("#nip").rules("add", {
											required:true,
										messages: {
											required: "Especificar un NIP",
										}
									});
									$("#cnip").rules("add", {
											equalTo: "#nip",
										messages: {
											equalTo:"Por favor, introduzca el mismo valor de nuevo",
										}
									});
								
							}
							
						}else{
							
							mensajeSis("El Cliente No cuenta Con un Número Telefónico Asociado a su Cuenta");
							inicializaForma('formaGenerica','cuentasBcaMovID');
							$('#cuentasBcaMovID').focus();
							$('#cuentasBcaMovID').val('');
							$('#altaPIN').hide();
							$('#gridUsuariosPDM').html("");
							$('#gridUsuariosPDM').hide();
							$('#usuarioPDM').hide();
							$('#btnGuardar').hide();
							$('#gridPreguntasSeguridad').html("");
							$('#gridPreguntasSeguridad').hide();
							$('#registroPDM').val('S');
							deshabilitaBoton('guardar');
							deshabilitaBoton('agregar');
							deshabilitaBoton('contrato');
							deshabilitaControl('clienteID');
						}
					}
					
				} else {			
					mensajeSis("El Número de Cuenta No Existe.");
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').val('');
					deshabilitaBoton('agregar');
				}		
			
			});
		}
	}

	// Funcion para consulta de usuario PDM
	function consultaUsuariPDM() {
		var numUsua = $('#cuentasBcaMovID').val();
			
		var tipConPantalla = 1;
		var CuentasBeanCon = {
			'cuentasBcaMovID' : numUsua
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numUsua != '' && !isNaN(numUsua) && esTab) { 
			if(numUsua =='0'){
				$("#formaGenerica").validate().resetForm();	
				$("#formaGenerica").find(".error").removeClass("error");	
				$("#nip").rules("remove");
				$("#cnip").rules("remove");
				$("#admin").rules("remove");
				$("#nipadmin").rules("remove");
				limpiaCampos();			
				habilitaControl('clienteID');
				$('#clienteID').focus();	
				$('#altaPIN').hide();
				$('#gridUsuariosPDM').html("");
				$('#gridUsuariosPDM').hide();
				$('#usuarioPDM').hide();
				$('#btnGuardar').hide();
				$('#gridPreguntasSeguridad').html("");
				$('#gridPreguntasSeguridad').hide();
				$('#registroPDM').val('S');
				deshabilitaBoton('guardar');
				deshabilitaBoton('agregar', 'submit');			
				deshabilitaBoton('bloquear', 'submit');			
				deshabilitaBoton('desbloquear', 'submit');	
				deshabilitaBoton('contrato');
				
				
			}else{		
				$("#formaGenerica").validate().resetForm();	
				$("#formaGenerica").find(".error").removeClass("error");				
				$("#nip").rules("remove");
				$("#cnip").rules("remove");
				$("#admin").rules("remove");
				$("#nipadmin").rules("remove");
				deshabilitaBoton('agregar', 'submit');
				deshabilitaControl('clienteID');
				$('#altaPIN').hide();
				$('#gridUsuariosPDM').html("");
				$('#gridUsuariosPDM').hide();
				$('#usuarioPDM').hide();
				$('#admin').val('');
				$('#nipadmin').val('');
				$('#registroPDM').val('S');
				
				
				cuentasBCAMovilServicio.consulta(tipConPantalla, CuentasBeanCon,{ async: false, callback:
					function(cuentas){							
						if (cuentas != null){							
							$('#cuentasBcaMovID').val(cuentas.cuentasBcaMovID);
							$('#clienteID').val(cuentas.clienteID);
							$('#nombreCompleto').val(cuentas.nombreCompleto);
							$('#cuentaAhoID').val(cuentas.cuentaAhoID);
							$('#telefono').val(cuentas.telefono);	
							$('#telefono').setMask('phone-us');
							$('#registroPDM').val(cuentas.registroPDM);
							if(cuentas.registroPDM == 'S'){
								consultaRegistroUsua();								
							}else{
								consultaNumeroPreguntas();
							}
							
							if(cuentas.estatus == "A"){
								
								deshabilitaBoton('desbloquear', 'submit');		
								habilitaBoton('bloquear', 'submit');
								habilitaBoton('modificar', 'submit');
								habilitaBoton('contrato', 'submit');
																
							}else{
								
								habilitaBoton('desbloquear', 'submit');
								deshabilitaBoton('bloquear', 'submit');
								deshabilitaBoton('modificar', 'submit');
								deshabilitaBoton('contrato', 'submit');
																
							}
	
						} else {
							mensajeSis("No Existe Usuario");
							inicializaForma('formaGenerica','cuentasBcaMovID');
							$('#cuentasBcaMovID').focus();
							$('#cuentasBcaMovID').val('');	
							deshabilitaBoton('agregar');
							deshabilitaControl('clienteID');
							$('#registroPDM').val('S');
						}	
					}
				});
			}		
		}
	}

	//Funcion para consultar los usuarios registrados en pademobil
	function consultaRegistroUsua() {
		var numCta =$('#cuentasBcaMovID').val();
		var params = {
		'cuentasBcaMovID'	:numCta,
		};
		params['tipoLista'] = 2;
		$.post("gridCtaUsuaBCAMovil.htm", params, function(data) {
			if (data.length > 0) {
				agregaFormatoControles('formaGenerica');
				$('#gridUsuariosPDM').html(data);
				$('#gridUsuariosPDM').show();
				$('#telefonoBD1').setMask('phone-us');
				
				$('#usuarioPDM').show();	
				$('#admin').focus();
				
				consultaNumeroPreguntas();
				
				$('#bloquear').click(function() {
					$("#admin").rules("add", {
						required:true,
					messages: {
							required: "Especificar un NICK",
					}
					});
					$("#nipadmin").rules("add", {
						required: true,
					messages: {
						required:"Especificar un NIP",
					}
					});
				});
				
				$('#desbloquear').click(function() {
					$("#admin").rules("add", {
						required:true,
					messages: {
							required: "Especificar un NICK",
					}
					});
					$("#nipadmin").rules("add", {
						required: true,
					messages: {
						required:"Especificar un NIP",
					}
					});
				});
			} else {
				$('#gridUsuariosPDM').html("");
				$('#gridUsuariosPDM').hide();
				mensajeSis("No se tienen Registros");
				
			}
		});	
	}
	
	// Funcion para consultar el numero de preguntas de seguridad del cliente
	function consultaNumeroPreguntas(){ 	
		var numCliente = $('#clienteID').val();
		var numeroPreguntas = "";
		var tipConsulta = 3;

		var PreguntasBeanCon = {
			'clienteID' : numCliente
		};
		if(numCliente != '' && !isNaN(numCliente)){
			cuentasBCAMovilServicio.consulta(tipConsulta, PreguntasBeanCon,{ async: false, callback:
					function(preguntas){			
						if (preguntas != null){				
							 numeroPreguntas = preguntas.numPreguntas;
							 if(numeroPreguntas == 0){
								registroPreguntasSeguridad();
							 }
							 else{
								 consultaPreguntasSeguridad();
							 }
						}	
					}
				});
			}
		}
	
	// Funcion para el registro de Preguntas de Seguridad en el Grid
	function registroPreguntasSeguridad(){
		var numCte =$('#clienteID').val();
		var params = {};
		params['tipoLista'] = 6;
		params['clienteID'] = numCte;
		
		$.post("gridPreguntasSeguridadPDM.htm", params, function(data){
			if(data.length >0) {	
				$('#btnGuardar').show();			
				$('#gridPreguntasSeguridad').html(data);
				$('#gridPreguntasSeguridad').show();
				habilitaBoton('guardar', 'submit');
				$('#preguntaID1').focus();
				$('#registroPDM').focus();
				if($('#numeroDocumento').val() == 0){
					$('#gridPreguntasSeguridad').html("");
					$('#gridPreguntasSeguridad').hide(); 
					$('#btnGuardar').hide();
					deshabilitaBoton('guardar', 'submit');
				}				
			}else{				
				$('#gridPreguntasSeguridad').html("");
				$('#gridPreguntasSeguridad').hide(); 
				$('#btnGuardar').hide();
			}
		});
		
	}
	
	// Funcion para la consulta de Preguntas de Seguridad en el Grid
	function consultaPreguntasSeguridad(){
		var numCte =$('#clienteID').val();
		var params = {};
		params['tipoLista'] = 7;
		params['clienteID'] = numCte;
		
		$.post("gridPreguntasSeguridadPDM.htm", params, function(data){
			if(data.length >0) {	
				$('#btnGuardar').show();			
				$('#gridPreguntasSeguridad').html(data);
				$('#gridPreguntasSeguridad').show();
				habilitaBoton('guardar', 'submit');

				$('#preguntaID1').focus();

				if($('#numeroDocumento').val() == 0){
					$('#gridPreguntasSeguridad').html("");
					$('#gridPreguntasSeguridad').hide(); 
					$('#btnGuardar').hide();
					deshabilitaBoton('guardar', 'submit');
				}				
			}else{				
				$('#gridPreguntasSeguridad').html("");
				$('#gridPreguntasSeguridad').hide(); 
				$('#btnGuardar').hide();
			}
		});

	}
	
	// Funcion para guardar Preguntas de Seguridad
	function guardarPreguntasSeguridad(){		
 		var mandar = verificarVacios();
 		if(mandar!=1){   
			var numCodigo = $('input[name=consecutivoIDP]').length;
			$('#datosGridPreguntas').val("");
			for(var i = 1; i <= numCodigo; i++){
				if(i == 1){
					$('#datosGridPreguntas').val($('#datosGridPreguntas').val() +
					document.getElementById("preguntaID"+i+"").value + ']' +
					document.getElementById("respuestas"+i+"").value);
				}else{
					$('#datosGridPreguntas').val($('#datosGridPreguntas').val() + '[' +
					document.getElementById("preguntaID"+i+"").value + ']' +
					document.getElementById("respuestas"+i+"").value);
				}	
			}
		}
		else{
			mensajeSis("Faltan Datos.");
			event.preventDefault();
		}
	}	
	
	// Funcion para verificar vacios
	function verificarVacios(){	
		quitaFormatoControles('gridPreguntasSeguridad');
		var numCodig = $('input[name=consecutivoIDP]').length;
		
		$('#datosGridPreguntas').val("");
		for(var i = 1; i <= numCodig; i++){
			var idcr = document.getElementById("preguntaID"+i+"").value;
 			if (idcr ==""){
 				document.getElementById("preguntaID"+i+"").focus();				
				$(idcr).addClass("error");	
 				return 1; 
 			}
			var idcde = document.getElementById("respuestas"+i+"").value;
 			if (idcde ==""){
 					document.getElementById("respuestas"+i+"").focus();
 	 				$(idcde).addClass("error");
 	 				return 1; 
 			}
 		}
	}
	
	// funcion para eliminar caracteres especiales
	function validaCaracteresEspeciales(){
		$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqRespuesta= eval("'#respuestas" + numero + "'");				
		
		var respuesta = $(jqRespuesta).val();
		
		var valorRespuesta = respuesta.replace(/[%&(=?¡'@,{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\][°|!#|$|%|/|()|=|?|:|;|-|¡|¿|\¬|+*{}|[]|_|]/gi, ''); 
			valorRespuesta = valorRespuesta.replace(/[_]/gi,'');
			respuesta = valorRespuesta;				
		
			$(jqRespuesta).val(respuesta);
		
		});
	}
	
	// Funcion para Generar el Contrato de Medios Electronicos
	function generaContratoMediosElectronicos(){
			// Declaracion de variables
			var tipoReporte = catTipoRepContrato.PDF;

			var cliente = $('#clienteID').val();
			var cuenta = $('#cuentaAhoID').val();
			
			var fechaEmision = parametroBean.fechaSucursal;
			var sucursal = parametroBean.sucursal;
			var nombreSucursal = parametroBean.nombreSucursal;

			var pagina ='contratoMediosElectronicos.htm?clienteID='+cliente+'&cuentaAhoID='+cuenta	
									+ '&tipoReporte='+tipoReporte+'&fechaEmision='+fechaEmision
									+'&sucursalID='+sucursal+'&nombreSucursal='+nombreSucursal;
			window.open(pagina);	
	}
	
	// Funcion para limpiar campos en pantalla
	function limpiaCampos(){
	
	    $('#clienteID').val('');
		$('#nombreCompleto').val('');
		$('#cuentaAhoID').val('');
		$('#numCtaBancaria').val('');
		$('#telefono').val('');
		$('#nip').val('');
		$('#cnip').val('');
		$('#registroPDM').val('S');
	}
	
	// Funcion de Exito
	function funcionExito() {
		inicializaForma('formaGenerica','cuentasBcaMovID');		
		deshabilitaBoton('guardar', 'submit');
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('bloquear', 'submit');			
		deshabilitaBoton('desbloquear', 'submit');
		deshabilitaBoton('contrato', 'submit');
		deshabilitaControl('clienteID');
		$('#altaPIN').hide();
		$('#gridUsuariosPDM').html("");
		$('#gridUsuariosPDM').hide();
		$('#usuarioPDM').hide();
		$('#btnGuardar').hide();
		$('#gridPreguntasSeguridad').html("");
		$('#gridPreguntasSeguridad').hide();
		$('#registroPDM').val('S');
	
	}
	
	function funcionExitoPreguntas() {
		$('#guardar').focus();
	}
	
	// Funcion de Error
	function funcionError() {
		inicializaForma('formaGenerica','cuentasBcaMovID');
		deshabilitaBoton('guardar', 'submit');
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('bloquear', 'submit');			
		deshabilitaBoton('desbloquear', 'submit');
		deshabilitaBoton('contrato', 'submit');
		deshabilitaControl('clienteID');
		$('#altaPIN').hide();
		$('#gridUsuariosPDM').html("");
		$('#gridUsuariosPDM').hide();
		$('#usuarioPDM').hide();
		$('#btnGuardar').hide();
		$('#gridPreguntasSeguridad').html("");
		$('#gridPreguntasSeguridad').hide();
	
	}
	
	
