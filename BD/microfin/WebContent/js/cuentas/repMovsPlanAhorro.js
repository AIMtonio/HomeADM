$(document).ready(function(){

	$("#planID").focus();

	consultaPlanesAhorro();
	inicializaForma();

	$("#sucursal").bind('keyup',function(e){
		lista('sucursal', '1', '1', 'nombreSucurs', $('#sucursal').val(), 'listaSucursales.htm');
	});

	$("#clienteID").bind('keyup',function(e){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$("#clienteID").blur(function(){
		consultaCliente();
	});

	$("#sucursal").blur(function(){
		consultaSucursal();
	});


	$('#generar').click(function() { 
			generaReporte();			
	});

	function generaReporte() {					
			var planID = $('#planID').val();	 
			var sucursal = $('#sucursal').val();	
			var clienteID = $('#clienteID').val();		
			var estatus = $('#estatus').val();
			var tipoReporte = $('input:radio[name=tipoReporte]:checked').val();
	
			var url='reportePlanAhorro.htm?planID='+planID+'&sucursal='+sucursal+'&clienteID='+
				clienteID+'&estatus='+estatus+'&tipoReporte='+tipoReporte;
			window.open(url,"_blank");
	}

	

	function consultaCliente(){
		var tipoCon = 1;
		clienteServicio.consulta(tipoCon,$("#clienteID").val(),function(clienteBean){
			if (clienteBean!=null) {
				$("#nombreCliente").val(clienteBean.nombreCompleto);
			}
		});
	}

	function consultaSucursal(){
		var numSucursal = $("#sucursal").val();	
		var conSucursal=2;
		sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
			if(sucursal!=null){							
				$('#nombreSucur').val(sucursal.nombreSucurs);				
			}					
		});
	}

	function consultaPlanesAhorro(){
		var tipoCon = 2;
		dwr.util.removeAllOptions('planID'); 
		dwr.util.addOptions('planID', {"0":'TODOS'});
		tiposPlanAhorroServicio.listaCombo(tipoCon,{},function(planesAhorro){
			dwr.util.addOptions('planID', planesAhorro, 'planID', 'nombre');
		});
	}

	function inicializaForma(){
		$("#planID").val(0);
		$("#sucursal").val(0);
		$("#clienteID").val(0);
		$("#estatus").val('0');
		$("#pdf").attr('checked','true');
	}

});