$(document).ready(function() {
	
	$("#institucionID").focus();

	esTab = true;
	var catTipoTransaccionCtaNostro = {
  		'agrega': 1,
  		'modifica':2,
  		'elimina':3
	};	
	
	var catTipoConsultaInstituciones = {
		'principal':1, 
		'foranea':2
	};

	var catTipoConsultaCtaNostro = {
		'principal':1,
		'foranea':2, 
		'resumen':4,
		'folioInstit':5,
		'estatus':11
	};	

	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('cancelar', 'submit'); 
	$('#sobregirarSaldo2').attr("checked",true);
	$('#tipoChequera').hide();
	$('#lbltipoChequera').hide();  
	$('#oculta').hide(); 
	$('#tipoChequera').val('');
	$('#divDatosChequeraEstandar').hide(500);
	verParametrosDispersion();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
        submitHandler: function(event) {
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'numCtaInstit',
        											'exitoCtaNostro','errorCtaNostro');
//  		   
        }
    });	
	//validacion bind
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#numCtaInstit').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "numCtaInstit";
		camposLista[1] = "institucionID";
		parametrosLista[0] = $('#numCtaInstit').val();
		parametrosLista[1] = $('#institucionID').val();
		listaAlfanumerica('numCtaInstit', '2', '7', camposLista,parametrosLista, 'ctaNostroLista.htm');	       
	});	
 
	$('#centroCostoID').bind('keyup',function(e){
		lista('centroCostoID', '2', '1', 'descripcion', $('#centroCostoID').val(), 'listaCentroCostos.htm');
	});

   $('#institucionID').blur(function() {
	   		
			$('#numCtaInstit').val('');	
			$('#cuentaClabe').val('');
			$('#saldo').val('');
  		    $('#chequera').val('');
  		    $('#divDatosChequera').hide(500);
  			$('#checkPrincipal').removeAttr("checked");
  		    $('#sucursalInstit').val('');
  		    $('#centroCostoID').val('');
  		    $('#nombreCentroCostos').val('');
  		    $('#cuentaCompletaID').val('');
			$('#descripcion').val('');
  		    $('#numCtaInstit').focus();
  		    $('#tipoChequera').hide();
  		    $('#lbltipoChequera').hide();
  		    $('#oculta').hide();
  		    $('#tipoChequera').val('');
  		    $('#divDatosChequeraEstandar').hide(500);

  		    //Campos convenio
  		    $('#numConvenio').val('');
  		    $('#descConvenio').val('');

  		    deshabilitaBoton('agrega','submit');
  		    deshabilitaBoton('modifica','submit');
  		    deshabilitaBoton('cancelar','submit');
  		    if($('#institucionID').val()!="" ){
  		    	consultaInstitucion(this.id);  
  		    }
 	});	
   	$('#centroCostoID').blur(function() {
   		if($('#centroCostoID').val()!=""){
   			consultaCentroCostos(this.id); 
   		}
   	});
   	
   	$('#cuentaCompletaID').blur(function() {
   		if($('#cuentaCompletaID').val()!=""){
   			if(esTab){
   				validaCuentaContable('cuentaCompletaID');
   			}
   		}else{
   			$('#descripcion').val('');
   		}
   	});

   	$('#numCtaInstit').blur(function(){
   		if($('#numCtaInstit').val()!="" && $('#institucionID').val()!=""){
   			validaCtaNostroExiste('numCtaInstit','institucionID');
   		}		
			$('#tipoChequera').val('');	
			$('#tipoChequera').hide();
			$('#lbltipoChequera').hide();
   	});
		
   	$('#cuentaClabe').blur(function(){
   		if($('#cuentaClabe').val()!="" && $('#institucionID').val()!=""){
   			validaExisteFolio('numCtaInstit','institucionID');	
   		}		
	});
	   	
   	$('#cuentaCompletaID').bind('keyup',function(e){
   		if(this.value.length >= 2){ 
   			var camposLista = new Array();
   			var parametrosLista = new Array();			
   			camposLista[0] = "descripcion"; 
   			parametrosLista[0] = $('#cuentaCompletaID').val();
   			listaAlfanumerica('cuentaCompletaID', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
   		}
   	}); 

   	$('#agrega').click(function() {		
   		$('#tipoTransaccion').val(catTipoTransaccionCtaNostro.agrega);
        $('#numCtaInstit').val();	   		
   	});
   
	$('#modifica').click(function() {			
		if($('#chequera').val()=='N'){
			$('#folioUtilizar').val('');
			$('#rutaCheque').val('');
			$('#folioUtilizarEstan').val('');
			$('#rutaChequeEstan').val('');

			$('#tipoChequera').hide();
			$('#tipoChequera').val('');
			$('#oculta').hide();
			$('#lbltipoChequera').hide();
			$('#divDatosChequera').hide(500);
			$('#divDatosChequeraEstandar').hide(500);
		}
		if($('#tipoChequera').val()=='P'){
			$('#folioUtilizarEstan').val('');
			$('#rutaChequeEstan').val('');
	
		}else if($('#tipoChequera').val()=='E'){
			$('#folioUtilizar').val('');
			$('#rutaCheque').val('');
	
		}
		$('#tipoTransaccion').val(catTipoTransaccionCtaNostro.modifica);
       		
	});

	$('#cancelar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCtaNostro.elimina);		
	});
	
	$('#checkPrincipal').click(function() {
		if($('#checkPrincipal').attr('checked') == true){
			$('#principal').val("S");			
		}else{
			$('#principal').val("N");
		}		
	});	
	$('#chequera').change(function(){
			if($('#chequera').val()=='S'){
				$('#tipoChequera').val('');	
				$('#tipoChequera').show();
				$('#lbltipoChequera').show();
				$('#oculta').show();
			}else{
				$('#tipoChequera').hide();
				$('#tipoChequera').val('');
				$('#lbltipoChequera').hide();
				$('#oculta').hide();
				$('#divDatosChequera').hide(500);
				$('#divDatosChequeraEstandar').hide(500);
			}
	});	  
	
	$('#tipoChequera').change(function(){
		if($('#tipoChequera').val()=='P'){
			$('#divDatosChequera').show(500);
			$('#divDatosChequeraEstandar').hide(500);
		}else if($('#tipoChequera').val()=='E'){
			$('#divDatosChequeraEstandar').show(500);
			$('#divDatosChequera').hide(500);
			
		}else if ($('#tipoChequera').val()=='A'){
			$('#divDatosChequera').show(500);
			$('#divDatosChequeraEstandar').show(500);
		}else{
			$('#divDatosChequera').hide(500);
			$('#divDatosChequeraEstandar').hide(500);
		}
	});
		    
		    
		    
   //Funcion de consulta para obtener el nombre de la institucion	
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto!='' && !isNaN(numInstituto)){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){		
					if(instituto!=null){							
						$('#nombreInstitucion').val(instituto.nombre);
						if(instituto.institucionID=='37'){
							$(proteccionOrdenPago).show();
						}else{
							$(proteccionOrdenPago).hide();
							$('#protecOrdenPago2').attr("checked",true);
						}
					}else{
						mensajeSis("No existe la Institución"); 
						$('#institucionID').val('');
						$('#institucionID').focus();
						$('#nombreInstitucion').val("");
					}    						
				});
		}else{
			$('#institucionID').val('');
			$('#nombreInstitucion').val("");
		}
		
	}
    //funcion de consulta para obtener el nombre del centro de costos.
	function consultaCentroCostos(idControl) {
		var jqCentro = eval("'#" + idControl + "'");
		var numCentro = $(jqCentro).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var centroBeanCon = {
			'centroCostoID' : $('#centroCostoID').val()
		};
		if(numCentro != '' && !isNaN(numCentro)){
			centroServicio.consulta(catTipoConsultaCtaNostro.foranea,centroBeanCon,function(centro) {
				if(centro!=null){
					$('#nombreCentroCostos').val(centro.descripcion);
				}else{
					mensajeSis("No Existe el Centro de Costos");
					$('#centroCostoID').val('');
					$('#nombreCentroCostos').val("");
				}
			});
		}else{
			$('#centroCostoID').focus();
			$('#centroCostoID').val('');
			$('#nombreCentroCostos').val('');
		}
	}	
		  
  	function validaCuentaContable(idControl) { 
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();
		var conPrincipal = 1;
		var CtaContableBeanCon = {
			'cuentaCompleta':numCtaContable
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaContable != '' && !isNaN(numCtaContable)){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){
					if(ctaConta.grupo != "E"){
						$('#descripcion').val(ctaConta.descripcion);
					}else{
						mensajeSis("Sólo Cuentas Contables De Detalle");
						$('#cuentaCompletaID').focus();
						$('#descripcion').val("");
					}
				} 
				else{
					mensajeSis("No Existe la Cuenta Contable.");
					$('#cuentaCompletaID').focus(); 
					$('#descripcion').val("");
				}
			}); 
		}else{
			$('#cuentaCompletaID').val('');
		}
  	}
		
  	function validaCtaNostroExiste(numCta,institID){
  		$('#sobregirarSaldo2').attr("checked",true);
  		$('#protecOrdenPago2').attr("checked",true);
  		var jqNumCtaInstit = eval("'#" + numCta + "'");
  		var jqInstitucionID = eval("'#" + institID + "'");
  		var numCtaInstit = $(jqNumCtaInstit).val();
  		var institucionID = $(jqInstitucionID).val();
  		var CtaNostroBeanCon = {
  				'institucionID':institucionID,
  				'numCtaInstit':numCtaInstit
  		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaInstit != '' && !isNaN(numCtaInstit)){
  			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon, function(ctaNostro){
  				  				
  				if(ctaNostro!=null){   				
	  				dwr.util.setValues(ctaNostro);
	  		
					var estatuscta=$('#estatus').val();					  		
					if($('#principal').val()=='S'){
						$('#checkPrincipal').attr("checked", true);
					}
					else{
						$('#checkPrincipal').attr("checked", false);
					}
					if(ctaNostro.sobregirarSaldo=='S'){
						$('#sobregirarSaldo').attr("checked", true);
					}else{
						$('#sobregirarSaldo2').attr("checked", true);
					}
					if(ctaNostro.protecOrdenPago=='S'){
						$('#protecOrdenPago').attr("checked", true);
					}else{
						$('#protecOrdenPago2').attr("checked", true);
					}
					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit'); 
					habilitaBoton('cancelar', 'submit');
					esTab=true;
					$('#saldo').attr("readOnly", "true");
					validaCuentaContable('cuentaCompletaID') ;
					consultaCentroCostos('centroCostoID');
					
					$('#saldo').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					if($('#chequera').val()=='S'){	
						$('#tipoChequera').show();
						$('#lbltipoChequera').show();
						$('#oculta').show();
						
						if($('#tipoChequera').val()=='P'){
							$('#divDatosChequera').show(500);
							if($('#folioUtilizar').val()!=''){
							}
							
						}else if($('#tipoChequera').val()=='E'){
							$('#divDatosChequeraEstandar').show(500);
							if($('#folioUtilizarEstan').val()!=''){
							}
							
						}else if ($('#tipoChequera').val()=='A'){
							$('#divDatosChequera').show(500);
							$('#divDatosChequeraEstandar').show(500);
							
							if($('#folioUtilizar').val()!=''){
							}
							if($('#folioUtilizarEstan').val()!=''){
	
							}
						}else{
							$('#divDatosChequera').hide(500);
							$('#divDatosChequeraEstandar').hide(500);
						}

					}else{

						$('#divDatosChequera').hide(500);
						$('#folioUtilizar').val('');
						$('#rutaCheque').val('');
						$('#divDatosChequeraEstandar').hide(500);
						$('#folioUtilizarEstan').val('');
						$('#rutaChequeEstan').val('');

					}

					if(estatuscta !='A'){
						mensajeSis("El Número de Cuenta Bancaria esta Inactiva");
	  					deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit'); 
						deshabilitaBoton('cancelar', 'submit');
						$('#numCtaInstit').focus();
	  				}
					
  				}
  				else{
  					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('cancelar', 'submit');
  					habilitaBoton('agrega', 'submit'); 
  					$('#saldo').removeAttr("readOnly");
        			$('#cuentaClabe').val('');
        			$('#saldo').val('');
        			$('#chequera').val('');
					$('#checkPrincipal').removeAttr("checked");
        			$('#sucursalInstit').val('');        	
        			$('#centroCostoID').val('');
        			$('#nombreCentroCostos').val('');
        			$('#cuentaCompletaID').val('');
        			$('#descripcion').val('');
        			$('#divDatosChequera').hide(500);
        			$('#folioUtilizar').val('');
        			$('#rutaCheque').val('');
        			$('#tipoChequera').hide();
        			$('#oculta').hide();
        			$('#lbltipoChequera').hide();
        			$('#tipoChequera').val('');
          		    $('#divDatosChequeraEstandar').hide(500);
          		  	$('#folioUtilizarEstan').val('');
          		  	$('#rutaChequeEstan').val('');

          		  	//Campos convenio
  		    		$('#numConvenio').val('');
  		    		$('#descConvenio').val('');
					
  				} 
  			});
  		}else{
  			$('#numCtaInstit').val('');
  			}
  	}
  	
  	function validaExisteFolio(numCta,institID){
  		esTab=true;
  		var jqNumCtaInstit = eval("'#" + numCta + "'");
  		var jqInstitucionID = eval("'#" + institID + "'");
  		var numCtaInstit = $(jqNumCtaInstit).val();
  		var institucionID = $(jqInstitucionID).val();
  		var CtaNostroBeanCon = {
  				'institucionID':institucionID,
  				'numCtaInstit':numCtaInstit  				
  		};
  		
  		if(esTab){
  			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.folioInstit,CtaNostroBeanCon, function(ctaNtro){
  				if(ctaNtro!=null){  
  					var folio = ctaNtro.cuentaClabe;// el folio de institucion se paso en el parametro cuentaClabe
  					var cuentaClabe = $('#cuentaClabe').val();
  					var substrClabe= cuentaClabe.substr(0,3);
  					if(folio!=substrClabe){
  						mensajeSis("La Cuenta Clabe no coincide con la Institución.");
  						$('#cuentaClabe').focus();
  						$('#cuentaClabe').val('');
  					}						 			
  				}
  			});
  		}
  	}
  	

  	$('#formaGenerica').validate({
  		rules: {
  			institucionID: {
  				required: true  				
  			},
  			cuentaCompletaID:{
  				required: true,	
  				maxlength: 25,
  				minlength: 1
  			},
  			centroCostoID:{
  				required: true  			
  			},
  			sucursalInstit:{
  				required: true	
  			},
  			chequera:{
  				required: true
  			},
  			cuentaClabe :{
  				required: true,	
  				number: true,
  				maxlength: 18,
  				minlength: 18
  			},
  			numCtaInstit:{
  				required: true,	
  				maxlength: 20  				
  			},
  			tipoChequera:{
  				required: function(){return $('#chequera').val()=='S';}
  			},
  			folioUtilizar:{ 				
  				required: function(){
  					if(($('#tipoChequera').val()=='P') || ($('#tipoChequera').val()=='A')){
  						return true;
	  				}else {
						return false;
					}
  					},
  				number: true
  			},
  			rutaCheque:{
  				required: function(){
  					if(($('#tipoChequera').val()=='P') || ($('#tipoChequera').val()=='A')){
  						return true;
	  				}else {
						return false;
					}
  					}
  			},
  			folioUtilizarEstan:{
  				required: function(){
  					if(($('#tipoChequera').val()=='E') || ($('#tipoChequera').val()=='A')){
  						return true;
	  				}else {
						return false;
					}
  					},
  				number: true
  			},
  			rutaChequeEstan:{
  				required: function(){
  					if(($('#tipoChequera').val()=='E') || ($('#tipoChequera').val()=='A')){
  						return true;
	  				}else {
						return false;
					}
  					},
  					},
  			numConvenio:{
  				maxlength:30
  			},
  			descConvenio:{
  				maxlength:100
  			}
  		},  		
  		messages: {
  			institucionID: {
  				required: 'El campo es requerido'
  			},				
  			cuentaCompletaID: {
  				required: 'Especifique la cuenta',
  				maxlength: 'máximo 25 números',
  				minlength: 'mínimo 1 número'
  			},
  			centroCostoID:{
  				required: 'El campo es requerido'  			
  			},
  			sucursalInstit:{
  				required: 'El campo es requerido',	
  			},
  			chequera:{
  				required: 'El campo es requerido',
  			},
  			cuentaClabe :{
  				required: 'El campo es requerido',
  				number: 'solo números',
  				maxlength: 'máximo 18 numeros',
  				minlength: 'mínimo 18 numeros'
  			},
  			numCtaInstit:{
  				required: 'El campo es requerido',
  				maxlength: 'maximo 20 numeros'
  			},
  			tipoChequera:{
  				required: 'El campo es requerido',
  			},
  			folioUtilizar:{
  				required: 'El campo es requerido',
  				number:   'Solo números'
  			},
  			rutaCheque:{
  				required: 'El campo es requerido'
  			},
  			folioUtilizarEstan:{
  				required: 'El campo es requerido',
  				number:   'Solo números'
  			},
  			rutaChequeEstan:{
  				required: 'El campo es requerido'
  			},
  			numConvenio:{
  				maxlength:'Máximo 30 caracteres'
  			},
  			descConvenio:{
  				maxlength:'Máximo 100 caracteres'
  			}
  		}		
  	});
	

});


