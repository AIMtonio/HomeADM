var montoMin =0.0;
var montoMax =0.0;
var cobraGarantiaFinanciada = "N";
var bonificaFOGA = "N";
var bonificaFOGAFI = "N";
var filasFOGA = 0;
var filasFOGAFI = 0;

var tipoTransaccion= {
			'alta' : '1',
			'actualizacion': '2',
			'elimina':'3',
			'altaFOGAFI' : '4',
			'actualizaFOGAFI' : '5',
			'eliminaFOGAFI' : '6',
			'eliminaGeneral' : '7'

		};



$(document).ready(function() {
	$('#producCreditoID').focus();

	// Se consulta si la Institución cobra Garantía Financiada
	consultaCobraGarantiaFinanciada();

	// Se valida si la institución cobra Garantía Financiada
	if(cobraGarantiaFinanciada == "S"){

		// Cuando la institución cobre Garantía Financiada, se muestran los campos que correspondan a Garantía Líquida y Garantía Financiada
		$("#garFogafiLblTD").show();
		$("#garFogafiTD").show();
		$("#garantiaFinanciadaLib").show();// Liberar Garantía Líquida
	}

	else{
		// Cuando la institución no cobre Garantía Financiada, se muestran los campos que solo correspondan a Garantía Líquida.
		$("#garantiaNoFinanciadaLbl").show();// Liberar Garantía Líquida
		$("#garantiaNoFinanciada").show();

	}

	/*le da formato de moneda, calendario, etc */
	agregaFormatoControles('formaGenerica');



	$("#divGrid").hide();// Cuando se ingresa por primera vez a la pantalla, el grid de la garantía liquida se oculta
	$("#divGridFOGAFI").hide();	// Cuando se ingresa por primera vez a la pantalla, el grid de FOGAFI se oculta

	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('grabarFOGAFI', 'submit');
	listaProductosCredito();

	$('#grabar').click(function () {
		var requiereGarantia = $("#garantiaLiquida").val();
		if(requiereGarantia == 'S'){
			 numFilas = consultaFilas();
			 if(parseInt(numFilas)>0){
				 $("#tipoTransaccion").val(tipoTransaccion.alta);
			 }else{
				 $("#tipoTransaccion").val(tipoTransaccion.elimina);
			 }

		}
		else{
			$("#tipoTransaccion").val(tipoTransaccion.actualizacion);
		}
	});


	// Se asigna la transacción a realizar cuando se le de click al botón grabarFOGAFI (Botón del Grid FOGAFI)
	$('#grabarFOGAFI').click(function () {
		var requiereGarantia = $("#garantiaFOGAFI").val();
		if(requiereGarantia == 'S'){
			 numFilas = consultaFilasFOGAFI();
			 if(parseInt(numFilas)>0){
				 $("#tipoTransaccion").val(tipoTransaccion.altaFOGAFI);
			 }else{
				 $("#tipoTransaccion").val(tipoTransaccion.eliminaFOGAFI);
			 }

		}
		else{
			$("#tipoTransaccion").val(tipoTransaccion.actualizaFOGAFI);
		}
	});

	// Se asgina la transacción a realizar cuando se le de click al botón grabarGral (Botón que solo será visible cuando no se requieren ambas garantías)
	$('#grabarGral').click(function () {

		$("#tipoTransaccion").val(tipoTransaccion.eliminaGeneral);

	});


	$('#producCreditoID').change(function () {
		consultaProductoCredito(this.value);
	});

	$('#producCreditoID').blur(function () {
		 consultaProductoCredito(this.value);
	});

	$('#garantiaLiquida').change(function () {
		var producCredito = $("#producCreditoID").val();
		if(this.value == 'S' && parseInt(producCredito) > 0 ){
			$("#divGrid").show(400);
			mostrarGridEsquemas(producCredito);


			if(cobraGarantiaFinanciada == "S"){
				filasFOGA = 1;
				muestraCamposFOGA();
				$("#tablaBtn").hide();
			}
		}
		else{
			var requiereGarantia = $("#garantiaFOGAFI").val();

			$('#liberarGaranLiq').val("N").selected = true;
			$("#divGrid").hide(400);
			habilitaBoton('grabar', 'submit');

			if(cobraGarantiaFinanciada == "S"){
				filasFOGAFI = 0;
				ocultaCamposFOGA();
			}

			if(requiereGarantia == 'N'){
				$("#tablaBtn").show();
			}
			else{
				$("#tablaBtn").hide();
			}
		}
	});


	// Acción a ejecutarse cuando se active el evento change del campo Garantía Líquida Financiada
	$('#garantiaFOGAFI').change(function () {
		var producCredito = $("#producCreditoID").val();
		var requiereGarantia = $("#garantiaLiquida").val();

		if(this.value == 'S' && parseInt(producCredito) > 0 ){
			$("#divGridFOGAFI").show(400);
			muestraCamposFOGAFI();
			mostrarGridEsquemasFOGAFI(producCredito);
			filasFOGAFI = 1;
			$("#tablaBtn").hide();

		}
		else{
			$('#liberarGaranLiq').val("N").selected = true;
			$("#divGridFOGAFI").hide(400);
			ocultaCamposFOGAFI();
			habilitaBoton('grabarFOGAFI', 'submit');
			filasFOGAFI = 0;

			if(requiereGarantia == 'N'){
				$("#tablaBtn").show();
			}
			else{
				$("#tablaBtn").hide();
			}
		}
	});


	// Select utilizado cuando no se cobra la garantia FOGA/FOGAFI
	$('#liberarGaranLiq1').change(function () {

		var valor = this.value;
		$('#liberarGaranLiq').val(valor);

	});

	// Select utilizado cuando se cobra la garantia FOGA/FOGAFI
	$('#liberarGaranLiq2').change(function () {
		var valor = this.value;
		$('#liberarGaranLiq').val(valor);

	});


	$('#bonificacionFOGA').change(function () {
		var valor = this.value;
		bonificaFOGA 	= valor;
		columnaBonifica('bonificacionFOGA');
	});

	$('#bonificacionFOGAFI').change(function () {
		var valor = this.value;
		bonificaFOGAFI	= valor;
		columnaBonifica('bonificacionFOGAFI');
	});
	/*esta funcion esta en forma.js, verifica que el mensaje d error o exito aparezcan correctamente y que realizara despues de cada caso */
	$.validator.setDefaults({
	    submitHandler: function(event) {
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID',
		    			'funcionExitoTransaccion','funcionFalloTransaccion');

	    }
	 });


	/* =============== VALIDACIONES DE LA FORMA ================= */
		$('#formaGenerica').validate({
			rules: {
				producCreditoID :{
					required:true
				},
				garantiaLiquida :{
					required: true
				},
				bonificacionFOGA:{
					required: function(e){
						if ($('#garantiaLiquida').val()=="S" && cobraGarantiaFinanciada == 'S'){
							return true;
						} else {
							return false;
						}
					}
				},
				desbloqAutFOGA:{
					required: function(e){
						if ($('#garantiaLiquida').val()=="S" && cobraGarantiaFinanciada == 'S') {
							return true;
						} else {
							return false;
						}
					}
				},
				garantiaFOGAFI : {
					required : function(e){
						if (cobraGarantiaFinanciada=="S") {
							return true;
						} else {
							return false;
						}
					}
				},
				modalidadFOGAFI : {
					required : function(e){
						if($('#garantiaFOGAFI').val()=="S"){
							return true;
						} else {
							return false;
						}
					}
				},
				bonificacionFOGAFI : {
					required : function(e){
						if($('#garantiaFOGAFI').val()=="S" && cobraGarantiaFinanciada == 'S'){
							return true;
						} else {
							return false;
						}
					}
				},
				desbloqAutFOGAFI : {
					required : function(e){
						if($('#garantiaFOGAFI').val()=="S" && cobraGarantiaFinanciada == 'S'){
							return true;
						} else {
							return false;
						}
					}
				},
				liberarGaranLiq2 : {
					required : true
				}
			},
			messages: {
				producCreditoID :{
					required:'Seleccione Producto de Crédito'
				},
				garantiaLiquida:{
					required : 'Seleccionar una Opción'
				},
				bonificacionFOGA:{
					required : 'Seleccionar una Opción'
				},
				desbloqAutFOGA:{
					required : 'Seleccionar una Opción'
				},
				garantiaFOGAFI:{
					required : 'Seleccionar una Opción'
				},
				modalidadFOGAFI:{
					required : 'Seleccionar una Opción'
				},
				bonificacionFOGAFI:{
					required : 'Seleccionar una Opción'
				},
				desbloqAutFOGAFI:{
					required : 'Seleccionar una Opción'
				},
				liberarGaranLiq2:{
					required : 'Seleccionar una Opción'
				}
			}
		});



	/* =================== FUNCIONES ========================= */

	/* Llena el combos de Productos de Crédito */
	function listaProductosCredito(){
		dwr.util.removeAllOptions('producCreditoID');
		dwr.util.addOptions('producCreditoID', {'':'SELECCIONAR'});

		productosCreditoServicio.listaCombo(16, function(productosCredito){
			dwr.util.addOptions('producCreditoID', productosCredito, 'producCreditoID', 'descripcion');

		});

	}

	function consultaProductoCredito(producCreditoID) {
		var tipoCon = 5;
		var productoCreditoBean = {
				'producCreditoID'	:producCreditoID
		};

		productosCreditoServicio.consulta(tipoCon,productoCreditoBean,{ async: false, callback:function(respuesta) {
					if (respuesta != null) {
						$('#garantiaLiquida').val(respuesta.requiereGarantia);
						$('#liberarGaranLiq').val(respuesta.liberarGaranLiq);
						$('#liberarGaranLiq1').val(respuesta.liberarGaranLiq);
						$('#liberarGaranLiq2').val(respuesta.liberarGaranLiq);

						// Se le asigna el valor a cada campo
						$('#bonificacionFOGA').val(respuesta.bonificacionFOGA);
						$('#desbloqAutFOGA').val(respuesta.desbloqAutFOGA);
						$('#garantiaFOGAFI').val(respuesta.garantiaFOGAFI);
						$('#modalidadFOGAFI').val(respuesta.modalidadFOGAFI);
						$('#bonificacionFOGAFI').val(respuesta.bonificacionFOGAFI);
						$('#desbloqAutFOGAFI').val(respuesta.desbloqAutFOGAFI);

						var cobraFOGAFI = respuesta.garantiaFOGAFI;

						// Si la institucion cobra Garantias FOGA/FOGAFI
						if(cobraGarantiaFinanciada == 'S'){

							// Se asigna el valor a bonificaFOGA si acepta bonificaciones, esto se utiliza para visualizar en el grid la columna del porcentaje de bonificaciones
							bonificaFOGA 	= respuesta.bonificacionFOGA;

							// Se asigna el valor a bonificaFOGAFI si acepta bonificaciones, esto se utiliza para visualizar en el grid la columna del porcentaje de bonificaciones
							bonificaFOGAFI	= respuesta.bonificacionFOGAFI;


							// Si cobra FOGAFI se muestran los campos correspondientes a FOGAFI
							if(cobraFOGAFI == 'S'){
								muestraCamposFOGAFI();

								// Sl el producto de crédito cobra garantia Financiada se mostrará el grid con el esquema FOGAFI
								$("#divGridFOGAFI").show(400);
								 mostrarGridEsquemasFOGAFI(respuesta.producCreditoID);

							}else{
								// Si no cobra FOGAFI, los campos se ocultarán
								ocultaCamposFOGAFI();

								$("#divGridFOGAFI").hide(400);
							}


							if( respuesta.requiereGarantia== 'S'){
								muestraCamposFOGA();
								$("#divGrid").show(400);
								 mostrarGridEsquemas(respuesta.producCreditoID);
							}
							else{
								ocultaCamposFOGA();
								$("#divGrid").hide(400);
							}


						}

						if( respuesta.requiereGarantia== 'S'){
							$("#divGrid").show(400);
							 mostrarGridEsquemas(respuesta.producCreditoID);
						}
						else{
							$("#divGrid").hide(400);
						}

						tipoCon = 1;
						productosCreditoServicio.consulta(tipoCon,productoCreditoBean,{
							async: false,
							callback: function(productos){
								if(productos!=null){
								 montoMin = productos.montoMinimo;
								 montoMax =productos.montoMaximo;
								}
							}
						});
					}
				}
			});
		setTimeout("$('#bonificacionFOGA').change();",100);
		setTimeout("$('#bonificacionFOGAFI').change();",100);
	}

});// fin de jquery



