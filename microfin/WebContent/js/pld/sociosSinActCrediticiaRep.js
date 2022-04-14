

$(document).ready(function() {
	esTab = true;

		var parametrosSesion = consultaParametrosSession();
		var sucursalLogueada =  parseInt(parametrosSesion.sucursal);
		var nombreSucLogueada = parametrosSesion.nombreSucursal;
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
	$('#sucursalID').val(sucursalLogueada);
	$('#nombreSucursal').val(nombreSucLogueada);	
	$('#periodo').val(1);
	
	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '1', '1', 'nombreSucurs',$('#sucursalID').val(), 'listaSucursales.htm');
	});
	
	$('#sucursalID').blur(function(){
		consultaSucursal(this.id);
		if($('#sucursalID').val() == '' || $('#sucursalID').val() == 0){
			$('#nombreSucursal').val('');
			$('#sucursalID').val(sucursalLogueada);
			$('#nombreSucursal').val(nombreSucLogueada);			
		}		
	});
	
	$('#periodo').blur(function(){
		if($('#periodo').val() == '' || isNaN($('#periodo').val())){
			$('#periodo').val(1);
		}
	});
	
	$('#generar').click(function(){
		generaPdf();
	});

	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			sucursalID: {
				required: true
			},
			periodo:{
				required: true,				
			}
			
		},
		messages: {
			sucursalID: {
				required: 'Especifique Sucursal'
			},
			periodo:{
				required: 'Especifique el Periodo(Número de Meses)'				
			}
			
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
				}else{
					alert("No Existe la Sucursal");					
					$(jqSucursal).val(sucursalLogueada);
					$(jqSucursal).focus();
					$('#nombreSucursal').val(nombreSucLogueada);
				}    						
			});
		}
	}
	function generaPdf() {	
		var tipoReporte= parseInt(1);
		var tipoLista = parseInt(1);
		var sucursalID = $('#sucursalID').val();
		var nombreSucursal = $('#nombreSucursal').val();
		var periodo = $('#periodo').val();
		var fechaEmision = parametrosSesion.fechaAplicacion;
		var nombreInstitucion = parametrosSesion.nombreInstitucion;
		var usuario = parametrosSesion.claveUsuario;
					
		$('#ligaGeneraRep').attr('href','generaRepSociosSinActCrediticia.htm?sucursalID='+sucursalID+
				'&nombreSucursal='+nombreSucursal+'&tipoReporte='+tipoReporte+'&fechaEmision='+fechaEmision+
				'&nombreInstitucion='+nombreInstitucion+'&usuario='+usuario+'&tipoLista='+tipoLista+'&periodo='+periodo);	
	
}
	
});