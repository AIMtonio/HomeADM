$(document).ready(function(){
	
	var parametroBean = consultaParametrosSession();   
	esTab = true;

	var catTipoConCampanias = { 
  		'principal'	: 1,
  		'foranea'	: 2
	};				
	var catTipoTranCampanias = { 
  		'agrega'			: 1,
  		'modifica'			: 2,
  		'altaYlista'		: 3,
  		'elimina'			: 4,
  		'modificacionLista' : 5,
  		'eliminarLista' 	: 6
	};		
		//-----------------------MÃ©todos y manejo de eventos-----------------------
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('eliminar', 'submit');
	$('#campaniaID').focus();
	
	agregaFormatoControles('formaGenerica');
	$('#clasificacion').val('');
	$('#categoria').val('');

	 $('#plantillaID').hide(500);
	 $('#plantilla').hide(500);
	
   	$.validator.setDefaults({
   		submitHandler: function(event) { 
   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','campaniaID','exitoCampania', 'falloCampania');    			
         }
    });	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#agregar').click(function(){
		$('#tipoTransaccion').val(catTipoTranCampanias.altaYlista);		
		guardarCodigos();
	});
	
	$('#modificar').click(function(){
		$('#tipoTransaccion').val(catTipoTranCampanias.modificacionLista);
		guardarCodigos();
	});
	
	$('#eliminar').click(function(){
		$('#tipoTransaccion').val(catTipoTranCampanias.eliminarLista);
		guardarCodigos();
	});

	$('#campaniaID').blur(function(){
		validaCampania(this.id);		
	});	
	
	$('#campaniaID').bind('keyup',function(e) { 
		lista('campaniaID', '1', '1', 'nombre', $('#campaniaID').val(),'campaniasLista.htm');
	});
	
	$('#tipo').blur(function(){
		consultaTipoCampania(this.id);
	});
	
	$('#fechaLimiteRes').change(function() {
		 $('#msgRecepcion').focus();
	});
	
	$('#tipo').bind('keyup',function(e) { 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombre"; 
		camposLista[1] = "clasificacion"; 
		camposLista[2] = "categoria"; 
	 	parametrosLista[0] = $('#tipo').val();
	 	parametrosLista[1] = $('#clasificacion').val();
		parametrosLista[2] = $('#categoria').val();
		lista('tipo', '1', '1', camposLista, parametrosLista,'TipoCampaniasLista.htm');
	});
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			campaniaID: {
				required: true,
				numeroPositivo: true
			},
			nombre: {
				required: true
			},
			clasificacion: {
				required:  true,
			},
			categoria: {
				required: true
			},
			msgRecepcion: {
				required:  function() {return $('#clasificacion').val() == 'E';},						  				 		  
			},
			tipo: {
				required: true
			},
			fechaLimiteRes: {
				date:true
			},
			plantillaID: {
				required:  function() { if(($('#clasificacion').val() == 'S' &&  $('#categoria').val() == 'A') || ($('#clasificacion').val() == 'E' &&  $('#categoria').val() == 'E')){
					return true;
				} else {
					return false;
				}			  				 		  
				}
			},
		},
		messages: {
			campaniaID: {
				required: 'Ingrese la Campania',
				numeroPositivo: 'Sólo positivos'
			},
			nombre: {
				required: 'Especificar Nombre'
			},
			clasificacion: {
				required: 'Especificar Clasificacion'
			},
			msgRecepcion: {
				required: 'Ingrese el mensaje'
			},
			categoria: {
				required: 'Especificar Categoria'
			},
			tipo: {
				required: 'Especificar Tipo'
			},
			fechaLimiteRes: {
				date: 'Fecha invalida'
			},
			plantillaID: {
				required:  'Especificar la plantilla',						  				 		   
			},
		}		
	});
