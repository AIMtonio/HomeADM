
var parametroBean = consultaParametrosSession(); 
$(document).ready(function() {
	esTab = true;
	var chequeCan	= 1;
	var chequeNue	= 2;	
	var catTipoConsultaInstituciones = {
		'principal':1, 
		'foranea':2
	};

	var catTipoConsultaCheques = {
		'emitidos':4,		
	};	
	
	var cat_TransCancelacionCheques = {
			'cancelarCheque' :1,
	};

	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('imprimirCheque','button');
	deshabilitaBoton('cancelarCheque','submit');
	inicializaForma('formaGenerica', 'institucionIDCan');

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	var sucursalID=parametroBean.sucursal;
	var cajaID=parametroBean.cajaID;
	
	$('#sucursalID').val(sucursalID);
	$('#cajaID').val(cajaID);
	
	
	
	
	$.validator.setDefaults({
        submitHandler: function(event) {
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'numeroPoliza','funcionExito','funcionFallo');        	
        }
    });			
	
	$('#institucionIDCan').focus();
	$('#fieldsetAutoriza').hide();
	$('#usuarioLogin').val(parametroBean.numeroUsuario);
	//validacion bind
	$('#institucionIDCan').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionIDCan', '1', '1', 'nombre', $('#institucionIDCan').val(), 'listaInstituciones.htm');
	});
	
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#numCtaBancariaCan').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "numCtaInstit";
		camposLista[1] = "institucionID";
		parametrosLista[0] = $('#numCtaBancariaCan').val();
		parametrosLista[1] = $('#institucionIDCan').val();
		listaAlfanumerica('numCtaBancariaCan', '2', '7', camposLista,parametrosLista, 'ctaNostroLista.htm');	       
	});	
	
	$('#numCtaBancariaCan').blur(function() {
		if($('#numCtaBancariaCan').val() != '' && esTab == true){
			consultaCuentaBan(this.id);	
		} 

		if(isNaN($('#numCtaBancariaCan').val()) ){
			$('#numCtaBancariaCan').val("");
			$('#numCtaBancariaCan').focus();
			
		
		}

	});
	
