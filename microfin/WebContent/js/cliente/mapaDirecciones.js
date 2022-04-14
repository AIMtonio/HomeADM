$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  

	var catTipoConsultaDirCliente = {
  		'principal'	:	1,
  		'foranea'	:	2,
		'comboBox' 	: 	3
	};	
	
	var catActualizaCoordenadas={
			'actualizar':4
	};
	
	
	
	
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('actualizar','submit');
	$('#clienteID').focus();
	
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
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','direccionID',
        			'funcionFalloDir','funcionExitoDir');
               
        }
	});
	
	 if($('#numero').val() != undefined){
			if(!isNaN($('#numero').val())){
				var numCliFlu = Number($('#numero').val());
				if(numCliFlu > 0){
					$('#clienteID').val($('#numero').val());
					consultaCliente('clienteID');
					consultarDireccionCliente($('#numero').val());
				}
			}
		}	   
		
	$('#direccionID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "clienteID";
		camposLista[1] = "direccionCompleta";
		
		
		parametrosLista[0] = $('#clienteID').val();
		parametrosLista[1] = $('#direccionID').val();
		
		lista('direccionID', '1', '1', camposLista, parametrosLista,'listaDireccion.htm','cajaLista2','elementoLista2');
	});		

	$('#direccionID').blur(function() { 	
		validaDirCliente(this.id); 	
	});

	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '1', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm','cajaLista2','elementoLista2');
	});
	
	$('#clienteID').blur(function() {
  		consultaCliente(this.id);
	});
	
	
	$('#verMapa').click(function() {
		if ($('#latitud').val()!=''&& $('#longitud').val()!=''){
			muestraMapa('mapDiv', $('#latitud').val(), $('#longitud').val());
			$('#mapDiv').show();
			habilitaBoton('actualizar','submit');
			console.log("click en mapa");
		}else{
			mensajeSis("Ingrese las Coordenadas.");
			deshabilitaBoton('actualizar','submit');
			habilitaControl('latitud');
			habilitaControl('longitud');
			$('#latitud').focus();
			$('#mapDiv').hide();
		}
		
	});	
	
	$('#actualizar').click(function() {
		$('#tipoTransaccion').val(catActualizaCoordenadas.actualizar);
	});
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required'
		},

		messages: {
			clienteID: 'Especifique Cliente'
		}		
	});
	//------------ Validaciones de Controles -------------------------------------
		
	
	function consultarDireccionCliente(numCliente){
		var direccionesCliente ={
					'clienteID' : 	numCliente  		
		};
		direccionesClienteServicio.consulta(3,direccionesCliente,function(direccion) {
			if(direccion!=null){
				$('#direccionID').val(direccion.direccionID);
				validaDirCliente('direccionID');							 
			}else{
				mensajeSis('El Cliente no Tiene Registrada una Dirección Oficial.');
				$('#direccionID').focus()
			}
		});				
	}
	
	
		function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista2').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
						if(cliente!=null){		
							$('#clienteID').val(cliente.numero);					
							$('#nombreCliente').val(cliente.nombreCompleto);
							$('#tipoDireccionID').val('');
							$('#direccionID').val('');
							$('#direccionCompleta').val('');
							$('#latitud').val('');
							$('#longitud').val('');
							$('#mapDiv').html("");
																	
						}else{
							mensajeSis("No Existe el Cliente.");
							$('#clienteID').val('');
							$('#tipoDireccionID').val('');
							$('#direccionID').val('');
							$('#nombreCliente').val('');
							$('#direccionCompleta').val('');
							$('#latitud').val('');
							$('#longitud').val('');
							$('#mapDiv').html("");
							$('#clienteID').focus();
							$('#clienteID').select();	
							deshabilitaBoton('actualizar','submit');
						}    	 						
				});
			}
		if(numCliente != '' && isNaN(numCliente) && esTab){
			mensajeSis("No Existe el Cliente.");
			$('#clienteID').val('');
			$('#tipoDireccionID').val('');
			$('#direccionID').val('');
			$('#nombreCliente').val('');
			$('#direccionCompleta').val('');
			$('#latitud').val('');
			$('#longitud').val('');
			$('#mapDiv').html("");
			$('#clienteID').focus();
			$('#clienteID').select();
		  }
		}	
		
		
		function validaDirCliente(control) {
		var numDireccion = $('#direccionID').val();
		setTimeout("$('#cajaLista2').hide();", 200);
		
		if(numDireccion != '' && !isNaN(numDireccion) && esTab){						
				var DirCliente = {
				    'clienteID' :  $('#clienteID').val(),
				    'direccionID' : numDireccion
				};
			direccionesClienteServicio.consulta(1,DirCliente,function(direccion) {
						if(direccion!=null){
							dwr.util.setValues(direccion);
							$('#tipoDireccionID').val(direccion.tipoDireccionID);
							consultaTipoDir('tipoDireccionID');
							
							if($('#latitud').val() >0 ||$('#longitud').val() >0){
								habilitaBoton('actualizar','submit');
								$('#mapDiv').show();
								muestraMapa('mapDiv', $('#latitud').val(), $('#longitud').val());
							}else{
								habilitaControl('latitud');
								habilitaControl('longitud');															
								$('#mapDiv').hide();
								deshabilitaBoton('actualizar','submit');
							}
																		
						}else{							
								mensajeSis("No Existe la Dirección del Cliente.");
								deshabilitaBoton('modifica', 'submit');
								deshabilitaBoton('agrega', 'submit');
								deshabilitaBoton('elimina', 'submit');
	   							$('#tipoDireccionID').val('');
	   							$('#direccionID').val('');
	   							$('#direccionCompleta').val('');
	   							$('#latitud').val('');
	   							$('#longitud').val('');
	   							$('#mapDiv').html("");
	   							$('#direccionID').focus();
	   							$('#direccionID').select();
	   							deshabilitaBoton('actualizar','submit');												
							}
				});
						
				}
					if(numDireccion != '' && isNaN(numDireccion) && esTab){
							mensajeSis("No Existe la Dirección del Cliente.");
							$('#tipoDireccionID').val('');
							$('#direccionID').val('');
							$('#direccionCompleta').val('');
							$('#latitud').val('');
							$('#longitud').val('');
							$('#mapDiv').html("");
							$('#direccionID').focus();
							$('#direccionID').select();
			
						}			
			}
		
