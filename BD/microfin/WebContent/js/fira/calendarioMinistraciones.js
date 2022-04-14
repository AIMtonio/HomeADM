esTab = true;       
//Definicion de Constantes y Enums
var catTipoConsultaCalendario = { 
	'principal':1,
	'foranea':2
};

var catTipoTranCalendario = {
	'agrega':1,
	'modifica':2
};

var Enum_PermiteCalIrregular ={
	'SI' : 'S',
	'NO' : 'N'	
};
$(document).ready(function() {
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	consultaPlazo();
	agregaOpcionesSelectFrecuencias();
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	
	$('#productoCreditoID').focus();

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
			if(!validaCalendarioIrregularFrecuencia()){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','productoCreditoID','exito','error');
			} else {
				mensajeSis('Seleccionar Frecuencia : LIBRE.');
				$("#frecuencias").focus();
			}
		}
	});					
	
	$('select').css('background-color','#FFFFFF');
	$('#grabar').click(function() {	
		$('#tipoTransaccion').val(catTipoTranCalendario.agrega);		
	});

	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTranCalendario.modifica);		
	});
	
	$('#productoCreditoID').bind('keyup',function(e){
		lista('productoCreditoID', '1', '10', 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');
	});
	
	$('#productoCreditoID').blur(function() {	 
		consultaProducCredito(this.id);
	});
	
	$('#frecuencias').blur(function() {
		var frecuencia =$('#frecuencias').val();
	});
		
	$('input[name="permiteCalIrregular"]').change(function (event){
		var tipoCalendario = $('input[name=permiteCalIrregular]:checked').val();
		if(tipoCalendario===Enum_PermiteCalIrregular.SI){
			agregaLibreSelectFrecuencias();
		} else if(tipoCalendario===Enum_PermiteCalIrregular.NO){
			eliminaLibreSelectFrecuencias();
		}
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			productoCreditoID : 'required',
			tomaFechaInhabil : 'required',
			permiteCalIrregular : 'required',
			diasCancelacion : 'required',
			diasMaxMinistraPosterior : 'required',
			frecuencias : 'required',
			plazos : 'required',
			tipoCancelacion : 'required'
		},
		
		messages: {
			productoCreditoID : 'Especifíque el Producto de Crédito.',
			tomaFechaInhabil : 'Especifíque Fecha Inhabil a Tomar.',
			permiteCalIrregular : 'Especifíque Permite Calendario Irregular.',
			diasCancelacion : 'Especifíque los Días de Cancelación.',
			diasMaxMinistraPosterior : 'Especifíque los Días Máximos de Ministración.',
			frecuencias : 'Especifíque las Frecuencias',
			plazos : 'Especifíque los Plazos.',
			tipoCancelacion : 'Especifíque el Tipo de Cancelación.'
		}
	});
	
	//------------ Validaciones de Controles -------------------------------------
	function validaCalendarioProducto(idControl) {
		var jqproducto  = eval("'#" + idControl + "'");
		var producto = $(jqproducto).val();	
		quitaFormatoControles('formaGenerica');
		var calendarioBeanCon = {
			'productoCreditoID' :producto
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(producto != '' && !isNaN(producto) && esTab){			 
			calendarioMinistracionServicio.consulta(catTipoConsultaCalendario.principal, calendarioBeanCon,{ async: false, callback:function(calendario) {
				if(calendario!=null){
					dwr.util.setValues(calendario);
					$('#productoCreditoID').val(calendario.productoCreditoID);
					$('input[name="permiteCalIrregular"]').change();
					consultaComboPlazos(calendario.plazos);
					consultaComboFrecuencias(calendario.frecuencias,'N');
					deshabilitaBoton('grabar', 'submit');	
					habilitaBoton('modificar', 'submit');
				} else {
					limpiaFormaCompleta('formaGenerica', true, [ 'productoCreditoID', 'descripProducto' ]);
					deshabilitaBoton('modificar', 'submit');	 
					habilitaBoton('grabar', 'submit');	 
				}
			  }
			});										
		}
	}
	 
	function consultaPlazo(){
		var tipoCon=3;
		dwr.util.removeAllOptions('plazos');
		plazosCredServicio.listaCombo(tipoCon, function(plazos){
			dwr.util.addOptions('plazos', plazos, 'plazoID', 'descripcion');
		});
	}
	
	function consultaProducCredito(idControl) { 
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
			productosCreditoServicio.consulta(catTipoConsultaCalendario.principal,ProdCredBeanCon,{ async: false, callback:function(prodCred) {
				if(prodCred!=null){
					$('#descripProducto').val(prodCred.descripcion);
					if(prodCred.esAgropecuario=='S'){
						if(prodCred.esGrupal=='S'){
							mensajeSis('El Producto de Crédito es Grupal.');
							$('#productoCreditoID').select();
							exito();
						} else {
							validaCalendarioProducto('productoCreditoID');
						}
					} else {
						mensajeSis('El Producto de Crédito No es Agropecuario.');
						$('#productoCreditoID').select();
						exito();
					}
				} else {							
					mensajeSis("No Existe el Producto de Crédito.");
					$('#productoCreditoID').focus();
					$('#productoCreditoID').select();
					exito();
				}
			}});
		}				 					
	}
	
	function consultaComboFrecuencias(frecuencia,varEsGrupal) {
		var frec= frecuencia.split(',');
		var tamanio = frec.length;
						
		for (var i=0;i< tamanio;i++) {
			var fre = frec[i];
			if(varEsGrupal=="S"){
				if(frec[i]!="L"){
					var jqFrecuencia = eval("'#frecuencias option[value="+fre+"]'");  
					$(jqFrecuencia).attr("selected","selected");
				}
			}else{  
				var jqFrecuencia = eval("'#frecuencias option[value="+fre+"]'");  
				$(jqFrecuencia).attr("selected","selected");
			}			  
		}
	}
	
	function consultaComboPlazos(plazos) {
		var plazo= plazos.split(',');
		var tamanio = plazo.length;
		for (var i=0;i<tamanio;i++) {  
			var plaz = plazo[i];
			var jqPlazo = eval("'#plazos option[value="+plaz+"]'");  
			$(jqPlazo).attr("selected","selected");   
		} 
	}
	
}); // fin function principal
 
