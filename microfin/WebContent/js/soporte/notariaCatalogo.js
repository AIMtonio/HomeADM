$(document).ready(function() {
	
	$('#estadoID').focus();
	
	esTab = true;
		
	//Definicion de Constantes y Enums  
	var catTipoTransaccionNotaria = { 
  		'agrega':'1',
  		'modifica':'2',
  		'elimina':'3'	}; 

	//------------ Metodos y Manejo de Eventos -----------------------------------------

   deshabilitaBoton('modifica', 'submit');
   deshabilitaBoton('agrega', 'submit'); 
   deshabilitaBoton('elimina', 'submit'); 

	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
$.validator.setDefaults({
            submitHandler: function(event) { 
       			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','estadoID','exitoTransNotaria','');
        			

            }
    });
				
		     
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionNotaria.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionNotaria.modifica);
	});	 

	$('#elimina').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionNotaria.elimina);
	});	
	
	$('#notariaID').bind('keyup',function(e){ 
		//TODO Agregar Libreria de Constantes Tipo Enum
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "municipioID";
		camposLista[2] = "titular"; 
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#notariaID').val();
		
		if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0 ){
			if($('#municipioID').val()!='' && $('#municipioID').asNumber()>0){
				lista('notariaID', '1', '1', camposLista, parametrosLista, 'listaNotarias.htm');
			}else{
				if($('#notariaID').val().length >= 3){
					$('#municipioID').focus();
					$('#notariaID').val('');
					$('#titular').val('');
					mensajeSis('Especificar Municipio');
				}
			}
		}else{
			if($('#notariaID').val().length >= 3){
				$('#estadoID').focus();
				$('#notariaID').val('');
				$('#titular').val('');
				mensajeSis('Especificar Estado');
			}

		}
		

	});
		 
	$('#notariaID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if($('#notariaID').val() 	!= 	'' &&	$('#notariaID').val() > 0	&&	!isNaN($('#notariaID').val())){
			if($('#estadoID').val()!=''  ){
				if($('#municipioID').val() !=''){
					validaNotaria(this.id);
				}else{
					$('#titular').val('');
					$('#notariaID').val('');
					mensajeSis("Elija un Municipio  antes de buscar Notaria");
				}
			}else{
				$('#titular').val('');
				$('#notariaID').val('');
				mensajeSis("Elija un Estado  antes de buscar Notaria");
			}
		}else{
			$('#titular').val('');
			$('#notariaID').val('');
		}

	});	
   
	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});
			
	$('#estadoID').blur(function() {
  		consultaEstado(this.id);
	}); 
	
	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val(); 
		
		lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});
	
	$('#municipioID').blur(function() {
  		consultaMunicipio(this.id); 
	});

	$('#telefono').setMask('phone-us');
	
	$('#extTelefonoPart').blur(function() {
		if(this.value != ''){
			if($("#telefono").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telefono").focus();
			}
		}
	});
	$("#telefono").blur(function (){
		if(this.value ==''){
			$('#extTelefonoPart').val('');
		}
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			estadoID: { 
				required: true, 
				minlength: 1
			},
			municipioID: { 
				required: true, 
				minlength: 1
			},
			notariaID: { 
				required: true, 
				minlength: 1
			},
			
			titular: { 
				required: true, 
				minlength: 6
			},
			direccion: { 
				required: true, 
				minlength: 6
			},				
			correo: { 
				required:  false,
				email: 	true
			},
			telefono: {
				required:  true	
			},
			extTelefonoPart: {
				number: true,
			}
		},
		messages: { 
			
			estadoID: {
				required: 'Especificar Estado',
				minlength: 'Al menos 1 Caracter'
			},
			municipioID: {
				required: 'Especificar Municipio',
				minlength: 'Al menos 1 Caracter'
			},
			notariaID: {
				required: 'Especificar Notaria',
				minlength: 'Al menos 1 Caracter'
			},
			titular: {
				required: 'Especificar Titular',
				minlength: 'Al menos 6 Caracteres'
			},
			direccion: {
				required: 'Especificar Direccion',
				minlength: 'Al menos6 Caracteres'
			},			
		 	correo: {
				required: 	'Especifique un Correo',
				email: 		'Direccion Invalida'
			},
			telefono: {
				required: 	'Especifique Teléfono'
			},
			extTelefonoPart: {
				number: 'Sólo Números(Campo opcional)',
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	function validaNotaria(idcontrol) { 
		
		var numNotaria = $('#notariaID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
								 
				var notariaBeanCon = {
  				'estadoID':$('#estadoID').val(),
  				'municipioID':$('#municipioID').val(),
  				'notariaID':numNotaria
				};
			if(numNotaria=='0'){		
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('elimina', 'submit');
			}else{if(numNotaria != '' && !isNaN(numNotaria) && esTab){
				 
					notariaServicio.consulta(1 ,notariaBeanCon,function(notaria) {
							if(notaria!=null){	
								dwr.util.setValues(notaria);
								$('#telefono').setMask('phone-us');
								deshabilitaBoton('agrega', 'submit');
								habilitaBoton('modifica', 'submit');
								habilitaBoton('elimina', 'submit');								
							}else{ 
								inicializaForma('formaGenerica','notariaID');
								habilitaBoton('agrega', 'submit');
								deshabilitaBoton('modifica', 'submit');
								deshabilitaBoton('elimina', 'submit');			 														
							}
					});
			}
		}
		}
												
		
	
	
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	 
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && esTab){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
						if(estado!=null){							
							$('#nombreEstado').val(estado.nombre);
																	
						}else{ 
							mensajeSis("No Existe el Estado");
							$('#estadoID').focus();
							$('#estadoID').select();		
						}    	 						
				});
			}
		}	
	
		function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	 
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
						if(municipio!=null){							
							$('#nombreMunicipio').val(municipio.nombre);
																	
						}else{
							mensajeSis("No Existe el Municipio");
							$('#municipioID').focus();
							$('#municipioID').select();		 
						}    	 						
				});
			}
		}	 
	

});


function ayudaTelefono(){	
		var data;       
			data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
					'<div id="ContenedorAyuda">'+ 
					'<legend class="ui-widget ui-widget-header ui-corner-all">El No de telefono debe contener 10 digitos: </legend>'+
					'<table id="tablaLista">'+
					'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo: </b></td>'+ 
					'<td id="contenidoAyuda">9511771020</td>'+
					'</tr>'+
					'</table>'+
					'</div>'+ 
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

	function exitoTransNotaria(){
		inicializaForma('formaGenerica','notariaID');
		deshabilitaBoton('modifica', 'submit');
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('elimina', 'submit');
	}
