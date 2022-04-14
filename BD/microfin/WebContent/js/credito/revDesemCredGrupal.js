$(document).ready(function(){
	//Definición de constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();   
	var catTipoConsultaCredito = { 
  		'principal'	: 1,
  		'foranea'	: 2,
  		'pago'		: 7 
	};	
			
	var catTipoTranCredito = { 
  		'pagoCredito'		: 12 ,
  		'pagoCreditoGrupal': 18 ,
	};		
	//-----------------------Métodos y manejo de eventos-----------------------

	var procedePago = 2;
	var montoPagarMayor = 1;
	deshabilitaBoton('aceptar', 'submit');
    $('#grupoID').focus();
		
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	agregaFormatoControles('formaGenerica');
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});			
    
   	$.validator.setDefaults({
            submitHandler: function(event) { 
                	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma','mensaje', 'true', 'grupoID', 'funcionRevExito','funcionRevFallo');	
            }
    });	
   	

	
	$('#fechaSistema').val(parametroBean.fechaAplicacion);
	
	$('#grupoID').blur(function() {		
		validaGrupo(this.id);
		
	});

	$('#grupoID').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	camposLista[0] = "nombreGrupo";
		    	parametrosLista[0] = $('#grupoID').val();
		 listaAlfanumerica('grupoID', '1', '6', camposLista, parametrosLista, 'listaGruposCredito.htm'); }
	 });
	

	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			creditoID: {
				required: true
			},
			motivoReversa: {
				required: true,
				maxlength : 400
			},
			usuarioAutorizaID: {
				required: true
			},
			contraseniaUsuarioAutoriza:{
				required: true
			}
	
		},
		messages: {
			creditoID: {
				required: 'Especificar Número de  Crédito'
			},
			motivoReversa: {
				required: 'Especificar Motivo Reversa Desembolso',
				maxlength:'Máximo de Caracteres'
			},
			usuarioAutorizaID: {
				required: 'Especificar El Usuario'
			},
			contraseniaUsuarioAutoriza: {
				required: 'Especificar El password'
			}
		}		
	});

	
//-------------Validaciones de controles---------------------
/////consulta GridIntegrantes////////////
	
	function mostrarIntegrantesGrupo(){	
		$('#Integrantes').val('');
		var params = {};		
	
		params['tipoLista'] = 3;
		params['grupoID'] = $('#grupoID').val();
			
			
		$.post("integrantesGpoAutorCredGridVista.htm", params, function(data){
			
			if(data.length >0) { 
				var fecIn = $('#fechaInicio').val(); 
				$('#Integrantes').html(data); 
				$('#Integrantes').show();
				var productCred = $('#producCreditoID').val();
				consultaProducCredito('producCreditoID');

				agregaFormatoMonedaGrid();
			//	 $('#Integrantes').css({ 'width':'600px', 'height':'308px' });
				
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

										
					}else{							
						mensajeSis("No Existe el Producto de Crédito");
						$('#producCreditoID').focus();
						$('#producCreditoID').select();																					
					}
				});
			}				 					
	}

	function consultaProducCredito(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){	
					$('#descripProducto').val(prodCred.descripcion);
					
				}else{							
					mensajeSis("No Existe el Producto de Crédito");																			
				}
			});
		}									
	}
	
	function validaEstatusCredito(var_estatus) {
		var estatusInactivo 	="I";		
		var estatusAutorizado 	="A";
		var estatusVigente		="V";
		var estatusPagado		="P";
		var estatusCancelada 	="C";		
		var estatusVencido		="B";
		var estatusCastigado 	="K";		
		
		if(var_estatus == estatusInactivo){
			$('#estatus').val('INACTIVO');
			habilitaBoton('pagar', 'submit');
		}	
		if(var_estatus == estatusAutorizado){
			$('#estatus').val('AUTORIZADO');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusVigente){
			$('#estatus').val('VIGENTE');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusPagado){
			$('#estatus').val('PAGADO');
			deshabilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusCancelada){
			$('#estatus').val('CANCELADO');							
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusVencido){
			$('#estatus').val('VENCIDO');							
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusCastigado){
			$('#estatus').val('CASTIGADO');							
			habilitaBoton('pagar', 'submit');
		}		
	}
	
	
	
	// Consulta de grupos 
	//function consultaGrupo(valID, id, desGrupo,idCiclo)
	function consultaGrupo(valID, id, desGrupo) { 
		var jqDesGrupo  = eval("'#" + desGrupo + "'");
		var jqIDGrupo  = eval("'#" + id + "'");
		var numGrupo = valID;	
		var tipConGrupo= 16;
		var grupoBean = {
			'grupoID'	:numGrupo
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numGrupo != '' && !isNaN(numGrupo) ){
			gruposCreditoServicio.consulta(tipConGrupo, grupoBean,function(grupo) {
				if(grupo!=null){
					var numCreditos = grupo.numCreditos;
					var numeroGrupo	= grupo.grupoID;

					if(numCreditos != 0){
						mostrarIntegrantesGrupo('grupoID');
						$(jqIDGrupo).val(grupo.grupoID);
						$(jqDesGrupo).val(grupo.nombreGrupo);
					}else{
						mensajeSis("El grupo " + numeroGrupo + " no tiene créditos desembolsados ");
						limpiaFormaCompleta('formaGenerica', true,['']);
						limpiaGrid('Integrantes','miTabla');
						$('#grupoID').focus();
						deshabilitaBoton('aceptar', 'submit');	

					}
						
				}
			});															
		}
	}

	
