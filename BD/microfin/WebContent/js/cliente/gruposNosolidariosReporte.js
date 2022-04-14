$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();
	$('#sucursalID').val(parametroBean.sucursal);

	var banGru=0;
	var banPro=0;
	//------------------Metodos y manejo de eventos----------------
	
	$('#sucursalIni').val('0');
	$('#nombreSucursalIni').val('TODAS');
	$('#grupoIniID').val('0');
	$('#nombreGrupoIni').val('TODOS');
	$('#grupoFinID').val('0');
	$('#nombreGrupoFin').val('TODOS');
	$('#promotorIni').val('0');
	$('#nombrePromotorIni').val('TODOS');
	$('#promotorFin').val('0');
	$('#nombrePromotorFin').val('TODOS');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grupoIniID').bind('keyup',function(e) { 
		var sucursal=$('#sucursalIni').val();
		if(sucursal == ''){
			sucursal=0;
		}
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreGrupo";
		camposLista[1] = "sucursal";
		parametrosLista[0] = $('#grupoIniID').val();
		parametrosLista[1] = sucursal;  
		
		lista('grupoIniID', '2', '1', camposLista, parametrosLista, 'listaGruposNosolidarios.htm');
		});
	$('#grupoIniID').blur(function() {
  		consultaNombre(this.id,'I');
	});
	
	$('#grupoFinID').bind('keyup',function(e) { 
		var sucursal=$('#sucursalIni').val();
		if(sucursal == ''){
			sucursal=0;
		}
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreGrupo";
		camposLista[1] = "sucursal";
		parametrosLista[0] = $('#grupoFinID').val();
		parametrosLista[1] = sucursal;  
		
		lista('grupoFinID', '2', '1', camposLista, parametrosLista, 'listaGruposNosolidarios.htm');
});
	$('#grupoFinID').blur(function() {
  		consultaNombre(this.id,'F');
	});
	$('#promotorIni').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorIni').val();
		parametrosLista[1] = parametroBean.sucursal; 
		if($('#sucursalIni').val() != 0 ){
			parametrosLista[1] = $('#sucursalIni').val();  
			lista('promotorIni', '1', '2',camposLista, parametrosLista, 'listaPromotores.htm');
		}else{
			lista('promotorIni', '1', '1',camposLista, parametrosLista, 'listaPromotores.htm');
		}
	});
	$('#promotorIni').blur(function() {
		consultaPromotor(this.id, 'I');
	});
	$('#promotorFin').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorFin').val();
		parametrosLista[1] = parametroBean.sucursal; 
		if($('#sucursalIni').val() != 0 ){
			parametrosLista[1] = $('#sucursalIni').val();  
			lista('promotorFin', '1', '2',camposLista, parametrosLista, 'listaPromotores.htm');
		}else{
			lista('promotorFin', '1', '1',camposLista, parametrosLista, 'listaPromotores.htm');
			
		}
	});
	$('#promotorFin').blur(function() {
		consultaPromotor(this.id, 'F');
	});
	
	$('#sucursalIni').bind('keyup',function(e){	
		lista('sucursalIni', '2', '1', 'nombreSucurs', $('#sucursalIni').val(), 'listaSucursales.htm');
	});
	$('#sucursalIni').blur(function() {
  		consultaSucursal(this.id,'I');
	});	
	$('#sucursalFin').bind('keyup',function(e){	
		lista('sucursalFin', '2', '1', 'nombreSucurs', $('#sucursalFin').val(), 'listaSucursales.htm');
	});
	$('#sucursalFin').blur(function() {
  		consultaSucursal(this.id, 'F');
	});	
	
	$('#pdf').click(function() {	
		$('#excel').attr("checked",false);
		if($('#pdf').is(':checked')){
			$('#excel').focus();		
		}
	});
	
	$('#excel').click(function() {	
		$('#pdf').attr("checked",false);
		if($('#excel').is(':checked')){
			$('#generar').focus();		
		}
	});
	$('#generar').click(function() {
		enviaDatosReporte();
	});
	//-----------------Funciones---------------------------------
	function consultaNombre(idControl,tipo){
		setTimeout("$('#cajaLista').hide();", 200);
		var jqGrupo = eval("'#" + idControl + "'");
		var numGrupo = $(jqGrupo).val();
		var tipoConsulta=1;
		var gruposNosolidariosBean = {
				'grupoID'	:numGrupo
			};
	
		if(numGrupo != '' && !isNaN(numGrupo) && esTab){
			if(numGrupo == 0){
				if(tipo=='I'){
					$('#nombreGrupoIni').val('TODOS');
				}
				if(tipo=='F'){
					$('#nombreGrupoFin').val('TODOS');
				}
				}else{
				
				gruposNosolidarios.consulta(tipoConsulta,gruposNosolidariosBean, function(grupo){
					if(grupo != null){
						if(tipo=='I'){
							if(grupo.sucursalID == $('#sucursalIni').val() && ($('#sucursalIni').val() != 0 || $('#sucursalIni').val() !='')){
							$('#nombreGrupoIni').val(grupo.nombreGrupo);
						
							banGru=0;
						}else{
								if($('#sucursalIni').val() != 0){
										alert('El Grupo No Pertenece a la Sucursal');
										$('#grupoIniID').val('');
										$('#grupoIniID').focus();
										$('#nombreGrupoIni').val('');
								}else{
									$('#nombreGrupoIni').val(grupo.nombreGrupo);
								}
							}
						}
						if(tipo=='F'){
							if(grupo.sucursalID == $('#sucursalIni').val() && ($('#sucursalIni').val() != 0 || $('#sucursalIni').val() !='')){
							$('#nombreGrupoFin').val(grupo.nombreGrupo);
							validaGrupo('F');
							banGru=0;
							}else{
								if($('#sucursalIni').val() != 0){
									alert('El Grupo No Pertenece a la Sucursal');
									$('#grupoFinID').val('');
									$('#grupoFinID').focus();
									$('#nombreGrupoFin').val('');
							}else{
								$('#nombreGrupoFin').val(grupo.nombreGrupo);
								validaGrupo('F');
							}
								}
						}
						
					}else{
						alert('El Grupo no Existe');
						if(tipo=='I'){
							$('#nombreGrupoIni').val('');
							$('#grupoIniID').val('');
							$('#grupoIniID').focus();
						}
						if(tipo=='F'){
							$('#nombreGrupoFin').val('');
							$('#grupoFinID').val('');
							$('#grupoFinID').focus();
						}
						
					}
					
						
					});
				}
		}else{
			if(numGrupo == ''){
				if(tipo =='I')
					 $('#nombreGrupoIni').val('');
				 if(tipo =='F')
					 $('#nombreGrupoFin').val('');	
				}
		}
		
	}
	function consultaPromotor(idControl, tipo) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
				if(numPromotor ==0){
					if(tipo =='I')
						 $('#nombrePromotorIni').val("TODOS");
					 if(tipo =='F')
						 $('#nombrePromotorFin').val("TODOS");
				}else{
					
					promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
						if (promotor != null) {
							if(promotor.estatus != 'A'){
								alert("El promotor debe de estar Activo");
								 $(jqPromotor).val("");
								 $(jqPromotor).focus();
								 if(tipo =='I')
									 $('#nombrePromotorIni').val("");
								 if(tipo =='F')
									 $('#nombrePromotorFin').val("");
							}else{
								
									 if(tipo =='I'){
										if(promotor.sucursalID == $('#sucursalIni').val() && ($('#sucursalIni').val() != 0 || $('#sucursalIni').val() !='')){
										 $('#nombrePromotorIni').val(promotor.nombrePromotor);
										
										 banPro=0;
										}else{
										
												if($('#sucursalIni').val() != 0){
													alert('El Promotor No Pertenece a la Sucursal');
													$('#promotorIni').val('');
													$('#promotorIni').focus();
													$('#nombrePromotorIni').val('');
												}else{
													 $('#nombrePromotorIni').val(promotor.nombrePromotor);
											}
											}
										 }
										
									 if(tipo =='F'){
										 if(promotor.sucursalID == $('#sucursalIni').val() && ($('#sucursalIni').val() != 0 || $('#sucursalIni').val() !='')){
										 $('#nombrePromotorFin').val(promotor.nombrePromotor);
										 validaPromotor('F');
										 banPro=0;
											}else{
												if($('#sucursalIni').val() != 0){
														alert('El Promotor No Pertenece a la Sucursal');
														$('#promotorFin').val('');
														$('#promotorFin').focus();
														$('#nombrePromotorFin').val('');
												}else{
													 $('#nombrePromotorFin').val(promotor.nombrePromotor);
													 validaPromotor('F');
												}
									 }
		
								}
							}
												
						} else {
							alert("El Promotor No Existe");
							 if(tipo =='I'){
								 $('#promotorIni').focus();
								 $('#promotorIni').val('');
								 $('#nombrePromotorIni').val('');
							 }
							 if(tipo =='F'){
								 $('#promotorFin').focus();
								 $('#nombrePromotorFin').val('');
								 $('#promotorFin').val('');
							 }
								
						}
					});
				}
		}else{
			if($('#promotorIni').val() == '' || $('#promotorFin').val() ==''){
				 if(tipo =='I'){
				
					 $('#promotorIni').val('');
					 $('#nombrePromotorIni').val('');
				 }
				 if(tipo =='F'){
					
					 $('#nombrePromotorFin').val('');
					 $('#promotorFin').val('');
			}
		}
	}
	}
	function consultaSucursal(idControl, tipo) {
	
		setTimeout("$('#cajaLista').hide();", 200);
		var jqGrupo = eval("'#" + idControl + "'");
		var numSucursal = $(jqGrupo).val();
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){	
			if(numSucursal==0){
				if(tipo =='I'){
					 $('#nombreSucursalIni').val("TODAS");
				}
	
			}else{
				
			
				sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) {
						if(sucursal!=null){
							if(tipo =='I'){
								 $('#nombreSucursalIni').val(sucursal.nombreSucurs);
								 validaSucursal('I');
								 banSuc=0;
							}
							 if(tipo =='F'){
								 $('#nombreSucursalFin').val(sucursal.nombreSucurs);
								 validaSucursal('F');
								 banSuc=0;
							 }
						}else{
							alert("No Existe la Sucursal");
							if(tipo =='I'){
								 $('#nombreSucursalIni').val('');
								 $('#sucursalIni').val('');
							 	 $('#sucursalIni').focus();
							}
						}
					});
				}				
			}else{
				if(numSucursal == ''){
				if(tipo =='I')
					 $('#nombreSucursalIni').val('');
				 if(tipo =='F')
					 $('#nombreSucursalFin').val('');	
				}
			}
			}
												
		

	function validaSucursal(control){
		var numSucursal;

		
		if($('#sucursalIni').val() != ''  && !isNaN($('#sucursalIni').val()) )		
			if($('#sucursalFin').val() != ''  && !isNaN($('#sucursalFin').val()) )
				if($('#sucursalIni').val() > $('#sucursalFin').val()){
					alert('La Sucursal Inicial Debe Ser Menor o Igual a la Sucursal Final');
					if(control == 'I'){
						$('#sucursalFin').val($('#sucursalIni').val());
						numSucursal = $('#sucursalFin').val();
					}
					if(control == 'F'){
						$('#sucursalIni').val($('#sucursalFin').val());
						numSucursal = $('#sucursalIni').val();
					}	
				
					sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) {
								if(sucursal!=null){
										$('#nombreSucursalIni').val(sucursal.nombreSucurs);
										 $('#nombreSucursalFin').val(sucursal.nombreSucurs);			
										 
										}
						});
				}
		}
	
	function validaGrupo(control){
		var numGrupo;

		if($('#grupoIniID').val() == 0 ){
			$('#grupoIniID').val('0');
			$('#grupoFinID').val('0');
			$('#nombreGrupoIni').val("TODOS");
			$('#nombreGrupoFin').val("TODOS");
			alert('Se Requiere el Grupo Inicial');
			$('#grupoFinID').focus();
		}else{	
				if($('#grupoIniID').val() != ''  && !isNaN($('#grupoIniID').val()) )		
					if($('#grupoFinID').val() != ''  && !isNaN($('#grupoFinID').val()) )
						if($('#grupoIniID').val() > $('#grupoFinID').val()){
							alert('El Grupo Inicial Debe Ser Menor o Igual al Grupo Final');
							if(control == 'I'){
								$('#grupoFinID').val($('#grupoIniID').val());
								numGrupo = $('#grupoFinID').val();
							}
							if(control == 'F'){
								$('#grupoIniID').val($('#grupoFinID').val());
								numGrupo = $('#grupoIniID').val();
							}	
							var tipoConsulta=1;
							var gruposNosolidariosBean = {
									'grupoID'	:numGrupo
								};
							gruposNosolidarios.consulta(tipoConsulta,gruposNosolidariosBean, function(grupo){
								if(grupo != null){
								
										$('#nombreGrupoIni').val(grupo.nombreGrupo);
								
										$('#nombreGrupoFin').val(grupo.nombreGrupo);
									}
								
									
								});
						}else{
							banGru=0;
						}
		}
		}
	function validaPromotor(control){
		var numPromotor;
	
		if($('#promotorIni').val()==0 ){
			$('#promotorFin').val('0');
			$('#promotorIni').val('0');
			 $('#nombrePromotorIni').val('TODOS');
			 $('#nombrePromotorFin').val('TODOS');
			 alert('Se Require el Promotor Inicial');
			 $('#promotorFin').focus();
			 
			
		}else{
				if($('#promotorIni').val() != ''  && !isNaN($('#promotorIni').val()) )		
					if($('#promotorFin').val() != ''  && !isNaN($('#promotorFin').val()) )
						if(parseInt ($('#promotorIni').val()) > parseInt( $('#promotorFin').val())){
							alert('El Promotor Inicial Debe Ser Menor o Igual al Promotor Final' + $('#promotorIni').val() + $('#promotorFin').val());
							if(control == 'I'){
								$('#promotorFin').val($('#promotorIni').val());
								numPromotor = $('#promotorFin').val();
							}
							if(control == 'F'){
								$('#promotorIni').val($('#promotorFin').val());
								numPromotor = $('#promotorIni').val();
							}	
							var tipConForanea = 2;
							var promotor = {
								'promotorID' : numPromotor
							};
							promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
								if (promotor != null) {
									
										 $('#nombrePromotorIni').val(promotor.nombrePromotor);
										 $('#nombrePromotorFin').val(promotor.nombrePromotor);
								}
									
								});
						}else{
							banPro=0;
						}
			}
		}
		function enviaDatosReporte(){

			var sucursal= $('#sucursalIni').val();
		
			var grupoI= $('#grupoIniID').val();
			var grupoF= $('#grupoFinID').val();
			var promotorI= $('#promotorIni').val();
			var promotorF= $('#promotorFin').val();
			
			var sucursalDes= $('#nombreSucursalIni').val();
		
			var grupoIdes= $('#nombreGrupoIni').val();
			var grupoFdes= $('#nombreGrupoFin').val();
			var promotorIdes= $('#nombrePromotorIni').val();
			var promotorFdes= $('#nombrePromotorFin').val();
		
			var nombreUsuario=parametroBean.claveUsuario;
			var nombreInstitucion=parametroBean.nombreInstitucion;
			var fechaEmision=parametroBean.fechaSucursal;
			

			
		
				if(sucursal!='' && sucursalDes!='' ){
					sucursalDes='';
					sucursalDes= ' '+$('#sucursalIni').val()+' - '+$('#nombreSucursalIni').val();						
					}else{
						sucursal=0;
						sucursalDes='TODOS';
						
					}
				
				 if(grupoI != '' && grupoIdes != '' && grupoI !=0  )
						if(grupoF == '' || grupoF == 0 ){
							alert('Favor de Especificar el Grupo Final');
							$('#grupoFinID').focus();
							banGru++;
						
				 }else{
					 banGru=0;
				 }
				 
					if(grupoF != '' && grupoFdes != '' && grupoF !=0 )
						if(grupoI == '' || grupoI==0 ){
							alert('Favor de Especificar el Grupo Inicial');
							$('#grupoIniID').focus();
							banGru++;
						
					}else{
						banGru=0;
					}
					
				if(grupoI!='' && grupoIdes!='' && grupoF!='' && grupoFdes!='' ){
					if(grupoI !=0 && grupoF !=0 ){
							if(grupoI<= grupoF && grupoI != 0 && grupoF !=0){
								grupoIdes='';
								grupoIdes= ' '+$('#grupoIniID').val()+' - '+$('#nombreGrupoIni').val();
								grupoFdes='';
								grupoFdes= ' '+$('#grupoFinID').val()+' - '+$('#nombreGrupoFin').val();	
								banGru=0;
							}else{
								alert('El Grupo Inicial Debe Ser Menor o Igual al Grupo Final');
								$('#grupoIniID').focus();
								$('#grupoIniID').val('');
								$('#nombreGrupoIni').val('');
								banGru=1;
							}
					}
						
					}else{
						
						grupoI='0';								
						grupoF='0';
						grupoIdes='TODOS';
						grupoFdes='TODOS';
						banGru=0;
					}
				
				
				 if(promotorI != '' && promotorIdes != '' && promotorI !=0 )
						if(promotorF == '' || promotorF==0 ){
							alert('Favor de Especificar el Promotor Final');
							$('#promotorFin').focus();
							banPro++;
						
				 }else{
					 banPro=0; 
				 }
				 
					if(promotorF != '' && promotorFdes != '' && promotorF !=0)
						if(promotorI == '' || promotorI==0){
							alert('Favor de Especificar el Promotor Inicial');
							$('#promotorIni').focus();
							banPro++;
						}else{
						banPro=0;
					}
					
				if(promotorI!='' && promotorIdes!='' && promotorF!='' && promotorFdes!='' ){
					if( promotorI != 0 && promotorF !=0){
							if(parseInt(promotorI) <= parseInt(promotorF) ){
								promotorIdes='';
								promotorIdes= ' '+$('#promotorIni').val()+' - '+$('#nombrePromotorIni').val();
								promotorFdes='';
								promotorFdes= ' '+$('#promotorFin').val()+' - '+$('#nombrePromotorFin').val();		
								banPro=0;
							}else{
								if( banGru==0){
								
								alert('El Promotor Inicial Debe Ser Menor o Igual al Promotor Final');
								$('#promotorIni').focus();
								$('#promotorIni').val('');
								$('#nombrePromotorIni').val('');
								banPro=1;
								}
					}
					}
						
						
					}else{
						promotorI='0';								
						promotorF='0';
						promotorIdes='TODOS';
						promotorFdes='TODOS';
						banPro=0;
					}
			
		
							if( $('#pdf').attr('checked')==false && $('#excel').attr('checked')==false){
								alert("No ha seleccionado Ninguna Opción Para la Presentación del Reporte");
							}else{
								if($('#pantalla').is(':checked')){
									tipoReporte = 1;
				
								}
								if($('#pdf').is(':checked')){
									tipoReporte = 1;
								}
								if($('#excel').is(':checked')){
									tipoReporte = 2;
									tipoLista = 2;
								}
									
									if(banGru==0 && banPro==0){
										var pagina='RepGruposNoSolidarios.htm?grupoIni='+grupoI+'&grupoIniDes='+grupoIdes+'&grupoFin='+grupoF+'&grupoFinDes='+grupoFdes+
										  '&sucursal='+sucursal+'&sucursalDes='+sucursalDes+'&promotorIni='+
										  promotorI+'&promotorIniDes='+promotorIdes+'&promotorFin='+promotorF+'&promotorFinDes='+promotorFdes+'&tipoReporte='+tipoReporte+
										  '&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaEmision='+fechaEmision;
										window.open(pagina,'_blank');
									}
										 
								}
		}

});