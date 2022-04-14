var catTransClaves= {
		'grabar' : 1
	};
	
	var catClavesLis = {
		'listaGrid' : 1
	};
	var catClavesCon = {
		'principal' : 1,
		'foranea' : 2,
		'fechaActual' : 3,
		'datosMatriz' : 10,
		'fechaExterna':5,
		'externa':14
	};
	
	$(document).ready(function() {
	esTab = true;
	//Definicion de Constantes y Enums  
	
	//------------ Msetodos y Manejo de Eventos -----------------------------------------	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$(':text').focus(function() {	
	 	esTab = false;
	});
		
	//llenarAnio();
	//consultaDatos();
	ComboCompanias();
	$('#grabar').click(function() {		
	 	$('#tipoTransaccion').val(catTransClaves.grabar);
	});
	
	 $('#desplegado1').change(function() {
		 if($('#desplegado1').val()!=''){
		 	 	$('#desplegado').val($('#desplegado1').val());
		 		llenarAnio();
				consultaDatos();
		 }

	 });

	 $('#desplegado1').blur(function() {
		 if($('#desplegado1').val()!=''){
	 	 	$('#desplegado').val($('#desplegado1').val());
	 		llenarAnio();
			consultaDatos();
		 }
	 });
	
	$('#anio').change(function () {
		consultaClaves();
	});
	
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			if (validaForma() == true) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID', 'funcionExito', 'funcionError');
			}
		}
   });
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			anio: {
		        required: true,
			}
		},
		messages: {
			anio: {
		        required: 'Especificar el Año'
			}
		}
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	function consultaDatos() {
		var paramBean ={
			'empresaID' : '1',
			'rutaArchivos':$('#desplegado1').val()
		};
		parametrosSisServicio.consulta(14, paramBean, function (parametros) {
			if (parametros != null) {
				$('#clienteID').val(parametros.nombreCortoInst);
				$('#nombreCliente').val(parametros.nombreInstitucion);
				consultaClaves();
			}
		});
	}
		
	
	
	function llenarAnio(){
		var conClaveBean ={
			'clienteID' : '',
			'origenDatos':$('#desplegado1').val()
		};
		controlClaveServicio.consulta(catClavesCon.fechaExterna, conClaveBean, function (ctrlClave) {
			if (ctrlClave != null) {
				var mesSucursal = parseInt(ctrlClave.mes);
				var anioSucursal = parseInt(ctrlClave.anio);
				var i=0;
				anioSucursal = anioSucursal + 1;	
				document.forms[0].anio.clear;
				document.forms[0].anio.length = 3;
				for (i=0; i < (document.forms[0].anio.length); i++){
					document.forms[0].anio[i].text = anioSucursal-i;
					document.forms[0].anio[i].value = anioSucursal-i;
				}
				document.forms[0].anio[1].selected = true;
				consultaClaves();
			}
		});
		
	}
	
	function ComboCompanias() {

		dwr.util.removeAllOptions('desplegado1');
		dwr.util.addOptions('desplegado1', {
			'' : 'SELECCIONA'
		});

			companiasServicio.listaCombo(1,function(companias) {
			
					for ( var j = 0; j < companias.length; j++) {
							$('#desplegado1').append(new Option(companias[j].desplegado,companias[j].origenDatos, true, true));
							$('#desplegado1').val('').selected = true;						
					}
				
			});

			
		}
}); 

	function agregaElemento() {
		var numFilas = $("tr[name=registro]").length;
		var id = 0;
		if (numFilas > 0) {
			id  = $("tr[name=registro]:last").attr('id').substring(8);
		} 
		var numeroFila = parseInt(id) + 1;
		var tds = '<tr id="registro' + numeroFila + '" name="registro" >';
		var mes= "";
		if (numeroFila == 1) {	mes = "ENERO";	}
		else if (numeroFila == 2) { mes = "FEBRERO"; }	
		else if (numeroFila == 3) { mes = "MARZO"; }
		else if (numeroFila == 4) { mes = "ABRIL"; }
		else if (numeroFila == 5) { mes = "MAYO"; }
		else if (numeroFila == 6) { mes = "JUNIO"; }
		else if (numeroFila == 7) { mes = "JULIO"; }
		else if (numeroFila == 8) { mes = "AGOSTO"; }
		else if (numeroFila == 9) { mes = "SEPTIEMBRE"; }
		else if (numeroFila== 10) { mes = "OCTUBRE"; }
		else if (numeroFila== 11) { mes = "NOVIEMBRE"; }
		else if (numeroFila== 12) { mes = "DICIEMBRE"; }
	
		if (numeroFila >= 13) {
			alert("Máximo de Meses Agregados");
		} else {
			tds += '<td>';
			tds += '<select id="mes" name="lisMes">';
			tds += '<option value="">SELECCIONA</option>';
			tds += '<option value="1">ENERO</option>';
			tds += '<option value="2">FEBRERO</option>';
			tds += '<option value="3">MARZO</option>';
			tds += '<option value="4">ABRIL</option>';
			tds += '<option value="5">MAYO</option>';
			tds += '<option value="6">JUNIO</option>';
			tds += '<option value="7">JULIO</option>';
			tds += '<option value="8">AGOSTO</option>';
			tds += '<option value="9">SEPTIEMBRE</option>';
			tds += '<option value="10">OCTUBRE</option>';
			tds += '<option value="11">NOVIEMBRE</option>';			
			tds += '<option value="12">DICIEMBRE</option>';
			tds += '</select>';
			tds += '</td>';
			tds += '<td><input type="text" id="claveKey'+numeroFila+'"  name="lisClaveKey" path="lisClaveKey" size="60" maxlength="100" /></td>';
			tds += '<td align="center"> <input type="button" id="'+numeroFila+'" name="agrega" class="btnAgrega" onclick="agregaElemento(this)"/>';
			tds += '</tr>';
		}		
		$("#tablaClaves").append(tds);
	}

	function funcionExito() {
		consultaClaves();
	}
	function funcionError() {

	}

