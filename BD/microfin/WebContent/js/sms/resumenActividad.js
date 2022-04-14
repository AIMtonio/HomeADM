$(document).ready(function(){
		esTab = false;
		
		$(':text').focus(function() {	
	 	esTab = false;
		});
	    
		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});	
		//Definicion de constantes y Enums
		
		var catTipoConResumen = { 
			'principal'	: 1,
			'foranea'	: 2
		};	
			
		var catTipoTranResumen = { 
			'agrega'		: 1,
			'modifica'	: 2
		};		
		
		var catTipoLisResumen = { 
		  	'principal'	: 1,
		  	'resumen'	: 2
		};	

		
		//-----------------------Metodos y manejo de eventos-----------------------
		
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('modificar', 'submit');
		$('#campaniaID').focus();
		$(':text').focus(function() {	
	});
	
	agregaFormatoControles('formaGenerica');
	
	
	$('#campaniaID').blur(function(){
		if(esTab){
		consultaCampania(this.id);		

		}
	});
		
	
	$('#campaniaID').bind('keyup',function(e) { 
		lista('campaniaID', '1', '1', 'nombre', $('#campaniaID').val(),'campaniasLista.htm');
	});
	

		
//-------------Validaciones de controles---------------------
	
	function consultaCampania(idControl){
		var jqCampania  = eval("'#" + idControl + "'");
		var numCam = $(jqCampania).val();	
		

		setTimeout("$('#cajaLista').hide();", 200);
		if(numCam != '' && !isNaN(numCam)){
			
			var CampBeanCon = { 
			'campaniaID' :numCam
			};
			campaniasServicio.consulta(catTipoConResumen.principal,CampBeanCon,{ async: false, callback:function(campanias) {
						if(campanias!=null){
							dwr.util.setValues(campanias);
							 esTab=true;	
							 $('#nomCampania').val(campanias.nombre);
							 consultaTipoCampania('tipo');	
							 consultaGridResumenAct();
							if (campanias.clasificacion == 'I' ){
								consultaCodigos();
								$('#campaniaID').focus();
							}else{
								$('#gridCodigosResp').html("");
								}
						}else{
							$('#gridResumenActividad').html("");
							$('#gridCodigosResp').html("");
							mensajeSis("La Campania no existe");
							$('#campaniaID').val('');
							$('#campaniaID').focus();
							limpiar();
							
						}
				}});
			
		}else{

			$('#gridResumenActividad').html("");
			$('#gridCodigosResp').html("");
			mensajeSis("La Campania no existe");
			$('#campaniaID').val('');
			$('#campaniaID').focus();
			limpiar();
		}
		
	}
	
	function consultaTipoCampania(idControl){
		var jqTipoCam  = eval("'#" + idControl + "'");
		var numTipoCam = $(jqTipoCam).val();	
		

		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCam != '' && !isNaN(numTipoCam) && esTab){
			
			var tipoCampBeanCon = { 
			'tipoCampaniaID' :numTipoCam
			};

			tipoCampaniasServicio.consulta(catTipoConResumen.principal,tipoCampBeanCon,function(tipoCampania) {
						if(tipoCampania!=null){
							 esTab=true;	
							 $('#nomTipo').val(tipoCampania.nombre);
							
						}else{
							mensajeSis("El tipo de Campania no existe");
							$('#tipoCampaniaID').focus();
							
						}
				});
			
		}
		
	}
	
	function limpiar(){
		$('#campaniaID').focus();
		$('#nomCampania').val('');
		$('#tipo').val('');
		$('#nomTipo').val('');
		$('#clasificacion').val('E');
		$('#categoria').val('A');

	}

	function consultaGridResumenAct(){	
		var params = {};
		params['tipoLista'] = catTipoLisResumen.resumen;
		params['campaniaID'] = $('#campaniaID').val();
		
		$.post("resumenActividadGridVista.htm", params, function(data){
				if(data.length >0) {		
						$('#gridResumenActividad').html(data);
						$('#gridResumenActividad').show();		
						 alternaFilas('alternacolor');			
				}else{				
						$('#gridResumenActividad').html("");
						$('#gridResumenActividad').show();
				}
		});
	}
	

	function consultaCodigos(){	
		var params = {};
		params['tipoLista'] = 3;
		params['campaniaID'] = $('#campaniaID').val();
		
		$.post("codRespResumenActGridVista.htm", params, function(data){
				if(data.length >0) {		
						$('#gridCodigosResp').html(data);
						$('#gridCodigosResp').show();	
						 alternaFilas('alternacolor2');							
				}else{				
						$('#gridCodigosResp').html("");
						$('#gridCodigosResp').show();
				}
		});
	}
	
	

	});


