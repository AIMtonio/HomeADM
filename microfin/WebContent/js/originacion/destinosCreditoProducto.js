var estatusProd = "";
var descripcion = "";
$(document).ready(function() {
	
	//Definicion de Constantes y Enums  
	//Definicion de Constantes y Enums  
	var consultaProductosCredito = {
			'foranea':2,
	};		
	var transaccionDestinosPorProducto = {
			'grabar':1,
	};		
	
	var parametroBean = consultaParametrosSession(); 
	esTab = true;
	
	$("#productoCreditoID").focus();
	deshabilitaBoton('grabar', 'submit');
	agregaFormatoControles('formaGenerica');
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
 	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) { 
          grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','productoCreditoID','exitoDestinosPorProd', 'falloDestinosPorProd');	
      }
   });					

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#grabar').click(function() {	
		$('#tipoTransaccion').val(transaccionDestinosPorProducto.grabar);
	});
	
	$('#productoCreditoID').bind('keyup',function(e){ 
		lista('productoCreditoID', '1', '15', 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');				       
	});  

	$('#productoCreditoID').blur(function() {
		if(isNaN($('#productoCreditoID').val()) ){
			$('#productoCreditoID').val("");
			$('#productoCreditoID').focus();
			$('#descripcionProducto').val("");
		}else{ 
			esTab = true;
			consultaProducCreditoForanea(this.id);
		}
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			productoCreditoID: { 
				required: true
			}
		},
		messages: {
			productoCreditoID: {
				required: 'Especifique Producto de Crédito'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	//consulta foranea del producto de credito  
	function consultaProducCreditoForanea(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCredBeanCon = {
  			'producCreditoID':$(jqProdCred).val() 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		estatusProd = "";
		descripcion = "";
		if($(jqProdCred).val() != '' && !isNaN($(jqProdCred).val()) && esTab){
			productosCreditoServicio.consulta(consultaProductosCredito.foranea,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#descripcionProducto').val(prodCred.descripcion);
					estatusProd = prodCred.estatus;
					descripcion = prodCred.descripcion;
					//se consulta el grid de destinos por credito
					muestraGridDestinosPorProducto($(jqProdCred).val());
				}else{							
					mensajeSis("No Existe el Producto de Crédito");
					$('#productoCreditoID').focus();
					$('#productoCreditoID').val("");	
					$('#descripcionProducto').val("");	
					deshabilitaBoton('grabar', 'submit');
				}
			});
		}				 					
	}
	
});// fin del ready

// Funcion que muestra el grid de destinos por producto de credito
function muestraGridDestinosPorProducto(varProductoCredito){  
	if(!isNaN(varProductoCredito)){
		var params = {};
		params['productoCreditoID'] = varProductoCredito;
		params['tipoLista']			= 1;
		
		$.post("destinosCreditoProductoGrid.htm", params, function(data){
			if(data.length > 0){
				$('#gridDestinosPorProducto').show();
				$('#gridDestinosPorProducto').html(data);
				if(estatusProd == 'I'){
					mensajeSis("El Producto "+ descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#productoCreditoID').focus();
					deshabilitaBoton('grabar', 'submit');
				}else{
					habilitaBoton('grabar', 'submit');
				}
			}else{
				mensajeSis('No se han encontrado Destinos de Crédito.');
				$('#gridDestinosPorProducto').html("");
			}
		}); 
	}
}// FIN - Funcion que muestra el grid de destinos por producto de credito

/* FUNCION PARA ASIGNAR VALOR CUANDO SELECCIONAN UN ELEMENTO*/
function funcionAsignaValorCheckAsignar(idAsinar,consecutivo){
	var jqCheckAsinar  = eval("'#" + idAsinar + "'");
	var jqDestinoCred = eval("'#destinoCreID" +consecutivo+ "'");	
	if($(jqCheckAsinar).is(':checked')){  
		$(jqCheckAsinar).val($(jqDestinoCred).val());
	}else{
		$(jqCheckAsinar).val("0");
	}
}

/* FUNCION PARA SELECCIONAR O NO SELECCIONAR TODOS LOS CHECKS*/
function funcionSeleccionarTodosCheck(idAsinar){
	var jqCheckTodos  = eval("'#" + idAsinar + "'");
	var consecutivo = 0;
	$('input[name=listaAsignar]').each(function() {
		consecutivo = consecutivo + 1;
		var jqCheckAsinar = eval("'#" + this.id + "'");	
		var jqDestinoCred = eval("'#destinoCreID" +consecutivo+ "'");	
		if( $(jqCheckTodos).is(":checked") ){
			$(jqCheckAsinar).attr('checked','true');
			$(jqCheckAsinar).val($(jqDestinoCred).val()); 
     	}else{
     		$(jqCheckAsinar).removeAttr('checked');
     		$(jqCheckAsinar).val("0");       		
     	}
	});
}


function exitoDestinosPorProd(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 
			inicializaForma('formaGenerica','productoCreditoID');
			//$('#gridDestinosPorProducto').html("");
		   $('#gridDestinosPorProducto').hide();					
		}
        }, 100);
	}					
}

function falloDestinosPorProd(){
}
	
