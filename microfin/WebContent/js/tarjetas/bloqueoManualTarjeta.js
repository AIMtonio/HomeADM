function funcionExitoBloqTar() {
	if ($('#tipoTarjeta').val()==1) {
		$('#tipoTarjetaDeb').focus();
		$('#tipoTarjetaDeb').attr("checked",true);
	    $('#tipoTarjetaCred').attr("checked",false);
	    lipiaCampos();
	}
	else{
		$('#tipoTarjetaCred').focus();
		$('#tipoTarjetaDeb').attr("checked",false);
	    $('#tipoTarjetaCred').attr("checked",true);
	    lipiaCampos();
	}
	deshabilitaControl('motivoBloqID');
	deshabilitaControl('descripcion');
}


$(document).ready(function() {
		esTab = true;
		var parametroBean = consultaParametrosSession();
	      $('#fecha').val(parametroBean.fechaSucursal);
	      $('#tipoTarjetaDeb').focus();
		  $('#tipoTarjetaDeb').attr("checked",false);
		  $('#tipoTarjetaCred').attr("checked",false);

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	consultaCatalogoTarjeta();
	var catTransaccionTarjeta = {
		'alta' : '5',
		'modifica' : '2',
		'bloqTarCred':'1'
	};

	deshabilitaBoton('bloquear','submit');
	deshabilitaControl('motivoBloqID');
	deshabilitaControl('descripcion');

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
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','tarjetaDebID','funcionExitoBloqTar');
	   	deshabilitaBoton('bloquear', 'submit');
	   	$('#longitud_textarea').html('<b>0</b> de 500 caracteres');
	   	$('#longitud_textarea').css('color', '#000000');
		}
	});

	$('#coorporativo').blur(function() {
		consultaTarCoorpo(this.id);

	});
	$('#tarjetaDebID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			if ($('#tarjetaDebID').val()!='' && $('#tarjetaDebID').val()!=null) {
				if ($("#tipoTarjetaDeb").is(':checked')){
				consultaTarjeta();
				}
				else if ($("#tipoTarjetaCred").is(':checked')) {
					consultaTarjetaCred();
				}
			}
			else{
				$('#tarjetaDebID').val('');
				$('#tarjetaDebID').focus();
			}
		}
	});




	$('#bloquear').click(function() {
		var numeroTarjeta=$('#tarjetaDebID').val();
		var ayuda0= numeroTarjeta.substr(0,4);
		var ayuda1= numeroTarjeta.substr(0,8);
		var ayuda2= numeroTarjeta.substr(0,12);
		var ayuda3= numeroTarjeta.substr(0,16);

		var tarjeta1= ayuda0.substr(0,4);
		var tarjeta2= ayuda1.substr(4,8);
		var tarjeta3= ayuda2.substr(8,12);
		var tarjeta4= ayuda3.substr(12,16);

		var motivoBloq= '';
		var motivo = $('#motivoBloqID').val();

		var descripcion= '';
		var descrip = $('#descripcion').val();
		var confirmar = false;

		if(motivo == motivoBloq ){
			mensajeSis(' Especifique el Motivo de Bloqueo');
			$('#motivoBloqID').focus();
			 event.preventDefault();
		} else
			if(descrip == descripcion){
				mensajeSis(' Especifique la descripción del Bloqueo');
				$('#descripcion').focus();
				event.preventDefault();
			} else{
				confirmar=confirm('Se Bloqueará la Tarjeta: '+tarjeta1+"-"+tarjeta2+"-"+tarjeta3+"-"+ tarjeta4 +" ¿Desea Continuar?");
				if (confirmar == true) {

				if($("#tipoTarjetaDeb").is(':checked')) {
		           $('#tipoTransaccion').val(catTransaccionTarjeta.alta);
					$('#tarjetaDebID').focus();
		        }
		        if($("#tipoTarjetaCred").is(':checked')){
		        	$('#tipoTransaccion').val(catTransaccionTarjeta.bloqTarCred);
					$('#tarjetaDebID').focus();
		        }

				}else{
					event.preventDefault();
				}
			}
	});

	 $('#tarjetaDebID').bind('keyup',function(e){
		 if(this.value.length >= 2  && isNaN($('#tarjetaDebID').val())){
			if($("#tipoTarjetaDeb").is(':checked')) {
	           lista('tarjetaDebID', '1', '2','tarjetaDebID', $('#tarjetaDebID').val(),'tarjetasDevitoLista.htm');
	        }
	        else if($("#tipoTarjetaCred").is(':checked')){
	        	lista('tarjetaDebID', '1', '1','tarjetaDebID', $('#tarjetaDebID').val(),'tarjetasCreditoLista.htm');
	        }
	        else{
	           mensajeSis("Selecciona el tipo de tarjeta");
	        }
		 }
	});

	//------------ Validaciones de Controles -------------------------------------
	function consultaTarjeta() {
		var tarjetaDebID =$('#tarjetaDebID').val();
		var TarjetaDebitoCon = {
			'tarjetaDebID': $('#tarjetaDebID').val()
		};
		var consulTarjetaID = 5;
		var TarjetaActivada = 7;
		var TarjetaDebito = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if ( tarjetaDebID !=''  && esTab && !isNaN(tarjetaDebID)  && $("#tipoTarjetaDeb").is(':checked')) {
			tarjetaDebitoServicio.consulta(TarjetaDebito, TarjetaDebitoCon,function(bitacoraTarjetaDeb) {

				if (bitacoraTarjetaDeb != null){

					if (bitacoraTarjetaDeb.estatus == TarjetaActivada ){
						$('#estatus').val("TARJETA ACTIVADA");
					tarjetaDebitoServicio.consulta(consulTarjetaID, TarjetaDebitoCon,function(bitacoraTarjetaDebito) {
						if(bitacoraTarjetaDebito != null){

							habilitaBoton('bloquear','submit');
							habilitaControl('motivoBloqID');
							habilitaControl('descripcion');
							$('#tarjetaHabiente').val(bitacoraTarjetaDebito.tarjetaHabiente);
							$('#nombreCli').val(bitacoraTarjetaDebito.nombreComp);
							if (bitacoraTarjetaDebito.coorporativo == 0 || bitacoraTarjetaDebito.coorporativo == '' || bitacoraTarjetaDebito.coorporativo == null) {
								$('#corpTr').hide();
							}else {
								$('#corpTr').show();
								$('#coorporativo').val(bitacoraTarjetaDebito.coorporativo);
								consultaTarCoorpo('coorporativo');
								$('#motivoBloq').val(bitacoraTarjetaDebito.motivoBloqueo);
							}

					}
				});
				}else{
					if (bitacoraTarjetaDeb.estatus == 1) {
						mensajeSis("La Tarjeta se encuentra Importada del Lote");
					}else if (bitacoraTarjetaDeb.estatus == 6) {
						mensajeSis("La Tarjeta se encuentra Asignada a Cliente");
					}else if(bitacoraTarjetaDeb.estatus == 8) {
						mensajeSis("La Tarjeta se encuentra Bloqueada");
					}else if (bitacoraTarjetaDeb.estatus == 9) {
						mensajeSis("La Tarjeta se encuentra Cancelada");
					}else if (bitacoraTarjetaDeb.estatus == 10) {
						mensajeSis("La Tarjeta se encuentra Expirada");
					}
					$('#tarjetaDebID').val('');
					$('#estatus').val('');
					$('#tarjetaHabiente').val('');
					$('#nombreCli').val('');
					$('#coorporativo').val('');
					$('#nomCorp').val('');
					$('#motivoBloq').val('');
					$('#tarjetaDebID').focus();
					$('#motivoBloqID').val('');
					$('#descripcion').val('');
					$('#tarjetaDebID').focus();
					deshabilitaBoton('bloquear','submit');
				}
			}else{
				mensajeSis("El Número de Tarjeta no Existe");
				$('#tarjetaDebID').val('');
				$('#estatus').val('');
				$('#tarjetaHabiente').val('');
				$('#nombreCli').val('');
				$('#coorporativo').val('');
				$('#nomCorp').val('');
				$('#motivoBloq').val('');
				$('#motivoBloqID').val('');
				$('#descripcion').val('');
				$('#tarjetaDebID').focus();
				deshabilitaBoton('bloquear','submit');
			}
			});
	}

}








