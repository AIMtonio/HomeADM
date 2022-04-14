$(document).ready(function() {
	parametros = consultaParametrosSession();	
	$("trBancaMovil").hide();
	var catTipoTransaccionCatalogoServivio = {
		'alta' : '1',
		'modificacion' : '2'			
	};
	var catTipoConsultaCatalogoServ = {
		'principal' : 1			
	};
	var catTipoOrigenServicio = {
			'tercero' : 'T',
			'interno' : 'I'
		};
	var razonSocial=parametros.dirFiscal;
	var nombreInstitucion=parametros.nombreInstitucion;
	
		// ------------ Metodos y Manejo de Eventos
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	agregaFormatoControles('formaGenerica');
	$('#catalogoServID').focus();
	
	$('#trCuentaClabe').hide();	
	$('#trRequiereCredito').hide();
	$('#trcentroCostos').hide();
	$('#trServTercerosID').hide();
	
	$.validator.setDefaults({
	    submitHandler: function(event) { 
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','catalogoServID','funcionExitoCatalogo','funcionErrorCatalogo'); 
	      }
	 });

		   				
	$('#agregar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCatalogoServivio.alta);
	});
	$('#modificar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCatalogoServivio.modificacion);
	});	
	$('#catalogoServID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		  
		camposLista[0] = "catalogoServID";
		camposLista[1] = "nombreServicio";
		  
		parametrosLista[0] = 0;
		parametrosLista[1] = $('#catalogoServID').val();
		  
		lista('catalogoServID', '1', '1', camposLista,parametrosLista, 'listaCatalogoServicios.htm');	       
	});	
	  					
	$('#ctaContaCom').bind('keyup',function(e){
		listaMaestroCuentas(this.id);
	});	
	$('#ctaContaIVACom').bind('keyup',function(e){
		listaMaestroCuentas(this.id);
	});		
	$('#ctaPagarProv').bind('keyup',function(e){
		listaMaestroCuentas(this.id);
	});	
	$('#ctaContaServ').bind('keyup',function(e){
		listaMaestroCuentas(this.id);
	});		
	$('#ctaContaIVAServ').bind('keyup',function(e){
		listaMaestroCuentas(this.id);
	});	
	//---------------
	$('#catalogoServID').blur(function() {		
		validaCatalogoServicio(this.id);		
	});
	$('#ctaContaCom').blur(function() {		
		maestroCuentasDescripcion(this.id,'desCtaContaCom');		
	});
	$('#ctaContaIVACom').blur(function() {		
		maestroCuentasDescripcion(this.id,'desCtaContaIVACom');		
		if($('#catalogoServID').asNumber() >0){
			
			$('#modificar').focus();
		}else{
			$('#agregar').focus();
		}
	});
	$('#ctaPagarProv').blur(function() {		
		maestroCuentasDescripcion(this.id,'desCtaPagarProv');		
	});
	$('#ctaContaServ').blur(function() {		
		maestroCuentasDescripcion(this.id,'desCtaContaServ');		
	});
	$('#ctaContaIVAServ').blur(function() {		
		maestroCuentasDescripcion(this.id, 'desCtaContaIVAServ');		
	});
	
	/*$('#origen1').blur(function() {		
		$('#nombreServicio').focus();
	});*/
	/*$('#origen2').blur(function() {		
		$('#nombreServicio').focus();
	});*/
	
	$('#origen1').click(function() {		
		$('#fielsetComision').show();
		$('#fielsetSevInterno').hide();		
		$('#direccion').val('');
		$('#razonSocial').val('');
	
		//$('#nombreServicio').focus();
		$('#origen1').focus();
		limpiaFormInterno();
		habilitaControl('razonSocial');
		habilitaControl('direccion');
		$('#cobraComision1').attr('checked','true');
		//$('#requiereCliente2').attr('checked','true');
		$('#trCuentaPagarProveedor').show();
		$('#trPagoAutomatico').show();
		$('#cuentaClabe').show();
	});
	$('#origen2').click(function() {		
		$('#fielsetComision').hide();
		$('#fielsetSevInterno').show();
		$('#direccion').val(razonSocial);
		$('#razonSocial').val(nombreInstitucion);
		//$('#nombreServicio').focus();
		$('#origen2').focus();
		limpiaFormTercero();		
		soloLecturaControl('razonSocial');
		soloLecturaControl('direccion');
		$('#trCuentaPagarProveedor').hide();
		$('#trPagoAutomatico').hide();
		$('#pagoAutomatico2').attr('checked','true');
		$('#cuentaClabe').val('');
		$('#cuentaClabe').hide();
	});
	
	$('#bancaMovil1').click(function() {
		
		$('#trServTercerosID').show();
	});
	
	$('#bancaMovil2').click(function() {
		
		$('#trServTercerosID').hide();
	});
	
	
	
	$('#cobraComision1').click(function() {	
		habilitaControl('montoComision');
		$('#montoComision').val('');
		habilitaControl('ctaContaCom');
		habilitaControl('ctaContaIVACom');
		habilitaControl('ctaPagarProv');		
		$('#trMontoComision').show();
		$('#trCuentaComision').show();
		$('#trCuentaIVAComision').show();
		//$('#montoComision1').focus();
		$('#cobraComision1').focus();
	});	
	

	$('#cobraComision2').click(function() {		
		ocultaCobraComision();
	});
	// requiere Cliente	
	$('#requiereCliente1').click(function() {	
		$('#requiereCliente1').focus();
		$('#trRequiereCredito').show();
		$('#trcentroCostos').show(500);
		
	});	

	
	$('#requiereCliente2').click(function() {			
		$('#trRequiereCredito').hide();
		$('#requiereCredito2').attr('checked','true');
		$('#requiereCliente2').focus();
		$('#trcentroCostos').hide(500);
		$('#centroCostos').val('');
	});

	// requiere credito
	$('#requiereCredito1').click(function() {	
		$('#requiereCredito1').focus();
	});		
	$('#requiereCredito2').click(function() {	
		$('#requiereCredito2').focus();		
	});

	
	// pago Automatico
	$('#pagoAutomatico1').click(function() {	
		$('#trCuentaClabe').show();	
		$('#pagoAutomatico1').focus();
		
	});
	$('#pagoAutomatico2').click(function() {	
		$('#trCuentaClabe').hide();	
		$('#cuentaClabe').val('');	
		$('#pagoAutomatico2').focus();
	});
	$('#cuentaClabe').blur(function() {		
		validaCuentaClabe(this.id);
	});
	

