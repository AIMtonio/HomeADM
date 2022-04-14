var tipoCalculoInteres = 0;
var habilita = false;
var esAgropecuario = '';
$(document).ready(function() {
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
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   //deshabilitaBoton('agregar', 'submit');
 	deshabilitaBoton('modificar', 'submit');
	agregaFormatoControles('formaGenerica');
	inicializaCombos();
	consultaPlazo();
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	$('#tdSeparador').hide();
	$('#lblPrimerAmor').hide();
	$('#reqPrimerAmor').hide();
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			var validaCal = validaCalendarioIrregularTipoCapital();
			if(validaCal ==1){				
				var validaCal = validaCalendarioIrregularFrecuencia();
				if(validaCal ==1){
					$('#ajusFecUlAmoVen').val("N");
					habilitaDiaQuinc(true);
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','productoCreditoID','inicializaCombos');
				}else{
					mensajeSis("Seleccionar Frecuencia : LIBRE");
				}
			}else{
				mensajeSis("Seleccionar Tipo de Pago de Capital : LIBRES");
			}	
		}
	});					

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
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
		lista('productoCreditoID', '2', '15', 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');
	});
	
	$('#productoCreditoID').blur(function() {	 
		consultaProducCredito(this.id);
	});

	$('#frecuencias').change(function(e) {
		var frecuencia =$('#frecuencias').val();
		validaDiaPago(frecuencia);
		validaDiaPagoQuinc(frecuencia);
	});
	
	$('#diaPagoCapital').click(function() {
		var perIgual = $("#iguaCalenIntCap").val();
		if(perIgual == "S"){
			$('#diaPagoInteres').attr("checked","1") ;
		}
	});
	
	$('#diaPagoCapital2').click(function() {
		var perIgual = $("#iguaCalenIntCap").val();
		if(perIgual == "S"){
			$('#diaPagoInteres2').attr("checked","1");
		}
	});
	
	$('#diaPagoCapital3').click(function() {
		var perIgual = $("#iguaCalenIntCap").val();
		if(perIgual == "S"){
			$('#diaPagoInteres3').attr("checked","1") ;
		}
	});
	

	$('#permCalenIrreg1').click(function(){
		$('#permCalenIrreg1').attr('checked',true);
		$('#permCalenIrreg2').attr('checked',false);
		$('#permCalenIrreg').val("S");
		$('#permCalenIrreg1').focus();
		agregaLibreSelectTipoCapital();
		agregaLibreSelectFrecuencias();
		
		var tipoPagoCap = $('#tipoPagoCapital').val();
		
		// SI EXISTE SELECCIONADO TIPO DE PAGO DE CAPITAL LIBRES
		if(tipoPagoCap.indexOf('L') != -1){
			$('#tdSeparador').show();
			$('#lblPrimerAmor').show();
			$('#reqPrimerAmor').show();

			$('#diasReqPrimerAmor').rules("add", {
				required: function() {return tipoPagoCap.indexOf('L') != -1},
				min: 1,
			messages: {
				required: 'Especifique Días Requeridos Primer Amortización.',
				min: 'El Día Requerido Primer Amortización debe ser mayor a 0'
				}
			});
		}

		// SI NO EXISTE SELECCIONADO TIPO DE PAGO DE CAPITAL LIBRES
		if(tipoPagoCap.indexOf('L') == -1){
			$('#tdSeparador').hide();
			$('#lblPrimerAmor').hide();
			$('#reqPrimerAmor').hide();
			$('#diasReqPrimerAmor').val("");
			$('#diasReqPrimerAmor').rules("remove");
			$("label.error").hide();
			$(".error").removeClass("error");
		}
	});
	
	$('#permCalenIrreg2').click(function(){
		$('#permCalenIrreg1').attr('checked',false);
		$('#permCalenIrreg2').attr('checked',true);
		$('#permCalenIrreg').val("N");
		$('#permCalenIrreg2').focus();
		eliminaLibreSelectTipoCapital();
		eliminaLibreSelectFrecuencias();
		
		var tipoPagoCap = $('#tipoPagoCapital').val();
		
		// SI EXISTE SELECCIONADO TIPO DE PAGO DE CAPITAL LIBRES
		if(tipoPagoCap.indexOf('L') != -1){
			$('#tdSeparador').show();
			$('#lblPrimerAmor').show();
			$('#reqPrimerAmor').show();

			$('#diasReqPrimerAmor').rules("add", {
				required: function() {return tipoPagoCap.indexOf('L') != -1},
				min: 1,
			messages: {
				required: 'Especifique Días Requeridos Primer Amortización.',
				min: 'El Día Requerido Primer Amortización debe ser mayor a 0'
				}
			});
		}

		// SI NO EXISTE SELECCIONADO TIPO DE PAGO DE CAPITAL LIBRES
		if(tipoPagoCap.indexOf('L') == -1){
			$('#tdSeparador').hide();
			$('#lblPrimerAmor').hide();
			$('#reqPrimerAmor').hide();
			$('#diasReqPrimerAmor').val("");
			$('#diasReqPrimerAmor').rules("remove");
			$("label.error").hide();
			$(".error").removeClass("error");
		}
	}); 
	
	$('#tipoPagoCapital').click(function(){
		var tipoPagoCap = $('#tipoPagoCapital').val();

		// SI EXISTE SELECCIONADO TIPO DE PAGO DE CAPITAL LIBRES
		if(tipoPagoCap.indexOf('L') != -1){
			$('#tdSeparador').show();
			$('#lblPrimerAmor').show();
			$('#reqPrimerAmor').show();

			$('#diasReqPrimerAmor').rules("add", {
				required: function() {return tipoPagoCap.indexOf('L') != -1},
				min: 1,
			messages: {
				required: 'Especifique Días Requeridos Primer Amortización.',
				min: 'El Día Requerido Primer Amortización debe ser mayor a 0'
				}
			});
		}

		// SI NO EXISTE SELECCIONADO TIPO DE PAGO DE CAPITAL LIBRES
		if(tipoPagoCap.indexOf('L') == -1){
			$('#tdSeparador').hide();
			$('#lblPrimerAmor').hide();
			$('#reqPrimerAmor').hide();
			$('#diasReqPrimerAmor').val("");
			$('#diasReqPrimerAmor').rules("remove");
			$("label.error").hide();
			$(".error").removeClass("error");
		}

	});

	$('#productoCreditoID').focus();
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			productoCreditoID: 'required',
			tipoPagoCapital: 'required',
			frecuencias: 'required',
			plazoID: 'required'
		},
		
		messages: {
			productoCreditoID: 'Especifique Producto',
			tipoPagoCapital: 'Especifique Tipo',
			frecuencias:'Especifique Frecuencias',
			plazoID:'Especifique Plazos'
		}
		
		
		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	function validaCalendarioProducto(idControl,varEsGrupal) {
		$('#diaPagoCapital').attr("checked",false) ;
		$('#diaPagoCapital2').attr("checked",false) ;
		$('#diaPagoCapital3').attr("checked",false) ;
		$('#diaPagoCapital4').attr("checked",false) ;
		inicializaCombos();
		var jqproducto  = eval("'#" + idControl + "'");
		var producto = $(jqproducto).val();	
		quitaFormatoControles('formaGenerica');
		var calendarioBeanCon = {
			'productoCreditoID' :producto
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if( producto != '' && !isNaN(producto) && esTab){			 
			calendarioProdServicio.consulta(catTipoConsultaCalendario.principal, calendarioBeanCon,{ async: false, callback:function(calendario) {
				if(calendario!=null){
					dwr.util.setValues(calendario);
					if(varEsGrupal=="S" && esAgropecuario== 'N'){ 
						$('#lblIrregular').hide();
						$('#radioIrregular').hide();
						$('#permCalenIrreg1').attr("checked",false) ;
						$('#permCalenIrreg2').attr("checked",true) ;
						$('#permCalenIrreg').val("N");
						eliminaLibreSelectTipoCapital();
						eliminaLibreSelectFrecuencias();
						$('#tdSeparador').hide();
						$('#lblPrimerAmor').hide();
						$('#reqPrimerAmor').hide();
					}else{
						$('#radioIrregular').show();
						$('#lblIrregular').show(); 
						agregaLibreSelectTipoCapital();
						agregaLibreSelectFrecuencias();
						$('#tdSeparador').show();
						$('#lblPrimerAmor').show();
						$('#reqPrimerAmor').show();
						
						if(calendario.diasReqPrimerAmor != 0){
							$('#diasReqPrimerAmor').val(calendario.diasReqPrimerAmor);
						}else{
							$('#diasReqPrimerAmor').val("");
						}
					}
					$('#productoCreditoID').val(calendario.productoCreditoID);
					var plazos = calendario.plazoID;
					var tipoDispersion = calendario.tipoDispersion;
					consultaComboPlazos(plazos);
					consultaComboTipoDispersion(tipoDispersion);					
					if(calendario.fecInHabTomar=='S'){				
						$('#fecInHabTomar').attr("checked","1") ;
						$('#fecInHabTomar2').attr("checked",false) ;
					}   
					else{
						if(calendario.fecInHabTomar=='A')
							$('#fecInHabTomar2').attr("checked","1") ;
							$('#fecInHabTomar').attr("checked",false) ;
					}
					if(calendario.ajusFecExigVenc=='S'){							
						$('#ajusFecExigVenc').attr("checked","1") ;
						$('#ajusFecExigVenc2').attr("checked",false) ;
					} 
					else{
						if(calendario.ajusFecExigVenc=='N') 
							$('#ajusFecExigVenc').attr("checked",false) ;
						$('#ajusFecExigVenc2').attr("checked","1");
					}
					if(calendario.permCalenIrreg=='S'){							
						$('#permCalenIrreg1').attr("checked",true) ;
						$('#permCalenIrreg2').attr("checked",false) ;
						$('#permCalenIrreg').val("S");
						agregaLibreSelectFrecuencias();
						consultaComboTipoPagoCap(calendario.tipoPagoCapital);
						consultaComboFrecuencias(calendario.frecuencias,varEsGrupal);
					}else{ 
						if(calendario.permCalenIrreg=='N'){
							$('#permCalenIrreg1').attr("checked",false) ;
							$('#permCalenIrreg2').attr("checked",true) ;
							$('#permCalenIrreg').val("N");
							eliminaLibreSelectFrecuencias();
							consultaComboTipoPagoCap(calendario.tipoPagoCapital);
							consultaComboFrecuencias(calendario.frecuencias,varEsGrupal);
						}	 
					}
					
					if(calendario.iguaCalenIntCap=='S'){		
						$('#iguaCalenIntCap').attr("checked","1") ;
						$('#iguaCalenIntCap2').attr("checked",false) ;
					}  
					else{
						if(calendario.iguaCalenIntCap=='N') 
							$('#iguaCalenIntCap').attr("checked",false) ;
						$('#iguaCalenIntCap2').attr("checked","1") ;
					}
					
					if(calendario.diaPagoCapital != null){
						$('#capital').show();
					}else{
						$("#capital").hide();
					}
					
					if(calendario.diaPagoQuincenal != ''){
						$('#diaPagoQuincDiv').show();
					}else{
						$("#diaPagoQuincDiv").hide();
					}
					
					if(calendario.diaPagoCapital=='F'){				
						$('#diaPagoCapital').attr("checked","1") ;
						$('#diaPagoCapital2').attr("checked",false) ;
						$('#diaPagoCapital3').attr("checked",false) ;
						$('#diaPagoCapital4').attr("checked",false) ;
					}   
					if(calendario.diaPagoCapital=='D'){				
						$('#diaPagoCapital2').attr("checked","1") ;
						$('#diaPagoCapital').attr("checked",false) ;
						$('#diaPagoCapital3').attr("checked",false);
						$('#diaPagoCapital4').attr("checked",false) ;
					} 
					if(calendario.diaPagoCapital=='A'){				
						$('#diaPagoCapital3').attr("checked","1") ;
						$('#diaPagoCapital').attr("checked",false) ;
						$('#diaPagoCapital2').attr("checked",false);
						$('#diaPagoCapital4').attr("checked",false);
					}
					if(calendario.diaPagoCapital=='I'){				
						$('#diaPagoCapital4').attr("checked","1") ;
						$('#diaPagoCapital').attr("checked",false) ;
						$('#diaPagoCapital2').attr("checked",false) ;
						$('#diaPagoCapital3').attr("checked",false) ;
					}
					esTab=true;
					deshabilitaBoton('grabar', 'submit');	
					habilitaBoton('modificar', 'submit');
				}else{
					deshabilitaBoton('modificar', 'submit');	 
					habilitaBoton('grabar', 'submit');	 
				}
			  }
			});										
		}
	}
	 
	function consultaPlazo(){
		var tipoCon=3;
		dwr.util.removeAllOptions('plazoID');
		plazosCredServicio.listaCombo(tipoCon, function(plazos){
			dwr.util.addOptions('plazoID', plazos, 'plazoID', 'descripcion');
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
					esTab=true;		
					$('#descripProducto').val(prodCred.descripcion);
					validaCalendarioProducto('productoCreditoID', prodCred.esGrupal);
					tipoCalculoInteres = prodCred.tipoCalInteres;
					esAgropecuario = prodCred.esAgropecuario;
					/* Si el tipo de cálculo de interes es sobre saldos insolutos entonces se habilitan
					 * las opciones de Día Pago Quincenal. Si es sobre monto original, se 
					 * deshabilitan y se marca como default Quincena.*/
					habilita = (tipoCalculoInteres == 1 ? true : false);
					if(!habilita){
						$('#diaPagoQuincenalQ').attr("checked",true);
					}
					habilitaDiaQuinc(habilita);
					if (prodCred.estatus == 'I'){
						mensajeSis("El Producto "+ prodCred.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						$('#productoCreditoID').focus();
						deshabilitaBoton('grabar', 'submit');
						deshabilitaBoton('modificar', 'submit');
					}
				}else{
					mensajeSis("No Existe el Producto de Crédito");
					$('#productoCreditoID').focus();
					$('#productoCreditoID').select();	
					$('#descripProducto').val("");
					tipoCalculoInteres = 0;
				}
			  }
			});
		}				 					
	}
		
	function consultaComboTipoPagoCap(tipoPago) {
		var tp= tipoPago.split(',');
		var tamanio = tp.length;
	 	for (var i=0;i<tamanio;i++) {
			var tip = tp[i];
			var jqTipo = eval("'#tipoPagoCapital option[value="+tip+"]'");
			$(jqTipo).attr("selected","selected");
		}
	 	
	 	// SI EXISTE SELECCIONADO TIPO DE PAGO DE CAPITAL LIBRES
		if(tp.indexOf('L') != -1){
			$('#tdSeparador').show();
			$('#lblPrimerAmor').show();
			$('#reqPrimerAmor').show();

			$('#diasReqPrimerAmor').rules("add", {
				required: function() {return tp.indexOf('L') != -1},
				min: 1,
			messages: {
				required: 'Especifique Días Requeridos Primer Amortización.',
				min: 'El Día Requerido Primer Amortización debe ser mayor a 0'
				}
			});
		}

		// SI NO EXISTE SELECCIONADO TIPO DE PAGO DE CAPITAL LIBRES
		if(tp.indexOf('L') == -1){
			$('#tdSeparador').hide();
			$('#lblPrimerAmor').hide();
			$('#reqPrimerAmor').hide();
			$('#diasReqPrimerAmor').val("");
			$('#diasReqPrimerAmor').rules("remove");
			$("label.error").hide();
			$(".error").removeClass("error");
		}
	}
	
	function consultaComboTipoDispersion(tipoDispersion){
		if(tipoDispersion != null){
			var tipoDis= tipoDispersion.split(',');
			var tamanio = tipoDis.length;
			for (var i=0;i< tamanio;i++) {
				var tipoD= tipoDis[i];
				var jqTipoD = eval("'#tipoDispersion option[value="+tipoD+"]'");  
				$(jqTipoD).attr("selected","selected");
			}
		}
	}
	function consultaComboFrecuencias(frecuencia,varEsGrupal) {
		var frec= frecuencia.split(',');
		var tamanio = frec.length;
						
		for (var i=0;i< tamanio;i++) {
			var fre = frec[i];

					var jqFrecuencia = eval("'#frecuencias option[value="+fre+"]'");  
					$(jqFrecuencia).attr("selected","selected");
				  
		}
	}
	
	function consultaComboPlazos(plazos) {
		var plazo= plazos.split(',');
		var tamanio = plazo.length;
		for (var i=0;i<tamanio;i++) {  
			var plaz = plazo[i];
			var jqPlazo = eval("'#plazoID option[value="+plaz+"]'");  
			$(jqPlazo).attr("selected","selected");   
		} 
	}  

	function validaDiaPago(frecuencia){
		var frec		= eval("'" + frecuencia + "'");
		var muestraDiv	= false;
		var Mensual		='M';
		var Bimestral	='B';
		var Trimestral	='T';
		var Tetramestral ='R';
		var Semestral	='E';
		var valor= frec.split(",");
		for(var i=0; i< valor.length; i++){
			var fre = valor[i];
			if(fre == Mensual || fre == Bimestral || fre == Trimestral
				|| fre == Tetramestral || fre == Semestral ){
				muestraDiv = true;
			}
		}
		if(muestraDiv){
			validaDiaPagoInt();
			$("#capital").show();
		} else {
			validaDiaPagoInt();
			$("#capital").hide();
		}
	}
	
	function validaDiaPagoInt(){
		var tipoPago = $("#tipoPagoCapital").val();
		var tipoPag  = eval("'" + tipoPago + "'");
		var Iguales 	='I';	
		var valor= tipoPag.split(",");
		for(var i=0; i< valor.length; i++){
			var tipo = valor[i];
			if(tipo == Iguales){
				//se verifica que el control igualdad en calendario de interes y capital
				var perIgual = $("#iguaCalenIntCap").val();
				if(perIgual == "N"){
					$("#interes").show();
				}else{
					$("#interes").hide();
				}	
			}
		}
	}
}); // fin function principal

