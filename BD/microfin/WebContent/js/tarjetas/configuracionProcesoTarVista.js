$(document).ready(function() {
	$("#servidor").focus();
	
	parametros = consultaParametrosSession();

	esTab = true;
	
	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	var TipoTransaccion = {
		'modificacion' : 1			
	};
	var catTipoConsultaCorreo = {
		'principal': 1,
		'foranea': 2
	};
	var tipoActualizacionTransaccion = {
		'actualizaConfFtp' : 1,
		'actualizaConfHora' : 2,
		'actualizaConfCorreo':3

	};

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {			
		}
	});
	// ------------ Metodos y Manejo de Eventos
	deshabilitaBoton('modificarFTP', 'submit');
	deshabilitaBoton('modificarConfHora', 'submit');
	deshabilitaBoton('modificaConfCorreo', 'submit');
	consultaConfiguracion();
	consultaDestinatarios();
	
	agregaFormatoControles('formaGenerica');
	///nueva consulta
	//lista

	/******* VALIDACIONES DE LA FORMA *******/	
	$.validator.setDefaults({submitHandler: function(event) {		
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','configFTPProsaID','funcionExito', 'funcionError');
	}});
	
	$('#modificarFTP').click(function() {	
		$('#tipoTransaccionFTP').val(tipoActualizacionTransaccion.actualizaConfFtp);		
	});


	$('#modificarConfHora').click(function() {	
		$('#tipoTransaccionFTP').val(tipoActualizacionTransaccion.actualizaConfHora);		
	});

	$('#modificaConfCorreo').click(function() {	
		$('#tipoTransaccionFTP').val(tipoActualizacionTransaccion.actualizaConfCorreo);		
	});
	$('#usuarioRemitente').blur(function () {
			esTab = true;
			validaCorreoRemi(this.id);
	});

	$('#usuarioRemitente').bind('keyup', function (e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#usuarioRemitente').val();
			lista('usuarioRemitente', '1', '1', camposLista, parametrosLista, 'listacorreo.htm');
		}
	});
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			servidor:{
				required: true
			},
			puerto:{
				required: true,
				digits: true,
  				min: 0,
			},
			usuario:{
				required: true
			},
			contrasenia: {
				required: true
			},
			horaInicio: {
  				required: true,
  				digits: true,
  				min: 1,
  				max: 24
    		},
    		intervaloMin: {
  				required: true,
  				digits: true,
  				min: 1,
  				max: 60
    		},
    		numIntentos: {
  				required: true,
  				digits: true,
  				min: 1,
  				max: 100
    		},
			mensajeCorreo: {
				required: true
			}
			
		},
		messages: {
			servidor:{
				required: 'Campo requerido'
			},
			puerto:{
				required: 'Campo requerido',
				digits: 'Solo admite numeros',
  				min: 'Pueto incorrecto',
			},
			usuario:{
				required: 'Campo requerido',
			},
			contrasenia: {
				required: 'Campo requerido'
			},
			horaInicio: {
  				required: 'Campo Requerido',
  				digits: 'Solo puede ingresar numeros',
  				min: 'No puede ingresar numeros negativos',
  				max: 'No existen horas mayores a 24'
    		},
    		intervaloMin: {
  				required: 'Campo requerido',
  				digits: 'Solo se pueden ingresar numeros',
  				min: 'No puede ingresar numeros negativos',
  				max: 'Minutos solo validas hasta 60'
    		},
    		numIntentos: {
  				required: 'Campo requerido',
  				digits: 'Solo admite numeros',
  				min: 'Mínimo un intento',
  				max: 'Máximo un 100 intentos'
    		},
			mensajeCorreo: {
				required: 'Contenido del correo obligatorio'
			}
		
		}
	});
});

	//Consulta descripcion firma
	function consultaConfiguracion(){
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoConsulta = 1;	
		var num = 1;		
		var bean={
				'configFTPProsaID':num
		};
		
		if(num != '' && !isNaN(num)){
				configuracionProcesoTarServicio.consulta(tipoConsulta,bean, { async: false, callback: function(configuracion) { 
				if(configuracion!=null){
					$('#servidor').val(configuracion.servidor);
					$('#puerto').val(configuracion.puerto);	
					$('#usuario').val(configuracion.usuario);	
					$('#contrasenia').val(configuracion.contrasenia);	
					$('#ruta').val(configuracion.ruta);	
					$('#horaInicio').val(configuracion.horaInicio);
					$('#intervaloMin').val(configuracion.intervaloMin);
					$('#numIntentos').val(configuracion.numIntentos);
					$('#mensajeCorreo').val(configuracion.mensajeCorreo);
					$('#usuarioRemitente').val(configuracion.usuarioRemitente);
					var usuarioRemi = $('#usuarioRemitente').val();
					if(usuarioRemi != 0){
						validaCorreoRemi('usuarioRemitente');
					}
					
					habilitaBoton('modificarFTP', 'submit');
					habilitaBoton('modificarConfHora', 'submit');
					habilitaBoton('modificaConfCorreo', 'submit');
				
					
				}else{
					mensajeSis("No existe el tipo de configuración");
					deshabilitaBoton('modificarFTP', 'submit');
					deshabilitaBoton('modificarConfHora', 'submit');
					deshabilitaBoton('modificaConfCorreo', 'submit');
				}
			}});
		}else{
			mensajeSis("Texto invalido");
		}
	
	}
	
	function consultaDestinatarios() {
			
		var params = {};
		var num = 1;
		params['tipoLista'] = num;
		//params['clienteID'] = clienteID;
		if (num != '' && !isNaN(num)){
			$.post("altaDestinatariosCProsa.htm", params, function(dat){
				if(dat.length >0) {
					$('#gridDestinatarios').html(dat);
					$('#gridDestinatarios').show();
				}else{
					$('#gridDestinatarios').html("");
					$('#gridDestinatarios').show();
				}
			});
		}
		
	}


	function validaCorreoRemi(idControl){
		var jqCorreo = eval("'#" + idControl + "'");
		var numCorreo = $(jqCorreo).val();
		var catConsultaPrin = 1;
		
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCorreo != '' && !isNaN(numCorreo) && esTab) {
			if (numCorreo == '0') {
				mensajeSis("Correo no valido");
				$('#usuarioRemitente').val('');

			} else {

				var TarEnvioCorreoParamBeanCon = {
					'remitenteID': numCorreo
				};

				tarEnvioCorreoParamServicio.consulta(catConsultaPrin, TarEnvioCorreoParamBeanCon, function (Correo) {

					if (Correo != null) {
						$('#correoRemitente').val(Correo.correoSalida);
						$('#correoRemitente').val(Correo.correoSalida);
						
					} else {
						mensajeSis("No Existe el Correo");
						$('#usuarioRemitente').val('');
						$('#usuarioRemitente').val(focus);
					}
				});
			}
		}

	}
	