function grabaFormaTransaccionRetrollamada(event, idForma, idDivContenedor, idDivMensaje,
		inicializaforma, idCampoOrigen, funcionPostEjecucionExitosa,
		funcionPostEjecucionFallo) {
	//consultaSesion();
	var jqForma = eval("'#" + idForma + "'");
	var jqContenedor = eval("'#" + idDivContenedor + "'");
	var jqMensaje = eval("'#" + idDivMensaje + "'");
	var url = $(jqForma).attr('action');
	var resultadoTransaccion = 0;	

	quitaFormatoControles(idForma);
	//No descomentar la siguiente linea
	//event.preventDefault();
	$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');   
	$(jqContenedor).block({
		message: $(jqMensaje),
		css: {border:		'none',
			background:	'none'}
	});
	// Envio de la forma

	$.post( url, serializaForma(idForma), function( data ) {
		if(data.length >0) {
			$(jqMensaje).html(data);
			var exitoTransaccion = $('#numeroMensaje').val();
			resultadoTransaccion = exitoTransaccion; 
			/*	if (exitoTransaccion == 0 && inicializaforma == 'true' ){
					inicializaForma(idForma, idCampoOrigen);	
				}  validar */
			var campo = eval("'#" + idCampoOrigen + "'");
			if($('#consecutivo').val() != 0){
				$(campo).val($('#consecutivo').val());
			}
			//Ejecucion de las Funciones de CallBack(RetroLlamada)
			if (exitoTransaccion == 0 && funcionPostEjecucionExitosa != '' ){
				esTab=true;

				eval( funcionPostEjecucionExitosa + '();' );
			}else{
				eval( funcionPostEjecucionFallo + '();' );
			}
			//TODO la de fallo
		}
	});
	return resultadoTransaccion;
}

function consultaClaves(){
		var clienteID = $('#clienteID').val();
		var anio = $("#anio").val();
		if (clienteID != '' && anio != ''){
			var params = {};
			params['tipoLista'] = catClavesLis.listaGrid;
			params['clienteID'] = clienteID;
			params['anio'] = anio;
			params['origenDatos'] = $('#desplegado1').val();
			$.post("gridClavesActivacion.htm", params, function(data){
				if(data.length >0) {
					$('#gridClaves').html(data);
					$('#gridClaves').show();
				}else{
					$('#gridClaves').html("");
					$('#gridClaves').show();
				}
			});
		}else{
			$('#gridClaves').hide();
			$('#gridClaves').html('');
		}
	}

function validaForma(){
	var lisMeses = "";
	var lisSelect = "";
	var contador = 1;
	$('input[name=lisMes]').each(function () {
		id = this.id.substring(3);
		if (contador != 1){
			lisMeses = lisMeses + "," + this.value;
		}else{
			lisMeses = lisMeses + this.value;	
		}
		contador++;
	});
	
	$('select[name=lisMes]').each(function () {
		if (lisMeses == ""){
			lisMeses = this.value;
		}else{
			lisMeses = lisMeses + ","+ this.value ;
		}
	});
	
	var arrLis = lisMeses.split(",");
	var aux = 0;
	var procede = 1;
	var mostrarAlert = 1;
	for(var i=0; i< arrLis.length; i++){
		for(var a= 0; a< arrLis.length; a++){
			if (i != a) {
				if (arrLis[i] == arrLis[a]) {
					aux++;
				}
			}
		}
		if (aux > 1){
			if (arrLis[i] == 1) {	mes = "ENERO";	}
			else if (arrLis[i] == 2) { mes = "FEBRERO"; }	
			else if (arrLis[i] == 3) { mes = "MARZO"; }
			else if (arrLis[i] == 4) { mes = "ABRIL"; }
			else if (arrLis[i] == 5) { mes = "MAYO"; }
			else if (arrLis[i] == 6) { mes = "JUNIO"; }
			else if (arrLis[i] == 7) { mes = "JULIO"; }
			else if (arrLis[i] == 8) { mes = "AGOSTO"; }
			else if (arrLis[i] == 9) { mes = "SEPTIEMBRE"; }
			else if (arrLis[i]== 10) { mes = "OCTUBRE"; }
			else if (arrLis[i]== 11) { mes = "NOVIEMBRE"; }
			else if (arrLis[i]== 12) { mes = "DICIEMBRE"; }
			procede = 0;
			mostrarAlert = 0;
			break;
		}
	}
	if (procede == 0){
		alert("La Clave del Mes de "+ mes +" ya ha sido Capturada.");
		return false;
	}else {
		return true;
	}

}