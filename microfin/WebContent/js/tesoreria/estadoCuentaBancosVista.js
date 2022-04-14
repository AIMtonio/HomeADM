$(document).ready(function() {
	esTab = true;
	
	var catTipoConsultaInstituciones = {
  		'principal':1, 
  		'foranea':2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------   
	agregaFormatoControles('formaGenerica');
	
	// de manda a llamar funcion para limpiar los campos y obtener parametro de sesion
	limpiarCampos();
	
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
	      
		}
	});		
	
	// se consulta la lista de Instituciones al escribir en la caja
	$('#institucionID').bind('keyup',function(e){
    	lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
    });
    
	// si pierde el foco se consulta el nombre de la institucion
    $('#institucionID').blur(function() {
    	consultaInstitucion(this.id);
    });
    
    // se obtiene la lista de las cuentas bancarias
    $('#cuentaBancaria').bind('keyup',function(e){
    	var camposLista = new Array();
		var parametrosLista = new Array();
			camposLista[0] = "institucionID";
            parametrosLista[0] = $('#institucionID').val();
                        
            camposLista[1] = "cuentaAhoID";			
            parametrosLista[1] = $('#cuentaBancaria').val();
                    
		lista('cuentaBancaria', '2', '2', camposLista,parametrosLista, 'tesoCargaMovLista.htm');	       
    });
    
    // se consulta 
    $('#cuentaBancaria').blur(function() {
    	if($('#cuentaBancaria').val() != '' && !isNaN($('#cuentaBancaria').val()) && esTab){
    		consultaCuentaBan(this.id);	
    	}
    	
    });
    
    // se ejecuta funcion al dar clic en boton consultar
    $('#consultar').click(function() {
    	 consultaMovimientosEstadoCuentaGrid();		
	});
	
    // se ejecuta funcion al dar clic en boton generar
    $('#generar').click(function() {
    	generarReporte(1);
	});
     
    // se ejecuta funcion al dar clic en boton generar
    $('#generarExcel').click(function() {
    	generarReporte(2);
	});
	
    $('#fecha').change(function() {
		if(!esTab){			
			$('#fecha').focus();
		}
	});	
    //------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			institucionID: 'required',
			cuentaAhoID: 'required',
			fechaCarga: 'required'
		},
		
		messages: {
			institucionID: 'Especificar la institucion',
			cuentaBancaria: 'Especificar Cuenta Bancaria',
			fecha: 'Especificar Fecha'
		}
	});
    

    // metodos y funciones
    
    //Método de consulta de Institución
    function consultaInstitucion(idControl) {
    	limpiarCampos();
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};
 
		if(numInstituto != '' && !isNaN(numInstituto) && esTab){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea, InstitutoBeanCon, function(instituto){
				if(instituto!=null){							
					$('#nombreInstitucion').val(instituto.nombre);
					$('#nombreCortoInstitucion').val(instituto.nombreCorto);
															
				}else{
					limpiarCampos(); 
					alert("No Existe la Institución"); 
					$(jqInstituto).focus();
				}    						
			});
		}
	}
    
    // se consulta el nombre del banco de la cuenta bancaria 
    function consultaCuentaBan(idControl) {
		var jqCuentaBan= eval("'#" + idControl + "'");
		var numCuenta = $(jqCuentaBan).val();
		setTimeout("$('#cajaLista').hide();", 200);	

		var tipoConsulta = 9;
		var DispersionBeanCta = {
			'institucionID': $('#institucionID').val(),
			'numCtaInstit': numCuenta
			};
					
		operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
			if(data!=null){
				$('#nombreBanco').val(data.nombreCuentaInst);
			}else{
				alert("No existe la cuenta indicada ");
				 $('#cuentaBancaria').focus();
				 $('#cuentaBancaria').select();
			}
		});
	}
    
    // funcion para consultar los movimientos del estado de cuenta de bancos
    function consultaMovimientosEstadoCuentaGrid(){	
    	if($('#institucionID').val() != '' && $('#institucionID').val() != null && $('#institucionID').val() != ' '){
    		if($('#cuentaBancaria').val() != '' && $('#cuentaBancaria').val() != null && $('#cuentaBancaria').val() != ' '){
    			if($('#fecha').val() != '' && $('#fecha').val() != null && $('#fecha').val() != ' '){
		    		var params = {};
		    		params['institucionID'] = $('#institucionID').val();
		    		params['numCtaInstit'] = $('#cuentaBancaria').val();
		    		params['fecha'] = $('#fecha').val(); 
		    		//alert($('#institucionID').val() +" - "+ $('#cuentaBancaria').val()+"-"+$('#fecha').val());
		    		$.post("gridEstadoDeCuentaBancos.htm", params, function(data){
		    				if(data.length >0) {//alert("datos");
		    					$('#gridMovEstadoCuentaBancos').html(data);
		    					$('#gridMovEstadoCuentaBancos').show();
		    					$('#generar').show();
		    					$('#trGenerarReporte').show();
		    					$('#generarExcel').show();
		    					
		    				}else{
		    					$('#gridMovEstadoCuentaBancos').html("");
		    					$('#gridMovEstadoCuentaBancos').show(); 
		    					$('#generar').hide(); 
		    					$('#generarExcel').hide();
		    				}
		    		});
    			}
    			else{
    				alert("Especifique Fecha");
    				$('#gridMovEstadoCuentaBancos').hide(); 
            		$('#fecha').focus();
    			}
    		}
    		else{
    			alert("Especifique Cuenta bancaria");
    			$('#gridMovEstadoCuentaBancos').hide(); 
        		$('#cuentaBancaria').focus();
    		}
    	}else{
    		$('#gridMovEstadoCuentaBancos').hide(); 
    		alert("Especifique Institución");
    		$('#institucionID').focus();
    	}		
	}
    
    // funcion para generar el reporte de estado de cuenta de bancos
    function generarReporte(varTiporeporte) { 
    	

    	var parametroBean = consultaParametrosSession();
    	if($('#institucionID').val() != '' && $('#institucionID').val() != null && $('#institucionID').val() != ' '){
    		if($('#cuentaBancaria').val() != '' && $('#cuentaBancaria').val() != null && $('#cuentaBancaria').val() != ' '){
    			if($('#fecha').val() != '' && $('#fecha').val() != null && $('#fecha').val() != ' '){
    				if(varTiporeporte == 1){
    					$('#enlace').attr('href','repEstadoCuentBancosPDF.htm?institucionID='+$('#institucionID').val()+
    							'&numCtaInstit='+$('#cuentaBancaria').val()+'&fecha='+$('#fecha').val()+'&nombreInstitucionSistema='+
    							$('#nombreInstitucionSistema').val()+'&nombreInstitucion='+$('#nombreCortoInstitucion').val()
    							+'&tipoReporte='+varTiporeporte+'&usuario='+parametroBean.claveUsuario+'&sucursal='+parametroBean.nombreSucursal);
    				}else{
    					
    					$('#enlaceExcel').attr('href','repEstadoCuentBancosPDF.htm?institucionID='+$('#institucionID').val()+
    							'&numCtaInstit='+$('#cuentaBancaria').val()+'&fecha='+$('#fecha').val()+'&nombreInstitucionSistema='+
    							$('#nombreInstitucionSistema').val()+'&nombreInstitucion='+$('#nombreCortoInstitucion').val()
    							+'&tipoReporte='+varTiporeporte+'&fechaSistema='+parametroBean.fechaSucursal+'&claveUsuario='+parametroBean.claveUsuario);
    				}
    			}
    			else{
    				alert("Especifique Fecha");
            		$('#generar').hide();
            		$('#fecha').focus();
    			}
    		}
    		else{
    			alert("Especifique Cuenta bancaria");
        		$('#generar').hide();
        		$('#cuentaBancaria').focus();
    		}
    	}else{
    		alert("Especifique Institución");
    		$('#generar').hide();
    		$('#institucionID').focus();
    	}
    	
		    
	}
    
   
    // Funcion para limpiar los campos de la pantalla 
    function limpiarCampos(){ 
    	inicializaForma('formaGenerica','institucionID' );
    	$('#cuentaBancaria').val("");
    	var parametroBean = consultaParametrosSession();
    	$('#nombreInstitucionSistema').val(parametroBean.nombreInstitucion);
    	$('#fecha').val(parametroBean.fechaSucursal);
    }

});