function listaDestina(value, id) {
	if (value.length >= 2) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = $('#'+id).val();
		//lista(id, '1', '1', camposLista, parametrosLista, 'listacorreo.htm');
		lista(id, '3', '3', camposLista, parametrosLista, 'listacorreo.htm');
	}
}
//revisar funcionalidad
/*function esRepetido(id){
	var jqControl = eval("'#"+id+"'");
	var usuarioAct = $(jqControl).val();
		$('input[name=usuarioDest]').each(function(index, tag) {
			var usuarioReg = $(tag).val();
			console.log(usuarioReg);
			console.log(usuarioAct);
			if (usuarioReg == usuarioAct) {
				console.log(true);
				return true;
			}
		});
	return false;
}*/
function blurDestinatario(id, idCorreo){
	esTab = true;
	//validaCorreoUsuario(id, idCorreo);
	validaCorreoUsuario(id, idCorreo);

	
	
}
function validaCorreoUsuario(id, idCorreo){
	//var jqControl = eval("#'"+id+"'");
	//var jqCorreo = eval("#'"+idCorreo +"'");
	var numCorreo = $("#"+id).val();
	var catConsultaPrin = 2;
	
	setTimeout("$('#cajaLista').hide();", 200);

	if (numCorreo != '' && !isNaN(numCorreo) && esTab) {
		if (numCorreo == '0') {

			$("#"+idCorreo +"").val('');
			mensajeSis("No Existe el Correo");

		} else {

			var TarEnvioCorreoParamBeanCon = {
				'remitenteID': numCorreo
			};

		tarEnvioCorreoParamServicio.consulta(catConsultaPrin, TarEnvioCorreoParamBeanCon, function (Correo) {

				if (Correo != null) {
					$("#"+idCorreo +"").val(Correo.descripcion);
				} else {
					mensajeSis("No Existe el Correo");
					//limpiarCampos();
					$("#"+idCorreo +"").val('');
					$("#"+idCorreo +"").val(focus);
				}
			});
		}
	}
}
function validaCorreo(idControl, idCorreo) {
	var jqControl = eval("'#"+idControl+"'");
	var jqCorreo = eval("'#"+idCorreo +"'");
	var numCorreo = $(jqControl).val();
	var catConsultaPrin = 1;
	
	setTimeout("$('#cajaLista').hide();", 200);

	if (numCorreo != '' && !isNaN(numCorreo) && esTab) {
		if (numCorreo == '0') {

			inicializaForma('formaGenerica', id);

		} else {

			var TarEnvioCorreoParamBeanCon = {
				'remitenteID': numCorreo
			};

			tarEnvioCorreoParamServicio.consulta(catConsultaPrin, TarEnvioCorreoParamBeanCon, function (Correo) {

				if (Correo != null) {
					$(jqCorreo).val(Correo.correoSalida);
				} else {
					mensajeSis("No Existe el Correo");
					//limpiarCampos();
					$(jqCorreo).val('');
					$(jqCorreo).val(focus);
				}
			});
		}
	}
}
function agregaDestinatario(ultimoIndex){
	var existenGrids = false;
	var contador=parseInt(ultimoIndex);
	$('input[name=elimina]').each(function() {
		//var jqConsecutivo = document.getElementById(index);
		existenGrids = true;
		contador++;
	});
	var nuevaFila = parseInt(contador);
	var tds = '<tr id="renglon'+nuevaFila+'" name="renglon">';
	    tds +='<td>';
		//tds += '<input id="usuarioDest'+nuevaFila+'" name="usuarioDest" size="10" type="text" onkeyup="listaDestina('+this.value+',usuarioDest'+nuevaFila+');" onblur="blurDestinatario(usuarioDest+'nuevaFila'+, correo'+nuevaFila+');"/>';
		tds += '<input id="usuarioDest'+nuevaFila+'" name="usuarioDest" size="10" type="text" onkeyup="listaDestina(this.value,\'usuarioDest'+nuevaFila+'\');" onblur="blurDestinatario(\'usuarioDest'+nuevaFila+'\', \'correo'+nuevaFila+'\');" maxlength = "11"/>';
		tds	+='</td>';

		tds +='<td>';
		tds	+='<input id=correo'+nuevaFila+' name="correoSalida" size="50" type="text"/>';
		tds	+=	'<td align="center">	<input type="button" name="elimina" id="'+nuevaFila+'" class="btnElimina" onclick="eliminaDestinatario(\'renglon'+nuevaFila+'\');"/> </td>';
		tds +='<td align="center">	<input type="button" name="agrega" id="'+nuevaFila+'" class="btnAgrega" onclick="agregaDestinatario('+nuevaFila+')"/> </td>';
		tds +='</td>';
	tds += '</tr>';
	$("#tablaLista").append(tds);


}
function eliminaDestinatario(index) {
	var existenGrids = false;
	var contador=0;
	var renglon = document.getElementById(index);
	$('input[name=elimina]').each(function() {
		//var jqConsecutivo = document.getElementById(index);
		existenGrids = true;
		contador++;
	});
	if(contador > 1 ){
		$(renglon).remove();
	}else {
		$('input[name=usuarioDest]').val('');
		$('input[name=correoSalida]').val('');
	}
	

}
//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	//inicializaPantalla();
	consultaConfiguracion();
	consultaDestinatarios();	
	//funcionCargaComboTiposActivos();

		
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
	agregaFormatoControles('formaGenerica');
} 