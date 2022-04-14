var tipoFirmas="";
$(document).ready(function() {
	esTab = true;
	
	$("#producCreditoID").focus();

	//Definicion de Constantes y Enums  
	var catTipoTransaccionProdCredito = {
			'grabar': 1
	};

	var catTipoConsultaProdCredito = {
			'principal'	: 1

	};	

	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('grabar', 'submit');
	agregaFormatoControles('formaGenerica'); 
	$('#esGrupal').hide();
	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionTransaccionExito','funcionTransaccionFallo');

		}
	});

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#producCreditoID').bind('keyup',function(e){
		lista('producCreditoID', '2', '15', 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');
	}); 

	$('#producCreditoID').blur(function(){
		validaProductoCredito(this.id); 
		agregaFormatoControles('formaGenerica');
	});

	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionProdCredito.grabar);
		consultaGridEsquemaComi();
		return guardarCodigos();


	});

	$('#formaGenerica').validate({
		rules: {

			producCreditoID: {
				required: true
			},
			tipoPagoComFalPago: {
				required: true
			},
			criterioComFalPag: {
				required: true
			},
			montoMinComFalPag: {
				required: true
			},
			tipCobComFalPago: {
				required: true
			},
			perCobComFalPag: {
				required: true
			}

		},
		messages: {

			producCreditoID: {
				required: 'Introduzca Numero del Producto de Credito'
			},
			tipoPagoComFalPago: {
				required: 'Especificar Tipo de Pago'
			},
			criterioComFalPag: {
				required: 'Especificar Base de Cálculo'
			},
			montoMinComFalPag: {
				required: 'Especificar Monto Mínimo'
			},
			tipCobComFalPago: {
				required: 'Especificar Tipo Comisión'
			},
			perCobComFalPag: {
				required: 'Especificar Periodicidad de Cobro'
			}
		}
	});

	function validaProductoCredito(control) {
		var numProdCredito = $('#producCreditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProdCredito != '' && !isNaN(numProdCredito) && esTab){

			habilitaBoton('grabar', 'submit'); 
			var prodCreditoBeanCon = { 
					'producCreditoID':$('#producCreditoID').val()
			};
			productosCreditoServicio.consulta(catTipoConsultaProdCredito.principal,prodCreditoBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#descripcion').val(prodCred.descripcion);
					$('#criterioComFalPag').val(prodCred.criterioComFalPag).selected = true;
					$('#montoMinComFalPag').val(prodCred.montoMinComFalPag);					

					$('#tipCobComFalPago').val(prodCred.tipCobComFalPago);
					$('#perCobComFalPag').val(prodCred.perCobComFalPag);
					$('#tipoPagoComFalPago').val(prodCred.tipoPagoComFalPago).selected = true;
					
					if(prodCred.esGrupal == 'S'){
						$('#esGrupal').show();
						$('#prorrateoComFalPag').val(prodCred.prorrateoComFalPag);
					}else{
						$('#esGrupal').hide();
					}
					consultaGridEsquemaComi();

					if(prodCred.estatus == 'I'){
						mensajeSis("El Producto "+ prodCred.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						$('#producCreditoID').focus();
						deshabilitaBoton('grabar', 'submit');
						deshabilitaBoton('agregar', 'submit'); 
					}else{
						habilitaBoton('grabar', 'submit');
						habilitaBoton('agregar', 'submit'); 
					}

				}else{
					mensajeSis('El Producto de Crédito no Existe');
					$('#producCreditoID').focus();
					$('#producCreditoID').val('');
					$('#tipCobComFalPago').val('');
					$('#perCobComFalPag').val('');
					$('#prorrateoComFalPag').val('');
					$('#tipoPagoComFalPago').val('');

					$('#descripcion').val('');
					$('#criterioComFalPag').val('');
					$('#montoMinComFalPag').val('');
					$('#gridEsquemaComision').html("");
					deshabilitaBoton('grabar', 'submit');
					inicializaForma('formaGenerica','producCreditoID' );									
				}

			}); 

		}
	}

	function consultaGridEsquemaComi(){
		if($('#producCreditoID').val()!= ""){
			var params = {};
			params['tipoLista'] = 1;
			params['producCreditoID'] =$('#producCreditoID').val();
			$.post("ConsultaGridEsquemaComi.htm", params, function(data){		
				if(data.length >0) {
					$('#gridEsquemaComision').html(data);
					$('#gridEsquemaComision').show();
					agregaFormatoControles('esquemaComisionGrid');

				}else{
					$('#gridEsquemaComision').html("");
					$('#gridEsquemaComision').show();
				}
			});
		}	
	}

	function guardarCodigos(){	

		var mandar = verificarvacios();
		var montoIniID = "";
		var montoFinID = "";
		var comisionID = "";
		var retorno = false;
		if(mandar!=1){   		  		
			var numCodigo = consultaFilasEsquema();
			$('#datosGrid').val("");
			for(var i = 1; i <= numCodigo; i++){
				montoIniID = eval("'#montoInicial"+i+"'");
				montoFinID = eval("'#montoFinal"+i+"'");
				comisionID = eval("'#comision"+i+"'");
				if(i == 1){

					$('#datosGrid').val($('#datosGrid').val() +
							$(montoIniID).asNumber()+ ']' +
							$(montoFinID).asNumber()+ ']' +
							document.getElementById("tipoComision"+i+"").value + ']' +
							$(comisionID).asNumber());



				}else{
					$('#datosGrid').val($('#datosGrid').val() + '[' +
							$(montoIniID).asNumber()+ ']' +
							$(montoFinID).asNumber()+ ']' +
							document.getElementById("tipoComision"+i+"").value + ']' +
							$(comisionID).asNumber());
				}	
			}
			retorno = true;

		}
		else{
			mensajeSis("Faltan Datos");
			//inicializaForma('esquemaComisionGrid');
			//consultaGridEsquemaComi();
			agregaFormatoControles('esquemaComisionGrid'); 
			retorno = false;
		}

		return retorno;
	}



	function verificarvacios(){	
		quitaFormatoControles('esquemaComisionGrid');
		var numCodig = consultaFilasEsquema();
		$('#datosGrid').val("");
		for(var i = 1; i <= numCodig; i++){

			var idmi = document.getElementById("montoInicial"+i+"").value;
			if (idmi ==""){
				document.getElementById("montoInicial"+i+"").value='';				
				$(idmi).addClass("error");
				return 1; 
			}
			var idmfe = document.getElementById("montoFinal"+i+"").value;
			if (idmfe =="" || idmfe==0){
				document.getElementById("montoFinal"+i+"").value='';
				$(idmfe).addClass("error");
				return 1; 
			}
			var idtc = document.getElementById("tipoComision"+i+"").value;
			if (idtc =="" || idtc == 0){
				document.getElementById("tipoComision"+i+"").value='';				
				$(idtc).addClass("error");	
				return 1; 
			}
			var idco = document.getElementById("comision"+i+"").value;
			if (idco =="" || idco == 0){
				document.getElementById("comision"+i+"").value='';
				$(idco).addClass("error");
				return 1; 
			}
		}
		agregaFormatoControles('esquemaComisionGrid'); 
	}
});


