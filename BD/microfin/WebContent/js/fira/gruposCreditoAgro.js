$(document).ready(function() {
	var noAceptado = 0; 
 	
		esTab = true;
		//Definicion de Constantes y Enums  
		var catTipoTransaccionGrupo = {  
	  		'alta':'1',
	  		'modifica':'2',
	  		'actualiza':'3'
	  	};
		
		var catTipoActualizacionGrupo = {  
			'actualizaInicio':'1',
			'actualizaCierre':'3'
		}
			
		
		var catTipoConsultaGrupo = {
			'principal'	: 15
		  		
		};	
		parametros = consultaParametrosSession();
		$('#nombreInstitucion').val(parametros.nombreInstitucion);// Parametro del sistema Nombre de la institucio
		//------------ Msetodos y Manejo de Eventos -----------------------------------------
		
		 deshabilitaBoton('grabar', 'submit');
		 deshabilitaBoton('iniciarCiclo', 'submit');
		 deshabilitaBoton('cerrarCiclo', 'submit');
		 deshabilitaBoton('actaConstitutiva','submit');
	     var parametroBean = consultaParametrosSession();
	  		$('#sucursalID').val(parametroBean.sucursal);		
	  		$('#nombreSucursal').val(parametroBean.nombreSucursal);
	  		$('#grupoID').focus();
		 
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
					$('#esAgropecuario').val('S');
			       	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID','exito','fallo');
		   		}
			});	
		
			
			
			$('#nombreGrupo').blur(function() { 
				 var nombreCnEspacios = $('#nombreGrupo').val();
				 var  nombreSinEspacios= $.trim(nombreCnEspacios);
				 $('#nombreGrupo').val(nombreSinEspacios);
			});
			
			$('#grupoID').blur(function() { 
				noAceptado=0;
				esTab=true;
		  		validaGrupo(this.id); 
			});
			
			
			 $('#grupoID').bind('keyup',function(e){
				 if(this.value.length >= 2){ 
					var camposLista = new Array(); 
				    var parametrosLista = new Array(); 
				    	camposLista[0] = "nombreGrupo";
				    	parametrosLista[0] = $('#grupoID').val();
				 listaAlfanumerica('grupoID', '1', '5', camposLista, parametrosLista, 'listaGruposCredito.htm'); } });
			
			
			$('#fechaRegistro').val(parametroBean.fechaAplicacion);
	     
	
	   
	  		$('#grabar').click(function() {
				$('#tipoTransaccion').val(catTipoTransaccionGrupo.alta);
	  			//grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID'); 
				
		  	});
	  		
	  	$('#iniciarCiclo').click(function() {

			$('#tipoTransaccion').val(catTipoTransaccionGrupo.actualiza);	
			$('#tipoActualizacion').val(catTipoActualizacionGrupo.actualizaInicio);	
			//grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID'); 
			
	  	});
	  	
	  	$('#cerrarCiclo').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccionGrupo.actualiza);	
			$('#tipoActualizacion').val(catTipoActualizacionGrupo.actualizaCierre);		
			//grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID');
			habilitaBoton('actaConstitutiva','submit');
    			return true;
        				return false;
		});
	  	
	  	$('#actaConstitutiva').click(function(){
	  		var eltipoReporte = 1;
	  		enviaDatosRepActaConstitutiva(eltipoReporte);
	  	});
	  //------------ Validaciones de la Forma -------------------------------------
		
		$('#formaGenerica').validate({
					
			rules: {
				
				grupoID: {
					required: true
					
				},
		
				nombreGrupo: {
					required: true
				},
				
				fechaRegistro: {
					required: true,
					date:true
				},
				
				sucursalID: {
					required: true
				},
				
				cicloActual: {
					required: true
				},
				
				estatus: {
					required: true
				},
				tipoOperacion: {
					required: true
				},
				
			
			},		
			messages: {
				
			
				grupoID: {
					required: 'Especifica Grupo.',
					
				},
				
				nombreGrupo: {
					required: 'Especifica Nombre'
				},
				
				fechaRegistro: {
					required: 'Especifica Fecha.',
					date: 'Fecha incorrecta',
				},
				
				sucursalID: {
					required: 'Especifica Sucursal.'
					
				},
				
				cicloActual: {
					required: 'Especifica Ciclo.'
				},
				estatus: {
					required: 'Especifica Estado.'
				},
				tipoOperacion: {
					required: 'Especifica Tipo de Operación.'
				},
	
			}		
		});
		
		
		//------------ Validaciones de Controles -------------------------------------
		
		function validaGrupo(control) {
		var numGrupo = $('#grupoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numGrupo != '' && !isNaN(numGrupo) && esTab){


			if(numGrupo=='0'){
			
				habilitaBoton('grabar', 'submit');		
				deshabilitaBoton('iniciarCiclo', 'submit');
				deshabilitaBoton('cerrarCiclo', 'submit');
				inicializaForma('formaGenerica','grupoID' );
				$('#fechaRegistro').val(obtenDia());
				$('#cicloActual').val(0);
				$('#fechaUltCiclo').val('1900-01-01');
				$('#estatusCiclo').val("N").selected = true;
				$('#tipoTransaccion').val(catTipoTransaccionGrupo.alta);
				$('#sucursalID').val(parametroBean.sucursal);
				$('#nombreSucursal').val(parametroBean.nombreSucursal);
				deshabilitaControl('cicloActual');
				deshabilitaControl('fechaUltCiclo');
				$('#pro').hide(100);
				$('#tipoCre').hide(100);
				$('#productoCre').hide(100);
				$('#nombreTipoCredito').hide(100);
				
				habilitaControl('nombreGrupo');
				$('#tipoOperacion').val('');
				habilitaControl('tipoOperacion');
				$('#nombreGrupo').focus();
				deshabilitaBoton('actaConstitutiva','submit');
			} else {				
				var grupoBeanCon = { 
  				'grupoID':$('#grupoID').val()
				};
				 
				gruposCreditoServicio.consulta(catTipoConsultaGrupo.principal,grupoBeanCon,function(grupos) {
						if(grupos!=null){
							$('#tipoTransaccion').val(catTipoTransaccionGrupo.modifica);
							dwr.util.setValues(grupos);	
						
							habilitaBoton('grabar', 'submit');
							$('#fechaRegistro').val(grupos.fechaRegistro.substring(0,19));
							$('#fechaUltCiclo').val(grupos.fechaUltCiclo.substring(0,19));
							if (grupos.productoCre==null){
								$('#pro').show(100);
								$('#tipoCre').hide(100);
								$('#productoCre').hide(100);
								$('#nombreTipoCredito').hide(100);
							}
							else{
								$('#pro').hide(100);
								$('#tipoCre').show(100);
								$('#productoCre').show(100);
								$('#nombreTipoCredito').show(100);
								esTab=true;
								 consultaProducto('productoCre');
							}
								
							if (grupos.cicloActual==0 && grupos.estatusCiclo=='N'){
								deshabilitaControl('nombreGrupo');
								deshabilitaControl('tipoOperacion');
								habilitaBoton('iniciarCiclo', 'submit');
								deshabilitaBoton('cerrarCiclo', 'submit');
								deshabilitaBoton('grabar', 'submit');
								deshabilitaBoton('actaConstitutiva','submit');
							}
							else{
									if (grupos.cicloActual!=0 && grupos.estatusCiclo=='C'){	
										deshabilitaControl('nombreGrupo');
										deshabilitaControl('tipoOperacion');
										habilitaBoton('iniciarCiclo', 'submit');
										habilitaBoton('actaConstitutiva','submit');
										deshabilitaBoton('cerrarCiclo', 'submit');
										deshabilitaBoton('grabar', 'submit');										
									}
									else{
										if(grupos.cicloActual!=0 && grupos.estatusCiclo=='A'){
										deshabilitaControl('nombreGrupo');
										deshabilitaControl('tipoOperacion');
										habilitaBoton('cerrarCiclo', 'submit');
										deshabilitaBoton('iniciarCiclo', 'submit');
										deshabilitaBoton('grabar', 'submit');
										deshabilitaBoton('actaConstitutiva','submit');
										}
										else{
											
											deshabilitaBoton('cerrarCiclo', 'submit');
										}
									}
							}
						}
						else{
							
							mensajeSis("No Existe el grupo");
							deshabilitaBoton('grabar', 'submit');
							deshabilitaBoton('iniciarCiclo', 'submit');
							deshabilitaBoton('cerrarCiclo', 'submit');
							inicializaForma('formaGenerica','grupoID' );
							$('#fechaRegistro').val(obtenDia());
							$('#estatusCiclo').val("N").selected = true;
							$('#pro').hide(100);
							$('#tipoCre').hide(100);
							$('#productoCre').hide(100);
							$('#nombreTipoCredito').hide(100);
							$('#grupoID').focus();
							$('#grupoID').val("");	
																			
							}
				});
						
			}
												
		}
	}
		
		
		  //------------ Funcion Consulta Producto-------------------------------------
	  	
	function consultaProducto(idControl) {
		var jqProducto = eval("'#" + idControl + "'");
		var numProducto = $(jqProducto).val();	
		var tipConPrincipal = 1;
		var productoBeanCon = { 
  				'producCreditoID':numProducto		  				
			};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numProducto != '' && !isNaN(numProducto) && esTab){
			productosCreditoServicio.consulta(tipConPrincipal,productoBeanCon,function(productos) {
				if(productos!=null){		
							esTab=true;
							$('#nombreTipoCredito').val(productos.descripcion);
																	
						}else{
							mensajeSis("No Existe el producto");
							
						}    	 						
				});
			}
		}	
		
		  //------------ Funcion Valida Integrantes-------------------------------------
	  	
	
	//Funcion Obtener Dia
	     function obtenDia(){
	     	var f = new Date();
	     	dia = f.getDate();
	        mes = f.getMonth() +1;
	        anio = f.getFullYear();
	        	if (dia <10){ dia = "0" + dia;}
	        	if (mes <10){ mes = "0" + mes;}  
	     	
	        	return anio + "-" + mes + "-" + dia;	    	    
	     }
		
	     // funcion Genera Reporte Acta Constitutiva
	     
	     function enviaDatosRepActaConstitutiva(tipoReporte){
	    	 var grupo=$('#grupoID').val();
	    	 var pagina ='actaConstitutivaPDF.htm?grupoID='+grupo+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&tipoReporte='+tipoReporte;
	    	 window.open(pagina,'_blank');
	     }

});

	function exito(){
		inicializaForma('formaGenerica','grupoID' );
	}
	//Funcion de error al realizar una trasaccion
	
	function fallo(){	
	}
	