/* ==================== FUNCIONES EXTRAS =================== */

// Carga Grid, funcion para consultar los esquemas de garantia liquida para un prodcuto de credito
function mostrarGridEsquemas(producCreditoID){
	var numFilas;
		var params = {};

		params['tipoLista'] = 2;
		params['producCreditoID'] = producCreditoID;
		params['bonificaFOGA'] = bonificaFOGA;

		$.post("esquemaGarantiaLiqGridVista.htm", params, function(esquemas){

			if(esquemas.length >0) {
				$('#tablaGrid').html(esquemas);
				agregaFormatoControles('formaGenerica');
				 numFilas = consultaFilas();
				 if(parseInt(numFilas)>0){
					 habilitaBoton('grabar');
				 }else{
					 deshabilitaBoton('grabar');
				 }
			}else{
				$('#tablaGrid').html("");
				$('#tablaGrid').hide();

			}
		});
  }


// Carga Grid, funcion para consultar los esquemas de garantia FOGAFI para un producto de credito */
function mostrarGridEsquemasFOGAFI(producCreditoID){
	var numFilas;
		var params = {};

		params['tipoLista'] = 4;
		params['producCreditoID'] = producCreditoID;
		params['bonificaFOGAFI'] = bonificaFOGAFI;

		$.post("esquemaGarFOGAFIGridVista.htm", params, function(esquemas){

			if(esquemas.length >0) {
				$('#tablaGridFOGAFI').html(esquemas);
				agregaFormatoControles('formaGenerica');
				 numFilas = consultaFilasFOGAFI();
				 if(parseInt(numFilas)>0){
					 habilitaBoton('grabarFOGAFI');
				 }else{
					 deshabilitaBoton('grabarFOGAFI');
				 }
			}else{
				$('#tablaGridFOGAFI').html("");
				$('#tablaGridFOGAFI').hide();

			}
		});
  }


