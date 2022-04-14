var esTab = false;
var parametroBean;

$(document).ready(
		function() {
			
			$("#nombreCortoInsitucion").focus();
			
			parametroBean = consultaParametrosSession();	
			
			deshabilitaBoton('modifica', 'submit');
			agregaFormatoControles('formaGenerica');
			
			$('input, select').focus(function() {
				esTab = false;
			});

			$('input ,select').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});

			$('input ,select').blur(function() {
				if ($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
					setTimeout(function() {
						$('#formaGenerica :input:enabled:visible:first').focus();
					}, 0);
				}
				
			});

			rellenaParametros();
			
			function rellenaParametros() {
				
				bamParametrosServicio.consulta(1, function(parametros) {
						if (parametros != null) {
							habilitaBoton('modifica', 'submit');
							$("#empresaID").val(parametros.empresaID);
							$("#nombreCortoInsitucion").val(parametros.nombreCortoInsitucion);
							$("#textoActivacionSMS").val(parametros.textoActivacionSMS);
							$("#ivaPagarSpei").val(parametros.ivaPagarSpei);
							$("#usuarioSpei").val(parametros.usuarioSpei);
							$("#rutaArchivos").val(parametros.rutaArchivos);
							$("#textoNotifNuevoUsuario").val(parametros.textoNotifNuevoUsuario);
							$("#textoNotifiCambioSeg").val(parametros.textoNotifiCambioSeg);
							$("#textoNotifPagos").val(parametros.textoNotifPagos);
							$("#textoNotifSesion").val(parametros.textoNotifSesion);
							$("#textoNotifTransferencias").val(parametros.textoNotifTransferencias);
							$("#tiempoValidoSMS").val(parametros.tiempoValidoSMS);
							$("#remitente").val(parametros.remitente);
							$("#minimoCaracteresPin").val(parametros.minimoCaracteresPin);
							$("#urlFreja").val(parametros.urlFreja);
							$("#tituloTransaccion").val(parametros.tituloTransaccion);
							$("#periodoValidacion").val(parametros.periodoValidacion);
							$("#tiempoMaxEspera").val(parametros.tiempoMaxEspera);
							$("#tiempoAprovisionamiento").val(parametros.tiempoAprovisionamiento);
	
						} else {
							console.log("Datos nulos");
						}
				});									
				
			}
			
			$.validator.prototype.checkForm = function() {
				// Reemplaza la funcion checkForm de jQuery para validar varios campos con el mismo valor en el atributo 'name'
				this.prepareForm();
				for (var i = 0, elements = (this.currentElements = this.elements()); elements[i]; i++) {
					if (this.findByName(elements[i].name).length !== undefined && this.findByName(elements[i].name).length > 1) {
						for (var cnt = 0; cnt < this.findByName(elements[i].name).length; cnt++) {
							this.check(this.findByName(elements[i].name)[cnt]);
						}
					} else {
						this.check(elements[i]);
					}
				}
				return this.valid();
			};


			$.validator.setDefaults({
				submitHandler : function(event) {

					var idsCompare = [];
					var duplicados = false;
					$('#miTabla tr').each(function(index) {
						if(index > 0){
							var value = $('#' + $(this).find("input[name^='lisProducCredito']").attr('id')).val();
							var found = idsCompare.indexOf(value);
							
							if(found != -1){
								duplicados = true;
							}
							idsCompare.push(value);
						}
					});

					if(!duplicados){
						idsCompare = [];

						$('#tablaTiposCta tr').each(function(index) {
							if(index > 0){
								var value = $('#' + $(this).find("input[name^='lisTiposCta']").attr('id')).val();
								var found = idsCompare.indexOf(value);
								
								if(found != -1){
									duplicados = true;
								}

								idsCompare.push(value);
								
							}
						});
					}

					if(!duplicados){
						if($("[name ='renglon']").length > 0){
							
							if($("[name ='renglonTiposCta']").length > 0){	
								grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma','mensaje', 'true', 'clienteID','exitoTransUsuario', 'falloTransUsuario');
							}else{
								mensajeSis("Especifique al menos un Tipo de Cuenta.");
							}
							
						}else{
							mensajeSis("Especifique al menos un Producto de Crédito.");
						}
					}else{
						mensajeSis("Especifique valores que no sean duplicados.");
					}

				}
			});

			// ------------ Validaciones de la Forma
			
			$('#formaGenerica').validate({
				rules : {
					nombreCortoInsitucion:{
						required : true,
						maxlength: 100
					},
					textoActivacionSMS:{
						required : true,
						maxlength: 100
					},
					ivaPagarSpei:{
						required : true,
						number: true,
						max : 100,
						numeroPositivo: true,
						maxlength: 10
					},
					usuarioSpei:{
						required : true,
						maxlength: 100
					},
					rutaArchivos:{
						required : true,
						maxlength: 200
					},
					textoNotifNuevoUsuario:{
						required : true,
						maxlength: 100
					},
					textoNotifiCambioSeg:{
						required : true,
						maxlength: 100
					},
					textoNotifPagos:{
						required : true,
						maxlength: 100
					},
					textoNotifSesion:{
						required : true,
						maxlength: 100
					},
					textoNotifTransferencias:{
						required : true,
						maxlength: 100
					},
					tiempoValidoSMS:{
						required : true,
						digits: true,
						numeroPositivo: true,
						maxlength: 10
					},
					remitente:{
						required : true,
						maxlength: 100
					},
					minimoCaracteresPin:{
						required : true,
						digits : true,
						numeroPositivo: true,
						maxlength : 10,
					},
					urlFreja:{
						required : true,
						maxlength: 300
					},
					tituloTransaccion:{
						required : true,
						maxlength: 100
					},
					periodoValidacion:{
						required : true,
						maxlength: 100,
						digits: true,
						numeroPositivo: true,
					},
					tiempoMaxEspera:{
						required : true,
						maxlength: 100,
						digits: true,
						numeroPositivo: true,
					},
					tiempoAprovisionamiento:{
						required : true,
						maxlength: 100,
						digits: true,
						numeroPositivo: true,
					},
					lisProducCredito:{
						required : true,
					},
					descripcionProd:{
						required : true,
					},
					lisDestinoCredito:{
						required : true,
					},
					descripcionDestino:{
						required : true,
					},
					desClasificacion:{
						required : true,
					},
					lisTiposCta:{
						required : true,
					},
					descripcion:{
						required : true,
					},
				},
				messages : {
					nombreCortoInsitucion:{
						required : "Especifique el nombre de la institución.",
						maxlength : 'Maximo 100 caracteres',
					},
					textoActivacionSMS:{
						required : 'Especifique el texto de SMS de activación.',
						maxlength : 'Maximo 100 caracteres',
					},
					ivaPagarSpei:{
						required : 'Especifique el iva a pagar por el uso de SPEI.',
						number : "No es un monto válido.",
						numeroPositivo: 'Sólo números positivos',
						maxlength : 'Maximo 10 caracteres',
						max : "Maximo 100%"
					},
					usuarioSpei:{
						required : 'Especifique el usuario para el envio de SPEI.',
						maxlength : 'Maximo 100 caracteres',
					},
					rutaArchivos:{
						required : 'Especifique la ruta de los archivos.',
						maxlength : 'Maximo 200 caracteres',
					},
					textoNotifNuevoUsuario:{
						required : 'Especifique el texto de notificación para nuevos usuarios',
						maxlength : 'Maximo 100 caracteres',
					},
					textoNotifiCambioSeg:{
						required : 'Especifique el texto de notificación para cambio de seguiridad.',
						maxlength : 'Maximo 100 caracteres',
					},
					textoNotifPagos:{
						required : 'Especifique el texto de notificación para pagos.',
						maxlength : 'Maximo 100 caracteres',
					},
					textoNotifSesion:{
						required : 'Especifique el texto de notificación para sesiones.',
						maxlength : 'Maximo 100 caracteres',
					},
					textoNotifTransferencias:{
						required : 'Especifique el texto de notificación para transferencias.',
						maxlength : 'Maximo 100 caracteres',
					},
					tiempoValidoSMS:{
						required : 'Especifique el tiempo de caducidad de SMS.',
						digits : 'Solo números.',
						numeroPositivo: 'Sólo números positivos',
						maxlength : 'Maximo 10 números',
					},
					remitente:{
						required : 'Especifique el remitente de correo electrónico.',
						maxlength : 'Maximo 100 caracteres',
					},
					minimoCaracteresPin:{
						required : 'Especifique el minimo de caracteres para contraseñas.',
						digits : 'Solo números.',
						numeroPositivo: 'Sólo números positivos',
						maxlength : 'Maximo 10 numeros',
					},
					urlFreja:{
						required : 'Especifique la URL del servidor.',
						maxlength : 'Maximo 300 caracteres',
					},
					tituloTransaccion:{
						required : 'Especifique Titulo de la transacción.',
						maxlength : 'Maximo 100 caracteres',
					},
					periodoValidacion:{
						required : 'Especifique periodo de validacion.',
						digits : 'Solo números.',
						numeroPositivo: 'Sólo números positivos'
					},
					tiempoMaxEspera:{
						required : 'Especifique el tiempo maximo de espera.',
						digits : 'Solo números.',
						numeroPositivo: 'Sólo números positivos'
					},
					tiempoAprovisionamiento:{
						required : 'Especifique periodo de validacion.',
						digits : 'Solo números.',
						numeroPositivo: 'Sólo números positivos'
					},
					lisProducCredito:{
						required : 'Especifique el producto de credito.',
					},
					descripcionProd:{
						required : 'Especifique la descripcion del producto.',
					},
					lisDestinoCredito:{
						required : 'Especifique el destino de producto.',
					},
					descripcionDestino:{
						required : 'Especifique la descripcion del destino de credito.',
					},
					desClasificacion:{
						required : 'Especifique la clasificacion destino.',
					},
					lisTiposCta:{
						required : 'Especifique tipo de cuenta.',
					},
					descripcion:{
						required : 'Especifique la descripcion del tipo de cuenta.',
					},
				}
			});
			
			consultaProductosCredito();
			consultaTiposCuenta();
		}
		
);


