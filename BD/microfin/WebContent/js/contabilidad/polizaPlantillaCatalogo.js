 var generaPoliza=false;
	var control='plantillaID';
$(document).ready(function(e) {
	esTab = true;
	//press = false;


	var parametroBean = consultaParametrosSession();

	//Definicion de Constantes y Enums
	var catTipoConsultaCtaContable = {
  		'principal':1
	};

	var catTipoTransaccionCtaContable = {
  		'grabar':'1',
  		'modificar':'2',
  		'plantillaPoliza':'4',
  		'plantilla':'5'
	};

	var catTipoListaConConta = {
		'principal':1
	};

	var catTipoConsultaConConta = {
		'principal' : 1
	};


	//------------ Metodos y Manejo de Eventos -----------------------------------------
   	deshabilitaBoton('grabar', 'submit');
   	deshabilitaBoton('guardar', 'submit');
   	deshabilitaBoton('modificar', 'submit');
	$('#imprimir').hide();
   	agregaFormatoControles('formaGenerica');



	$.validator.setDefaults({
      submitHandler: function(event) {
    	var numDetalle = $('input[name=consecutivoID]').length;
    	if(numDetalle>0){
      	grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'false', control,
				'limpiaForma','');

      }else{
    	  alert('Se Requieren Movimientos Contables');
      }
      }
   });
//
//	$(':text').bind('keydown',function(e){
//		if (e.which == 9 && !e.shiftKey){
//			esTab= true;
//			press=true;
//		}
//		if (e.which == 9 && e.shiftKey){
//			press= false; //alert("44");
//		}
//	});
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});


	$(':text').focus(function() {
		esTab = false;
	});


	$('#grabar').click(function(event) {
	sumaCargos= $('#ciCtrlCargos').asNumber();
	sumaAbonos= $('#ciCtrlAbonos').asNumber();
	diferencia = 0;
	if(sumaCargos>sumaAbonos){
  		diferencia= (sumaCargos-sumaAbonos).toFixed(2);
  		$('#diferencia').val(diferencia);
  	}
  	if(sumaCargos<sumaAbonos){
  		diferencia= (sumaAbonos-sumaCargos).toFixed(2);
  		$('#diferencia').val(diferencia);
  	}
  	if(sumaAbonos==sumaCargos){
  		diferencia= 0;
  		$('#diferencia').val(diferencia);
  	}
  	if($('#diferencia').asNumber() != 0){
		mensajeSis('La Póliza que desea agregar no está cuadrada.');
  	}
  	else{
		$('#tipoTransaccion').val(catTipoTransaccionCtaContable.grabar);
		$('#tipo').val('M');
		crearPoliza();
		$('#imprimir').show();
		generaPoliza=true;
		control='polizaID';
		$('#polizaID').val($('#plantillaID').val());
		}
	});



	$('#guardar').click(function(event) {
		$('#tipoTransaccion').val(catTipoTransaccionCtaContable.plantilla);
		$('#tipo').val('M');
		crearPoliza();
		$('#imprimir').hide();
		$('#polizaID').val($('#plantillaID').val());
		control='plantillaID';
		generaPoliza=false;
	});

	$('#modificar').click(function(event) {
		$('#tipoTransaccion').val(catTipoTransaccionCtaContable.modificar);
		$('#tipo').val('M');
		$('#tipo').val('M');
		crearPoliza();
		$('#imprimir').hide();
		$('#polizaID').val($('#plantillaID').val());
		control='plantillaID';
		generaPoliza=false;
	});
	$('#imprimir').click(function() {
			var poliza = $('#polizaID').val();
			var fecha = $('#fecha').val();
			var pagina='RepPoliza.htm?polizaID='+poliza+'&fechaInicial='+parametroBean.fechaSucursal+
					'&fechaFinal='+parametroBean.fechaSucursal+'&nombreUsuario='+parametroBean.nombreUsuario;
			window.open(pagina,'_blank');

		});
	$('#plantillaID').blur(function() {
  		validaPoliza('plantillaID');
	});

	$('#concepto').blur(function() {
  		$('#desPlantilla').val($('#concepto').val());
	});



	$('#conceptoID').bind('keyup',function(e){
		if(this.value.length >= 1){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#conceptoID').val();
			listaAlfanumerica('conceptoID', 1, catTipoListaConConta.principal, camposLista,
					 parametrosLista, 'listaConceptosConta.htm');
		}
	});

	$('#conceptoID').blur(function() {
  		consultaConceptoConta('conceptoID');
	});

	$('#fecha').blur(function() {
		$('#conceptoID').focus();
	});
	consultaMoneda();

	$('#plantillaID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "desPlantilla";
			parametrosLista[0] = $('#plantillaID').val();
			listaAlfanumerica('plantillaID', 2,2, camposLista,
					 parametrosLista, 'listaPolizaPlantilla.htm');
		}
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			cuentaCompleta : 'required',
			monedaID	   : 'required',
			conceptoID	   : 'required',
			fecha		   : 'required',
		},

		messages: {
			cuentaCompleta : 'Especifique la Cuenta',
			monedaID			: 'Especifique la Moneda',
			conceptoID		: 'Especifique el concepto',
			fecha		: 'Especifique la fecha',
		}
	});
	//------------ Validaciones de Controles ----------------------------------

	function validaPoliza(idControl) {
		var jqPoliza = eval("'#" + idControl + "'");
		var numPoliza = $(jqPoliza).val();
		var conPlantilla= 2;
		var PolizaBeanCon = {
  			'polizaID':numPoliza
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numPoliza != '' && !isNaN(numPoliza) && esTab){
			if(numPoliza=='0'){
				$('#fecha').val(parametroBean.fechaSucursal);
				$('#conceptoID').val('');
				$('#concepto').val('');
				$('#desPlantilla').val('');
				$('#polizaID').val('');
				 habilitaBoton('guardar', 'submit');
				 deshabilitaBoton('grabar', 'submit');
				 deshabilitaBoton('modificar', 'submit');
				 consultaDetalle();
				 $('#imprimir').hide();

			} else {

				polizaServicio.consulta(conPlantilla, PolizaBeanCon, function(poliza){
					if(poliza!=null){
						consultaDetalle();
						$('#fecha').val(parametroBean.fechaSucursal);
						$('#plantillaID').val(poliza. polizaID);
						$('#conceptoID').val(poliza.conceptoID);
						$('#concepto').val(poliza.concepto);
						$('#desPlantilla').val(poliza.desPlantilla);
						$('#polizaID').val('');
					 	$('#imprimir').hide();
					 	deshabilitaBoton('guardar', 'submit');
					 	deshabilitaBoton('grabar', 'submit');
					 	habilitaBoton('modificar', 'submit');


					}else{
						alert("La plantilla No Existe");
						limpiaForma();
						$('#plantillaID').val('');
						$('#plantillaID').focus();


					}
				});
			}
		}
	}

	function consultaConceptoConta(idControl){
		var conceptoConta = $('#conceptoID').val();
		var tipoConsulta = catTipoConsultaConConta.principal;
		setTimeout("$('#cajaLista').hide();", 200);

		var conceptoContableBean = {
      	'conceptoContableID':conceptoConta
      };

		if(conceptoConta != '' && !isNaN(conceptoConta) && esTab){
			conceptoContableServicio.consulta(tipoConsulta, conceptoContableBean, function(conceptoContable){
				if(conceptoContable!=null){
					$('#conceptoID').val(conceptoContable.conceptoContableID);
					$('#concepto').val(conceptoContable.descripcion);
				}else{
					$('#concepto').val('');
				}
			});
		}
	}

	function consultaDetalle(){
		var params = {};
		params['tipoLista'] = 2;
		params['polizaID'] = $('#plantillaID').val();

		$.post("gridPolizaContablePlantilla.htm", params, function(data){
				if(data.length >0) {
						$('#gridDetalle').html(data);
						$('#gridDetalle').show();
						sumaCifrasControlCargos();
						sumaCifrasControlAbonos();
						diferenciaCargosAbonos();
						$('tr[name=renglon]').each(function() {
							var numero= this.id.substr(7,this.id.length);
							maestroCuentasDescripcion('cuentaCompleta'+numero, 'desCuentaCompleta'+numero);
						});
				}else{
						$('#gridDetalle').html("");
						$('#gridDetalle').show();
				}




		});


	}



	function consultaMoneda() {
  		dwr.util.removeAllOptions('monedaID');

		//dwr.util.addOptions('monedaID', {"":'Seleciona'});
		monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

   //$('#fecha').val(parametroBean.fechaSucursal);

   function crearPoliza(){
		var mandar = verificarvacios();

		if(mandar!=1){
	   	quitaFormatoControles('gridDetalle');
			var numDetalle = $('input[name=consecutivoID]').length;
			$('#detallePoliza').val("");
			for(var i = 1; i <= numDetalle; i++){
				controlQuitaFormatoMoneda("cargos"+i+"");
				controlQuitaFormatoMoneda("abonos"+i+"");
				if(i == 1){
				$('#detallePoliza').val($('#detallePoliza').val() +
											//document.getElementById("consecutivoID"+i+"").value + '-' +
											$('#fecha').val() + ']' +
											document.getElementById("centroCostoID"+i+"").value + ']' +
											document.getElementById("cuentaCompleta"+i+"").value + ']' +
											document.getElementById("referencia"+i+"").value + ']' + // agrega el instrumento
											document.getElementById("referencia"+i+"").value + ']' +
											document.getElementById("descripcion"+i+"").value + ']' +
											$('#monedaID').val()+ ']' +
											document.getElementById("cargos"+i+"").value + ']' +
											document.getElementById("abonos"+i+"").value + ']');
				}else{
				$('#detallePoliza').val($('#detallePoliza').val() + '[' +
											//document.getElementById("consecutivoID"+i+"").value + '-' +
											$('#fecha').val() + ']' +
											document.getElementById("centroCostoID"+i+"").value + ']' +
											document.getElementById("cuentaCompleta"+i+"").value + ']' +
											document.getElementById("referencia"+i+"").value + ']' + // agrega el instrumento
											document.getElementById("referencia"+i+"").value + ']' +
											document.getElementById("descripcion"+i+"").value + ']' +
											$('#monedaID').val()+ ']' +
											document.getElementById("cargos"+i+"").value + ']' +
											document.getElementById("abonos"+i+"").value + ']');
				}
			}
		}
		else{
			alert("Faltan Datos");
			event.preventDefault();
		}
	}

	function verificarvacios(){
   	quitaFormatoControles('gridDetalle');
		var numDetalle = $('input[name=consecutivoID]').length;
		$('#detallePoliza').val("");

		for(var i = 1; i <= numDetalle; i++){
			controlQuitaFormatoMoneda("cargos"+i+"");
			controlQuitaFormatoMoneda("abonos"+i+"");

			var idcc = document.getElementById("centroCostoID"+i+"").value;
 			if (idcc ==""){
 				document.getElementById("centroCostoID"+i+"").focus();
				$(idcc).addClass("error");
 				return 1;
 				}
			var idcco = document.getElementById("cuentaCompleta"+i+"").value;
 			if (idcco ==""){
 				document.getElementById("cuentaCompleta"+i+"").focus();
				$(idcco).addClass("error");
 				return 1;
 			}
			var idr = document.getElementById("referencia"+i+"").value;
 			if (idr ==""){
 				document.getElementById("referencia"+i+"").focus();
				$(idr).addClass("error");
 				return 1;
 			}
			var idd = document.getElementById("descripcion"+i+"").value;
 			if (idd ==""){
 				document.getElementById("descripcion"+i+"").focus();
				$(idd).addClass("error");
 				return 1;
 			}
		}
	}
});


