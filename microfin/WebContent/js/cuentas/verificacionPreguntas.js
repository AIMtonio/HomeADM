$(document).ready(function() {
	esTab = false;

	//Definicion de Constantes y Enums  
	var tipoTransaccion= {			
			'validar': '1',
			'enviar' : '2'				
	};
	
	var Constantes = {
		"SI" 			: "S",
		"NO" 			: "N",	
		"CADENAVACIA" 	: "",
		"ENTEROCERO"  	: 0,
	};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('consultar', 'submit');
	deshabilitaBoton('validar', 'submit');
	deshabilitaBoton('enviar', 'submit');
	$('#validar').hide();
	$('#usuarioID').val(parametroBean.numeroUsuario);
	
	$('#clienteID').focus();

	consultaTiposSoporte();
	
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
	
	// Lista de Clientes
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	// Consulta de Clientes
	$('#clienteID').blur(function() {
		if(esTab){
			consultaCliente(this.id);
			inicializaForma('formaGenerica','clienteID');		
			deshabilitaBoton('consultar', 'submit');
			deshabilitaBoton('validar', 'submit');
			$('#gridPreguntasSeguridad').html("");
			$('#gridPreguntasSeguridad').hide();
			$('#datosGridPreguntas').val('');
			deshabilitaBoton('enviar', 'submit');
			$('#validar').hide();
			$('#resAprobadas').val("");
		}
	});
	
	// Numero de Telefono del Cliente
	$("#numeroTelefono").setMask('phone-us');
	
	// Fecha de Nacimiento del Cliente
	$('#fechaNacimiento').blur(function() {
		if(esTab){
			var Xfecha = $('#fechaNacimiento').val(); 
			var Yfecha =  parametroBean.fechaSucursal;
			if(esFechaValida(Xfecha)){
				if (mayor(Xfecha, Yfecha))
				{
					mensajeSis("La Fecha Capturada es Mayor a la de Hoy");
					$('#fechaNacimiento').val('');
					$('#fechaNacimiento').focus();
				}
			}else{
				$('#fechaNacimiento').val('');
			}
		}
	});
	
	//Fecha de Nacimiento del Cliente
	$('#fechaNacimiento').change(function() {
		var Xfecha = $('#fechaNacimiento').val(); 
		var Yfecha =  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if (mayor(Xfecha, Yfecha))
			{
				mensajeSis("La Fecha Capturada es Mayor a la de Hoy");
				$('#fechaNacimiento').val('');
				$('#fechaNacimiento').focus();
			}
		}else{
			$('#fechaNacimiento').val('');
		}
	});
	
	// Consultar datos del cliente
	$('#consultar').click(function() {
		if($('#numeroTelefono').val()== Constantes.CADENAVACIA){
			mensajeSis("Especifique Número de Teléfono.");
			$('#numeroTelefono').focus();
			} else {
				if($('#fechaNacimiento').val() == Constantes.CADENAVACIA){
					mensajeSis("Especifique Fecha de Nacimiento.");
					$('#fechaNacimiento').focus();	
				} else {
					if($('#tipoSoporteID').val() == Constantes.CADENAVACIA){
					mensajeSis("Especifique Tipo de Soporte.");
					$('#tipoSoporteID').focus();	
				}
			else{
				consultaDatosCliente('clienteID');
				}
			}
		}
	});
	
	// Validar Respuestas Preguntas Seguridad
	$('#validar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.validar);
		validaCaracteresEspeciales();
		guardarPreguntasSeguridad(); 
	});
	
	// Validar Respuestas Preguntas Seguridad
	$('#enviar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.enviar);
	});
	
	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true
			},
			numeroTelefono: {
				required: true
			},
			fechaNacimiento: {
				required: true,
				date: true
			},
			tipoSoporteID: {
				required: true
			},
			comentarios:{
				required:function(){return $('#resAprobadas').val()=='1'; }
			}
		},		
		messages: {		
			clienteID: {
				required: "Especifique Número de Cliente"
			},
			numeroTelefono: {
				required: "Especifique Número de Teléfono"
			},
			fechaNacimiento: {
				required: "Especifique Fecha de Nacimiento",
				date : 'Fecha Incorrecta'
			},
			tipoSoporteID: {
				required: "Especifique Tipo de Soporte"
			},
			comentarios:{
				required: "Especifique Comentarios"
			}
		}		
	});

	//------------ Validaciones de Controles -------------------------------------
	
	// Funcion para consultar datos del Cliente
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		
		var conPrincipal = 1;
		
		$('#numeroTelefono').val('');	
		$('#fechaNacimiento').val('');	
		$('#tipoSoporteID').val('');	
		$('#telefonoCelular').val('');

		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCliente != Constantes.CADENAVACIA && !isNaN(numCliente)) {
			clienteServicio.consulta(conPrincipal, numCliente, function(cliente) {
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
			});
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
	
	// Funcion para consultar los Tipos de Soporte
	function consultaTiposSoporte() {
		tipoLista = 2;
		
		var tipoSoporteBean = {
			'tipoSoporteID' : 0
		};
		dwr.util.removeAllOptions('tipoSoporteID'); 
		dwr.util.addOptions('tipoSoporteID', {'':'SELECCIONAR'});
		 	
		verificacionPreguntasServicio.listaCombo(tipoLista, tipoSoporteBean, function(soporte){
			dwr.util.addOptions('tipoSoporteID', soporte, 'tipoSoporteID', 'descripcion');
		});
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

});	

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
		}else{
			deshabilitaBoton('enviar', 'submit');
			$('#resAprobadas').val('0');
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
	