/* Agregar una nueva fila al Grid */
function agregarFila(){
	var numeroFila=consultaFilas();

	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
			tds += '<input   type="hidden" id="consecutivoID'+nuevaFila+'" size="6"  value="'+nuevaFila+'" />';
			tds += '<td align="center"><select id="clasificacion'+nuevaFila+'" name="lClasificacion"><option value="N">NO ASIGNADA</option><option value="A">EXCELENTE</option><option value="B">BUENA</option><option value="C">REGULAR</option></select> </td>';
			tds += '<td align="center"><input  type="text" id="limiteInferior'+nuevaFila+'" name="lLimiteInferior" size="22"  autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarLimites(this.id,this.value)" onClick="this.focus()" /></td>';
			tds += '<td align="center"><input  type="text" id="limiteSuperior'+nuevaFila+'" name="lLimiteSuperior" size="22" autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarLimites(this.id,this.value)" onClick="this.focus()" /> </td>';
			tds += '<td align="center"><input  type="text" id="porcentaje'+nuevaFila+'" name="lPorcentaje" size="10" value="" autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarPorcentaje(this.id,this.value)" onClick="this.focus()" /> <label class="label">%</label>	</td>';
			tds += '<td class="bonoFOGA" align="center"><input  type="text" id="bonificaFOGA'+nuevaFila+'" name="lBonificaFOGA" size="10" value="" autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarPorcentaje(this.id,this.value)" onClick="this.focus()" /> <label class="label">%</label>	</td>';

		tds += '<td align="center"><input type="button" name="eliminar" id="'+nuevaFila+'"  value="" class="btnElimina" onclick="eliminarFila(this.id)" />';
		tds += '<input type="button" name="agrega" id="'+nuevaFila+'"  value="" class="btnAgrega" onclick="agregarFila()"/></td>';
		tds += '</tr>';

		$("#miTabla").append(tds);
		habilitaBoton('grabar');
		agregaFormatoControles('formaGenerica');

		columnaBonifica('bonificacionFOGA');

		return false;
}


