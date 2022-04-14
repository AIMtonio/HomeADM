$(document).ready(function() {
	esTab = true;

	//Definicion de Constantes y Enums

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	deshabilitaBoton('limpiar','submit');

	$(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','usuarioID');
		}
    });

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});



	consultaUsuario();

	$('#limpiar').click(function() {
		consultaCheck();


	});


});
	//------------ Validaciones de la Forma -------------------------------------


	//------------ Validaciones de Controles -------------------------------------


	function consultaUsuario() {
		var numLista=11;
		var varClave='';
			usuarioServicio.listaConsulta(numLista,function(claves) {
				if (claves !=null){
					for(var i=0; i<claves.length; i++){
						varClave= claves[i].clave;

							var datosUsuario = {
								'usuarioID' : claves[i].usuarioID,
								'clave'		: varClave,
								'nombreCom'	: claves[i].nombreCompleto,
								'sucUsuario': claves[i].nombreSucurs
							};

						sesionActiva(datosUsuario);

					}
				}
			});
		}


	function sesionActiva(datosUsuario) {
		var usuarioID = datosUsuario.usuarioID;
		var claveUsuario = datosUsuario.clave;
		var nombreUsuario = datosUsuario.nombreCom;
		var estatus = 'ACTIVO';


		usuarioServicio.consultaUsuarioLogeado(claveUsuario,function(usuario) {
		var estaLogeado = usuario;

		if(estaLogeado=="S"){
			gridSesionActiva(datosUsuario)

				}

		});

	}

	function gridSesionActiva(datosUsuario){
		$('#gridSesionesActivas').show(500);
		var numeroFila = consultaFilas();
		var nuevaFila = parseInt(numeroFila) + 1;
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';

		var usuarioID = datosUsuario.usuarioID;
		var sucursalUsuario = datosUsuario.sucUsuario;
		var claveUsuario = datosUsuario.clave;
		var nombreUsuario = datosUsuario.nombreCom;
		var estatus = 'ACTIVO';

		if(numeroFila == 0){

			tds += '<td><input  id="usuarioID'+nuevaFila+'" value="'+usuarioID+'" name="usuarioID" size="13" readonly="true"/></td>';
			tds += '<td><input  id="sucursalUsuario'+nuevaFila+'" name="sucursalUsuario"   size="17" value="'+sucursalUsuario+'" readOnly="true" type="text"/></td>';
			tds += '<td><input  id="clave'+nuevaFila+'" name="clave"   size="30" value="'+claveUsuario.toUpperCase()+'" readOnly="true" type="text" onBlur="ponerMayusculas(this)"/></td>';
			tds += '<td style="display:none;"><input  id="claveR'+nuevaFila+'" name="claveR"   size="30" value="'+claveUsuario+'" readOnly="true" type="text" onBlur="ponerMayusculas(this)"/></td>';
			tds += '<td><input  id="nombreCompleto'+nuevaFila+'" name="nombreCompleto"  size="60" value="'+nombreUsuario+'"  readOnly="true" type="text"/></td>';
			tds += '<td><input  id="estatus'+nuevaFila+'" name="estatus"  size="8" value="'+estatus+'" readOnly="true" type="text" /></td>';
			tds += '<td align="center">';
			tds += '<input type="checkbox" id="aplicaCheckout'+nuevaFila+'" name="aplicaCheckout" onclick="habilitaLimpiar(this.id)"/>';
			tds += '</td>';


		} else{
			var contador = 1;
			    $('input[name=consecutivoID]').each(function() {
				contador = contador + 1;

			  });

			    tds += '<td><input  id="usuarioID'+nuevaFila+'" value="'+usuarioID+'" name="usuarioID" size="13" readonly="true"/></td>';
				tds += '<td><input  id="sucursalUsuario'+nuevaFila+'" name="sucursalUsuario"   size="17" value="'+sucursalUsuario+'" readOnly="true" type="text"/></td>';
				tds += '<td><input  id="clave'+nuevaFila+'" name="clave"   size="30" value="'+claveUsuario.toUpperCase()+'" readOnly="true" type="text" onBlur="ponerMayusculas(this)"/></td>';
				tds += '<td style="display:none;"><input  id="claveR'+nuevaFila+'" name="claveR"   size="30" value="'+claveUsuario+'" readOnly="true" type="text" onBlur="ponerMayusculas(this)"/></td>';
				tds += '<td><input  id="nombreCompleto'+nuevaFila+'" name="nombreCompleto"  size="60" value="'+nombreUsuario+'"  readOnly="true" type="text" /></td>';
				tds += '<td><input  id="estatus'+nuevaFila+'" name="estatus"  size="8" value="'+estatus+'" readOnly="true" type="text" /></td>';
				tds += '</td>';
				tds += '<td align="center">';
				tds += '<input type="checkbox" id="aplicaCheckout'+nuevaFila+'" name="aplicaCheckout" onclick="habilitaLimpiar(this.id)"/>';
				tds += '</td>';

				}
			$("#sesionesActivas").append(tds);
	 }

	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;
		});
		return totales;

	}

