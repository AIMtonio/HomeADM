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
			'actualizaCierre':'2'
		};
			
		
		var catTipoConsultaGrupo = {
			'principal'	: 1
		  		
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
		            	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID');  
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
				 listaAlfanumerica('grupoID', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); } });
			
			
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
	  		if(noAceptado==13 || noAceptado == 0 ){
			$('#tipoTransaccion').val(catTipoTransaccionGrupo.actualiza);	
			$('#tipoActualizacion').val(catTipoActualizacionGrupo.actualizaCierre);		
			//grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID');
			habilitaBoton('actaConstitutiva','submit');
    			return true;
        	}
			muestraErrorValidaGrupal();
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
								habilitaBoton('iniciarCiclo', 'submit');
								deshabilitaBoton('cerrarCiclo', 'submit');
								deshabilitaBoton('grabar', 'submit');
								deshabilitaBoton('actaConstitutiva','submit');
							}
							else{
									if (grupos.cicloActual!=0 && grupos.estatusCiclo=='C'){	
										deshabilitaControl('nombreGrupo');
										habilitaBoton('iniciarCiclo', 'submit');
										habilitaBoton('actaConstitutiva','submit');
										deshabilitaBoton('cerrarCiclo', 'submit');
										deshabilitaBoton('grabar', 'submit');										
									}
									else{
										if(grupos.cicloActual!=0 && grupos.estatusCiclo=='A'){
										deshabilitaControl('nombreGrupo');
										habilitaBoton('cerrarCiclo', 'submit');
										deshabilitaBoton('iniciarCiclo', 'submit');
										deshabilitaBoton('grabar', 'submit');
										deshabilitaBoton('actaConstitutiva','submit');
										validaDatosGrupales(grupos.productoCre);
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
/////funcion para consultar y validar los datos grupales	y guarda el error     
	 function validaDatosGrupales( productoCre ){//id control se refiere al dato que esta tomando de el espacio select, input de la forma para procesar la informacion
	 	var proCredBean='';	
		var max 	= Number(0);
		var min		= Number(0);
		var maxh	= Number(0);
		var minh	= Number(0);
		var maxm	= Number(0);
		var minm	= Number(0);
		var maxms	= Number(0);
		var minms	= Number(0);
		var numeroi	= Number(0);
		var numeroms= Number(0);
		var numerom	= Number(0);
		var numeroh	= Number(0);
		//primero se consulta el P-credito por el numero de grupo 
		var conGrupo = 8;
		var GrupoBeanCon = {
				'grupoID' : $('#grupoID').val()
			};
	//	    		setTimeout("$('#cajaLista').hide();", 200);
		if ($('#grupoID').val() != '' && !isNaN($('#grupoID').val()) ) {
			gruposCreditoServicio.consulta(conGrupo, GrupoBeanCon, function(grupo) {
				if(grupo!=null){
					numeroi		= Number(grupo.tInt);
					numeroms	= Number(grupo.tMS);
					numerom		= Number(grupo.tM);
					numeroh		= Number(grupo.tH);
					if(numeroi<=0){
						noAceptado = 2;
					}else{	
						if(productoCre != null){
							if(Number(productoCre)>0){
								proCredBean = {
    				    				  'producCreditoID':productoCre
    				    				};
								productosCreditoServicio.consulta(4,	proCredBean, function(procred) {
						    			if(procred != null ){			
						    			max 	= Number(procred.maxIntegrantes);
						    			min		= Number(procred.minIntegrantes);
						    			maxh	= Number(procred.maxHombres);
						    			minh	= Number(procred.minHombres);
						    			maxm	= Number(procred.maxMujeres);
						    			minm	= Number(procred.minMujeres);
						    			maxms	= Number(procred.maxMujeresSol);
						    			minms	= Number(procred.minMujeresSol);
						    			if(max<numeroi){
						    				noAceptado = 5;
						    			}else{
						    				if(min>numeroi){
    						    				noAceptado = 6;
    						    			}else{
    						    				if(maxms<numeroms){
    						    					if(maxms==0){
    						    						noAceptado = 14;
    						    					}else{
    						    						noAceptado = 7;
    						    					}
	    						    				
	    						    			}else{
	    						    				if(minms>numeroms){
		    						    				noAceptado = 8;
		    						    			}else{
		    						    				if(maxm<numerom){
		    						    					if(maxm==0){
		    						    						noAceptado = 15;
		    						    					}else{
		    						    						noAceptado = 9;
		    						    					}
			    						    			}else{
			    						    				if(minm>numerom){
				    						    				
				    						    				noAceptado = 10;
				    						    			}else{
				    						    				if(maxh<numeroh){
				    						    					if(maxh==0){
				    						    						noAceptado = 16;
				    						    					}else{
				    						    						noAceptado = 11;
				    						    					}
					    						    			}else{
					    						    				if(minh>numeroh){
						    						    				noAceptado = 12;
						    						    			}else{
						    						    				if((maxm-minms)< (numerom-numeroms)){
						    						    					if((maxm-minms)==0){
						    						    						noAceptado = 17;
						    						    					}else{
						    						    						noAceptado = 18;
						    						    					}
						    						    				}else{
							    						    				if((maxm-maxms)>(numerom-numeroms)){
								    						    				noAceptado = 0;
								    						    			}else{
								    						    				noAceptado = 13;			
									    						    		}
							    						    			}
						    						    			}
						    						    		}
					    									}
				    						    		}
			    						    		}
		    						    		}
	    						    		}
    						    		}
						    		}
					    		});
							}else{
								noAceptado = 4;
							}
						}else{
							noAceptado = 3;
						}
					}
				}else{
					noAceptado = 1;
				}
			});
			}
	 }
	 
	 ///aqui muestra el error
	 function muestraErrorValidaGrupal(){
		 switch(noAceptado){
		 case 1:mensajeSis('El Grupo No Existe');
			 break;
		 case 2:mensajeSis('El Grupo No Tiene Integrantes');
			 break;
		 case 3:mensajeSis('El Grupo No Tiene Integrantes Relacionados');
			 break;
		 case 4:mensajeSis('El Grupo No Tiene Producto de Crédito Relacionado.');
			 break;
		 case 5:mensajeSis('Se ha superado el Número Máximo de Integrantes para el Grupo. Verfique el Producto de Crédito.');
			 break;
		 case 6:mensajeSis('No se ha alcanzado el Número Mínimo de Integrantes para el Grupo.');
			 break;
		 case 7:mensajeSis('Se ha superado el Número Máximo de Mujeres Solteras para el Grupo. Verfique el Producto de Crédito.'); 
			 break;
		 case 8:mensajeSis('No se ha alcanzado el Número Mínimo de Mujeres Solteras para el Grupo.');
			 break;
		 case 9:mensajeSis('Se ha superado el Número Máximo de Mujeres para el Grupo. Verfique el Producto de Crédito.'); 
			 break;
		 case 10:mensajeSis('No se ha alcanzado el Número Mínimo de Mujeres para el Grupo.');
			 break;
		 case 11:mensajeSis('Se ha superado el Número Máximo de Hombres para el Grupo. Verfique el Producto de Crédito.'); 
			 break;
		 case 12:mensajeSis('No se ha alcanzado el Número Mínimo de Hombres para el Grupo.');
		 break;
		 case 14:mensajeSis('El Producto de Crédito no Admite Mujeres Solteras, verifique las solicitudes de este Grupo.'); 
		 break;
		 case 15:mensajeSis('El Producto de Crédito no Admite Mujeres, verifique las solicitudes de este Grupo.'); 
		 break;
		 case 16:mensajeSis('El Producto de Crédito no Admite Hombres, verifique las solicitudes de este Grupo.'); 
		 break;
		 case 17:mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras, verifique las solicitudes de este Grupo.'); 
		 break;
		 case 18:mensajeSis('Se ha superado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo, verifique las solicitudes de este Grupo.'); 
		 break;
		 }

	 }
});


	