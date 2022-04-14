
var catTipoTransaccion = {
	'agregar' : 1,
	'modificar' : 2,
	'baja' : 3
};

var catTipoConsultaParametros = {
		'principal' : 1,
		'porFolio' : 3,
		'existeFolio' : 4
};

var folioVigente =0;
var existeFolioVigente = 'N';
var esTab = false;

$(document).ready(function() {
	listaMonedas();

	 var parametroBean = consultaParametrosSession();
     
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	agregaFormatoControles('formaGenerica');
	$('#historico').hide();
	deshabilitaBoton('historico','submit');
	
	$('#folioID').focus();
	 
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	consultaFolioVigente();	
	$.validator.setDefaults({
		submitHandler : function(event) {
			resultadoTransaccion =
				  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folioID','funcionExito','funcionError'); 	
		}
	});
		
	$('#grabar').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccion.agregar);		
	 });
		
	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.modificar);		
  	});
	
	$('#baja').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.baja);		
  	});
	
	$('#folioID').blur(function() {
		consultaFolio($('#folioID').val()); 
	});

	$('#montoRemesaUno').blur(function(){
		var monto = $('#montoRemesaUno').asNumber();
		if(monto<=0 && esTab){
			alert('El Monto Límite no debe ser cero o negativo.');
			$('#montoRemesaUno').focus();
		}
	});

	$('#montoRemesaDos').blur(function(){
		var monto = $('#montoRemesaDos').asNumber();
		if(monto<=0 && esTab){
			alert('El Monto Límite no debe ser cero o negativo.');
			$('#montoRemesaDos').focus();
		}
	});

	$('#montoRemesaTres').blur(function(){
		var monto = $('#montoRemesaTres').asNumber();
		if(monto<=0 && esTab){
			alert('El Monto Límite no debe ser cero o negativo.');
			$('#montoRemesaTres').focus();
		}
	});

	$('#montoLimEfecM').blur(function(){
		var monto = $('#montoLimEfecM').asNumber();
		if(monto<=0 && esTab){
			alert('El Monto Límite no debe ser cero o negativo.');
			$('#montoLimEfecM').focus();
		}
	});

	$('#montoLimEfecF').blur(function(){
		var monto = $('#montoLimEfecF').asNumber();
		if(monto<=0 && esTab){
			alert('El Monto Límite no debe ser cero o negativo.');
			$('#montoLimEfecF').focus();
		}
	});

	$('#montoLimEfecMes').blur(function(){
		var monto = $('#montoLimEfecMes').asNumber();
		if(monto<=0 && esTab){
			alert('El Monto Límite no debe ser cero o negativo.');
			$('#montoLimEfecMes').focus();
		}
	});
	
	  //------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({					
		rules: {				
			folioID: {
				required: true
			},		
			montoRemesaUno: {
				required: true,
				number: true
			},			
			montoRemesaDos: {
				required: true,
				number: true
			},			
			montoRemesaTres: {
				required: true,
				number: true
			},			
			montoLimEfecF: {
				required: true,
				number: true
			},			
			montoLimEfecM: {
				required: true,
				number: true
			},			
			montoLimEfecMes: {
				required: true,
				number: true
			}
		},		
		
		messages: {		
		
			folioID: {
				required: 'Especifique un Número de Folio.',
			},				
			montoRemesaUno: {
				required: 'Especifique un Monto Límite.',
				number: 'Sólo Números.'
			},			
			montoRemesaDos: {
				required: 'Especifique un Monto Límite.',
				number: 'Sólo Números.'
			},			
			montoRemesaTres: {
				required: 'Especifique un Monto Límite.',
				number: 'Sólo Números.'
			},			
			montoLimEfecF: {
				required: 'Especifique un Monto Límite.',
				number: 'Sólo Números.'
			},			
			montoLimEfecM: {
				required: 'Especifique un Monto Límite.',
				number: 'Sólo Números.'
			},			
			montoLimEfecMes: {
				required: 'Especifique un Monto Límite.',
				number: 'Sólo Números.'
			}
		}		
	});
	
	
	/* ***********************************FUNCIONES******************************  */
	// Consulta un numero de folio existente
	function consultaFolio(numFolio) {
		var bean = {
				folioID: numFolio
		};
		if(numFolio != '' && !isNaN(numFolio) && esTab){
			if(numFolio == '0' ) {
				consultaExisteFolioVig();
			    $('#fechaVigencia').val(parametroBean.fechaSucursal);
			 	$('#estatus').val('V');
				if(existeFolioVigente=="S"){
					alert("El Folio: "+folioVigente+" se Encuentra Vigente.");
					$('#folioID').val(folioVigente);
					$('#folioID').focus();
					funcionExito();
				} else {
					habilitaControlesParam();
					habilitaBoton('grabar','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('baja','submit');
					limpiaCombos();
					limpiaCampos();
				}
			} else {
				paramPLDOpeEfecServicio.consulta(bean, catTipoConsultaParametros.porFolio, function(datosParams){
					if (datosParams != null ){
						dwr.util.setValues(datosParams);
						if(datosParams.estatus == 'B'){
							deshabilitaControlesParam();
							deshabilitaBoton('grabar','submit');
							deshabilitaBoton('modifica','submit');
							deshabilitaBoton('baja','submit');
						} else {
							habilitaControlesParam();
							deshabilitaBoton('grabar','submit');
							habilitaBoton('modifica','submit');
							habilitaBoton('baja','submit');
						}
						agregaFormatoControles('contenedorForma');
					} else {
						alert("No existe el Folio Indicado.");				
						inicializaForma('formaGenerica','folioID');
						limpiaCombos();
						$('#folioID').val('');
						$('#folioID').focus();
						$('#estatus').val('');
						deshabilitaBoton('grabar','submit');
						deshabilitaBoton('modifica','submit');
						deshabilitaBoton('baja','submit');
					}
				});				
			}
		}
		
	}
	
	// Consulta el folio vigente actual
	function consultaFolioVigente(){
		var numFolio = 0;
		var bean = {
				folioID: numFolio
		};

		paramPLDOpeEfecServicio.consulta(bean, catTipoConsultaParametros.principal, function(datos){
			if(datos != null){
				dwr.util.setValues(datos);
				if(datos.estatus == 'B'){
					deshabilitaControlesParam();
					deshabilitaBoton('grabar','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('baja','submit');
				} else {
					habilitaControlesParam();
					deshabilitaBoton('grabar','submit');
					habilitaBoton('modifica','submit');
					habilitaBoton('baja','submit');
				}
				agregaFormatoControles('contenedorForma');
			} else {	
				inicializaForma('formaGenerica','folioID');
				limpiaCombos();
				$('#folioID').val('');
				$('#folioID').focus();
				habilitaControlesParam();
				habilitaBoton('grabar','submit');
				deshabilitaBoton('modifica','submit');
				deshabilitaBoton('baja','submit');
			}
		});
	}
	
	// Consulta la existencia de un folio vigente
	function consultaExisteFolioVig(){
		var bean = {
				folioID: 0
		};
		paramPLDOpeEfecServicio.consulta(bean, catTipoConsultaParametros.existeFolio, { async: false, callback:function(datosParams){
			if (datosParams != null ){
				existeFolioVigente=datosParams.folioVigente;
				folioVigente=datosParams.folioID;
			} else {
				existeFolioVigente='N';
				folioVigente=0;
			}
		}});
	}
	
	// Llena los combos con las monedas del catalogo MONEDAS
	function listaMonedas(){
		dwr.util.removeAllOptions('remesaMonedaID'); 
		monedasServicio.listaCombo(3, function(tiposCuenta){
			dwr.util.addOptions('remesaMonedaID', tiposCuenta, 'monedaID', 'descripcion');
		});
		
		dwr.util.removeAllOptions('montoLimMonedaID'); 
		monedasServicio.listaCombo(3, function(tiposCuenta){
			dwr.util.addOptions('montoLimMonedaID', tiposCuenta, 'monedaID', 'descripcion');
		});
		
	}
								
});

