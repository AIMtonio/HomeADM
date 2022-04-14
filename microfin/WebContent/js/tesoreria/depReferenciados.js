 var listaPersBloqBean = {
                    'estaBloqueado' :'N',
                    'coincidencia'  :0
            };
            
            var consultaSPL = {
            		'opeInusualID' : 0,
            		'numRegistro' : 0,
            		'permiteOperacion' : 'S',
            		'fechaDeteccion' : '1900-01-01'
            };
            
            var esCliente           ='CTE';
            
$(document).ready(function() {
		esTab = true;
		
	 var montoCuenta = null;
	 agregaFormatoControles('formaGenerica');
	
	 $('#institucionID').focus();
	 //Definicion de Constantes y Enums  
		var catTipoTransaccionDep = {
		  		'procesar':'1',
		  		
			};
	 
	var catTipoTransaccionConciliacion = {
  		'graba':'1',
  		'modifica':'2',
  		'elimina':'3'
	};
	
	var catTipoConsultaConciliacion = {
  		'principal':1,
  		'foranea':2
	};	

	var catTipoConsultaInstituciones = {
  		'principal':1, 
  		'foranea':2
	};
	
	var catTipoConsultaSucursales = {
  		'principal':1, 
  		'foranea':2,
  		'porCuentasAho':3
	};
	var catTipoConsultaDispersion = {
  		'principal':1 
  		
	};
	
	var catTipoTransaccionCtaAho = {
  		'grabar':'1'
	};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	deshabilitaBoton('procesar', 'submit');
	

	
	$('#folioOperacion').blur(function() {
		validaFolio(this.id);
			
	});
	
   var parametroBean = consultaParametrosSession();
	$('#fechaActual').val(parametroBean.fechaSucursal);
		
	$('#procesar').click(function(event) {	
		$('#tipoTransaccion').val(catTipoTransaccionDep.procesar);	
		
	});	
	
	$('#grabar').click(function(event) {	
		$('#tipoTransaccion').val(catTipoTransaccionCtaAho.grabar);	
	});	
	
	$('#modificar').click(function(event) {	
		$('#tipoTransaccion').val(catTipoTransaccionConciliacion.modifica);	
	});			
	
	$('#ventana').click(function(event) {	
      $.post("/ejem/ventana.jsp");
	});	
	
	
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	
	$('#institucionID').blur(function() {
		if($('#institucionID').val() != ''  && esTab){
			consultaInstitucion(this.id);
		}else {
			$('#cuentaAhorroID').val("");
			$('#contenedorDeps').html("");
			$('#institucionID').focus();
		}
		
		if(isNaN($('#institucionID').val()) ){
			$('#institucionID').val("");
			$('#institucionID').focus();
			$('#cuentaAhorroID').val("");
			$('#contenedorDeps').html("");
			
		
		}
	});
	
	
	$('#cuentaAhorroID').bind('keyup',function(e){
    	var camposLista = new Array();
		var parametrosLista = new Array();
			camposLista[0] = "institucionID";
            parametrosLista[0] = $('#institucionID').val();
                        
            camposLista[1] = "cuentaAhoID";			
            parametrosLista[1] = $('#cuentaAhorroID').val();
                    
		lista('cuentaAhorroID', '2', '2', camposLista, parametrosLista, 'tesoCargaMovLista.htm');	       
    });
	
	
	 

	
	$('#cuentaAhorroID').blur(function() {
	
		if($('#cuentaAhorroID').val() != '' && !isNaN($('#cuentaAhorroID').val()) && esTab){
		 validaCuentaAhorro(this.id);
		  }
		
		if(isNaN($('#cuentaAhorroID').val()) ){
			$('#cuentaAhorroID').val("");
			$('#cuentaAhorroID').focus();
			$('#contenedorDeps').html("");
		
		}
	});
	


	
	function validaCuentaAhorro(idControl){
	
        	var tipoConsulta = 9;
			var DispersionBeanCta = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': $('#cuentaAhorroID').val()
				};
			
				
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				
						if(data!=null){
							$('#cuentaAhorroID').val(data.numCtaInstit);
							$('#numCtaInstit').val(data.cuentaAhorro);
						    $('#nombreSucurs').val(data.nombreCuentaInst);
						    pegaHtml($('#institucionID').val(),data.numCtaInstit);
						   
						}else{
							alert("La Cuenta Bancaria no Existe");
							$('#contenedorDeps').html("");
							$('#cuentaAhorroID').val("");
							$('#cuentaAhorroID').focus();
						}
					});
			
		}

  
  
	function validaFolio(idControl){
		
		var jqFolio = eval("'#" + idControl + "'");
		var numFolio = $(jqFolio).val();
			
		if(numFolio == 0 && numFolio != '' && esTab){
			habilitaBoton('grabar', 'submit');
         //limpiarMovimientos();
         		
		}if
		(numFolio != 0 && numFolio != '' && esTab){
        
         var DispersionBeanCta = {
				'folioOperacion': $('#folioOperacion').val()
			};
			operDispersionServicio.consulta( catTipoConsultaDispersion.principal, DispersionBeanCta, function(dispBean){
						if(dispBean!=null){
							var fechaDeOp = dispBean.fechaOperacion;
							$('#fechaActual').val(fechaDeOp.substr(0,10));//sin formato (yyyy-mm-dd hh-mm-ss)
							$('#institucionID').val(dispBean.institucionID);
							      consultaInstitucion('institucionID');
							$('#cuentaAhorro').val(dispBean.cuentaAhorro);
							      validaCuentaAhorro(); 
							 
 						    $('#tableCon').show();  
							 habilitaBoton('modificar', 'submit');  
							  agregaFormatoControles('formaGenerica');//******************************************
							 
						}else{
							alert("No existe el Folio de Operación");
							$('#folioOperacion').focus();
						}
			});
			// call  DISPERSIONMOVLIS(?,?,?,?,?,?,?,?) // sp lista
		}
	}
	

	
	function pegaHtml(institucionID,numCtaInstit){	
		
		var params = {};
		params['institucionID'] = institucionID;
   	    params['numCtaInstit'] = numCtaInstit;
		params['tipoConsulta'] =  1;
		
		$.post("depositosReferen.htm", params, function(data){
				if(data.length > 0) {
					
						$('#contenedorDeps').html(data);
						$('#contenedorDeps').show();
						agregaCuentasAho();
			
					        	if($('#numeroDetalle').val() >= 1){
					        		habilitaBoton('procesar', 'submit');	
					        	}
					        	else{
					        		deshabilitaBoton('procesar', 'submit');	
									
							}		
					        	
				}
				else{
					
						$('#contenedorDeps').html("");
						$('#contenedorDeps').show();
						
				}
		});
	}
	function agregaCuentasAho(){
		
	 	var total = $('#numeroDetalle').val();
	 	var totalInt= parseInt(total);
	 	for(var i=1;i<=totalInt; i++){
	 			var ctaAhoID = eval("'#cuentaAhoID" + i + "'");
	 		   var ctaAhoIDlbl = eval("'#lblcuentaAhoID" + i + "'");
            var cuentaAhorro = $('#numCtaInstit').val();	
                      
            var label= '<label for='+'"lblcuentaAhoID'+i+'"'+' style="color:black;">'+cuentaAhorro+'</label>';			
	 			$(ctaAhoID).val(cuentaAhorro);
	 			$(ctaAhoIDlbl).replaceWith(label);
	 	 		
	 }	
	}
		
	
	 function agregaNombresClientes(){
	 	var total = $('#numeroDetalle').val();
	 	var totalInt= parseInt(total);
	 	for(var i=1;i<=totalInt; i++){
	 			var ctaAhoID = eval("'cuentaAhoID" + i + "'");
	 			var nombreCte =eval("'nombreCte" + i + "'");
	 			var clienteId = eval("'clienteID" + i + "'");
	 			var saldo = eval("'saldo" + i + "'");
	 			maestroCuentasDescripcion(ctaAhoID, nombreCte, clienteId, saldo);
	 			
	 			var tipoMov= eval("'tipoMov" + i + "'");
	 			var nombreBenefi= eval("'nombreBenefi" + i + "'");
	 			var fechaEnvio= eval("'fechaEnvio" + i + "'");
	 			validaTipoMov(tipoMov,nombreBenefi,fechaEnvio);
	 		}
	 	
	 }
	 
	
	
	//Método de consulta de Institución
	
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};

		if(numInstituto != '' && !isNaN(numInstituto)  ){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea, InstitutoBeanCon, function(instituto){
				if(instituto!=null){	
					
					
					$('#nombreInstitucion').val(instituto.nombre);
					$('#cuentaAhorroID').val("");
					$('#nombreSucurs').val("");
					
					$('#tableCon').hide();
					$('#tableCon').val("");
					deshabilitaBoton('procesar', 'submit');
					
					
					
				}else{
					alert("No se encontró la Institución");
					$('#institucionID').focus();
					$('#institucionID').val("");
					$('#nombreInstitucion').val("");
					$('#cuentaAhorroID').val("");
					$('#nombreSucurs').val("");
					$('#contenedorDeps').html("");
				
				//	 $('#contenedorDeps').hide();
					$('#tableCon').hide();
					
					deshabilitaBoton('procesar', 'submit');
				
				}    
				
				
			});
		}
	
	}

	//Método de consulta para el nombre de sucursal
	function consultaSucursal(idControl){
		var jqControl = eval("'#" + idControl + "'");
		var numControl = $(jqControl).val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		var sucursalesBean = {
  				'nombreSucurs': numControl,
  				'sucursalID': $('#institucionID').val()
				};	
				
		if(numControl != '' && !isNaN(numControl) && esTab){
			sucursalesServicio.consulta(sucursalesBean,catTipoConsultaSucursales.porCuentasAho,function(sucursal){
						if(sucursal!=null){							
							$('#nombreSucurs').val(sucursal.nombreSucurs);									
						}   						
				});
		}		
	}
	
	
	$.validator.setDefaults({
		submitHandler: function(event) { 	
				grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuentaAhorroID');
			}
	});
	

	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			institucionID	: 'required',
			cueClave		: 'required'
		},
		
		messages: {
			institucionID	: 'Especifique Institucion',
			cueClave		: 'Especifique Cuenta Bancaria'
		}		
	});
	
	//deshabilitaBoton('exportar', 'submit');
	$('#exportar').click(function(event) {
        var folioOperacion = $('#folioOperacion').val();
        $('#enlace').attr('href','exportaDispercionTxt.htm?folioOperacion='+folioOperacion);
	});
	
	
