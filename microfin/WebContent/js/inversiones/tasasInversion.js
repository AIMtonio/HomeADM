 $(document).ready(function() {
	esTab = true;
	$('#tipoInvercionID').focus();

	// Definicion de Constantes y Enums
	var catTipoTransaccionTasasInvercion = {
			'agrega' : 1,
			'modifica' : 2
	};
	
	var catTipoListaTasasInversion = {
			'principal':1,
			'secundaria':2,
			'tercera':3
	};

	var catTipoListaDiasInversion = {
		'combo':2
	};
	var catTipoListaMontosInversion = {
		'combo':2
	};

	
	// Definicion de Constantes y Enums
	var catTipoConsultaTasasInversion = {
			'principal' : 1,
			'dias': 2,
			'montos': 3,
			'comboBox' : 5
	};
	
	
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('imprimir', 'submit');
	
	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
			
	$.validator.setDefaults({
		submitHandler: function(event) { 
				grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoInvercionID');
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
			}
	});
	
		
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTasasInvercion.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTasasInvercion.modifica);
	});
	
	
	$('#formaGenerica').validate({
		
		rules: {
			conceptoInversion: {
					required: true,
					number: true,
					min: 0.01
			},
			tipoInvercionID:  'required',
			diaInversionID:  'required',
			montoInversionID:  'required'
			
			
		},
		
		messages: {
			conceptoInversion: 'Se requiere una tasa Anualizada',
			tipoInvercionID:  'Se requiere una Inversion',
			diaInversionID:  'Se requiere un dia',
			montoInversionID:  'Se requiere un monto'
			
		}
		
	});
	
	$('#tipoInvercionID').bind('keyup',function(e){
		if(this.value.length >= 3){
			
			var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "monedaId";
			 camposLista[1] = "descripcion";
			 parametrosLista[0] = 0;
			 parametrosLista[1] = $('#tipoInvercionID').val();
			
			lista('tipoInvercionID', 3, '5', camposLista, parametrosLista, 'listaTipoInversiones.htm');
		}
	});
		
	$('#tipoInvercionID').blur(function() {
		validaTipoInvercion(this);
		
		
		
		var tipoInvercion = $('#tipoInvercionID').val();
		var diasInversionBean = {
	  		'tipoInvercionID':tipoInvercion
		};
		var montosInversionBean = {
	  		'tipoInversionID':tipoInvercion
		};
		
				
		if(!isNaN(tipoInvercion) && tipoInvercion != ''){
			
			dwr.util.removeAllOptions('diaInversionID');
			dwr.util.removeAllOptions('montoInversionID');
			
			dwr.util.addOptions( "diaInversionID", {cero:'SELECCIONAR'});
			dwr.util.addOptions( "montoInversionID", {cero:'SELECCIONAR'});
										
			diasInversionServicio.listaCombo(
				catTipoListaDiasInversion.combo,
				diasInversionBean,
				function(dias){
					dwr.util.addOptions('diaInversionID', dias, 'diaInversionID', 'diaInversionDescripcion');
			});
						
			montosInversionServicio.listaCombo(
				catTipoListaMontosInversion.combo,
				montosInversionBean,				
				function(montos){
					dwr.util.addOptions('montoInversionID', montos, 'montoInversionID', 'montoInversionDescripcion');
			});		
			
		}
		if(isNaN($('#tipoInvercionID').val()) ){
			$('#tipoInvercionID').val("");
			$('#tipoInvercionID').focus();
			
		
		}
		
	});
	
	
	$('#diaInversionID').change(function(){
		
		var tasasInversion = obtieneVariables();
		var estatusTipoCed = "";
		
		if($('#diaInversionID').val()!='cero' && $('#montoInversionID').val()!='cero'){
			estatusTipoCed = $('#estatusTipoInver').val();
			tasasInversionServicio.consultaPrincipal(catTipoConsultaTasasInversion.principal, tasasInversion, function(porcentaje){
					
				if(porcentaje!=null){
					$('#tasaInversionID').val(porcentaje.tasaInversionID);
					$('#conceptoInversion').val(porcentaje.conceptoInversion);
					$('#gatInformativo').val(porcentaje.gatInformativo);
					deshabilitaBoton('agrega', 'submit');
					
					if(estatusTipoCed == 'I'){
						deshabilitaBoton('modifica', 'submit');
						mensajeSis("El Producto "+$('#descripcion').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						$('#tipoInvercionID').focus();
					}else{
						habilitaBoton('modifica', 'submit');
					}
					
				}else{
					$('#conceptoInversion').val("0.0");
					$('#gatInformativo').val("0.0");
					if(estatusTipoCed == 'I'){
						deshabilitaBoton('agrega', 'submit');
						mensajeSis("El Producto "+$('#descripcion').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						$('#tipoInvercionID').focus();
					}else{
						habilitaBoton('agrega', 'submit');
					}
					deshabilitaBoton('modifica', 'submit');
				}
							
				
			});
		}
	});
	
	
	$('#montoInversionID').change(function(){
		
		var tasasInversion = obtieneVariables();
		var estatusTipoCed = "";
		
		if($('#diaInversionID').val()!='cero' && $('#montoInversionID').val()!='cero'){
			estatusTipoCed = $('#estatusTipoInver').val();
			tasasInversionServicio.consultaPrincipal(catTipoConsultaTasasInversion.principal, tasasInversion, function(porcentaje){
					
				if(porcentaje!=null){
					$('#tasaInversionID').val(porcentaje.tasaInversionID);
					$('#conceptoInversion').val(porcentaje.conceptoInversion); // aqui
					$('#gatInformativo').val(porcentaje.gatInformativo);
					deshabilitaBoton('agrega', 'submit');
					if(estatusTipoCed == 'I'){
						deshabilitaBoton('modifica', 'submit');
						mensajeSis("El Producto "+$('#descripcion').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						$('#tipoInvercionID').focus();
						$('#tipoInvercionID').focus();
					}else{
						habilitaBoton('modifica', 'submit');
					}
					
				}else{
					$('#conceptoInversion').val("0.0");
					$('#gatInformativo').val("0.0");
					if(estatusTipoCed == 'I'){
						deshabilitaBoton('agrega', 'submit');
						mensajeSis("El Producto "+$('#descripcion').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					}else{
						habilitaBoton('agrega', 'submit');
					}
					deshabilitaBoton('modifica', 'submit');
				}
							
				
			});
		}
	});
		
	function validaTipoInvercion(){
		var tipoInvercion = $('#tipoInvercionID').val();
		setTimeout("$('#cajaLista').hide();", 200);
					
		if(tipoInvercion != '' && !isNaN(tipoInvercion) && esTab){
			
			if(tipoInvercion != 0){
							
				var tipoInversionBean = {
		                'tipoInvercionID':tipoInvercion,
		                'monedaId':0
		        };
		        				
				tipoInversionesServicio.consultaPrincipal(catTipoListaTasasInversion.secundaria, tipoInversionBean, function(tipoInver){
					if(tipoInver!=null){
						$('#tipoInvercionID').val(tipoInver.tipoInvercionID);
						$('#descripcion').val(tipoInver.descripcion);
						$('#descripcionCon').val(tipoInver.descripcion);
						$('#conceptoInversion').val("0.0");
						$('#gatInformativo').val("0.0");
						$('#moneda').html(tipoInver.descripcionMoneda);
						$('#estatusTipoInver').val(tipoInver.estatus);
						habilitaBoton('imprimir', 'submit');
						
					}else{
						mensajeSis("No Existe el Tipo de Inversión");
						$('#estatusTipoInver').val('');
						$('#tipoInvercionID').focus();
						$('#tipoInvercionID').select();
					}
				});
								
				tipoInversionesServicio.consultaPrincipal(catTipoListaTasasInversion.tercera, tipoInversionBean, function(tipoRein){
					if(tipoRein!=null){						
						var reinversion = '';
						var tipoRinversion = '';
						if(tipoRein.reinversion == 'S'){
							reinversion = 'Reinversión al vencimiento';
						}else{
							reinversion = 'Sin Reinversión';
						}
						switch(tipoRein.reinvertir){
							case ('C'): tipoRinversion = 'Solo Capital'; break;
							case ('CI'): tipoRinversion = 'Capital más Interés'; break;
							case ('I'): tipoRinversion = 'Indistinto'; break;
							case ('N'): tipoRinversion = 'Ninguna'; break;
						}						
						$('#reinversion').html(reinversion);
						$('#tipoReinversion').html(tipoRinversion);
					}
				});
				
			}
		}
	}
	
	$('#imprimir').click(function() {
		var tipoInversion = $('#tipoInvercionID').val();
		var descripcion = $('#descripcionCon').val();
		$('#enlace').attr('href','reporteCatalogoTasaInversiones.htm?tipoInvercionID='+tipoInversion+"&tipoInversionDescripcion="+descripcion);
	});

	function obtieneVariables(){
		var tasasInversionBean = {
				'tipoInvercionID' : $('#tipoInvercionID').val(),
				'diaInversionID' : $('#diaInversionID').val(),
				'montoInversionID' : $('#montoInversionID').val()
		};
		return tasasInversionBean;
	}
	
	

});

function validaDigitos(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46){
		if (key==8|| key == 46 || key == 0){
			return true;
		}
		else 
  		return false;
	}
}
function validaDigitosConNegat(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46){
		if (key==8|| key == 46 || key == 0 || key == 45){
			if(e.target.value.toUpperCase().indexOf('-')>=0 && e.key.toUpperCase() === '-') 
			  {
			      e.preventDefault();
			    }
			return true;
		}
		else 
  		return false;
	}
}
