$(document).ready(function() {
		esTab = false;
		var parametroBean = consultaParametrosSession();
	      $('#fechaser').val(parametroBean.fechaSucursal);
	      $('#tipoTarjetaDeb').focus();
		  $('#tipoTarjetaDeb').attr("checked",false);
		  $('#tipoTarjetaCred').attr("checked",false);

	//------------ Metodos y Manejo de Eventos -----------------------------------------
 //limpiarFormularioBloqueoTarjeta();
	consultaCatalogoTarjeta();
	var catTransaccionTarjeta = {
			'alta' : '7',
			'modifica' : '2',
			'cancelacion' : '3',
		};

	deshabilitaBoton('cancelar','submit');
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
	   	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tarjetaDebID', 'funcionExitoCancelacionTar','funcionErrorCancelacionTar');
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
					consultaTarjetaDebitoCancel();
				}
				else if ($("#tipoTarjetaCred").is(':checked')) {
					consultaTarjetaCreditoCancel();
				}
			}
			else{
				lipiaCampos();
				$('#tarjetaDebID').focus();
			}
		}
	});

	$('#cancelar').click(function() {
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
			mensajeSis(' Especifique el Motivo de Cancelación');
			 $('#motivoBloqID').focus();
			 event.preventDefault();

		} else
		if(descrip == descripcion){
			mensajeSis(' Especifique la Descripción de la Cancelación');
			 $('#descripcion').focus();
			 event.preventDefault();
		} else{
			confirmar=confirm('Se Cancelará la Tarjeta: '+tarjeta1+"-"+tarjeta2+"-"+tarjeta3+"-"+ tarjeta4 +" ¿Desea Continuar?");
			if (confirmar == true) {
				if($("#tipoTarjetaDeb").is(':checked')) {
		            $('#tipoTransaccion').val(catTransaccionTarjeta.alta);
					$('#tarjetaDebID').focus();
		        }
		        if($("#tipoTarjetaCred").is(':checked')){
		        	$('#tipoTransaccion').val(catTransaccionTarjeta.cancelacion);
					$('#tarjetaDebID').focus();
		        }


			  }else{
				  event.preventDefault();
			  }
		}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	 $('#tarjetaDebID').bind('keyup',function(e){
		 if(this.value.length >= 2  && isNaN($('#tarjetaDebID').val())){
			if($("#tipoTarjetaDeb").is(':checked')) {
	           lista('tarjetaDebID', '1','8','tarjetaDebID', $('#tarjetaDebID').val(),'tarjetasDevitoLista.htm');
	        }
	        else if($("#tipoTarjetaCred").is(':checked')){
	        	lista('tarjetaDebID', '1','4','tarjetaDebID', $('#tarjetaDebID').val(),'tarjetasCreditoLista.htm');
	        }
	        else{
	           mensajeSis("Selecciona el tipo de tarjeta");
	        }
		 }
	});


	//------------ Validaciones de Controles -------------------------------------
	function consultaTarjetaDebitoCancel() {
		var tarjetaDebID =$('#tarjetaDebID').val();
		var TarjetaDebitoCon = {
			'tarjetaDebID': $('#tarjetaDebID').val()
		};
		var consulTarjetaID = 10;
	    var TarjetaDebito=1;
	    setTimeout("$('#cajaLista').hide();", 200);
		if ( tarjetaDebID !=''  && !isNaN(tarjetaDebID) && esTab && $("#tipoTarjetaDeb").is(':checked') ) {
			tarjetaDebitoServicio.consulta(TarjetaDebito, TarjetaDebitoCon,function(bitacoraTarjetaDeb) {
				if ( bitacoraTarjetaDeb != null ){
					tarjetaDebitoServicio.consulta(consulTarjetaID, TarjetaDebitoCon,function(tarBloq){
						if( tarBloq != null ){
							$('#tarjetaDebID').val(tarBloq.tarjetaDebID);
							$('#estatus').val(tarBloq.estatus);
							$('#tarjetaHabiente').val(tarBloq.tarjetaHabiente);
							$('#nombreCli').val(tarBloq.nombreComp);
							$('#motivoBloqID').val('');
							$('#descripcion').val('');
							habilitaControl('motivoBloqID');
							habilitaControl('descripcion');
							if ( tarBloq.coorporativo == '' || tarBloq.coorporativo == 0 || tarBloq.coorporativo == null ) {
								$('#cteCorpTr').hide();
							}else{
								$('#cteCorpTr').show();
								$('#coorporativo').val(tarBloq.coorporativo);
								consultaTarCoorpo('coorporativo');
							}
							if (tarBloq.tarjetaHabiente == '' || tarBloq.tarjetaHabiente == 0 || tarBloq.tarjetaHabiente == null) {
								$('#clienteTr').hide();
							}else {
								$('#clienteTr').show();
							}

							habilitaBoton('cancelar','submit');
						}else {
							if (bitacoraTarjetaDeb.estatus == 9) {
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
							$('#motivoBloqID').val('');
							$('#descripcion').val('');
							$('#tarjetaDebID').focus();

							deshabilitaBoton('cancelar','submit');
						}
					});
				}
				else{
					mensajeSis("La Tarjeta No Existe");
					$('#tarjetaDebID').val('');
					$('#estatus').val('');
					$('#tarjetaHabiente').val('');
					$('#nombreCli').val('');
					$('#coorporativo').val('');
					$('#nomCorp').val('');
					$('#motivoBloqID').val('');
					$('#descripcion').val('');
					$('#tarjetaDebID').focus();
				}

				});


		}
		else{

			if (tarjetaDebID == '' && !isNaN(tarjetaDebID)) {
				inicializaForma('formaGenerica');
				deshabilitaBoton('desbloquear', 'submit');
				$('#tipoTarjetaDeb').focus();
				$('#tipoTarjetaDeb').attr("checked",true);
			    $('#tipoTarjetaCred').attr("checked",false);
			}else {
				inicializaForma('formaGenerica');
				deshabilitaBoton('desbloquear', 'submit');
				$('#tipoTarjetaDeb').focus();
				$('#tipoTarjetaDeb').attr("checked",true);
			    $('#tipoTarjetaCred').attr("checked",false);
			}

		}
	}



// CONSULTA A TARJETA DE CREDITO

function consultaTarjetaCreditoCancel() {
	var tarjetaDebID =$('#tarjetaDebID').val();
	var TarjetaDebitoCon = {
		'tarjetaDebID': $('#tarjetaDebID').val()
	};

    var TarjetaCredito=1;
    setTimeout("$('#cajaLista').hide();", 200);
	if ( tarjetaDebID !=''  && !isNaN(tarjetaDebID) && esTab && $("#tipoTarjetaCred").is(':checked') ) {
		tarjetaCreditoServicio.consulta(TarjetaCredito, TarjetaDebitoCon,function(bitacoraTarjetaCred) {
			if ( bitacoraTarjetaCred != null ){
				tarjetaCreditoServicio.consulta(4, TarjetaDebitoCon,function(tarBloq){
					if( tarBloq != null ){
						$('#tarjetaDebID').val(tarBloq.tarjetaID);
						$('#estatus').val(tarBloq.estatus);
						$('#tarjetaHabiente').val(tarBloq.tarjetaHabiente);
						$('#nombreCli').val(tarBloq.nombreComp);
						$('#motivoBloqID').val('');
						$('#descripcion').val('');
						habilitaControl('motivoBloqID');
						habilitaControl('descripcion');
						if ( tarBloq.coorporativo == '' || tarBloq.coorporativo == 0 || tarBloq.coorporativo == null ) {
							$('#cteCorpTr').hide();
						}else{
							$('#cteCorpTr').show();
							$('#coorporativo').val(tarBloq.coorporativo);
							consultaTarCoorpo('coorporativo');
						}
						if (tarBloq.tarjetaHabiente == '' || tarBloq.tarjetaHabiente == 0 || tarBloq.tarjetaHabiente == null) {
							$('#clienteTr').hide();
						}else {
							$('#clienteTr').show();
						}

						habilitaBoton('cancelar','submit');
					}else {
						if (bitacoraTarjetaCred.estatus == 9) {
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
						$('#motivoBloqID').val('');
						$('#descripcion').val('');
						$('#tarjetaDebID').focus();

						deshabilitaBoton('cancelar','submit');
					}
				});
			}

			else{

				mensajeSis("La Tarjeta No Existe");
				$('#tarjetaDebID').val('');
				$('#estatus').val('');
				$('#tarjetaHabiente').val('');
				$('#nombreCli').val('');
				$('#coorporativo').val('');
				$('#nomCorp').val('');
				$('#motivoBloqID').val('');
				$('#descripcion').val('');
				$('#tarjetaDebID').focus();
			}


		});


	}
	else{
		if (tarjetaDebID == '' && !isNaN(tarjetaDebID)) {
			inicializaForma('formaGenerica');
			deshabilitaBoton('desbloquear', 'submit');
			$('#tipoTarjetaDeb').focus();
			$('#tipoTarjetaDeb').attr("checked",true);
		    $('#tipoTarjetaCred').attr("checked",false);
		}else {
			inicializaForma('formaGenerica');
			deshabilitaBoton('desbloquear', 'submit');
			$('#tipoTarjetaDeb').focus();
			$('#tipoTarjetaDeb').attr("checked",true);
		    $('#tipoTarjetaCred').attr("checked",false);
		}

	}

}








	function consultaTarCoorpo(idControl) {
		var jqCoorpo = eval("'#" + idControl + "'");
		var coorporativo = $(jqCoorpo).val();
		var consulTarCoorpo = 12;
		setTimeout("$('#cajaLista').hide();", 200);
		if ( coorporativo!=''  && !isNaN(coorporativo) ) {
			clienteServicio.consulta(consulTarCoorpo, coorporativo,"",function(cliente) {
				if (cliente != null) {

					$('#coorporativo').val(cliente.numero);
					$('#nomCorp').val(cliente.nombreCompleto);
				} else {
					mensajeSis("No Existe el Corporativo relacionado.");
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
		catalogoBloqueoCancelacionTarDebitoServicio.listaCombo( 5, function(motivos){
			dwr.util.addOptions('motivoBloqID', motivos, 'motCanBloID', 'descripcion');
		});
	}
	$(".contador").each(function(){
		var longitud = $(this).val().length;
			$(this).parent().find('#longitud_textarea').html('<b>'+longitud+'</b> de 500 caracteres');
			$(this).keyup(function(){
				var nueva_longitud = $(this).val().length;
				$(this).parent().find('#longitud_textarea').html('<b>'+nueva_longitud+'</b> de 500 caracteres');
				if (nueva_longitud == "500") {
					$('#longitud_textarea').css('color', '#ff0000');
				}
				});
			});

	$('#formaGenerica').validate({
		rules: {
			descripcion: {
				required: true,
				maxlength: 500
			},
		},
		messages: {
			descripcion: {
				required: 'Especifique el Motivo de Bloqueo',
				maxlength: 'Máximo 250 Caracteres'
			},
		}
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
				if (comprobarSiBisisesto(anio)){ numDias=29;}else{ numDias=28;};
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




// función para cargar los valores de la lista recibe el
// el control que es el campo donde secargara el valor y el valorCompleto es un valor extra. que se podra usar en cualquier campo
function cargaValorListaTarjetaDeb(control, valor,valorCompleto) {
	consultaSesion();
	jqControl = eval("'#" + control + "'");
	$(jqControl).val(valor);
	$(jqControl).focus();
	setTimeout("$('#cajaLista').hide();", 200);

}

function lipiaCampos() {
	$('#tarjetaDebID').val('');
	$('#estatus').val('');
	$('#tarjetaHabiente').val('');
	$('#nombreCli').val('');
	$('#descripcion').val('');
	$('#motivoBloqID').val('');
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
function funcionExitoCancelacionTar(){
	deshabilitaBoton('bloquear', 'submit');
	$('#tarjetaDebID').focus();
//
	$('#estatus').val('');
	$('#tarjetaHabiente').val('');
	$('#nombreCli').val('');
	$('#coorporativo').val('');
	$('#nomCorp').val('');
	$('#motivoBloq').val('');
	$('#fecha').val('');
	$('#motivoBloqID').val('');
	$('#descripcion').val('');
	if ($('#tipoTarjeta').val()==1) {
		$('#tipoTarjetaDeb').attr("checked",true);
	    $('#tipoTarjetaCred').attr("checked",false);
	    lipiaCampos();
	}
	else{
		$('#tipoTarjetaDeb').attr("checked",false);
	    $('#tipoTarjetaCred').attr("checked",true);
	    lipiaCampos();
	}
	deshabilitaBoton('cancelar','submit');
	deshabilitaControl('motivoBloqID');
	deshabilitaControl('descripcion');

}

// funcion que se ejecuta cuando el resultado fue error
// diferente de cero
function funcionErrorCancelacionTar(){
	if ($("#tipoTarjetaCred").is(':checked')) {
		$('#tipoTarjetaDeb').attr("checked",false);
	    $('#tipoTarjetaCred').attr("checked",true);
	}
	else{
		$('#tipoTarjetaDeb').attr("checked",true);
	    $('#tipoTarjetaCred').attr("checked",false);
	}
	$('#tarjetaDebID').focus();

}