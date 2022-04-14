var TipoOperacionHaberesMenor =40;

$(document).ready(function(){
	

	var Con_SocioExMenor={
			'principal' :1
		};
	//Definicion de Constantes y Enums

	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	

	deshabilitaBoton('graba','sumbit');
	// llenaComboTiposIdenti();

	
	$('#buscarMiSucRe').click(function(){
		listaCte('clienteIDMenor', '2', '4', 'clienteID', $('#clienteIDMenor').val(), 'listaExMenores.htm');
	});
	$('#buscarGeneralRe').click(function(){
		listaCte('clienteIDMenor', '2', '5', 'clienteID', $('#clienteIDMenor').val(), 'listaExMenores.htm');
	});
	$('#clienteIDMenor').blur (function(){
		setTimeout("$('#cajaLista').hide();", 200);
		var cliente = $('#clienteIDMenor').asNumber();
		if(cliente>0){
			listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
			consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);
			
			if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
				expedienteBean = consultaExpedienteCliente($('#clienteIDMenor').val());
				if(expedienteBean.tiempo<=1){
					validaCliente('clienteIDMenor');
				} else {
					alert('Es necesario Actualizar el Expediente del Cliente para Continuar.');
					$('#clienteIDMenor').focus();					
					$('#nombreClienteMenor').val('');
					$('#clienteIDMenor').val('');
					inicializaForma('formaGenerica');
				}
			} else {
				alert('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				$('#clienteIDMenor').focus();					
				$('#nombreClienteMenor').val('');
				$('#clienteIDMenor').val('');
				inicializaForma('formaGenerica');
			}
		}
	});

	$('#clienteIDMenor').bind('keyup',function(e) {
		if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
			listaCte('clienteIDMenor', '2', '5', 'clienteID', $('#clienteIDMenor').val(), 'listaExMenores.htm');
		}

		if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
			listaCte('clienteIDMenor', '2', '4', 'clienteID', $('#clienteIDMenor').val(), 'listaExMenores.htm');
		}
	});
	
	$('#identiMenor').blur(function() {		

		consultaTipoIdentGenerica('identiMenor','descIdentiMenor', TipoOperacionHaberesMenor );
	});

	
	//funcion para validar cliente
	function validaCliente (idControl){
		var jqcliente = eval("'#" + idControl + "'");
		var numCliente = $(jqcliente).val();
		
		setTimeout("$('#cajaLista').hide();", 200);
		var ExMenorBeanCon = {
				'clienteID' : numCliente
			};
		if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {
			clienteExMenorServicio.consulta(Con_SocioExMenor.principal, ExMenorBeanCon, function(cliente) {
				if (cliente != null) {
					if(cliente.estatusRetiro=="R"){
						alert("La Cuota del Socio Indicado ha sido Retirada");
						$('#clienteIDMenor').focus();					
						$('#clienteIDDes').val('');
						$('#clienteIDMenor').val('');
						inicializaForma('formaGenerica');
					}else if(cliente.estatusRetiro=="N"){
						consultaCliente('clienteIDMenor');
						$('#totalHaberes').val(cliente.saldoAhorro);
					}else{
						alert("No Existe Información para el Socio Consultado  ");
						$('#clienteIDMenor').focus();					
						$('#nombreClienteMenor').val('');
						$('#clienteIDMenor').val('');
						inicializaForma('formaGenerica');
					}
			
				} else {
					alert("No Existe Información para el Socio Consultado ");
					$('#clienteIDMenor').focus();					
					$('#nombreClienteMenor').val('');
					$('#clienteIDMenor').val('');
					inicializaForma('formaGenerica');					
				}
			});
		}
	}
	
	
	//funcion para consultar nombre del cliente
	function consultaCliente (idControl){
		var jqcliente = eval("'#" + idControl + "'");
		var numCliente = $(jqcliente).val();
		var conCliente = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {
			clienteServicio.consulta(conCliente, numCliente, function(cliente) {
				if (cliente != null) {
					$('#clienteIDMenor').val(cliente.numero);
					$('#nombreClienteMenor').val(cliente.nombreCompleto);
					$('#fechaNacMenor').val(cliente.fechaNacimiento);
					$('#sucursalMenor').val(cliente.sucursalOrigen);
					consultaSucursal(cliente.sucursalOrigen);
					$('#edadMenor').val(cliente.edad);
					$('#curpMenor').val(cliente.CURP);
					if(cliente.estatus=="A"){
						$('#estatusMenor').val("ACTIVO");
					}else if(cliente.estatus=="I"){
						$('#estatusMenor').val("INACTIVO");	
					}else{
						$('#estatusMenor').val("NO IDENTIFICADO");	
					}
					$('#descIdentiMenor').val('');
					$('#identiMenor').val('');
				} else {
					alert("No Existe el Cliente");
					$('#clienteIDMenor').focus();					
					$('#nombreClienteMenor').val('');
					$('#clienteIDMenor').val('');		
					inicializaForma('formaGenerica');
				}
			});
		}
	}
	
	
	
	
	
	
	/* Consulta la sucursal  */
	function consultaSucursal(numSucursal) {		
		var tipoConsulta = 2;
		setTimeout("$('#cajaLista').hide();", 200);	
		
		if (numSucursal != '' && !isNaN(numSucursal)) {			
			sucursalesServicio.consultaSucursal(tipoConsulta,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#sucursalMenor').val(sucursal.sucursalID);
						$('#nombreSucMenor').val(sucursal.nombreSucurs);	
					
				} else {
					$('#sucursalMenor').focus();
					$('#nombreSucMenor').val('');
					$('#sucursalMenor').val('');
					alert("La Sucursal No Existe.");								
				}
			});
		}
	}

	$('#identiMenor').change(function() {
		consultaTipoIdent();
	});
	
	//Consulta el número máximo y mínimo de caracteres para cada tipo de identificacion
	function consultaTipoIdent() {
		var tipConP = 1;	
		
		var numTipoIden = $('#identiMenor option:selected').val();
		setTimeout("$('#cajaLista').hide();", 200);					

		tiposIdentiServicio.consulta(tipConP,numTipoIden,function(identificacion) {
			if(identificacion!=null){						
				$('#numCaracteresMaxMin').val(identificacion.numeroCaracteres);	
			}else{
				$('#numCaracteresMaxMin').val(0);
			}    	 						
		});
	
	}
	
	
});// FIN DEL DOCUMENT