function exitoTransUsuario() {
	$("#nombreCortoInsitucion").focus();
	agregaFormatoControles('formaGenerica');
}

function falloTransUsuario() {
	agregaFormatoControles('formaGenerica');
}

function consultaProductosCredito(){	
	var params = {};
	params['perfilID'] = parametroBean.perfilUsuario;
	
	$.post("listaBANProductosCredito.htm", params, function(data){				
			if(data.length >0) {
				$('#gridProductosCreditos').html(data);
				$('#gridProductosCreditos').show();
			}else{					
				$('#gridProductosCreditos').html("");
				$('#gridProductosCreditos').show();
			}
	});
}

function duplicadoTipos(){
	var idsProducts = [];
	$('#tablaTiposCta tr').each(function(index) {
		if(index > 0){
			var value = $('#' + $(this).find("input[name^='lisTiposCta']").attr('id')).val();
			var found = idsProducts.indexOf(value);
			
			if(found != -1){
				return true;
			}

			idsProducts.push(value);
			
		}
	});
	return false;
}

function consultaProductosCreditoAyuda(idControl) {

	var jqProducto = eval("'#" + idControl + "'");
	var numProducto = $(jqProducto).val();
	var conForanea = 2;
	var jqNombreSucurs = eval("'#descripcionProd" + idControl.substr(15) + "'");
	var ProductoCreditoCon = {
		'producCreditoID' : numProducto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if (numProducto != '' && !isNaN(numProducto) && esTab == true) {
		productosCreditoServicio.consulta(conForanea, ProductoCreditoCon, function(productos) {
			if (productos != null && productos!= '') {
				$(jqNombreSucurs).val(productos.descripcion);
				}
			else{
				mensajeSis("No existe el Producto de Crédito.")
				$(jqProducto).val("");
				$(jqNombreSucurs).val("");
				$(jqProducto).focus();
			}
			});
	}
}

function listaProd(idControl){
	var jq = eval("'#" + idControl + "'");
	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = num;
		lista(idControl, '2', '1', camposLista, parametrosLista, 'listaProductosCredito.htm');
	});
}

