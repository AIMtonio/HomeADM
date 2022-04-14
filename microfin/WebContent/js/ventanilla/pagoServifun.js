var Var_EstatusAutorizado ='A';
$(document).ready(function() {
	
	
	$('#serviFunFolioID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "serviFunFolioID";
			camposLista[1] = "tramPrimerNombre";
			
			parametrosLista[0] = 0;
			parametrosLista[1] = $('#serviFunFolioID').val();
			lista('serviFunFolioID', '2', '2', camposLista, parametrosLista, 'serviFunFoliosLista.htm');
		}				       
	});

	$('#folioIdentificacion').blur(function() {
		$('#cantSalMil').focus();
	});


	$('#tipoIdentificacion').change(function() {	
		$('#folioIdentificacion').val('');
		consultaTipoIdent2(this.id,'folioIdentificacion');
	});
	
	function consultaTipoIdent2(idControl, desFolio) {
		var tipConP = 1;	
		var jqTipoIdentificacion = eval("'#" + idControl + "'");
		var numIdentificacion = $(jqTipoIdentificacion).val();		
		setTimeout("$('#cajaLista').hide();", 200);					
		if(numIdentificacion >0){
			tiposIdentiServicio.consulta(tipConP,numIdentificacion,function(identificacion) {
				if(identificacion!=null){					
					longitudIdentificacion= identificacion.numeroCaracteres;
					if( identificacion.numeroCaracteres>0){
						$("#"+desFolio).rules("add", {
							maxlength : identificacion.numeroCaracteres,
						messages: {
							maxlength: "Máximo "+identificacion.numeroCaracteres+" Caracteres"
							}
						});
					}
					
				}    	 						
			});
		}
		
	}


	
});// fin Document
	
function  validaServiFun(idControl) {  
	var jqFolio = eval("'#" + idControl + "'");
	var numFolio = $(jqFolio).val();
	var tipConPrincipal = 1;				
	limpiacampoServifun();
	setTimeout("$('#cajaLista').hide();", 200);			
	var proteccionBeanP = {
			'serviFunFolioID': numFolio								
		};

	if(numFolio != '' && !isNaN(numFolio)){		
		serviFunFoliosServicio.consulta(tipConPrincipal,proteccionBeanP,function(proteccion) {
			if(proteccion!=null){
				var cliente = Number(proteccion.clienteID);
				if(cliente>0){
					listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
					if(listaPersBloqBean.estaBloqueado!='S'){
						expedienteBean = consultaExpedienteCliente(cliente);
						if(expedienteBean.tiempo<=1){
							if(proteccion.tipoServicio == "F"){
								$('#estatusServifun').val(proteccion.estatus).selected = true;
								if(proteccion.estatus = "A"){
									$('#fielsetIndeitificacion').show();
									$('#tipoIdentificacion').val('').selected == true;
									$('#folioIdentificacion').val('');						
									$('#tipoServivioServifun').val(proteccion.tipoServicio);
									consultaClienteServifun(proteccion.clienteID);
									consultaServiFunEntregadoServicio(numFolio);
									$('#difuntoServifunID').val(proteccion.difunClienteID);
									$('#difuntoServifunNomComp').val(proteccion.difNombreCompleto);		

									llenaComboTiposIdenti(); // Consulta los tipos de identificacion  /* pagoServifun.js*/

									$('#tipoIdentificacion').focus();		
								}else{
									if(proteccion.estatus != Var_EstatusAutorizado){
										alert("El Folio no se Encuentra Autorizado ");
										$(jqFolio).focus();
										$(jqFolio).val("");
									}
								}					
							}else{
								alert("Solo se pueden pagar Folios que sean por Fallecimiento de Familiar de un Socio.");
								$(jqFolio).focus();
								$(jqFolio).val("");
							}
								
							//consultaGridServifun();
						} else {
							alert('Es necesario Actualizar el Expediente del Cliente para Continuar.');
							$(jqFolio).focus();
							$(jqFolio).val("");
						}
					} else {
						alert('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						$(jqFolio).focus();
						$(jqFolio).val("");
					}
				}
			}else{
				alert("El Folio indicado no existe");						
				$(jqFolio).focus();
				
			}
		});								
	}
}


/* funcion para consultar los clientes de solicitud servifun */  
function consultaClienteServifun(numCliente) {
	var tipConPrincipal = 1;	
	limpiaSeccionSocioServifun();
	setTimeout("$('#cajaLista').hide();", 200);			
	
	if(numCliente != '' && !isNaN(numCliente) ){
		clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
			if(cliente!=null){						
				$('#clienteServifunID').val(numCliente);
				$('#nombreCteServifun').val(cliente.nombreCompleto);					
				$('#fechaNacimientoServifun').val(cliente.fechaNacimiento);
				$('rfcServifun').val(cliente.RFC);					
				$('#curpServifun').val(cliente.CURP);
				$('#estadoCivilServifun').val(cliente.estadoCivil);
				$('#fechaIngresoServifun').val(cliente.fechaAlta);
				$('#edadIngresoServifun').val(calcular_edad(cliente.fechaNacimiento,cliente.fechaAlta));
				
			
				if(cliente.tipoPersona == 'F'){
					$('#tipoPersonaServifun').val('FÍSICA');
				}else{
					if(cliente.tipoPersona == 'A'){
						$('#tipoPersonaServifun').val('FÍSICA ACT. EMP.');
					}else{
						$('#tipoPersonaServifun').val('MORAL');
					}
				}	
				
			}else{
				alert("No Existe el Cliente");				
				$('#clienteServifunID').focus();
				$('#clienteServifunID').select();	
				limpiaSeccionSocioServifun();
			}
		});
	}
}


