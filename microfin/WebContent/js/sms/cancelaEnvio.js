$(document).ready(function(){
	esTab = false;
	var parametroBean = consultaParametrosSession();

	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
		var parametroBean = consultaParametrosSession();   
		//DefiniciÃ³n de constantes y Enums
		
		var catTipoConCancelaSMS = { 
  		'principal'	: 1,
  		'foranea'	: 2
	};	
			
		var catTipoTranCancelaSMS = { 
  		'cancelar'	: 3,
  		
	};		
		//-----------------------Metodos y manejo de eventos-----------------------
		
	deshabilitaBoton('cancelar', 'submit');
	agregaFormatoControles('formaGenerica');

   	$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','campaniaID'); 
						  deshabilitaBoton('cancelar', 'submit');
			
            }
    });	
    
  	$('#campaniaID').focus();

	$('#cancelar').click(function(){
		$('#tipoTransaccion').val(catTipoTranCancelaSMS.cancelar);		

	});
	
	
	$('#campaniaID').blur(function(){
		if (esTab) {
			consultaCampania(this.id);		

		}
	});
		
	
	$('#campaniaID').bind('keyup',function(e) { 
		lista('campaniaID', '1', '1', 'nombre', $('#campaniaID').val(),'campaniasLista.htm');
	});
	

	
	$('#soloMensajes').click(function(){
		$('#Ambos').attr("checked",false) ;
	});
	
	$('#Ambos').click(function(){
		$('#soloMensajes').attr("checked",false) ;
	});		

	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			
			campaniaID: {
				required: true
			}
		},
		
		
		messages: {

			campaniaID: {
				required: 'Especificar Campania'
			}
		}		
	});

	
//-------------Validaciones de controles---------------------
			
	function consultaCampania(idControl){
		var jqCampania  = eval("'#" + idControl + "'");
		var numCam = $(jqCampania).val();	
		

		setTimeout("$('#cajaLista').hide();", 200);
		if(numCam != '' && !isNaN(numCam)){
			inicializaForma('formaGenerica','campaniaID');
			var CampBeanCon = { 
			'campaniaID' :numCam
			};
			campaniasServicio.consulta(catTipoConCancelaSMS.principal,CampBeanCon,{ async: false, callback:function(campanias) {
						if(campanias!=null){
							dwr.util.setValues(campanias);
							habilitaBoton('cancelar', 'submit');
							 esTab=true;	
							 $('#nomCampania').val(campanias.nombre);
							 consultaTipoCampania('tipo');
							 if(campanias.estatus = 'V'){
								 $('#estatus').val('VIGENTE');
							 }else
								 if(campanias.estatus = 'C'){
									 $('#estatus').val('CANCELADA');
								 }
								 else
									 if(campanias.estatus = 'F'){
										 $('#estatus').val('FINALIZADA');
									 }
								 $('#fechaCancelacion').val(parametroBean.fechaSucursal);
						}else{
							inicializaForma('formaGenerica','campaniaID');
							mensajeSis("La Campania no existe");
							$('#campaniaID').focus();
							deshabilitaBoton('cancelar', 'submit');
							
						}
				}});
		}else{
			inicializaForma('formaGenerica','campaniaID');
			mensajeSis("La Campania no existe");
			$('#campaniaID').focus();
			deshabilitaBoton('cancelar', 'submit');
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

			tipoCampaniasServicio.consulta(catTipoConCancelaSMS.principal,tipoCampBeanCon,{ async: false, callback:function(tipoCampania) {
						if(tipoCampania!=null){
							 esTab=true;	
							 $('#nomTipo').val(tipoCampania.nombre);
							
						}else{
							mensajeSis("El tipo de Campania no existe");
							$('#tipoCampaniaID').focus();
						}
				}});
		}else{
			mensajeSis("El tipo de Campania no existe");
			$('#tipoCampaniaID').focus();
		}
	}
	



	});