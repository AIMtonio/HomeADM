$(document).ready(function() {

	$('#numeroMonedaBasePCC').val(parametroBean.numeroMonedaBase);

	$('#clienteCancelaIDPCC').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		camposLista[1] = "areaCancela";
		parametrosLista[0] = $('#clienteCancelaIDPCC').val();
		parametrosLista[1] = "";
		lista('clienteCancelaIDPCC', '2', '2', camposLista, parametrosLista, 'listaClientesCancela.htm');
	});
	
	$('#clienteCancelaIDPCC').blur(function() {
		consultaSolicitudCancelacionSocio(this.id);
	});
	
	
	
	
});// fin Document
	

/* Funcion para consultar el folio de cancelacion .*/
function consultaSolicitudCancelacionSocio(idControl) {
	var jqFolioSolicitud = eval("'#" + idControl + "'");
	var varFolioSolicitud = $(jqFolioSolicitud).val();
	var tipConPrincipal = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	if (varFolioSolicitud != '' && !isNaN(varFolioSolicitud)) { // si es numero y no esta vacio el campo
		/*se trata de una consulta de folio */
		var clienteCancelaBean = {
			'clienteCancelaID'	:$('#clienteCancelaIDPCC').val()
		};
		clientesCancelaServicio.consulta(tipConPrincipal,clienteCancelaBean,function(cliente) {
			if(cliente!=null){	
				esTab = true;
				$('#clienteIDPCC').val(cliente.clienteID);
				var clienteExp = $('#clienteIDPCC').asNumber();
				if(clienteExp>0){
					listaPersBloqBean = consultaListaPersBloq(clienteExp, esCliente, 0, 0);
					if(listaPersBloqBean.estaBloqueado!='S'){
						expedienteBean = consultaExpedienteCliente(clienteExp);
						if(expedienteBean.tiempo<=1){
							switch(cliente.estatus){
							case 'R':
								alert("La Solicitud de Cancelación no esta Autorizada");
								$('#clienteCancelaIDPCC').focus();
								$('#clienteCancelaIDPCC').select();	
								$('#clienteCancelaIDPCC').val("");
//								limpiaDatosClienteCancelSocio();
								break;
							case 'A':
								consultaClienteCancelacionSocio(cliente.clienteID);
								$('#clienteIDPCC').val(cliente.clienteID);
								$('#estatusPCC').val(cliente.estatus).selected = true;
								mostraGridEntregaCancelSocio($('#clienteCancelaIDPCC').val(), cliente.saldoFavorCliente);
								break;
							case 'P':
								alert("La Solicitud de Cancelación ya fue Pagada.");
								$('#clienteCancelaIDPCC').focus();
								$('#clienteCancelaIDPCC').select();	
								$('#clienteCancelaIDPCC').val("");
								$('#clienteIDPCC').val("");
//								limpiaDatosClienteCancelSocio();
								break;
							default:
								alert("La Solicitud de Cancelación tiene un estatus no definido.");
								$('#clienteCancelaIDPCC').focus();
								$('#clienteCancelaIDPCC').select();	
								$('#clienteCancelaIDPCC').val("");
								$('#clienteIDPCC').val("");
//								limpiaDatosClienteCancelSocio();
							}
						} else {
							alert('Es necesario Actualizar el Expediente del Cliente para Continuar.');
							$('#clienteCancelaIDPCC').focus();
							$('#clienteCancelaIDPCC').select();	
							$('#clienteCancelaIDPCC').val("");
							$('#clienteIDPCC').val("");
						}
					} else {
						alert('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						$('#clienteCancelaIDPCC').focus();
						$('#clienteCancelaIDPCC').select();	
						$('#clienteCancelaIDPCC').val("");
						$('#clienteIDPCC').val("");
					}
				}
			}else{
				alert("El Número de Solicitud de Cancelación no Existe.");				
				$('#clienteCancelaIDPCC').focus();
				$('#clienteCancelaIDPCC').select();	
				$('#clienteCancelaIDPCC').val("");
				$('#clienteIDPCC').val("");
//				limpiaDatosClienteCancelSocio();
			}
		});	
	}	
}

/* funcion para consultar un cliente */
function consultaClienteCancelacionSocio(numCliente) {
	var tipConPrincipal = 1;	
	setTimeout("$('#cajaLista').hide();", 200);			
//	limpiaDatosClienteCancelSocio();
	if(numCliente != '' && !isNaN(numCliente) ){
		clienteServicio.consulta(tipConPrincipal,numCliente.trim(),function(cliente) {
			if(cliente!=null){			
				esTab = true;
				$('#clienteIDPCC').val(cliente.numero);
				$('#nombreClientePCC').val(cliente.nombreCompleto);
				$('#fechaNacimientoPCC').val(cliente.fechaNacimiento);
				$('#rfcPCC').val(cliente.RFC);
				$('#sucursalOrigenPCC').val(cliente.sucursalOrigen);
				$('#curpPCC').val(cliente.CURP);
				
				consultaSucursalCancelacionSocio(cliente.sucursalOrigen); // se consulta la sucursal
				
				if(cliente.tipoPersona == 'F'){
					$('#tipoPersonaPCC').val('FÍSICA');
				}else{
					if(cliente.tipoPersona == 'A'){
						$('#tipoPersonaPCC').val('FÍSICA ACT. EMP.');
					}else{
						$('#tipoPersonaPCC').val('MORAL');
					}
				}
			}else{
				alert("No Existe el Cliente");				
				$('#clienteID').focus();
				$('#clienteID').select();	
				inicializarFormularioNuevaSolicitud();
			}
		});
	}
}

/*funcion para consultar la sucursal*/
function consultaSucursalCancelacionSocio(numSucursal) {
	var conSucursal = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
		sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
			if (sucursal != null) {
				$('#sucursalOrigenDesPCC').val(sucursal.nombreSucurs);
			} else {
				alert("No Existe la Sucursal");
			}
		});
	}
}

