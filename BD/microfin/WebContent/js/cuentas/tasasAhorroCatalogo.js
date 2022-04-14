var tipodePersona = "F";
var operacion ="";
$(document).ready(function() {
	esTab = false;

	//Definicion de Constantes y Enums  
	var catTipoTransaccionTasaAhorro = {
			'graba':'1',
			'modifica':'2', 
			'elimina':'3'
	};

	var catTipoConsultaTasaAhorro = {
			'principal':1,
			'foranea':2
	};	
	var catTipoListaTasaAhorro = {
			'principal':1,
			'foranea':2
	};


	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('modifica', 'submit'); 
	deshabilitaBoton('graba', 'submit');
	deshabilitaBoton('elimina', 'submit');
	$('#tipoCuentaID').focus();

	$(':text').focus(function() {	
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true', 'tasaAhorroID',
					'funcionExitoTasaAho', 'funcionFalloTasaAho');
		}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#graba').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTasaAhorro.graba);
		operacion="1";
	});

	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTasaAhorro.modifica);
		operacion="2";
		validaMontosEquemaTasas();
	});	
	$('#elimina').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTasaAhorro.elimina);
		operacion="3";
	});	

	$('#graba').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');
	$('#elimina').attr('tipoTransaccion', '3');


	$('#tasaAhorroID').blur(function() {
		validaTasaAhorro(this.id);	
	});

	$('#tipoCuentaID').bind('keyup',function(e){
		if(this.value.length >= 3){
			lista('tipoCuentaID', '3', '1', 'descripcion', $('#tipoCuentaID').val(), 'listaTiposCuenta.htm');
		}
	});

	$('#tasaAhorroID').bind('keyup',function(e){
		var tipoLista;
		if(this.value.length >= 0){
			var tipoCuenta = $('#tipoCuentaID').val();
			var monedaID=  $('#monedaID').val();		
			var camposLista = new Array();
			var parametrosLista = new Array();
			if (tipoCuenta == 0 || monedaID == 0){
				tipoLista = catTipoListaTasaAhorro.foranea ;
			}else {
				tipoLista = catTipoListaTasaAhorro.principal;
			}
			camposLista[0] = "tipoCuentaID";
			camposLista[1] = "monedaID";
			camposLista[2] = "tipoPersona";
			parametrosLista[0] = tipoCuenta;
			parametrosLista[1] = monedaID;
			if ($('#tipoPersonaF').is(':checked')){
				parametrosLista[2] = 'F';
				tipodePersona = 'F';
			}
			if ($('#tipoPersonaM').is(':checked')){
				parametrosLista[2] = 'M';
				tipodePersona = 'M';
			}
			if($('#tipoPersonaA').is(':checked')){ // Persona Fisica con Actividad Empresarial
				parametrosLista[2]= 'A';
				tipodePersona = 'A';
			}
			consultaGridTasasAho();
			lista('tasaAhorroID', '0', tipoLista, camposLista, parametrosLista, 'listaTasas.htm');
		}
	});	
	$('#montoSuperior').blur(function() {
		if(esTab){
			if($('#montoInferior').asNumber() >= $('#montoSuperior').asNumber()){
				mensajeSis("El Monto Superior debe de ser Mayor al Monto Inferior");
				$('#montoSuperior').focus();
			}			
		}
	});
	$('#montoInferior').blur(function() {
		if(esTab){
			validaMontosEquemaTasas();
		}		
	});

	consultaMoneda(); //para llenar el combobox de monedas
	consultaTiposCuenta();

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			monedaID : 	'required'
		},
		messages: {
			monedaID	: 'Especifique tipo de Moneda'
		}
	});


	//------------ Validaciones de Controles -------------------------------------

	function validaTasaAhorro(idControl) {
		var jqnum  = eval("'#" + idControl + "'");
		var numTasa = $(jqnum).val();
		var conPrincipal= 1;
		var TasaAhorroBeanCon = {
				'tasaAhorroID':numTasa
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numTasa != '' && !isNaN(numTasa) && esTab){

			if(numTasa=='0'){
				consultaGridTasasAho();
				habilitaBoton('graba', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('elimina', 'submit');
				inicializaForma('formaGenerica','tasaAhorroID');

			} else {	
				tasasAhorroServicio.consulta(conPrincipal, TasaAhorroBeanCon,function(tasaAhorro) {
					if(tasaAhorro!=null){
						dwr.util.setValues(tasaAhorro);	
						$('#monedaID').val(tasaAhorro.monedaID).selected = true;
						$('#tipoCuentaID').val(tasaAhorro.tipoCuentaID).checked = true;
						if(tasaAhorro.tipoPersona=='F'){                                 
							$('#tipoPersonaF').attr('checked', true);
							tipodePersona ='F';	                   
						} 
						else{
							if(tasaAhorro.tipoPersona=='M'){
								$('#tipoPersonaM').attr('checked', true);
								tipodePersona ='M';
							}
							else{
								if(tasaAhorro.tipoPersona=='A'){
									$('#tipoPersonaA').attr('checked', true);
									tipodePersona ='A';
								}
							}
						}		

						deshabilitaBoton('graba', 'submit');
						habilitaBoton('modifica', 'submit');
						habilitaBoton('elimina', 'submit');	
						consultaGridTasasAho();
					}else{
						//limpiaForm($('#formaGenerica'));
						mensajeSis("No Existe la Tasa de Ahorro");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('elimina', 'submit');
						deshabilitaBoton('graba', 'submit');
						/*$('#tipoCuentaID').focus();
						$('#tipoCuentaID').select();
						$('#tipoCuentaID').val(0);
						$('#monedaID').val(0);*/
						$('#tasasAhorroGrid').html("");
						$('#tasasAhorroGrid').hide();
						$('#tasaAhorroID').focus();
						$('#tasaAhorroID').val('');
						$('#montoInferior').val('');
						$('#montoSuperior').val('');
						$('#tasa').val('');
						//$('#tipoPersonaF').attr('checked', true);
					}
				});
			}
		}
	}

	function consultaTiposCuenta() {			
		dwr.util.removeAllOptions('tipoCuentaID'); 
		dwr.util.addOptions('tipoCuentaID', {0:'SELECCIONAR'}); 
		tiposCuentaServicio.listaCombo(9, function(tiposCuenta){
			dwr.util.addOptions('tipoCuentaID', tiposCuenta, 'tipoCuentaID', 'descripcion');		
		});
	}

	function consultaMoneda() {			
		dwr.util.removeAllOptions('monedaID'); 

		dwr.util.addOptions('monedaID', {0:'SELECCIONAR'}); 
		monedasServicio.listaCombo(3, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');

		});
	}

	$('#tipoPersonaF').click(function (){
		$('#tipoPersonaF').attr('checked', true);
		tipodePersona =$('#tipoPersonaF').val();
		$('#montoSuperior').val("");
		$('#montoInferior').val("");
		$('#tasa').val("");
		$('#tasaAhorroID').val("");
		$('#monedaID').val(0);
		$('#monedaID').focus();
		deshabilitaBoton('modifica', 'submit'); 
		deshabilitaBoton('elimina', 'submit');
		validaGrid();		
	});

	$('#tipoPersonaM').click(function (){
		$('#tipoPersonaM').attr('checked', true);
		tipodePersona =$('#tipoPersonaM').val();		
		$('#montoSuperior').val("");
		$('#montoInferior').val("");
		$('#tasa').val("");
		$('#tasaAhorroID').val("");
		$('#monedaID').val(0);
		$('#monedaID').focus();
		deshabilitaBoton('modifica', 'submit'); 
		deshabilitaBoton('elimina', 'submit');
		validaGrid();	
	});

	$('#tipoPersonaA').click(function (){
		$('#tipoPersonaA').attr('checked', true);
		tipodePersona =$('#tipoPersonaA').val();
		$('#montoSuperior').val("");
		$('#montoInferior').val("");
		$('#tasa').val("");
		$('#tasaAhorroID').val("");
		$('#monedaID').val(0);
		$('#monedaID').focus();
		deshabilitaBoton('modifica', 'submit'); 
		deshabilitaBoton('elimina', 'submit');
		validaGrid();		

	});

	$('#monedaID').change(function(){
		if($('#tipoCuentaID').val()!=0){
			if($('#monedaID').val()!=0){
				if(tipodePersona!="" && $('#tipoCuentaID').val()!=0){
					consultaGridTasasAho();
					$('#montoSuperior').val("");
					$('#montoInferior').val("");
					$('#tasa').val("");
					$('#tasaAhorroID').val("");

					deshabilitaBoton('modifica', 'submit'); 
					deshabilitaBoton('elimina', 'submit');
					validaGrid();
				}

			}
			else{
				$('#montoSuperior').val("");
				$('#montoInferior').val("");
				$('#tasa').val("");
				$('#tasaAhorroID').val("");
				validaGrid();
			}
		}
		else{
			mensajeSis("Especificar el tipo de Cuenta");
			$('#montoSuperior').val("");
			$('#montoInferior').val("");
			$('#tasa').val("");
			$('#tasaAhorroID').val("");
			$('#monedaID').val(0);
			$('#tipoPersonaF').attr('checked', true);
			$('#tipoCuentaID').focus();
			deshabilitaBoton('modifica', 'submit'); 
			deshabilitaBoton('elimina', 'submit');
			validaGrid();
		}
	});
	$('#tipoCuentaID').change(function(){
		if($('#tipoCuentaID').val()!=0){
			if(tipodePersona!="" && $('#monedaID').val()!=0){
				consultaGridTasasAho();
				$('#montoSuperior').val("");
				$('#montoInferior').val("");
				$('#tasa').val("");
				$('#tasaAhorroID').val("");
				$('#monedaID').val(0);

				deshabilitaBoton('modifica', 'submit'); 
				deshabilitaBoton('elimina', 'submit');
				validaGrid();
			}else{
				$('#montoSuperior').val("");
				$('#montoInferior').val("");
				$('#tasa').val("");
				$('#tasaAhorroID').val("");
				$('#monedaID').val(0);
				$('#tipoPersonaF').attr('checked', true);
				$('#tipoPersonaF').focus();
				deshabilitaBoton('modifica', 'submit'); 
				deshabilitaBoton('elimina', 'submit');
				validaGrid();
			}
		}
		else{
			$('#montoSuperior').val("");
			$('#montoInferior').val("");
			$('#tasa').val("");
			$('#tasaAhorroID').val("");
			$('#monedaID').val(0);
			$('#tipoPersonaF').attr('checked', true);
			$('#tipoCuentaID').focus();
			deshabilitaBoton('modifica', 'submit'); 
			deshabilitaBoton('elimina', 'submit');
			validaGrid();
		}
	});

	function consultaGridTasasAho(){
		if($('#tipoPersonaF').val()!= "" || $('#tipoPersonaM').val()!= "" || $('#tipoPersonaA').val()!= ""){
			if($('#tipoCuentaID').val()!=0 && $('#monedaID').val()!=0){
				var params = {};
				params['tipoLista'] = 1;
				params['tipoCuentaID'] =$('#tipoCuentaID').val();
				params['monedaID']=$('#monedaID').val() ;
				params['tipoPersona']=tipodePersona;
				$.post("tasasAhoGrid.htm", params, function(data){
					if(data.length >0) {

						$('#tasasAhorroGrid').html(data);
						$('#tasasAhorroGrid').show();
						var numFilas = consultaFilas();
						if(numFilas>0){
							$('#tasasAhorroGrid').html(data);
							$('#tasasAhorroGrid').show();
						}else{
							$('#tasasAhorroGrid').html("");
							$('#tasasAhorroGrid').hide();
						}

					}else{
						$('#tasasAhorroGrid').html("");
						$('#tasasAhorroGrid').hide();
					}
				});
			}
		}	
	}

	function validaGrid(){
		$('#tasasAhorroGrid').html("");
		$('#tasasAhorroGrid').hide();
	}

});



