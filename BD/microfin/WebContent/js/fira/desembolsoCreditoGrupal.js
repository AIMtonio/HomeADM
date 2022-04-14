var prorrateoPago;
var modicarPrepago;
var permitePrepago;
var	requiereValidaCredito="N";
var cantidadProcesados = 0;
$(document).ready(function() {
		esTab = true;
	consultaReqValidaCred();
	 
	//Definicion de Constantes y Enums  
	var catTipoConCreditoGrup = {
  		'principal':1,
  		'foranea':2,
  		'pagareImpreso':13
  		};	
	
	
	var catTipoTranCreditoGrup = {
  		'desmbolsaGrupal':38,
  		'desGrupalAgro'	 :4
  		};
		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('desembolsar', 'submit');
   $('#grupoID').focus();

	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) { 
         grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID','exitoTransaccionDesembolso','erorrTransaccionDesembolso');	
      }
   });					

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#desembolsar').click(function() {	
		$('#tipoTransaccion').val(catTipoTranCreditoGrup.desmbolsaGrupal);
		$('#tipoActualizacion').val(catTipoTranCreditoGrup.desGrupalAgro);		
	});
	
	
	$('#grupoID').blur(function() { 
		if(esTab){
			cantidadProcesados = 0;
			validaGrupo(this.id);
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
	
	

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			grupoID: 'required'
				
		},
		
		messages: {
			grupoID: 'Especifique numero de Grupo'
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	function validaGrupo(idControl){
		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		
		var grupoBeanCon = { 
  		'grupoID':grupo
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		if(grupo != '' && !isNaN(grupo) && esTab){
			gruposCreditoServicio.consulta(15,grupoBeanCon,function(grupos) {
			if(grupos!=null){
				esTab=true;     
				$('#nombreGrupo').val(grupos.nombreGrupo);
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
				consultaIntegrantesGrid();
				consultaGrupoPagare('grupoID');

				if(grupos.estatusCiclo != 'C' ){
					deshabilitaBoton('desembolsar', 'submit');	
					mensajeSis("El Ciclo debe estar Cerrado.");
					$(jqGrupo).focus();
				}
				$('#cicloActual').val(grupos.cicloActual);
				$('#estatus').val(nombEstatus);

			}else{ 
				mensajeSis("El Grupo no Existe.");
				$(jqGrupo).focus();
				deshabilitaBoton('desembolsar', 'submit');							
				}
			});		
		}
   }
			
   //Funcion para consultar el pagare de un grupo
	function consultaGrupoPagare(idControl){
		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		
		var grupoBeanCon = { 
  		'grupoID':grupo
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		inicializaForma('formaGenerica','grupoID' );
		if(grupo != '' && !isNaN(grupo) && esTab){
			gruposCreditoServicio.consulta(catTipoConCreditoGrup.pagareImpreso,grupoBeanCon,function(grupos) {
			if(grupos!=null){
				esTab=true;   
				$('#pagare').val(grupos.pagareImpreso);						
				if(grupos.pagareImpreso == 'N' ){
					mensajeSis("EL Pagaré del Crédito Grupal no ha sido Impreso. ");
					deshabilitaBoton('desembolsar', 'submit');
					$('#grupoID').focus();		
				}
			   }

			});		
		}
   }
	
	function consultaIntegrantesGrid(){
		$('#Integrantes').val('');
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
				
			}else{
				$('#Integrantes').html("");
				$('#Integrantes').show();
			}			
		}); 
	}
	

function consultaProducCredito(idControl) {  
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		var linea =$('#lineaCreditoID').val();
		 

			if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
				productosCreditoServicio.consulta(catTipoConCreditoGrup.foranea,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){
						$('#nombreProducto').val(prodCred.descripcion);
						prorrateoPago = prodCred.prorrateoPago;
						permitePrepago = prodCred.permitePrepago;
						modificarPrepago= prodCred.modificarPrepago;	
						consultaCreditosGrupo();

										
					}else{							
						mensajeSis("No Existe el Producto de Crédito");
						$('#producCreditoID').focus();
						$('#producCreditoID').select();																					
					}
				});
			}				 					
	}
	
	
	
	function consultaCredito(idControl) { 
		var jqCredito  = eval("'#" + idControl + "'");
		var credito = $(jqCredito).val();	 
		var creditoBeanCon = {
			'creditoID'	:credito
		};
	
		setTimeout("$('#cajaLista').hide();", 200);
		if(credito != '' && !isNaN(credito) && esTab){
			creditosServicio.consulta(catTipoConCreditoGrup.principal, creditoBeanCon,function(creditos) {
					if(creditos!=null){
						if(creditos.estatus != 'A'){
							deshabilitaBoton('desembolsar', 'submit');		
						}else{
							habilitaBoton('desembolsar', 'submit');		
							}
						if(creditos.numTransacSim == '0'){
							mensajeSis("No hay amortizaciones para este Crédito");
							}
							if(creditos.fechaMinistrado != '1900-01-01'){
								$('#fechaMinistrado').val(creditos.fechaMinistrado);
								deshabilitaBoton('desembolsar', 'submit');		
							}
					}else{ 
						mensajeSis("El Crédito no Existe");
						$(jqCredito).focus();
						deshabilitaBoton('desembolsar', 'submit');	
						$(jqCredito).select();									
					}
			});										
														
		}
	}

	function consultaCreditoMonitor(idControl) { 
		var jqCredito  = eval("'#" + idControl + "'");
		var credito = $(jqCredito).val();	 
		var creditoBeanCon = {
			'creditoID'	:credito
		};
	
		setTimeout("$('#cajaLista').hide();", 200);
		if(credito != '' && !isNaN(credito) && esTab){
			creditosServicio.consulta(catTipoConCreditoGrup.principal, creditoBeanCon,function(creditos) {
					if(creditos!=null){						
						if(creditos.estatus != 'M'){
							
							cantidadProcesados = cantidadProcesados + 1;
							if(cantidadProcesados > 0){
								deshabilitaBoton('desembolsar', 'submit');	
							}
								
						}else{
							if(cantidadProcesados == 0){
								habilitaBoton('desembolsar', 'submit');
								}		
							}
						if(creditos.numTransacSim == '0'){
							mensajeSis("No hay amortizaciones para este Crédito");
							}
							if(creditos.fechaMinistrado != '1900-01-01'){
								$('#fechaMinistrado').val(creditos.fechaMinistrado);
								deshabilitaBoton('desembolsar', 'submit');										
							}
					}else{ 
						mensajeSis("El Crédito no Existe");
						$(jqCredito).focus();
						deshabilitaBoton('desembolsar', 'submit');	
						$(jqCredito).select();									
					}
			});										
														
		}
	}

	function consultaCreditosGrupo() { 
		var numReg = $('input[name=consecutivoID]').length;
		if(prorrateoPago == 'N')
			if(permitePrepago =='S')
				if(modificarPrepago=='S')
					seleccionaValor();
					
		if(numReg <1){
			deshabilitaBoton('desembolsar', 'submit');	
			}
		for(var i = 1; i <= numReg; i++){
			var credito = "solicitudCre"+i;	
			esTab= true;

			if(requiereValidaCredito == 'N'){
				consultaCredito(credito);
			}else{
				consultaCreditoMonitor(credito);
			}			
			

			
			var idMonto = "monto"+i;	
			var jqMonto  = eval("'#" + idMonto + "'");
			$(jqMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});		
		}
	}

}); // fin jquery function principal

function seleccionaValor (){	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jsPrepagos = eval("'prepagos" + numero+ "'");	
			var valorPrepagos= document.getElementById(jsPrepagos).value;	
			$('#tipoPrepago'+numero+' option[value='+ valorPrepagos +']').attr('selected','true');	
			deshabilitaControl('tipoPrepago'+numero);
			$('#lbltipoPrepago').show();
		});
		
	} 
// funcion a ejecutar despues de transaccion exitosa
function exitoTransaccionDesembolso(){
	deshabilitaBoton('desembolsar', 'submit');
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('Integrantes');
}

// funcion a ejecutar despues de transaccion con error
function erorrTransaccionDesembolso(){
	deshabilitaBoton('desembolsar', 'submit');	
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('Integrantes');
}

function consultaReqValidaCred() {
	var numConsulta = 1;
	var paramBean = {
		'empresaID' : 1
	};
	parametrosSisServicio.consulta(numConsulta, paramBean, function(parametrosBean) {
		if (parametrosBean != null) {
				requiereValidaCredito = parametrosBean.reqValidaCred;
		}
	});
}