function consultaTipoIdentGenerica(tipoIdentificacion, campoValidar, TipoOperacion) { 
	var tipConP = 1;	
	var jqControl=	eval("'#" + tipoIdentificacion + "'");
	var numTipoIden = $(jqControl).val();
	var jqControlValida =	eval("'#" + campoValidar + "'");
	
	
	setTimeout("$('#cajaLista').hide();", 200);	
	
	if(numTipoIden >0){
		tiposIdentiServicio.consulta(tipConP,numTipoIden,	{ async: false, callback:function(identificacion) {
			if(identificacion!=null){							
				longitudIdentificacion= identificacion.numeroCaracteres; // declarado en js principal																		
				
				 if($('#tipoOperacion').asNumber()== TipoOperacion ){
						$('#formaGenerica '+jqControlValida).rules("add", {
							minlength        : longitudIdentificacion,  
							maxlength        : longitudIdentificacion,  
							
							messages        : {
								minlength    : 'Se Requieren '+longitudIdentificacion+ ' Caracteres',
						    	maxlength    : 'Se Requieren '+longitudIdentificacion+ ' Caracteres',
						    	
						    }
						});
					}
			}else{
				longitudIdentificacion=0;
			}  
		}
		});	
	}else{
		longitudIdentificacion=0;
	}	

}

//Funcion para hacer la llamada y modelar el ticket
function imprimeTicketHaberesExMenor() {		 
	var simboloMoneda=parametroBean.simboloMonedaBase;
	
 	var ctaSocioExMenor=3; 	
	var socioExMenorBean = { 
			'clienteID':$('#clienteIDMenor').val()	  				
	};				
	
	clienteExMenorServicio.consulta(ctaSocioExMenor,socioExMenorBean,function(exMenor) {
		if(exMenor != null){
			cuentaAho=exMenor.cuentaAhoID;
			tipoCta=exMenor.descripcion;

		}else{
			cuentaAho='';
			tipoCta='';
		}

		var imprimeTicketHaberesExMenorBean ={
			    'folio' 	        	:$('#numeroTransaccion').val(),
		        'tituloOperacion'  		:'ENTREGA HABERES EXMENOR',
			    'menorID'               :$('#clienteIDMenor').val(),						  
			    'nombreMenor'    		:$('#nombreClienteMenor').val(),
		        'totalHaberes'      	:$('#totalHaberes').val(),
	            'moneda'				:simboloMoneda,
	            'cuentaAhoID'			:cuentaAho,
	            'descripcion'			:tipoCta,
	            'monto'					:$('#totalHaberes').asNumber()
			};					
		imprimeTicketHaberesExMenorCta(imprimeTicketHaberesExMenorBean);	
				
	});		
}



////Rellena combo identificacion generica
function llenaComboTiposIdentiGenerica(idControl){

	dwr.util.removeAllOptions(idControl); 
	tiposIdentiServicio.listaCombo(3, function(tIdentific){
		dwr.util.addOptions(idControl	,{'':'SELECCIONAR'});
		dwr.util.addOptions(idControl, tIdentific, 'tipoIdentiID', 'nombre');
	});		

}