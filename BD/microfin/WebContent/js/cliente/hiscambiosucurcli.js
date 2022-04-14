$(document).ready(function() {
	
	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	$('#avalados').val("");
	$('#inicioAvalados').val('');
	$('#creditosAvalados').val('');
	$('#clienteID').focus();
	/* consulta parametros de usuario y sesion */
	var parametrosBean = consultaParametrosSession();
	
	$("#usuarioID").val(parametrosBean.numeroUsuario);
	
	/*le da formato de moneda, calendario, etc */
	agregaFormatoControles('formaGenerica');
	
	$("#divNuevaSucursal").hide();
	deshabilitaBoton('grabar', 'submit');
	
	var tipoTransaccion= {
			'alta' : '1'
		};
	
	/* lista de ayudas para clientes */
	
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '9', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '25', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '9', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {	
		var cliente=$('#clienteID').val();
		if(cliente !='' && !isNaN(cliente) ){
			 var LongCliente=$('#clienteID').val().length;
			 if(LongCliente>11){
				 var maxLongCliente=$('#clienteID').val();
				 var max=maxLongCliente.substring(0,10);
				 $('#clienteID').val(max);
			 }
		} 
  		consultaCliente(this.id);  		
  		consultaGridOculto();
  		$('#imprimir').hide();
	});
	
	$('#imprimir').click(function() { 	
			generaReporte();
	});

	/* lista de ayudas para sucursales */
	$('#sucursalDestino').bind('keyup',function(e) { 
		lista('sucursalDestino', '2', '1', 'nombreSucurs', $('#sucursalDestino').val(), 'listaSucursales.htm');
	}); 
	$('#sucursalDestino').blur(function() {		
		consultaSucursalDestino(this.value);
	});
	
	
	/* lista de ayudas para promotores */
	$('#promotorActual').bind('keyup',function(e) { 
		var camposLista = new Array();
		var parametrosLista = new Array();		
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";	
		
		parametrosLista[0] = $('#promotorActual').val();
		parametrosLista[1] =  $('#sucursalDestino').val();		
		
		
		listaAlfanumerica('promotorActual', '2', '4', camposLista, parametrosLista, 'listaPromotores.htm');
	}); 
	$('#promotorActual').blur(function() {		
		consultaPromotorDespues(this.value);
	});
	
	
	
	/*asigna el tipo de transaccion */
	$('#grabar').click(function() {	
		$('#tipoTransaccion').val(tipoTransaccion.alta);
		ElementosGrid();
	});
	
	
	/*esta funcion esta en forma.js, verifica que el mensaje d error o exito aparezcan correctamente y que realizara despues de cada caso */
	$.validator.setDefaults({		
	    submitHandler: function(event) { 
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID',
		    			'funcionExitoTransaccion','funcionFalloTransaccion'); 
	      }
	 });
	
	
	
	

	/* =============== VALIDACIONES DE LA FORMA ================= */
		$('#formaGenerica').validate({			
			rules: {
				clienteID :{
					required:true,
				},
				sucursalDestino :{
					required:true,
					maxlength: 8
				},
				promotorActual :{
					required:true,
					maxlength: 8
				}
			},		
			messages: {
				clienteID :{
					required:'Especificar Socio',
				},
				sucursalDestino :{
					required:'Especificar Sucursal',
					maxlength: 'Máximo 8 caracteres'
				},
				promotorActual :{
					required:'Especificar Promotor',
					maxlength: 'Máximo 8 caracteres'
				}
			}		
		});

	
		
		
		/* =================== FUNCIONES ========================= */
			

				/* Consulta el cliente */
				function consultaCliente(idControl) {
					var jqCliente = eval("'#" + idControl + "'");
					var numCliente = $(jqCliente).val();
					var numConsulta = 1;
					var clienteActivo ='A';
					setTimeout("$('#cajaLista').hide();", 200);
					
					// si no esta vacio es un numero ejecutara la consulta del cliente
					if (numCliente != '' && !isNaN(numCliente)) {
					
						//constulta un cliente
						clienteServicio.consulta(numConsulta, numCliente, function(cliente) {
							//si el resultado obtenido de la consulta regreso un resultado
							if (cliente != null) {
								if(cliente.estatus == clienteActivo){
									inicializaForma('formaGenerica', 'clienteID');	
									habilitaBoton('grabar', 'submit');
										$("#clienteID").val(cliente.numero);
										$("#clienteIDDes").val(cliente.nombreCompleto);
										$("#sucursalOrigen").val(cliente.sucursalOrigen);
										$("#RFC").val(cliente.RFC);								
										$("#CURP").val(cliente.CURP);
										$("#razonSocial").val(cliente.razonSocial);
										$("#promotorAnterior").val(cliente.promotorActual);
										$("#fechaNacimiento").val(cliente.fechaNacimiento);
										$("#fechaIngreso").val(cliente.fechaAlta);
										$("#edad").val(cliente.edad);
										$("#estatus").val('ACTIVO');
																		
										switch(cliente.tipoPersona ) {
										case 'M':
											$("#tipoPersona").val('MORAL');
											$("#trRazonSocial").show();
										    break;
										case 'A':
											$("#tipoPersona").val('FÍSICA CON ACTIVIDAD EMPRESARIAL');
											$("#trRazonSocial").hide();
										    break;
										case 'F':
											$("#tipoPersona").val('FÍSICA');
											$("#trRazonSocial").hide();
										    break;
										}										
										
											$("#divNuevaSucursal").show();
											$('#sucursalDestino').focus();																		
										
										
										consultaSucursalOrigen(cliente.sucursalOrigen);
										consultaPromotorAnterior(cliente.promotorActual);
									}
									else{
										inicializaForma('formaGenerica', 'clienteID');	
										$("#clienteID").focus();
										$("#clienteID").val('');
										$("#clienteIDDes").val('');
										$("#divNuevaSucursal").hide();
										mensajeSis("El Socio No esta Activo.");										
										deshabilitaBoton('grabar', 'submit');
									}
							}
							else{
								inicializaForma('formaGenerica', 'clienteID');	
								$("#clienteID").focus();
								$("#clienteID").val('');
								$("#clienteIDDes").val('');
								$("#divNuevaSucursal").hide();
								mensajeSis("El Socio No existe.");								
								deshabilitaBoton('grabar', 'submit');								
							}
						});
						
					}
				}
				
				
				/* Consulta la sucursal  */
				function consultaSucursalOrigen(numSucursal) {		
					var tipoConsulta = 2;
					setTimeout("$('#cajaLista').hide();", 200);
					
					if (numSucursal != '' && !isNaN(numSucursal)) {			
						sucursalesServicio.consultaSucursal(tipoConsulta,numSucursal, function(sucursal) {
							if (sucursal != null) {
								$('#sucursalOrigen').val(sucursal.sucursalID);	
									$('#sucursalOrigenDes').val(sucursal.nombreSucurs);	
								
							} else {
								mensajeSis("La Sucursal No Existe.");
								$('#sucursalOrigenDes').val('');
							}
						});
					}
				}
				
				/* Consulta la sucursal  */
				function consultaSucursalDestino(numSucursal) {		
					var tipoConsulta = 2;
					setTimeout("$('#cajaLista').hide();", 200);
					$('#promotorActual').val('');
					$('#promotorActualDes').val('');					
					
					if (numSucursal != '' && !isNaN(numSucursal)) {			
						sucursalesServicio.consultaSucursal(tipoConsulta,numSucursal, function(sucursal) {
							if (sucursal != null) {
								$('#sucursalDestino').val(sucursal.sucursalID);
									$('#sucursalDestinoDes').val(sucursal.nombreSucurs);	
								
							} else {
								$('#sucursalDestino').focus();
								$('#sucursalDestinoDes').val('');
								$('#sucursalDestino').val('');
								mensajeSis("La Sucursal No Existe.");								
							}
						});
					}
				}
				
				/* Consulta el promotor */
				function consultaPromotorAnterior(numPromotor) {		
					var tipoConsulta = 1;
					var promotorBean = {
							'promotorID'	: numPromotor
					};
					setTimeout("$('#cajaLista').hide();", 200);					
					
					if (numPromotor != '' && !isNaN(numPromotor)) {			
						promotoresServicio.consulta(tipoConsulta,promotorBean, function(promotor) {
							if (promotor != null) {
								$('#promotorAnterior').val(promotor.promotorID);	
									$('#promotorAnteriorDes').val(promotor.nombrePromotor);		
								}
								else{
									$('#promotorAnteriorDes').val('');	
								}
						});
					}
				}
				
				/* Consulta el promotor  */
				function consultaPromotorDespues(numPromotor) {		
					var tipoConsulta = 4;
					var promotorBean = {
							'promotorID'	: numPromotor
					};
					setTimeout("$('#cajaLista').hide();", 200);
					
					if (numPromotor != '' && !isNaN(numPromotor)) {			
						promotoresServicio.consulta(tipoConsulta,promotorBean, function(promotor) {
							if (promotor != null) {
									if(promotor.sucursalID == $("#sucursalDestino").asNumber()){
										$('#promotorActual').val(promotor.promotorID);
										$('#promotorActualDes').val(promotor.nombrePromotor);										
									}else{
										$('#promotorActual').focus();
										$('#promotorActual').val('');
										$('#promotorActualDes').val('');	
										mensajeSis("El Promotor No pertenece a la Sucursal indicada");
									}										
								}
								else{		
									$('#promotorActual').focus();
									$('#promotorActual').val('');
									$('#promotorActualDes').val('');
									mensajeSis("El Promotor No Existe.");
								}
						});
					}
				}
				
				//Funcion para Generar Reporte 
				function generaReporte(){	
					var tipoReporte=2;
					var sucursal = parametroBean.nombreSucursal;
					var clienteID =$('#clienteID').val();
					var nombreCliente = $('#clienteIDDes').val();
					var nombreInstitucion =  parametroBean.nombreInstitucion; 
					var domicilioInst =  parametroBean.direccionInstitucion;
					var rfcInst=parametroBean.rfcInst;
					var sucursalOrigenDes=$('#sucursalOrigenDes').val();
					var sucursalDestinoDes=$('#sucursalDestinoDes').val();
										
					var paginaReporte= 'reporteHiscambiosucurcli.htm?nombreInstitucion='+nombreInstitucion+'&clienteID='+clienteID+'&sucursal='+sucursal+
					'&clienteIDDes='+nombreCliente+'&domicilioInst='+domicilioInst+'&rfcInst='
					+rfcInst+'&sucursalOrigenDes='+sucursalOrigenDes+'&sucursalDestinoDes='+sucursalDestinoDes+'&tipoReporte='+tipoReporte;			
					$('#ligaGenerar').attr('href',paginaReporte);
			}
	
});