// Deshabilita los inputs text
function deshabilitaControlesParam(){
	deshabilitaControl('remesaMonedaID');
	deshabilitaControl('montoRemesaUno');
	deshabilitaControl('montoRemesaDos');
	deshabilitaControl('montoRemesaTres');
	deshabilitaControl('montoLimMonedaID');
	deshabilitaControl('montoLimEfecF');
	deshabilitaControl('montoLimEfecM');
	deshabilitaControl('montoLimEfecMes');
}

// Habilita los inputs text
function habilitaControlesParam(){
	habilitaControl('remesaMonedaID');
	habilitaControl('montoRemesaUno');
	habilitaControl('montoRemesaDos');
	habilitaControl('montoRemesaTres');
	habilitaControl('montoLimMonedaID');
	habilitaControl('montoLimEfecF');
	habilitaControl('montoLimEfecM');
	habilitaControl('montoLimEfecMes');	
}

// Funcion que limpia la forma 
function limpiaCampos(){
	inicializaForma('formaGenerica','folioID');
	$('#fechaVigencia').val(parametroBean.fechaAplicacion);
	$('#estatus').val('V');
	habilitaBoton('grabar','submit');
	deshabilitaBoton('modifica','submit');
	deshabilitaBoton('baja','submit');
}

// Funcion que inicializa los combos de monedas
function limpiaCombos(){
	$('#remesaMonedaID').val('1');
	$('#montoLimMonedaID').val('1');
}

// Funcion de exito
function funcionExito(){
	limpiaCampos();
	limpiaCombos();
	deshabilitaBoton('grabar','submit');
}

// Funcion de error
function funcionError(){
	agregaFormatoControles('contenedorForma');
}