function validaGrupo(idControl){
		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		
		var grupoBeanCon = { 
  		'grupoID':grupo
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		if(grupo != '' && !isNaN(grupo) && esTab){
			gruposCreditoServicio.consulta(catTipoConsultaCredito.principal,grupoBeanCon,function(grupos) {
			if(grupos!=null){
				esTab=true;     
				$('#grupoDes').val(grupos.nombreGrupo);
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
				$('#cicloID').val(grupos.cicloActual);
				$('#producCreditoID').val(grupos.productoCre);

				
				$('#motivo').val("");
				$('#usuarioAutorizaID').val("");
				$('#contraseniaUsuarioAutoriza').val("");

				var numGrupo = $('#grupoID').val();
				consultaGrupo(numGrupo,'grupoID','grupoDes');
				habilitaBoton('aceptar', 'submit');	

				if(grupos.estatusCiclo != 'C' ){
					deshabilitaBoton('aceptar', 'submit');	
					mensajeSis("El Ciclo debe estar Cerrado.");
					limpiaGrid('Integrantes','miTabla');	
					limpiaFormaCompleta('formaGenerica', true,['']);	
					$(jqGrupo).focus();
				}
				
				

			}else{ 
				mensajeSis("El Grupo no Existe.");
				$(jqGrupo).focus();
				deshabilitaBoton('aceptar', 'submit');	
				limpiaGrid('Integrantes','miTabla');	
				limpiaFormaCompleta('formaGenerica', true,['']);					
				}
			});		
		}
   }
	



	
});


function agregaFormatoMonedaGrid(){
	var numero = 0;
	var varMonto = "";
	$('input[name=monto]').each(function() {		
		numero= this.id.substr(5,this.id.length);
		varMonto = eval("'#monto"+numero+"'");
		$(varMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

	});
}

//limpiar Detalle del Grid
function limpiaDetalleGrid(idTabla){
	$('#'+idTabla).find(':tr').each( 
		function(){	    		
			var child = $(this);
			child.remove();
		}
	);
}

//limpiar los Grids
function limpiaGrid(idControl,idTabla){
	$('#'+idControl).html('');
	$('#'+idControl).hide();
	limpiaDetalleGrid(idTabla);
}


function funcionRevExito(){
	limpiaFormaCompleta('formaGenerica', true,['']);
	limpiaGrid('Integrantes','miTabla');
	deshabilitaBoton('aceptar', 'submit');	
	$('#grupoID').focus();
	
}

function funcionRevFallo(){
	limpiaFormaCompleta('formaGenerica', true,['']);
	limpiaGrid('Integrantes','miTabla');
	deshabilitaBoton('aceptar', 'submit');	
	$('#grupoID').focus();
}


