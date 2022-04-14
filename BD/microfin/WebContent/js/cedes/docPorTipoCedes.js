var tab2=false;
$(document).ready(function() {
		esTab = true;
	 	
	//Definicion de Constantes y Enums  
	var catTipoConsultaDocReq = {
  		'foranea':2,	
  		'docTpoCede':4	
	};		
	
	var catTipoTranDocReq = {
  		'grabalista':3
	};
	
	var catTipoConsultaCedes = {
			'general' : 2,

	};
	
	var catTipoListaTipoCede = {
			'principal':1
		};	
	 
	var parametroBean = consultaParametrosSession();  

	//------------ Metodos y Manejo de Eventos -----------------------------------------
 	deshabilitaBoton('grabar', 'submit');
	$('#tipoProducto').focus();

	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) { 
          grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoProducto','exito');	
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
	
	
	$('#tipoProducto').bind('keyup',function(e){
		
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "descripcion";
		 parametrosLista[0] = $('#tipoProducto').val();
		
		lista('tipoProducto', 2, catTipoListaTipoCede.principal, camposLista,
				 parametrosLista, 'listaTiposCedes.htm');
	});	
		
	$('#tipoProducto').blur(function() {
		if( esTab == true){
			
		validaTipoCede(this);
		}
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			tipoProducto: { 
				required: true
			}	
		},
		messages: {
			tipoProducto: {
				required: 'Especificar Tipo de Cuenta'
			}	
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------


/* se valida el tipo de cede*/
	
	function validaTipoCede(){
		var tipoCede = $('#tipoProducto').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(tipoCede != '' && !isNaN(tipoCede)){
			
			if(tipoCede == '0'){
				alert("No Existe el Tipo de Cede");	
				$('#tipoProducto').focus();
				$('#tipoProducto').val('');
				deshabilitaBoton('agrega', 'submit');
				$('#divListaTipoDoctosCap').hide();
				$('#gridDocumentosReq').html('');
				$('#detalleDocumentosReq').val("");
			}else{
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');				
				var tiposCedesBean = {
		                'tipoCedeID':tipoCede,
		                'monedaId':0
		        };
								
				tiposCedesServicio.consulta(catTipoConsultaCedes.general, tiposCedesBean,{ async: false, callback: function(tiposCedes){
					if(tiposCedes!=null){
						dwr.util.setValues(tiposCedes);						
						consultaDocumentosReqProdGrid();
						habilitaBoton('agrega', 'submit');
						
					}else{
						alert("No Existe el Tipo de Cede");
						deshabilitaBoton('agrega', 'submit');
						$('#tipoProducto').focus();
						$('#tipoProducto').val('');
						$('#divListaTipoDoctosCap').hide();
						$('#gridDocumentosReq').html('');
						$('#detalleDocumentosReq').val("");
						inicializaForma('formaGenerica','tipoProducto');
					}
					
				}
			});
				
			}
			
		}		
	}
	
	
	function consultaDocumentosReqProdGrid(){
		$('#gridDocumentosReq').html('');
		$('#detalleDocumentosReq').val("");
		
		var params = {};		
		params['tipoLista'] = catTipoConsultaDocReq.docTpoCede;
		params['tipoProducto'] = $('#tipoProducto').val();
		$.post("docPorTipoCedesGrid.htm", params, function(data){
			if(data.length >0) { 
				$('#gridDocumentosReq').html(data); 
				$('#gridDocumentosReq').show();
				habilitaBoton('grabar', 'submit');
				seleccionaFoco();
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
			var jqClasif  = eval("'#tipoDocCapID" +i+ "'");
			var checkDoc= eval("'#checkDoc" +i+ "'");
			if(i == 1 && ($(checkDoc).is(':checked')) == true){
			$('#detalleDocumentosReq').val($('#detalleDocumentosReq').val() +
										document.getElementById("tipoDocCapID"+i+"").value + ']');
			}else{
				if(($(checkDoc).is(':checked')) == true){
				$('#detalleDocumentosReq').val($('#detalleDocumentosReq').val() + '[' +
										document.getElementById("tipoDocCapID"+i+"").value+ ']');		
				}	
			}	
		}
}
		
}); /*Termina el document*/

function seleccionaFoco(){
	$('input[name=checkDoc]').each(function () {
	
	});
		$('#checkDoc1').focus();
	$('#checkDoc1').select();
}

function selecTodoCheckout(idControl){
	var jqSelec  = eval("'#" + idControl + "'");
	var cont = 0;
	if ($(jqSelec).is(':checked')){
		$('input[name=checkDoc]').each(function () {
			$(this).attr('checked', 'true');
			cont ++;
		});
	}else {
		$('input[name=checkDoc]').each(function () {
		$(this).removeAttr('checked');
		});	
	}

}
		
	function exito(){
		tab2 = false;
	}
	