//------------ Consulta de tarjeta de credito -------------------------------------
function consultaTarjetaCred() {
	var tarjetaDebID =$('#tarjetaDebID').val();
	var TarjetaDebitoCon = {
		'tarjetaDebID': $('#tarjetaDebID').val()
	};
	var TarjetaDebito = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	if ( tarjetaDebID !=''  && esTab && !isNaN(tarjetaDebID)  && $("#tipoTarjetaCred").is(':checked')) {
		tarjetaCreditoServicio.consulta(TarjetaDebito, TarjetaDebitoCon,function(bitacoraTarjetaCred) {
			if (bitacoraTarjetaCred != null){
				if (bitacoraTarjetaCred.estatus == 7 ){
					$('#estatus').val("TARJETA ACTIVADA");

					tarjetaCreditoServicio.consulta(2, TarjetaDebitoCon,function(bitacoraTarjetaCredito) {
						if(bitacoraTarjetaCredito != null){
							habilitaBoton('bloquear','submit');
							habilitaControl('motivoBloqID');
							habilitaControl('descripcion');
							$('#tarjetaHabiente').val(bitacoraTarjetaCredito.tarjetaHabiente);
							$('#nombreCli').val(bitacoraTarjetaCredito.nombreComp);
							if (bitacoraTarjetaCredito.coorporativo == 0 || bitacoraTarjetaCredito.coorporativo == '' || bitacoraTarjetaCredito.coorporativo == null) {
								$('#corpTr').hide();
							}else {
								$('#corpTr').show();
								$('#coorporativo').val(bitacoraTarjetaCredito.coorporativo);
								consultaTarCoorpo('coorporativo');
								$('#motivoBloq').val(bitacoraTarjetaCredito.motivoBloqueo);
							}

					    }
				});
				}
				else{
					if (bitacoraTarjetaCred.estatus == 1) {
						mensajeSis("La Tarjeta se encuentra Importada del Lote");
					}else if (bitacoraTarjetaCred.estatus == 6) {
						mensajeSis("La Tarjeta se encuentra Asignada a Cliente");
					}else if(bitacoraTarjetaCred.estatus == 8) {
						mensajeSis("La Tarjeta se encuentra Bloqueada");
					}else if (bitacoraTarjetaCred.estatus == 9) {
						mensajeSis("La Tarjeta se encuentra Cancelada");
					}else if (bitacoraTarjetaCred.estatus == 10) {
						mensajeSis("La Tarjeta se encuentra Expirada");
					}
					$('#tarjetaDebID').val('');
					$('#estatus').val('');
					$('#tarjetaHabiente').val('');
					$('#nombreCli').val('');
					$('#coorporativo').val('');
					$('#nomCorp').val('');
					$('#motivoBloq').val('');
					$('#tarjetaDebID').focus();
					$('#motivoBloqID').val('');
					$('#descripcion').val('');
					$('#tarjetaDebID').focus();
					deshabilitaBoton('bloquear','submit');
				}

			}
			else{
				mensajeSis("El Número de Tarjeta no Existe");
				$('#tarjetaDebID').val('');
				$('#estatus').val('');
				$('#tarjetaHabiente').val('');
				$('#nombreCli').val('');
				$('#coorporativo').val('');
				$('#nomCorp').val('');
				$('#motivoBloq').val('');
				$('#motivoBloqID').val('');
				$('#descripcion').val('');
				$('#tarjetaDebID').focus();
				deshabilitaBoton('bloquear','submit');
			}
		});

	}
}



	function consultaBitacoraTarDeb(tarjetaDebID) {
		bean={
		'tarjetaDebID':tarjetaDebID
		};

		var consulBitacora = 6;
		setTimeout("$('#cajaLista').hide();", 200);
		if (  Number(tarjetaDebID)>0  && !isNaN(tarjetaDebID) ) {
			tarjetaDebitoServicio.consulta(consulBitacora, bean,function(bitacoratarDeb) {
				if(bitacoratarDeb != null){
				$('#tarjetaHabiente').val(bitacoratarDeb.tarjetaHabiente);
				$('#nombreCli').val(bitacoratarDeb.nombreComp);
				$('#coorporativo').val(bitacoratarDeb.coorporativo);
				$('#motivoBloqID').val(bitacoratarDeb.motivoBloqueo);
				$('#fecha').val(bitacoratarDeb.fechaBloqueo);
				$('#descripcion').val(bitacoratarDeb.descriBloqueo);
				}

			});
		}
	}


	function consultaTarCoorpo(idControl) {
		var jqCoorpo = eval("'#" + idControl + "'");
		var coorporativo = $(jqCoorpo).val();
		var consulTarCoorpo = 12;
		setTimeout("$('#cajaLista').hide();", 200);
		if (  Number(coorporativo)>0  && !isNaN(coorporativo) ) {
			clienteServicio.consulta(consulTarCoorpo, coorporativo,"",function(cliente) {
				if (cliente != null) {

					$('#coorporativo').val(cliente.numero);
					$('#nomCorp').val(cliente.nombreCompleto);
				} else {
					mensajeSis("No Existe el Cliente Corporativo relacionado.");
					$('#coorporativo').val('');
					$('#nomCorp').val('');
				}
			});
		}else{
			$('#coorporativo').val('');
			$('#nomCorp').val('');
		}
	}
	function consultaCatalogoTarjeta() {

		dwr.util.removeAllOptions('motivoBloqID');
		dwr.util.addOptions('motivoBloqID', {'':'SELECCIONA'});

		catalogoBloqueoCancelacionTarDebitoServicio.listaCombo( 3, function(motivos){
		dwr.util.addOptions('motivoBloqID', motivos, 'motCanBloID', 'descripcion');

		});
	}

	$('#formaGenerica').validate({
		rules: {

			descripcion: {
				required: true,
				maxlength: 500

			},


		},

		messages: {

			descripcion: {
				required: 'Especificar el Motivo de Bloqueo',
				maxlength: 'Máximo 500 Caracteres'
			},



		}
	});

	$(".contador").each(function(){
		var longitud = $(this).val().length;
			$(this).parent().find('#longitud_textarea').html('<b>'+longitud+'</b> de 500 caracteres');
			$(this).keyup(function(){
				var nueva_longitud = $(this).val().length;
				$(this).parent().find('#longitud_textarea').html('<b>'+nueva_longitud+'</b> de 500 caracteres');
				if (nueva_longitud == "500") {
					$('#longitud_textarea').css('color', '#ff0000');
				}else{
					$('#longitud_textarea').css('color', '#000000');
				}
				});
			});
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}

});