//grid de documentos entregados
function consultaGridOculto(){		
	$('#creditosAvalados').val('');
	var params = {};
	params['tipoLista'] = 34;	
	params['clienteID'] = $('#clienteID').val();	
	
	$.post("resumenCteCreditosAvalados.htm", params, function(data){
		if(data.length >0) {	
			$('#creditosAvalados').html(data);
			var numFilas=consultaFilas();		
			if(numFilas == 0 ){
				$('#creditosAvalados').html("");
			}	
		}else{				
			$('#creditosAvalados').html("");		
		}
	});
}


function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
		
	});
	return totales;
}


function ElementosGrid(){		
	$('#avalados').val("");		
	var credito="Crédito: ";
	var estatusCre=" Estatus: ";
	var DiasAtraso=" Días Atraso: ";
	var numDoc = consultaFilas();	
	$('#inicioAvalados').val("El " +$('#socioCliente').val()+ " se Encuentra Avalando los Siguientes Créditos: \n");
	var credAvalados="";
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var cred= eval("'#creditoIDAv" + numero + "'");   
			var stast= eval("'#estatusAv" + numero + "'");   
			var dias= eval("'#diasAtrasoAv" + numero + "'");   
	
			if (numDoc >=1){
				if (($(stast).val()=="B" || $(stast).val()=="K" || $(stast).val()=="V")){
					//SE DEFINE EL ESTATUS DEL CREDITO
					if ($(stast).val()=="P"){
						$(stast).val("PAGADO");
					}else if ($(stast).val()=="V"){
						$(stast).val("VIGENTE");
					}else if ($(stast).val()=="K"){
						$(stast).val("CASTIGADO");						
					}else if($(stast).val()=="I"){
						$(stast).val("INACTIVO");
					}else if($(stast).val()=="B"){
						$(stast).val("VENCIDO");
					}else if($(stast).val()=="A"){
						$(stast).val("AUTORIZADO");
					}else if($(stast).val()=="C"){
						$(stast).val("CANCELADO");
					}
					
					$('#avalados').val($('#inicioAvalados').val()
										  +$('#avalados').val()
										  +credito + $(cred).val()
										  + estatusCre + $(stast).val()
										  + DiasAtraso + $(dias).val()+ "\n" );
					credAvalados=$('#avalados').val();	
					$('#inicioAvalados').val("");
				}
			}
		});
		if (credAvalados !=""){
			confirmacion = confirm(credAvalados + " \n Desea Continuar?");
			if (confirmacion!=true){
				event.preventDefault();
			}
		}
		
}	

function funcionExitoTransaccion(){
	//inicializaForma('formaGenerica', 'clienteID');	
	deshabilitaBoton('grabar', 'submit');
	$('#imprimir').show();
}

function funcionFalloTransaccion(){
	//inicializaForma('formaGenerica', 'clienteID');
}