var esTab = false;
var parametroBean;

$(document).ready( function() {
			
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
					var idsCompareDest = [];
					var duplicados = false;
					$('#miTabla tr').each(function(index) {
						if(index > 0){
							var value = $('#' + $(this).find("input[name^='lisProducCredito']").attr('id')).val();
							var found = idsCompare.indexOf(value);
							
							var valueDest = $('#' + $(this).find("input[name^='lisDestinoCredito']").attr('id')).val();
							var foundDest = idsCompareDest.indexOf(valueDest);
							
							if(found != -1 && foundDest != -1){
								duplicados = true;
							}
							idsCompare.push(value);
							idsCompareDest.push(valueDest);
						}
					});

					if(!duplicados){
						if($("[name ='renglon']").length > 0){
							grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma','mensaje', 'true', 'clienteID','exitoTransUsuario', 'falloTransUsuario');
						}else{
							var registroElim = $('#productoCreditoFWIDs').val();
							if(registroElim != ""){
								grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma','mensaje', 'true', 'clienteID','exitoTransUsuario', 'falloTransUsuario');
							}else{
								mensajeSis("Especifique al menos un Producto de Crédito.");
							}
						}
					}else{
						mensajeSis("Especifique valores que no sean duplicados[Destino].");
					}

				}
			});

			// ------------ Validaciones de la Forma
			
			$('#formaGenerica').validate({
				rules : {
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
					
				},
				messages : {
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
				}
			});
			
			consultaProductosCredito();
		}
		
);


function exitoTransUsuario() {
	agregaFormatoControles('formaGenerica');
	$('#productoCreditoFWIDs').val("");
	$('#esModificado').val(0);
	consultaProductosCredito();
}

function falloTransUsuario() {
	agregaFormatoControles('formaGenerica');
}

function consultaProductosCredito(){	
	var params = {
	};
	params['page'] = 0;
	params['perfilID'] = parametroBean.perfilUsuario;
	params['numRegistros'] = 15;
	params['tipoLista'] = 3;
	
	$.post("listaFWProductosCredito.htm", params, function(data){				
			if(data.length >0) {
				$('#gridProductosCreditos').html(data);
				$('#gridProductosCreditos').show();
			}else{					
				$('#gridProductosCreditos').html("");
				$('#gridProductosCreditos').show();
			}
	});
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
	$('#esModificado').val(1);
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
	$('#esModificado').val(1);
}

function agregaNuevoProducto(){
	var numeroFila = consultaFilas();
	var nuevaFila = parseInt(numeroFila) + 1;
  	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	if(numeroFila == 0){
		tds += '<input type="hidden" id="productoCreditoFWID'+nuevaFila+'" name="lisProductoCreditoFWID"  value="0" style="text-align: center; width: 100% "/>';
		tds += '<td align="center"><input  id="producCreditoID'+nuevaFila+'" name="lisProducCredito"  size="8"  value="" autocomplete="off"  type="text" onkeyPress="listaProd(this.id)" onblur="consultaProductosCreditoAyuda(this.id)" style="text-align: center; width: 100% "/></td>';
		tds += '<td align="center"><input type="text" id="descripcionProd'+nuevaFila+'" name="descripcionProd" size="8" value="" maxlength="200" autocomplete="off" style="text-align: left; width: 100%" readOnly="true" /></td>';
		tds += '<td align="center"><input  id="destinoCreditoID'+nuevaFila+'" name="lisDestinoCredito"  size="8"  value="" autocomplete="off"  type="text" onkeyPress="listaDestinos(this.id)" onblur="consultaDestinoCredito(this.id)" style="text-align: center; width: 100% " /></td>';
		tds += '<td align="center"><input type="text" id="descripcionDestino'+nuevaFila+'" name="descripcionDestino" size="8" value="" maxlength="200" autocomplete="off" style="text-align: center; width: 100%" readOnly="true" /></td>';
		tds += '<td align="center"><input type="hidden" id="clasificacion'+nuevaFila+'" name="lisClasificacion" size="8" value="" maxlength="200" autocomplete="off" style="text-align: center; width: 100% "readOnly="true" /><input type="text" id="desClasificacion'+nuevaFila+'" name="desClasificacion" size="8" value="" maxlength="200" autocomplete="off" style="text-align: left; width: 100% " readOnly="true" /></td>';
	} else{
		var valor = parseInt(numeroFila) + 1
		tds += '<input type="hidden" id="productoCreditoFWID'+nuevaFila+'" name="lisProductoCreditoFWID" value="0" style="text-align: center; width: 100% "/>';
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
	$('#esModificado').val(1);
}

var idsCompareProdDest = [];
function eliminarProducto(control){
	
	var contador = 0 ;
	var numeroID = control.substr(8, control.length);
	
	idsCompareProdDest.push(numeroID);
	$('#productoCreditoFWIDs').val(idsCompareProdDest);
	$('#esModificado').val(1);
	
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

var tabGeneral = 19;

function asignarTabs(){
	tabGeneral = 19;
	asignarTabIndexProductos();
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





