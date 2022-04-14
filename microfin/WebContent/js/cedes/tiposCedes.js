var tabButton = 50;
$(document).ready(function() {
	var paramSesion = consultaParametrosSession();
	esTab = true;

	// Definicion de Constantes y Enums
	var catTipoTransaccionInverciones = {
			'agrega' : 1 ,
			'modifica' :2
	};

	var catTipoListaMonedas = {
			'combo' : 3
	};

	var catTipoConsultaCedes = {
			'general' : 2,

	}; 
	
	var catTipoListaTipoCede = {
			'tipoCedesAct':3
		};	
	$('#reinvertir2').attr("checked",true);
	cargaComboReinvertir(2);
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	$('#diasPeriodo').hide();
	$('#diasPeriodo').val('');
	$('#lbldiasPeriodo').hide();
	$('#lblpagoIntCal').hide();
	
	
	consultaMoneda();	
	muestraOcultaSegunAnclaje();
	
	$('#tipoPagoInt').blur(function() {
		var tipoPagoInt =$('#tipoPagoInt').val();
		muestraCampoDias(tipoPagoInt);
		muestraCampoPagoIntCal(tipoPagoInt);
	});

		
	$('#fechaCreacion').val(paramSesion.fechaAplicacion);
	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 
						'true', 'tipoCedeID', 'funcionExito','funcionFallo');				
			}
	});
	
	$('#tipoCedeID').focus();

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#tipoCedeID').bind('keyup',function(e){
		
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "descripcion";
		 parametrosLista[0] = $('#tipoCedeID').val();
		
		lista('tipoCedeID', 2, catTipoListaTipoCede.tipoCedesAct, camposLista,parametrosLista, 'listaTiposCedes.htm');
	});	
	
	$('#agrega').click(function() {	
		$('#tipoTransaccion').val(catTipoTransaccionInverciones.agrega);
	});
	
	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionInverciones.modifica);
	});
	
	$('#maximoEdad').blur(function(){
		if(esTab){
			validaRango(this.id);	
		}
			
	});
	
	$('#minimoEdad').blur(function(){
		if(esTab){
		validaRango(this.id);
		}	
	});
	
	$('#anclajeNo').click(function(){
		muestraOcultaSegunAnclaje();
		$('#minimoAnclaje').val('');
	});
	
	$('#anclajeSi').click(function(){
		muestraOcultaSegunAnclaje();
		$('#minimoAnclaje').val('');
	});
	
			
	
	// valida en rango de edades
	function validaRango(idControl){
		var jqRango = eval("'#" + idControl + "'");			
		if( $('#minimoEdad').val() != '' && $('#maximoEdad').val() != '' &&
				!isNaN($('#minimoEdad').val()) && !isNaN($('#maximoEdad').val())){		
			if( $('#maximoEdad').asNumber() > 150){
				mensajeSis('La Edad no Puede ser Mayor a 150');
				$(jqRango).val('');
				$(jqRango).focus();				
			}else if($('#minimoEdad').asNumber() > $('#maximoEdad').asNumber() || $('#minimoEdad').asNumber() == $('#maximoEdad').asNumber()){
				mensajeSis('El Rango Final debe Ser Mayor que el Rango Inicial.');
				$(jqRango).val('');
				$(jqRango).focus();
			}else if($(jqRango).asNumber() < 0 || $(jqRango).asNumber() == 0){
				mensajeSis('Especifique un Número Mayor que Cero');
				$(jqRango).val('');
				$(jqRango).focus();
			}
		}else if($('#minimoEdad').val() != '' && !isNaN($('#minimoEdad').val()) ){
			if($(jqRango).asNumber() < 0 || $(jqRango).asNumber() == 0){
				mensajeSis('Especifique un Número Mayor que Cero');
				$(jqRango).val('');
				$(jqRango).focus();
			}
		}
		else if($('#maximoEdad').val() != '' && !isNaN($('#maximoEdad').val()) ){
			if($(jqRango).asNumber() < 0 || $(jqRango).asNumber() == 0){
				mensajeSis('Especifique un Número Mayor que Cero');
				$(jqRango).val('');
				$(jqRango).focus();
			}
		}
	}
	
	function consultaMoneda() {			
		dwr.util.removeAllOptions('monedaSelect');
		dwr.util.addOptions('monedaSelect', {'':'SELECCIONAR'}); 
		monedasServicio.listaCombo(catTipoListaMonedas.combo, function(monedas){
		dwr.util.addOptions('monedaSelect', monedas, 'monedaID', 'descripcion');
		});
	}
		
		
	$('#tipoCedeID').blur(function() {
		if(esTab){
		validaTipoCede(this);
		}
	});
	
	$('#fechaInscripcion').change(function() {
		var Yfecha= $('#fechaInscripcion').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaInscripcion').val(parametroBean.fechaSucursal);
			}
				if($('#fechaInscripcion').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Inscripcion  es Mayor a la Fecha del Sistema.");
					$('#fechaInscripcion').val(parametroBean.fechaSucursal);
				}				
			
		}else{
			$('#fechaInscripcion').val(parametroBean.fechaSucursal);
		}

	});

	/*==== Funcion valida fecha formato (yyyy-MM-dd) =====*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29}else{ numDias=28};
				break;
			default:
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}
	
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}

	
	$('#tipoReinversion').change(function(){
		if($('#tipoReinversion').val() == 'N'){
			$('#reinvertir1').attr("disabled",true);
			$('#reinvertir2').attr("checked",true);
			$('#reinvertir3').attr("disabled",true);
		}else{
			$('#reinvertir1').attr("checked",true);
			$('#reinvertir1').attr("disabled",false);
			$('#reinvertir2').attr("disabled",false);
		}
	});

	$('#reinvertir1').click(function(){
		cargaComboReinvertir(1);
	});

	$('#reinvertir2').click(function(){
		cargaComboReinvertir(2);
	});

	$('#reinvertir3').click(function(){
		cargaComboReinvertir(3);
	});
	
function cargaComboReinvertir(tipo){
	dwr.util.removeAllOptions('tipoReinversion');

	if (tipo == 1) {
		dwr.util.addOptions( "tipoReinversion", {'C':'SOLO CAPITAL', 'CI': 'CAPITAL MAS INTERES','I': 'INDISTINTO'});
		$('#tipoReinversion').val('C').selected;
		habilitaControl('tipoReinversion');
	}else if(tipo == 2){
		dwr.util.addOptions( "tipoReinversion", {'N':'NO REALIZA INVERSIÓN'});
		$('#tipoReinversion').val('N').selected;
		deshabilitaControl('tipoReinversion');
	}else {
		dwr.util.addOptions( "tipoReinversion", {'I': 'INDISTINTO'});
		$('#tipoReinversion').val('I').selected;
		deshabilitaControl('tipoReinversion');
	}
	
}


	function validaTipoCede(){
		var tipoCede = $('#tipoCedeID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(tipoCede != '' && !isNaN(tipoCede)){
			
			if(tipoCede == '0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','tipoCedeID');
				eliminaTablaActividades();
				inicializaCampos();	
				$('#fechaInscripcion').val("");
				$('#reinvertir2').attr("checked",true);
				muestraOcultaSegunAnclaje();
				$('#tasaF').attr('checked',true);
				$('#pagoIntCalIgual').attr('checked',true);
				$('#reinvertir2').attr('checked',true);
				$('#tipoReinversion').val('N').selected;
			}else{
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');				
				var tiposCedesBean = {
		                'tipoCedeID':tipoCede,
		                'monedaId':0
		        };
				dwr.util.removeAllOptions('tipoReinversion');
				
				tiposCedesServicio.consulta(catTipoConsultaCedes.general, tiposCedesBean,{ async: false, callback: function(tiposCedes){
					if(tiposCedes!=null){
						dwr.util.setValues(tiposCedes);
						// REINVERSION --------------------
						evaluaReinversion(tiposCedes.reinversion,tiposCedes.reinvertir);	

						muestraOcultaSegunAnclaje();						
						consultGenero(tiposCedes.genero);
						consultaEdoCivil(tiposCedes.estadoCivil);
						consultaComboTipoPagoInt(tiposCedes.tipoPagoInt);	
						muestraCampoPagoIntCal(tiposCedes.tipoPagoInt);
						if(tiposCedes.actividadBMX != ''){
							consultaActividadEconBD(tiposCedes.actividadBMX);
						}else{								
							eliminaTablaActividades();
						}
						
						if(tiposCedes.fechaInscripcion=='1900-01-01'){
							$('#fechaInscripcion').val("");
							
						}else{								
							$('#fechaInscripcion').val(tiposCedes.fechaInscripcion);
						}
						
						if(tiposCedes.diaInhabil == 'SD'){
							$('#sabaDomi').attr('checked',true);
						}
						else{
							$('#soloDomi').attr('checked',true);
						}
						
						if(tiposCedes.diaInhabil == null){
							$('#sabaDomi').attr('checked',true);
						}

						$('#minimoApertura').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});

						$('#minimoAnclaje').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
					    
						if(tiposCedes.pagoIntCal == 'I'){
							$('#pagoIntCalIgual').attr('checked',true);
						}
						else{
							$('#pagoIntCalDev').attr('checked',true);
						}
						if(tiposCedes.pagoIntCal == ''){
							$('#pagoIntCalIgual').attr('checked',true);
						}
						deshabilitaBoton('agrega', 'submit');
						if(tiposCedes.estatus == 'I'){
							mensajeSis("El Producto "+tiposCedes.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
							deshabilitaBoton('modifica', 'submit');
							$('#tipoCedeID').focus();
						}else{
							habilitaBoton('modifica', 'submit');
						}
						
					}else{
						mensajeSis("No Existe el Tipo de CEDE");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#tipoCedeID').val('');
						$('#tipoCedeID').focus();
						$('#tipoCedeID').select();
						inicializaCampos();					
						eliminaTablaActividades();
						inicializaForma('formaGenerica','tipoCedeID');
						$('#tasaF').attr('checked',true);
						$('#pagoIntCalIgual').attr('checked',true);
					}
					
				}
			});
				
			}
			
		}		
	}
	
	
	
	$('#formaGenerica').validate({
		rules: {
			tipoCedeID: 'required',
			descripcion: 'required',
			monedaSelect: 'required',
			tipoReinversion: 'required',
			minimoEdad:{
				required: true,
				maxlength:3,
				number: true
			},
			maximoEdad:{
				required: true,
				maxlength:3,
				number: true
			},
			minimoApertura:{
				number: true,
				maxlength:24
			},
			minimoAnclaje:{
				maxlength:24
			},
			genero:{
				required:true
			},
			estadoCivil:{
				required: true
			},
			minimoApertura:{
				required: true,
				number: true
			},
			tipoPagoInt: 'required',
			diasPeriodo: {
				required : function() {
					if(($('#tipoPagoInt').val() == 'P')
					||(($('#tipoPagoInt').val() == 'V,F,P'))
					||(($('#tipoPagoInt').val() == 'V,P'))
					||(($('#tipoPagoInt').val() == 'F,P'))){
						return true;
						}else {
							return false;
							}
					}
			},
			pagoIntCal: {
				required : function() {
					if(($('#tipoPagoInt').val() == 'P')
					||(($('#tipoPagoInt').val() == 'V,F,P'))
					||(($('#tipoPagoInt').val() == 'V,P'))
					||(($('#tipoPagoInt').val() == 'F,P'))
					||(($('#tipoPagoInt').val() == 'F,V'))
					||(($('#tipoPagoInt').val() == 'F'))){
						return true;
						}else {
							return false;
							}
					}
			},
				
		},
		
		
		messages: {
			tipoCedeID: 'Especifique Número.',
			descripcion: 'Especifique la Descripción.',
			monedaSelect : 'Especifique un Tipo de Moneda',
			tipoReinversion: 'Especifique un Tipo de Reinversion',
			minimoEdad:{
				required:'Especifique Rango de Edad.',
				number: 'Sólo Números.',
				maxlength:'Máximo 3 Números.'				
			},
			maximoEdad:{
				required:'Especifique Rango de Edad.',
				number:'Sólo Números.',
				maxlength:'Máximo 3 Números.'				
			},
			minimoApertura:{
				number:'Sólo Números',
				maxlength:'Máximo 24 Caracteres.'
			},
			minimoAnclaje:{
				maxlength:'Máximo 24 Caracteres.'
			},
			genero:{
				required:'Especifique Género.'
			},
			estadoCivil:{
				required: 'Especifique Estado Civil.'
			},
			minimoApertura:{
				required: 'Especifique Monto Mínimo de Apertura.',
				number: 'Sólo Números.'
			},
			tipoPagoInt: 'Especifique la Forma de Pago de Interés.',
			diasPeriodo: {
				required : 'Especifique el Número de Días de Periodo.'
			},
			pagoIntCal: 'Especifique el Tipo de Pago de Interés.'
			
		}
	});
		
	// funcion que selecciona los generos almacenados en la consulta
	function consultGenero(genero) {
			if(genero != '' && genero != null){
				var cadenaGenero= genero.split(',');
				var tamanio = cadenaGenero.length;
				for (var i=0;i<tamanio;i++) {  
					var valorGenero= cadenaGenero[i];
					var jqGenero = eval("'#genero option[value="+valorGenero+"]'");  
					$(jqGenero).attr("selected","selected");   
				} 
			}
	}
	
	// funcion que selecciona los estados Civiles almacenados en la consulta
	function consultaEdoCivil(estadoCivil) {
			if(estadoCivil != '' && estadoCivil != null){
				var cadenaEdoCivil= estadoCivil.split(',');
				var tamanio = cadenaEdoCivil.length;
				for (var i=0;i<tamanio;i++) {  
					var valorEdoCivil= cadenaEdoCivil[i];
					var jqEdoCivil = eval("'#estadoCivil option[value="+valorEdoCivil+"]'");  
					$(jqEdoCivil).attr("selected","selected");   
				} 
			}
	}
	
	//**************  anclaje ***************//
	function muestraOcultaSegunAnclaje(){
		if($('#anclajeNo').is(':checked')){
			$('#trMinimoAnclaje').hide();
		}
		else if($('#anclajeSi').is(':checked')){
			$('#trMinimoAnclaje').show();
		}
	}


	//------------ EVALUA INVERSION
	function evaluaReinversion(reinversion, reinvertir){
		dwr.util.removeAllOptions('tipoReinversion');

		if (reinversion == 'S') {
			dwr.util.addOptions( "tipoReinversion", {'C':'SOLO CAPITAL', 'CI': 'CAPITAL MAS INTERES','I': 'INDISTINTO'});
			habilitaControl('tipoReinversion');
			$('#reinvertir1').attr('checked',true);
			$('#reinvertir2').attr('checked',false);
			$('#reinvertir3').attr('checked',false);
			$('#tipoReinversion').val(reinvertir).selected;	
		}

		if (reinversion == 'I') {
			dwr.util.addOptions( "tipoReinversion", {'I': 'INDISTINTO'});	
			deshabilitaControl('tipoReinversion');;
			$('#reinvertir1').attr('checked',false);
			$('#reinvertir2').attr('checked',false);
			$('#reinvertir3').attr('checked',true);
			$('#tipoReinversion').val('I').selected;
		}

		if (reinversion == 'N') {			
			dwr.util.addOptions( "tipoReinversion", {'N':'NO REALIZA INVERSIÓN'});
			deshabilitaControl('tipoReinversion');
			$('#reinvertir1').attr('checked',false);
			$('#reinvertir2').attr('checked',true);
			$('#reinvertir3').attr('checked',false);
			$('#tipoReinversion').val('N').selected;
		}
	}
	
	function consultaComboTipoPagoInt(tipoPagoInt) { 
		var tp= tipoPagoInt.split(',');
		var tamanio = tp.length;
	 	for (var i=0;i<tamanio;i++) {  
			var tip = tp[i];
			var jqTipo = eval("'#tipoPagoInt option[value="+tip+"]'");  
			$(jqTipo).attr("selected","selected");    
			muestraCampoDias(tipoPagoInt);
		}
	}

	function muestraCampoDias(tipoPagoInt){
		var tipoPago  = eval("'" + tipoPagoInt + "'");
		var Periodo ='P';	
		var valor= tipoPago.split(",");
		for(var i=0; i< valor.length; i++){
			var tipoPagInt = valor[i];
			if(tipoPagInt == Periodo){	
				$('#diasPeriodo').show();
				$('#lbldiasPeriodo').show();
				$('#lblpagoIntCal').show();
			}else{
				$('#diasPeriodo').hide();
				$('#lbldiasPeriodo').hide();
				$('#lblpagoIntCal').hide();
			}
		}
	} 	
    
	function muestraCampoPagoIntCal(valTipoPagoInt){    
	    if((valTipoPagoInt.includes("P")) || (valTipoPagoInt.includes("F"))){
	    	$('#lblpagoIntCal').show();
	    }else{
	    	$('#lblpagoIntCal').hide();
	    }
	} 	


});