//Fin del jquery
});



	function obtenerCuenta(idControl){
	
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "clienteID";
		parametrosLista[0] = document.getElementById(idControl).value;
		
		if(document.getElementById(idControl).value != ""){
			lista(idControl, '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}
	}
   
   
	function maestroCuentasDescripcion(idControl, fila, cliente, saldo){ 	
		
		var numCta = document.getElementById(idControl).value;
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta
		};
				
		if(numCta != '' && !isNaN(numCta) && esTab){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){	
							document.getElementById(cliente).value = cuenta.clienteID;
							document.getElementById(idControl).value = cuenta.cuentaAhoID;
							
							consultaClientePantalla(cuenta.clienteID, fila);
							consultaCtaAho(idControl, cuenta.clienteID, saldo);
						}else{
							alert("No Existe la cuenta de ahorro");
							document.getElementById(idControl).focus();
						}
				});															
		}
	}
	
	function consultaClientePantalla(numCliente, fila) {
		var conCliente =5;
		var rfc = ' ';
						
		if(numCliente != '' && !isNaN(numCliente)&& esTab){
			clienteServicio.consulta(conCliente, numCliente, rfc, function(cliente){
						if(cliente!=null){		
							var tipo = (cliente.tipoPersona);
							if(tipo=="F"){
								document.getElementById(fila).value = cliente.nombreCompleto;
							}
							if(tipo=="M"){
								document.getElementById(fila).value = cliente.razonSocial;
							}							
						}else{
							alert("No Existe el Cliente");
						}    						
				});
			}
	}
	
	function consultaCtaAho(cuenta, clienteID, saldo) {
		var numCta = document.getElementById(cuenta).value;
		var catTipoConsultaCuentas = 5;
		var CuentaAhoBeanCon = {
			'cuentaAhoID': numCta,
			'clienteID': clienteID
		};
		
     if(numCta != '' && !isNaN(numCta) && esTab){
          cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCuentas, CuentaAhoBeanCon, function(cuenta) {
          	if(cuenta.saldoDispon!=null){
          			document.getElementById(saldo).value = cuenta.saldoDispon;
          	}else{
          		alert("La Cuenta no Existe");
          	}
          });                                                                                                                        
        }
	}	
	
  	function validarMonto(idControl, saldo){
		
  		var saldoDisponible = convierteStrInt(document.getElementById(saldo).value);
  		var monto = convierteStrInt(document.getElementById(idControl).value);
  		
  		if(monto > saldoDisponible){
  			alert("El monto es superior al disponible");
  			document.getElementById(idControl).focus();
  		}
  		
	}   
	
  	function validaSpei(idControl, cuentaClabe){
  		var esSpei = document.getElementById(idControl).value;
  		var numero = document.getElementById(cuentaClabe).value;
  		
  		if(esSpei == '1' && numero != ''){
	  		if(numero.length == 18 && numero != ''){
	  			if(!isNaN(numero)){
	  				
	  				var institucion= numero.substr(0,3);
	  				var tipoConsulta = 3;
	  				var DispersionBean = {
							'institucionID': institucion
	  					};
	  				
	  				institucionesServicio.consultaInstitucion(tipoConsulta, DispersionBean, function(data){
						if(data==null){
							alert('La cuenta clabe no coincide con ninguna institución financiera registrada');
							document.getElementById(cuentaClabe).focus();
						}
				   });
	  			}
	  		}else{
	  			alert("La cuenta clable tiene que tener 18 caracteres");
	  			document.getElementById(cuentaClabe).focus();
	  		}
  		}
  		return false;
	}
	
 	function validaFecha(idControl, fecha){
  		var esSpei = document.getElementById(idControl).value;
  		var fechaEnvio = document.getElementById(fecha).value;
  		
  		if(esSpei == '1' && fechaEnvio == ''){
  		alert("La fecha de envio esta vacia.");
  		$('#'+fecha).focus();
  		}
  			
  	}	
	
 function convierteStrInt(cadena){
		var re = /,/g;
		var cantidad  = cadena.replace(re, "");
		return  parseFloat(cantidad);
	} 
 
