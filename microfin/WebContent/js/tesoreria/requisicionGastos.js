$(document).ready(function() {
	// Definicion de Constantes y Enums	
	var esTab = true;
	var parametroBean = consultaParametrosSession();									  
		
	var catTipoTransaccionRequisicion = {
	  	'agregar'	:1,
	  	'modificar'	:2,
		'cancelar'	:3
	};
	
	var catTipoConsultaRequisicion = {
		'principal':1
	};

	var catTipoListaTipoRequisicion = {
		'principal':1
	};
	var catTipoConsultaCentroCosto ={
		'principal':1
	};	
	
	var catTipoListaTipoGasto = {
		'principal':1
	};

	var catTipoConsultaTipoGasto = {
		'principal':1
	};		

	var catStatusRequisicion = {
		'alta':		'Alta',
	  	'cancelada': 	'Cancelado',
	  	'autorizada':	'Autorizada',
		'procesada':	'Procesada'
	};

	$(':text').focus(function() {			
	 	esTab = false;
	});

     //$('#resulTipoPago').hide();  
     document.getElementById('resTipoPagolbl').style.display='none'; 
     document.getElementById('numCtaInstit').style.display='none'; 
	$('#requisicionID').focus();
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	agregaFormatoControles('formaGenerica');
	
	$('#requisicionID').click(function(){
		$('#requisicionID').select();
		$('#requisicionID').focus();
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('cancelar', 'submit');	
	});

	$('#requisicionID').blur(function(){
		validaRequisicion(this.id);
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
    
   $("#tipoPago").change(function() {
         var tipoDePago = $("#tipoPago").val();
         if(tipoDePago=='sp'){
          document.getElementById('resTipoPagolbl').style.display='inline'; 
          document.getElementById('numCtaInstit').style.display='inline';       
         }
         if(tipoDePago=='ch'){
           document.getElementById('resTipoPagolbl').style.display='none'; 
           document.getElementById('numCtaInstit').style.display='none'; 
            $('#numCtaInstit').val(""); 
         }
         // else es cheque, pendiente
   });

	$.validator.setDefaults({
		submitHandler: function(event) { 				
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','requisicionID');
			deshabilitaBoton('agregar', 'submit');
			deshabilitaBoton('modificar', 'submit');
			deshabilitaBoton('cancelar', 'submit');
		}
	});
	
	$('#agregar').click(function() {		 
		$('#tipoTransaccion').val(catTipoTransaccionRequisicion.agregar);
	});
	
	$('#modificar').click(function() {		 
		$('#tipoTransaccion').val(catTipoTransaccionRequisicion.modificar);
	});	
	
	$('#requisicionID').bind('keyup',function(e){

		if(this.value.length >= 2){
                        var camposLista = new Array();
                        var parametrosLista = new Array();
                        
                        camposLista[0] = "descripcionRG";
                        
                        parametrosLista[0] = $('#requisicionID').val();
                                                
                        lista('requisicionID', '2', catTipoListaTipoRequisicion.principal, camposLista, parametrosLista, 'listaRequisicionGastos.htm');
                }
	});
	function consultarTipoGastoLista(){
		$('#tipoGastoID').bind('keyup',function(e){

		if(this.value.length >= 2){
                        var camposLista = new Array();
                        var parametrosLista = new Array();
                        
                        camposLista[0] = "descripcionTG";
                        parametrosLista[0] = $('#tipoGastoID').val();
                                                
                        lista('tipoGastoID', '2', catTipoListaTipoGasto.principal, camposLista, parametrosLista, 'requisicionTipoGastoListaVista.htm');
                }
		});
	}
	$('#tipoGastoID').blur(function(){
		consultaTipoGasto(this.id);
	});

	$('#centroCostoID').bind('keyup',function(e){
		lista('centroCostoID', '2', '1', 'descripcion', $('#centroCostoID').val(), 'listaCentroCostos.htm');
	});
	$('#centroCostoID').blur(function() {
  		validaCentroCostos(this.id);
	});
   
   $('#numCtaInstit').blur(function(){
       if($('#numCtaInstit').val()!='') validaSpei('numCtaInstit');	
   });
    
//-----------------------------------------------------------------------------------------------------/
	function consultaTipoGasto(idControl){
		var jqTipoGasto = eval("'#" + idControl + "'");
		var numTipoGasto = $(jqTipoGasto).val();
		esTab = true;
		if(numTipoGasto != '' && !isNaN(numTipoGasto) && esTab){
			var RequisicionTipoGastoListaBean = {
			   			'tipoGastoID' : numTipoGasto
			};
			requisicionGastosServicio.consultaTipoGasto(catTipoConsultaTipoGasto.principal,RequisicionTipoGastoListaBean,function(tipoGastoCon){
					if(tipoGastoCon!=null){
						$('#descripcionTG').val(tipoGastoCon.descripcionTG);
					}else{
						alert("No existe el Tipo de Gasto");
						$(jqTipoGasto).focus();
						$(jqTipoGasto).select();						
					}	
			});				
		}
	}
//*****************************************************************************************************------------------------------------------------/
	function validaRequisicion(idControl){
		var jqRequisicion = eval("'#" + idControl + "'");
		var numRequisicion = $(jqRequisicion).val();
		deshabilitaBoton('agregar', 'submit'); 
				
		if(numRequisicion == 0 && numRequisicion != '' && esTab){
			habilitaBoton('agregar', 'submit');
			inicializaForma('formaGenerica','requisicionID');	

			$('#sucursalID').val(parametroBean.numeroSucursalMatriz);
			$('#nombreSucursal').val(parametroBean.nombreSucursalMatriz);
			$('#usuarioID').val(parametroBean.numeroUsuario);   
			$('#nombreUsuario').val(parametroBean.nombreUsuario);           
		   document.getElementById('resTipoPagolbl').style.display='none'; 
         document.getElementById('numCtaInstit').style.display='none'; 
			consultarTipoGastoLista();
				
		}else{
			if(esTab){

	  	     		if(numRequisicion != ''){
					var RequisicionGastosBean = {
			   			'requisicionID' : numRequisicion
					};
		                        requisicionGastosServicio.consulta(catTipoConsultaRequisicion.principal,RequisicionGastosBean, function(requisicionCon){
				        	if(requisicionCon!=null){						
			        			var estatus = requisicionCon.status;
							var varError = 1;
							if(requisicionCon.tipoPago=="sp"){
								 document.getElementById('resTipoPagolbl').style.display='inline'; 
                         document.getElementById('numCtaInstit').style.display='inline';       
							}
							if(requisicionCon.tipoPago=="ch"){
								 document.getElementById('resTipoPagolbl').style.display='none'; 
                         document.getElementById('numCtaInstit').style.display='none';
                              
							}
							dwr.util.setValues(requisicionCon);
							
							
							if(estatus == catStatusRequisicion.cancelada){
									//dwr.util.setValues(requisicionCon);
									$('#requisicionID').focus();
									$('#nombreSucursal').val(parametroBean.nombreSucursalMatriz);
									$('#nombreUsuario').val(parametroBean.nombreUsuario);
									$('#tipoGastoID').attr("disabled","true");
									$('#descripcionRG').attr("disabled","true");
									$('#monto').attr("disabled","true");
									$('#centroCostoID').attr("disabled","true");
									$('#fechaSolicitada').attr("disabled","true");
									$('#cuentaAhoID').attr("disabled","true");
									consultaTipoGasto('tipoGastoID');
									validaCentroCostos('centroCostoID');
									alert("La Requisicion esta Cancelada.");
							}			
								//dwr.util.setValues(requisicionCon);
							if(estatus == catStatusRequisicion.alta){
									$('#tipoGastoID').attr("disabled",false);
									$('#tipoGastoID').removeAttr("readOnly");
									$('#descripcionRG').attr("disabled",false);
									$('#descripcionRG').removeAttr("readOnly");
									$('#monto').attr("disabled",false);
									$('#monto').removeAttr("readOnly");
									$('#centroCostoID').attr("disabled",false);
									$('#centroCostoID').removeAttr("readOnly");
									$('#fechaSolicitada').attr("disabled",false);
									$('#fechaSolicitada').removeAttr("readOnly");
									$('#cuentaAhoID').attr("disabled",false);
									$('#cuentaAhoID').removeAttr("readOnly");
									//------------------------------------------------
									$('#sucursalID').attr("readOnly","true");
									$('#usuarioID').attr("readOnly","true");
									$('#nombreSucursal').val(parametroBean.nombreSucursalMatriz);
									$('#nombreUsuario').val(parametroBean.nombreUsuario); 
									varError = 0;
									esTab = true;
									$('#tipoGastoID').focus(); 
									
									consultaTipoGasto('tipoGastoID');
									validaCentroCostos('centroCostoID');							
									habilitaBoton('modificar','submit');
									habilitaBoton('cancelar','submit');
							}
							if(estatus == catStatusRequisicion.autorizada){
									alert("La Requisicion esta Aurizada");
									$('#sucursalID').attr("readOnly","true");
									$('#usuarioID').attr("readOnly","true");
									$('#nombreSucursal').val(parametroBean.nombreSucursalMatriz);
									$('#nombreUsuario').val(parametroBean.nombreUsuario); 
									$('#tipoGastoID').attr("disabled",false);
									$('#tipoGastoID').attr("readOnly","true");
									$('#descripcionRG').attr("disabled",false);
									$('#descripcionRG').attr("readOnly","true");
									$('#monto').attr("disabled",false);
									$('#monto').attr("readOnly","true");
									$('#centroCostoID').attr("disabled",false);
									$('#centroCostoID').attr("readOnly","true");
									$('#fechaSolicitada').attr("disabled",false);
									$('#fechaSolicitada').attr("readOnly","true");
									$('#cuentaAhoID').attr("disabled",false);
									$('#cuentaAhoID').attr("readOnly","true");
									consultaTipoGasto('tipoGastoID');
									validaCentroCostos('centroCostoID');
							}
							if(estatus == catStatusRequisicion.procesada){
									$('#sucursalID').attr("readOnly","true");
									$('#usuarioID').attr("readOnly","true");
									$('#nombreSucursal').val(parametroBean.nombreSucursalMatriz);
									$('#nombreUsuario').val(parametroBean.nombreUsuario); 
									$('#tipoGastoID').attr("readOnly","true");
									$('#descripcionRG').attr("readOnly","true");
									$('#monto').attr("readOnly","true");
									$('#centroCostoID').attr("readOnly","true");
									$('#fechaSolicitada').attr("readOnly","true");
									$('#cuentaAhoID').attr("readOnly","true");
									consultaTipoGasto('tipoGastoID');
									validaCentroCostos('centroCostoID');
									alert("Requisicion Finalizada");
								}
							
							if (varError > 0){
								$(jqRequisicion).focus();
								$(jqRequisicion).select();
							}
						}else{
							alert("No existe la Requisicion Seleccionada");
							$(jqRequisicion).focus();
							$(jqRequisicion).select();						
						}
					});
				}
			}
		}		
	}
	//--------------------- Lista Centro costo Requisicion ---------------------------------
	function validaCentroCostos(idControl) {
		var jqCentroCosto = eval("'#" + idControl + "'");
		var numCentroCosto = $(jqCentroCosto).val();
		if(numCentroCosto != '' && !isNaN(numCentroCosto) && esTab){	
			var centroBeanCon = {  
  				'centroCostoID':$('#centroCostoID').val()
			}; 
			centroServicio.consulta(catTipoConsultaCentroCosto.principal,centroBeanCon,function(centro) { 
				if(centro!=null){
					dwr.util.setValues(centro);
					$('#centroCosto').val(centro.descripcion);
					esTab=true; 	
				}else{
					alert("No existe Centro de Costos");
					$(jqCentroCosto).focus();
					$(jqCentroCosto).select();						
				}
			});
		}
	}
  //valida cuenta Bancaria
  
    	function validaSpei(idControl){
  		
  		var numero = document.getElementById(idControl).value;
  		
  		
	  		if(numero.length == 18){
	  			if(!isNaN(numero)){
	  				
	  				var institucion = numero.substr(0,3);
	  				var tipoConsulta = 3;
	  				var DispersionBean = {
							'institucionID': institucion
	  					};
	  				
	  				institucionesServicio.consultaInstitucion(tipoConsulta, DispersionBean, function(data){
						if(data==null){
							alert('La cuenta clabe no coincide con ninguna institución financiera registrada');
							$('#numCtaInstit').focus();
						}
				   });
	  			}
	  		}
  		
	}
  //----------------------------------------

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			requisicionID: 'required',
			
			numCtaInstit :{
			   number: true,
				minlength: 18
		   },
			/*tipoGastoID: 'required',	
			centroCostoID: 'required'*/
		},
		
		messages: {
			requisicionID: 'Especifique numero de Requisicion',
			
			numCtaInstit :{
			   number: 'Solo números',
				minlength: 'Minimo 18 caracteres'
		   },
			
		}
	});
	
});