//***********  Actividades del Banco de MEXICO ***********//

	$('#agregaActividad').click(function(){
		agregaActividadBMX();
	});
	
	//funcion para agregar renglones de actividades BMX
	function agregaActividadBMX(){		
		$('#gridActividadesMBX').show(500);	
		 numeroFila = consultaFilas();
		var nuevaFila = parseInt(numeroFila) + 1;
		
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
				  
		if(numeroFila == 0){ 
				tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
				tds += '<input type="text" id="actividadBMXID'+nuevaFila+'" name="lactividadBMXID" size="20" tabindex="'+(tabButton = tabButton+1)+'" onKeyUp="listaActividades(\'actividadBMXID'+nuevaFila+'\');" onblur="consultaActividadBMX(this.id);" /></td>';
				tds += '<td><input  id="descripcionActBMX'+nuevaFila+'" name="descripcionActBMX"   size="80" value="" readOnly="true" type="text" /></td>';			
				tds += '<td nowrap="nowrap"><input type="button" name="eliminar" id="'+nuevaFila +'" value="" tabindex="'+(tabButton = tabButton+1)+'" class="btnElimina" onclick="eliminaActividad(this.id)"/>';
				tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value=""   tabindex="'+(tabButton = tabButton+1)+'" class="btnAgrega"  onclick="agregaActividadBMX()""/></td>';
				tds += '</tr>';	
		} else { 
			var contador = 1;
			    $('input[name=consecutivoID]').each(function() {		
				contador = contador + 1;	
			  });
				tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
				tds += '<input type="text" id="actividadBMXID'+nuevaFila+'" name="lactividadBMXID" size="20"  tabindex="'+(tabButton = tabButton+1)+'" onblur="consultaActividadBMX(this.id);" onKeyUp="listaActividades(\'actividadBMXID'+nuevaFila+'\');"  /></td>';
				tds += '<td><input  id="descripcionActBMX'+nuevaFila+'" name="descripcionActBMX"  size="80" value="" readOnly="true" type="text" /></td>';				
				tds += '<td nowrap="nowrap"><input type="button" name="eliminar" id="'+nuevaFila +'" value=""  tabindex="'+(tabButton = tabButton+1)+'" class="btnElimina" onclick="eliminaActividad(this.id)"/>';
				tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value=""  tabindex="'+(tabButton = tabButton+1)+'" class="btnAgrega"  onclick="agregaActividadBMX()""/></td>';
				tds += '</tr>';				
				}		
			   	   
			$("#tablaActividades").append(tds);
			return false;		
	 }
		
	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;		
		});
		return totales;
	}	
	
	function eliminaActividad(control){
	
		var contador = 0 ;
		var numeroID = control;
	
		var jqRenglon = eval("'#renglon" + numeroID + "'");
		var jqNumero = eval("'#consecutivoID" + numeroID + "'");
		var jqActividadBMXID = eval("'#actividadBMXID" + numeroID + "'");
		var jqDescripcion=eval("'#descripcionActBMX" + numeroID + "'");		
		var jqAgrega=eval("'#agrega" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");		
	
		// se elimina la fila seleccionada
		$(jqNumero).remove();
		$(jqActividadBMXID).remove();
		$(jqDescripcion).remove();	
		$(jqAgrega).remove();
		$(jqRenglon).remove();
		$(jqElimina).remove();
		
		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {		
			numero= this.id.substr(7,this.id.length);
			
			var jqRenglon = eval("'#renglon" + numero + "'");
			var jqNumero = eval("'#consecutivoID" + numero + "'");
			var jqActividadBMXID = eval("'#actividadBMXID" + numero + "'");
			var jqDescripcion=eval("'#descripcionActBMX" + numero + "'");		
			var jqAgrega=eval("'#agrega" + numero + "'");
			var jqElimina = eval("'#" + numero + "'");
			
			
			$(jqNumero).attr('id','consecutivoID'+contador);
			$(jqActividadBMXID).attr('id','actividadBMXID'+contador);
			$(jqDescripcion).attr('id','descripcionActBMX'+contador);			
			$(jqAgrega).attr('id','agrega'+ contador);
			$(jqRenglon).attr('id','renglon'+ contador);
			$(jqElimina).attr('id', contador);
			contador = parseInt(contador + 1);				
		});
	}
	
	function listaActividades(idControl){
		var valorControl=document.getElementById(idControl).value;
		lista(idControl, '2', '1','descripcion', valorControl,'listaActividades.htm');	
	}
	
	// funcion de consulta para las actividades BMX
	function consultaActividadBMX(idControl) {
		var jqActividadBMXID = eval("'#" + idControl + "'");
		var sbtrn = (idControl.length);
		var Control = idControl.substr(14, sbtrn);
		setTimeout("$('#cajaLista').hide();", 200);
	
		var numActividadBMXID = $(jqActividadBMXID).val();		
		var descripcion = eval("'#descripcionActBMX" + Control + "'");	
		var tipConCompleta = 3;
	
		esTab = true;
		if (numActividadBMXID != '' && !isNaN(numActividadBMXID)) {
			actividadesServicio.consultaActCompleta(tipConCompleta, numActividadBMXID, function(actividadComp) {
				if (actividadComp != null) {					
					$(descripcion).val(actividadComp.descripcionBMX);					
				} else {					
					mensajeSis("No Existe la Actividad BMX");
					$(jqActividadBMXID).val("");				
					$(descripcion).val("");
					$(jqActividadBMXID).focus();
				}
			});
		}
	}
	
	// funcion que consulta las Actividades Economicas BMX en BD y pone la descripcion
	function consultaActividadEconBD(actividadBMX){			
		var tds='';		
			if (actividadBMX != ''){
				var cadenaActividadBMX = actividadBMX.split(",");			
				var tamanio = cadenaActividadBMX.length;				
				var contador = 0;
					while(consultaFilas() >0){
						eliminaActividad(consultaFilas());
					}
					for ( var i = 0; i < tamanio; i++){
						
					tds += '<tr id="renglon' +i+ '" name="renglon">';
					tds += '<td><input  id="consecutivoID'+i+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
					tds += '<input type="text" id="actividadBMXID'+i+'" name="lactividadBMXID" value="'+cadenaActividadBMX[i]+'"size="20"  tabindex="'+(tabButton = tabButton+1)+'" onblur="consultaActividadBMX(this.id);" onKeyUp="listaActividades(\'actividadBMXID'+i+'\');"  /></td>';
					tds += '<td><input  id="descripcionActBMX'+i+'" name="descripcionActBMX"  size="80" value="" readOnly="true" type="text" /></td>';				
					tds += '<td nowrap="nowrap"><input type="button" name="eliminar" id="'+i +'" value=""  tabindex="'+(tabButton = tabButton+1)+'" class="btnElimina" onclick="eliminaActividad(this.id)"/>';
					tds += '<input type="button" name="agrega" id="agrega'+i +'" value=""  tabindex="'+(tabButton = tabButton+1)+'" class="btnAgrega"  onclick="agregaActividadBMX()""/></td>';						
					tds += '</tr>';	
						
					agregaFormatoControles('formaGenerica');
					contador ++;
					}
					
		    	 $("#tablaActividades").append(tds);
		    	 if(i == tamanio){						 
		    		 consultaActividad(); //pone la descripcion al grid
				}
	    	}				
		}
	// Pone la descripcion despues de  que pinta el grid
	function consultaActividad(){
		 setTimeout("$('#cajaLista').hide();", 200);	
			var tipConCompleta = 3;
			esTab = true;
		 $('tr[name=renglon]').each(function() {
				var numero= this.id.substr(7,this.id.length);
				
				var numActividad = $("#actividadBMXID" + numero).val();
					
					actividadesServicio.consultaActCompleta(tipConCompleta, numActividad, 	{ async: false, callback: function(actividadComp) {
						if (actividadComp != null) {
							$('#descripcionActBMX'+ numero).val(actividadComp.descripcionBMX);									
						} 
					}
					});					
		 });			
	}

		
	//**********   funcion para inicializar combos y multiselect ***** //
	function inicializaCampos(){		
		$('#genero').val("0").selected = true;
		$('#estadoCivil').val("0").selected = true;	
		$('#monedaSelect').val("").selected = true;	
		$("#tipoPagoInt").each(function(){  
	        $("#tipoPagoInt option").removeAttr("selected");  
	    });
		$('#diasPeriodo').hide();
		$('#lbldiasPeriodo').hide();
		$('#lblpagoIntCal').hide();
		$('#pagoIntCalIgual').attr('checked',true);
		

	}
	
	// funcion para eliminar la tabla de actividades BMX
	function eliminaTablaActividades(){		
		 $('tr[name=renglon]').each(function() {
				var numero= this.id.substr(7,this.id.length);
				$("#renglon" + numero).remove();
				
		 });
	}
	
	function funcionExito(){
		inicializaForma('formaGenerica','tipoCedeID');
		inicializaCampos();
		eliminaTablaActividades();
		deshabilitaBoton('modifica', 'submit');
		deshabilitaBoton('agrega', 'submit');
		$('#tasaF').attr('checked',true);
		$('#pagoIntCalIgual').attr('checked',true);
		$('#fechaInscripcion').val("");
		
		
	}
	
	function funcionFallo(){
		
	}
	
	function ayuda(){	
		var data;
		
		data = '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
		'<div id="ContenedorAyuda">'+ 
		'<legend class="ui-widget ui-widget-header ui-corner-all">Tipo Pago Interés</legend>'+
		'<table id="tablaLista" width="100%" style="margin-top:10px">'+
			'<tr>'+
				'<td colspan="0" id="contenidoAyuda"><b>Parámetro que indica si el Interés que se pagará en cada cuota del CEDE será Igual o se pagará por el número de días transcurridos.</b></td>'+ 
			'</tr>'+
		'</table>'+
		'</div>'+ 
		'</fieldset>';
		
		$('#ContenedorAyuda').html(data); 

		$.blockUI({
			message : $('#ContenedorAyuda'),
			css : {
				 left: '50%',
				 top: '50%',
				 margin: '-200px 0 0 -200px',
				 border: '0',
				 'background-color': 'transparent'
			}
		});  
	   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
	}
