$(document).ready(function() {
	esTab = true;
	agregaFormatoControles('formaGenerica');
	listaMonedas();

	parametros = consultaParametrosSession();
	
	//Definicion de Constantes y Enums  
	var catTipoTransaccionParamOpRel = {
			'grabar':1,
			'grabar3':2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	validaLimiteOperRel();
	habilitaBoton('grabar', 'submit');

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grabar').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccionParamOpRel.grabar);
	});
	
	$.validator.setDefaults({	
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','monedaLimOPR','funcionExito','funcionError');
		}
	 });
	

	$('#limiteInferior').blur(function (){
		validaNumeros(this.id);
	});
	$('#limMensualMicro').blur(function (){
		validaNumeros(this.id);
	});
	
	$('#verhistorico').click(function(event){
		event.preventDefault();
		enviaDatoRepRelevantes();
	});
	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules: {

			monedaID: {
				required: true
			},
			monedaLimMicro: {
				required: true
			},

			limiteInferior: {
				required: true,
				maxlength: 16
			},
			limMensualMicro: {
				required: true,
				maxlength: 16
			}
		},
		messages: {
			monedaID: {
				required: 'Especificar Moneda'
			},

			monedaLimMicro: {
				required: 'Especificar Moneda'

			},
			limiteInferior: {
				required: 'Especificar Límite Inferior',
				numeroPositivo: 'Solo número',
				maxlength: 'Máximo 10 dítos y 2 decimales'
			},
			limMensualMicro: {
				required: 'Especificar Límite Mensual',
				numeroPositivo: 'Solo número',
				maxlength: 'Máximo 10 dítos y 2 decimales'
			}
		}		
	});
	
	
	//------------ Validaciones de Controles -------------------------------------

	function validaLimiteOperRel() { 
		setTimeout("$('#cajaLista').hide();", 200);
		var moneda = $('#monedaLimOPR').val();
		if(moneda =='-1' ){
			habilitaBoton('agrega', 'submit');		
			deshabilitaBoton('modifica', 'submit');
			inicializaForma('formaGenerica','clienteID');


		} else {


			habilitaBoton('agrega', 'submit');	
			habilitaBoton('verhistorico', 'submit');
			var bean = {
					'monedaLimOPR' :  $('#monedaLimOPR').val()
			};
			paramOpRelServicio.consulta(1,bean,function(paramsOpRel) {
				if(paramsOpRel!=null){
					dwr.util.setValues(paramsOpRel);
					habilitaBoton('agrega', 'submit');	
					habilitaBoton('verhistorico', 'submit');
					agregaFormatoControles('contenedorForma');

				}else{
					deshabilitaBoton('verhistorico', 'submit');												
				}
			});		
		}

	}

	function validaNumeros(controlID){
		var jqControl = eval("'#" + controlID + "'");
		var valor = $(jqControl).val();
		
		if(valor != ''){	
			if(isNaN(valor)){
				if($(jqControl).asNumber() <= 0){
					alert("Ingrese una Cantidad Correcta.");
					$(jqControl).focus();
					$(jqControl).select();
				}
			}
		}
	}

	function ConsultaLimitesMicrocredito() { 
		setTimeout("$('#cajaLista').hide();", 200);

		var moneda2 = $('#monedaLimMicro').val();
		if(moneda2 =='0' ){
			habilitaBoton('grabar', 'submit');		
			inicializaForma('formaGenerica','clienteID');

		} else {

			habilitaBoton('grabar', 'submit');

			var paramsOpRel = {
					'monedaLimMicro' :  $('#monedaLimMicro').val()
			};
			paramOpRelServicio.consulta(1,paramsOpRel,function(paramsOpRel) {
				if(paramsOpRel!=null){
					$('#monedaLimMicro').val(paramsOpRel.monedaLimMicro).selected = true;
					$('#limMensualMicro').val(paramsOpRel.limMensualMicro);
					habilitaBoton('grabar', 'submit');
					agregaFormatoControles('contenedorForma');

				}else{
					deshabilitaBoton('verhistorico', 'submit');												
				}
			});		
		}

	}
	
	
	function enviaDatoRepRelevantes(){
		var desMonedaLimOPR=$("#monedaLimOPR option:selected").val();
		var nombreusuario =parametros.nombreUsuario;
		var nombreInstitucion=parametros.nombreInstitucion;
		var fechaEmision=parametros.fechaSucursal;

		if(desMonedaLimOPR !=0){
			desMonedaLimOPR = $("#monedaLimOPR option:selected").html();
		}

		var pagina = 'RepParametrosOpRel.htm?MonedaOPR='+desMonedaLimOPR+
		'&nombreusuario='+nombreusuario+'&nombreInstitucion='+nombreInstitucion
		+'&fechaEmision='+fechaEmision;
		window.open(pagina,'_blank');
	}

	function enviaDatoRepTipoInstrum(){
		var nombreusuario =parametros.nombreUsuario;
		var nombreInstitucion=parametros.nombreInstitucion;
		var fechaEmision=parametros.fechaSucursal;

		var pagina = 'RepParametrosOpTipoInstrumento.htm?nombreusuario='+
		nombreusuario+'&nombreInstitucion='+nombreInstitucion
		+'&fechaEmision='+fechaEmision;
		window.open(pagina,'_blank');
	}
	
	
	function listaMonedas(){
		dwr.util.removeAllOptions('monedaLimOPR'); 
		dwr.util.removeAllOptions('monedaLimMicro'); 
		monedasServicio.listaCombo(3, function(tiposCuenta){
			dwr.util.addOptions('monedaLimOPR', tiposCuenta, 'monedaID', 'descripcion');
			dwr.util.addOptions('monedaLimMicro', tiposCuenta, 'monedaID', 'descripcion');
		});
	}

});

function funcionExito(){
	agregaFormatoControles('formaGenerica');
}

function funcionError(){
	agregaFormatoControles('formaGenerica');
}