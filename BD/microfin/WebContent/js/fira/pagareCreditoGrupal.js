	
var catEstatusCredito = {
		'autorizado':'A',
  		'inactivo':'I',	
  		'procesado':'M',	
};
var CattipoOpera = {
	'Global' : 'G',
	'Formal': 'F'
};
var montoTot = 0.0;
var prorrateoPago;
var modicarPrepago;
var permitePrepago;
var monedaContrato=0;
var creditoContrato='';
var montoTotalCreditoContrato=0;
var imprimeFormatosInd='S';
$(document).ready(function() {
	esTab = true;

	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	agregaFormatoControles('formaGenerica');
	inicializaForma('formaGenerica','grupoID' );

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});		
	
	//Definicion de Constantes y Enums  
	var catTipoConCreditoGrup = {
		'principal':1,
  		'foranea':2,	
  	};	
		
	var catTipoTranCreditoGrup = {
  		'pagareGrupal':36
  	};

  	var catTipoActCreditoGrup = {
  		'grabarPagare':1
  	};
  
	var catNombreCortoInst = {
		'SANA': 'STF'	
	} ;
	
	var parametroBean = consultaParametrosSession();
	var nombreInstitucion;
	
	//------------ Metodos y Manejo de Eventos ---------------------------------------
	$('#imprimir').hide();
	deshabilitaBoton('grabar', 'submit');
 	deshabilitaBoton('generar', 'submit');
 	/*deshabilitaBoton('caratulaContrato', 'submit');*/
 	deshabilitaBoton('contratoAdhesion', 'submit');
 	deshabilitaBoton('obligaCreditoGrupal', 'submit');
 	deshabilitaBoton('planPago', 'submit');
 	agregaFormatoControles('formaGenerica');
    $('#grupoID').focus();
	

	$.validator.setDefaults({
			submitHandler: function(event) { 	
				       	
		       	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','grupoID','exito','fallo');
	   		}
		});					

	$('#grabar').click(function() {	
		$('#tipoTransaccion').val(catTipoTranCreditoGrup.pagareGrupal);
		$('#tipoActualizacion').val(catTipoActCreditoGrup.grabarPagare);		
	});
	
	
	$('#grupoID').blur(function() {
		if(esTab){
			if($('#grupoID').val()!=""){
				validaGrupo(this.id);		
			}else{
				
				inicializaForma('formaGenerica','grupoID' );
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('autorizar', 'submit');
				deshabilitaBoton('generar', 'submit');	
			 	deshabilitaBoton('contratoAdhesion', 'submit');
			 	deshabilitaBoton('obligaCreditoGrupal', 'submit');
			 	deshabilitaBoton('planPago', 'submit');
				$('#Integrantes').html('');
				$('#nombreProducto').val('');
				$('#cicloActual').val('');
				$('#nombreGrupo').val('');
				$('#grupoID').val('');
				$('#grupoID').focus();
				$('#grupoID').select();
			}
			consultaParamImpresion();
		}
		
	});
	
	
	 $('#grupoID').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	camposLista[0] = "nombreGrupo";
		    	parametrosLista[0] = $('#grupoID').val();
		 listaAlfanumerica('grupoID', '1', '5', camposLista, parametrosLista, 'listaGruposCredito.htm'); }
	 });
	
	var creditoImprimir = "";

	$('#generar').click(function() {
		var numReg = $('input[name=consecutivoID]').length;	
		
		for(var i = 1; i <= numReg; i++){
			var credito = "solicitudCre"+i; 
			var jqCredito  = eval("'#" + credito + "'");
			creditoImprimir = $(jqCredito).val();
			var mc ="";
			var tb = "";
			var ci = "";
			var mon = "";
			var tt= 36;
			var ta= 2;
			var mont ="";
			var noCredito="";
			var numeroUsuario =parametroBean.numeroUsuario;
			var creditoBeanCon = {
				'creditoID'	:creditoImprimir
			};
			

			if(imprimeFormatosInd == 'S'){
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
							mont =	 mc.replace (/,/g,"");
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
							var enlace = ('pagareCreditoGrupalAgro.htm?calcInteresID='+ci+'&montoCredito='+mont+'&tasaBase='+tb+'&creditoID='+noCredito+
							 	'&tipoTransaccion='+tt+'&tipoActualizacion='+ta+'&monedaID='+mon+'&usuario='+numeroUsuario+'&nombreInstitucion='+nombreInstitucion+
							 	'&producCreditoID='+$('#reca').val()+'&sucursal='+sucursal+'&gerenteSucursal='+gerente
								+'&direccionInstit='+dirInst+'&RFCInstit='+RFCInst+'&telefonoInst='+telInst+'&fechaSistema='+fechaEmision+"&grupoID="+$('#grupoID').val());	
							window.open(enlace);
						}			
					});
				}	
			}
			if(i == numReg){ 

				var Moned='1';   
				var grupo =$('#grupoID').val();
				var tipoRepGrupal=4;
				var numeroUsuario = parametroBean.numeroUsuario;
				var montoToCre  = eval("'" + montoTot + "'");
				nombreInstitucion =  parametroBean.nombreInstitucion.toUpperCase();
				var tipoActPagGrupal=10;
				var tipoTrans=8;
					var enlace = ('pagareCreditoGrupalAgro.htm?calcInteresID=0&montoCredito='+montoToCre+'&tasaBase=0&creditoID='+grupo+
					'&tipoTransaccion='+tipoTrans+'&tipoActualizacion='+tipoActPagGrupal+'&monedaID='+Moned+'&tipoReporte='+tipoRepGrupal+'&usuario='+numeroUsuario+
					'&nombreInstitucion='+nombreInstitucion+'&producCreditoID='+$('#reca').val()+"&grupoID="+$('#grupoID').val());	
					 	window.open(enlace);
				}
	
		}
	});
	
	$('#obligaCreditoGrupal').click(function() {	
		var ci = 7;

		var nombreInstitucion =  parametroBean.nombreInstitucion;
	    var numeroUsuario = parametroBean.numeroUsuario; 
		var pagina='pagareCreditoGrupalAgro.htm?calcInteresID='+ci+
        '&nombreInstitucion='+nombreInstitucion;
		window.open(pagina,'_blank');
	});
	
	$('#contratoAdhesion').click(function() {			
		generaLiga();
	});
	
	

		function generaLiga() {
		var grupo = $('#grupoID').val();
		var numeroUsuario = parametroBean.numeroUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var dirInst = parametroBean.direccionInstitucion;
		var RFCInst = parametroBean.rfcInst;
		var telInst = parametroBean.telefonoLocal;
		var fechaEmision = parametroBean.fechaSucursal;
		var representante = parametroBean.representanteLegal;
		var ci = '5';

		$('#ligaGenerar').attr('href', 'pagareCreditoGrupalAgro.htm?calcInteresID=' + ci + '&grupoID=' + grupo + '&monedaID=' + monedaContrato + '&montoCredito=' + montoTotalCreditoContrato + '&nombreInstitucion=' + nombreInstitucion + '&usuario=' + numeroUsuario + '&producCreditoID=' + $('#reca').val() + '&direccionInstit=' + dirInst + '&RFCInstit=' + RFCInst + '&telefonoInst=' + telInst + '&fechaSistema=' + fechaEmision + '&representanteLegal=' + representante);
	}	
	
	


		$('#caratulaContrato').click(function() {
		var grupo = $('#grupoID').val();
		var numeroUsuario = parametroBean.numeroUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var ci = '6';
		var moneda = 0;
		var credito = '';
		var montoTotalCredito = 0.0;
		$('tr[name=renglon]').each(function() {
			var numero = this.id.substr(7, this.id.length);
			credito = $('#solicitudCre' + numero).val();

		});

		$('input[name=monto]').each(function() {
			var jQMonto = eval("'#" + this.id + "'");
			var montoCre = $(jQMonto).asNumber();
			montoTotalCredito = montoTotalCredito + montoCre;
		});

		var creditoBeanCon = {
			'creditoID' : credito
		};

		if (credito != '' && !isNaN(credito)) {
			creditosServicio.consulta(catTipoConCreditoGrup.principal, creditoBeanCon, function(creditos) {
				if (creditos != null) {
					moneda = creditos.monedaID;

					var pagina = 'pagareCreditoGrupalAgro.htm?calcInteresID=' + ci + '&grupoID=' + grupo + '&monedaID=' + moneda + '&montoCredito=' + montoTotalCredito + '&nombreInstitucion=' + nombreInstitucion + '&usuario=' + numeroUsuario;
					window.open(pagina, '_blank');

				}
			});
		}
	});
	
	$('#planPago').click(function() {	
		var grupo = $('#grupoID').val();
		var fechaDes = $('#fechaMinistrado').val();
		var producto = $('#nombreProducto').val();
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var ci = '6'; 
		var moneda=0;
		var credito = '';
		var montoTotalCredito = 0.0;
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			credito = $('#solicitudCre'+numero).val();
		});
		
		
		$('input[name=monto]').each(function() {	
			var jQMonto = eval("'#" + this.id + "'");		
			var montoCre = $(jQMonto).asNumber();
			montoTotalCredito = montoTotalCredito + montoCre;
		});
		
		var creditoBeanCon = {
				'creditoID'	:credito
			};
		
		if(credito != '' && !isNaN(credito) && tipoOperacion != CattipoOpera.Global){
			creditosServicio.consulta(catTipoConCreditoGrup.principal, creditoBeanCon,function(creditos) {
				if(creditos!=null){
					moneda =creditos.monedaID;
					/*noCredito = creditos.creditoID;
					 mc =creditos.montoCredito;
					 tb = creditos.tasaBase;
					 ci = creditos.calcInteresID; 
					 mon =creditos.monedaID;
					 mont =	 mc.replace (/,/,"");*/
					nombreInstitucion=parametroBean.nombreInstitucion;
					var pagina='repPlanDePagosGrupal.htm?grupoID='+grupo+'&montoCredito='+montoTotalCredito+
					                            '&fechaMinistrado='+fechaDes+'&nombreProducto='+producto+'&nombreInstitucion='+nombreInstitucion;
				    window.open(pagina,'_blank');;	
				}
			});
		}

		if(imprimeFormatosInd == 'S'){
			$('tr[name=renglon]').each(function() {
				var id= this.id.substr(7,this.id.length);
				var clienteID = $('#clienteID'+id).val();
				var montoCredito = $('#monto'+id).val();
				var creditoID =$('#solicitudCre'+id).val();
				nombreInstitucion=parametroBean.nombreInstitucion;
				var pagina='repPlanPagosIndividual.htm?grupoID='+grupo+'&creditoID='+creditoID+'&clienteID='+clienteID+
				'&montoCredito='+montoCredito+'&fechaMinistrado='+fechaDes+'&nombreProducto='+producto+'&nombreInstitucion='+nombreInstitucion;
	            window.open(pagina,'_blank');
	
			});
		}
	});
	
	$('#imprimir').click(function() {			
});  




	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			grupoID:{ 
				required: true
				},
			fechaMinistrado:{
				required: true,
				date: true
			}
				
		},
		
		messages: {
			grupoID: {
				required:'Especifique N??mero de Grupo'
					},
			fechaMinistrado: {
				required:'Especifique Fecha',
				date:'Fecha Incorrecta'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	function validaGrupo(idControl){
		monedaContrato=0;
		creditoContrato='';
		montoTotalCreditoContrato=0;
		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		//$('#Integrantes').html("");
		var grupoBeanCon = { 
  		'grupoID':grupo
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		inicializaForma('formaGenerica','grupoID' );
		if(grupo != '' && !isNaN(grupo) && esTab){
		//	$('#Integrantes').html('');
			gruposCreditoServicio.consulta(15,grupoBeanCon,function(grupos) {
			if(grupos!=null){ 
				esTab=true;  
				$('#cicloActual').val(grupos.cicloActual);
				if(grupos.estatusCiclo != 'C' ){
					inicializaForma('formaGenerica','grupoID' );
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('autorizar', 'submit');
					deshabilitaBoton('generar', 'submit');	
				 	deshabilitaBoton('caratulaContrato', 'submit');
				 	deshabilitaBoton('contratoAdhesion', 'submit');
				 	deshabilitaBoton('obligaCreditoGrupal', 'submit');
				 	deshabilitaBoton('planPago', 'submit');
					mensajeSis("El Ciclo Debe Estar Cerrado");
					$('#Integrantes').html('');
					$('#nombreProducto').val('');
					$('#cicloActual').val('');
					$('#nombreGrupo').val('');
					$('#grupoID').val('');
					$('#grupoID').focus();
					$('#grupoID').select();
				} else{
					$('#nombreGrupo').val(grupos.nombreGrupo);								
					consultaIntegrantesGrid();				
					
			 	}
				

			}else{ 
				mensajeSis("El Grupo No Existe");
				inicializaForma('formaGenerica','grupoID' );
				$('#Integrantes').html('');
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('autorizar', 'submit');
				deshabilitaBoton('generar', 'submit');	
			 	deshabilitaBoton('caratulaContrato', 'submit');
			 	deshabilitaBoton('contratoAdhesion', 'submit');
			 	deshabilitaBoton('obligaCreditoGrupal', 'submit');
			 	deshabilitaBoton('planPago', 'submit');
			 	$('#Integrantes').html('');
				$('#nombreProducto').val('');
				$('#cicloActual').val('');
				$('#nombreGrupo').val('');
				$('#grupoID').val('');
				$('#grupoID').focus();
				$('#grupoID').select();						
				}
			});	
			
		}
   }
			

	
	function consultaIntegrantesGrid(){
		$('#Integrantes').html('');
		var params = {};		
	
		params['tipoLista'] = 3;
		params['grupoID'] = $('#grupoID').val();
			
			
		$.post("integrantesGpoAutorCredGridVista.htm", params, function(data){
			
			if(data.length >0) { 
				var fecIn = $('#fechaInicio').val(); 
				$('#Integrantes').html(data); 
				$('#Integrantes').show();
				var productCred = $('#productoCreditoID').val();
				$('#producCreditoID').val(productCred);
				consultaProducCredito('producCreditoID');	
				consultaCreditosGrupo();

			}else{
				$('#Integrantes').html("");
				$('#Integrantes').show();
			}			
		}); 
	}
	

function consultaProducCredito(idControl) {  
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();
		var contador = $('#contador').val();
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		var linea =$('#lineaCreditoID').val();
		 

			if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
				productosCreditoServicio.consulta(1,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){
						$('#nombreProducto').val(prodCred.descripcion);
						$('#reca').val(prodCred.registroRECA);

						prorrateoPago=prodCred.prorrateoPago;
						permitePrepago=prodCred.permitePrepago;
						modificarPrepago=prodCred.modificarPrepago;
								
					}else{							
						mensajeSis("No Existe el Producto de Cr??dito");
						$('#producCreditoID').focus();
						$('#producCreditoID').select();																					
					}
				});
			}				 					
	}
	

	
	
});

