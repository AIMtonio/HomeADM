$(document).ready(function() {
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFotoCliente = {
	  		'enviar':1,
	};

	$('#clienteID').focus();
	var cliente='';
	var recurso='';

	expedienteBean = {
			'clienteID' : 0,
			'tiempo' : 0,
			'fechaExpediente' : '1900-01-01',
	};
	listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	var esCliente 			='CTE';
	var esUsuario			='USS';
	//camara
	webcam.set_quality(100);
	webcam.set_shutter_sound( false ); // play shutter click sound
	webcam.set_swf_url("js/soporte/webcam.swf");
	webcam.set_hook("onComplete", "webcamComplete");
	webcam.set_hook("onError", "webcamError");
	webcam.set_hook("onLoad", "alCargarCamara");
	
	
	
	deshabilitaBoton('tomarFoto', 'submit');
	deshabilitaBoton('cancelaToma', 'submit');
	deshabilitaBoton('grabar', 'submit');	
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
	
	  	}
	});	
	var parametrosBean = consultaParametrosSession();
	var rutaArchivos = parametrosBean.rutaArchivos;
	$('#recurso').val(rutaArchivos);



	if($('#flujoCliNumCli').val() != undefined){
		if(!isNaN($('#flujoCliNumCli').val())){
			var numCliFlu = Number($('#flujoCliNumCli').val());
			$('#clienteID').val($('#flujoCliNumCli').val());
			consultaCliente('clienteID'); 

		}
	}	



	
	$('#grabar').click(function() {
		cliente=$('#clienteID').val();
		recurso=$('#recurso').val();
		webcam.set_api_url("SubeFotoCliente.htm?clienteID="+cliente+"&recurso="+recurso+'&tipoTransaccion='+
				catTipoTransaccionFotoCliente.enviar+'&tipoDocumento='+$('#tipoDocumento').val()+
				'&observacion='+$('#observacion').val());
	
		webcam.upload();
		webcam.reset();
		habilitaBoton('tomarFoto', 'submit');
		deshabilitaBoton('cancelaToma', 'submit');
		deshabilitaBoton('grabar', 'submit');							
	});
	
	
	$('#tomarFoto').click(function() {
		webcam.freeze();
		deshabilitaBoton('tomarFoto', 'submit');
		habilitaBoton('cancelaToma', 'submit');
		habilitaBoton('grabar', 'submit');		
		$('#cancelaToma').focus();
					
	});

	$('#cancelaToma').click(function() {
		webcam.reset();
		deshabilitaBoton('cancelaToma', 'submit');
		deshabilitaBoton('grabar', 'submit');
		habilitaBoton('tomarFoto', 'submit');
		$('#tomarFoto').focus();
	});
	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '19', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {setTimeout("$('#cajaLista').hide();", 200);
		var cliente = $('#clienteID').asNumber();
		if(cliente>0){
			listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
			if(listaPersBloqBean.estaBloqueado!='S'){
				expedienteBean = consultaExpedienteCliente($('#clienteID').val());
				if(expedienteBean.tiempo<=1){
			  		consultaCliente('clienteID'); 
				} else {
					mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
					limpiaForm($('#formaGenerica'));
					$('#clienteID').focus();
					$('#clienteID').val('');
				}
			} else {
				mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				limpiaForm($('#formaGenerica'));
				$('#clienteID').focus();
				$('#clienteID').val('');
			}
		}
	});
	
	//------------------------validaciones-----------

	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true
			},
			tipoDocumento: {
				required: true
			},
			observacion: {
				required: true
			},
			
		},
		messages: {
			clienteID: {
				required: 'Especificar Cliente'
			},
			tipoDocumento: {
				required: 'Especificar Tipo de Documento'
			},
			observacion: {
				required: 'Especificar Observación'
			},
				 
		}			
	});
	//--------------------------funciones---------------------------
	
	
	function consultaCliente(control) {
		var nacional='N';
		var extranjero='E';
		
		var masculino='M';
		var femenino='F';
		
		var moral='M';
		var fisicaActividaEmpresarial='A';
		var fisica='F';
		
		var numCliente = $('#clienteID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
			
				clienteServicio.consulta(1,numCliente,function(cliente) {
					if (cliente != null) {
						$('#telefonoCasa').val(cliente.telefonoCasa);				
						if (cliente.fechaNacimiento == '1900-01-01'){
							$('#fechaNacimiento').val('');
						}else{
							$('#fechaNacimiento').val(cliente.fechaNacimiento);
						}
						$('#nombreCliente').val(cliente.nombreCompleto);	
						if (cliente.nacion==nacional){
							$('#nacion').val('NACIONAL');
						}
						if (cliente.nacion==extranjero){
							$('#nacion').val('EXTRANJERO');
						}
						if(cliente.sexo==masculino ){
							$('#sexo').val('MASCULINO');
						}
						if(cliente.sexo==femenino ){
							$('#sexo').val('FEMENINO');
						}
						if(cliente.tipoPersona==moral ){
							$('#tipoPersona').val('MORAL');
						}
						if(cliente.tipoPersona==fisicaActividaEmpresarial){
							$('#tipoPersona').val('FISICA CON ACTIVIDAD EMPRESARIAL');
						}
						if(cliente.tipoPersona==fisica){
							$('#tipoPersona').val('FISICA');
						}
						consultaFotoCliente();//consultamos si el cliente ya tiene una foto 
					
						habilitaBoton('tomarFoto','submit');
						 if (cliente.estatus=='I'){
								mensajeSis("El Cliente se encuentra Inactivo");
								$('#clienteID').val('');
								$('#nombreCliente').val('');
								$('#tipoPersona').val('');
								$('#sexo').val('');
								$('#fechaNacimiento').val('');
								$('#telefonoCasa').val('');
								$('#clienteID').focus();
								deshabilitaBoton('tomarFoto','submit');
						 }
					} else {
						limpiaForm($('#formaGenerica'));
						mensajeSis("No Existe el Cliente");
						deshabilitaBoton('modifica','submit');
						deshabilitaBoton('agrega','submit');
						$('#clienteID').focus();
						$('#clienteID').select();
						deshabilitaBoton('tomarFoto','submit');
					}
				});
			
		}
	}
	
	// función para consultar si el cliente ya tiene capturada la foto
	function consultaFotoCliente(){
		var numCliente=$('#clienteID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente )){
			var clienteArchivosBeanCon = { 
				'clienteID':$('#clienteID').val(),
				'prospectoID':$('#prospectoID').val(),
				'tipoDocumento'	  :$('#tipoDocumento').val(),									
				};   			   	
			clienteArchivosServicio.consulta(13,clienteArchivosBeanCon,function(cliente) {
			
			});
		}
	}
	
	
	
});


function alCargarCamara() {

//		habilitaBoton('tomarFoto', 'submit');
	
	
}
	
function webcamComplete(response) {
	mensajeSis("Información Actualizada");	
	/*if($('#observacion').val()==''){
		mensajeSis("Especifique una observación");
		habilitaBoton('grabar', 'submit');
		event.preventDefault();
	}*/
}

function webcamError(error) {
	mensajeSis("Error al Actualizar Información ");
}