function cambiaStatus(fila, nuevaFila){
	
		if(document.getElementById(fila).checked){
			document.getElementById(nuevaFila).value="C";	
		}else{
			document.getElementById(nuevaFila).value="NI";
		
		}
	}

function cambiaReferencia(){
		var total = $('#numeroDetalle').val();
	 	var totalInt= parseInt(total);
	 	for(var i=1;i<=totalInt; i++){
	 			var estCheckBox = eval("'#estatusHidden" + i + "'");
	 			var refConfirma = eval("'#rerefenConfirmar" + i + "'");
	 			var movRefe		= eval("'#referenciaMov" + i + "'");
	 			var valorNuevo = $(refConfirma).val();
	 			if($(estCheckBox).val() == "C"){
	 					if($(refConfirma).val() != ''){
	 						
	 						$(movRefe).val(valorNuevo);
	 					}

	 			}	
	 		}

}


function habilitaLimpiar(idControl){
	
	var cont = 0;
	var numReg = ($('#tableCon >tbody >tr').length) - 1;

	$('input[name=estatus]').each(function () {
		if ($(this).is(':checked')){
			cont ++;
		}
	});
	if (cont > 0 ) {
		habilitaBoton('procesar');
	}else{
		deshabilitaBoton('procesar');
	}
}