/* funcion para consultar las solicitudes autorizadas*/  
function consultaServiFunEntregadoServicio(folio) {
	var tipConPrincipal = 1;	
	limpiaSeccionSocioServifun();
	setTimeout("$('#cajaLista').hide();", 200);	
	var proteccionBeanP = {
			'serviFunFolioID': folio								
		};
	
	if(folio != '' && !isNaN(folio) ){
		serviFunEntregadoServicio.consulta(tipConPrincipal,proteccionBeanP,function(serviFunEntregado) {
			if(serviFunEntregado!=null){						
				$('#montoEntregarServifun').val(serviFunEntregado.cantidadEntregado);
				$('#folioentregadoID').val(serviFunEntregado.serviFunEntregadoID);
			
			}else{
				alert("No Existe el Folio o no se encuentra Autorizado.");				
				$('#serviFunFolioID').focus();
				$('#serviFunFolioID').val("");	
				limpiaSeccionSocioServifun();
			}
		});
	}
}



function calcular_edad(fechaNacimiento, fechaIngresoCli) {
	var edad  = 0; 
	if(fechaNacimiento == "" || fechaNacimiento == null ){
		alert("Se requiere Fecha de Nacimiento para Calcular la Edad.");
		edad = 0;
	}else{
		if(fechaIngresoCli == "" || fechaIngresoCli == null){
			alert("Se requiere Fecha de Ingreso para Calcular la Edad.");
			edad = 0;
		}else{
			FechaNac = fechaNacimiento.split("-");
			FechaIngreso = fechaIngresoCli.split("-");
			var diaCumple = FechaNac[2];
			var mesCumple = FechaNac[1];
			var yyyyCumple = FechaNac[0];
			
			var diaIngreso =FechaIngreso[2];
			var mesIngreso =FechaIngreso[1];
			var anioIngreso =FechaIngreso[0];
			//retiramos el primer cero de la izquierda
			if (mesCumple.substr(0,1) == 0) {
				mesCumple= mesCumple.substring(1, 2);
			}
			//retiramos el primer cero de la izquierda
			if (diaCumple.substr(0, 1) == 0) {
				diaCumple = diaCumple.substring(1, 2);
			}
			edad = anioIngreso - yyyyCumple;

			/*validamos si el mes de cumpleaños es menor al actual
			o si el mes de cumpleaños es igual al actual
			y el dia actual es menor al del nacimiento
			De ser asi, se resta un año*/
			if ((mesIngreso < mesCumple) || (mesIngreso == mesCumple && diaIngreso < diaCumple)) {
				edad--;
			}
		}
	}
	return edad;
};

function limpiaSeccionSocioServifun() {
	$('#nombreCteServifun').val("");					
	$('#fechaNacimientoServifun').val("");
	$('rfcServifun').val("");					
	$('#curpServifun').val("");
	$('#estadoCivilServifun').val("");
	$('#fechaIngresoServifun').val("");
	$('#edadIngresoServifun').val("");
	$('#clienteServifunID').val("");
			
}

// ----- Grid de beneficiarios por cuenta
function consultaGridServifun(){
	var numeroFolio = $('#serviFunFolioID').asNumber();
	var params = {};
	params['tipoLista'] = 2;
	params['serviFunFolioID'] = numeroFolio;
	if (numeroFolio != '' && !isNaN(numeroFolio)){
		$.post("servifunEntregadoGridVista.htm", params, function(data){
			if(data.length >0) {					
				$('#gridServifun').html(data);
				$('#gridServifun').show(); 
				limpiaCamposIdentificacion();
			}else{
				$('#gridServifun').html("");
				$('#gridServifun').hide();
			}
		});
	}
}
function llenaComboTiposIdenti(){
	dwr.util.removeAllOptions('tipoIdentificacion'); 
	tiposIdentiServicio.listaCombo(3, function(tIdentific){
		dwr.util.addOptions('tipoIdentificacion'	,{'0':'SELECCIONAR'});
		dwr.util.addOptions('tipoIdentificacion', tIdentific, 'tipoIdentiID', 'nombre');
	});		
}