function limpiaForma(){

	 if(!generaPoliza ){
	$('#fecha').val(parametroBean.fechaSucursal);
	$('#conceptoID').val('');
	$('#concepto').val('');
	$('#desPlantilla').val('');

	$('#polizaID ').val('');
	$('#tipo').val('MANUAL');
	$('#gridDetalle').hide();
	 deshabilitaBoton('guardar', 'submit');
	 deshabilitaBoton('grabar', 'submit');
	 deshabilitaBoton('modificar', 'submit');
	 $('#imprimir').hide();

	 }else{

	 if(generaPoliza){


		$('#tipo').val('MANUAL');
		generaPoliza=false;
		agregaFormatoControles('formaGenerica');
	 	}
	 }

}


function listaCentroCostos(idControl){
	var jq = eval("'#" + idControl + "'");

	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = num;

		lista(idControl, '2', '1', camposLista, parametrosLista, 'listaCentroCostos.htm');
	});
}

function listaMaestroCuentas(idControl){
	var jq = eval("'#" + idControl + "'");

	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = num;
		if(num != '' && !isNaN(num)){
			listaAlfanumerica(this.id, '0', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
		else{
			listaAlfanumerica(this.id, '0', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});
}


function maestroCuentasDescripcion(idControl, fila){
	var jqCtaContable = eval("'#" + idControl + "'");
	setTimeout("$('#cajaLista').hide();", 200);
	var numero=idControl.substr(14,idControl.length);

		var numCtaContable = $(jqCtaContable).val();
		var desCuentaCompleta = eval("'#"+fila+"'");
		var conForanea = 2;
		var CtaContableBeanCon = {
		  'cuentaCompleta':numCtaContable
		};
		if(numCtaContable != '' && !isNaN(numCtaContable) ){
		cuentasContablesServicio.consulta(conForanea,CtaContableBeanCon,function(ctaConta){
			if(ctaConta!=null){
				if(ctaConta.grupo == "D"){
					$(desCuentaCompleta).val(ctaConta.descripcion);
				}
				else{
					alert("Solo Cuentas Contables Detalle");
					$(jqCtaContable).val("");
					$(desCuentaCompleta).val("");
					$(jqCtaContable).focus();
				}
			}else{
				alert("La Cuenta Contable No Existe");
				$(jqCtaContable).val("");
				$(desCuentaCompleta).val("");
				$(jqCtaContable).focus();

			}
			});
		}



}

function cargosS(fila){
	var jqCargos = eval("'#"+"cargos"+fila+"'");
	var cargo = $(jqCargos).val();
	//if(press){
		if(cargo > 0 && !isNaN(cargo) && esTab){
			$(jqCargos).select();
		}
		else
		{	$(jqCargos).select();
			$(jqCargos).val('');
		}
	//}
}

function sumaCifrasControlCargos(fila){
	var jqCargos;
	var suma;
	var contador = 1;
	var cargo;
	esTab=true;
	suma= 0;
	var jqAbonos = eval("'#"+"abonos"+fila+"'");
	var abono = $(jqAbonos).val();
	//if(press) {
		if(abono > 0 && !isNaN(abono) && esTab){
			$(jqAbonos).select();
		}
		else
		{	$(jqAbonos).select();
			$(jqAbonos).val('');
		}
	//}
  	$('input[name=cargos]').each(function() {
		jqCargos = eval("'#" + this.id + "'");
		cargo= $(jqCargos).asNumber();
		if(cargo != '' && !isNaN(cargo) && esTab){
			suma = suma + cargo;
			contador = contador + 1;
		}
		else {
			$(jqCargos).val(0);
		}
	});
	$('#ciCtrlCargos').val(suma);
	diferenciaCargosAbonos();
}

function sumaCifrasControlAbonos(fila){
	var suma;
	var contador = 1;
	var jqAbonos;
	var abono;
	esTab=true;

	suma= 0;
  	$('input[name=abonos]').each(function() {
		jqAbonos = eval("'#" + this.id + "'");
		abono = $(jqAbonos).asNumber();
		if(abono != '' && !isNaN(abono) && esTab){
			suma = suma + abono;
			contador = contador + 1;
		}
		else{
			$(jqAbonos).val(0);
		}
		if(abono = ''){
			$(jqAbonos).val(0);
		}
	});

	$('#ciCtrlAbonos').val(suma);
	diferenciaCargosAbonos();
}

function diferenciaCargosAbonos(){
	var sumaCargos;
	var sumaAbonos;
	var diferencia;
	controlQuitaFormatoMoneda('ciCtrlCargos');
	controlQuitaFormatoMoneda('ciCtrlAbonos');

	sumaCargos= $('#ciCtrlCargos').asNumber();
	sumaAbonos= $('#ciCtrlAbonos').asNumber();
	diferencia= 0;
  	if(sumaCargos>sumaAbonos){
  		diferencia= (sumaCargos-sumaAbonos).toFixed(2);
  		$('#diferencia').val(diferencia);
  	}
  	if(sumaCargos<sumaAbonos){
  		diferencia= (sumaAbonos-sumaCargos).toFixed(2);
  		$('#diferencia').val(diferencia);
  	}
  	if(sumaAbonos==sumaCargos){
  		diferencia= 0;
  		$('#diferencia').val(diferencia);
  	}

 	if($('#diferencia').asNumber() != 0){
		deshabilitaBoton('grabar', 'submit');
  	}
  	else{
  		if(($('#ciCtrlCargos').val()>0 || $('#ciCtrlAbonos').val()>0) && $('#plantillaID').val() != 0 && $('#diferencia').asNumber() == 0)
  		habilitaBoton('grabar', 'submit');
  	}
  	//habilitaBoton('grabar', 'submit');
  	actualizaFormatosMoneda('gridDetalle');
}

function consultaCentroCostos(numero) {
	var numcentroCosto= $('#centroCostoID'+numero).val();
	var conPrincipal =1;
	setTimeout("$('#cajaLista').hide();", 200);
		if(numcentroCosto != '' && !isNaN(numcentroCosto) && esTab ){
				var centroBeanCon = {
					'centroCostoID':numcentroCosto
			 };
			centroServicio.consulta(conPrincipal,centroBeanCon,function(centro) {
					if(centro==null){
						 alert("El Centro de Costo no Existe");
						 $('#centroCostoID'+numero).val('');
						 $('#centroCostoID'+numero).focus();
					}
				});
		}

	}


/* Cancela las teclas [ ] en el formulario*/
document.onkeypress = pulsarCorchete;
function pulsarCorchete(e) {
	tecla=(document.all) ? e.keyCode : e.which;
	if(tecla==91 || tecla==93){
		return false;
	}
	return true;
}