/* Agregar una nueva fila al Grid */
function agregarFilaFOGAFI(){
	var numeroFila=consultaFilasFOGAFI();

	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglonFOGAFI' + nuevaFila + '" name="renglonFOGAFI">';
			tds += '<input   type="hidden" id="consecutivoFOGAFIID'+nuevaFila+'" size="6"  value="'+nuevaFila+'" />';
			tds += '<td align="center"><select id="clasificacionFOGAFI'+nuevaFila+'" name="lClasificacionFOGAFI"><option value="N">NO ASIGNADA</option><option value="A">EXCELENTE</option><option value="B">BUENA</option><option value="C">REGULAR</option></select> </td>';
			tds += '<td align="center"><input  type="text" id="limiteInferiorFOGAFI'+nuevaFila+'" name="lLimiteInferiorFOGAFI" size="22"  autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarLimitesFOGAFI(this.id,this.value)" onClick="this.focus()" /></td>';
			tds += '<td align="center"><input  type="text" id="limiteSuperiorFOGAFI'+nuevaFila+'" name="lLimiteSuperiorFOGAFI" size="22" autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarLimitesFOGAFI(this.id,this.value)" onClick="this.focus()" /> </td>';
			tds += '<td align="center"><input  type="text" id="porcentajeFOGAFI'+nuevaFila+'" name="lPorcentajeFOGAFI" size="10" value="" autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarPorcentajeFOGAFI(this.id,this.value)" onClick="this.focus()" /> <label class="label">%</label>	</td>';
			tds += '<td class="bonoFOGAFI" align="center"><input  type="text" id="bonificaFOGAFI'+nuevaFila+'" name="lBonificaFOGAFI" size="10" value="" autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarBonificacionFOGAFI(this.id,this.value)" onClick="this.focus()" /> <label class="label">%</label>	</td>';

		tds += '<td align="center"><input type="button" name="eliminarFOGAFI" id="'+nuevaFila+'"  value="" class="btnElimina" onclick="eliminarFilaFOGAFI(this.id)" />';
		tds += '<input type="button" name="agregaFOGAFI" id="'+nuevaFila+'"  value="" class="btnAgrega" onclick="agregarFilaFOGAFI()"/></td>';
		tds += '</tr>';

		$("#miTablaFOGAFI").append(tds);
		habilitaBoton('grabarFOGAFI');
		agregaFormatoControles('formaGenerica');

		columnaBonifica('bonificacionFOGAFI');

		return false;
}