//----------------------- Funciones del Grid Esquema Comision -----------------------------------


function consultaFilasEsquema(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
	});
	return totales;
}


//funcion para agregar y quitar formato moneda y tasa
function cambioFormatoComision(noFila){
	var numCodig = consultaFilasEsquema();
	var varComisionID ="";
	for(var i = 1; i <= numCodig; i++){
		var actualID = document.getElementById("tipoComision"+i+"").value;

		varComisionID = eval("'#comision"+i+"'");
		if(actualID == 'M'){

			esMoneda = true;
			$(varComisionID).attr('esMoneda',true);	
			$(varComisionID).removeAttr('esTasa');
			agregaFormatoMoneda('formaGenerica');
		}
		else{
			esTasa = true;
			$(varComisionID).attr('esTasa',true);	
			$(varComisionID).removeAttr('esMoneda');
			agregaFormatoTasa('formaGenerica');
		}

	}

	ValidaSuperiorComision(noFila);

}

function agregaNuevoEsquema(){
	agregaFormatoControles('esquemaComisionGrid'); 
	var numeroFila =consultaFilasEsquema();
	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">'; 	  
	if(numeroFila == 0){
		tds += '<td><input  id="consecutivo'+nuevaFila+'" name="consecutivo" size="6"  value="1" autocomplete="off"  disabled="true" /></td>';
		tds += '<td><input type="text" id="montoInicial'+nuevaFila+'" name="montoInicial" size="14"  value="" autocomplete="off" onkeyPress="return Validador(event);" esMoneda="true" onBlur="ValidaSuperiorInicio(this)" onchange="agregaFormato(this.id)" /></td>';	//onchange="agregaFormato(this.id)"
		tds += '<td><input type="text" id="montoFinal'+nuevaFila+'" name="montoFinal" size="14" value="" autocomplete="off" onkeyPress="return Validador(event);" esMoneda="true" onBlur="ValidaSuperior('+nuevaFila+')" onchange="agregaFormato(this.id)" /></td>';	
		tds += '<td>';
		tds += '<select name="tipoComision"  id="tipoComision'+nuevaFila+'" autocomplete="off" onchange="cambioFormatoComision('+nuevaFila+')" >';
		tds += '<option value="M">MONTO</option>';
		tds += '<option value="P">PORCENTAJE (1/100)</option>';
		tds += '</select>';
		tds += '</td>';
		tds += '<td><input type="text" id="comision'+nuevaFila+'" name="comision" size="14" value="" autocomplete="off" onkeyPress="return Validador(event);" esTasa = "true" onBlur="ValidaSuperiorComision('+nuevaFila+')"  onchange="cambioFormatoComision()"/></td>';
	} else{    		
		var valor = parseInt(document.getElementById("consecutivo"+numeroFila+"").value) + 1;// agrega nuevo valor al consecutivo siguiente
		var sumMontoFinal = eval("'#montoFinal"+numeroFila+"'");// se obtiene el numero
		var valor2 = $(sumMontoFinal).asNumber()+ 0.01; // agrega suma 0.01 al monto inicial siguiente
		tds += '<td><input  id="consecutivo'+nuevaFila+'" name="consecutivo" size="6" value="'+valor+'" autocomplete="off" disabled="true" /></td>';
		tds += '<td><input type="text" id="montoInicial'+nuevaFila+'" name="montoInicial" size="14" value="'+valor2+'" autocomplete="off" disabled="true" onkeyPress="return Validador(event);" esMoneda="true"  onBlur="ValidaSuperiorInicio(this)" onchange="agregaFormato(this.id)" /></td>';	
		tds += '<td><input type="text" id="montoFinal'+nuevaFila+'" name="montoFinal" size="14" value="" autocomplete="off" onkeyPress="return Validador(event);" esMoneda="true" onBlur="ValidaSuperior('+nuevaFila+')" onchange="agregaFormato(this.id)" /></td>';	
		tds += '<td>';
		tds += '<select name="tipoComision"  id="tipoComision'+nuevaFila+'" autocomplete="off" onchange="cambioFormatoComision('+nuevaFila+')" >';
		tds += '<option value="M">MONTO</option>';
		tds += '<option value="P">PORCENTAJE (1/100)</option>';
		tds += '</select>';
		tds += '</td>';
		tds += '<td><input type="text" id="comision'+nuevaFila+'" name="comision" size="14" value=""  autocomplete="off" onkeyPress="return Validador(event);"   onBlur="ValidaSuperiorComision('+nuevaFila+')" onchange="cambioFormatoComision()"/></td>';
	}
	tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarEsquema(this.id)"/>';
	tds += ' <input type="button" name="agrega" id="agrega'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoEsquema()"/></td>';
	tds += '</tr>';
	document.getElementById("numeroEsquema").value = nuevaFila;    	
	$("#miTabla").append(tds);

	agregaFormatoControles('esquemaComisionGrid');
	agregaFormatoControles('formaGenerica'); 
	return false;		
}

