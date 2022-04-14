
/**
 *
 * Función consulta lista niveles operacion
 *
 */
function comboOperacion(callbackFuncion){

	var bean = {};

	regulatorioInsServicio.lista(1,bean,{async: false, callback:function(nivelOperaciones){
		dwr.util.removeAllOptions('nivelOperaciones');
		dwr.util.addOptions('nivelOperaciones', {'':'SELECCIONAR'});
		dwr.util.addOptions('nivelOperaciones', nivelOperaciones, 'clave', 'descripcion');
		if(typeof callbackFuncion == 'function'){
			callbackFuncion();
		}
	}});

}

 /**
 *
 * Función consulta lista niveles regulacion prudencial
 *
 */
function comboPrudencial(callbackFuncion){

	var bean = {};

	regulatorioInsServicio.lista(3,bean,{async: false, callback:function(nivelPrudencial){
		dwr.util.removeAllOptions('nivelPrudencial');
		dwr.util.addOptions('nivelPrudencial', {'':'SELECCIONAR'});
		dwr.util.addOptions('nivelPrudencial', nivelPrudencial, 'clave', 'descripcion');
		if(typeof callbackFuncion == 'function'){
			callbackFuncion();
		}
	}});

}


 /**
 *
 * Función consulta instituciones con regulatorios
 *
 */
 function comboInstituciones(callbackFuncion){

	var bean = {};

	regulatorioInsServicio.lista(2,bean,{async: false, callback:function(formatoRegulatorios){
		dwr.util.removeAllOptions('tipoRegulatorios');
		dwr.util.addOptions('tipoRegulatorios', {'':'SELECCIONAR'});
		dwr.util.addOptions('tipoRegulatorios', formatoRegulatorios, 'clave', 'descripcion');
		if(typeof callbackFuncion == 'function'){
			callbackFuncion();
		}
	}});

 }


 /**
  *
  * Función para consultar los datos de parametros
  *
  */
var parametroSaldo;
var parametroCuentaConta;
function consultaParametros(){
	var bean = {};
	paramRegulatoriosServicio.consulta(1,bean,{async: false, callback:function(parametros){
		dwr.util.setValues(parametros);
		parametroSaldo = parametros.ajusteSaldo;
		parametroCuentaConta = parametros.cuentaContableAjusteSaldo;
		$('#ajusteSaldo').val(parametroSaldo);
		$('#cuentaContableAjusteSaldo').val(parametroCuentaConta);
	}});

}


function exito(){
	consultaParametros();
}


