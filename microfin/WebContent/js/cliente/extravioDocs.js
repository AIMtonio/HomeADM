var tipoReporte = '';
$(document).ready(function() {

	$('#cuenta').click(function(){
		limpiarCampos();
		tipoReporte = 'C';
		$('#repCuenta').show();
		$('#repInversion').hide();
		$('#cuentaID').focus();
	});

	$('#inversion').click(function(){
		limpiarCampos();
		tipoReporte = 'I';
		$('#repCuenta').hide();
		$('#repInversion').show();
		$('#inversionID').focus();
	});

	$('#cuenta').click();

	$('#cuentaID').bind('keyup',function(){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#cuentaID').val();
		lista('cuentaID',2,3,camposLista,parametrosLista,'cuentasAhoListaVista.htm');
	});

	$('#inversionID').bind('keyup',function(){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCliente";
		parametrosLista[0] = $('#inversionID').val();
		lista('inversionID',2,8,camposLista,parametrosLista,'listaInversiones.htm');
	});

	$('#cuentaID').blur(function(){
		consultaCuenta();
	});

	$('#inversionID').blur(function(){
		consultaInversion();
	});
	
	$('#imprimir').click(function(){
		imprimeReporte();
	});

});

function imprimeReporte(){
	var cuentaID = $('#cuentaID').val();
	var inversionID = $('#inversionID').val();
	var clienteID = $('#clienteID').val();
	var nombreCliente = $('#nombreCliente').val();
	
	
	if( (tipoReporte=='C' && cuentaID=='') || (tipoReporte=='I' && inversionID=='') ){
		var mensaje = (tipoReporte=='C') ? 'Cuenta de Ahorro' : 'Inversión';
		var jControl = (tipoReporte=='C') ? 'cuentaID' : 'inversionID';
		mensajeSis("El Número de "+mensaje+" está vacío.");
		$("#"+jControl).focus();
		
	}else{
		cuentaID = (cuentaID!='') ? cuentaID : 0;
		inversionID = (inversionID!='') ? inversionID : 0;
		var url="repExtravioDocs.htm?"+
			"tipoRep="+tipoReporte+
			"&cuentaID="+cuentaID+
			"&inversionID="+inversionID+
			"&clienteID="+clienteID+
			"&nombreCliente="+nombreCliente;
		window.open(url,"_blank");
	}
}

function limpiarCampos(){
	tipoReporte = '';
	$('#cuentaID').val('');
	$('#inversionID').val('');
	$('#clienteID').val('');
	$('#nombreCliente').val('');
}

function consultaCuenta(){
	var tipoCon = 1;
	var cuentaBean = {};

	cuentaBean['cuentaAhoID'] = $('#cuentaID').val();

	if ($('#cuentaID').val()!=null && !isNaN($('#cuentaID').val())) {
		cuentasAhoServicio.consultaCuentasAho(tipoCon,cuentaBean,{
			async : false,
			callback : function(cuentaAho){
				if (cuentaAho!=null) {
					$('#clienteID').val(cuentaAho.clienteID);
					conusltaCliente(cuentaAho.clienteID);
				}
			}
		});
	}
}	

function consultaInversion(){
	var tipoCon = 1;
	var inversionBean = {};
	inversionBean['inversionID'] = $('#inversionID').val();

	if ($('#inversionID').val()!=null && !isNaN($('#inversionID').val())) {
		inversionServicioScript.consulta(tipoCon,inversionBean,{
			async : false,
			callback : function(inversion){
				if (inversion!=null) {
					$('#clienteID').val(inversion.clienteID);
					conusltaCliente(inversion.clienteID);
				}
			}
		});
	}
}

function conusltaCliente(idCliente){
	var tipoCon = 1;

	if (idCliente!=null && !isNaN(idCliente)) {
		clienteServicio.consulta(tipoCon,idCliente,'',{
			async : false,
			callback : function(cliente){
				if (cliente!=null) {
					$('#nombreCliente').val(cliente.nombreCompleto);
				}
			}
		});
	}
}