function verParametrosDispersion(){
		paramGeneralesServicio.consulta(43,{},function(parametro){
			if (parametro != null) {
				permiteVer = parametro.valorParametro;
				if(permiteVer == 'S'){
					$('#trAlgClaveRetiro').show();
					$('#trVigClaveRetiro').show();
				}else{
					$('#trAlgClaveRetiro').hide();
					$('#trVigClaveRetiro').hide();
				}
			}
		});
}



function exitoCtaNostro(){

	$('#cuentaClabe').val('');
	$('#saldo').val('');
	$('#sucursalInstit').val('');
	$('#centroCostoID').val('');
	$('#nombreCentroCostos').val('');
	$('#cuentaCompletaID').val('');
	$('#descripcion').val('');
	$('#checkPrincipal').attr('checked',false);	
	$('#principal').val('N');
	$('#chequera option[value=""]').attr('selected','true');
	$('#folioUtilizar').val('');
	$('#rutaCheque').val('');
	$('#divDatosChequera').hide(200);
	$('#tipoChequera').hide();
	$('#oculta').hide();
	$('#lbltipoChequera').hide();
	$('#tipoChequera option[value=""]').attr('selected','true');
	$('#folioUtilizarEstan').val('');
	$('#rutaChequeEstan').val('');
	$('#divDatosChequeraEstandar').hide(200);
	$('#algClaveRetiro').val('M');
	$('#vigClaveRetiro').val('');

	//Campos convenio
	$('#numConvenio').val('');
	$('#descConvenio').val('');
	
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit'); 	
	deshabilitaBoton('cancelar', 'submit');
	esTab = false;	
}
function errorCtaNostro(){
	
}