//-------------Validaciones de controles---------------------	
	function validaCampania(idControl){
		var interactiva='I';
		var jqCampania  = eval("'#" + idControl + "'");
		var numCamp = $(jqCampania).val();	

		setTimeout("$('#cajaLista').hide();", 200);
		if(numCamp != '' && !isNaN(numCamp) && esTab){
			if (numCamp == '0') {
				limpiaForm($('#formaGenerica'));				
				deshabilitaBoton('agregar', 'submit');	
				deshabilitaBoton('modificar', 'submit');	
				deshabilitaBoton('eliminar', 'submit');		
			}else{
				$('#gridCodigosResp').html("");
				var campaniaBeanCon = { 'campaniaID' :numCamp  };
				campaniasServicio.consulta(catTipoConCampanias.principal,campaniaBeanCon,function(campanias) {
					if(campanias!=null){
						
						dwr.util.setValues(campanias);
						consultaTipoCampania('tipo');	
						if (campanias.clasificacion == interactiva ){
							consultaCodigos();
							
						}else{
							$('#gridCodigosResp').html("");
						}																	
						deshabilitaBoton('agregar', 'submit');
						habilitaBoton('modificar', 'submit');
						habilitaBoton('eliminar', 'submit');
					}else{
						inicializaForma('formaGenerica','campaniaID');
						habilitaBoton('agregar', 'submit');
						deshabilitaBoton('modificar', 'submit');	
						deshabilitaBoton('eliminar', 'submit');	
					}
				});
			}
		}
	}
		
	
	  consultaPlantilla();		
		
	
	function consultaPlantilla(){
		var tipoConsulta = 1;				
		var plantillaBean = {
			'nombre' :	'%%'
		};
		dwr.util.removeAllOptions('plantillaID'); 
		dwr.util.addOptions('plantillaID', {0:'SELECCIONAR'}); 
		smsPlantillaServicio.lista(tipoConsulta, plantillaBean, function(plantilla){
			dwr.util.addOptions('plantillaID', plantilla, 'plantillaID', 'nombre');
		});
		
	}
		

	function consultaCodigos(){	
		var params = {};
		params['tipoLista'] = 2;
		params['campaniaID'] = $('#campaniaID').val();
		
		$.post("codigosRespuestaGridVista.htm", params, function(data){
			if(data.length >0) {		
				$('#gridCodigosResp').html(data);
				$('#gridCodigosResp').show();
				agregaFormatoControles('gridCodigosResp');
			}else{				
				$('#gridCodigosResp').html("");
				$('#gridCodigosResp').show();
			}
		});
	}
	
 	function guardarCodigos(){		
 		var mandar = verificarvacios();

 		if(mandar!=1){   		  		
			var numCodigo = $('input[name=consecutivoID]').length;
			
			$('#codigosRespuesta').val("");
			for(var i = 1; i <= numCodigo; i++){
				if(i == 1){
					$('#codigosRespuesta').val($('#codigosRespuesta').val() +
					document.getElementById("codigoRespID"+i+"").value + ']' +
					document.getElementById("descripcion"+i+"").value);
				}else{
					$('#codigosRespuesta').val($('#codigosRespuesta').val() + '[' +
					document.getElementById("codigoRespID"+i+"").value + ']' +
					document.getElementById("descripcion"+i+"").value);			
				}	
			}
		}
		else{
			mensajeSis("Faltan Datos");
			event.preventDefault();
		}
	}	

	function verificarvacios(){	
		quitaFormatoControles('gridCodigosResp');
		var numCodig = $('input[name=consecutivoID]').length;
		
		$('#codigosRespuesta').val("");
		for(var i = 1; i <= numCodig; i++){	
			var idcr = document.getElementById("codigoRespID"+i+"").value;
 			if (idcr ==""){
 				document.getElementById("codigoRespID"+i+"").focus();				
				$(idcr).addClass("error");	
 				return 1; 
 			}
			var idcde = document.getElementById("descripcion"+i+"").value;
 			if (idcde ==""){
 				document.getElementById("descripcion"+i+"").focus();
				$(idcde).addClass("error");
 				return 1; 
 			}			
		}
	}


	function consultaTipoCampania(idControl){
		var interactiva='I';
		var entrada='E';
		var evento='E';
		var salida='S';
		var automatica='A';
		var jqTipoCam  = eval("'#" + idControl + "'");
		var numTipoCam = $(jqTipoCam).val();	
		
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCam != '' && !isNaN(numTipoCam)){			
			var tipoCampBeanCon = { 
			'tipoCampaniaID' :numTipoCam
			};

			tipoCampaniasServicio.consulta(catTipoConCampanias.principal,tipoCampBeanCon,function(tipoCampania) {
						if(tipoCampania!=null){
							 $('#nomTipo').val(tipoCampania.nombre);
							 $('#clasificacion').val(tipoCampania.clasificacion);
							 $('#categoria').val(tipoCampania.categoria);
							 if (tipoCampania.clasificacion == interactiva ){
								 consultaCodigos();
							 }else{
								$('#gridCodigosResp').html("");
								$('#gridCodigosResp').hide();
							 }
							 if(tipoCampania.clasificacion==entrada){
								 $('#msgRecepcion').show(500);
								 $('#msg').show(500);
							 }else{
								 $('#msgRecepcion').hide(500);
								 $('#msg').hide(500);
							 }
							 if((tipoCampania.clasificacion== salida && tipoCampania.categoria== automatica) || (tipoCampania.clasificacion== entrada && tipoCampania.categoria== evento)){
								 $('#plantillaID').show(500);
								 $('#plantilla').show(500);
							 }else{
								 $('#plantillaID').hide(500);
								 $('#plantilla').hide(500);
							 }							 
						}else{
							mensajeSis("El tipo de Campaña no existe");							
							$('#tipoCampaniaID').val('');
							$('#nomTipo').val('');
							$('#tipoCampaniaID').focus();
						}
			});			
		}		
	}
	
	
	
});

// funciones que se ejecutan despues de una transaccion
function exitoCampania(){	
	deshabilitarCodigos();
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('agregaCodigo', 'submit');
	inicializaForma('formaGenerica','campaniaID');
	limpiaForm($('#gridCodigosResp'));			
	inicializaForma('gridCodigosResp');	
	$('#clasificacion').val('');
	$('#categoria').val('');
	$('#plantillaID').val('');
	$('#plantillaID').hide(500);
	$('#plantilla').hide(500);
}

function falloCampania(){
	
}

function deshabilitarCodigos(){	
	var numCodig = $('input[name=consecutivoID]').length;
	
	var jqCodigo = 'codigoRespID';
	var jqDescrip = 'descripcion';
	
	for(var i = 1; i <= numCodig; i++){
		jqCodigo = 'codigoRespID'+i;
		jqDescrip = 'descripcion'+i;
		
		 $('#'+jqCodigo).attr('disabled',true);
		 $('#'+jqDescrip).attr('disabled',true);
	}
}


function ayudaCR(){	
	var data;		       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Opciones:</legend>'+
			'<table id="tablaLista">'+
				'<tr align="left">'+
					'<td id="encabezadoLista"></td><td id="contenidoAyuda">Para agregar una nueva campaña'+ 
				' especificar un código de campaña que no exista<b></b></td>'+
				'</tr>'+
				
			'</table>'+
			'<br>'+
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