//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({			
		rules: {
			
			catalogoServID: {
				required: true,
				numeroPositivo: true
			},
			
			nombreServicio: {
				required: true				
			},											
			razonSocial: {
				required : function() {return $('#origen1:checked').val() == 'T';}
			},
			montoServicio: {
				required : function() {return $('#origen2:checked').val() == 'I';},
				numeroPositivo: true
			},
			montoComision: {
				required : function() {return $('#cobraComision1:checked').val() == 'S';},
				numeroPositivo: true		
			},
			cuentaClabe: {
				required : function() {return $('#pagoAutomatico1:checked').val() == 'S';},
				numeroPositivo: true		
			},
			numServProve: {
				numeroPositivo: true
			},
			
		},		
		messages: {
			nombreServicio: {
				required: 'Especificar nombre del servicio',
				numeroPositivo:'Sólo Números'
			},											
			razonSocial: {
				required :'Ingrese la Razón Social',				
			},
			montoServicio: {
				required :'Ingrese el monto del servicio',				
			},
			catalogoServID: {
				required :'Ingrese el número de Servicio',	
				numeroPositivo:'Sólo Números'
			},
			montoComision: {
				required :'Ingrese el monto de la Comisión',
				numeroPositivo:'Sólo Números'
			},
			cuentaClabe: {
				required :'Ingrese la Cuenta Clabe',
				numeroPositivo:'Sólo Números'
			},
			numServProve: {
				numeroPositivo:'Sólo Números'
			}

		}		
	});
	