//-- Lista de cheques emitidos--//
	$('#numChequeCan').bind('keyup',function(e) { 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionIDCan"; //DONDE MOSTRAR RESULTADO
		camposLista[1] = "numCtaBancariaCan";		
		camposLista[2] = "beneficiarioCan";	
		camposLista[3] = "tipoChequera";	
		parametrosLista[0] = $('#institucionIDCan').val();//FILTROS
		parametrosLista[1] = $('#numCtaBancariaCan').val();
		parametrosLista[2] = $('#numChequeCan').val();
		parametrosLista[3] = $('#tipoChequeraCan').val();
		lista('numChequeCan', '2', '3',  camposLista, parametrosLista, 'listaChequesEmitidos.htm');
	}); 	
	
	//-- Lista de cuentas que manejan chequera--//
	$('#numCtaBancaria').bind('keyup',function(e) { 
		if($('#emitidoEn').val() == 'V'){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "sucursalID"; //DONDE MOSTRAR RESULTADO
			camposLista[1] ="cajaID";		
			camposLista[2] = "institucionID";	
			parametrosLista[0] = parametroBean.sucursal;//FILTROS
			parametrosLista[1] = parametroBean.cajaID;
			parametrosLista[2] = $('#institucionID').val();		
			lista('numCtaBancaria', '2', '6',  camposLista, parametrosLista, 'listaCuentasConChequera.htm');
		}else if($('#emitidoEn').val() == 'T'){	
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "numCtaInstit";
			camposLista[1] = "institucionID";
			parametrosLista[0] = $('#numCtaBancaria').val();
			parametrosLista[1] = $('#institucionID').val();
			listaAlfanumerica('numCtaBancaria', '2', '7', camposLista,parametrosLista, 'ctaNostroLista.htm');	
		}
	}); 	
	 	
	$('#numCtaBancaria').blur(function() {
		if($('#numCtaBancaria').val()!='' && esTab == true){
		consultaCuentaBanNuevo(this.id);
		}
	});
	$('#institucionIDCan').blur(function() {	
	   consultaInstitucion(this.id, chequeCan);	
 	});	
   
	$('#institucionID').blur(function() {
		consultaInstitucion(this.id,chequeNue);
	});
   
	$('#numChequeCan').blur(function(){	  
	   consultaChequesEmi(this.id);	 
	  habilitaCampos();
	});
	$('#confimaNumCheque').blur(function(){
		if($('#numCheque').val() != '' && $('#confimaNumCheque').val()!=''&& $('#numCheque').val() != $('#confimaNumCheque').val()){
			mensajeSis('Los Números de Cheques no Coinciden');
			$('#confimaNumCheque').focus();
		}
	});
	$('#numCheque').blur(function(){
		if($('#numCheque').val()!='' &&  !isNaN($('#numCheque').val()) && esTab == true){
		habilitaBoton('cancelarCheque','submit');
		}
	});
  	$('#cancelarCheque').click(function(){  		
  		$('#tipoTransaccion').val(cat_TransCancelacionCheques.cancelarCheque);  	
  	});  
  	$('#imprimirCheque').click(function(){
  		imprimirCheque();
  		inicializaCampos();
  	});

   //Funcion de consulta para obtener el nombre de la institucion	
	function consultaInstitucion(idControl, idInst) {
		var jqInstituto = eval("'#" + idControl + "'");
		
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto!='' && !isNaN(numInstituto) && esTab == true){
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
		}else{				
			
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
					$('#numCtaBancariaCan').val(data.numCtaInstit);
					$('#tipoChequeraCan').val('');
					$('#numChequeCan').val("");
					$('#beneficiarioCan').val("");
					$('#montoCan').val("");
					$('#fechaCan').val("");
					$('#conceptoCan').val("");
					$('#institucionID').val("");
					$('#numCtaBancaria').val("");
					$('#tipoChequera').val("");
					$('#numCheque').val("");
					$('#confimaNumCheque').val("");
					$('#beneficiario').val("");
					$('#motivoCancela').val("");
					$('#usuarioAutoriza').val("");
					$('#passwdAutoriza').val("");
					$('#nombreInstitucion').val("");
					$('#ultimoChequeUtili').val("");
					deshabilitaBoton('cancelarCheque','submit');
					cargaTipoChequeraCan();
										
				}else{
					mensajeSis("No se encontró la cuenta bancaria.");
					$('#numCtaBancariaCan').val("");
					$('#numCtaBancariaCan').focus();
					$('#numChequeCan').val("");
					$('#tipoChequeraCan').val("");
					$('#tipoChequeraCan').val("").selected = true;
					$('#beneficiarioCan').val("");
					$('#montoCan').val("");
					$('#fechaCan').val("");
					$('#conceptoCan').val("");
					$('#institucionID').val("");
					$('#numCtaBancaria').val("");
					$('#tipoChequera').val("");
					$('#numCheque').val("");
					$('#confimaNumCheque').val("");
					$('#beneficiario').val("");
					$('#motivoCancela').val("");
					$('#usuarioAutoriza').val("");
					$('#passwdAutoriza').val("");
					$('#nombreInstitucion').val("");
					$('#ultimoChequeUtili').val("");
					deshabilitaBoton('cancelarCheque','submit');

				}
			});
		}
	}
 	function cargaTipoChequeraCan(){
		tipoChequeraBean = {
				'institucionID': $('#institucionIDCan').val(),
				'numCtaInstit': $('#numCtaBancariaCan').val()
				};
		
			cuentaNostroServicio.listaCombo(15,tipoChequeraBean,function(tiposChe){
				if(tiposChe!=''){
					dwr.util.removeAllOptions('tipoChequeraCan'); 
  			  		dwr.util.addOptions('tipoChequeraCan', {'':'SELECCIONAR'});
  			  		dwr.util.addOptions('tipoChequeraCan', tiposChe, 'tipoChequera', 'descripTipoChe');  
				}
			});	
		}
	
 	function cargaTipoChequera(){
		tipoChequeraBean = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': $('#numCtaBancaria').val()
				};
		
			cuentaNostroServicio.listaCombo(15,tipoChequeraBean,function(tiposChe){
				if(tiposChe!=''){
					dwr.util.removeAllOptions('tipoChequera'); 
  			  		dwr.util.addOptions('tipoChequera', {'':'SELECCIONAR'});
  			  		dwr.util.addOptions('tipoChequera', tiposChe, 'tipoChequera', 'descripTipoChe');  
				}
			});	
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
					$('#numCtaBancaria').val(data.numCtaInstit);
					$('#tipoChequera').focus();
					$('#beneficiario').val($('#beneficiarioCan').val());
					$('#ultimoChequeUtili').val('');
					$('#numCheque').val('');
					$('#confimaNumCheque').val('');
					$('#motivoCancela').val('');
					$('#usuarioAutoriza').val('');
					$('#passwdAutoriza').val('');
					deshabilitaBoton('cancelarCheque','submit');
					cargaTipoChequera();
										
				}else{
					mensajeSis("No se encontró la cuenta bancaria.");
					$('#numCtaBancaria').val('');
					$('#numCtaBancaria').focus();
					$('#tipoChequera').val('');
					$('#ultimoChequeUtili').val('');
					$('#numCheque').val('');
					$('#confimaNumCheque').val('');
					$('#beneficiario').val('');	
					$('#motivoCancela').val('');
					$('#usuarioAutoriza').val('');
					$('#passwdAutoriza').val('');
					deshabilitaBoton('cancelarCheque','submit');

				}
			});
		}
	}
	
	$('#tipoChequera').blur(function(){
		$('#ultimoChequeUtili').val('');
		$('#numCheque').val('');
		$('#confimaNumCheque').val('');
		$('#motivoCancela').val('');
		$('#usuarioAutoriza').val('');
		$('#passwdAutoriza').val('');
		consultaFolioUtilizar();

	});
	
	function consultaFolioUtilizar(){
		var valorChequera=$('#tipoChequera option:selected').val();
		var tipoConsulta=2;
		var asignaChequeBean={
			'institucionID': $('#institucionID').val(),
			'numCtaInstit': $('#numCtaBancaria').val(),
			'sucursalID'  : sucursalID,
			'cajaID': cajaID,
			'tipoChequera': valorChequera
		};			
		
		asignarChequeSucurServicio.consulta(tipoConsulta,asignaChequeBean,function(folio){				
			if(folio!=null){
				$('#ultimoChequeUtili').val(folio.folioUtilizar);
				
				if(valorChequera == 'P'){
					consultaRutaChequeProforma(valorChequera);
				}else if(valorChequera == 'E'){
					consultaRutaChequeEstan(valorChequera);
				}

			}else{
				mensajeSis('El Número de Cuenta no esta asignada a la Sucursal o a la Caja.');
				$('#numCtaBancaria').focus();
				$('#numCtaBancaria').val('');
				$('#tipoChequera').val('');
			}
		});
	}
	
	function consultaRutaChequeProforma(valorChequera){
		var tipoConsulta=13;
		var cuentasNostroBean = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': $('#numCtaBancaria').val(),
				'tipoChequera'	: valorChequera
			};
		setTimeout("$('#cajaLista').hide();", 200);		
		cuentaNostroServicio.consulta(tipoConsulta,cuentasNostroBean,function(ruta){
			if(ruta!=null){
				var str=ruta.rutaCheque;		
				var res = str.split(".");
				$('#rutaCheque').val(res[0]);
			}
		});				
	}
	
	function consultaRutaChequeEstan(valorChequera){
		var tipoConsulta=16;
		var cuentasNostroBean = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': $('#numCtaBancaria').val(),
				'tipoChequera'	: valorChequera
			};
		setTimeout("$('#cajaLista').hide();", 200);		
		cuentaNostroServicio.consulta(tipoConsulta,cuentasNostroBean,function(ruta){
			if(ruta!=null){
				var str=ruta.rutaChequeEstan;		
				var res = str.split(".");
				$('#rutaCheque').val(res[0]);
			}
		});				
	}
	
	
		
	 //Funcion de consulta para obtener datos del cheque que fue emitido y se va a cancelar
	function consultaChequesEmi(idControl) {
		var jqNumCheque = eval("'#" + idControl + "'");
		var numCheque = parseFloat($(jqNumCheque).val());
		var valorChequera=$('#tipoChequeraCan option:selected').val();
		var tipoConsulta=17;
		setTimeout("$('#cajaLista').hide();", 200);	
		var ChequeBeanCon = {
				'institucionID'	: $('#institucionIDCan').val(),
				'numCtaInstit': $('#numCtaBancariaCan').val(),			
				'cuentaClabe'		: numCheque,		
				'tipoChequera'		: valorChequera
		};
		
		if(numCheque!='' && !isNaN(numCheque) && esTab){
			cuentaNostroServicio.consulta(tipoConsulta,ChequeBeanCon,function(cheque){		
					if(cheque!=null){						
						$('#beneficiarioCan').val(cheque.beneficiarioCan);
						$('#montoCan').val(cheque.monto);				
						$('#montoCan').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n', 
							roundToDecimalPlace: 2	
						});						
						$('#conceptoCan').val(cheque.concepto);
						$('#fechaCan').val(cheque.fechaEmision);						
						$('#institucionID').focus();
						$('#emitidoEn').val(cheque.emitidoEn);
						if($('#emitidoEn').val() == 'V'){
							$('#fieldsetAutoriza').show();
							}else{
								$('#fieldsetAutoriza').hide();
							}
						if(parametroBean.cajaID == '' && $('#emitidoEn').val() == 'V'){//si el usuario logueado no tiene caja							
							$('#institucionID').val($('#institucionIDCan').val());
							$('#nombreInstitucion').val($('#nombreInstitucionCan').val());
							$('#numCtaBancaria').val($('#numCtaBancariaCan').val());
							$('#beneficiario').val($('#beneficiarioCan').val());
							$('#institucionID').attr('readOnly','true');
							$('#numCtaBancaria').attr('readOnly','true');
							consultaFolioUtilizar();
							$('#numCheque').focus();
						}else if(parametroBean.cajaID == '' && $('#emitidoEn').val() == 'T'){
							$('#institucionID').removeAttr('readOnly');
							$('#numCtaBancaria').removeAttr('readOnly');	
							$('#beneficiario').val($('#beneficiarioCan').val());
						}
					}else{
						mensajeSis("El Número de Cheque no Existe o se Encuentra Pagado,Cancelado, Reemplazado o Conciliado");
						inicializaForma('formaGenerica', 'institucionIDCan');
						$('#institucionIDCan').val('');
						$('#institucionIDCan').focus();
						deshabilitaBoton('cancelarCheque','submit');
					}    						
				});
		}else{
			deshabilitaBoton('cancelarCheque','submit');
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
  			numCtaBancariaCan:{
  				required: true,	
  				maxlength: 25,
  				minlength: 1
  			},
  			tipoChequeraCan:{
  				required:true
  			},
  			numChequeCan:{
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
  			numCtaBancaria:{
  				required:true
  			},
  			tipoChequera:{
  				required:true
  			},
  			numCheque:{
  				required:true
  			},
  			confimaNumCheque:{
  				required:true
  			},
  			motivoCancela:{
  				required: true
  			}
  		},  		
  		messages: {
  			institucionIDCan: {
  				required: 'Especifique la Institución.', 				
  			},
  			numCtaBancariaCan:{
  				required: 'Especifique el Número de Cuenta.',	
  				maxlength: 'Máximo 25 Caracteres.',
  				minlength: 'Mínimo 1 Cacter.',
  			},
  			tipoChequeraCan:{
  				required:'Especifique el Formato del Cheque a Cancelar'
  			},
  			numChequeCan:{
  				required:'Especifique el Número de Cheque.'
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
  			numCtaBancaria:{
  				required:'Especifique el Número de Cuenta.'
  			},
  			tipoChequera:{
  				required:'Especifique el Formato de Cheque.'
  			},
  			numCheque:{
  				required:'Especifique el Número de Cheque.'
  			},
  			confimaNumCheque:{
  				required:'Especifique el Número de Cheque'
  			},
  			motivoCancela:{
  				required: 'Especifique el Motivo de Cancelación'
  			}
  		}		
  	});
});

