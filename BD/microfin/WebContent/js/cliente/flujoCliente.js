//este archivo es usado por flujoIndividualCatalogoVista.jsp
expedienteBean = {
		'clienteID' : 0,
		'tiempo' : 0,
		'fechaExpediente' : '1900-01-01',
};
listaPersBloqBean = {
		'estaBloqueado'	:'N',
		'coincidencia'	:0
};
var esCliente 			='CTE';
var esUsuario			='USS';
var clasificacionCliNom	="";
$(document).ready(function() {
	parametroBean = consultaParametrosSession(); 
	esTab = false;
	solicitudActual="";
	$('#flujoCliNumCli').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaMenu');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$( '#tabs' ).tabs({
		ajaxOptions: {
			error: function( xhr, status, index, anchor ) {
				$( anchor.hash ).html("Couldn't load this tab. We'll try to fix this as soon as possible. " +
					"If this wouldn't be a demo." );
			}
		}
    });				

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	
	
	$.validator.setDefaults({
			submitHandler: function(event) {
				grabaFormaTransaccion(event, 'formaMenu', 'contenedorForma', 'mensaje','true','flujoCliNumCli');	
			}
				
	});	
	
	$('#flujoCliNumCli').blur(function() {
		if(esTab == true){
			consultaFlujo('0',$('#flujoCliNumCli').val());
		}
		
	});


	$('#flujoCliNumCli').bind('keyup',function(e){
		if(this.value.length >= 0){
			listaContenedor('flujoCliNumCli', '3', '1', 'nombreCompleto', $('#flujoCliNumCli').val(), 'listaCliente.htm');
		}				       
	});
	
	$('#flujoCliNumCli').bind('keyup',function(e){
		if($('#flujoCliNumCli').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});

	$('#buscarMiSuc').click(function(){
		listaCte('flujoCliNumCli', '3', '19', 'nombreCompleto', $('#flujoCliNumCli').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('flujoCliNumCli', '3', '1', 'nombreCompleto', $('#flujoCliNumCli').val(), 'listaCliente.htm');
	});
	
	
	
	
	$('#tabs ul li a').click(function(){
		
		var controlTab = eval("'#"+this.id+"'");
		var controlPantalla = eval("'#_"+this.id+"'");
		var recurso = $(controlTab).val();
		if(this.id == 'selecciona'){
			$('#_selecciona').show();
			$('#flujoCliNumCli').focus().select();
		}else{
			for(var i = 1; i < 16;i++){
				var jqPantallas = eval("'#_pantalla"+i+"'");
				$(jqPantallas).html('');
			}
			$(controlPantalla).load(recurso);
			
			$('#_selecciona').hide();
		}
	});
	
	$('#formaMenu').validate({
		rules: {
		},
		messages: {
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	
			
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =1;
		var rfc = ' ';
		setTimeout("$('#cajaListaContenedor').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){							
					$('#nomCompleto').val(cliente.nombreCompleto);
				}else{
					mensajeSis("No Existe el Cliente");
					$(jqCliente).focus();
				}    						
			});
		}
	}
	
	
	
}); // fin funcion principal

var parametroBean = consultaParametrosSession(); 