$(document).ready(function() {

	$('#tipoRegulatorios').focus();
	comboOperacion(function(){
		comboPrudencial(function(){
			comboInstituciones(function(){
				consultaParametros();
			});
		});
	});

	validaAjuste(parametroSaldo);
	cuentaDescripcion(parametroCuentaConta);

	$('#modificar').click(function(event){
		$('#tipoTransaccion').val(2);
	});


	$('#nivelOperaciones').change(function(event){
		if($('#nivelOperaciones').val() != ''){
			if($('#nivelOperaciones').asNumber() == 0){
				$('#nivelPrudencial').val(0);
			}else{
				if($('#nivelPrudencial').asNumber() == 0){
					$('#nivelPrudencial').val(1);
				}
			}
		}
	});

	$('#nivelPrudencial').change(function(event){
		if($('#nivelPrudencial').val() != ''){
			if($('#nivelPrudencial').asNumber() == 0){
				$('#nivelOperaciones').val(0);
			}else{
				if($('#nivelOperaciones').asNumber() == 0){
					$('#nivelOperaciones').val(1);
				}
			}
		}
	});

	$('#ajusteSaldo').change(function(event){
		validaAjuste($('#ajusteSaldo').val());
	});


	$('#ajusteSaldo').blur(function(event){
		validaAjuste($('#ajusteSaldo').val());
	});

	$('#cuentaContableAjusteSaldo').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#cuentaContableAjusteSaldo').val();
			listaAlfanumerica('cuentaContableAjusteSaldo', '1', '9', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});

	$('#cuentaContableAjusteSaldo').blur(function(event){
		setTimeout("$('#cajaLista').hide();", 200);
		var cuentaContable = $('#cuentaContableAjusteSaldo').val();
		cuentaDescripcion(cuentaContable);
	});

	function cuentaDescripcion(cuentaContable){
		var numCtaContable = cuentaContable;
		var consultaRegulatorio = 2;
		var CtaContableBeanCon = {
			'cuentaCompleta':numCtaContable
		};
		if(numCtaContable != '' && !isNaN(numCtaContable )){
			cuentasContablesServicio.consulta(consultaRegulatorio,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){
					$('#descripcionCta').val(ctaConta.descripcion);
					$('#cuentaContableAjusteSaldo').val(ctaConta.cuentaCompleta);
				}
				else{
					$('#cuentaContableAjusteSaldo').focus();
					$('#descripcionCta').val('');
					$('#cuentaContableAjusteSaldo').val('');
					mensajeSis('No existe la cuenta contable');
				}
			});
		}
		else{
			if(numCtaContable != '' && !isNaN(numCtaContable )){

			}else{
				$('#descripcionCta').val('');
				$('#cuentaContableAjusteSaldo').val('');
			}
		}
	}

	function validaAjuste(parametro){
		var ajusteSaldo = parametro;
		var var_SI = 'S';
		if( ajusteSaldo == var_SI ){
			$('#cuentaContableAjusteSaldo').show();
			$('#descripcionCta').show();
			$('#cuentaConta').show();
		}else{
			$('#cuentaContableAjusteSaldo').hide();
			$('#descripcionCta').hide();
			$('#cuentaConta').hide();
		}
	}

	// Validaciones de la forma
   $('#formaGenerica').validate({
		rules: {
			tipoRegulatorios  : {
				required : true,
			},
			claveEntidad  : {
				required : true,
				maxlength : 10,
				minlength : 6,
				alfanumerico: true
			},
			nivelOperaciones  : {
				required : true,
			},
			nivelPrudencial  : {
				required : true,
			},
			cuentaEPRC  : {
				required : true,
				maxlength : 10,
				cuentaEprc: true
			},
			claveFederacion :{
				alfanumerico: true
			},
			muestraRegistros: {
				required: true
			},
			mostrarComoOtros: {
				required: true
			},
			sumaIntCredVencidos: {
				required: true
			},
			ajusteSaldo: {
				required: true
			},
			mostrarSucursalOrigen: {
				required: true
			},
			contarEmpleados: {
				required:true
			},
			tipoRepActEco: {
				required:true
			},
			ajusteResPreventiva: {
				required:true
			},
			ajusteCargoAbono: {
				required:true
			},
			ajusteRFCMenor: {
				required:true
			}
		},
		messages: {
			tipoRegulatorios  : {
				required : "Seleccione un formato de regulatorios",
			},
			claveEntidad  : {
				required : "Ingrese la clave CASFIM",
				maxlength : "Máximo 10 caracteres",
				minlength : "Minimo 6 caracteres",
				alfanumerico: "Ingrese una clave válida"
			},
			nivelOperaciones  : {
				required : "Seleccione el Nivel de Operaciones",
			},
			nivelPrudencial  : {
				required : "Seleccione el Nivel Prudencial",
			},
			cuentaEPRC  : {
				required : "Ingrese la cuenta de Estimación Preventiva",
				maxlength : "Máximo 10 caracteres",
				cuentaEprc: "Ingrese una cuenta válida"
			},
			claveFederacion :{
				alfanumerico: "Ingrese una clave válida"
			},
			muestraRegistros: {
				required: "Seleccione una opción"
			},
			mostrarComoOtros: {
				required: "Seleccione una opción"
			},
			sumaIntCredVencidos: {
				required: "Seleccione una opción"
			},
			ajusteSaldo: {
				required: "Seleccione una opción"
			},
			mostrarSucursalOrigen: {
				required: "Seleccione una opción"
			},
			contarEmpleados: {
				required: "Seleccione una opción"
			},
			tipoRepActEco: {
				required: "Seleccione el tipo de reporte de actividad económica"
			},
			ajusteResPreventiva: {
				required: "Seleccione una opción"
			},
			ajusteCargoAbono: {
				required: "Seleccione una opción"
			},
			ajusteRFCMenor: {
				required: "Seleccione una opción"
			}
		},
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoRegulatorios',"exito","exito");
		}
	});

	$.validator.addMethod("alfanumerico", function(value, element) {
		return this.optional(element) || /^[a-z0-9%\s]+$/i.test(value);
	}, "Ingrese solo letras");

	$.validator.addMethod("cuentaEprc", function(value, element) {
		return this.optional(element) || /^[0-9%\s]+$/i.test(value);
	}, "Ingrese solo letras");

	$('#tipoRegulatorios').change(function(){
		if($('#tipoRegulatorios').asNumber() ==  3){
			$('.par_sofipo').show();
		}else{
			$('.par_sofipo').hide();
		}
	});

}); // fin ready
