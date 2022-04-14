//DECLARACION DE VARIABLES GLOBALES
var parametroBean = consultaParametrosSession();
var fechaSis = "";
var anio = 0;
var mes = 0;
var anioAux=0;


$("#tipoGeneracion").click(function(){
	$('.mes').show();
	$('.semestre').hide();
	$('.semestre1').hide();
	$('.semestre2').hide();
	$('#mes').val(mes);
	$('.gridProd').html("");
	$('#semestre').val("");
	$('#mesInicioGen').val("");
  	$('#mesFinGen').val("");
});

$("#tipoGeneracion1").click(function(){
  	$('.mes').hide();
	$('.semestre').show();
	$('.semestre1').hide();
	$('.semestre2').hide();
	$('#mes').val("");
	$('.gridProd').html("");
});

$("#semestre").change(function(){
  	$('.mes').hide();
  	$('.semestre').show();
  	if ($('#semestre').val()=="1") {
  		$('.semestre1').show();
  		$('.semestre2').hide();
  		$('#mesInicioGen').val("01");
  		$('#mesFinGen').val("06");
  	}

  	if ($('#semestre').val()=="2") {
  		$('.semestre2').show();
  		$('.semestre1').hide();
  		$('#mesInicioGen').val("06");
  		$('#mesFinGen').val("12");
  	}

});

$("#mes").change(function(){
	if (parseInt($("#mes").val()) > mes ||  $("#mes").val()=="") {
		mensajeSis("El mes seleccionado no es valido");
		$("#mes").val(mes);
		$("#mes").focus();
	}
});

$("#agregarFila").click(function(){
	if ($("#tipoGeneracion1").is(":checked") && $("#semestre").val()=="") {
		mensajeSis("Seleccionar el semestre correspondiente");
		$("#semestre").focus();
	}
	else{
		agregaNuevoDetalleProducto();
	}

});

$('#generaCadena').click(function() {
	$('#tipoTransaccion').val(1);
});

$('#timbrar').click(function() {
	$('#tipoTransaccion').val(2);
});



$(document).ready(function() {
	parametroBean = consultaParametrosSession();
	fechaSis = parametroBean.fechaSucursal;
	anio = fechaSis.substring(0,4);
	mes = fechaSis.substring(5,7);
	$("#anio").prepend("<option value='"+anio+"' >"+anio+"</option> ");
	if (parseInt(mes)==1) {
		for (var i = 1; i >=1; i--) {
			anioAnterior = anio-i;
			$("#anio").prepend("<option value='"+anioAnterior+"' >"+anioAnterior+"</option> ");
			$("#anio").val(1);
			$("#anio").select();
			$("#anio").focus();
		}
	}


	$('#mes').val(mes);
	$('#tipoGeneracion').attr("checked",true);
	$('#tipoGeneracion1').attr("checked",false);

	$('.mes').show();
	$('.semestre').hide();
	$('.semestre1').hide();
	$('.semestre2').hide();


	$.validator.setDefaults({
	    submitHandler: function(event) {
	    	if (verificarVacios()==false && $('input[name=lproductoCredID]').length>0) {
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoGeneracion', 'funcionExito','funcionError');
	    	}
	    	else{
	    		mensajeSis('Disculpa las molestias. Existen campos Vacios del Grid');
	    	}

	  }
	});


	$('#formaGenerica').validate({

		rules: {

		},
		messages: {

		}
	});

});


// ------------ Validaciones de la Forma
function funcionExito(){
}

function funcionError(){
}

//consulta cuantas filas tiene el grid de los productos
function consultaFilasProductos(){
	var totales=0;
	$('tr[name=renglonProducto]').each(function() {
		totales++;
	});
	return totales;
}