//metodo para la impresion del cheque 
function imprimirCheque(){	
	var numeroPoliza = parseInt($('#numeroPoliza').val());	
	var numSucursal= parametroBean.sucursal;
	var moneda = 1;
	var fechaEmision =parametroBean.fechaAplicacion;
	var nombreOperacion = limpiarCaracteresEsp($('#conceptoCan').val());
	var nombreBeneficiario = $('#beneficiario').val();
	var monto = $('#montoCan').asNumber();
	var usuarioCheque = parametroBean.claveUsuario;
	var numTran = 0;
	var nombreRutaCheque = $('#rutaCheque').val();	
	
	
	window.open('imprimeCheque.htm?polizaID='+numeroPoliza+'&nombreReporte='+nombreRutaCheque+'&numeroTransaccion='+numTran+
			'&sucursalID='+numSucursal+'&monedaID='+moneda+'&fechaEmision='+fechaEmision+'&nombreOperacion='+
			nombreOperacion+'&nombreBeneficiario='+nombreBeneficiario+'&monto='+monto+'&nombreUsuario='+usuarioCheque,'_blank');
	deshabilitaBoton('imprimirCheque','button');

}

function limpiaCamposChequeCancela(){	
	$('#numCtaBancariaCan').val("");		
	$('#numChequeCan').val("");
	$('#beneficiarioCan').val("");
	$('#montoCan').val("");
	$('#fechaCan').val("");
	$('#conceptoCan').val("");
	$('#institucionID').val("");
	$('#numCtaBancaria').val("");
	$('#tipoChequera').val("");
	$('#tipoChequeraCan').val("");
	$('#numCheque').val("");
	$('#confimaNumCheque').val("");
	$('#beneficiario').val("");
	$('#motivoCancela').val("");
	$('#usuarioAutoriza').val("");
	$('#passwdAutoriza').val("");
	$('#nombreInstitucion').val("");
	$('#ultimoChequeUtili').val("");
	deshabilitaBoton('cancelarCheque','submit');
}   

