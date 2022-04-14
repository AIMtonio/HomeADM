$(document).ready(function() {
	var parametroBean = consultaParametrosSession();
	esTab = true;

	var catTipoListaCliente = {
  		'Principal'	:	'1',
	};	

	var catTipoconsultaCliente = {
  		'PantallaForanea'	:	5,
	};	

	$(':text').focus(function() {	
	 	esTab = false;
	});
  
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#numero').bind('keyup',function(e){
		lista('numero', '3', catTipoListaCliente.Principal, 'nombreCompleto',
				 $('#numero').val(), 'listaCliente.htm');
	});
	
	$('#numero').blur(function() {
  		consultaCliente(this.id);
	});
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccion(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero');
		}
	});
	$('#nomEmpresa').val(parametroBean.nombreInstitucion);
	$('#telefonoCasa').setMask('phone-us');
	
	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			numero : {
				required : true
			},
			extTelefonoPart: {
				number: true
			}
		},
		messages : {
			numero : {
				required : 'Especificar numero de Cliente'
			},
			extTelefonoPart: {
				number: 'Sólo Números'
			}
		}
	});
	 
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = catTipoconsultaCliente.PantallaForanea;	
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
						if(cliente!=null){
							$('#numero').val(cliente.numero);
							$('#nombreCliente').val(cliente.nombreCompleto);
							$('#RFC').val(cliente.RFC);
							$('#telefonoCasa').val(cliente.telefonoCasa);				
							$('#extTelefonoPart').val(cliente.extTelefonoPart);						
							$('#telefonoCasa').setMask('phone-us');
							$('#consultarRep').focus();
							
						}else{
							alert("No Existe el Cliente");
							inicializaForma('formaGenerica', 'numero');
							$('#numero').focus();
							$('#numero').select();
						}    	 						
				});
			}
		}	
	$('#consultarRep').click(function() {		
		$('#numero').focus();
		$('#numero').select();		
	});	
	
		
		
});