function eliminarEsquema(control){	

	var contador = 0 ;
	var numeroID = control;
	var jqRenglon = eval("'#renglon" + numeroID + "'");
	var jqConsecutivo = eval("'#consecutivo" + numeroID + "'");	
	var jqMontoInicial = eval("'#montoInicial" + numeroID + "'");
	var jqMontoFinal= eval("'#montoFinal" + numeroID + "'");
	var jqTipoComision = eval("'#tipoComision" + numeroID + "'");
	var jqComision= eval("'#comision" + numeroID + "'");
	var jqElimina = eval("'#" + numeroID + "'");
	var jqAgrega = eval("'#agrega" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqRenglon).remove();
	$(jqConsecutivo).remove();
	$(jqMontoInicial).remove();
	$(jqMontoFinal).remove();
	$(jqTipoComision).remove();
	$(jqComision).remove();
	$(jqElimina).remove();
	$(jqAgrega).remove();

	// se asigna el numero de 
	$('#numeroEsquema').val(consultaFilasEsquema());	
	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;

	$('tr[name=renglon]').each(function() {

		numero= this.id.substr(7,this.id.length);	

		var jqRenglonCiclo = eval("'renglon" + numero+ "'");	
		var jqNumeroCiclo = eval("'consecutivo" + numero + "'");		
		var jqMontoInicialCiclo = eval("'montoInicial" + numero + "'");	
		var jqMontoFinalCiclo = eval("'montoFinal" + numero + "'");	
		var jqTipoComisionCiclo = eval("'tipoComision" + numero + "'");
		var jqComisionCiclo= eval("'comision" + numero + "'");
		var jqEliminaCiclo = eval("'" + numero + "'");
		var jqAgregaCiclo = eval("'agrega" + numero + "'");

		document.getElementById(jqNumeroCiclo).setAttribute('value',  contador);		
		document.getElementById(jqRenglonCiclo).setAttribute('id', "renglon" + contador);//	renglon	
		document.getElementById(jqNumeroCiclo).setAttribute('id', "consecutivo" + contador);// consecutivo
		document.getElementById(jqMontoInicialCiclo).setAttribute('id', "montoInicial" + contador);//montoInicial
		document.getElementById(jqMontoFinalCiclo).setAttribute('id', "montoFinal" + contador);// montoFinal
		document.getElementById(jqTipoComisionCiclo).setAttribute('id', "tipoComision" + contador);// tipoComision
		document.getElementById(jqComisionCiclo).setAttribute('id', "comision" + contador);// comision
		document.getElementById(jqEliminaCiclo).setAttribute('id',  contador);	
		document.getElementById(jqAgregaCiclo).setAttribute('id',"agrega"+  contador);// agrega

		contador = parseInt(contador + 1);	

	});

}