function listaDestinos(idControl){
	var jq = eval("'#" + idControl + "'");
	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();

		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "descripcion";
		parametrosLista[0] = num;
		
		lista(idControl, '2', '1', 'destinoCreID', num,'listaDestinosCredito.htm');
	});
}

function consultaDestinoCredito(idControl) {
	$('#clasifiDestinCred').val('');
	
	var number = idControl.substring(16, idControl.length);

	var jqDestino = eval("'#" + idControl + "'");
	var DestCred = $(jqDestino).val();
	var DestCredBeanCon = {
			'destinoCreID' : DestCred
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (DestCred != '' && !isNaN(DestCred) && esTab) {
		destinosCredServicio.consulta(2, DestCredBeanCon,function(destinos) {
					if (destinos != null) {
						$("#descripcionDestino" + number).val(destinos.descripcion);
						$("#clasificacion" + number).val(destinos.clasificacion);
						$("#desClasificacion" + number).val(destinos.desClasificacion);
					} else {
						mensajeSis("No Existe el Destino de Crédito.");
					}
				});
	}
}

function agregaNuevoProducto(){
	var numeroFila = consultaFilas();
	var nuevaFila = parseInt(numeroFila) + 1;
  	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	if(numeroFila == 0){
		tds += '<td align="center"><input  id="producCreditoID'+nuevaFila+'" name="lisProducCredito"  size="8"  value="" autocomplete="off"  type="text" onkeyPress="listaProd(this.id)" onblur="consultaProductosCreditoAyuda(this.id)" style="text-align: center; width: 100% "/></td>';
		tds += '<td align="center"><input type="text" id="descripcionProd'+nuevaFila+'" name="descripcionProd" size="8" value="" maxlength="200" autocomplete="off" style="text-align: left; width: 100%" readOnly="true" /></td>';
		tds += '<td align="center"><input  id="destinoCreditoID'+nuevaFila+'" name="lisDestinoCredito"  size="8"  value="" autocomplete="off"  type="text" onkeyPress="listaDestinos(this.id)" onblur="consultaDestinoCredito(this.id)" style="text-align: center; width: 100% " /></td>';
		tds += '<td align="center"><input type="text" id="descripcionDestino'+nuevaFila+'" name="descripcionDestino" size="8" value="" maxlength="200" autocomplete="off" style="text-align: center; width: 100%" readOnly="true" /></td>';
		tds += '<td align="center"><input type="hidden" id="clasificacion'+nuevaFila+'" name="lisClasificacion" size="8" value="" maxlength="200" autocomplete="off" style="text-align: center; width: 100% "readOnly="true" /><input type="text" id="desClasificacion'+nuevaFila+'" name="desClasificacion" size="8" value="" maxlength="200" autocomplete="off" style="text-align: left; width: 100% " readOnly="true" /></td>';
	} else{
		var valor = parseInt(numeroFila) + 1
		tds += '<td align="center"><input  id="producCreditoID'+nuevaFila+'" name="lisProducCredito"  size="8"  value="" autocomplete="off"  type="text" onkeyPress="listaProd(this.id)" onblur="consultaProductosCreditoAyuda(this.id)" style="text-align: center; width: 100% " /></td>';
		tds += '<td align="center"><input type="text" id="descripcionProd'+nuevaFila+'" name="descripcionProd" size="8" value="" maxlength="200" autocomplete="off" style="text-align: left; width: 100% " readOnly="true" /></td>';
		tds += '<td align="center"><input  id="destinoCreditoID'+nuevaFila+'" name="lisDestinoCredito"  size="8"  value="" autocomplete="off"  type="text" onkeyPress="listaDestinos(this.id)" onblur="consultaDestinoCredito(this.id)" style="text-align: center; width: 100% " /></td>';
		tds += '<td align="center"><input type="text" id="descripcionDestino'+nuevaFila+'" name="descripcionDestino" size="8" value="" maxlength="200" autocomplete="off" style="text-align: left; width: 100% " readOnly="true" /></td>';
		tds += '<td align="center"><input type="hidden" id="clasificacion'+nuevaFila+'" name="lisClasificacion" size="8" value="" maxlength="200" autocomplete="off" style="text-align: left; width: 100% " readOnly="true" /><input type="text" id="desClasificacion'+nuevaFila+'" name="desClasificacion" size="8" value="" maxlength="200" autocomplete="off" style="text-align: left; width: 100% " readOnly="true" /></td>';
	}
	tds += '<td><input type="button" name="agregaE" id="agregaE'+nuevaFila+'" value="" class="btnAgrega" onclick="agregaNuevoProducto()" />';
	tds += '<input type="button" name="eliminaE" id="eliminaE'+nuevaFila+'" value="" class="btnElimina" onclick="eliminarProducto(this.id)" /></td>';
	tds += '</tr>';
	document.getElementById("numeroDetalle").value = nuevaFila;
	$("#miTabla").append(tds);
	agregaProducto();
	
	asignarTabs();
	return false;

}

function agregaProducto(){
	var contador = 0 ;
	var numeroID = 1;
	var jqRenglon = eval("'#renglon" + numeroID + "'");
	var jqProd = eval("'#producCreditoID" + numeroID + "'");
	var jqNombre = eval("'#descripcionProd" + numeroID + "'");
	var jqAlter = eval("'#destinoCreditoID" + numeroID + "'");
	var jqFor= eval("'#descripcionDestino" + numeroID + "'");
	var jqInf= eval("'#clasificacion" + numeroID + "'");
	var jqAgrega=eval("'#agregaE" + numeroID + "'");
	var jqElimina = eval("'#eliminaE" + numeroID + "'");


	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1 = eval("'#renglon" + numero + "'");
		var jqProd1 = eval("'#producCreditoID" + numero + "'");
		var jqNombre1 = eval("'#descripcionProd" + numero + "'");
		var jqAlter1 = eval("'#destinoCreditoID" + numero + "'");
		var jqFor1= eval("'#descripcionDestino" + numero + "'");
		var jqInf1= eval("'#clasificacion" + numero + "'");
		var jqAgrega1=eval("'#agregaE" + numero + "'");
		var jqElimina1 = eval("'#eliminaE" + numero + "'");
		
		$(jqProd1).attr('id','producCreditoID'+contador);
		$(jqNombre1).attr('id','descripcionProd'+contador);
		$(jqAlter1).attr('id','destinoCreditoID'+contador);
		$(jqFor1).attr('id','descripcionDestino'+contador);
		$(jqInf1).attr('id','clasificacion'+contador);
		$(jqAgrega1).attr('id','agregaE'+contador);
		$(jqElimina1).attr('id','eliminaE'+contador);
		$(jqRenglon1).attr('id','renglon'+ contador);
		contador = parseInt(contador + 1);
	});
	
	revalidarRenglonesError("renglon");

}