function lipiaCampos() {
	$('#tarjetaDebID').val('');
	$('#estatus').val('');
	$('#tarjetaHabiente').val('');
	$('#nombreCli').val('');
	$('#descripcion').val('');
	$('#motivoBloqID').val('');
	$('#coorporativo').val('');
	$('#nomCorp').val('');

}
$('#tipoTarjetaDeb').click(function() {
	lipiaCampos();
	$('#tipoTarjetaCred').attr("checked",false);
	$('#tipoTarjeta').val('1');
	$('#tarjetaDebID').focus();

});
$('#tipoTarjetaCred').click(function() {
	lipiaCampos();
	$('#tipoTarjetaDeb').attr("checked",false);
	$('#tipoTarjeta').val('2');
	$('#tarjetaDebID').focus();


});

//funcion que se ejecuta cuando el resultado fue exito
function funcionExitoBloqueoTar(){
	deshabilitaBoton('bloquear', 'submit');
	$('#tarjetaDebID').focus();
	$('#tarjetaDebID').val('');
	$('#estatus').val('');
	$('#tarjetaHabiente').val('');
	$('#nombreCli').val('');
	$('#coorporativo').val('');
	$('#nomCorp').val('');
	$('#motivoBloqID').val('');
	$('#descripcion').val('');
	deshabilitaControl('motivoBloqID');
	deshabilitaControl('descripcion');
}
// funcion que se ejecuta cuando el resultado fue error
// diferente de cero
function funcionErrorBloqueoTar(){

}