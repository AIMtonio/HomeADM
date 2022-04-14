	var existeCreditoPagado = false;
	var existeCreditoCastigado = false;
	var existeSolicitud = false;
	var existeCredito = false;
	var montoTot = 0.0;
	var prorrateoPago;
	var modicarPrepago;
	var permitePrepago;
	var monedaContrato=0;
	var creditoContrato='';
	var montoTotalCreditoContrato=0;
	
	var mensajeAlert;  /*Esta variable mantiene el valor de un hilo para indicar cuando
						mostrara el mensajeSis despues de grabar la tranzaccion */
	
	agregaFormatoControles('formaGenerica');
	
$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();
	var nombreInstitucion;
	
	$("#grupoID").focus();
	
	deshabilitaBoton('actualizar', 'submit');
	deshabilitaBoton('generar', 'submit');
	deshabilitaBoton('contratoAdhesion', 'submit');
	deshabilitaBoton('planPago', 'submit');
 	
	$('#tdGenerar').hide();
	$('#tdContrato').hide();
	$('#tdPlan').hide();
	
	//Definicion de Constantes y Enums  
	var catTipoConCreditoGrup = {
		'principal':1,
  	};
	
	var catTipoConGrupo = {
		'principal':1,
	 };
	
	var catTipoTranPuesto = {
	  	'actualizaPuesto':1 
	};
		 
	agregaFormatoControles('formaGenerica');
	$.validator.setDefaults({
		submitHandler: function(event) {
			var msg = validaCargos();
			if(msg == ""){
      	  	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID',
      	  			'validaImpresion','errorCambioPuestoGrupo');
			}else{
				mensajeSis(msg);
				return false;
			}
		}
	});

	$(':text').focus(function() {
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
		esTab= true;
		}
	});
	
	$('#grupoID').bind('keyup',function(e){
	 if(this.value.length >= 2){ 
		 var camposLista = new Array(); 
		 var parametrosLista = new Array(); 
		 	camposLista[0] = "nombreGrupo";
		 	parametrosLista[0] = $('#grupoID').val();
		 	lista('grupoID', '2', '4', camposLista, parametrosLista, 'listaGruposCredito.htm'); 
		 }
 	});
	 
	$('#grupoID').blur(function() { 
		validaGrupo(this.id);
	});

	$('#actualizar').click(function() {
		$('#tipoTransaccion').val(catTipoTranPuesto.actualizaPuesto);
		validaSolicitudTransaccion();
		validaCreditoTransaccion();
		validaCreditoCastigadoPagado();
	});
	
	$('#contratoAdhesion').click(function() {			
		generaLiga();
	});

	
	//Funcion para generar el pagare grupal
	function generaLiga(){		
		var grupo = $('#grupoID').val();
		var numeroUsuario = parametroBean.numeroUsuario;
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var dirInst = parametroBean.direccionInstitucion;
		var RFCInst = parametroBean.rfcInst;
		var telInst = parametroBean.telefonoLocal;
		var fechaEmision = parametroBean.fechaSucursal;
		var representante = parametroBean.representanteLegal;
 		var ci = '5'; 	
 		
		$('#ligaGenerar').attr('href','RepPDFPagareCredito.htm?calcInteresID='+ci+'&grupoID='+grupo+
                '&monedaID='+monedaContrato+'&montoCredito='+montoTotalCreditoContrato+
                '&nombreInstitucion='+nombreInstitucion+ '&usuario='+numeroUsuario+'&producCreditoID='+$('#reca').val()
                +'&direccionInstit='+dirInst+'&RFCInstit='+RFCInst+'&telefonoInst='+telInst+'&fechaSistema='+fechaEmision
                +'&representanteLegal='+representante);					 		
	}
	
	//Funcion para generar el plan de pago del credito grupal
	$('#planPago').click(function() {	
		var grupo = $('#grupoID').val();
		var fechaDes = $('#fechaMinistrado').val();
		var producto = $('#descripProducto').val();
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var credito = '';
		var montoTotalCredito = 0.0;
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			if($('#credito'+numero).val()!=''){
			credito = $('#credito'+numero).val();

			}
			
		});
		
		$('input[name=montoCredito]').each(function() {
			var jQMonto = eval("'#" + this.id + "'");		
			var montoCre = $(jQMonto).asNumber();
			montoTotalCredito = montoTotalCredito + montoCre;
		});
		
		var creditoBeanCon = {
				'creditoID'	:credito
			};
		
		if(credito != '' && !isNaN(credito)){
			creditosServicio.consulta(catTipoConCreditoGrup.principal, creditoBeanCon,function(creditos) {
				if(creditos!=null){
					moneda =creditos.monedaID;
					
					nombreInstitucion=parametroBean.nombreInstitucion;
					var pagina='repPlanDePagosGrupal.htm?grupoID='+grupo+'&montoCredito='+montoTotalCredito+
					                            '&fechaMinistrado='+fechaDes+'&nombreProducto='+producto+'&nombreInstitucion='+nombreInstitucion;
				    window.open(pagina,'_blank');;	
				}
			});
		}
		
		$('tr[name=renglon]').each(function() {
			var id= this.id.substr(7,this.id.length);
			var clienteID = $('#cliente'+id).val();
			var montoCredito = $('#montoCredito'+id).val();
			var creditoID =$('#credito'+id).val();
			nombreInstitucion=parametroBean.nombreInstitucion;
			var estatusSolicitud= $('#estatusSolici'+id).val();    
			var estatusCredito= $('#estatusCredito'+id).val(); 
		
			
			if((estatusSolicitud!='C'|| estatusSolicitud!='R') && estatusCredito !='') {
				var pagina='repPlanPagosIndividual.htm?grupoID='+grupo+'&creditoID='+creditoID+'&clienteID='+clienteID+
				'&montoCredito='+montoCredito+'&fechaMinistrado='+fechaDes+'&nombreProducto='+producto+'&nombreInstitucion='+nombreInstitucion;
	            window.open(pagina,'_blank');
			}
		});
	});
	
	var creditoImprimir = "";
	
	//Funcion para imprimir el pagare grupal
	$('#generar').click(function() {	
		var numReg = $('input[name=consecutivo]').length;
		for(var i = 1; i <= numReg; i++){
			var credito = "credito"+i; 
			var jqCredito  = eval("'#" + credito + "'");
			creditoImprimir = $(jqCredito).val();
			var mc ="";
			var tb = "";
			var ci = "";
			var mon = "";
			var tt= 3;
			var ta= 2;
			var mont ="";
			var noCredito="";
			var numeroUsuario =parametroBean.numeroUsuario;
			var creditoBeanCon = {
				'creditoID'	:creditoImprimir
			};
	
			if(creditoImprimir != '' && !isNaN(creditoImprimir)){
				creditosServicio.consulta(catTipoConCreditoGrup.principal, creditoBeanCon,function(creditos) {
					if(creditos!=null){
						creditoImprimir="";
						Moned =creditos.monedaID;
						noCredito = creditos.creditoID;
						mc =creditos.montoCredito;
						tb = creditos.tasaBase;
						ci = creditos.calcInteresID; 
						mon =creditos.monedaID;
						numeroUsuario = parametroBean.numeroUsuario;
						mont =	 mc.replace (/,/,"");
						nombreInstitucion =  parametroBean.nombreInstitucion.toUpperCase();
						var fechaEmision = parametroBean.fechaSucursal;
						var dirInst = parametroBean.direccionInstitucion;
						var RFCInst = parametroBean.rfcInst;
						var telInst = parametroBean.telefonoLocal;
						var sucursal= parametroBean.sucursal;
						var gerente	= parametroBean.gerenteGeneral;
						if(ci=="1"){
							ci="9";
						}else{
							ci = creditos.calcInteresID; 
						}
						var enlace = ('RepPDFPagareCredito.htm?calcInteresID='+ci+'&montoCredito='+mont+'&tasaBase='+tb+'&creditoID='+noCredito+
						 	'&tipoTransaccion='+tt+'&tipoActualizacion='+ta+'&monedaID='+mon+'&usuario='+numeroUsuario+'&nombreInstitucion='+nombreInstitucion+
						 	'&producCreditoID='+$('#reca').val()+'&sucursal='+sucursal+'&gerenteSucursal='+gerente
							+'&direccionInstit='+dirInst+'&RFCInstit='+RFCInst+'&telefonoInst='+telInst+'&fechaSistema='+fechaEmision);	
						window.open(enlace);
					}			
				});
			}	
			if(i == numReg){ 
				var Moned='1';   
				var grupo =$('#grupoID').val();
				var tipoRepGrupal=4;
				var numeroUsuario = parametroBean.numeroUsuario;
				var montoToCre  = eval("'" + montoTot + "'");
				nombreInstitucion =  parametroBean.nombreInstitucion.toUpperCase();
					var enlace = ('RepPDFPagareCredito.htm?calcInteresID=0&montoCredito='+montoToCre+'&tasaBase=0&creditoID='+grupo+
					'&tipoTransaccion=0&tipoActualizacion=0&monedaID='+Moned+'&tipoReporte='+tipoRepGrupal+'&usuario='+numeroUsuario+
					'&nombreInstitucion='+nombreInstitucion+'&producCreditoID='+$('#reca').val());	
					 	window.open(enlace);
				}
			}
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			grupoID:  {
				required:true
			}
		
		},	
		messages: {			
			grupoID: {
				required: 'Especifique el Grupo.'
			}
			 
		}		
	});
	
	 
	//------------ Validaciones de Controles -------------------------------------

	//Funcion para Consultar el Grupo 
	function validaGrupo(idControl){
		$('#pagareImpreso').val("");
		monedaContrato=0;
		creditoContrato='';
		montoTotalCreditoContrato=0;
		existeCreditoPagado = false;
		existeCreditoCastigado = false;
		existeCredito = false;
		mensaje ='';
		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		
		var grupoBeanCon = { 
				'grupoID':grupo
		};	
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		if(grupo == 0){
			$('#grupoID').focus();
			$('#grupoID').val('');
			limpiaFormulario();
		}
		if(grupo != 0 && !isNaN(grupo)){
			$('#nombreGrupo').val("");
			$('#ciclo').val("");
			$('#estatus').val("");
			$('#fechaRegistro').val("");
			$('#estatusGrupo').val("");
			gruposCreditoServicio.consulta(catTipoConGrupo.principal,grupoBeanCon,function(grupos) {
				if(grupos!=null){
				esTab=true;  
				$('#nombreGrupo').val(grupos.nombreGrupo);	
				$('#ciclo').val(grupos.cicloActual);
				$('#fechaRegistro').val(grupos.fechaRegistro);
				$('#estatusGrupo').val(grupos.estatusCiclo);
				var nombEstatus="";
				switch(grupos.estatusCiclo){
					case 'N': nombEstatus="NO INICIADO";
					break;
					case 'A': nombEstatus="ABIERTO"; 
					break;
					case 'C': 
							nombEstatus="CERRADO"; 				
					break;
				}
				$('#estatus').val(nombEstatus);
				habilitaBoton('actualizar', 'submit');
				consultaIntegrantesGrid();
				$('#tdGenerar').hide();
				$('#tdContrato').hide();
				$('#tdPlan').hide();
				habilitaBoton('generar', 'submit');
				habilitaBoton('contratoAdhesion', 'submit');
				habilitaBoton('planPago', 'submit');
			}else{ 
				mensajeSis("El Grupo no Existe.");
				$(jqGrupo).focus();
				$(jqGrupo).val('');
				limpiaFormulario();
			}

			});	
		}
   }
 
	//Funcion para Consultar de Producto de Credito
	function consultaProducCredito(idControl) {  
			var jqProdCred  = eval("'#" + idControl + "'");
			var ProdCred = $(jqProdCred).val();			
			var ProdCredBeanCon = {
	  			'producCreditoID':ProdCred 
			}; 
			setTimeout("$('#cajaListaContenedor').hide();", 200);
			var conPrincipal= 1;
				if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
					productosCreditoServicio.consulta(conPrincipal,ProdCredBeanCon,function(prodCred) {
						if(prodCred!=null){
							$('#descripProducto').val(prodCred.descripcion);
							$('#reca').val(prodCred.registroRECA);
						}
					});
				}				 					
		}
	//Funcion para Consultar los Integrantes del Grupo
	function consultaIntegrantesGrid(){
		$('#integrantesGrupo').val('');
		var params = {};		
	
		params['tipoLista'] = 13;
		params['grupoID'] = $('#grupoID').val();

		$.post("cambioPuestoIntegrantesGridVista.htm", params, function(data){
			if(data.length >0) { 
				$('#integrantesGrupo').html(data);
				$('#integrantesGrupo').show();
				agregaFormatoControles('integrantesGrupo');
				var productCred = $('#prodCreditoID').val();
				$('#producCreditoID').val(productCred);
	
				consultaProducCredito('producCreditoID');
				consultaCreditosGrupo();
				
				$('tr[name=renglon]').each(function() {
					var numero= this.id.substr(7,this.id.length);
				
					var jqTdCargo= eval("'#tdCargo" + numero + "'");
					var jqCargoIntegra= eval("'#cargoIntegra" + numero + "'");
					var jqCargo="";
					
					$(jqTdCargo).append('<select id="cargo'+ numero +'"'+' name="lcargo" onchange="validaCargo(this.id);validaSolicitud(this.id);" tabindex="2" >'
							+'<option value="0">SELECCIONAR</option>'
							+'<option value="1">PRESIDENTE</option>'
							+'<option value="2">TESORERO</option>'
							+'<option value="3">SECRETARIO</option>'
							+'<option value="4">INTEGRANTE</option>'
							+'</select>');
					
					jqCargo= eval("'#cargo" + numero + "'");
					$(jqCargo).val($(jqCargoIntegra).val()).selected=true;

			});
					consultaIntegrantesFila();
					seleccionaCargo(this.id);
			}else  {;
				$('#integrantesGrupo').html("");
				$('#integrantesGrupo').hide();
			}			
		}); 
	}  	
  	
}); //FIN DE DOCUMENT

	//Funcion para validar que no se repita el puesto de integrantes
	function validaCargo(control){
		var jqEstatus = $('#estatusGrupo').val();
		var jqControl= eval("'#" + control + "'");
			$('tr[name=renglon]').each(function() {
				var numero= this.id.substr(7,this.id.length);
				var jqCargo= eval("'#cargo" + numero + "'");				
				var numCargo=$(jqCargo).asNumber();
				var numFilas= consultaFilas();
				
				if($(jqCargo).val()==$(jqControl).val() && jqControl != jqCargo){
					
					if(jqEstatus=='A' && numCargo=='1'){
						mensajeSis("Solo Puede Existir un Presidente en el Grupo.");
						$(jqControl).val('0').selected;
					}
					else if(jqEstatus=='A' && numCargo=='2'){
						mensajeSis("Solo Puede Existir un Tesorero en el Grupo.");
						$(jqControl).val('0').selected;
					}
					else if(jqEstatus=='A' && numCargo=='3'){
						mensajeSis("Solo Puede Existir un Secretario en el Grupo.");
						$(jqControl).val('0').selected;
					}
					else if(jqEstatus=='C' && numCargo=='1'){
						mensajeSis("Solo Puede Existir un Presidente en el Grupo.");
						$(jqControl).val('0').selected;
					}
					else if(jqEstatus=='C' && numCargo=='2'){
						mensajeSis("Solo Puede Existir un Tesorero en el Grupo.");
						$(jqControl).val('0').selected;
					}
					else if(jqEstatus=='C' && numCargo=='3'){
						mensajeSis("Solo Puede Existir un Secretario en el Grupo.");
						$(jqControl).val('0').selected;
					}
				}
				if(numFilas=='1' && jqEstatus=='C' && numCargo!='1'){
					mensajeSis("El Puesto Debe ser Presidente.");
					$(jqControl).val('1');
				}
				else if(numFilas=='2' && numCargo=='3' && jqEstatus=='C'){
					if($(jqControl).asNumber()==numCargo){
					mensajeSis("El Puesto no Puede ser Secretario");
					$(jqControl).val('0').selected;
					}
				}
				else if(numFilas=='2' && numCargo=='4' && jqEstatus=='C'){
					mensajeSis("El Puesto no Puede ser Integrante.");
					$(jqControl).val('0').selected;
				}else if(numFilas=='3' && numCargo=='4' && jqEstatus=='C'){
					if($(jqControl).asNumber()==numCargo){
						mensajeSis("El Puesto no Puede ser Integrante.");
						$(jqControl).val('0').selected;
						
					}
				}
		});
	}
	
	
	//Funcion para validar solicitudes canceladas o rechazadas
	function validaSolicitud(control){
		var jqControl= eval("'#" + control + "'");
			$('tr[name=renglon]').each(function() {
				var numero= this.id.substr(7,this.id.length);
				var jqSolicitud= eval("'#estatusSolicitud" + numero + "'");			
				var estatusSolicitud = $(jqSolicitud).val();
				var jqCargo= eval("'#cargo" + numero + "'");	

				if(estatusSolicitud=='C' && jqControl == jqCargo){
					if($(jqCargo).val()=='1' || $(jqCargo).val()=='2' || $(jqCargo).val()=='3'){
						mensajeSis("La Solicitud está Cancelada, el Puesto debe de ser Integrante.");
						$(jqCargo).val('4').selected;
					}
				}
				if(estatusSolicitud=='R' && jqControl == jqCargo){
					if($(jqCargo).val()=='1' || $(jqCargo).val()=='2' || $(jqCargo).val()=='3'){
						mensajeSis("La Solicitud está Rechazada, el Puesto debe de ser Integrante.");
						$(jqCargo).val('4').selected;
						
					}
				}
		});
	}
	
	/*Funcion para validar solicitudes canceladas o rechazadas
	  al actualizar el cambio de puestos */
	function validaSolicitudTransaccion(){
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqSolicitud= eval("'#estatusSolicitud" + numero + "'");			
			var estatusSolicitud = $(jqSolicitud).val();
			var jqCargo= eval("'#cargo" + numero + "'");	

			switch(estatusSolicitud){
			case 'C':
				if($(jqCargo).val()=='1' || $(jqCargo).val()=='2' || $(jqCargo).val()=='3'){
					mensajeSis("La Solicitud está Cancelada, el Puesto debe de ser Integrante.");
					$(jqCargo).val('4').selected;
					$(jqCargo).focus();
					event.preventDefault();
					return false;
				}
				break;
			case 'R':
				if($(jqCargo).val()=='1' || $(jqCargo).val()=='2' || $(jqCargo).val()=='3'){
					mensajeSis("La Solicitud está Rechazada, el Puesto debe de ser Integrante.");
					$(jqCargo).val('4').selected;
					$(jqCargo).focus();
					event.preventDefault();
					return false;
				}
					break;
					default:
					return true;
			}
		});
	}

	
	function validaCreditoTransaccion(){
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqEstCredito= eval("'#estatusCre" + numero + "'");	
			var estatusCredito = $(jqEstCredito).val();
			var jqCargo= eval("'#cargo" + numero + "'");	

			switch(estatusCredito){
			case 'P':
				if($(jqCargo).val()=='1' || $(jqCargo).val()=='2' || $(jqCargo).val()=='3'){
					mensajeSis("El Crédito está Pagado, el Puesto debe de ser Integrante.");
					$(jqCargo).val('4').selected;
					$(jqCargo).focus();
					event.preventDefault();
					return false;
				}
				break;
			case 'K':
				if($(jqCargo).val()=='1' || $(jqCargo).val()=='2' || $(jqCargo).val()=='3'){
					mensajeSis("El Crédito está Castigado, el Puesto debe de ser Integrante.");
					$(jqCargo).val('4').selected;
					$(jqCargo).focus();
					event.preventDefault();
					return false;
				}
					break;
					default:
					return true;
			}
		});
	}

	
	//Funcion para validar creditos Pagados y Castigados
	function validaCreditoCastigadoPagado(){
		var numFilas= consultaFilas();
		var contador=0;
		var contadorPagado=0;
			$('tr[name=renglon]').each(function() {
				var numero= this.id.substr(7,this.id.length);
				var jqEstCredito= eval("'#estatusCre" + numero + "'");	
				var estatusCredito = $(jqEstCredito).val();
				if(estatusCredito=='K'){
					contador++;
				}

				if(estatusCredito=='P'){
					contadorPagado++;
				}
				
				if(numFilas==contador){	
					mensajeSis("No se Permite Cambios de Puestos a Créditos Castigados.");	
					event.preventDefault();
					return false;
					}
				else
					
				if(numFilas==contadorPagado){	
					mensajeSis("No se Permite Cambios de Puestos a Créditos Pagados.");	
					event.preventDefault();
					return false;
					}
				
				else
					if(contador + contadorPagado==numFilas){
					mensajeSis("No se Permite Cambios de Puestos a Créditos Pagados y Castigados.");	
					event.preventDefault();
					return false;
					
				   }
		        });
			}

	// Consulta total de filas integrantes
	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;	
		});
		return totales;
	}

	 //Funcion para seleccionar cargo
	 function seleccionaCargo(control){
	 		$('select[name=cargo]').each(function() {
	 	});
	 		$('#cargo1').focus();
			$('#cargo1').select();
	 }
	 
	 //Funcion para consultar los creditos del grupo
	function consultaCreditosGrupo() {
		montoToCre =  0.0;
		montoTot = 0.0;
		var monConv=0;
		var numReg = $('input[name=consecutivo]').length;
		if(numReg <1){
			deshabilitaBoton('actualizar', 'submit');
			deshabilitaBoton('generar', 'submit');
		 	deshabilitaBoton('contratoAdhesion', 'submit');
		 	deshabilitaBoton('planPago', 'submit');
		}
		
		validaMoneda();
		for(var i = 1; i <= numReg; i++){
			var cred = "credito"+i;	
			esTab= true;

			consultaCredito(cred);
			var idMonto = "montoCredito"+i;	
			var jqMonto  = eval("'#" + idMonto + "'");
			var montoCre = $(jqMonto).asNumber();
			monConv = parseFloat(montoCre);
			montoTot = montoTot+montoCre;
			$(jqMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					
		}		
			
	}
		
	 //Funcion para validar la moneda y total de credito grupal
	 function validaMoneda(){		
			$('tr[name=renglon]').each(function() {
				var numero= this.id.substr(7,this.id.length);
				var jQMonto = eval("'#montoCredito" + numero + "'");	
				if($('#credito'+numero).val()!=''){
					creditoContrato = $('#credito'+numero).val();
				}
				var montoCre = $(jQMonto).asNumber();
				montoTotalCreditoContrato = montoTotalCreditoContrato + montoCre;
			});
			var creditoBeanCon = {
					'creditoID'	:creditoContrato
				};
			if(creditoContrato != '' && !isNaN(creditoContrato)){
				creditosServicio.consulta(1, creditoBeanCon,function(creditos) {
					if(creditos!=null){
						monedaContrato =creditos.monedaID;						
					} 					
				});
			}	
		}
	 
	 //Funcion para consultar los creditos
		function consultaCredito(idControl) {
			var jqCredito  = eval("'#" + idControl + "'");
			var credito = $(jqCredito).val();
			var conPrincipal=1;	 
			var creditoBeanCon = {
				'creditoID'	:credito
			};
			setTimeout("$('#cajaLista').hide();", 200);
			if(credito != '' && !isNaN(credito) && esTab){
				creditosServicio.consulta(conPrincipal, creditoBeanCon,function(creditos) {
						if(creditos!=null){
							$('#fechaMinistrado').val(creditos.fechaMinistrado);
						}
				});										
															
			}
		}

		//Funcion para imprimir pagare, contrato y plan de pago
		function validaImpresion(control){
			var numFilas= consultaFilas();
				$('tr[name=renglon]').each(function() {
					var numero= this.id.substr(7,this.id.length);
					var jqEstCredito= eval("'#estatusCre" + numero + "'");	
					var jqEstatusCredito= eval("'#estatusCredito" + numero + "'");	
					var jqEstPagare= eval("'#estatusPagare" + numero + "'");	
					var jqCredito= eval("'#credito" + numero + "'");	
					var estatusCredito = $(jqEstCredito).val();
					var estatusPagare = $(jqEstPagare).val();
					var numCredito=$(jqCredito).asNumber();
					if ($(jqEstatusCredito).val()=="0"){
						$(jqEstatusCredito).val("");
					}
					if(numCredito!='' && estatusPagare=='S' && ( estatusCredito=='V' || estatusCredito=='B' 
										|| estatusCredito=='A' || estatusCredito=='I' || estatusCredito=='P') ){
							existeCredito = true;
						}
					if(existeCredito==true && numFilas==numero){
						var jQmensaje = eval("'#ligaCerrar'");
							if($(jQmensaje).length > 0) { 
							mensajeAlert=setInterval(function() { 
								if($(jQmensaje).is(':hidden')) { 	
									$('#tdGenerar').show();
									$('#tdContrato').show();
									$('#tdPlan').show();
									deshabilitaBoton('actualizar', 'submit');
									habilitaBoton('generar', 'submit');  
									habilitaBoton('contratoAdhesion', 'submit');
									habilitaBoton('planPago', 'submit');
									clearInterval(mensajeAlert); 
									$('#generar').select();
									$('#generar').focus();
									mensajeSis("No Olvide Llevar a Cabo la Reimpresión de Pagaré, Contrato y Plan de Pagos.");					
								}
					            }, 1);
							}

					}
					else {
						if(numFilas==numero){
						$('#grupoID').focus();
						$('#tdGenerar').hide();
						$('#tdContrato').hide();
						$('#tdPlan').hide();
						deshabilitaBoton('actualizar', 'submit');
						deshabilitaBoton('generar', 'submit');
						deshabilitaBoton('contratoAdhesion', 'submit');
						deshabilitaBoton('planPago', 'submit');
						}
							 
					}
			});	
		}
		
		
		/*Funcion que valida los cargos de los integrantes
		   de los grupos abiertos y cerrados */
		function validaCargos(){			
			var jqEstatus = $('#estatusGrupo').val();
			var mensaje="";
			var numFilas= 0;
			var presidente= 0;
			var tesorero= 0;
			var secretario=0;
			var integrante=0;
			var vacio=0;
			var presidenteRepetido='';
			var tesoreroRepetido='';
			var secretarioRepetido='';
			var jqControlFoco= '';
			var vacioRepetido='';
			
			$('tr[name=renglon]').each(function() {
				numFilas = cuentaIntegrantesValidos();
				var numero= this.id.substr(7,this.id.length);
				var jqCargo= eval("'#cargo" + numero + "'");				
				var numCargo=$(jqCargo).asNumber();
				var valorCargo = $(jqCargo).val();
				
				if(numCargo==1){
					presidente ++;
					presidenteRepetido=numero;
				}
				if(numCargo==2){
					tesorero ++;
					tesoreroRepetido=numero;
				}
				if(numCargo==3){
					secretario ++;
					secretarioRepetido=numero;
				}
				if(numCargo==4){
					integrante ++;
				}

				if(valorCargo==0){
					vacio ++;
					vacioRepetido=numero;
				}
				if(jqEstatus=='A'){
					if(numFilas==numero){
						if (parseInt(presidente)>1){
							mensaje="Solo Puede Haber un Presidente.";
							jqControlFoco=eval("'#cargo" + presidenteRepetido + "'");
							$(jqControlFoco).focus();
						}
						else{
							if (parseInt(tesorero)>1){
								mensaje="Solo Puede Haber un Tesorero.";
								jqControlFoco=eval("'#cargo" + tesoreroRepetido + "'");
								$(jqControlFoco).focus();
							}
							else{
								if (parseInt(secretario)>1){
									mensaje="Solo Puede Haber un Secretario.";
									jqControlFoco=eval("'#cargo" + secretarioRepetido + "'");
									$(jqControlFoco).focus();
								}
								else{
									if(vacio>=1){
										mensaje="Seleccione un Cargo.";
										jqControlFoco=eval("'#cargo" + vacioRepetido + "'");
										$(jqControlFoco).focus();
									}
									
									else{
										mensaje="";
									}

								}
								
							}
							
						}
					}
				}
				else{
					if(jqEstatus=='C'){
						if(numFilas>=3){
							if(parseInt(presidente)<1){
								mensaje="Seleccione un Presidente.";
							}
							else {
								if(parseInt(tesorero)<1){
								   mensaje="Seleccione un Tesorero.";
								}
								else{
									if(parseInt(secretario)<1){
										mensaje="Seleccione un Secretario.";
									}
										else{
											mensaje="";
										
									}
								}
							}
						}
						else{
							if(numFilas==1){
								if(parseInt(presidente)<1){
									mensaje="El Puesto debe de ser Presidente.";
								}
								else{
									mensaje="";
								}
							}
							else{	
							if(numFilas==2){
								if(parseInt(presidente)<1 || parseInt(tesorero)<1){
									mensaje="El Puesto debe de ser Presidente o Tesorero.";
								}
								else{
									mensaje="";
								}
							}
						}
					}
				}
				
			}
		}
		
	 );  
	 return mensaje;
	}
		
	//Funcion para Consultar si el grupo tiene integrantes registrados
	function consultaIntegrantesFila(){
		var numFilas= consultaFilas();
			if(numFilas==0){
				mensajeSis("El Grupo no Tiene Integrantes Registrados.");
				limpiaFormulario();
				$('#grupoID').focus();
				$('#grupoID').val('');
			
		}
	}	


	// Consulta total de integrantes validos
	function cuentaIntegrantesValidos(){
		var totales=0;
		var councre=0;
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqEstatusSolicitud= eval("'#estatusSolicitud" + numero + "'");	
			var jqEstCredito= eval("'#estatusCre" + numero + "'");	
			if (($(jqEstatusSolicitud).val() == 'C' || $(jqEstatusSolicitud).val() == 'R')
				|| ($(jqEstCredito).val() == 'K' || $(jqEstCredito).val() == 'P')){
				councre++;
			}else{
				totales++;
			}
		});
		return totales;
	}

	/* Funcion  para limpiar todos los campos del formulario */
	function limpiaFormulario() {
		$('#nombreGrupo').val("");
		$('#producCreditoID').val("");
		$('#descripProducto').val("");
		$('#ciclo').val("");
		$('#estatus').val("");
		$('#fechaRegistro').val("");
		deshabilitaBoton('actualizar', 'submit');
		$('#integrantesGrupo').html("");
		$('#integrantesGrupo').hide();
		$('#tdGenerar').hide();
		$('#tdContrato').hide();
		$('#tdPlan').hide();
	}
	
	/* Funcion de exito de actualizacion de puestos */
	function exitoCambioPuestoGrupo() {
	}
	
	/* Funcion de error de actualizacion de puestos */
	function errorCambioPuestoGrupo() {
		$('#grupoID').select();
		$('#grupoID').focus();

	}
	
	