// funcion para agregar al select de tipo de capital la opcion de libres
function agregaLibreSelectTipoCapital(){
	eliminaLibreSelectTipoCapital();
	$("#tipoPagoCapital").append('<option value="L">LIBRES</option>');
}
//funcion para quitar en select de tipo de capital la opcion de libres
function eliminaLibreSelectTipoCapital(){

	 document.getElementById("tipoPagoCapital").remove(2);
}
 
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
	eliminaOpcionesSelectFrecuencias();
	$("#frecuencias").append('<option value="S">SEMANAL</option>');
	$("#frecuencias").append('<option value="D">DECENAL</option>');
	$("#frecuencias").append('<option value="C">CATORCENAL</option>');
	$("#frecuencias").append('<option value="Q">QUINCENAL</option>');
	$("#frecuencias").append('<option value="M">MENSUAL</option>');
	$("#frecuencias").append('<option value="B">BIMESTRAL</option>');
	$("#frecuencias").append('<option value="T">TRIMESTRAL</option>');                		
	$("#frecuencias").append('<option value="R">TETRAMESTRAL</option>');
	$("#frecuencias").append('<option value="E">SEMESTRAL</option>');
	$("#frecuencias").append('<option value="A">ANUAL</option>');
	$("#frecuencias").append('<option value="P">PERIODO</option>');
	$("#frecuencias").append('<option value="U">PAGO &Uacute;NICO</option>');
}