// VALIDA CAMPOS VACIO DEL GRID DEDETALLES DE GARANTIA
function verificarVacios(){
	var numDetalle = $('input[name=lproductoCredID]').length;
	var cont=0;
	for ( var i = 1; i <= numDetalle; i++) {
		var producto = $('#lproductoCredID'+i).val();  //Producto
		if (producto == "" ) {
			$('#lproductoCredID'+i).select();
			$('#lproductoCredID'+i).focus();
			$('#lproductoCredID'+i).addClass("error");
			i = numDetalle;
			cont++;
		}
	}

	if (cont==0) {
		return false;
	}
	else{
		return true;
	}

}
// SE AGREGA EL NUEVO DETALLE DEL PRODUCTO
function agregaNuevoDetalleProducto(){

	if(verificarVacios()==true){
		mensajeSis('Disculpa las molestias, No Puede agregar otra fila sin rellenar la anterior.');
	}
	else{
		var numeroFila=consultaFilasProductos();
		var nuevaFila = parseInt(numeroFila) + 1;
		var tds = '<tr class="gridProd" id="renglonProducto'+ nuevaFila+ '" name="renglonProducto">';
		if(numeroFila == 0){
			tds += '<td nowrap="nowrap"><input  id="ltamanioLista'+nuevaFila+'" name="ltamanioLista" size="6" value="1" autocomplete="off"  type="hidden"/>';
			tds += '<input name="lproductoCredID" id="lproductoCredID'+nuevaFila+'" autofocus="true" maxlength="6" rows="1" onkeypress="listaProductos(this.id)" onblur="validaProducCredi('+nuevaFila+');" maxlength="10" size="15"></td>';
			tds += '<td nowrap="nowrap"><input name="nombreProducto" id="nombreProducto'+nuevaFila+'" rows="1" onblur="" size="50" disabled></td>';
			tds += '<td nowrap="nowrap"><input type="button" name="eliminar" id="'+nuevaFila +'"  value="" class="btnElimina" onclick="eliminaDetalleProducto(this.id)" />';
			tds += ' <input type="button" name="agrega" id="'+nuevaFila +'"  value="" class="btnAgrega" onclick="agregaNuevoDetalleProducto()"/></td>';

		} else{
			var valor = numeroFila+ 1;
			tds += '<td nowrap="nowrap"><input  id="ltamanioLista'+nuevaFila+'" name="ltamanioLista" size="6" value="1" autocomplete="off"  type="hidden"/>';
			tds += '<input name="lproductoCredID" id="lproductoCredID'+nuevaFila+'" autofocus="true" maxlength="6" rows="1" onkeypress="listaProductos(this.id)" onblur="validaProducCredi('+nuevaFila+');" maxlength="10" size="15"></td>';
			tds += '<td nowrap="nowrap"><input name="nombreProducto" id="nombreProducto'+nuevaFila+'" rows="1" onblur="" size="50" disabled></td>';
			tds += '<td nowrap="nowrap"><input type="button" name="eliminar" id="'+nuevaFila +'"  value="" class="btnElimina" onclick="eliminaDetalleProducto(this.id)" />';
			tds += ' <input type="button" name="agrega" id="'+nuevaFila +'"  value="" class="btnAgrega" onclick="agregaNuevoDetalleProducto()"/></td>';

		}
		tds += '</tr>';

		$("#miTablaProductos").append(tds);
		return false;
	}


}

function eliminaDetalleProducto(numeroID){
	var jqRenglon = eval("'#renglonProducto" + numeroID + "'");
	var jqNumero = eval("'#ltamanioLista" + numeroID + "'");
	var jqProducto=eval("'#lproductoCredID" + numeroID + "'");
	var jqNombreProd=eval("'#nombreProducto" + numeroID + "'");
	var jqAgrega=eval("'#agrega" + numeroID + "'");
	var jqElimina = eval("'#" + numeroID + "'");

	$(jqRenglon).remove();
	$(jqNumero).remove();
	$(jqProducto).remove();
	$(jqNombreProd).remove();
	$(jqAgrega).remove();
	$(jqElimina).remove();
	$('#renglonProducto'+numeroID).remove();

	var existenGrids = false;
	var contador=0;
	$('input[name=ltamanioLista]').each(function() {
		var jqConsecutivo = eval("'#" + this.id + "'");
		existenGrids = true;
		contador++;
		$(jqConsecutivo).val(contador);
		var tamanio = jqConsecutivo.length;
		var numero = jqConsecutivo.substr(14,tamanio);
		$('#monto'+numero).attr('id', 'monto'+numero);
		agregaFormatoControles('formaGenerica');
	});
	if(existenGrids==false) {
		//agregaNuevoDetalleProducto();
	}

}