function eliminarFila(control){
	var contador = 0 ;
	var numeroID = control;

	var jqRenglon = eval("'#renglon" + numeroID + "'");
	$(jqRenglon).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglon = eval("'#renglon"+numero+"'");
		var jqNumero = eval("'#consecutivoID"+numero+"'");
		var jqClasificacion = eval("'#clasificacion"+numero+"'");
		var jqLimiteInferior = eval("'#limiteInferior"+numero+"'");
		var jqLimiteSuperior= eval("'#limiteSuperior"+numero+"'");
		var jqPorcentaje=eval("'#porcentaje"+ numero+"'");
		var jqAgrega=eval("'#agrega"+ numero+"'");
		var jqElimina = eval("'#"+numero+ "'");

		$(jqNumero).attr('id','consecutivoID'+contador);
		$(jqClasificacion).attr('id','clasificacion'+contador);
		$(jqLimiteInferior).attr('id','limiteInferior'+contador);
		$(jqLimiteSuperior).attr('id','limiteSuperior'+contador);
		$(jqPorcentaje).attr('id','porcentaje'+contador);
		$(jqAgrega).attr('id','agrega'+contador);
		$(jqElimina).attr('id',contador);
		$(jqRenglon).attr('id','renglon'+ contador);
		contador = parseInt(contador + 1);

	});

}

function eliminarFilaFOGAFI(control){
	var contador = 0 ;
	var numeroID = control;

	var jqRenglon = eval("'#renglonFOGAFI" + numeroID + "'");
	$(jqRenglon).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglonFOGAFI]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglon = eval("'#renglonFOGAFI"+numero+"'");
		var jqNumero = eval("'#consecutivoFOGAFIID"+numero+"'");
		var jqClasificacion = eval("'#clasificacionFOGAFI"+numero+"'");
		var jqLimiteInferior = eval("'#limiteInferiorFOGAFI"+numero+"'");
		var jqLimiteSuperior= eval("'#limiteSuperiorFOGAFI"+numero+"'");
		var jqPorcentaje=eval("'#porcentajeFOGAFI"+ numero+"'");
		var jqAgrega=eval("'#agregaFOGAFI"+ numero+"'");
		var jqElimina = eval("'#"+numero+ "'");

		$(jqNumero).attr('id','consecutivoFOGAFIID'+contador);
		$(jqClasificacion).attr('id','clasificacionFOGAFI'+contador);
		$(jqLimiteInferior).attr('id','limiteSuperiorFOGAFI'+contador);
		$(jqLimiteSuperior).attr('id','limiteSuperior'+contador);
		$(jqPorcentaje).attr('id','porcentajeFOGAFI'+contador);
		$(jqAgrega).attr('id','agregaFOGAFI'+contador);
		$(jqElimina).attr('id',contador);
		$(jqRenglon).attr('id','renglonFOGAFI'+ contador);
		contador = parseInt(contador + 1);

	});

}