function limpiaCamposNuevoCheque(){	
	$('#numCtaBancaria').val('');
	$('#tipoChequera').val("");
	$('#ultimoChequeUtili').val('');
	$('#numCheque').val('');
	$('#confimaNumCheque').val('');
	$('#beneficiario').val('');	
	$('#motivoCancela').val("");
	$('#usuarioAutoriza').val("");
	$('#passwdAutoriza').val("");
	deshabilitaBoton('cancelarCheque','submit');
} 

function inicializaCampos(){
	$('#institucionIDCan').val("");
	$('#institucionIDCan').focus();
	$('#nombreInstitucionCan').val("");
	$('#numCtaBancariaCan').val("");		
	$('#numChequeCan').val("");
	$('#tipoChequeraCan').val("");
	$('#beneficiarioCan').val("");
	$('#montoCan').val("");
	$('#fechaCan').val("");
	$('#conceptoCan').val("");
	$('#institucionID').val("");
	$('#numCtaBancaria').val("");
	$('#tipoChequera').val("");
	$('#numCheque').val("");
	$('#confimaNumCheque').val("");
	$('#beneficiario').val("");
	$('#motivoCancela').val("");
	$('#usuarioAutoriza').val("");
	$('#passwdAutoriza').val("");
	$('#nombreInstitucion').val("");
	$('#ultimoChequeUtili').val("");
	$('#fieldsetAutoriza').hide();
	$('#usuarioLogin').val(parametroBean.numeroUsuario);
	deshabilitaBoton('cancelarCheque','submit');
}

