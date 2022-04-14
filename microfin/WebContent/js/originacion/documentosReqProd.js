var tab2=false;
var estatusProd = "";
var descripcion = "";
$(document).ready(function() {
		esTab = true;
		
		$("#producCreditoID").focus();
	 	
	//Definicion de Constantes y Enums  
	var catTipoConsultaDocReq = {
  		'principal':1,
  		'foranea':2,
	};		
	
	var catTipoTranDocReq = {
  		'agrega':1,
  		'modifica':2,
  		'grabalista':3
	};
	
	var parametroBean = consultaParametrosSession();  

	//------------ Metodos y Manejo de Eventos -----------------------------------------
 	deshabilitaBoton('grabar', 'submit');


	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) { 
          grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','exito');	
      }
   });					

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	
	$('#grabar').click(function() {	
		$('#tipoTransaccion').val(catTipoTranDocReq.grabalista);
		guardarDetalle(); 
	});
	
	$('#producCreditoID').bind('keyup',function(e){ 
		
		lista('producCreditoID', '1', '15', 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');				       
	});  

	$('#producCreditoID').change(function() {
		if(isNaN($('#producCreditoID').val()) ){
			$('#producCreditoID').val("");
			$('#producCreditoID').focus();
			$('#descripProducto').val("");
			tab2 = false;
		}else{
			tab2=true;
			esTab = true;
			consultaProducCreditoForanea(this.id);
		}	
	});


	$('#producCreditoID').blur(function() {
		if(isNaN($('#producCreditoID').val()) ){
			$('#producCreditoID').val("");
			$('#producCreditoID').focus();
			$('#descripProducto').val("");
			tab2 = false;
		}else{ 
			if(tab2 == false){
				esTab = true;
				consultaProducCreditoForanea(this.id);
		 	}
		}
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			producCreditoID: { 
				required: true
			}
		
			
			
		},
		
		messages: {
			producCreditoID: {
				required: 'Especificar Producto'
			}
			
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	//consulta foranea del producto de credito  
	function consultaProducCreditoForanea(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		estatusProd = "";
		descripcion = "";
			if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
				productosCreditoServicio.consulta(catTipoConsultaDocReq.foranea,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){
						esTab=true;
						$('#descripProducto').val(prodCred.descripcion);
						estatusProd = prodCred.estatus;
						descripcion = prodCred.descripcion;
						consultaDocumentosReqProdGrid();
					}else{							
						mensajeSis("No Existe el Producto de Crédito");
						$('#producCreditoID').focus();
						$('#producCreditoID').select();	
						deshabilitaBoton('grabar', 'submit');
						$('#gridDocumentosReq').html('');																	
					}
			});
			}				 					
	}

	

	function consultaDocumentosReqProdGrid(){
		$('#gridDocumentosReq').html('');
		$('#detalleDocumentosReq').val("");
		
		var params = {};		
		params['tipoLista'] = catTipoConsultaDocReq.foranea;
		params['producCreditoID'] = $('#producCreditoID').val();
		$.post("documentosReqProdGridVista.htm", params, function(data){
			
			if(data.length >0) { 
				$('#gridDocumentosReq').html(data); 
				$('#gridDocumentosReq').show();

				if(estatusProd == 'I'){
					mensajeSis("El Producto "+ descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#producCreditoID').focus();
					deshabilitaBoton('grabar', 'submit');
				}else{
					habilitaBoton('grabar', 'submit');
				}
			}else{
				$('#gridDocumentosReq').html("");
				$('#gridDocumentosReq').show();
			}			
		}); 
	}
	
	


	
	
	
	function guardarDetalle(){		  		
			var numDetalle = $('input[name=numero]').length;
			$('#detalleDocumentosReq').val("");
			for(var i = 1; i <= numDetalle; i++){
				var jqClasif  = eval("'#clasificaTipDocID" +i+ "'");
				var checkDoc= eval("'#checkDoc" +i+ "'");
				if(i == 1 && ($(checkDoc).is(':checked')) == true){
				$('#detalleDocumentosReq').val($('#detalleDocumentosReq').val() +
											document.getElementById("clasificaTipDocID"+i+"").value + ']');
				}else{
					if(($(checkDoc).is(':checked')) == true){
					$('#detalleDocumentosReq').val($('#detalleDocumentosReq').val() + '[' +
											document.getElementById("clasificaTipDocID"+i+"").value+ ']');		
					}	
				}	
			}
		
	}
	
	
	
	$('#clasificaTipDocID').focus();
	
	
});

	
		
	function exito(){
		tab2 = false;
	}
	
