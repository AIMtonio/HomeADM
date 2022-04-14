var txt = '';
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
	$('#campaniaID').focus();

	//Definición de constantes y Enums
	
	var catTipoConSms = {
		'principal'	: 1,
		'foranea'	: 2,
		'numInst'   : 3,
		'prinSalCamp':4
	};
	
	txt = '';
			
	var catTipoTranSms = { 
  		'agrega'	: 1
	};

//-----------------------Métodovalidas y manejo de eventos-----------------------
	agregaFormatoControles('formaGenerica');
	cargaListaPlantilla();

   	$.validator.setDefaults({
            submitHandler: function(event) { 
            	$('#remitente').removeAttr('disabled');
            	grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','campaniaID','limpiacampos','funcionvacia');      			
                $('#remitente').attr('disabled','disabled');
            }
    });

	$('#campaniaID').bind('keyup',function(e) { 		
		lista('campaniaID', '2', '2', 'nombre', $('#campaniaID').val(),'campaniasLista.htm');
	});

	$('#receptor').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		
		parametrosLista[0] = $('#receptor').val();
		lista('receptor', '3', '2', camposLista,parametrosLista, 'listaCliente.htm');	       
	});
	$('#receptor').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
	});
	$('#enviar').click(function(){
		$('#tipoTransaccion').val(catTipoTranSms.agrega);		
		//event.preventDefault();
	
	});
	
	$('#campaniaID').blur(function(){
		if(esTab){
		validaCampania(this.id);

		}
	});		

	$('#listaPlantilla').change(function (){
		$('#msjenviar').val('');
		var numPlantilla = this.value;
		var tipoConsulta = 1;
		var plantillaBean = {
			'plantillaID' :	numPlantilla
		};
	
		smsPlantillaServicio.consulta(tipoConsulta, plantillaBean, function(plantilla){
			if(plantilla != null){
				txt = plantilla.descripcion;
				consultaCodigos();
			}
		});
		
	});
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {			
			campaniaID: {
				required: true,
				numeroPositivo: true
			},
			receptor: {
				required: true,
				numeroPositivo: true,
				maxlength : 10,
				minlength : 10,
			},
			msjenviar: {
				required: true,
				maxlength : 160
			}
		},		
		messages: {
			campaniaID: {
				required: 'Especificar Numero de Campaña',
				numeroPositivo: 'Sólo números positivos',
			},
			receptor: {
				required: 'Especificar Destinatario',
				numeroPositivo: 'Sólo números positivos',
				maxlength : 'Maximo 10 números',
				minlength : 'Minimo 10 números',
			},
			msjenviar: {
				required: 'Especificar Texto a Enviar',
				maxlength : 'Maximo de caracteres 160'					
			}
		}
	});
	
//-------------Validaciones de controles---------------------	
		
	function consultaDestinatario() {
		var destinatarioBeanCon = { 
				'numeroInstitu1' : 1
			};
		parametrosSMSServicio.consulta(catTipoConSms.numInst, destinatarioBeanCon, function(destinatario) {
			
			if (destinatario != null) {
				$('#remitente').val(destinatario.numeroInstitu1);
			}
		});
	}
	
	function validaCampania(idControl){
		var jqCampania  = eval("'#" + idControl + "'");
		var numCamp = $(jqCampania).val();	
		if(numCamp != '' && !isNaN(numCamp) ){
		var campaniaBeanCon = { 
			'campaniaID' :numCamp
		};
		campaniasServicio.consulta(catTipoConSms.prinSalCamp,campaniaBeanCon,{ async: false, callback:function(campanias) {
				if(campanias!=null){
					$('#nombreCampania').val(campanias.nombre);
					habilitaBoton('enviar', 'submit');
					consultaCodigos();
					
				}else{
					mensajeSis('La campaña no existe');
					inicializaForma('formaGenerica','campaniaID');
					limpiaForm($('#formaGenerica'));					
					$('#campaniaID').focus();
					$('#campaniaID').val('');
					$('#nombreCampania').val('');
					deshabilitaBoton('enviar', 'submit');										
				}
			}});			
		}else{
			mensajeSis('La campaña no existe');
			limpiaForm($('#formaGenerica'));					
			$('#campaniaID').focus();
			$('#campaniaID').val('');
			$('#nombreCampania').val('');
			deshabilitaBoton('enviar', 'submit');

		}
	}	
	
	function consultaCodigos(){	
		var params = {};
		params['tipoLista'] = 2;
		params['campaniaID'] = $('#campaniaID').val();
		
		var jqCodigo = 'codigoRespID';
		var jqDescrip = 'descripcion';
		var codigos= "";
		var codigo= "";
		var descrip= "";
		$.post("codRespResumenActGridVista.htm", params, function(data){
				if(data.length >0) {		
						$('#gridCodigosResp').html(data);
						var numCodig = $('input[name=consecutivoID]').length;
					
						for(var i = 1; i <= numCodig; i++){	 
							jqCodigo  = 'codigoRespID'+i;
							jqDescrip = 'descripcion'+i;
		
								codigo = $('#'+jqCodigo).val();
								descrip = $('#'+jqDescrip).val();
								codigos = codigos+"#"+codigo+"  "+descrip+" \n" ;
						}
						$('#msjenviar').val(txt+" "+codigos);
						carateres();
						 $('#gridCodigosResp').val("");	
						 
				}else{				
						$('#gridCodigosResp').html("");
						$('#gridCodigosResp').show();
				}
		});
	}
	
	function cargaListaPlantilla(){
		var tipoConsulta = 1;				
		var plantillaBean = {
			'nombre' :	'%%'
		};
		dwr.util.removeAllOptions('listaPlantilla'); 
		dwr.util.addOptions('listaPlantilla', {0:'SELECCIONAR'}); 
		smsPlantillaServicio.lista(tipoConsulta, plantillaBean, function(plantilla){
			dwr.util.addOptions('listaPlantilla', plantilla, 'plantillaID', 'nombre');
		});
		
	}

	
	$(".contador").each(function(){
		var longitud = $("#msjenviar").val().length;
			$(this).parent().find('#longitud_textarea').html('<b>'+longitud+'</b> de 160 caracteres');
			$(this).keyup(function(){ 
				var nueva_longitud = $(this).val().length;
				$(this).parent().find('#longitud_textarea').html('<b>'+nueva_longitud+'</b> de 160 caracteres');
				if (nueva_longitud == "160") {
					$('#longitud_textarea').css('color', '#ff0000');
				}
				});
			});

	function  carateres() {
		var longitud = $("#msjenviar").val().length;
		$(".contador").parent().find('#longitud_textarea').html('<b>'+longitud+'</b> de 160 caracteres');
		$(".contador").change(function(){ 
			var nueva_longitud = $(this).val().length;
			$(this).parent().find('#longitud_textarea').html('<b>'+nueva_longitud+'</b> de 160 caracteres');
			if (nueva_longitud == "160") {
				$('#longitud_textarea').css('color', '#ff0000');
			}
			});
	}
	
});

function limpiacampos(){
	$('#listaPlantilla option')[0].selected = true;
	$('#campaniaID').val('');
	
	$('#codigoRespID1').val('');
	$('#remitente').val('1');
	$('#nombreCampania').val('');
	$('#receptor').val('');
	$('#msjenviar').val('');
	$('#longitud_textarea').text(0+' de 160 caracteres');
	txt = '';

}
function funcionvacia(){


}