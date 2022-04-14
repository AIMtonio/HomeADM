$(document).ready(function() {

	esTab = true;

	// Definicion de Constantes y Enums
	var catTipoTransaccionInversiones = {
			'agrega' : 1,
			'modifica' : 2
	};
	
	var catTipoListaDiasInversion = {
			'principal':1,
			'secundaria':2
	};
	
	// Definicion de Constantes y Enums
	var catTipoConsultaTipoInversion = {
			'principal' : 1,
			'secundaria' : 2
	};

	var catTipoListaTipoInversion = {
			'todas' : 5
	};
	
	
	deshabilitaBoton('agregaInv', 'submit');
	$('#tipoInvercionID').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
			submitHandler: function(event) { 
         	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoInvercionID'); 
			}
    });			
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agregaInv').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionInversiones.agrega);
		creaPlazosInversion();
	});
			
	$('#tipoInvercionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		if(this.value.length >= 3){
			var camposLista = new Array();
        	var parametrosLista = new Array();
        	camposLista[0] = "monedaId";
        	camposLista[1] = "descripcion";
        	parametrosLista[0] = 0;
        	parametrosLista[1] = $('#tipoInvercionID').val();
        	
       	lista('tipoInvercionID', 3, catTipoListaTipoInversion.todas,
       			 camposLista, parametrosLista, 'listaTipoInversiones.htm');		
		}
	});
		
	$('#tipoInvercionID').blur(function() {
		validaTipoInversion();
		if(!isNaN($('#tipoInvercionID').val())){
			consultaPlazos();
		}
		
	});
	
	function consultaPlazos(){	
		var params = {};
		params['tipoLista'] = 1;
		params['tipoInvercionID'] = $('#tipoInvercionID').val();
		
		$.post("gridDiasInversion.htm", params, function(data){
				if(data.length >0) {
					$('#gridPlazos').html(data);
					$('#gridPlazos').show();
				}else{
					$('#gridPlazos').html("");
					$('#gridPlazos').show();
				}
		});
	}

	$('#formaGenerica').validate({
		rules: {
			tipoInvercionID: { 
				minlength: 1
			}
		},
		messages: { 			
		 	tipoInvercionID: {
				minlength: 'Al menos un Caracter'
			}
		}		
	});
	
	function validaTipoInversion(){			
		var tipoInversion = $('#tipoInvercionID').val();		
		var tipoConsulta = catTipoConsultaTipoInversion.secundaria;		
		setTimeout("$('#cajaLista').hide();", 200);
		
		var tipoInversionBean = {
      	'tipoInvercionID':tipoInversion,
         'monedaId':0
      };		
		
		if(tipoInversion != '' && !isNaN(tipoInversion) && esTab){
					
			
			tipoInversionesServicio.consultaPrincipal(tipoConsulta, tipoInversionBean, function(tipoInver){
				
				if(tipoInver!=null){							
					$('#descripcion').val(tipoInver.descripcion);
					$('#monedaID').val(tipoInver.monedaId);
					$('#descripcionMoneda').val(tipoInver.descripcionMoneda);
					$('#estatusTipoInver').val(tipoInver.estatus);
					if(tipoInver.estatus == 'I'){
						mensajeSis("El Producto "+tipoInver.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						deshabilitaBoton('agregaInv', 'submit');
						$('#tipoInvercionID').focus();	
					}else{
						habilitaBoton('agregaInv', 'submit');	
					}
									
				}else{
					mensajeSis("No Existe el Tipo de Inversión");
					$('#tipoInvercionID').focus();	
					$('#estatusTipoInver').val('');
				}
			});
		}
	}
	
	function creaPlazosInversion(){
		var contador = 1;	
		$('#diasInferior').val("");
		$('#diasSuperior').val("");		
		
		$('input[name=plazoInferior]').each(function() {					
			if (contador != 1){
				$('#diasInferior').val($('#diasInferior').val() + ','  + this.value);
			}else{
				$('#diasInferior').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=plazoSuperior]').each(function() {
			if (contador != 1){
				$('#diasSuperior').val($('#diasSuperior').val() + ','  + this.value);
			}else{
				$('#diasSuperior').val(this.value);
			}
			contador = contador + 1;
		});
	}
	

});

