var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/	
	esTab = false;

	var catTipoTransaccion = {
	  		'agrega':'1',
	  		'modifica':'2'
	};	

	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/	    
	inicializaPantalla();	
	funcionCargaComboClasificacion();
	$("#tipoActivoID").focus();

    /******* VALIDACIONES DE LA FORMA *******/	
	$.validator.setDefaults({submitHandler: function(event) {		
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoActivoID','funcionExito', 'funcionError');
	}});
	
	$('#formaGenerica').validate({
		rules: {		
			tipoActivoID: {
				required: true
			},	
			descripcion: {
				required: true,
				maxlength: 300
			},		
			descripcionCorta: {
				required: true,
				maxlength: 15
			},	
			depreciacionAnual: {
				required: function() {return $('#clasificaActivoID').val() == 1;},
				numeroPositivo : true,
				min: function() {if($('#clasificaActivoID').val() == 1){return 1;}else{return 0;}},
				max: 100
			},
			clasificaActivoID: {
				required: true
			},
			tiempoAmortiMeses: {
				required: true,
				numeroPositivo : true,
				min: 1,
				max: 12
			},
			estatus: {
				required: true
			}
			
		},		
		messages: {	
			tipoActivoID: {
				required: 'Especifique Número'
			},	
			descripcion: {
				required: 'Especifique Descripción',
				maxlength: 'Máximo 300 Caracteres'
			},		
			descripcionCorta: {
				required: 'Especifique Descripción Corta',
				maxlength: 'Máximo 15 Caracteres'
			},	
			depreciacionAnual: {
				required: 'Especifique % Depreciación Anual' ,
				numeroPositivo : "Sólo números",
				min: 'Valor Mínimo de  1',
				max: 'Valor Máximo de 100'
			},
			clasificaActivoID: {
				required: 'Especifique Clasificación'
			},
			tiempoAmortiMeses: {
				required: 'Especifique Tiempo Amortizar en Meses',
				numeroPositivo : "Sólo números",
				min: 'Valor Mínimo de 1',
				max: 'Valor Máximo de 12'
			},
			estatus: {
				required: 'Especifique Estatus'
			}
			
		}
	});
	
	/******* MANEJO DE EVENTOS *******/	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccion.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccion.modifica);
	});	
	
	$('#tipoActivoID').bind('keyup', function(e){
		lista('tipoActivoID', '2', '1', 'descripcion', $('#tipoActivoID').val(),'listaTiposActivos.htm');
	});
	
	$('#tipoActivoID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);	
		if(esTab){
			consultaTipoActivo(this.id);
		}
	});
	
	$('#clasificaActivoID').change(function(){
		$('#tiempoAmortiMeses').val("");
		if($('#clasificaActivoID').val() == 1){
			$('#tiempoAmortiMeses').val("12");
			deshabilitaControl('tiempoAmortiMeses');
		}else{			
			habilitaControl('tiempoAmortiMeses');			
		}
	});
	
	$('#depreciacionAnual').blur(function(){		
		if(esTab){
			if($('#clasificaActivoID').val() != '' && $('#clasificaActivoID').asNumber() > 1 ){
				if($('#depreciacionAnual').asNumber() > 0 ){
					mensajeSis('Para este Tipo de Activo, se calculará el monto de depreciación contable anual y se depreciara N meses, utilizando el % de depreciación Anual.');
				}
			}
		}
	});
					
	/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/	 
	//FUNCIÓN CONSULTA LOS DATOS DEL TIPO DE ACTIVO
	function consultaTipoActivo(idControl) {
		var jqNumero = eval("'#" + idControl + "'");
		var tipoActivoID = $(jqNumero).val();
		setTimeout("$('#cajaLista').hide();", 200);
		inicializaPantalla();
		var numCon=1;
		var BeanCon = {
				'tipoActivoID':tipoActivoID 
			};	
		
		if(tipoActivoID != '' && tipoActivoID == 0){
			habilitaBoton('agrega','submit');
			deshabilitaBoton('modifica','submit');	
			$('#estatus').val('A');
			deshabilitaControl("estatus");
		}else if(tipoActivoID != '' && !isNaN(tipoActivoID) && tipoActivoID > 0){
			tiposActivosServicio.consulta(numCon,BeanCon,function(tipoActivoBean) { 
				if(tipoActivoBean!=null){
					$('#descripcion').val(tipoActivoBean.descripcion);
					$('#descripcionCorta').val(tipoActivoBean.descripcionCorta);
					$('#depreciacionAnual').val(tipoActivoBean.depreciacionAnual);
					$('#clasificaActivoID').val(tipoActivoBean.clasificaActivoID);					
					if(tipoActivoBean.clasificaActivoID == 1){
						deshabilitaControl('tiempoAmortiMeses');
					}else{			
						habilitaControl('tiempoAmortiMeses');			
					}
					$('#tiempoAmortiMeses').val(tipoActivoBean.tiempoAmortiMeses);
					$('#estatus').val(tipoActivoBean.estatus);
					
					deshabilitaBoton('agrega','submit');
					habilitaBoton('modifica','submit');	
					habilitaControl("estatus");
				}else{
					$(jqNumero).val('');				
					$(jqNumero).focus();
					mensajeSis('No Existe el Tipo de Activo');
				}
			});
		}else{
			if(isNaN(tipoActivoID)){
				$(jqNumero).val('');				
				$(jqNumero).focus();
				mensajeSis('No Existe el Tipo de Activo');	
			}
		}
	}

	
}); // FIN $(DOCUMENT).READY()