function eliminarProducto(control){
	
	var contador = 0 ;
	var numeroID = control.substr(8, control.length);
	var jqRenglon = eval("'#renglon" + numeroID + "'");
	var jqProd = eval("'#producCreditoID" + numeroID + "'");
	var jqNombre = eval("'#descripcionProd" + numeroID + "'");
	var jqAlter = eval("'#destinoCreditoID" + numeroID + "'");
	var jqFor= eval("'#descripcionDestino" + numeroID + "'");
	var jqInf= eval("'#clasificacion" + numeroID + "'");
	var jqDCl = eval("'#desClasificacion" + numeroID +"'");
	var jqAgrega=eval("'#agregaE" + numeroID + "'");
	var jqElimina = eval("'#eliminaE" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqProd).remove();
	$(jqNombre).remove();
	$(jqAlter).remove();
	$(jqFor).remove();
	$(jqInf).remove();
	$(jqElimina).remove();
	$(jqAgrega).remove();
	$(jqDCl).remove();
	$(jqRenglon).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1 = eval("'#renglon" + numero + "'");
		var jqProd1 = eval("'#producCreditoID" + numero + "'");
		var jqNombre1 = eval("'#descripcionProd" + numero + "'");
		var jqAlter1 = eval("'#destinoCreditoID" + numero + "'");
		var jqFor1= eval("'#descripcionDestino" + numero + "'");
		var jqInf1= eval("'#clasificacion" + numero + "'");
		var jqInf2= eval("'#desClasificacion" + numero + "'");
		var jqAgrega1=eval("'#agregaE" + numero + "'");
		var jqElimina1 = eval("'#eliminaE" + numero + "'");

		$(jqProd1).attr('id','producCreditoID'+contador);
		$(jqNombre1).attr('id','descripcionProd'+contador);
		$(jqAlter1).attr('id','destinoCreditoID'+contador);
		$(jqFor1).attr('id','descripcionDestino'+contador);
		$(jqInf1).attr('id','clasificacion'+contador);
		$(jqInf2).attr('id','desClasificacion'+contador);
		$(jqAgrega1).attr('id','agregaE'+contador);
		$(jqElimina1).attr('id','eliminaE'+contador);
		$(jqRenglon1).attr('id','renglon'+ contador);
		contador = parseInt(contador + 1);

	});
	
	asignarTabs();
	revalidarRenglonesError("renglon");
}
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
	});
	return totales;
}

