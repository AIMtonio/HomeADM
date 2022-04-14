

$(document).ready(function() {
	esTab = true;
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	agregaFormatoControles('formaGenerica');
	$.validator.setDefaults({
	    submitHandler: function(event) { 
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','catalogoServID','FuncionExitosaATM','FuncionErrorExitosaATM'); 
	      }
	 });
	
	$("#extTelefonoPart").blur(function(){
		if(this.value != ''){
			if($("#telefonoUEAU").val() == ''){
				this.value = '';
				alert("El Número de Teléfono está Vacío.");
				$("#telefonoUEAU").focus();
			}
		}				
	});
	consultaTiposCuenta();
	//cargaAutomatica();
	
	jQuery.validator.addMethod("validaCampoEnvioCorreo", function (value, element) {
		return $('input:radio[name="envioAutomatico"]:checked').val() == "N" || $(element).val() != '';
	}, "Especifique valor");
	
	jQuery.validator.addMethod("validaRequiereAut", function (value, element) {
		return $('input:radio[name="envioAutomatico"]:checked').val() == "N" || $(':checked[name="requiereAut"]').length > 0;
	}, "Especifique valor");
	
	$('#formaGenerica').validate({			
		rules: {				
			rutaReporte: {
				required: true							
			},				
			rutaExpPDF:{
				required: true		
			},
			montoMin:{
				required:true,
				number:true
			},
			ciudadUEAUID: {
				required: true							
			},				
			ciudadUEAU:{
				required: true						
			},						
			horarioUEAU:{
				required:true				
			},
			direccionUEAU: {
				required: true							
			},				
			correoUEAU:{
				required: true,
				email:	true
			},
			rutaCBB:{
				required:true				
			},
			rutaCFDI:{
				required:true,			
			},
			rutaLogo:{
				required:true
			},
			extTelefonoPart: {
				number: true
			},
			extTelefono: {
				number: true
			},
			envioAutomatico: {
				required:true
			},
			correoRemitente: {
				validaCampoEnvioCorreo: true,
				email: true
			},
			servidorSMTP: {
				validaCampoEnvioCorreo: true,
			},
			usuarioRemitente: {
				validaCampoEnvioCorreo: true,
			},
			contraseniaRemitente: {
				validaCampoEnvioCorreo: true,
			},
			puertoSMTP: {
				validaCampoEnvioCorreo: true,
				digits: true,
				range: [0, 9999]
			},
			asunto: {
				validaCampoEnvioCorreo: true,
			},
			requiereAut: {
				validaRequiereAut: true,
			},
			tipoAut: {
				validaCampoEnvioCorreo: true,
			},
			cuerpoTexto: {
				validaCampoEnvioCorreo: true,
			}
		},		
		messages: {
			rutaReporte: {
				required: 'Especifique ruta del reporte'					
			},
			rutaExpPDF:{
				required:'Especifique ruta del PDF'				
			},
			montoMin:{
				required:'Especifique monto mínimo'				
			},		
			ciudadUEAUID: {
				required:'Especifique No de ciudad',							
			},				
			ciudadUEAU:{
				required:'Especifique Nombre de ciudad',		
			},			
			horarioUEAU:{
				required:'Especifique horario',				
			},
			direccionUEAU: {
				required:'Especifique dirección',							
			},				
			correoUEAU:{
				required:'Especifique correo',
				email:'Dirección Inválida',
			},
			rutaCBB:{
				required:'Especifique Ruta CBB',				
			},
			rutaCFDI:{
				required:'Especifique Ruta CFDI',				
			},
			rutaLogo:{
				required:'Especifique Ruta de Logo'
			},
			extTelefonoPart:{
				number: 'Sólo Números(Campo opcional)'
			},
			extTelefono: {
				number: 'Sólo Números(Campo opcional)'
			},
			envioAutomatico: {
				required: 'Especifique envio automático',
			},
			correoRemitente: {
				email: 'Dirección inválida'
			},
			puertoSMTP: {
				digits: 'Solo números enteros',
				range: 'Especifique valor entre 0 y 9999'
			}
		}		
	});
	//$('#tipoActualizacion').val(Enum_Con_EdoCtaParams.consultaPrincipal);	
	var Enum_Tran_EdoCtaParamsTar={			  
			  'modificar':1			  
	};
	var Enum_Con_EdoCtaParamsTar={
		'consultaPrincipal':1
	};


	$('#ciudadUEAUID').bind('keyup',function(e) {		
		lista('ciudadUEAUID', '2', '1', 'nombre',$('#ciudadUEAUID').val(),'listaEstados.htm');
	});

	$('#ciudadUEAUID').blur(function() {	
		if(esTab){
			consultaEstado(this.id);
		}else{
			if(isNaN($('#ciudadUEAUID').number())){
				$('#ciudadUEAUID').val('');
				$('#ciudadUEAU').val('');
			}
			
		}

		
	});
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(Enum_Tran_EdoCtaParamsTar.modificar);
	});
	
	$('#telefonoUEAU').blur(function(){
		if($('#telefonoUEAU').val()==''){
			$('#extTelefonoPart').val('');
		}
	});
	
	$("#extTelefono").blur(function(){
		if(this.value != ''){
			if($("#otrasCiuUEAU").val() == ''){
				this.value = '';
				alert("El Número de Teléfono está Vacío.");
				$("#otrasCiuUEAU").focus();
			}
		}				
	});
	$('#otrasCiuUEAU').blur(function(){
		if($('#otrasCiuUEAU').val()==''){
			$('#extTelefono').val('');
		}
	});
	
	$("#otrasCiuUEAU").setMask('phone-us');
	$('#telefonoUEAU').setMask('phone-us');
	
	function consultaEstado(idControl) {		
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado)) {						
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {				
								if (estado != null) {									
									if (estado.estadoID == 0) {
										alert("No Existe el Estado");
										$('#ciudadUEAUID').focus();
										$('#ciudadUEAUID').val('');
										$('#ciudadUEAU').val('');										
									}
									$('#ciudadUEAU').val(estado.nombre);
								}else {
									alert("No Existe el Estado");
									$('#ciudadUEAUID').focus();
									$('#ciudadUEAUID').val('');
									$('#ciudadUEAU').val('');									
								}
			});
		}else{
			$(jqEstado).val('');
			$('#ciudadUEAU').val('');
		}
	}

	
	function consultaTiposCuenta(){
		var tipoCon=2;
		dwr.util.removeAllOptions('tipoCuentaID');
		tiposCuentaServicio.listaCombo(tipoCon, function(cuentas){
			dwr.util.addOptions('tipoCuentaID', cuentas, 'tipoCuentaID', 'descripcion');
			cargaAutomatica();
		});
	}
	
	$('#formaGenerica textarea').keypress(function(event) {
		if (event.which == 13) {
			event.preventDefault();
			var posicion = this.selectionStart;
			var tamanioCadena = this.length;
			var inicioCadena = this.value.substring(0, posicion);
			var finCadena = this.value.substring(posicion, tamanioCadena);
			this.value = inicioCadena + "\n" + finCadena;
			$(this).asignaPosicion(posicion + 1);
		}
	});

	$('input:radio[name="envioAutomatico"]').click(function() {
		if($('input:radio[name="envioAutomatico"]:checked').val() == "S") {
			$("#correoServidor").show();
			$("#usuarioClave").show();
			$("#puertoAsunto").show();
			$("#cuerpo").show();
			$("#labelAut").show();
			$("#tipoAut").show();
		} else {
			$("#correoServidor").hide();
			$("#usuarioClave").hide();
			$("#puertoAsunto").hide();
			$("#cuerpo").hide();
			$("#labelAut").hide();
			$("#tipoAut").hide();
		}
	});
});				///////////////FIN DEL DOCUMETO JAVASCRIPT
$.fn.asignaPosicion = function(pos) {
	this.each(function(index, elem) {
	if (elem.setSelectionRange) {
			elem.setSelectionRange(pos, pos);
		} else if (elem.createTextRange) {
			var range = elem.createTextRange();
			range.collapse(true);
			range.moveEnd('character', pos);
			range.moveStart('character', pos);
			range.select();
		}
	});
	return this;
};
function FuncionExitosaATM(){
	agregaFormatoControles('formaGenerica');
	cargaAutomatica();
}