function valiaPLB(idControl, idReferenciaMov,idRefValida,idTipoCanal){
	var jqControl  = eval("'#"+idControl+"'"); 
	var jqTipoCanal = eval("'#"+idTipoCanal+"'");
	var control = $(jqControl).val();
	var tipoCanal = $(jqTipoCanal).val();
	 if(control != '' && !isNaN(control) && esTab){
		 	if(tipoCanal == 1){
		 		 validaCredito(idControl, idReferenciaMov,idRefValida);
		 	}
		 	if(tipoCanal == 2){
		 		validaCuenta(idControl, idReferenciaMov,idRefValida);
		 	}
		 	if(tipoCanal == 3){
		 		validaCliente(idControl, idReferenciaMov,idRefValida);
		 	}
	 }
}



function validaCredito(idControl, idReferenciaMov,idRefValida){
	var jqCredito = eval("'#"+idControl+"'"); 
	var jqValida = eval("'#"+idRefValida+"'");

	var numCredito = $(jqCredito).val();
	 var referenciaMov =idReferenciaMov;
	 var creditoBeanCon = {
             'creditoID' : numCredito
     };
     creditosServicio.consulta(1,creditoBeanCon, { async: false, callback: function(credito) {
         if (credito != null) {
        	 listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
				consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);
				if(listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'N'){
					$(jqValida).val(referenciaMov);
					$(jqCredito).val(''),
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
					
				}
         }
     }
     });
}

function validaCuenta(idControl, idReferenciaMov,idRefValida){
	var jqCuenta = eval("'#"+idControl+"'"); 
	var jqValida = eval("'#"+idRefValida+"'");
	var numCuenta = $(jqCuenta).val();
	 var referenciaMov =idReferenciaMov;
	 
	 var CuentaAhoBeanCon = {
				'cuentaAhoID' : numCuenta
			};
	 cuentasAhoServicio.consultaCuentasAho(1,CuentaAhoBeanCon, { async: false, callback:function(cuenta) {
			if (cuenta != null) {
				listaPersBloqBean = consultaListaPersBloq(cuenta.clienteID, esCliente, 0, 0);
				consultaSPL = consultaPermiteOperaSPL(cuenta.clienteID,'LPB',esCliente);
				if(listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'N'){
					$(jqValida).val(referenciaMov);
					$(jqCuenta).val(''),
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
					
				}
			}
	 }
	 });
}


function validaCliente(idControl, idReferenciaMov,idRefValida){
	var jqCliente = eval("'#"+idControl+"'"); 
	var jqValida = eval("'#"+idRefValida+"'");
	var numCliente = $(jqCliente).val();
	 var referenciaMov = idReferenciaMov;
	 
	 if(numCliente!= null || numCliente != ''){
		 listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
			consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB',esCliente);
			if(listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'N'){
				$(jqValida).val(referenciaMov);
				$(jqCliente).val(''),
				mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				
			}
		 
	 }
	
}

