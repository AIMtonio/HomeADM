var parametroBean = consultaParametrosSession(); 

$(document).ready(function() {
	esTab = true;
	var chequeCan	= 1;
	var chequeNue	= 2;	
	var catTipoConsultaInstituciones = {
		'principal':1, 
		'foranea':2
	};

	var catTipoConsultaOrdenesPago= {
		'emitidos':1,		
	};	
	
	var catTransRenovOrdenPago = {
			'renovarOrden' :1,
	};

	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('renovacion','submit');
	inicializaForma('formaGenerica', 'institucionIDCan');
	$('#institucionIDCan').focus();
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
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'numeroPoliza','funcionExito','funcionFallo');        	
        }
    });

	$('#institucionIDCan').bind('keyup',function(e){
		lista('institucionIDCan', '2', '1', 'nombre', $('#institucionIDCan').val(), 'listaInstituciones.htm');
	});
	
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionID', '2', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#numCtaInstitCan').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionIDCan').val();
		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#numCtaInstitCan').val();
		
		listaAlfanumerica('numCtaInstitCan', '2', '2', camposLista,parametrosLista, 'tesoCargaMovLista.htm');	       
	});	
	
//-- Lista de cheques emitidos--//
	$('#numOrdenPagoCan').bind('keyup',function(e) { 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID"; 
		camposLista[1] = "numCtaInstit";		
		camposLista[2] = "numOrdenPago";	
		parametrosLista[0] = $('#institucionIDCan').val();
		parametrosLista[1] = $('#numCtaInstitCan').val();
		parametrosLista[2] = $('#numOrdenPagoCan').val();		
		listaAlfanumerica('numOrdenPagoCan', '2', '1',  camposLista, parametrosLista, 'listaOrdenesPago.htm');
	}); 	
	
	
	$('#numCtaInstit').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();
		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#numCtaInstit').val();
		
		listaAlfanumerica('numCtaInstit', '2', '2', camposLista,parametrosLista, 'tesoCargaMovLista.htm');	       
	});		

	$('#numCtaInstitCan').blur(function() {
		if($('#numCtaInstitCan').val() != '' ){
			consultaCuentaBan(this.id);	
		} 

		if(isNaN($('#numCtaInstitCan').val()) ){
			$('#numCtaInstitCan').val("");
			$('#numCtaInstitCan').focus();
		}
	});

	$('#numCtaInstit').blur(function() {
		if($('#numCtaInstit').val() != '' ){
		consultaCuentaBanNuevo(this.id);
		}
	});

	$('#institucionIDCan').blur(function() {	
	   consultaInstitucion(this.id, chequeCan);	
 	});	
   
	$('#institucionID').blur(function() {
   consultaInstitucion(this.id,chequeNue);
	});
   
	$('#numOrdenPagoCan').blur(function(){	  
	   consultaOrdenes(this.id);	 
	  habilitaCampos();
	});
	$('#confimaNumOrdenPago').blur(function(){
		if($('#numOrdenPago').val() != '' && $('#confimaNumOrdenPago').val()!=''&& $('#numOrdenPago').val() != $('#confimaNumOrdenPago').val()){
			mensajeSis('Los Números de Referencia no Coinciden');
			$('#confimaNumOrdenPago').focus();
		}
		habilitaBoton('renovacion','submit');
	});

  	$('#renovacion').click(function(){  		
  		$('#tipoTransaccion').val(catTransRenovOrdenPago.renovarOrden);  	
  	});  


   //Funcion de consulta para obtener el nombre de la institucion	
	function consultaInstitucion(idControl, idInst) {
		var jqInstituto = eval("'#" + idControl + "'");
		
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto!='' && !isNaN(numInstituto)){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){					
					if(idInst == chequeCan){						
						if(instituto!=null){
							$('#nombreInstitucionCan').val(instituto.nombre);
							limpiaCamposChequeCancela();
						}else{
							mensajeSis("No existe la Institución"); 
							$('#institucionIDCan').val('');
							$('#institucionIDCan').focus();
							$('#nombreInstitucionCan').val("");
							limpiaCamposChequeCancela();
						}
					}
					else if(idInst==chequeNue){				
						if(instituto!=null){
							$('#nombreInstitucion').val(instituto.nombre);
							limpiaCamposNuevoCheque();
						}else{
							mensajeSis("No existe la Institución"); 
							$('#institucionID').val('');
							$('#institucionID').focus();
							$('#nombreInstitucion').val("");
							limpiaCamposNuevoCheque();
						}
						
					}
					
				});
		}
		
	}	

	function consultaCuentaBan(idControl) {
	var jqCuentaBan= eval("'#" + idControl + "'");
		var numCuenta = $(jqCuentaBan).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var tipoConsulta = 9;
		var DispersionBeanCta = {
				'institucionID': $('#institucionIDCan').val(),
				'numCtaInstit': numCuenta
		};
		if(!isNaN(numCuenta)){		
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){
					$('#numCtaInstitCan').val(data.numCtaInstit);
					$('#numOrdenPagoCan').val('');
					$('#beneficiarioCan').val('');
					$('#montoCan').val('');
					$('#conceptoCan').val('');
					$('#fechaCan').val('');
					$('#institucionID').val('');
					$('#nombreInstitucion').val('');
					$('#numCtaInstit').val('');
					$('#numOrdenPago').val('');
					$('#confimaNumOrdenPago').val('');
					$('#beneficiario').val('');	
					$('#motivoRenov').val('');
					deshabilitaBoton('renovacion','submit');
			
				}else{
					mensajeSis("No se encontró la cuenta bancaria.");
					$('#numCtaInstitCan').val("");
					$('#numCtaInstitCan').focus();
					$('#beneficiarioCan').val('');
					$('#montoCan').val('');
					$('#conceptoCan').val('');
					$('#fechaCan').val('');
					$('#institucionID').val('');
					$('#nombreInstitucion').val('');
					$('#numCtaInstit').val('');
					$('#numOrdenPago').val('');
					$('#confimaNumOrdenPago').val('');
					$('#beneficiario').val('');	
					$('#motivoRenov').val('');
					deshabilitaBoton('renovacion','submit');

				}
			});
		}
	}

	function consultaCuentaBanNuevo(idControl) {
		var jqCuentaBan= eval("'#" + idControl + "'");
		var numCuenta = $(jqCuentaBan).val();
		setTimeout("$('#cajaLista').hide();", 200);	


		var tipoConsulta = 9;
		var DispersionBeanCta = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': numCuenta
		};
		if(!isNaN(numCuenta)){		
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){
					$('#numCtaInstit').val(data.numCtaInstit);
					$('#numOrdenPago').focus();
					$('#beneficiario').val($('#beneficiarioCan').val());
					console.log($('#beneficiarioCan').val());
					$('#numOrdenPago').val('');
					$('#confimaNumOrdenPago').val('');
					$('#motivoRenov').val('');
					deshabilitaBoton('renovacion','submit');
				}else{
					mensajeSis("No se encontró la cuenta bancaria.");
					$('#numCtaInstit').val("");
					$('#numCtaInstit').focus();
					$('#numOrdenPago').val('');
					$('#confimaNumOrdenPago').val('');
					$('#beneficiario').val('');	
					$('#motivoRenov').val('');
					deshabilitaBoton('renovacion','submit');

				}
			});
		}
	}

	 //Funcion de consulta para obtener datos del cheque que fue emitido y se va a cancelar
	function consultaOrdenes(idControl) {
		var jqNumOrden = eval("'#" + idControl + "'");
		var numOrden = $(jqNumOrden).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var OrdenBeanCon = {
				'institucionID': $('#institucionIDCan').val(),
				'numCtaInstit': $('#numCtaInstitCan').val(),			
				'numOrdenPago': numOrden,				
		};
		
		if(numOrden!='' && esTab == true){
			renovacionOrdenPagoServicio.consulta(catTipoConsultaOrdenesPago.emitidos,OrdenBeanCon,function(orden){		
					if(orden!=null){						
						$('#beneficiarioCan').val(orden.beneficiario);
						$('#montoCan').val(orden.monto);				
						$('#montoCan').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n', 
							roundToDecimalPlace: 2	
						});						
						$('#conceptoCan').val(orden.concepto);
						$('#fechaCan').val(orden.fecha);						
						$('#institucionID').focus();
					}else{
						mensajeSis("La Orden de Pago no Existe o se Encuentra Renovada/Conciliada.");
						inicializaForma('formaGenerica', 'institucionIDCan');
						$('#institucionIDCan').val('');
						$('#institucionIDCan').focus();
						deshabilitaBoton('renovacion','submit');
					}    						
				});
		}else{
			deshabilitaBoton('renovacion','submit');
			$('#beneficiarioCan').val('');
			$('#montoCan').val('');
			$('#conceptoCan').val('');
			$('#fechaCan').val('');			
		}		
	}
	

  	$('#formaGenerica').validate({
  		rules: {
  			institucionIDCan: {
  				required: true  				
  			},
  			numCtaInstitCan:{
  				required: true,	
  				maxlength: 25,
  				minlength: 1
  			},
  			numOrdenPagoCan:{
  				required:true
  			},
  			beneficiarioCan:{
  				required:true
  			},
  			montoCan:{
  				required:true
  			},
  			conceptoCan:{
  				required:true
  			},
  			fechaCan:{
  				required:true
  			},
  			institucionID:{
  				required:true
  			},
  			numCtaInstit:{
  				required:true
  			},
  			numOrdenPago:{
  				required:true
  			},
  			confimaNumOrdenPago:{
  				required:true
  			},
  			motivoRenov:{
  				required: true
  			}
  		},  		
  		messages: {
  			institucionIDCan: {
  				required: 'Especifique la Institución.', 				
  			},
  			numCtaInstitCan:{
  				required: 'Especifique el Número de Cuenta.',	
  				maxlength: 'Máximo 20 Caracteres.',
  				minlength: 'Mínimo 1 Cacter.',
  			},
  			numOrdenPagoCan:{
  				required:'Especifique la Orden de Pago.'
  			},
  			beneficiarioCan:{
  				required:'Especifique el Nombre de Beneficiario.'
  			},
  			montoCan:{
  				required:'Especifique el Monto.'
  			},
  			conceptoCan:{
  				required:'Especifique el Concepto.'
  			},
  			fechaCan:{
  				required:'Especifique la Fecha.'
  			},
  			institucionID:{
  				required:'Especifique la Institución.'
  			},
  			numCtaInstit:{
  				required:'Especifique el Número de Cuenta.'
  			},
  			numOrdenPago:{
  				required:'Especifique la Orden de Pago.'
  			},
  			confimaNumOrdenPago:{
  				required:'Especifique la Orden de Pago'
  			},
  			motivoRenov:{
  				required: 'Especifique el Motivo de Renovación'
  			}
  		}		
  	});
});

	function limpiaCamposChequeCancela(){	
		$('#numCtaInstitCan').val('');
		$('#numOrdenPagoCan').val('');
		$('#beneficiarioCan').val('');
		$('#montoCan').val('');
		$('#conceptoCan').val('');
		$('#fechaCan').val('');
		$('#institucionID').val('');
		$('#nombreInstitucion').val('');
		$('#numCtaInstit').val('');
		$('#numOrdenPago').val('');
		$('#confimaNumOrdenPago').val('');
		$('#beneficiario').val('');	
		$('#motivoRenov').val('');
		deshabilitaBoton('renovacion','submit');
	}   

	function limpiaCamposNuevoCheque(){	
		$('#numCtaInstit').val('');
		$('#numOrdenPago').val('');
		$('#confimaNumOrdenPago').val('');
		$('#beneficiario').val('');
		$('#motivoRenov').val('');
		deshabilitaBoton('renovacion','submit');

	} 

	function inicializaCampos(){
		$('#institucionIDCan').val("");
		$('#institucionIDCan').focus();
		$('#nombreInstitucionCan').val("");
		$('#numCtaInstitCan').val("");		
		$('#numOrdenPagoCan').val("");
		$('#beneficiarioCan').val("");
		$('#montoCan').val("");
		$('#fechaCan').val("");
		$('#conceptoCan').val("");
		$('#institucionID').val("");
		$('#numCtaInstit').val("");
		$('#numOrdenPago').val("");
		$('#confimaNumOrdenPago').val("");
		$('#beneficiario').val("");
		$('#motivoRenov').val("");
		$('#nombreInstitucion').val("");
		deshabilitaBoton('cancelarCheque','submit');
	}

