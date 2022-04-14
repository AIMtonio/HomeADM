$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();   
	var catTipoListaCliente = {
  		'Principal'	:	'1',
	};	

	var catTipoconsultaCliente = {
  		'PantallaForanea'	:	5,
	};	

	var tipoPersona;
	
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------


		
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
	
	$('#tipoPersona').click(function() {
		if($('#tipoPersona2').is(':checked')) {
			$('#tipoPersona2').attr('checked',false);
		}
	});
	
	$('#tipoPersona2').click(function() {
		if($('#tipoPersona').is(':checked')) {
			$('#tipoPersona').attr('checked',false);
		}
	});
	
	$('#pdf').click(function() {
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		if ($('#cuentaAhoID').val() == '') {
			alert('Especifique una Cuenta');
			$('#cuentaAhoID').focus();
			return false;
		}
		var ctaAho= $('#cuentaAhoID').val();
		$('#enlace').attr('href','RepConocimientoCtaPDF.htm?cuentaAhoID='+ctaAho+'&tipoPersona='+tipoPersona+'&nombreInstitucion='+nombreInstitucion);
	});
	
	function consultaCtaAho(idControl) {
		var jqCtaAho  = eval("'#" + idControl + "'");
		var numCtaAho = $(jqCtaAho).val();
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCtaAho
		};
		var conCtaAho =3;
		var var_estatus;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaAho != '' && !isNaN(numCtaAho) && esTab){
			cuentasAhoServicio.consultaCuentasAho(conCtaAho,CuentaAhoBeanCon,function(ctaAho){
				if(ctaAho!=null){
					$('#cuentaAhoID').val(ctaAho.cuentaAhoID);							
					$('#clienteID').val(ctaAho.clienteID);
					consultaCliente('clienteID');
				}else{
					deshabilitaBoton('pdf', 'submit');
					alert("No Existe la Cuenta de Ahorro");
					$(jqCtaAho).focus();
					$('#clienteID').val('');
					$('#nombreCte').val('');					
					$('#descTipoPersona').val('');					
		
					
							
				}
			});
		}
	}
	 
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = catTipoconsultaCliente.PantallaForanea;	
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){
					habilitaBoton('pdf', 'submit');
					$('#clienteID').val(cliente.numero);
					$('#nombreCte').val(cliente.nombreCompleto);
					tipoPersona= (cliente.tipoPersona);
					$('#tipoPersona').val(cliente.tipoPersona);
					if(cliente.tipoPersona=='F'){							
						$('#descTipoPersona').val("FISICA") ;			
					}
					
					if(cliente.tipoPersona=='M'){
							$('#descTipoPersona').val("MORAL") ;
						}
					
					if(cliente.tipoPersona=='A'){
						$('#descTipoPersona').val("FISICA CON ACT.EMP.") ;
					}
					
					$('#consultarRep').focus();
					
					validaconocimientoCta('cuentaAhoID')
				}else{
					deshabilitaBoton('pdf', 'submit');
					alert("No Existe el Cliente");
					inicializaForma('formaGenerica', 'numero');
					$('#clienteID').val('');
					$('#cuentaAhoID').focus();
					$('#nombreCte').val('');					
					$('#descTipoPersona').val('');	
					
				}
			});
		}
	}
	function validaconocimientoCta(idControl) {
		var jqnum  = eval("'#" + idControl + "'");
		var num = $(jqnum).val();
		var conPrincipal= 1;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(num != '' && !isNaN(num) && esTab){
			if(num=='0'){
			
				inicializaForma('formaGenerica','cuentaAhoID');
			} else {
				esTab=true;
					if(num != '' && !isNaN(num) && esTab){
						var numeroBeanCon = {
	  						'cuentaAhoID':num
						}; 
						conocimientoCtaServicio.consulta(conPrincipal,numeroBeanCon,function(conocimiento){
								if(conocimiento!=null){
									dwr.util.setValues(conocimiento);	
									habilitaBoton('pdf', 'submit');
							
								}else{
									deshabilitaBoton('pdf', 'submit');
									alert("El Cliente no tiene datos en Conocimiento de Cuenta");
									inicializaForma('formaGenerica','idControl'); 
									$('#clienteID').val('');
									$('#cuentaAhoID').focus();
									$('#nombreCte').val('');					
									$('#descTipoPersona').val('');	
									
								}    						
						}); 
						
					}					
				}												
			}
	}

	
	
	
	
});




