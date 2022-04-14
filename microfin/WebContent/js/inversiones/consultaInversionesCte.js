
$(document).ready(function() {
	$('#clienteID').focus();
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	// Lista de Clientes
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '9', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function(){		
		consultaClientePantalla();
	});
	

});//Fin del Document Ready

function consultaInvCteVig(pageValor){
	var clienteID = $('#clienteID').val();
	if (clienteID != '' && !isNaN(clienteID)){
		var params = {};
		params['tipoLista'] = 2;
		params['clienteID'] = clienteID;
		params['pagina'] = pageValor;

		$.post("consultaInvCteVigVenGrid.htm", params, function(dat){
			if(dat.length >0) {
				$('#gridInvCteVig').html(dat);
				$('#gridInvCteVig').show();
			}else{
				$('#gridInvCteVig').html("");
				$('#gridInvCteVig').show();
			}

		});
	}
}

function consultaInvCteVen(pageValor){
	var clienteID = $('#clienteID').val();
	if (clienteID != '' && !isNaN(clienteID)){
		var params = {};
		params['tipoLista'] = 10;
		params['clienteID'] = clienteID;
		params['pagina'] = pageValor;

		$.post("consultaInvCteVigVenGrid.htm", params,function(dat){
			if(dat.length >0) {
				$('#gridInvCteVen').html(dat);
				$('#gridInvCteVen').show();
				desbloquearPantalla();
			}else{
				$('#gridInvCteVen').html("");
				$('#gridInvCteVen').show();
			}

		});
	}
}

//Funcion para consultar informacion del cliente
function consultaClientePantalla(){	
	var numCliente = $('#clienteID').val();		
	var tipConPantalla = 1;
	var rfc = ' ';
	
	if(numCliente == ''){
		$('#nombreCompleto').val('');
	}
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && !isNaN(numCliente) && esTab) {
		bloquearPantalla();
		clienteServicio.consulta(tipConPantalla,numCliente,rfc,{async:false, callback:function(cliente){
				if (cliente != null){
					if(cliente.estatus == 'A'){
					$('#clienteID').val(cliente.numero);
					$('#nombreCompleto').val(cliente.nombreCompleto);						
					consultaInvCteVig();
					consultaInvCteVen();
					}
					if(cliente.estatus == 'I'){
						mensajeSis('El Cliente se encuentra Inactivo');
						$('#clienteID').val(cliente.numero);
						$('#nombreCompleto').val(cliente.nombreCompleto);
					}						
					if(cliente.estatus == 'C'){
						mensajeSis('El Cliente se encuentra Cancelado');
						$('#clienteID').val(cliente.numero);
						$('#nombreCompleto').val(cliente.nombreCompleto);
					}
					
					if(cliente.estatus == 'B'){
						mensajeSis('El Cliente se encuentra Bloqueado');
						$('#clienteID').val(cliente.numero);
						$('#nombreCompleto').val(cliente.nombreCompleto);
					}						
					
				} else {
					mensajeSis("No Existe el Cliente");	
					$('#clienteID').val('');
					$('#nombreCompleto').val('');
					$('#gridInvCteVen').html("");
					$('#gridInvCteVig').html("");
				}	
			}
		});	
	}else{
		$('#nombreCompleto').val('');
	}
}

function muevePagina(tipoReporte,pageValor){
	if(tipoReporte == 2){
		consultaInvCteVig(pageValor);
	}
	if(tipoReporte == 10){
		consultaInvCteVen(pageValor);
	}
}