function consultaFilasTiposCta(){
	var totales = 0;
	$('tr[name=renglonTiposCta]').each(function(){
		totales++;
	});
	return totales;
}

function consultaTiposCuenta(){	
	var params = {};
	params['tipoLista'] = 1;
	$.post("gridBANTiposCuenta.htm", params, function(data){	
			if(data.length >0) {	
				$('#gridTiposCuentas').html(data);
				$('#gridTiposCuentas').show();
			}else{					
				$('#gridTiposCuentas').html("");
				$('#gridTiposCuentas').show();
			}
	});
}
function agregaNuevaTiposCta(){
	var numeroFila = consultaFilasTiposCta();
	var nuevaFila = parseInt(numeroFila) + 1;
  	var tds = '<tr id="renglonTiposCta' + nuevaFila + '" name="renglonTiposCta">';
	if(numeroFila == 0){
		tds += '<td><input type="text" size="25"  name="lisTiposCta" 		id="tiposCuentaID'+nuevaFila+'"  		style="text-align: centert" onkeypress="listaTipoCtas(this.id)"onblur="consultaTipoCuentaAyuda(this.id)" /></td>';
		tds += '<td><input type="text" size="25"  name="descripcion" 	id="descripcion'+nuevaFila+'"   style="text-align: left" readOnly="true" /></td>';
	} else{
		var valor = parseInt(numeroFila) + 1
		tds += '<td><input type="text" size="25"  name="lisTiposCta" 		id="tiposCuentaID'+nuevaFila+'"  		style="text-align: center" onkeypress="listaTipoCtas(this.id)"onblur="consultaTipoCuentaAyuda(this.id)" /></td>';
		tds += '<td><input type="text" size="25"  name="descripcion" 	id="descripcion'+nuevaFila+'"   style="text-align: left" readOnly="true" /></td>';
	}
	tds += '<td><input type="button" name="agregaT" id="agregaT'+nuevaFila+'" value="" class="btnAgrega" onclick="agregaNuevaTiposCta()" />';
	tds += ' <input type="button" name="eliminaT" id="eliminaT'+nuevaFila+'" value="" class="btnElimina" onclick="eliminarTipoCta(this.id)" /></td>';
	tds += '</tr>';
	document.getElementById("numeroTiposCta").value = nuevaFila;
	$("#tablaTiposCta").append(tds);
	agregaTipoCta();
	asignarTabs();
	return false;
}
function eliminarTipoCta(control){
	var contador = 0 ;
	var numeroID = control.substr(8, control.length);
	var jqRenglon = eval("'#renglonTiposCta" + numeroID + "'");
	var jqTCta = eval("'#tiposCuentaID" + numeroID + "'");
	var jqDesc = eval("'#descripcion" + numeroID + "'");
	var jqAgrega=eval("'#agregaT" + numeroID + "'");
	var jqElimina = eval("'#eliminaT" + numeroID + "'");

	$(jqTCta).remove();
	$(jqDesc).remove();
	$(jqElimina).remove();
	$(jqAgrega).remove();
	$(jqRenglon).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglonTiposCta]').each(function() {
		numero= this.id.substr(15,this.id.length);
		var jqRenglon1 = eval("'#renglonTiposCta" + numero + "'");
		var jqTCta1 = eval("'#tiposCuentaID" + numero + "'");
		var jqDesc1 = eval("'#descripcion" + numero + "'");
		var jqAgrega1=eval("'#agregaT" + numero + "'");
		var jqElimina1 = eval("'#eliminaT" + numero + "'");

		$(jqTCta1).attr('id','tiposCuentaID'+contador);
		$(jqDesc1).attr('id','descripcion'+contador);
		$(jqAgrega1).attr('id','agregaT'+contador);
		$(jqElimina1).attr('id','eliminaT'+contador);
		$(jqRenglon1).attr('id','renglonTiposCta'+ contador);
		contador = parseInt(contador + 1);
	});
	revalidarRenglonesError("renglonTiposCta");
	asignarTabs();
}
function agregaTipoCta(){
	var contador = 0 ;
	var numeroID = 1;
	var jqRenglon = eval("'#renglonTiposCta" + numeroID + "'");
	var jqTCta = eval("'#tiposCuentaID" + numeroID + "'");
	var jqDesc = eval("'#descripcion" + numeroID + "'");
	var jqAgrega=eval("'#agregaT" + numeroID + "'");
	var jqElimina = eval("'#eliminaT" + numeroID + "'");


	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglonTiposCta]').each(function() {
		numero= this.id.substr(15,this.id.length);
		var jqRenglon1 = eval("'#renglonTiposCta" + numero + "'");
		var jqTCta1 = eval("'#tiposCuentaID" + numero + "'");
		var jqDesc1 = eval("'#descripcion" + numero + "'");
		var jqAgrega1=eval("'#agregaT" + numero + "'");
		var jqElimina1 = eval("'#eliminaT" + numero + "'");


		$(jqTCta1).attr('id','tiposCuentaID'+contador);
		$(jqDesc1).attr('id','descripcion'+contador);
		$(jqAgrega1).attr('id','agregaT'+contador);
		$(jqElimina1).attr('id','eliminaT'+contador);
		$(jqRenglon1).attr('id','renglonTiposCta'+ contador);
		contador = parseInt(contador + 1);

	});
	revalidarRenglonesError("renglonTiposCta");

}

