	var Var_EstatusRegistradaSol	='R';
	var Var_EstatusAutorizadaSol	='A';
	var Var_EstatusRechazadaSol		='X';
	var Var_EstatusPagadaSol		='P';
	
$(document).ready(function() {

	

	$('#buscarMiSucApo').click(function(){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "clienteID";
		camposLista[1] = "apoyoEscSolID";
		camposLista[2] = "nombreCompleto";
		
		parametrosLista[0] = 0;
		parametrosLista[1] = 0;
		parametrosLista[2] = $('#clienteIDApoyoEsc').val();		
		listaCte('clienteIDApoyoEsc', '2', '6', camposLista, parametrosLista, 'listaApoyoEscolarSol.htm');
	});
	$('#buscarGeneralApo').click(function(){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "clienteID";
		camposLista[1] = "apoyoEscSolID";
		camposLista[2] = "nombreCompleto";
		
		parametrosLista[0] = 0;
		parametrosLista[1] = 0;
		parametrosLista[2] = $('#clienteIDApoyoEsc').val();		
		listaCte('clienteIDApoyoEsc', '2', '7', camposLista, parametrosLista, 'listaApoyoEscolarSol.htm');
	});

	$('#clienteIDApoyoEsc').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "clienteID";
		camposLista[1] = "apoyoEscSolID";
		camposLista[2] = "nombreCompleto";
		
		parametrosLista[0] = 0;
		parametrosLista[1] = 0;
		parametrosLista[2] = $('#clienteIDApoyoEsc').val();	

		if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
			listaCte('clienteIDApoyoEsc', '2', '7', camposLista, parametrosLista, 'listaApoyoEscolarSol.htm');
		}

		if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
			listaCte('clienteIDApoyoEsc', '2', '6', camposLista, parametrosLista, 'listaApoyoEscolarSol.htm');
		}
	});

	
	$('#clienteIDApoyoEsc').blur(function() {
		borrarDivCheques();
		setTimeout("$('#cajaLista').hide();", 200);
		var cliente = $('#clienteIDApoyoEsc').asNumber();
		if (cliente > 0) {
			listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
			if (listaPersBloqBean.estaBloqueado != 'S') {
				expedienteBean = consultaExpedienteCliente(cliente);
				if (expedienteBean.tiempo <= 1) {
					if (alertaCte(cliente) != 999) {
						consultaClienteApoyoEscolar(this.id);
					}
				} else {
					mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
					limpiaFormaApoyoEscolar();
				}
			} else {
				mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				limpiaFormaApoyoEscolar();
			}
		} else {
			limpiaFormaApoyoEscolar();
		}
	});
	$('#apoyoEscSolID').change(function(){
		consultaSolicitudApoyoEscolar();
	});
	
	$('#recibeApoyoEscolar').blur(function() {
		$('#cantSalMil').focus();
	});
	
	 function consultaClienteApoyoEscolar(idControl) {
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();	
			var tipConPrincipal = 1;						
			limpiaFormaApoyoEscolar();
			setTimeout("$('#cajaLista').hide();", 200);			

			if(numCliente != '' && !isNaN(numCliente) ){
				clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
					if(cliente!=null){	
						$('#fielsetSocioApoyoEscolar').show();
						
						$('#nombreCteApoyoEsc').val(cliente.nombreCompleto);	
						$('#sucursalSocioAEsc').val(cliente.sucursalOrigen);
						$('#fechaNacimientoAEsc').val(cliente.fechaNacimiento);
						$('#RFCClienteAEsc').val(cliente.RFC);
						$('#edadClienteAEsc').val(cliente.edad);
						$('#fechaIngresoAEsc').val(cliente.fechaAlta);										
						if(cliente.tipoPersona == 'F'){
							$('#tipoPersonaAEsc').val('FÍSICA');
						}else{
							if(cliente.tipoPersona == 'A'){
								$('#tipoPersonaAEsc').val('FÍSICA ACT. EMP.');
							}else{
								$('#tipoPersonaAEsc').val('MORAL');
							}
						}
						if(cliente.esMenorEdad == 'S'){
							$('#fielsetDatosTutor').show();
							consultaDatosTutorMenor('clienteIDApoyoEsc');
						}else{
							$('#fielsetDatosTutor').hide();
						}
						consultaSucursalGenerica('sucursalSocioAEsc','descSucursalAEsc');
						llenaComboSolApoyoEscolar();
					}else{
						$('#fielsetSocioApoyoEscolar').hide();
						mensajeSis("No Existe el Cliente");				
						$('#'+idControl).focus();
						$('#'+idControl).select();					
					}
				});
			}
		}
	 
	 
	 function consultaDatosTutorMenor(idControl) {
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();	
			var tipConDatosTutor = 12;	
			setTimeout("$('#cajaLista').hide();", 200);			

			if(numCliente != '' && !isNaN(numCliente) ){
				socioMenorServicio.consultaTutor(tipConDatosTutor,numCliente,function(tutor) {
					if(tutor!=null){	
						var tipoRelacionID = 40;  // id de Tutor
					
						$('#clienteIDTutor').val(tutor.clienteTutorID);
						$('#nombreTutor').val(tutor.nombreTutor);
						$('#parentescoCliente').val(tipoRelacionID);
						$('#descParentesco').val(tutor.parentescoTutor);

						
					}else{						
						mensajeSis("No Existen datos del Tutor");				
				
					}
				});
			}
		}
	 

	 function llenaComboSolApoyoEscolar() {		
		 var listaSolicitudesCombo = 4;
		 var clienteApoyoEscolar =$('#clienteIDApoyoEsc').val();
		 
		 var solicitudApoyoEsc = {
					'clienteID'		: clienteApoyoEscolar,
					'apoyoEscSolID'	:0,
					'nombreCompleto' :''
		};
		
			
		 apoyoEscolarSolServicio.listaCombo(listaSolicitudesCombo, solicitudApoyoEsc, function(solicitudApoyo){	
			dwr.util.removeAllOptions('apoyoEscSolID'); 
			dwr.util.addOptions('apoyoEscSolID', {'':'SELECCIONAR'});
			dwr.util.addOptions('apoyoEscSolID',solicitudApoyo, 'apoyoEscSolID', 'descripcionSolcitud'); 				 		
		});
	}
	 
	 

});// fin Document
function consultaSolicitudApoyoEscolar() {	
	var tipoConsultaPrincipal = 1;	
	limpiaFormaSolicitdApoyo();
	setTimeout("$('#cajaLista').hide();", 200);			
	var numCliente = $('#clienteIDApoyoEsc').val();
	
	var solicitudBean = {
				'clienteID':	$('#clienteIDApoyoEsc').val(),	
				'apoyoEscSolID':$('#apoyoEscSolID').val()
	};
	if(numCliente != '' && !isNaN(numCliente) ){
		apoyoEscolarSolServicio.consulta(tipoConsultaPrincipal,solicitudBean,function(solicitudApoyo) {
			if(solicitudApoyo != null){	
				$('#fielsetApoyoEscolar').show();							
				$('#gradoEscolar').val(solicitudApoyo.gradoEscolar);
				$('#cicloEscolar').val(solicitudApoyo.cicloEscolar);
				$('#promedioEscolar').val(solicitudApoyo.promedioEscolar);
				$('#edadCliente').val(solicitudApoyo.edadCliente);
				$('#monto').val(solicitudApoyo.monto);
				$('#fechaRegistro').val(solicitudApoyo.fechaRegistro);
				
				$('#estatusApoyoEscolar').val(solicitudApoyo.estatus);
				if(solicitudApoyo.estatus == Var_EstatusRegistradaSol){
					$('#estatusApoyoEscolar').val('REGISTRADO');
				}else if(solicitudApoyo.estatus == Var_EstatusAutorizadaSol){
					$('#estatusApoyoEscolar').val('AUTORIZADA');
				}else if(solicitudApoyo.estatus == Var_EstatusRechazadaSol){
					$('#estatusApoyoEscolar').val('RECHAZADA');
				}else if(solicitudApoyo.estatus == Var_EstatusPagadaSol){
					$('#estatusApoyoEscolar').val('PAGADA');
				}					
				$('#edadClienteAEsc').val(solicitudApoyo.edadCliente);
				$('#descripcionGradoEsc').val(solicitudApoyo.desCicloEscolar);
				consultaUsuario(solicitudApoyo.usuarioRegistra, 'usuarioRegistra');
				totalEntradasSalidasGrid();				
			}else{	
				$('#fielsetApoyoEscolar').hide();
				mensajeSis("No Existe la Solicitud de Apoyo Escolar");						
			}
		});
	}
}
function consultaUsuario(usuarioID, nombreUsuario){
	var conForanea = 2;
	var usuarioBean = {
		'usuarioID' : usuarioID
	};
	if(usuarioID != '' && !isNaN(usuarioID)){
		usuarioServicio.consulta(conForanea, usuarioBean, function(usuario){
			if (usuario != null){					
				$('#'+nombreUsuario).val(usuario.nombreCompleto);					
			}else{
				mensajeSis('No Existe el Usuario');					
				$('#'+nombreUsuario).val('');					
			}
		});
	}
}
function limpiaFormaApoyoEscolar(){	
	$('#nombreCteApoyoEsc').val('');
	$('#apoyoEscSolID').val('').selected =true;
	$('#sucursalSocioAEsc').val('');
	$('#descSucursalAEsc').val('');
	$('#fechaNacimientoAEsc').val('');
	$('#RFCClienteAEsc').val('');
	$('#edadClienteAEsc').val('');
	$('#tipoPersonaAEsc').val('');
	$('#fechaIngresoAEsc').val('');
	$('#clienteIDTutor').val('');
	$('#nombreTutor').val('');
	$('#parentescoCliente').val('');
	$('#descParentesco').val('');
	$('#descripcion').val('');
	$('#recibeApoyoEscolar').val('');
	limpiaFormaSolicitdApoyo('');
	
	
}
function limpiaFormaSolicitdApoyo(){
	$('#gradoEscolar').val('');
	$('#cicloEscolar').val('');
	$('#promedioEscolar').val('');
	$('#edadCliente').val('');
	$('#monto').val('');
	$('#fechaRegistro').val('');
	$('#estatusApoyoEscolar').val('');
	$('#usuarioRegistra').val('');
	$('#descripcionGradoEsc').val('');
	
}


function imprimeTicketApoyoEscolar() {	
	var imprimeTicketApoyoEscolarBean ={
		    'folio' 	       	:$('#numeroTransaccion').val(),
	        'tituloOperacion'  	:'PAGO APOYO ESCOLAR',
		    'clienteID'         :$('#clienteIDApoyoEsc').val(),
		    'nombreCliente'     :$('#nombreCteApoyoEsc').val(),
		    'personaRecibe'     :$('#recibeApoyoEscolar').val(),
		    'monto'				:$('#monto').val(),	       		    
		};					
	imprimeTicketPagoApoyoEscolar(imprimeTicketApoyoEscolarBean);			
														
		
}

	