// FUNCION PARA MOSTRAR MENSAJES DE AYUDA
function descripcionCampo(idCampo){	
	var data;	
	switch(idCampo) {
	    case 'depreciacionAnual':
	    	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 			
			'<table id="tablaLista">'+
				'<tr align="left">'+
				'<td id="contenidoAyuda" align="justify">'+
					'<b> Indica el % que corresponde al tipo de activo capturado este puede ser un valor a dos decimales en un rango del 1 al 100. '+
					'</b>'+
				'</td>'+
				'</tr>'+
			'</table>'+
			'</fieldset>'; 
	        break;
	    case 'clasificaActivoID':
	    	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 			
			'<table id="tablaLista">'+
				'<tr align="left">'+
				'<td id="contenidoAyuda" align="justify">'+
					'<b> Indica el tipo de clasificación del activo, puede ser  "ACTIVO FIJO", "OTROS ACTIVOS" o "BIENES ADJUDICADOS"; este campo nos ayuda a determinar si se amortiza o deprecia el activo relacionado. '+
					'</b>'+
				'</td>'+
				'</tr>'+
			'</table>'+
			'</fieldset>'; 
	        break;
	    case 'tiempoAmortiMeses':
	    	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 			
			'<table id="tablaLista">'+
				'<tr align="left">'+
				'<td id="contenidoAyuda" align="justify">'+
					'<b> Indica el tiempo en meses que se consideraran para amortizar el activo esto solo tratándose de "Otros Activos", en el caso de "Activo Fijo" su valor será 12 ya que corresponde al periodo de un año. '+
					'</b>'+
				'</td>'+
				'</tr>'+
			'</table>'+
			'</fieldset>'; 
	        break;
	    case 'estatus':
	    	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 			
			'<table id="tablaLista">'+
				'<tr align="left">'+
				'<td id="contenidoAyuda" align="justify">'+
					'<b> Indica el estatus del tipo de activo, este puede ser ACTIVO o INACTIVO. '+
					'</b>'+
				'</td>'+
				'</tr>'+
			'</table>'+
			'</fieldset>'; 
	        break;
	    default:
	    	data = "";
	} 
	
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}

//FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	inicializaForma('formaGenerica','tipoActivoID');
	agregaFormatoControles('formaGenerica');	
	$('#clasificaActivoID').val('');
	$('#estatus').val('');

	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
	habilitaControl('tiempoAmortiMeses');
}

function funcionCargaComboClasificacion(){
	dwr.util.removeAllOptions('clasificaActivoID'); 
	tiposActivosServicio.listaCombo(1, function(beanLista){
		dwr.util.addOptions('clasificaActivoID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('clasificaActivoID', beanLista, 'clasificaActivoID', 'descripcion');
	});
}

//FUNCIÓN SOLO ENTEROS SIN PUNTOS NI CARACTERES ESPECIALES 
function validaSoloNumero(e,elemento){//Recibe al evento 
	var key = "";
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
	}else if(e.which){//Firefox , Opera Netscape
			key = e.which;
	}
	
	 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja 
	    return false;
	 return true;
}

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	inicializaPantalla();	
	funcionCargaComboClasificacion();
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
} 