//funcion para quitar en select de frecuencias las opciones diferentes a libres 
function eliminaOpcionesSelectFrecuencias(){
	document.getElementById("frecuencias").innerHTML = "";
}
 

//funcion para agregar al select de tipo de capital las opciones diferentes de libres
function agregaOpcionesSelectTipoCapital(){
	eliminaOpcionesSelectTipoCapital();
	$("#tipoPagoCapital").append('<option value="C">CRECIENTES</option>');
	$("#tipoPagoCapital").append('<option value="I">IGUALES</option>');
	$("#tipoPagoCapital").append('<option value="L">LIBRES</option>');
}

//funcion para quitar en select de tipo de capital las opciones diferentes a libres 
function eliminaOpcionesSelectTipoCapital(){
	document.getElementById("tipoPagoCapital").innerHTML = "";
}

function validaCalendarioIrregularFrecuencia(){
	var alertMandar = 0;
	if($('#permCalenIrreg').val()=="S"){
		$("#frecuencias option:selected").each(function() {
			if($(this).text()=="LIBRE"){
				alertMandar = 1;
			}			
		});
	}else{
		alertMandar = 1;
	}
	return alertMandar; 
}
 
function validaCalendarioIrregularTipoCapital(){
	var alertMandar = 0;
	if($('#permCalenIrreg').val()=="S"){
		$("#tipoPagoCapital option:selected").each(function() {
			if($(this).text()=="LIBRES"){
				alertMandar = 1;
			}			
		});
	}else{
		alertMandar = 1;
	}
	return alertMandar; 
}
 