function validarLimites(controlID, valor){
	var numero= controlID.substr(14,controlID.length);
	var tipoLimite = controlID.substr(0,controlID.length - parseInt(numero.length));
	var jqLimite = eval("'#" + controlID + "'");

	// Si es un limite inferior
	if(tipoLimite == 'limiteInferior'){
		//si el valor esta vacio
		if(valor== ''){
			$(jqLimite).val('0.00');
		//si no esta vacio el limite inferior
		}else{
			 // si el numero de digitos es menor a 20
			 if(valor.length <= 19){
					// si el valor ingresado es un numero valido
					if(parseFloat(valor)>= parseFloat(0)){
						if($("#limiteInferior"+numero).asNumber() > $("#limiteSuperior"+numero).asNumber() && $("#limiteSuperior"+numero).val() != 0){
							mensajeSis("El Monto Inferior No puede ser mayor al Monto Superior");
							$(jqLimite).val('');
							$(jqLimite).focus();
						}
						else{
							if(parseFloat($("#limiteInferior"+numero).asNumber())  < parseFloat(montoMin)){
								mensajeSis("El Monto Inferior No puede ser menor a "+montoMin);
								$(jqLimite).val('');
								$(jqLimite).focus();
							}
						}
					}
					else{
						$(jqLimite).val('0.00');
					}
			 }
			 else{
				 mensajeSis("Máximo 14 dígitos y 2 decimales");
					$(jqLimite).val('');
					$(jqLimite).focus();
			 }
		}
	}
	// si es un limite superior
	else{
		// si el valor esta vacio
		if(valor== ''){
			$(jqLimite).val('');
			mensajeSis("Ingrese Monto Superior");
			$(jqLimite).focus();
		// si no esta vacio el limite superior
		}else{
			 // si el numero de digitos es menor a 20
			 if(valor.length <= 19){
					// si el valor ingresado es un numero valido
					if(parseFloat(valor)> parseFloat(0)){
						if($("#limiteInferior"+numero).asNumber() > $("#limiteSuperior"+numero).asNumber() && $("#limiteSuperior"+numero).val() != 0){
							mensajeSis("El Monto Inferior No puede ser mayor al Monto Superior");
							$(jqLimite).val('');
							$(jqLimite).focus();
						}
						else{
							if(parseFloat($("#limiteSuperior"+numero).asNumber())  > parseFloat(montoMax)){
								mensajeSis("El Monto Superior No puede ser mayor a "+montoMax);
								$(jqLimite).val('');
								$(jqLimite).focus();
							}
						}
					}
					else{
						$(jqLimite).val('');
						mensajeSis("El Monto Superior es incorrecto");
						$(jqLimite).focus();
					}
			 }else{
				 mensajeSis("Máximo 14 dígitos y 2 decimales");
					$(jqLimite).val('');
					$(jqLimite).focus();
			 }
		}
	}


}