function FuncionErrorExitosaATM(){
	agregaFormatoControles('formaGenerica');
	cargaAutomatica();
}
function cargaAutomatica(){	
	edoCtaParamsTarServicio.consulta(2,function (EdoCta){
			if(EdoCta!=null){						
					dwr.util.setValues(EdoCta);
					//consultaComboCuentas(EdoCta.tipoCuentaID);						
					$('#montoMin').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});	
					$('#otrasCiuUEAU').setMask('phone-us');
					$('#telefonoUEAU').setMask('phone-us');
					muestraOcultaCamposEnvio();
			}else{								
			}
	}); 		
}

function consultaComboCuentas(cuentas) {
var cuenta= cuentas.split(',');
var tamanio = cuenta.length;
for (var i=0;i<tamanio;i++) {  
	var cta = cuenta[i];
	var jqCta = eval("'#tipoCuentaID option[value="+cta+"]'");  
	$(jqCta).attr("selected","selected");   
} 
}

function muestraOcultaCamposEnvio() {
	if($('input:radio[name="envioAutomatico"]:checked').val() == "S") {
		$("#correoServidor").show();
		$("#usuarioClave").show();
		$("#puertoAsunto").show();
		$("#cuerpo").show();
		$("#labelAut").show();
		$("#tipoAut").show();
	} else {
		$("#correoServidor").hide();
		$("#usuarioClave").hide();
		$("#puertoAsunto").hide();
		$("#cuerpo").hide();
		$("#labelAut").hide();
		$("#tipoAut").hide();
	}
	$('#aut').attr('checked', true)
}