function listaTipoCtas(idControl){
	var jq = eval("'#" + idControl + "'");
	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = num;
		lista(idControl, '3', '1', camposLista, parametrosLista, 'listaTiposCuenta.htm');
	});
}
function consultaTipoCuentaAyuda(idControl) {
	var jqTipo = eval("'#" + idControl + "'");
	var numTipo = $(jqTipo).val();
	var conForanea = 2;
	var jqDesc = eval("'#descripcion" + idControl.substr(13) + "'");
	var TipoCuentaCon = {
		'tipoCuentaID' : numTipo
	};
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if (numTipo != '' && !isNaN(numTipo) && esTab == true) {
		tiposCuentaServicio.consulta(conForanea, TipoCuentaCon, function(tipoCuenta) {
			if (tipoCuenta != null && tipoCuenta!= '') {
				$(jqDesc).val(tipoCuenta.descripcion);
				}
			else{
				mensajeSis("No existe el Tipo de cuenta")
				$(jqTipo).val("");
				$(jqDesc).val("");
				$(jqTipo).focus();
			}
			});
	}
}

var tabGeneral = 19;

function asignarTabs(){
	tabGeneral = 19;
	asignarTabIndexProductos();
	asignarTabIndexTipos();
	tabGeneral++;
	$('#modificar').attr('tabindex' , tabGeneral);
}