function listaProductos(idControl){
	var jq = eval("'#" + idControl + "'");
	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();
		var tipoGeneracion = "";
		if($("#tipoGeneracion").is(":checked")==true){
			 tipoGeneracion = "M";
		}
		if($("#tipoGeneracion1").is(":checked")==true){
			tipoGeneracion = "E";
		}

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "frecuenciaID";

		parametrosLista[0] = tipoGeneracion;
		lista(idControl, '2', '2', camposLista, parametrosLista, 'listaTimbradoProduc.htm');
	});
}

function validaProducCredi(controlID) {
	var control = "lproductoCredID";
	var productoCredito = $("#lproductoCredID"+controlID).val();
	var frecuenciaProd = "";
	var principal=1;

	if($("#tipoGeneracion").is(":checked")==true){
		frecuenciaProd = "M";
	}
	if($("#tipoGeneracion1").is(":checked")==true){
		frecuenciaProd = "E";
	}

	setTimeout("$('#cajaLista').hide();", 200);
	if(productoCredito != '' && !isNaN(productoCredito)){
		var productoCreditoBeanCon = {
	    	'producCreditoID':productoCredito,
	    	'frecuenciaID':frecuenciaProd
		};
		if(verificaSeleccionado(controlID) == 0){
			frecTimbradoProducServicio.consulta(principal, productoCreditoBeanCon,function(prodCred) {
		        if(prodCred!=null){
		          $("#nombreProducto"+controlID).val(prodCred.descripcion);
		          $('#lproductoCredID'+controlID).removeClass("error");
		          validaTimbradoProducto(controlID);
		         }
	          else{
	            mensajeSis("El Número de Producto de Crédito no Existe.");
	            $("#lproductoCredID"+controlID).val("");
	            $("#nombreProducto"+controlID).val("");
	            $("#lproductoCredID"+controlID).focus();

	          }
		  	});
		}
	}
	else {
		$("#nombreProducto"+controlID).val("");
		$("#lproductoCredID"+controlID).val("");
	}
}

function validaTimbradoProducto(controlProdID) {
	var productoCredito = $("#lproductoCredID"+controlProdID).val();
	var productoCreditoBeanCon = {
    	'productoCredID':productoCredito,
    	'anio':$("#anio").val(),
    	'mesInicioGen':$("#mes").val(),
    	'mesFinGen':$("#mes").val(),
    	'semestre':$("#semestre").val(),
	};

	timbradoPorProductoServicio.consulta(1, productoCreditoBeanCon,function(timbradoProducto) {
       if(timbradoProducto!=null){
          if (timbradoProducto.timbrado=="S") {
          	 mensajeSis("El Producto seleccionado ya se encuentra <b>TIMBRADO<b>.");
	        $("#lproductoCredID"+controlProdID).val("");
	        $("#nombreProducto"+controlProdID).val("");
	        $("#lproductoCredID"+controlProdID).focus();
          }
       }
      else{
    	mensajeSis("No se encuentra información del <b>PRODUCTO</b> seleccionado.");
        $("#lproductoCredID"+controlProdID).val("");
        $("#nombreProducto"+controlProdID).val("");
        $("#lproductoCredID"+controlProdID).focus();

      }
  	});
}



function verificaSeleccionado(controlID){
	var contador = 0;
	var Producto  =$('#lproductoCredID'+controlID).val();
	var idCampoActual = "lproductoCredID"+controlID;

	$('tr[name=renglonProducto]').each(function() {
		var numero= this.id.substr(15,this.id.length);
		var jqIdProduc = eval("'lproductoCredID" + numero+ "'");
		var valorProduc = $('#'+jqIdProduc).val();
		if(jqIdProduc != idCampoActual){
			if(valorProduc == Producto ){
				mensajeSis("El Número de Producto debe ser distinto a los anteriores.");
				$('#lproductoCredID'+controlID).focus();
				$('#lproductoCredID'+controlID).select();
				$('#lproductoCredID'+controlID).val("");
				$('#nombreProducto'+controlID).val("");
				contador = contador+1;
			}
		}
	});
	return contador;
}