function limpiaPestanias(){
//	$("#selecciona").html("");
	$("#solic").hide();
	$("#bc").hide();
	$("#datSosEc").hide();
	$("#aval").hide();
	$("#asigAval").hide();
	$("#garan").hide();		
	$("#asigGaran").hide();
	$("#check").hide();		
	$('#burocredito').hide();	
	$('#checklist').hide();
	$('#contAvales').hide();	
	$('#asignaAval').hide();	
	$('#garantias').hide();				
	$('#asignaGarantias').hide(); 
	$('#dtsSocioEcon').hide();
}
function muestraPestanias(){
//	$("#selecciona").html();
	$("#solic").show();
	$("#bc").show();
	$("#datSosEc").show();
	$("#check").show();		
	$('#burocredito').show();	
	$('#checklist').show();
	$('#dtsSocioEcon').show();
}
	
	function validaNuevosComentarios(estatusSolicitud, jqComentarioNuevo){
		var inactiva = 'I';
		if(estatusSolicitud == inactiva){
			 habilitaBoton('agregarComent', 'submit');
			 $('#nuevosComents').removeAttr('disabled');
		}else{
			deshabilitaBoton('agregarComent', 'submit');
			$('#nuevosComents').attr('disabled',true);
			$('#nuevosComents').val('');
		}
	}
	
	
	function validaProductoRequiereGarantia(requiereGarantia){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereGarantia == siRequiere){
			$('#garan').show('slow');
			$('#asigGaran').show('slow');
		}
		if(requiereGarantia == noRequiere){
			$('#garantias').html("");				
			$('#asignaGarantias').html(""); 
			$('#garan').hide('slow');
			$('#asigGaran').hide('slow');
		}
	}
	
	function validaProductoRequiereAvales(requiereAvales){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereAvales == siRequiere){
			$('#aval').show('slow');
			$('#asigAval').show('slow');
			
		}
		if(requiereAvales == noRequiere){
			$('#contAvales').html("");	
			$('#asignaAval').html("");
			$('#aval').hide('slow');
			$('#asigAval').hide('slow');
		}
	}
	
	
	function validaContieneComentario(comentario){
		var comentarioEjecutivo =  $.trim(comentario);
		if(comentarioEjecutivo !=''){
			$('#comentEjecut').val(comentarioEjecutivo);
			$('#comentDeEjecutivo').show('slow');			
			$('#labelHistorialCom').show('slow');
		}else{
			$('#comentEjecut').val('');
			$('#comentDeEjecutivo').hide('slow');
			$('#labelHistorialCom').hide('slow');
		}
	}
	
	
	 
	function consultacicloCliente(idControlCicloCliente, par_Cliente, par_Prospecto, par_ProductoCredito, par_Grupo){
		var sqCicloCliente = eval("'#"+idControlCicloCliente+"'");
		var CicloCreditoBean = {
				'clienteID':par_Cliente,
				'prospectoID':par_Prospecto,
				'productoCreditoID':par_ProductoCredito,
				'grupoID':par_Grupo
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		solicitudCredServicio.consultaCiclo(CicloCreditoBean,function(cicloCreditoCte) {
			if(cicloCreditoCte !=null){
				$(sqCicloCliente).val(cicloCreditoCte.cicloCliente);
			}	
			else{
				mensajeSis('No hay Ciclo para el Cliente');
			}
		});

	}
	
	function consultaProducCredito(idControlDecripcion, valor) {
		var jqProdCred  = eval("'#" + idControlDecripcion + "'");
		var ProdCredBeanCon = {
				'producCreditoID':valor 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		if(valor != '' && !isNaN(valor) ){		
			productosCreditoServicio.consulta(2,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$(jqProdCred).val(prodCred.descripcion);
				}else{							
					mensajeSis('No Existe el Producto de Crédito');
					$(jqProdCred).val('');
				}
			});
		}				 					
	}
	function consultaFlujo(esPantallaAltaCli, clienteVal){
		inicializaForma('contenedorForma', 'flujoCliNumCli');
		$('#flujoCliIdeID').val(0);
		$('#flujoCliDirOfi').val(0);
		$('#flujoCliSolCue').val(0);
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		if(isNaN(clienteVal) ){
			$('#flujoCliNumCli').focus().select();
		}else{
			if( $.trim(clienteVal)!= "" && $.trim(clienteVal)!= "0" ){
				var cliente = $('#flujoCliNumCli').asNumber();
				if(cliente>0){
					listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
					if(listaPersBloqBean.estaBloqueado!='S'){
						expedienteBean = consultaExpedienteCliente(cliente);
						if(expedienteBean.tiempo<=1){
							clienteServicio.consulta(1,clienteVal,function(cliente) {
								if(cliente != null){
									if($('#numero').val() != undefined){
										$('#numero').val(clienteVal);
									}
									
									$('#nomCompleto').val(cliente.nombreCompleto);
									$('#sucOrigen').val(cliente.sucursalOrigen);
									clasificacionCliNom = cliente.clasificacion;

									sucursalesServicio.consultaSucursal(2,cliente.sucursalOrigen,function(sucursal) { 
										if(sucursal!=null){
											$('#nomsucOrigen').val(sucursal.nombreSucurs);
										}else{
											$('#nomsucOrigen').val('');
										}
									});
									switch(cliente.tipoPersona){
										case 'A':$('#tipoPer').val('FÍSICA ACT. EMP.'); break;
										case 'F':$('#tipoPer').val('FÍSICA'); break;
										case 'M':$('#tipoPer').val('MORAL'); break;
										default: $('#tipoPer').val('NO IDENTIFICADO');
									}
									$('#promActual').val(cliente.promotorActual);
									var promotor = {
											 'promotorID' : cliente.promotorActual
											};
									promotoresServicio.consulta(2, promotor,function(respromotor) {
										if(respromotor!=null){
											$('#nompromotorActual').val(respromotor.nombrePromotor);
										}else{
											$('#nompromotorActual').val('');
										}
									});
									var direccionesCliente ={
								 			'clienteID' : clienteVal  		
									};		
									direccionesClienteServicio.consulta(3,direccionesCliente,function(direccion) {
										if(direccion!=null){
											$('#flujoCliDirOfi').val(direccion.direccionID);
											$('#direCompleta').val(direccion.direccionCompleta);
										}else{
											$('#flujoCliDirOfi').val('0');
											$('#direCompleta').text('');
										}
									});
									var identifiCliente = {
											'clienteID' :  clienteVal
									};

									identifiClienteServicio.consulta(3,identifiCliente,function(identificacion) {
										if(identificacion != null){
											$('#flujoCliIdent').val(identificacion.numIdentific);
											$('#flujoCliIdeID').val(identificacion.identificID);
											
											tiposIdentiServicio.consulta(2,identificacion.tipoIdentiID, function(tipoident){
												if(tipoident != null){
													$('#nomidentificacion').val(tipoident.nombre);
												}else{
													$('#nomidentificacion').val('');
												}
											});
										}else{
											$('#flujoCliIdent').val('');
										}
									});
									
									
									var beanCuentasAho = {
											'clienteID':clienteVal
									};
									cuentasAhoServicio.consultaCuentasAho(15,beanCuentasAho,function(respCuentasAho){
										if(respCuentasAho!=null){
											$('#flujoCliSolCue').val(respCuentasAho.cuentaAhoID);
											$('#flujoCliSolCuePrinc').val(respCuentasAho.cuentaAhoID);
										}else{
											$('#flujoCliSolCue').val('');
											$('#flujoCliSolCuePrinc').val('');
										}
									});
									///esto es para rellenar los tabs
									asignaTabs('flujoCliNumCli',esPantallaAltaCli);
								}else{
									mensajeSis('No existe Cliente');
									inicializaForma('contenedorForma', 'flujoCliNumCli');
									$('#flujoCliNumCli').focus().select();
								}
								
							});					
						} else {
							inicializaForma('contenedorForma', 'flujoCliNumCli');
							mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
							$('#flujoCliNumCli').focus().select();
						}
					} else {
						inicializaForma('contenedorForma', 'flujoCliNumCli');
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						$('#flujoCliNumCli').focus().select();
					}
				}
			}else if ($.trim(clienteVal) == "0"){
				
				//debe hacerlo automatico
				asignaTabs('flujoCliNumCli',esPantallaAltaCli);
				
				
			}else{
				inicializaForma('contenedorForma', 'flujoCliNumCli');
				$('#flujoCliNumCli').focus().select();
			}
		}
	
	}
	function asignaTabs(idControl, esPantallaAltaCli){
		var jqControl=eval("'#"+idControl+"'");
		var numeroCliente = $(jqControl).val();
		var tipoFlujoListaCliente = 1;
		var bean= {
				'tipoFlujoID':1,
				'identificador':numeroCliente,
				'nomCortoInstitucion':parametroBean.nombreCortoInst
		};
		
///primero se pregunta si es una consulta o una agregacion nueva de cliente/socio -------------
		if(!isNaN(numeroCliente) &&  numeroCliente.trim() >= '0'){
				flujoPantallaClienteServicio.lista(tipoFlujoListaCliente,bean,function(data){
					if(data != null){
						for(var i = 1; i < 16; i++){						
							if(esPantallaAltaCli != i){ // se excluye la pantalla de la que fue llamada para no limpiarla
								var sqtab = eval("'#pantalla"+i+"'");
								var sqpantalla = eval("'#_pantalla"+i+"'");
								$(sqtab).val('');
								$(sqtab).hide();
								$(sqpantalla).html('');
							}
						}
						
						var nregistros= data.length;
						for(var cont=1; cont < 16;cont++){
							var jqControl = eval("'#pantalla"+cont+"'");
							var jqControlpantallas = eval("'#_pantalla"+cont+"'");
							if(!( esPantallaAltaCli = cont)){
								$(jqControl).hide();
								$(jqControl).val('');
								$(jqControl).html('');
								$(jqControlpantallas).val('');
								$(jqControlpantallas).html('');
								$(jqControlpantallas).empty('');
							}
							
						}
						for(var cont=0; cont < nregistros;cont++){
							var jqControl = eval("'#pantalla"+(data[cont].orden)+"'");
							$(jqControl).show();
							$(jqControl).val(data[cont].recurso);
							$(jqControl).html('');
							$(jqControl).append(data[cont].desplegado+ '<br><br>');
							
						}
						if(nregistros == 1){
							$('#_selecciona').hide();
							$('#pantalla1').show();
							$('#pantalla1').click();
							$("#selecciona").attr("href", "#_selecciona");
							
						}
						if(clasificacionCliNom!="M"){
							$("#pantalla11").hide();
						}
						
					}else{
						mensajeSis('No existen datos del flujo de Cliente y con número de cliente'+numeroCliente);
						inicializaForma('contenedorForma', 'flujoCliNumCli');
						$('#flujoCliNumCli').focus().select();
					}
				});
		}else {
			for(var i = 1; i < 16; i++){
				var sqtab = eval("'#pantalla"+i+"'");
				var sqpantalla = eval("'#_pantalla"+i+"'");
				$(sqtab).val('');
				$(sqtab).removeAttr('href');
				$(sqtab).hide();
				$(sqpantalla).html('');
			}
			$('#selecciona').removeAttr('href');
			$('#_selecciona').show();
			inicializaForma('contenedorForma', 'flujoCliNumCli');
			$(jqControl).focus.select();
		}
	}