function inicializaCombos(){
	$("#tipoPagoCapital").each(function(){  
        $("#tipoPagoCapital option").removeAttr("selected");  
    });
    $("#frecuencias").each(function(){  
        $("#frecuencias option").removeAttr("selected");  
    });
	$("#plazoID").each(function(){  
        $("#plazoID option").removeAttr("selected");  
    });
	$("#tipoDispersion").each(function(){
        $("#tipoDispersion option").removeAttr("selected");  
    });
	validaDiaPagoQuinc('frecuencias');
	habilitaDiaQuinc(true);
	$('#diaPagoQuincenalI').attr("checked",false);
	$('#diaPagoQuincenalD').attr("checked",false);
	$('#diaPagoQuincenalQ').attr("checked",false);
	deshabilitaBoton('grabar','submit');
	deshabilitaBoton('modificar','submit');
}

function validaDiaPagoQuinc(frecuencia){
	var frec = eval("'" + frecuencia + "'");
	var muestraDiv = false;
	var Quincenal ='Q';
	var valor= frec.split(",");
	for(var i=0; i< valor.length; i++){
		var fre = valor[i];
		if(fre == Quincenal){
			muestraDiv = true;
		}
	}
	if(muestraDiv){
		$("#diaPagoQuincDiv").show();
	} else {
		$("#diaPagoQuincDiv").hide();
	}
}