//-------------------- Métodos------------------	
	function validaCatalogoServicio(control) {
		var jqCatalogoServicio  = eval("'#" +control + "'");
		var catalogoServicio = $(jqCatalogoServicio).val();	
		var siCobraComision='S';

		if(catalogoServicio != '' && !isNaN(catalogoServicio)){		
			$('#estatus').val('A');
			if(catalogoServicio == '0'){								
				habilitaBoton('agregar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				inicializaForma('formaGenerica', 'catalogoServID');
				habilitaControl('razonSocial');
				habilitaControl('direccion');	
				$('#origen1').attr('checked','true');
				$('#cobraComision1').attr('checked','true');					
				$('#trRequiereCredito').hide();
				$('#fielsetSevInterno').hide();				
				$('#trCuentaPagarProveedor').show();
				$('#trcentroCostos').hide();
				$('#trCuentaClabe').hide();
				$('#trServTercerosID').hide();
				
				$('#fielsetComision').show();
				$('#trMontoComision').show();
				$('#trCuentaComision').show();
				$('#trCuentaIVAComision').show();
				deshabilitaControl('estatus');
														
			}else{	
				habilitaControl('estatus');
				var catalogoServ = { 
						'catalogoServID':catalogoServicio	  				
				};				
				
				catalogoServicios.consulta(catTipoConsultaCatalogoServ.principal,catalogoServ,function(catalogoServicioBean) {
					if(catalogoServicioBean != null){
						dwr.util.setValues(catalogoServicioBean);
						
						if(catalogoServicioBean.bancaMovil=="S"){
							$('#trServTercerosID').show();
						}else{
							$('#trServTercerosID').hide();
						}
						
						if(catalogoServicioBean.origen == catTipoOrigenServicio.tercero){
							$('#fielsetComision').show();
							$('#fielsetSevInterno').hide();
							$('#trCuentaPagarProveedor').show();
							$('#trPagoAutomatico').show();
							if(catalogoServicioBean.cobraComision == siCobraComision){
								habilitaControl('montoComision');
								$('#trMontoComision').show();
								$('#trCuentaComision').show();
								$('#trCuentaIVAComision').show();
							}else{
								soloLecturaControl('montoComision');
								$('#trMontoComision').hide();
								$('#trCuentaComision').hide();
								$('#trCuentaIVAComision').hide();
							}
							
							if(catalogoServicioBean.pagoAutomatico == 'S'){
								$('#trCuentaClabe').show();
							}else{
								$('#trCuentaClabe').hide();
							}
						}else if (catalogoServicioBean.origen == catTipoOrigenServicio.interno){
							$('#fielsetComision').hide();
							$('#fielsetSevInterno').show();
							$('#trCuentaPagarProveedor').hide();														
							$('#trPagoAutomatico').hide();
							$('#trCuentaClabe').hide();
						}			
						if($('#requiereCliente1').is(':checked')){
							$('#trRequiereCredito').show();
							$('#trcentroCostos').show();
						}else if($('#requiereCliente2').is(':checked')){
							$('#trRequiereCredito').hide();
							$('#trcentroCostos').hide();
						}
						
						maestroCuentasDescripcion('ctaContaCom','desCtaContaCom');											
						maestroCuentasDescripcion('ctaContaIVACom','desCtaContaIVACom');						
						maestroCuentasDescripcion('ctaPagarProv','desCtaPagarProv');												
						maestroCuentasDescripcion('ctaContaServ','desCtaContaServ');										
						maestroCuentasDescripcion('ctaContaIVAServ', 'desCtaContaIVAServ');					
						
						deshabilitaBoton('agregar', 'submit');
						habilitaBoton('modificar', 'submit');
					}else{								
						alert("No existe el Servicio");
						deshabilitaBoton('modificar', 'submit');				
						inicializaForma('formaGenerica','catalogoServID' );	
						$('#trcentroCostos').hide();
					}
				});
						
			}											
		}
	}
	function listaMaestroCuentas(idControl){
		var jqControl = eval("'#" + idControl+ "'");
		
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = $(jqControl).val();
		
		if($(jqControl).val() != '' && !isNaN($(jqControl).val() )){
			listaAlfanumerica(idControl, '1', '6', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
		else{
			listaAlfanumerica(idControl, '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}	
	
	function maestroCuentasDescripcion(idControl,descripcionCta) {
		var jqCuentaContable = eval("'#" + idControl + "'");	
		var numCta = $(jqCuentaContable).val();
		var jdDescripvionCta =eval("'#" + descripcionCta + "'");
		
		var tipConForanea = 2;
		
		var ctaContableBeanCon = {
		  'cuentaCompleta':numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCta != '' && !isNaN(numCta)) {
			if(numCta.length >= 10){
				cuentasContablesServicio.consulta(tipConForanea,ctaContableBeanCon,function(ctaConta){
					if (ctaConta != null) {
						if(ctaConta.grupo != "E"){
							$(jdDescripvionCta).val(ctaConta.descripcion);
						} else{
							alert("Solo Cuentas Contables De Detalle");
							$(jqCuentaContable).val("");
							$(jqCuentaContable).focus();
							$(jdDescripvionCta).val("");						
						}
					}else {
						alert("La Cuenta Contable no existe.");
						$(jqCuentaContable).val("");
						$(jqCuentaContable).focus();
						$(jdDescripvionCta).val("");
					}
				});
			}
		}
	}
	function ocultaCobraComision(){
		$('#cobraComision2').focus();
		soloLecturaControl('montoComision');
		$('#montoComision').val('0.00');
		soloLecturaControl('ctaContaCom');
		soloLecturaControl('ctaContaIVACom');							
		$('#montoComision').val('');
		$('#ctaContaCom').val('');
		$('#desCtaContaCom').val('');
		$('#ctaContaIVACom').val('');
		$('#desCtaContaIVACom').val('');

		$('#trMontoComision').hide();
		$('#trCuentaComision').hide();
		$('#trCuentaIVAComision').hide();
	}
	function limpiaFormTercero(){
		$('#cobraComision2').attr('checked','true');
		$('#montoComision').val('');
		$('#ctaContaCom').val('');
		$('#desCtaContaCom').val('');
		$('#ctaContaIVACom').val('');
		$('#desCtaContaIVACom').val('');
		$('#ctaPagarProv').val('');
		$('#desCtaPagarProv').val('');
		
		
	}
	function limpiaFormInterno(){
		$('#montoServicio').val('');
		$('#ctaContaServ').val('');
		$('#desCtaContaServ').val('');
		$('#ctaContaIVAServ').val('');
		$('#desCtaContaIVAServ').val('');
	}
	



	function validaCuentaClabe(idControl){
		var jqCuentaClave =eval("'#" + idControl + "'");	
		var valorFolio	= $(jqCuentaClave).val();
	
		if( valorFolio != '' && !isNaN(valorFolio) > 0){
			if(valorFolio.length == 18 && valorFolio != ''){

				var numeroFolio= valorFolio.substr(0,3);
				var tipoConsulta = 3;
				var DispersionBean = {
						'institucionID': numeroFolio
				};

				institucionesServicio.consultaInstitucion(tipoConsulta, DispersionBean, function(data){
					if(data==null){
						alert('La cuenta clabe no coincide con ninguna institución financiera registrada');
						$(jqCuentaClave).focus();;
					}
				});
				
			}else{
				alert("La cuenta clable debe de tener 18 caracteres");
				$(jqCuentaClave).focus();
			}
		}
		
	}

	
});

function funcionExitoCatalogo(){

}
function funcionErrorCatalogo(){
	agregaFormatoMoneda('formaGenerica');
}
function ayuda(){	
	var data;
	
				       
data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura Centro Costo:</legend>'+
			'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="encabezadoLista">&SO</td><td id="contenidoAyuda"><b>Sucursal Origen</b></td>'+
					'</tr>'+
					'<tr>'+
						'<td id="encabezadoLista" >&SC</td><td id="contenidoAyuda"><b>Sucursal Cliente</b></td>'+
					'</tr>'+ 
			'</table>'+
			'<br>'+
	 '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+  
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplos: </legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 1: </b></td>'+ 
						'<td id="contenidoAyuda">&SO</td>'+
				'</tr>'+
				'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 2:</b></td>'+ 
						'<td id="contenidoAyuda">&SC</td>'+
				'</tr>'+
				'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 3:</b></td>'+ 
						'<td id="contenidoAyuda">15</td>'+
				'</tr>'+
			'</table>'+
			'</div></div>'+  
		'</fieldset>'+
	 '</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}