// funcion para agregar al select de frecuencias la opcion de libres
function agregaLibreSelectFrecuencias(){
	eliminaLibreSelectFrecuencias();
	$("#frecuencias").append('<option value="L">LIBRE</option>');
}
//funcion para quitar en select de frecuencias la opcion de libres
function eliminaLibreSelectFrecuencias(){
	 $("#frecuencias").find("option[value='L']").remove(); 
}	

//funcion para agregar al select de Frecuencias las opciones diferentes de libres
function agregaOpcionesSelectFrecuencias(){
	var lista_frecuencia = 1;
	var producCreditoID=$('#productoCreditoID').asNumber();
	var bean={
			'producCreditoID': producCreditoID
	};
	dwr.util.removeAllOptions('frecuencias');

	catFrecuenciasServicio.lista(lista_frecuencia,bean,{ async: false, callback:function(frecuenciaCreditoBean) {
		if(frecuenciaCreditoBean!=null && frecuenciaCreditoBean.length>0){
			dwr.util.addOptions('frecuencias', frecuenciaCreditoBean, 'frecuenciaID', 'descInfinitivo');
		} else {
			mensajeSis("El Producto no tiene las Frecuencias Parametrizadas.");
			deshabilitaBoton('grabar', 'submit');
		}
	}});
}

function validaCalendarioIrregularFrecuencia(){
	var alertMandar = true;
	if($('input[name=permiteCalIrregular]:checked').val()=="S"){
		$("#frecuencias option:selected").each(function() {
			if($(this).text()=="LIBRE"){
				alertMandar = false;
			}			
		});
	} else {
		alertMandar = false;
	}
	return alertMandar; 
}

function exito(){
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('grabar', 'submit');
	limpiaFormaCompleta('formaGenerica', true, [ 'productoCreditoID' ]);
}

function error(){

}