function asignarTabIndexProductos(){
	var numeroTab = tabGeneral;
	
	$('#miTabla tr').each(function(index) {
		if(index > 0){
			numeroTab++;
			$('#' + $(this).find("input[name^='lisProducCredito']").attr('id')).attr('tabindex' , numeroTab);
			numeroTab++;
			$('#' + $(this).find("input[name^='descripcionProd']").attr('id')).attr('tabindex' , numeroTab);
			numeroTab++;
			$('#' + $(this).find("input[name^='lisDestinoCredito']").attr('id')).attr('tabindex' , numeroTab);
			numeroTab++;
			$('#' + $(this).find("input[name^='descripcionDestino']").attr('id')).attr('tabindex' , numeroTab);
			numeroTab++;
			$('#' + $(this).find("input[name^='desClasificacion']").attr('id')).attr('tabindex' , numeroTab);
			numeroTab++;
			$('#' + $(this).find("input[name^='eliminaE']").attr('id')).attr('tabindex' , numeroTab);
			numeroTab++;
			$('#' + $(this).find("input[name^='agregaE']").attr('id')).attr('tabindex' , numeroTab);
		}
	});
	
	tabGeneral = numeroTab;
}

function asignarTabIndexTipos(){
	var numeroTab = tabGeneral;
	
	$('#tablaTiposCta tr').each(function(index) {
		if(index > 0){
			numeroTab++;
			$('#' + $(this).find("input[name^='lisTiposCta']").attr('id')).attr('tabindex' , numeroTab);
			numeroTab++;
			$('#' + $(this).find("input[name^='descripcion']").attr('id')).attr('tabindex' , numeroTab);
			numeroTab++;
			$('#' + $(this).find("input[name^='agregaT']").attr('id')).attr('tabindex' , numeroTab);
			numeroTab++;
			$('#' + $(this).find("input[name^='eliminaT']").attr('id')).attr('tabindex' , numeroTab);
		}
	});
	
	tabGeneral = numeroTab;
}

/**
 * Metodo que realiza la revalidacion de renglones de un grid.
 * Busca los campos con mensajes de error, limpia y revalida(Simula Ordenacion)
 * @param nombreRenglon
 * @returns void
 */
function revalidarRenglonesError(nombreRenglon){
	$('tr[name='+nombreRenglon+']').each(function() {
	    var numero = this.id.substr(nombreRenglon.length, this.id.length);
	    $("#" + nombreRenglon + numero).find(".error + label[generated='true']").each( 
			function(){	    	
				var campoError = $(this).prev();
				$(this).remove();
				var jControl = eval("'#" + campoError.attr('id') + "'");
				$(jControl).valid();
			}					
		);	  
	});
}