function habilitaCampos(){
	 $('#institucionID').removeAttr('disabled');
	   $('#numCtaInstit').removeAttr('disabled');
	   $('#numOrdenPago').removeAttr('disabled');
	   $('#confimaNumOrdenPago').removeAttr('disabled');
	   $('#beneficiario').removeAttr('disabled');
	   $('#motivoRenov').removeAttr('disabled');
	   $('#institucionID').val('');
	   $('#numCtaInstit').val('');
	   $('#numOrdenPago').val('');
	   $('#confimaNumOrdenPago').val('');
	   $('#beneficiario').val('');
	   $('#motivoRenov').val('');
	   $('#nombreInstitucion').val('');
}

function funcionExito(){	
	deshabilitaBoton('renovacion','submit');	
	$('#nombreInstitucionCan').attr('disabled','true');
	$('#beneficiarioCan').attr('disabled','true');
	$('#montoCan').attr('disabled','true');
	$('#conceptoCan').attr('disabled','true');
	$('#fechaCan').attr('disabled','true');
	$('#motivoRenov').attr('disabled','true');
	$('#institucionID').attr('disabled','true');
	$('#nombreInstitucion').attr('disabled','true');
	$('#numCtaInstit').attr('disabled','true');
	$('#numOrdenPago').attr('disabled','true');
	$('#confimaNumOrdenPago').attr('disabled','true');
	$('#beneficiario').attr('disabled','true');
		
}

function funcionFallo(){
	
}