function habilitaCampos(){
	 $('#institucionID').removeAttr('disabled');
	   $('#numCtaBancaria').removeAttr('disabled');
	   $('#numCheque').removeAttr('disabled');
	   $('#confimaNumCheque').removeAttr('disabled');
	   $('#beneficiario').removeAttr('disabled');
	   $('#motivoCancela').removeAttr('disabled');
	   $('#usuarioAutoriza').removeAttr('disabled');
	   $('#passwdAutoriza').removeAttr('disabled');
	   $('#institucionID').val('');
	   $('#numCtaBancaria').val('');
	   $('#tipoChequera').val("");
	   $('#numCheque').val('');
	   $('#confimaNumCheque').val('');
	   $('#beneficiario').val('');
	   $('#motivoCancela').val('');
	   $('#usuarioAutoriza').val('');
	   $('#passwdAutoriza').val('');
	   $('#nombreInstitucion').val('');
	   $('#ultimoChequeUtili').val('');
}

function funcionExito(){	
	deshabilitaBoton('cancelarCheque','submit');	
	$('#numeroPoliza').val($('#consecutivo').val());
	if($('#numCheque').val()!='' &&  !isNaN($('#numCheque').val())){
	habilitaBoton('imprimirCheque','button');
	}
	$('#nombreInstitucionCan').attr('disabled','true');
	$('#beneficiarioCan').attr('disabled','true');
	$('#montoCan').attr('disabled','true');
	$('#conceptoCan').attr('disabled','true');
	$('#fechaCan').attr('disabled','true');
	$('#usuarioAutoriza').attr('disabled','true');
	$('#passwdAutoriza').attr('disabled','true');
	$('#motivoCancela').attr('disabled','true');
	$('#institucionID').attr('disabled','true');
	$('#nombreInstitucion').attr('disabled','true');
	$('#numCtaBancaria').attr('disabled','true');
	$('#ultimoChequeUtili').attr('disabled','true');
	$('#numCheque').attr('disabled','true');
	$('#confimaNumCheque').attr('disabled','true');
	$('#beneficiario').attr('disabled','true');
		
}

function funcionFallo(){
	
}


/*funcion para limpiar caracteres especiales*/
function limpiarCaracteresEsp(cadena){
	 // Definimos los caracteres que queremos eliminar
   var specialChars = "!@$^%*()+=-[]\/{}|:<>?,.";
   // Elimina caracteres especiales
   for (var i = 0; i < specialChars.length; i++) {
       cadena= cadena.replace(new RegExp("\\" + specialChars[i], 'gi'), '');
   }   

   // Se cambia las letras por valores URL
   cadena = cadena.replace(/&/gi,"%26");
   cadena = cadena.replace(/#/gi,"%23");
  
   return cadena;

}