//Valida que la Comision actual no sea menor a la anterior
function ValidaSuperiorComision(noFila){

	var jqComiAct = eval("'#comision" + noFila+ "'");
	var jqtipComisionAct = eval("'#tipoComision" +noFila+ "'");

	var comisionAct =$(jqComiAct).asNumber();
	var tipoComiAct =$(jqtipComisionAct).val();



	if($(jqComiAct).val()!=''){ 


		$('input[name=elimina]').each(function() {

			var valorTipoComision=eval("'#tipoComision" + this.id+ "'");
			var valorComision=eval("'#comision" +this.id+ "'");
			var valor =$(valorTipoComision).val();
			var valorc =$(valorComision).asNumber();


			if(jqComiAct!=valorComision){
				if(valor==tipoComiAct && valor=='M'){

					if (comisionAct <= valorc ){
						mensajeSis("Debe ser mayor a "+valorc+".00");
						$(jqComiAct).val("");
						$(jqComiAct).focus();
						return false;
					}
					if($(jqComiAct).val() <= 0 ){
						mensajeSis("Debe ser mayor a cero");
						$(jqComiAct).val("");
						$(jqComiAct).focus();
						return false;

					}
				}
				if(valor==tipoComiAct && valor=='P'){

					if (comisionAct <= valorc ){
						mensajeSis("El Porcentaje debe de ser Mayor al "+valorc+" %");
						$(jqComiAct).val("");
						$(jqComiAct).focus();
						return false;
					}
					if(comisionAct  <= 0 ){
						mensajeSis("Debe ser mayor a 0%");
						$(jqComiAct).val("");
						$(jqComiAct).focus();
						return false;
					}

					if(comisionAct  >= 101){
						mensajeSis("El Porcentaje no debe de ser Mayor al 100%");
						$(jqComiAct).val("");
						$(jqComiAct).focus();
						return false;

					}


				}
			}


		});	}
	if(comisionAct  >= 101 && tipoComiAct=='P'){
		mensajeSis("El Porcentaje no debe de ser Mayor al 100%");
		$(jqComiAct).val("");
		$(jqComiAct).focus();
		return false;

	}
	if(noFila==1){
		if($(jqComiAct).val()!=''){ 
			if(tipoComiAct=='P'){
				if(comisionAct  >= 101){
					mensajeSis("El Porcentaje no debe de ser Mayor al 100%");
					$(jqComiAct).val("");
					$(jqComiAct).focus();
					return false;

				}
				if($(jqComiAct).val() <= 0 ){
					mensajeSis("Debe ser mayor a 0%");
					$(jqComiAct).val("");
					$(jqComiAct).focus();
					return false;
				}
			}
		}
	}
	if(tipoComiAct=='M'){
		if($(jqComiAct).val() <= 0 ){
			mensajeSis("Debe ser mayor a cero");
			$(jqComiAct).val("");
			$(jqComiAct).focus();
			return false;

		}

	}
}

