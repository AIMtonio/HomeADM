$(document).ready(
		function() {
			esTab = true;
			otroTab = false;
			var lista = false;
			// Definicion de Constantes y Enums
			var catTipoTransaccionPuestos = {
				'agrega' : '1',
				'baja' : '2',
				'modifica' : '3'
			};

			var catTipoConsultaPuestos = {
				'principal' : 1

			};

			// ------------ Metodos y Manejo de Eventos// -----------------------------------------
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('elimina', 'submit');

			$('#gestorSi').attr('checked',false);
			$('#gestorNo').attr('checked',true);
			$('#supervisor').hide();
			$('#clavePuestoID').focus();
			$(':text').focus(function() {
				esTab = false;
			});

			$(':text').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});
			
			$('#clavePuestoID').focus(function() {	
			 	esTab = true;
			 	 deshabilitaBoton('agrega', 'submit'); 
                 deshabilitaBoton('modifica', 'submit');
                 deshabilitaBoton('elimina', 'submit');
                 if(isNaN($('#area').val())){
 			 		consultaArea('area');
 			 	 }
			});
			
			$('#area').focus(function() {	
			 	esTab = true;
			 	if(isNaN($('#categoriaID').val())){
			 		consultaCategoria('categoriaID');
			 	 }
			});
			
			$('#descripcion').focus(function() {	
			 	esTab = true;
			 	if(isNaN($('#area').val())){
			 		consultaArea('area');
			 	 }
			 	if(isNaN($('#categoriaID').val())){
			 		consultaCategoria('categoriaID');
			 	 }
			});
			
			$('#categoriaID').focus(function() {	
			 	esTab = true;
			 	 if(isNaN($('#area').val())){
			 		consultaArea('area');
			 	 }
			 	
			});
			
			$('#agrega').focus(function() {	
			 	esTab = true;
			 	 if(isNaN($('#categoriaID').val())){
			 		consultaCategoria('categoriaID');
			 	 }
			 	
			});
			
			$('#modifica').focus(function() {	
			 	esTab = true;
			 	 if(isNaN($('#categoriaID').val())){
			 		consultaCategoria('categoriaID');
			 	 }
			 	
			});
			
			$('#area').blur(function() {
				otroTab= false;
				if (lista == true){
					esTab = false;
					lista = false;
				}else{
					esTab=true;
					consultaArea(this.id);
				}
			});
			
				$('#categoriaID').blur(function() {
					otroTab= false;
					if (lista == true){
						esTab = false;
						lista = false;
					}else{
						esTab=true;
						consultaCategoria(this.id);	
					}
				});
				
			
				$.validator.setDefaults({
					submitHandler : function(event) {
						grabaFormaTransaccion(event, 'formaGenerica',
								'contenedorForma', 'mensaje', 'true',
								'clavePuestoID');
					}
				});

			
				 $('#clavePuestoID').bind('keyup',function(e){
					 if(this.value.length >= 2){ var camposLista = new Array(); var
						 parametrosLista = new Array(); camposLista[0] = "descripcion";
						 parametrosLista[0] = $('#clavePuestoID').val();
					 listaAlfanumerica('clavePuestoID', '1', '1', camposLista, parametrosLista, 'listaPuestos.htm'); 
					 };});
			

				 $('#area').bind('keyup',function(e){
					 if(this.value.length >= 2 && isNaN($('#area').val())){
						 var camposLista = new Array(); var
						 parametrosLista = new Array(); camposLista[0] = "descripcion";
						 parametrosLista[0] = $('#area').val();
					 listaAlfanumerica('area', '1', '1', camposLista, parametrosLista, 'listaAreas.htm'); 
					 lista = true;
					 } });
				
			 
				 $('#categoriaID').bind('keyup',function(e){
					 if(this.value.length >= 2&& isNaN($('#categoriaID').val())){
					 var camposLista = new Array(); var
					 parametrosLista = new Array(); camposLista[0] = "descripcion";
					 parametrosLista[0] = $('#categoriaID').val();
					 listaAlfanumerica('categoriaID', '1', '1', camposLista, parametrosLista, 'listaCategorias.htm'); 
					 lista = true;
					 } });
					
			 
					$('#agrega').click(function() {
						$('#tipoTransaccion').val(catTipoTransaccionPuestos.agrega);
					});
		
					$('#modifica').click(function() {
						$('#tipoTransaccion').val(catTipoTransaccionPuestos.modifica);
					});
					
					$('#elimina').click(function() {
						$('#tipoTransaccion').val(catTipoTransaccionPuestos.baja);
					});
		
					$('#clavePuestoID').blur(function() {
						validaPuestos(this.id);
					});
				
					$('#gestorSi').click(function() {
						$('#gestorSi').focus();
						$('#gestorSi').attr('checked',true);
						$('#gestorNo').attr('checked',false);
						$('#supervisor').show();
					});
					
					$('#gestorNo').click(function() {
						$('#gestorNo').focus();
						$('#gestorSi').attr('checked',false);
						$('#gestorNo').attr('checked',true);
						$('#supervisor').hide();
					});
					$('#gestorSi').blur(function() {
						$('#gestorSi').attr('checked',true);
						$('#gestorNo').attr('checked',false);
						$('#supervisor').show();
					});
					
					$('#gestorNo').blur(function() {
						$('#gestorSi').attr('checked',false);
						$('#gestorNo').attr('checked',true);
						$('#supervisor').hide();
					});

			// ------------ Validaciones de la Forma// -------------------------------------

			$('#formaGenerica').validate({

				rules : {

					clavePuestoID : {
						required : true,
						
					},

					descripcion : {
						required : true
					},
					
					area : {
						required : true
					},
					
					categoriaID : {
						required : true
					},

				},
				messages : {

					clavePuestoID : {
						required  : 'Especificar Clave.',
						
					},

					descripcion : {
						required : 'Especificar Descripción'
					},
					
					area : {
						required : 'Especificar Area'
					},
					
					categoriaID : {
						required : 'Especificar Categoria'
					},

				}
			});

			// ------------ Validaciones de Controles// -------------------------------------

		//----------Funcion consultaArea---------------------//
			function consultaArea(idControl) {
				var jqArea = eval("'#" + idControl + "'");
				var numArea = $(jqArea).val();
				var conArea = 2;
				var areasBeanCon = { 
		  				'area':numArea		  				
					};
				setTimeout("$('#cajaLista').hide();", 200);
				if (numArea != ''  && esTab) {
					puestosServicio.consulta(conArea,
							areasBeanCon, function(areas) {
								if (areas != null) {
									$('#descripcionArea').val(areas.descripcionArea);
								} 
								else{
									alert("No existe el Area "+ numArea);
									$('#descripcionArea').val('');	
									$('#area').focus();	
									$('#area').val("");
								}
						});
				}
			}
			
			//----------Funcion consultaCategoria---------------------//
			function consultaCategoria(idControl) {
				var jqCategoria = eval("'#" + idControl + "'");
				var numCategoria = $(jqCategoria).val();
				var conCategoria = 3;
				var categoriaBeanCon = { 
		  				'categoriaID':numCategoria		  				
					};
				setTimeout("$('#cajaLista').hide();", 200);
				if (numCategoria != ''  && esTab) {
					puestosServicio.consulta(conCategoria,
							categoriaBeanCon, function(categorias) {
								if (categorias != null) {
									$('#descripcionCategoria').val(categorias.descripcionCategoria);

								} 
								else{
									alert("No existe la Categoria "+ numCategoria);
									$('#descripcionCategoria').val('');	
									$('#categoriaID').focus();	
									$('#categoriaID').val("");
								}
							});
				}
			}
			
			function validaPuestos(control) {
				var numconcepto = $('#clavePuestoID').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numconcepto != '' && esTab){

					if(numconcepto !=null){
						habilitaBoton('agrega', 'submit');
						var puestosBeanCon = { 
		  				'clavePuestoID':$('#clavePuestoID').val()		  				
						};
						 
						puestosServicio.consulta(catTipoConsultaPuestos.principal,puestosBeanCon,function(puestos) {
								if(puestos!=null){
									dwr.util.setValues(puestos);
									esTab = true;
									consultaArea('area');
									consultaCategoria('categoriaID');
									if(puestos.atiende=='S'){                                 
					                    $('#atiende').attr("checked","1") ;
				                  	}
					               	else{
				                    		if(puestos.atiende=='N'){
				                  	  		$('#atiende2').attr("checked","1") ;}
					               	}
									if(puestos.esGestor=='S'){                               
										$('#gestorSi').attr('checked',true);
										$('#gestorNo').attr('checked',false);
										$('#supervisor').show();
				                  	}
					               	else{
				                    		if(puestos.esGestor=='N'){
				                    			$('#gestorSi').attr('checked',false);
				        						$('#gestorNo').attr('checked',true);
				        						$('#supervisor').hide();
				                  	  		}
					               	}
									deshabilitaBoton('agrega', 'submit');
									habilitaBoton('modifica', 'submit');	
									habilitaBoton('elimina', 'submit');	
									
								}
										
								else{
									
									deshabilitaBoton('modifica', 'submit');
									deshabilitaBoton('elimina', 'submit');
									inicializaForma('formaGenerica','clavePuestoID' );
									$('#atiende').attr("checked","1") ;
	                    			$('#gestorSi').attr('checked',false);
	        						$('#gestorNo').attr('checked',true);
	        						$('#supervisor').hide();
								}
						});
								
					}else {
                        deshabilitaBoton('agrega', 'submit'); 
                        deshabilitaBoton('modifica', 'submit');
                        deshabilitaBoton('elimina', 'submit');
                        inicializaForma('formaGenerica','clavePuestoID' );
						$('#atiende').attr("checked","1") ;
                       
					}									
				}
			}
			
		});
			