/* funcion para mostrar el grid de beneficiarios de la solicitud de cancelacion del socio */
function mostraGridEntregaCancelSocio(varClienteCancelaID, totalMontoBeneficio){	
	var params = {};
	params['tipoLista']			= 1;
	params['clienteCancelaID']	= varClienteCancelaID;
	
	$.post("listaCliCancelaEntregaVen.htm", params, function(data){
		if(data.length >0) {		
			$('#divBeneficiariosPCC').html(data);
			$('#divBeneficiariosPCC').show();
			$('#radioEntregar1').focus();
			$('#totalBeneficio').val(totalMontoBeneficio);
			$('#totalBeneficio').formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
			});
			$('#agregarSalEfec').trigger('click');
		}else{				
			$('#divBeneficiariosPCC').html("");
			$('#divBeneficiariosPCC').hide();
		}		
	});
}

/* funcion para llevar el total de cantida a entregar */
function sumaTotalRecibirCancelacionSocio() { 
	setTimeout("$('#cajaLista').hide();", 200);
	var jqMontoEntrada	= "";
	var jqradioID		= "";
	var jqNombreBeneID	= "";
	var jqNombreRecibe	= "";
	var montoEntrada	= 0;
	var suma = parseFloat(0);
	$('input[name=cantidadRecibir]').each(function() {
		jqMontoEntrada	= eval("'#" + this.id + "'");
		jqradioID		= eval("'#radioEntregar" + this.id.substr(15, this.id.length) + "'");
		jqNombreBeneID	= eval("'#nombreBeneficiarioGrid" + this.id.substr(15, this.id.length) + "'");
		jqNombreRecibe	= eval("'#nombreRecibePago" + this.id.substr(15, this.id.length) + "'");
		jqClienteCanID	= eval("'#cliCancelaEntregaID" + this.id.substr(15, this.id.length) + "'");
		
		montoEntrada= $(jqMontoEntrada).asNumber(); 
		if($(jqradioID).attr('checked')==true){
			suma = parseFloat(suma) + parseFloat(montoEntrada);
			$(jqradioID).val("S"); 
			$('#nombreBeneficiario').val($(jqNombreBeneID).val());
			$('#nombreRecibePago').val($(jqNombreRecibe).val());
			$('#cliCancelaEntregaID').val($(jqClienteCanID).val());
			$('#beneCheque').val($(jqNombreRecibe).val());
			
		}else{
			$(jqradioID).val("N");			
		}
		$('#totalRecibir').val(suma);
		$('#totalRecibir').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#agregarSalEfec').trigger('click');
		if($('#formaPagoOpera2').attr('checked')==true){
			$('#formaPagoOpera2').trigger('click');
		}
		
	});		
}

function limpiaDatosClienteCancelSocio() {
	$('#clienteIDPCC').val("");
	$('#nombreClientePCC').val("");
	$('#fechaNacimientoPCC').val("");
	$('#sucursalOrigenPCC').val("");
	$('#sucursalOrigenDesPCC').val("");
	$('#rfcPCC').val("");
	$('#curpPCC').val("");
	$('#tipoPersonaPCC').val("");
	$('#divBeneficiariosPCC').html("");
	$('#divBeneficiariosPCC').hide();
}


function imprimeTicketPagoCancelacionSocio() {		 		     	    
	var i =0;				
	var imprimeTicketPagoCancelBean ={
		    'folio' 	       	:$('#numeroTransaccion').val(),
	        'tituloOperacion'  	:'PAGO CANCELACION SOCIO',
		    'clienteID'         :$('#clienteIDPCC').val(),						  
		    'beneficiario'     	:$('#nombreClientePCC').val(),
	        'nombreRecibe'      :$('#nombreRecibePago').val(),
            'totalBeneficioNum'    :$('#totalRecibir').asNumber(),
            'totalBeneficio'    :$('#totalRecibir').val()
		};					
	imprimeTicketPagoCancel(imprimeTicketPagoCancelBean);			
}


/* funcion para llevar el total de cantida a entregar */
function funcionActualizaRecibePagoCancelSocio() { 
	setTimeout("$('#cajaLista').hide();", 200);
	var jqradioID		= "";
	var jqNombreRecibe	= "";
	$('input[name=cantidadRecibir]').each(function() {
		jqradioID		= eval("'#radioEntregar" + this.id.substr(15, this.id.length) + "'");
		jqNombreRecibe	= eval("'#nombreRecibePago" + this.id.substr(15, this.id.length) + "'");
		if($(jqradioID).attr('checked')==true){
			$(jqNombreRecibe).val($('#beneCheque').val());
			
		}else{
			$(jqradioID).val("N");			
		}		
	});		
}