//Valida el Monto Final debe ser Mayor al Monto Inicial
function ValidaSuperior(noFila){

	var jqMontoInicialAct = eval("'#montoInicial" + noFila+ "'");
	var jqMontoFinalAct = eval("'#montoFinal" + noFila+ "'");

	var montoIniAct =$(jqMontoInicialAct).asNumber();
	var montoFinAct =$(jqMontoFinalAct).asNumber();

	if(montoFinAct<=montoIniAct){
		mensajeSis("El Monto Final debe ser Mayor al Monto Inicial ");
		$(jqMontoFinalAct).focus();

	}


}


//Valida el Monto Inicial no sea mayor o igual al Final
function ValidaSuperiorInicio(control){
	if (!isNaN(control.value) && control.value != ''){

		var numeroID = control.id;

		var siguienteID = (parseFloat(numeroID.replace("montoInicial",""))+1);
		var anteriorID = (parseFloat(numeroID.replace("montoInicial",""))-1);

		var jqMontoSig = eval("'#montoFinal" + String(siguienteID) + "'");
		var jqMontoAct = eval("'#montoFinal" + String(anteriorID) + "'");
		control.value = parseFloat(control.value);

		if (parseFloat(control.value) <= parseFloat($(jqMontoAct).val()) ){
			mensajeSis("El Monto Inicial debe ser Mayor al Monto Final ");
			control.focus();
			return false;
		}else{
			if(parseInt($(jqMontoAct).val()) > 0 ){
				if (parseInt(control.value) <= parseInt($(jqMontoAct).val()) ){
					mensajeSis("El Monto Inicial debe ser Mayor al Monto Final");
					control.focus();
					return false;
				}
			}
			if($(jqMontoSig).val()!= undefined) {
				$(jqMontoSig).val(parseInt(control.value)+1);
			}
		}

	}
}

function Validador(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {
		if (key==8|| key == 46)	{ 
			return true;
		}
		else
			mensajeSis("sólo se pueden ingresar números");
		return false;

	}

}

function agregaFormato(idControl){

	var jControl = eval("'#" + idControl + "'"); 

	$(jControl).bind('keyup',function(){
		$(jControl).formatCurrency({
			colorize: true,
			positiveFormat: '%n', 
			roundToDecimalPlace: -1
		});
	});

	$(jControl).blur(function() {
		$(jControl).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
	});

	$(jControl).formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});			
}


function funcionTransaccionExito(){
	$('#gridEsquemaComision').html("");
	deshabilitaBoton('grabar', 'submit');
	inicializaForma('formaGenerica','producCreditoID' );	
	$('#tipCobComFalPago').val('');
	$('#perCobComFalPag').val('');
	$('#prorrateoComFalPag').val('');
	$('#tipoPagoComFalPago').val('');

	$('#descripcion').val('');
	$('#criterioComFalPag').val('');
	$('#montoMinComFalPag').val('');
}

function funcionTransaccionFallo(){
	
}