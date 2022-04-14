var nomClavePresupID = "";

var catTipoTransaccionTipoClav = {
	'elimina' : '1',
	'agrega' : '2',
	'modifica' : '3'
};


$(document).ready(function(){
	esTab = true;

	$("#nomTipoClavePresupID").focus();
	deshabilitaBoton('graba', 'submit');
	deshabilitaBoton('elimina', 'submit');
	deshabilitaBoton('modifica', 'submit');
	document.getElementById("reqClaveSI").checked = false;
	document.getElementById("reqClaveNO").checked = false;
	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({submitHandler : function(event) {
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','nomTipoClavePresupID','exitoTransParametro','falloTransParametro');
		}
	});

	/***********MANEJO DE EVENTOS******************/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab = true;
		}
	});

	$('#graba').click(function() {
		if(document.getElementById("reqClaveSI").checked == false && document.getElementById("reqClaveNO").checked == false){
			mensajeSis("Especifique si el Tipo Clave Presupuestal Requiere Clave.");
			return false;
		}

		$('#tipoTransaccion').val(catTipoTransaccionTipoClav.agrega);
	});

	$('#elimina').click(function() {
		if(nomClavePresupID != null && nomClavePresupID != '' && nomClavePresupID > 0){
			mensajeSis("El Tipo Clave Presupuestal a Eliminar se encuentra Asociada con una Clave Presupuestal");
			$("#nomTipoClavePresupID").focus();
			return false;
		}

		$('#tipoTransaccion').val(catTipoTransaccionTipoClav.elimina);
	});

	$('#modifica').click(function() {
		if(document.getElementById("reqClaveSI").checked == false && document.getElementById("reqClaveNO").checked == false){
			mensajeSis("Especifique si el Tipo Clave Presupuestal Requiere Clave.");
			return false;
		}

		$('#tipoTransaccion').val(catTipoTransaccionTipoClav.modifica);
	});


/*========================================  CONSULTA DEL LISTADO DE PRODUCTO DE CREDITO ================================ */
	$('#nomTipoClavePresupID').bind('keyup',function(e){
		lista('nomTipoClavePresupID', '2', '1', 'descripcion', $('#nomTipoClavePresupID').val(), 'tipoClavePresupListaVista.htm');
	});

	$('#nomTipoClavePresupID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		var nomTipoClavePresupID = $('#nomTipoClavePresupID').val();
		if(esTab){
			if(nomTipoClavePresupID == 0 && nomTipoClavePresupID != '' && nomTipoClavePresupID != null){
				document.getElementById("reqClaveSI").checked = false;
				document.getElementById("reqClaveNO").checked = false;
				$('#descripcion').val("");
				habilitaBoton('graba', 'submit');
				deshabilitaBoton('elimina', 'submit');
				deshabilitaBoton('modifica', 'submit');
			} else if(nomTipoClavePresupID > 0 && nomTipoClavePresupID != '' && nomTipoClavePresupID != null){
				document.getElementById("reqClaveSI").checked = false;
				document.getElementById("reqClaveNO").checked = false;
				$('#descripcion').val("");
				consultaTipoClavePresup(this.id);

			}else if(nomTipoClavePresupID != ''){
				$('#descripcion').val("");
				document.getElementById("reqClaveSI").checked = false;
				document.getElementById("reqClaveNO").checked = false;
				deshabilitaBoton('graba', 'submit');
				deshabilitaBoton('elimina', 'submit');
				deshabilitaBoton('modifica', 'submit');
				mensajeSis("Espeficique un Tipo Clave Presupuestal Valido");
			}
		}
	});

	$('#formaGenerica').validate({
		rules : {
			nomTipoClavePresupID: {
				required: true
			},
			descripcion: {
				required: true
			}
		},

		messages : {
			nomTipoClavePresupID: {
				required: 'Especifique el Número de Tipo Clave Presupuestal'
			},
			descripcion: {
				required: 'Especifique la Descripción del Tipo Clave Presupuestal'
			},
		}
	});
});

	function exitoTransParametro(){
		document.getElementById("reqClaveSI").checked = false;
		document.getElementById("reqClaveNO").checked = false;
		deshabilitaBoton('graba', 'submit');
		deshabilitaBoton('elimina', 'submit');
		deshabilitaBoton('modifica', 'submit');
		$('#descripcion').val("");

		if($('#tipoTransaccion').val() == catTipoTransaccionTipoClav.elimina){
			$('#nomTipoClavePresupID').val("");
		}
	}

	function falloTransParametro(){

	}

	/*==================  FUNCIONALIDAD QUE CONSULTA EL TIPO DE CLAVE PRESUPUESTAL ============================== */
	function consultaTipoClavePresup(control) {
		var tipoClavePresupID = $('#nomTipoClavePresupID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoClavePresupID != '' && !isNaN(tipoClavePresupID)){
			var tipoClavePresupBean = { 
				'nomTipoClavePresupID': tipoClavePresupID
			};
			tipoClavePresupServicio.consulta(1,tipoClavePresupBean,function(tipoClavePresp) {
				if(tipoClavePresp != null){
					$('#nomTipoClavePresupID').val(tipoClavePresp.nomTipoClavePresupID);
					$('#descripcion').val(tipoClavePresp.descripcion);
					var reqClave = tipoClavePresp.reqClave;

					if(reqClave == "S"){
						document.getElementById("reqClaveSI").checked = true;
						document.getElementById("reqClaveNO").checked = false;
					}
					if(reqClave == "N"){
						document.getElementById("reqClaveNO").checked = true;
						document.getElementById("reqClaveSI").checked = false;
					}

					nomClavePresupID = tipoClavePresp.nomClavePresupID;
					deshabilitaBoton('graba', 'submit');
					habilitaBoton('elimina', 'submit');
					habilitaBoton('modifica', 'submit');
				}else{
					$('#descripcion').val("");
					document.getElementById("reqClaveNO").checked = true;
					document.getElementById("reqClaveSI").checked = false;
					deshabilitaBoton('graba', 'submit');
					deshabilitaBoton('elimina', 'submit');
					deshabilitaBoton('modifica', 'submit');
					mensajeSis('El Tipo de Clave Presupuestal no Existe');
				}
			}); 
		}
	}