function selecTodoCheckout(idControl){
	var jqSelec  = eval("'#" + idControl + "'");
	var cont = 0;
	if ($(jqSelec).is(':checked')){
		$('input[name=aplicaCheckout]').each(function () {
			$(this).attr('checked', 'true');
			cont ++;
		});
	}else {
		$('input[name=aplicaCheckout]').each(function () {
		$(this).removeAttr('checked');
		});
	}
	if (cont != 0) {
		habilitaBoton('limpiar');
	}else{
		deshabilitaBoton('limpiar');
	}
}


function habilitaLimpiar(idControl){
	var cont = 0;
	var numReg = ($('#sesionesActivas >tbody >tr').length) - 1;

	$('input[name=aplicaCheckout]').each(function () {
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
		habilitaBoton('limpiar');
	}else{
		deshabilitaBoton('limpiar');
	}
}

	function consultaCheck(){
		$('input[name=aplicaCheckout]').each(function(){
			var i = this.id.substring(14);
			var jqClaveUsuario = eval("'#claveR" + i + "'");
			var valClave  = $(jqClaveUsuario).val();
			var jqcheck = eval("'#aplicaCheckout" + i + "'");
			console.log(valClave);
			if($(this).is(":checked") ){
				eliminaSessionUsu(valClave);
			}
			$('#imprimeCheque').hide();
			$('#reimprimirCheque').show();
		});
		alert("Sesion(es) de Usuario Eliminada(s) Exitosamente.");
		deshabilitaBoton('limpiar');
		$('#seleccionaTodos').removeAttr('checked');
	}

	 function eliminaSessionUsu(claveU) {
			var claveUsuario = claveU;

			usuarioServicio.eliminaSessionUsuario(claveUsuario,function(eliminaSe) {
				if(eliminaSe!=null){
					eliminaDetalle();
				}else{
					alert("El procedimiento no regresa ningun valor");
				}

			});

		}



	 function eliminaDetalle(){

		 $('input[name=aplicaCheckout]').each(function(){
			 var i = this.id.substring(14);

			 var jqClaveUsuario = eval("'#clave" + i + "'");
			 var jqClaveReal = eval("'#claveR" + i + "'");
				var jqTr = eval("'#usuarioID" + i + "'");
				var jqConsecutivoID = eval("'#sucursalUsuario" + i + "'");
				var jqcuentaAho = eval("'#aplicaCheckout" + i + "'");
				var jqcuentaDescrip = eval("'#nombreCompleto" + i + "'");
				var jqsaldoBloq = eval("'#estatus" + i + "'");
				var renglon =	eval("'#usario" + i + "'");
			 var valClave  = $(jqClaveUsuario).val();


			if($(this).is(":checked") ){

				$(jqConsecutivoID).remove();
				$(jqcuentaAho).remove();
				$(jqcuentaDescrip).remove();
				$(jqClaveUsuario).remove();
				$(jqClaveReal).remove();
				$(jqsaldoBloq).remove();
				$(jqTr).remove();
				$(renglon).remove();


			}
		  });


		}