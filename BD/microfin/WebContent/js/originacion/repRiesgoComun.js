$(document).ready(function() {
	parametros = consultaParametrosSession();

	// Declaración de constantes 
	var catTipoConsultaSolicitud = {  
	  		'principal'		: 1
		};	
		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');				
		
	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) {
		}
	});	
	$('#sucursalID').val(parametroBean.sucursal);
	$('#excel').attr("checked",true); 
	$('#clienteID').focus();
	$('#clienteID').val('0');
	$('#nombreCliente').val('TODOS');
	$('#sucursalSolCredID').val('0');
	$('#sucursalSolCredNombre').val('TODAS');
		

	$('#sucursalSolCredID').bind('keyup',function(e) {
		lista('sucursalSolCredID', '2', '1','nombreSucurs', $('#sucursalSolCredID').val(), 'listaSucursales.htm');
	});
	
	
	$('#clienteID').blur(function() {
		if ($('#clienteID').asNumber()>0 && $.trim($('#clienteID').val()) != "" && esTab == true) {
			consultaCliente(this.id);
		} else {
			$('#clienteID').val(0);
			$('#nombreCliente').val('TODOS');
		}
	});

	$('#sucursalSolCredID').blur(function() {
		consultaSucursal(this.id);
	});

	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '3', '12', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	
	$('#generar').click(function() { 
		generaExcel();

	});	

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && numSucursal != 0) {
			sucursalesServicio.consultaSucursal(conSucursal,
					numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#sucursalSolCredID').val(sucursal.sucursalID);
							$('#sucursalSolCredNombre').val(sucursal.nombreSucurs);
						} else {
							mensajeSis("No Existe la Sucursal");
							$('#sucursalSolCredID').val('0');
							$('#sucursalSolCredNombre').val('TODAS');
						}
					});
		}
		else{
			$('#sucursalSolCredID').val('0');
			$('#sucursalSolCredNombre').val('TODAS');
		}
	}
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			solicitudCreditoID: 'required',
		},		
		messages: {
			solicitudCreditoID: 'Especifique el Número de Solicitud.',
		}		
	});
	
	

	//------------ Validaciones de Controles -------------------------------------
	
	//Funcion para genera Reporte
	function generaExcel(){
		var tipoRep			= 1;
		var nombreInstitucion=parametroBean.nombreInstitucion;
		var fechaEmision = parametroBean.fechaSucursal;
		var claveUsuario=parametroBean.claveUsuario;
		var nomUsu	= parametroBean.nombreUsuario;
		var clienteID= $('#clienteID').asNumber();
		var clienteNombre = $('#nombreCliente').val();
		var estatus =  $('#estatus').val();

		var paginaReporte ='RepRiesgoComun.htm?'+	
			'tipoRep='+tipoRep+		
			'&nombreInstitucion='+nombreInstitucion+
			'&fechaInicio='+$('#fechaInicio').val()+
			'&sucursalID='+$('#sucursalID').val()+
			'&usuario='+$('#usuarioID').val()+
			'&nombreSucursal='+$('#nombreSucursal').val()+
			'&nombreUsuario='+nomUsu+
			'&nomUsuario='+claveUsuario+
			'&fechaSistema='+fechaEmision+
			'&numeroCliente='+clienteID+
			'&clienteNombre='+clienteNombre+
			'&estatus='+estatus+
			'&riesgoComun='+$('#riesgoComun').val()+
			'&persRelacionada='+ $('#persRelacionada').val()+
			'&procesado='+ $('#procesado').val() +
			'&sucursalSolCredID='+ $('#sucursalSolCredID').val() +
			'&sucursalSolCredNombre='+ $('#sucursalSolCredNombre').val();
			$('#ligaGenerar').attr('href',paginaReporte);
	}	
	
	
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 23;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
					if(cliente!=null){
						$('#clienteID').val(cliente.numero)	;						
						$('#nombreCliente').val(cliente.nombreCompleto);
					}else{
						clienteexiste = 1;
						mensajeSis("No Existe el Cliente");
						$('#clienteID').val('0');
						$('#nombreCliente').val('TODOS');
					}    	 						
				});
			}
		}	
});
