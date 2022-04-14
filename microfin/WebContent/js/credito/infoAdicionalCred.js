$(document).ready(function() {
	esTab = false;
	var contPlaca = 0;
	var contGnv = 0;
	var contVin = 0;
	var contEst = 0;
	
	var catTipoTransaccion = {
  		'agrega':'1'
  	};
	
	var catTipoConsulta = {
		'relacion': 1
	};
	
	agregaFormatoControles('formaGenerica'); 
	deshabilitaBoton('grabar', 'submit');
	$('#creditoID').focus();
   
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
			if (contPlaca == 0 && contGnv == 0 && contVin == 0 && contEst == 0){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','funcionExito','funcionError');					
			}else{
				verificarVacios();
				limpiaGrid();
			}
		}
	});
	
	$('#grabar').click(function() {
		validaFormGrid();
		$('#tipoTransaccion').val(catTipoTransaccion.agrega);
		creaRelacionCred();
	});
	
	$('#creditoID').blur(function() {
		if(esTab){
			consultaCred();
		}
	});
	$('#creditoID').bind('keyup',function(e){	
		lista('creditoID', '2', '1', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});

	$('#creditoID').bind('keyup',function(e){
		if($('#creditoID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});

	$('#formaGenerica').validate({				
		rules: {			
			creditoID: {
				required: true
			}
		},
		
		messages: {
			creditoID: {
				required: 'Especifique el numero de Credito',
			}			
		}		
	});

	function consultaCred() {
		var numCred = $('#creditoID').asNumber(); 
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCred > 0){
			var bean = {
					'creditoID' : numCred
			};
			infoAdicionalCredServicio.consulta(catTipoConsulta.relacion, bean, function(relacion) {
				if(relacion.creditoID != null){	
					$('#creditoID').val(relacion.creditoID);						
					$('#nombreCliente').val(relacion.nombreCom);
						 consultaRelacion();
				} else {
					mensajeSis("No Existe el Crédito");
					$('#creditoID').val('');
					$('#nombreCliente').val('');
					$('#creditoID').focus();
					$('#creditoID').select();
					deshabilitaBoton('grabar','submit');
					$('#gridRelacion').html("");
					$('#gridRelacion').hide();
				}    	 						
			});
		} else {
			mensajeSis("No Existe el Crédito");
			$('#creditoID').val('');
			$('#nombreCliente').val('');
			$('#creditoID').focus();
			$('#creditoID').select();
			deshabilitaBoton('grabar','submit');
			$('#gridRelacion').html("");
			$('#gridRelacion').hide();
		}		
	}
		
	function consultaRelacion(){
		var numCred = $('#creditoID').val();
		
		if (numCred != '' && !isNaN(numCred) ){
			var params = {};
			params['tipoLista'] = 1;
			params['creditoID'] = numCred; 
			
			$.post("gridInfoAdicionalCred.htm", params, function(data){
				if(data.length > 0) {
					$('#gridRelacion').html(data);
					$('#gridRelacion').show();
					habilitaBoton('grabar', 'submit');
					if ($('#numeroRelaciones').val() == 0){
						deshabilitaBoton('grabar','submit');						
					}
				} else {
					$('#gridRelacion').html("");
					$('#gridRelacion').show();
					deshabilitaBoton('grabar','submit');
				}
			});
		} else {
			$('#gridRelacion').hide();
			$('#gridRelacion').html('');
			deshabilitaBoton('grabar','submit');
		}
	}
	
	function creaRelacionCred(){
		var contador = 1;
		$('#lisPlacas').val("");
		$('#lisGnv').val("");
		$('#lisVin').val("");
		$('#lisEst').val("");
				
		$('input[name=idPlaca]').each(function() {
			if (this.value == '') this.value = 0;
			if (contador != 1){
				$('#lisPlacas').val($('#lisPlacas').val() + ','  + this.value);
			}else{
				$('#lisPlacas').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=idGnv]').each(function() {
			if (this.value == '') this.value = 0;
			if (contador != 1){
				$('#lisGnv').val($('#lisGnv').val() + ','  + this.value);
			}else{
				$('#lisGnv').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=idVin]').each(function() {
			if (contador != 1){
				$('#lisVin').val($('#lisVin').val() + ','  + this.value);
			}else{
				$('#lisVin').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('[name=idEstatus]').each(function() {
			if (contador != 1){
				$('#lisEst').val($('#lisEst').val() + ','  + this.value);
			}else{
				$('#lisEst').val(this.value);
			}
			contador = contador + 1;
		});
	}

	function validaFormGrid(){
		contPlaca = 0;		
		$('input[name=idPlaca]').each(function () {
			if (isEmpty(this.value)){
				contPlaca++;
			}
		});
		contGnv = 0;
		$('input[name=idGnv]').each(function () {
			if (isEmpty(this.value)){
				contGnv++;
			}
		});
		contVin = 0;
		$('input[name=idVin]').each(function () {
			if (isEmpty(this.value)){
				contVin++;
			}
		});
		contEst = 0;
		$('[name=idEstatus]').each(function () {
			if (isEmpty(this.value)){
				contEst++;
			}
		});
	}

	function isEmpty(obj) {
	if (typeof obj == 'undefined' || obj === null || obj === '' || obj == 0) return true;
		if (typeof obj == 'number' && isNaN(obj)) return true;
	 	if (obj instanceof Date && isNaN(Number(obj))) return true;
	 	return false;
	}

});

function verificarVacios(){	
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqPlaca = eval("'#placa" + numero + "'");
		var jqGnv = eval("'#gnv" + numero + "'");
		var jqVin = eval("'#vin" + numero + "'");
		var jqEst = eval("'#estatus" + numero+ "'");

		if($(jqPlaca).asNumber() == 0 || $(jqGnv).asNumber() == 0 || $(jqVin).asNumber() == 0 || $(jqEst).asNumber() == 0 ||
				$(jqPlaca).val().length < 5 || $(jqGnv).val().length < 16 || $(jqVin).val().length < 1){
			mensajeSis('Los Valores no pueden estar Vacios o con Valor de 0.');
			$(jqPlaca).focus();
			return false;
		}
	});		
}

function limpiaGrid() {
	$('input[name=idPlaca]').each(function () {
		if (this.value == ''){
			$(this).val('');
		}
	});
	$('input[name=idGnv]').each(function () {
		if (this.value == ''){
			$(this).val('');
		}
	});
	$('input[name=idVin]').each(function () {
		if (this.value == ''){
			$(this).val('');
		}
	});
	$('[name=idEstatus]').each(function () {
		if (this.value == ''){
			$(this).val('');
		}
	});
}

function funcionExito(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 
			
			$('#gridRelacion').html("");
			$('#gridRelacion').hide();
			$('#creditoID').focus();
			deshabilitaBoton('grabar', 'submit');
		}
      }, 50);
	}
}

//función de error en la transacción
function funcionError(){
	
}