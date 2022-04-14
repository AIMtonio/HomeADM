

$(document).ready(function() {
	esTab = true;

		var parametrosSesion = consultaParametrosSession();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
		
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','usuarioID'); 
		}
    });	
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#sucursalID').val(0);
	$('#nombreSucursal').val('TODAS');	
	
	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '1', '1', 'nombreSucurs',$('#sucursalID').val(), 'listaSucursales.htm');
	});
	
	$('#sucursalID').blur(function(){
		consultaSucursal(this.id);
		if($('#sucursalID').val() == '' || isNaN($('#sucursalID').val())){
			$('#nombreSucursal').val('');
			$('#sucursalID').val(0);
			$('#nombreSucursal').val('TODAS');			
		}else if($('#sucursalID').val() == '0'){
			$('#sucursalID').val(0);
			$('#nombreSucursal').val('TODAS');
		}		
	});
	
	$('#generar').click(function(){
		generaExcel();
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
						
		},
		messages: {
					
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
		
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();	
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){							
					$('#nombreSucursal').val(sucursal.nombreSucurs);
				} else{
					if($('#sucursalID').val() != 0){
						alert("No Existe la Sucursal"); 
						$(jqSucursal).val("");
						$(jqSucursal).focus();
						$('#nombreSucursal').val("");
					}
				}   						
			});
		}
	}
	
	function generaExcel() {	
			var tipoReporte= parseInt(1);
			var tipoLista = 1;
			var sucursalID = $('#sucursalID').val();
			var nombreSucursal = $('#nombreSucursal').val();
			var fechaEmision = parametrosSesion.fechaAplicacion;
			var nombreInstitucion = parametrosSesion.nombreInstitucion;
			var usuario = parametrosSesion.claveUsuario;
						
			$('#ligaGeneraRep').attr('href','generaRepSociosAltoRiesgo.htm?sucursalID='+sucursalID+
					'&nombreSucursal='+nombreSucursal+'&tipoReporte='+tipoReporte+'&fechaEmision='+fechaEmision+
					'&nombreInstitucion='+nombreInstitucion+'&usuario='+usuario+'&tipoLista='+tipoLista);	
		
	}
	
	
});