function validarLimitesFOGAFI(controlID, valor){
	var numero= controlID.substr(14,controlID.length);
	var tipoLimite = controlID.substr(0,controlID.length - parseInt(numero.length));
	var jqLimite = eval("'#" + controlID + "'");

	// Si es un limite inferior
	if(tipoLimite == 'limiteInferiorFOGAFI'){
		//si el valor esta vacio
		if(valor== ''){
			$(jqLimite).val('0.00');
		//si no esta vacio el limite inferior
		}else{
			 // si el numero de digitos es menor a 20
			 if(valor.length <= 19){
					// si el valor ingresado es un numero valido
					if(parseFloat(valor)>= parseFloat(0)){
						if($("#limiteInferiorFOGAFI"+numero).asNumber() > $("#limiteSuperiorFOGAFI"+numero).asNumber() && $("#limiteSuperiorFOGAFI"+numero).val() != 0){
							mensajeSis("El Monto Inferior No puede ser mayor al Monto Superior");
							$(jqLimite).val('');
							$(jqLimite).focus();
						}
						else{
							if(parseFloat($("#limiteInferiorFOGAFI"+numero).asNumber())  < parseFloat(montoMin)){
								mensajeSis("El Monto Inferior No puede ser menor a "+montoMin);
								$(jqLimite).val('');
								$(jqLimite).focus();
							}
						}
					}
					else{
						$(jqLimite).val('0.00');
					}
			 }
			 else{
				 mensajeSis("Máximo 14 dígitos y 2 decimales");
					$(jqLimite).val('');
					$(jqLimite).focus();
			 }
		}
	}
	// si es un limite superior
	else{
		// si el valor esta vacio
		if(valor== ''){
			$(jqLimite).val('');
			mensajeSis("Ingrese Monto Superior");
			$(jqLimite).focus();
		// si no esta vacio el limite superior
		}else{
			 // si el numero de digitos es menor a 20
			 if(valor.length <= 19){
					// si el valor ingresado es un numero valido
					if(parseFloat(valor)> parseFloat(0)){
						if($("#limiteInferiorFOGAFI"+numero).asNumber() > $("#limiteSuperiorFOGAFI"+numero).asNumber() && $("#limiteSuperiorFOGAFI"+numero).val() != 0){
							mensajeSis("El Monto Inferior No puede ser mayor al Monto Superior");
							$(jqLimite).val('');
							$(jqLimite).focus();
						}
						else{
							if(parseFloat($("#limiteSuperiorFOGAFI"+numero).asNumber())  > parseFloat(montoMax)){
								mensajeSis("El Monto Superior No puede ser mayor a "+montoMax);
								$(jqLimite).val('');
								$(jqLimite).focus();
							}
						}
					}
					else{
						$(jqLimite).val('');
						mensajeSis("El Monto Superior es incorrecto");
						$(jqLimite).focus();
					}
			 }else{
				 mensajeSis("Máximo 14 dígitos y 2 decimales");
					$(jqLimite).val('');
					$(jqLimite).focus();
			 }
		}
	}


}


function validarPorcentaje(controlID, valor){
	var numero= controlID.substr(10,controlID.length);

	if(isNaN(parseFloat(valor))){
		$("#porcentaje"+numero).focus();
		$("#porcentaje"+numero).val('0.00');
	}else{
		if(valor.length > 6){
			mensajeSis("Máximo 3 dígitos y 2 decimales");
			$("#porcentaje"+numero).focus();
			$("#porcentaje"+numero).val('0.00');
		}
	}
}


function validarBonificacion(controlID, valor){
	var numero= controlID.substr(10,controlID.length);

	if(isNaN(parseFloat(valor))){
		$("#bonificaFOGA"+numero).focus();
		$("#bonificaFOGA"+numero).val('0.00');
	}else{
		if(valor.length > 6){
			mensajeSis("Máximo 3 dígitos y 2 decimales");
			$("#bonificaFOGA"+numero).focus();
			$("#bonificaFOGA"+numero).val('0.00');
		}
	}
}


function validarPorcentajeFOGAFI(controlID, valor){
	var numero= controlID.substr(10,controlID.length);

	if(isNaN(parseFloat(valor))){
		$("#porcentajeFOGAFI"+numero).focus();
		$("#porcentajeFOGAFI"+numero).val('0.00');
	}else{
		if(valor.length > 6){
			mensajeSis("Máximo 3 dígitos y 2 decimales");
			$("#porcentajeFOGAFI"+numero).focus();
			$("#porcentajeFOGAFI"+numero).val('0.00');
		}
	}
}


function validarBonificacionFOGAFI(controlID, valor){
	var numero= controlID.substr(10,controlID.length);

	if(isNaN(parseFloat(valor))){
		$("#bonificaFOGAFI"+numero).focus();
		$("#bonificaFOGAFI"+numero).val('0.00');
	}else{
		if(valor.length > 6){
			mensajeSis("Máximo 3 dígitos y 2 decimales");
			$("#bonificaFOGAFI"+numero).focus();
			$("#bonificaFOGAFI"+numero).val('0.00');
		}
	}
}