function infoDiaQuinc(){
	var data;
	
	data = '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">&nbsp;&nbsp;D&iacute;a Quincena&nbsp;&nbsp;</legend>'+
			'<div id="ContenedorAyuda" style="text-align: justify; padding: 10px">'+ 
				'En la pantalla <b>Solicitud de Cr&eacute;dito > Registro > Alta de Solicitud de Cr&eacute;dito</b>, se permitir&aacute; elegir el d&iacute;a de la Primer Quincena.</br></br>Este valor debe encontrarse entre el 1 y el 13.'+
				'<br>'+
			'</div>'+ 
			'</fieldset>'; 
	
	$('#info').html(data); 

	$.blockUI({
		message : $('#info'),
		css : {
			top : ($(window).height() - 400) / 2 + 'px',
			left : ($(window).width() - 400) / 2 + 'px',
			width : '400px'
		}
	});  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}

//FUNCIÓN SOLO ENTEROS SIN PUNTOS NI CARACTERES ESPECIALES 
function validaSoloNumero(e,elemento){//Recibe al evento 
	var key;
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
	}else if(e.which){//Firefox , Opera Netscape
			key = e.which;
	}
	
	 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja 
	    return false;
	 return true;
}

function habilitaDiaQuinc(habilita){
	if(habilita){
		habilitaControl('diaPagoQuincenalD');
		habilitaControl('diaPagoQuincenalQ');
		habilitaControl('diaPagoQuincenalI');
	} else {
		deshabilitaControl('diaPagoQuincenalD');
		deshabilitaControl('diaPagoQuincenalQ');
		deshabilitaControl('diaPagoQuincenalI');
	}
}
