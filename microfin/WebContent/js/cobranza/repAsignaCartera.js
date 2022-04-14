$(document).ready(function() {
	esTab = false;
	$('#interno').focus();
	    
	var parametroBean = consultaParametrosSession();
    
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
	
	$('#gestorID').bind('keyup', function(e){
		lista('gestorID', '3', '1', 'nombre', $('#gestorID').val(),'listaGestoresCobranza.htm');
	});
	
	$('#gestorID').blur(function(){
		if(esTab){
			consultaGestorCobranza(this.id);	
		}
	});
	
	$('#sucursalID').blur(function() {
		if(esTab){
			validaSucursal();
		}
  	});

	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '3', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	
	$('#generar').click(function() {		
		generaReporte();
	});
   
	$('#excel').click(function() {
		$('#excel').attr('checked', true);
		$('#excel').focus();
	});

   
	$.validator.setDefaults({submitHandler: function(event) {
	   
	}});	
	
	   
	function generaReporte(){
		var varTipoGestor = "";
		if($('#interno').is(':checked')){
			varTipoGestor	= 'I';
		}
		else{
			varTipoGestor	= 'E';
		}
		var varSucursalID		= $('#sucursalID').val();
		var varGestorID			= $('#gestorID').val();

		var varNombreInstitucion = parametroBean.nombreInstitucion;
		var varClaveUsuario		= parametroBean.claveUsuario;
	    var varFechaSistema     = parametroBean.fechaAplicacion;

		/// VALORES TEXTO
		var nombreSucursal = $('#nombreSucursal').val();
		var nombreGestor = $('#nombreGestor').val();


		var pagina='reporteAsignaCartera.htm?tipoGestor='+varTipoGestor		+ '&sucursalID='+varSucursalID			+ '&gestorID='+varGestorID
							+ '&nombreInstitucion='	+varNombreInstitucion	+ '&claveUsuario='+varClaveUsuario.toUpperCase()		+ '&tipoLista=1'
							+ '&tipoReporte=1' + '&nombreSucursal='	+ nombreSucursal + '&nombreGestor=' +nombreGestor + '&fechaSis=' + varFechaSistema;
		window.open(pagina);	   
	};  
	
	function validaSucursal() {
		var numSucursal = $('#sucursalID').val();
		setTimeout("$('#cajaLista').hide();", 200);

		if(numSucursal == '' || numSucursal==0){
			$('#sucursalID').val(0);
			$('#nombreSucursal').val('TODAS');
		}
		else
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) { 
				if(sucursal!=null){
					$('#nombreSucursal').val(sucursal.nombreSucurs);				
				}else{
					alert('No existe la Sucursal');
					$('#sucursalID').focus();
					$('#sucursalID').val(0);
					$('#nombreSucursal').val('TODAS');
				}
			});
		}
	}
	
	function consultaGestorCobranza(idControl) {
		var jqGestor = eval("'#" + idControl + "'");
		var numGestor = $(jqGestor).val();	
		var conGestor=1;
		var gestorBeanCon = {
  				'gestorID':numGestor 
				};	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numGestor == '' || numGestor==0){
			$(jqGestor).val(0);
			$('#nombreGestor').val('TODOS');
		}
		else
		if(numGestor != '' && !isNaN(numGestor) && $('#gestorID').val() > 0 && esTab){
			gestoresCobranzaServicio.consulta(conGestor,gestorBeanCon,function(gestor) {
				if(gestor!=null){
					if(gestor.tipoGestor == 'E'){
						$('#externo').attr("checked",true);
					}else{
						$('#interno').attr("checked",true);
					}
					$('#gestorID').val(gestor.gestorID);
					$('#nombreGestor').val(gestor.nombreCompleto);	
				}else{							
					alert("No Existe el Gestor de Cobranza");
					$('#gestorID').focus();
					$('#gestorID').val(0);
					$('#nombreGestor').val('TODOS');
				}  
			});
		}
	}
	
}); // fin ready