// consulta la lista de integrantes del grupo
function consultaIntegrantesGrid(){
		$('#Integrantes').html('');
		var params = {};		
	
		params['tipoLista'] = 3;
		params['grupoID'] = $('#grupoID').val();
			
			
		$.post("integrantesGpoAutorCredGridVista.htm", params, function(data){
			
			if(data.length >0) { 
				var fecIn = $('#fechaInicio').val(); 
				$('#Integrantes').html(data); 
				$('#Integrantes').show();
				var productCred = $('#productoCreditoID').val();
				$('#producCreditoID').val(productCred);
				consultaProducCredito('producCreditoID');	
				consultaCreditosGrupo();

			}else{
				$('#Integrantes').html("");
				$('#Integrantes').show();
			}			
		}); 
	}
	
// consulta producto de credito
function consultaProducCredito(idControl) {  
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		var linea =$('#lineaCreditoID').val();
		var conForanea=2; 

			if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
				productosCreditoServicio.consulta(conForanea,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){
						$('#nombreProducto').val(prodCred.descripcion);
						$('#reca').val(prodCred.registroRECA);
					}else{							
						mensajeSis("No Existe el Producto de Cr??dito");
						$('#producCreditoID').focus();
						$('#producCreditoID').select();																					
					}
				});
			}				 					
	}
	
	function consultaCreditosGrupo() {
		montoToCre =  0.0;
		montoTot = 0.0;
		
		var numReg = $('input[name=consecutivoID]').length;
		if(numReg <1){
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('generar', 'submit');	
		 	/*deshabilitaBoton('caratulaContrato', 'submit');*/
		 	deshabilitaBoton('contratoAdhesion', 'submit');
		 	deshabilitaBoton('obligaCreditoGrupal', 'submit');
		 	deshabilitaBoton('planPago', 'submit');
		}
		validaMoneda();
		for(var i = 1; i <= numReg; i++){
			var credito = "solicitudCre"+i;	
			esTab= true;

			consultaCredito(credito);
			var idMonto = "monto"+i;	
			var jqMonto  = eval("'#" + idMonto + "'");
			var montoCre = $(jqMonto).val();
			var monConv = parseFloat(montoCre);
			montoTot = montoTot+monConv;
			$(jqMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			
			var numRe = $('input[name=consecutivoID]').length;
		
		}		
			
	}
	
	function validaMoneda(){		
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			creditoContrato = $('#solicitudCre'+numero).val();
			
			var jQMonto = eval("'#monto" + numero + "'");		
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
						if(prorrateoPago == 'N')
							if(permitePrepago =='S')
								if(modificarPrepago =='S'){
										seleccionaValor();
										$('#formaPago').val('S');				
										$('#lbltipoPrepago').show();
										
									}else{
									$('#lbltipoPrepago').hide();
									$('#formaPago').val('N');
									}
							else{
								$('#lbltipoPrepago').hide();
								$('#formaPago').val('N');
								}
						else{
							$('#lbltipoPrepago').hide();
							$('#formaPago').val('N');
							}


						if(creditos.estatus != catEstatusCredito.autorizado &&
						   creditos.estatus != catEstatusCredito.inactivo&&
						   creditos.estatus != catEstatusCredito.procesado){
							deshabilitaBoton('grabar', 'submit');		
							deshabilitaBoton('generar', 'submit');	
						 	/*deshabilitaBoton('caratulaContrato', 'submit');*/
						 	deshabilitaBoton('contratoAdhesion', 'submit');
						 	deshabilitaBoton('obligaCreditoGrupal', 'submit');
						 	deshabilitaBoton('planPago', 'submit');
							deshabilitaTipoPrepago();
							
						}else{
							habilitaBoton('grabar', 'submit');
							habilitaBoton('generar', 'submit');		
						 	/*habilitaBoton('caratulaContrato', 'submit');*/
						 	habilitaBoton('contratoAdhesion', 'submit');
						 	habilitaBoton('obligaCreditoGrupal', 'submit');
						 	habilitaBoton('planPago', 'submit');
							}
						if(creditos.fechaMinistrado == '1900-01-01'){
							deshabilitaBoton('generar', 'submit');	
						 	/*deshabilitaBoton('caratulaContrato', 'submit');*/
						 	deshabilitaBoton('contratoAdhesion', 'submit');
						 	deshabilitaBoton('obligaCreditoGrupal', 'submit');
						 	deshabilitaBoton('planPago', 'submit');
							$('#fechaMinistrado').val(parametroBean.fechaAplicacion);				
						}else{
							habilitaBoton('generar', 'submit');
							/*habilitaBoton('caratulaContrato', 'submit');*/
						 	habilitaBoton('contratoAdhesion', 'submit');
						 	habilitaBoton('obligaCreditoGrupal', 'submit');
						 	habilitaBoton('planPago', 'submit');
							$('#fechaMinistrado').val(creditos.fechaMinistrado);		
						}
						
					}else{ 
						mensajeSis("El Cr??dito No Existe");
						$(jqCredito).focus();
						deshabilitaBoton('grabar', 'submit');	
						deshabilitaBoton('generar', 'submit');	
					 	/*deshabilitaBoton('caratulaContrato', 'submit');*/
					 	deshabilitaBoton('contratoAdhesion', 'submit');
					 	deshabilitaBoton('obligaCreditoGrupal', 'submit');
					 	deshabilitaBoton('planPago', 'submit');
						$(jqCredito).select();									
					}
			});										
														
		}
	}

