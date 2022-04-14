var tipoCliente = $("#tipoCliente").val();
$(document).ready(function() {
	esTab = true;
	$('#clienteID').focus();
	var parametroBean = consultaParametrosSession();      
	var fechaSucursal =parametroBean.fechaSucursal; 
	var fechaVacia='1900-01-01';
	$('#fechaSistemaMov').val(fechaSucursal);
	
	//------------ Metodos y Manejo de Eventos ----------------------------------------
	
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('consultar');
	$('#imprimir').hide();
	$('#solicitar').hide(); 
	
	$('#clienteID').bind('keyup',function(e){               
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');			
	});
		
	$('#clienteID').blur(function(){
		inicializaForma('formaGenerica');
		$('#gridAportacionMovimientos').html("");
		$('#gridAportacionMovimientos').show(); 
		$('#imprimir').hide();
		$('#solicitar').hide(); 
		consultaClientePantalla(this.id);
	});
	
	
	$('#consultar').click(function() {
		
		consultaMovimientos();
		
	});	
	
	$('#imprimir').click(function() {
		var fecha=$('#fechaImp').val();
		if($('#fechaImp').val()==fechaVacia){
			imprimeCertificado();
		
		}
	
		else {
			if(confirm("El certificado de Aportación Social ya fue impreso con fecha " +fecha +" , desea reimprimirlo?")){
				imprimeCertificado();
						
            }
		}
	});		
	
	$('#solicitar').click(function() {
		var nombreCte = $('#nombreCliente').val();
		var numCte = $('#clienteID').val();
		var nombreInst = parametroBean.nombreInstitucion;
		var dirInst = parametroBean.direccionInstitucion;
		var RFCInst = parametroBean.rfcInst;
		var telInst = parametroBean.telefonoLocal;
		var fechaEmision = parametroBean.fechaSucursal;
		var direccionSucursal = parametroBean.edoMunSucursal;
		var representanteLegal = parametroBean.representanteLegal;
		var ta= 1;
		
		var urlSolicitar = 'RepSolicitudBajaSocio.htm?nombreInstit='+nombreInst+'&direcInstit='+dirInst
				+'&clienteID='+numCte+'&RFCInstit='+RFCInst+'&telInstit='+telInst+'&nombreCliente='+nombreCte
				+'&tipoReporte='+ta+'&fechaEmision='+fechaEmision+'&direccionSucursal='+direccionSucursal
				+'&representanteLegal='+representanteLegal;
		window.open(urlSolicitar);
	});	
	
	//------------ Validaciones de la Forma -------------------------------------	
	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required',
		},
		
		messages: {
			clienteID: 'Especifique Número del '+tipoCliente+'.',
		}		
	});	
	
	//------------ Validaciones de Controles -------------------------------------
	function consultaClientePantalla(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
						if(cliente!=null){		
							$('#numCliente').val(cliente.numero);
						    $('#nombreCliente').val(cliente.nombreCompleto);	
							consultaDevolucionSocio(numCliente);
							habilitaBoton('consultar');
							$('#consultar').focus();
						}else{
							mensajeSis("El "+tipoCliente+" No Existe.");
							$(jqCliente).focus();
							$(jqCliente).val('');
							$('#nombreCliente').val('');
							$('#saldo').val('');
							$('#fechaImp').val('');
						}    						
				});
			}
	}
	
	 function consultaDevolucionSocio(numCliente){ 
			var conAportacionSocio =1;
			var aportaCliente={
					'clienteID':numCliente
			};
			 setTimeout("$('#cajaLista').hide();", 200);		
				if(numCliente != '' && !isNaN(numCliente)){
					aportacionSocial.consulta(conAportacionSocio,aportaCliente,function(aportacionSocio){
							if(aportacionSocio!=null){
									$('#saldo').val(aportacionSocio.saldo);
									$('#fechaImp').val(aportacionSocio.fechaImp);
									agregaFormatoMoneda('formaGenerica');
							
							}else{
								$('#saldo').val('');
								$('#fechaImp').val('');
							}    						
					});
				}
		 }

	function consultaMovimientos(){	
		var params = {};
		var numDetalle;
		params['tipoLista'] =  1;
		params['clienteID'] = $('#clienteID').val();			
		$.post("gridAportaSocioGridVista.htm", params, function(data){
				if(data.length >0) {
					$('#gridAportacionMovimientos').html(data);
					$('#gridAportacionMovimientos').show(); 
					$('#imprimir').show(); 
					numDetalle = $('label[name=descripcionMov]').length;
					if(numDetalle==0){
					deshabilitaBoton('imprimir','submit');
					deshabilitaBoton('solicitar','submit');	
					}else{
						habilitaBoton('imprimir','submit');
						habilitaBoton('solicitar','submit');	
					}	
					if ($('#saldo').asNumber()>0){
						$('#solicitar').show(); 
					}
					else if ($('#saldo').asNumber()<=0){
						$('#solicitar').hide(); 
					}
				}else{
					$('#gridAportacionMovimientos').html("");
					$('#gridAportacionMovimientos').show();
					$('#imprimir').hide(); 
					$('#solicitar').hide(); 
 
				}
		});		
	}
	
	function imprimeCertificado(){

		var nombreCte = $('#nombreCliente').val();
		var numCte = $('#clienteID').val();
		var sucursalID = parametroBean.sucursal;
		var nombreInst = parametroBean.nombreInstitucion;
		var dirInst = parametroBean.direccionInstitucion;
		var RFCInst = parametroBean.rfcInst;
		var telInst = parametroBean.telefonoLocal;
		var ta= 1;
		
		url='RepAportacionSocioMov.htm?nombreInstit='+nombreInst+'&direcInstit='+dirInst+'&clienteID='+numCte+'&RFCInstit='+RFCInst+
		'&telInstit='+telInst+'&sucursalID='+sucursalID+'&nombreCliente='+nombreCte+'&tipoReporte='+ta;
		
		 window.open(url);
	
		
	}
});

function consultaMovimientos(pageValor){	
	var params = {};
	params['tipoLista'] =  1;
	params['clienteID'] = $('#clienteID').val();
	params['anio'] = $('#anio').val();
	params['mes'] = $('#mes').val(); 
	params['page'] = pageValor ;
	
	$.post("gridAportaSocioGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#gridAportacionMovimientos').html(data);
				$('#gridAportacionMovimientos').show();
				$('#imprimir').show();
				$('#solicitar').show();
			}else{
				$('#gridAportacionMovimientos').html("");
				$('#gridAportacionMovimientos').show(); 
			}
			
	});
	
	
}