function validaMontosEquemaTasas(){
	var noFila = 0;
	var montofinal = 0 ;
	$('input[name=montoSuperior2]').each(function() {	
		noFila = noFila +1 ;
		montofinal= eval("'#montoSuperior2" + noFila+ "'");

	});
	if($('#tasaAhorroID').val()=="0"){
		if($('#montoInferior').asNumber() <= $(montofinal).asNumber()){
			var montoSup2;
			if($(montofinal).asNumber() > 0){
				montoSup2 = $(montofinal).val();
			}else{
				montoSup2 = 0;
			}
			mensajeSis("Verfique el Monto inferior, debe de ser mayor a: "+montoSup2);
			$('#montoInferior').focus();
		}
	}

}

function funcionExitoTasaAho(){
	
	if($('#tipoPersonaF').val()!= "" || $('#tipoPersonaM').val()!= "" || $('#tipoPersonaA').val()!= ""){
		var params = {};
		params['tipoLista'] = 1;
		params['tipoCuentaID'] =$('#tipoCuentaID').val();
		params['monedaID']=$('#monedaID').val() ;
		params['tipoPersona']=tipodePersona;
		$.post("tasasAhoGrid.htm", params, function(data){
			if(data.length >0) {

				$('#tasasAhorroGrid').html(data);
				$('#tasasAhorroGrid').show();
				var numFilas = consultaFilas();
				if(numFilas>0){
					$('#tasasAhorroGrid').html(data);
					$('#tasasAhorroGrid').show();
				}else{
					$('#tasasAhorroGrid').html("");
					$('#tasasAhorroGrid').hide();
				}
				
			}else{
				$('#tasasAhorroGrid').html("");
				$('#tasasAhorroGrid').hide();
				
			}
		});
		if(operacion !=""){
			$('#montoInferior').val("");
			$('#montoSuperior').val("");
			$('#tasa').val("");
			deshabilitaBoton('modifica');
			deshabilitaBoton('elimina');
			deshabilitaBoton('graba');
		}
	}	
}

function funcionFalloTasaAho(){
	//No se realiza operacion
	$('#montoInferior').val("");
	$('#tasaAhorroID').val("");
	$('#montoSuperior').val("");
	$('#tasa').val("");
	$('#tasasAhorroGrid').html("");
	$('#tasasAhorroGrid').hide();
}

function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;

	});
	return totales;
}