function seleccionaValor (){	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			
			var jsPrepagos = eval("'prepagos" + numero+ "'");	
			var valorPrepagos= document.getElementById(jsPrepagos).value;	
			$('#tipoPrepago'+numero+' option[value='+ valorPrepagos +']').attr('selected','true');	
			
		});
		
	}
function deshabilitaTipoPrepago(){
$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);		
			deshabilitaControl('tipoPrepago'+numero);
			});
		
}
// funcion a ejecutar despues de transaccion exitosa
function exito(){
	deshabilitaBoton('grabar', 'submit');
	habilitaBoton('generar', 'submit');
 	habilitaBoton('contratoAdhesion', 'submit');
 	habilitaBoton('planPago', 'submit');
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('Integrantes');
}

// funcion a ejecutar despues de transaccion con error
function fallo(){
	habilitaBoton('grabar', 'submit');
	deshabilitaBoton('generar', 'submit');
 	deshabilitaBoton('contratoAdhesion', 'submit');
 	deshabilitaBoton('obligaCreditoGrupal', 'submit');
 	deshabilitaBoton('planPago', 'submit');
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('Integrantes');
}

	
function consultaParamImpresion() {
	var numConsulta = 1;
	var paramBean = {
		'empresaID' : 1
	};
	parametrosSisServicio.consulta(numConsulta, paramBean, function(parametrosBean) {
		if (parametrosBean != null) {
				imprimeFormatosInd = parametrosBean.impFomatosInd;
		}
	});
}