function sumaPagarValidaIdentificacion(idControl){	// se ejecuta desde Grid "servifunEntregadoGridVista"
	$('#folioentregadoID').val('');	
	$('#montoEntregarServifun').val('');	
	$('#nombreRecibeBeneficio').val('');
	
	var numero= idControl.substr(8,idControl.length);
	var jqcantidadEntregado = eval("'#cantidadEntregado"+numero+"'");	
	var valorCantidadEntregado = $(jqcantidadEntregado).asNumber();
	var jqServiFunEntregadoID = eval("'#serviFunEntregadoID"+numero+"'");	
	var valorServiFunEntregadoID = $(jqServiFunEntregadoID).asNumber();
	
	var jqNombreRecibePago= eval("'#nombreRecibePago"+numero+"'");	
	var valorNombreRecibePago = $(jqNombreRecibePago).val();
	
	var jqControl = eval("'#"+idControl+"'");	
	$(jqControl).focus();
	
	$('tr[name=benefiServifun]').each(function() {
		var numero= this.id.substr(14,this.id.length);
		var jqNombreRecibePago= eval("'#nombreRecibePago"+numero+"'");	
		var jqEstatus= eval("'#estatus"+numero+"'");	
		var valorEstatus = $(jqEstatus).val();		
		
		var jqEntregar = eval("'#entregar"+numero+"'");	
		if($(jqEntregar).attr('checked') == true){
			$('#nombreRecibeBeneficio').val('');
			$('#nombreRecibeBeneficio').val(valorNombreRecibePago);
		}else{
			if(valorEstatus == 'AUTORIZADO'){
				$(jqNombreRecibePago).val('');	
			}
			
		}
		
	});
	
	
	$('#folioentregadoID').val(valorServiFunEntregadoID);	
	$('#montoEntregarServifun').val(valorCantidadEntregado);
	$('#nombreRecibeBeneficio').val(valorNombreRecibePago);
	
	
	$('#fielsetIndeitificacion').show();
	$('#tipoIdentificacion').val('').selected == true;
	$('#folioIdentificacion').val('');
	
	totalEntradasSalidasGrid();
	$('#montoEntregarServifun').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});	
}

function seleccionaPersonaRecibe(idControl){			
	$('tr[name=benefiServifun]').each(function() {
		var numero= this.id.substr(14,this.id.length);
		var jqNombreRecibePago= eval("'#nombreRecibePago"+numero+"'");	
		var valorNombreRecibePago = $(jqNombreRecibePago).val();		
		
		var jqEntregar = eval("'#entregar"+numero+"'");	
		if($(jqEntregar).attr('checked') == true){
			$('#nombreRecibeBeneficio').val('');
			$('#nombreRecibeBeneficio').val(valorNombreRecibePago);
		}
		
	});
}

function imprimeTicketPagoServifun() {		 		     	    
	var i =0;				
				var imprimeTicketProteccionBean ={
					    'folio' 	       	:$('#numeroTransaccion').val(),
				        'tituloOperacion'  	:'PAGO SERVIFUN',
					    'clienteID'         :$('#clienteServifunID').val(),						  
					    'beneficiario'     	:$('#nombreCteServifun').val(),	
					    'numCteBeneficiario':$('#clienteServifunID').val(),
				        'nombreRecibe'      :$('#nombreCteServifun').val(),
	                    'totalBeneficioNum'    :$('#montoEntregarServifun').asNumber(),
	                    'totalBeneficio'    :$('#montoEntregarServifun').val(),						   
					    'tipoServicio'		:$('#tipoServivioServifun').val(),
					    'numCta'			:$('#cuentaAhoIDCte'+i).val(),
					    'tipoIdentificacion':$("#tipoIdentificacion option:selected").html(),
					    'folioIdentificacion':$('#folioIdentificacion').val(),
					};					
				imprimeTicketSERVIFUN(imprimeTicketProteccionBean);			

}

function limpiacampoServifun(){
	limpiaCamposIdentificacion();
	$('#gridServifun').html("");
	$('#gridServifun').hide();
	$('#montoEntregarServifun').val('');
	$('#nombreCteServifun').val("");					
	$('#fechaNacimientoServifun').val("");
	$('rfcServifun').val("");					
	$('#curpServifun').val("");
	$('#estadoCivilServifun').val("");
	$('#fechaIngresoServifun').val("");
	$('#edadIngresoServifun').val("");
	$('#clienteServifunID').val("");
}

function limpiaCamposIdentificacion(){
	$('#tipoIdentificacion').val('');
	$('#folioIdentificacion').val('');
	$('#fielsetIndeitificacion').hide();
}