function consultaTipoDir(idControl) {
		var jqTipoDir = eval("'#" + idControl + "'");
		var numDirec  = $(jqTipoDir).val();	
		var tipConP   = 1;	
		setTimeout("$('#cajaLista2').hide();", 200);		
		if(numDirec != '' && !isNaN(numDirec) && esTab){
			tiposDireccionServicio.consulta(tipConP,numDirec,function(direccion) {
						if(direccion!=null){							
							$('#tipoDireccionID').val(direccion.descripcion);
																	
						}else{
							mensajeSis("No Existe el Tipo de Dirección.");
						}    	 						
				});
			}
		if(numDirec != '' && isNaN(numDirec) && esTab){
			mensajeSis("No Existe el Tipo de Dirección.");
			$('#tipoDireccionID').val('');
			$('#direccionID').val('');
			$('#direccionCompleta').val('');
			$('#latitud').val('');
			$('#longitud').val('');
			$('#direccionID').focus();
			$('#direccionID').select();
			
		}
		}
		



	
		
}); 
	

//Funcion que Muestra el Mapa, segun la API de Google Maps
//Parametros: div, es la division en la forma donde se mostrara el mapa
//latitud: coordenada de latitud a 6 decimales
//longitud: coordenada de longitud a 6 decimales
function muestraMapa(div, latitud, longitud){

	var mapDiv = document.getElementById(div);
	
	var latlng = new google.maps.LatLng(latitud, longitud);
	
	var options = {
		center: latlng,
		zoom: 17,
		mapTypeId: google.maps.MapTypeId.ROADMAP,
		mapTypeControl: true,
		mapTypeControlOptions: {
			mapTypeIds: [
				google.maps.MapTypeId.ROADMAP,
				google.maps.MapTypeId.SATELLITE
			],
			position: google.maps.ControlPosition.TOP_RIGHT,
			style: google.maps.MapTypeControlStyle.DROPDOWN_MENU

		},
		disableDefaultUI: true,
		navigationControl: true,
		navigationControlOptions: {
		style: google.maps.NavigationControlStyle.ZOOM_PAN
		},
		streetViewControl: true,
		draggableCursor: 'move',
		draggingCursor: 'move',
	};
	var map = new google.maps.Map(mapDiv, options);
	
	var marker = new google.maps.Marker({
		position: new google.maps.LatLng(latitud,longitud), 
		map: map,
		draggable: true //que el marcador se pueda arrastrar
	});
	
	//Añado un listener para cuando el markador se termine de arrastrar
	//actualize el formulario con las nuevas coordenadas
	google.maps.event.addListener(marker, 'dragend', function(){
		actualizarPosicion(marker.getPosition());
	});
} 

//funcion que simplemente actualiza los campos del formulario
function actualizarPosicion(latLng){
	$('#latitud').val(latLng.lat());
	$('#longitud').val(latLng.lng());
}




function funcionExitoDir(){
	deshabilitaBoton('actualizar','submit');
}

function funcionFalloDir(){
	
	} 


