$(document).ready(function() {
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
	
	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "clienteID";
			
			parametrosLista[0] = $('#cuentaAhoID').val();
				
						
			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}				       
	});	
	
	$('#cuentaAhoID').blur(function() {
  		consultaCtaAho(this.id);
	});
	
	
	function consultaCtaAho(idControl) {
		var jqCtaAho  = eval("'#" + idControl + "'");
		var numCtaAho = $(jqCtaAho).val();	
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCtaAho
		};
		var conCtaAho =4;
		var var_estatus;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCtaAho != '' && !isNaN(numCtaAho) && esTab){
			cuentasAhoServicio.consultaCuentasAho(conCtaAho,CuentaAhoBeanCon,function(ctaAho){
						if(ctaAho!=null){
							$('#cuentaAhoID').val(ctaAho.cuentaAhoID);							
							$('#clienteID').val(ctaAho.clienteID);
							$('#tipoCuenta').val(ctaAho.descripcionTipoCta); 
							consultaCliente('clienteID');
						
						}else{
							alert("No Existe la Cuenta de Ahorro");
							$(jqCtaAho).focus();
						}    						
				});
		}	
	}

	
	$('#anexo').click(function(event) {	
		var ctaAho = $('#cuentaAhoID').val();
		var tp1 = $('#tipoPersona').val();
		var tp2 = $('#tipoPersona2').val();		  
		if(tp2 = 'M'){ 
		$('#liga').attr('href','AnexoPortadaContratoCtaPM.htm?cuentaAhoID='+ctaAho);   
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
							$('#clienteID').val(cliente.numero);
							$('#nombreCte').val(cliente.nombreCompleto);
							if(cliente.tipoPersona=='F'){	
							$('#anexo').hide();						
								$('#tipoPersona').attr("checked","1") ;
								$('#tipoPersona2').attr("checked",false) ;
								} 
							else{
							if(cliente.tipoPersona=='M')
								$('#tipoPersona2').attr("checked","1") ;
								$('#tipoPersona').attr("checked", false);
									$('#anexo').show();
								}
							$('#consultarRep').focus();
							
						}else{
							alert("No Existe el Cliente");
							inicializaForma('formaGenerica', 'numero');
							$('#clienteID').focus();
							$('#clienteID').select();
						}    	 						
				});
			}
		}	
		

		
		
});