/*    cuenta las filas de la tabla del grid       */
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
	});
	return totales;
}

/*    cuenta las filas de la tabla del grid FOGAFI     */
function consultaFilasFOGAFI(){
	var totales=0;
	$('tr[name=renglonFOGAFI]').each(function() {
		totales++;
	});
	return totales;
}

function setFocoGrid() {
	$("#clasificacion1").focus();
}

function setFocoGridFOGAFI() {
	$("#clasificacionFOGAFI1").focus();
}


function funcionExitoTransaccion (){
	$('#tablaGrid').html("");
	$("#divGrid").hide(400);
	$("#divGridFOGAFI").hide(400);
	agregaFormatoControles('formaGenerica');
}


function funcionFalloTransaccion (){
	agregaFormatoControles('formaGenerica');
}


function consultaCobraGarantiaFinanciada(){
	var tipoConsulta = 26;
	var bean = {
			'empresaID'		: 1
		};

	paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
			if (parametro != null){
				cobraGarantiaFinanciada = parametro.valorParametro;

			}else{
				cobraGarantiaFinanciada = 'N';
			}

	}});
}

// Función donde se muestran los campos de garantias FOGA Y FOGAFI
function muestraCamposFOGAFI(){
	$("#separadorModalidad").show();
	$("#modalidadLbl").show();
	$("#modalidad").show();

	$("#separadoBonFOGAFI").show();
	$("#lblBonificaFOGAFI").show();
	$("#bonificaFOGAFI").show();

	$("#separadorDesbFOGAFI").show();
	$("#lblseparadorDesbFOGAFI").show();
	$("#desbloqueoFOGAFI").show();

}

// Función que muestra los campos correspondientes a la Garantia FOGAFI
function muestraCamposFOGA(){
	$("#separadorBonificacion").show();
	$("#lblBonificacion").show();
	$("#tdBonificacion").show();

	$("#separadorDesbloquea").show();
	$("#lblDesbloquea").show();
	$("#tdDesbloquea").show();

}

// Función que oculta los campos correspondientes a la Garantia FOGAFI
function ocultaCamposFOGA(){
	$("#separadorBonificacion").hide();
	$("#lblBonificacion").hide();
	$("#tdBonificacion").hide();

	$("#separadorDesbloquea").hide();
	$("#lblDesbloquea").hide();
	$("#tdDesbloquea").hide();

	$('#bonificacionFOGA').val('N');
	$('#desbloqAutFOGA').val('N');


}

// Función donde se ocultan los campos de garantias FOGA Y FOGAFI
function ocultaCamposFOGAFI(){
	$("#separadorModalidad").hide();
	$("#modalidadLbl").hide();
	$("#modalidad").hide();

	$("#separadoBonFOGAFI").hide();
	$("#lblBonificaFOGAFI").hide();
	$("#bonificaFOGAFI").hide();

	$("#separadorDesbFOGAFI").hide();
	$("#lblseparadorDesbFOGAFI").hide();
	$("#desbloqueoFOGAFI").hide();

	$('#modalidadFOGAFI').val('');
	$('#bonificacionFOGAFI').val('N');
	$('#desbloqAutFOGAFI').val('N');
}


// Función que muestra los campos para la Garantía Liquida(Actualmente FOGA)
function muestraCamposGarantias(){
	$("#garantiaNoFinanciadaLbl").show();// Liberar Garantía Líquida
	$("#garantiaNoFinanciada").show();
}

function ocultaCamposGarantias(){
	$("#garantiaNoFinanciadaLbl").hide();
	$("#garantiaNoFinanciada").hide();

	$("#separadorBonificacion").hide();
	$("#lblBonificacion").hide();
	$("#tdBonificacion").hide();
	$("#separadorDesbloquea").hide();
	$("#lblDesbloquea").hide();
	$("#tdDesbloquea").hide();
}


function columnaBonifica(jControl){
	var control = eval("'#" + jControl + "'");
	var colBonoVista = $(control).val();

	var garantia = (jControl=='bonificacionFOGA')?'FOGA':'FOGAFI';

	if(colBonoVista=='S'){
		$('#encBono'+garantia).show();
		$('.bono'+garantia).show();
	}else{
		$('#encBono'+garantia).hide();
		$('.bono'+garantia).hide();
	}
}