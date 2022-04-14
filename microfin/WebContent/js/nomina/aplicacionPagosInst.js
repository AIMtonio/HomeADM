var existeCuenta = 0;
var montosIguales =0;
var nombreInstitNom ='';
var institNomID =0;
var verificaPagos='';
var tipoTrans=0;
var sumaTotal = 0;
var sumaTotal2 = 0;

var listaPersBloqBean = {
        'estaBloqueado' :'N',
        'coincidencia'  :0
};

var consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente           ='CTE';

$(document).ready(function() {
	var tipoTransaccion= {
			'pagar'    : '2',
			'cancelar' : '3',
		};
	var parametroBean = consultaParametrosSession();

esTab = true;
deshabilitaBoton('realizarPagos');
deshabilitaBoton('cancelarPagos');
deshabilitaBoton('importar');
deshabilitaBoton('verificaPagoBancos');
deshabilitaControl('seleccionaTodos');
$('#ligaGenerar').removeAttr("href");
$('#institNominaID').focus();

/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	agregaFormatoControles('formaGenerica');
	/*pone tap falso cuando toma el foco input text */
	$(':text').focus(function() {
	 	esTab = false;
	});

	/*pone tab en verdadero cuando se presiona tab */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			if($('#totalPagos').val()!=0 || $('#estatusPagoInst').val() == 'P'){
				if(validaMonto()==1){
			     tipoTrans= $('#tipoTransaccion').val();
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'institNominaID', 'funcionExito', 'funcionError');
			   }else{
			     mensajeSis("La Suma de los Pagos Seleccionados debe de ser Igual al Depósito en Bancos");
			  }
			}else{
				mensajeSis("Seleccione al Menos un Movimiento para Procesar.");
			}
    	}
      });

	$('#fechaInicio').val(parametroBean.fechaAplicacion);
	$('#fechaFin').val(parametroBean.fechaAplicacion);

	//Valida la fecha de inicio del reporte
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Inicio no Debe ser Mayor a la Fecha Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha Inicio no Debe ser Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
		regresarFoco('fechaInicio');
	});

	//Valida la fecha de fin del reporte
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Fin no Debe ser Menor a la Fecha Inicio.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha  Final  es Mayor a la Fecha del Sistema.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
		regresarFoco('fechaFin');
	});

	$('#institNominaID').bind('keyup',function(e){
		lista('institNominaID', '1', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function() {

		consultaInstitucionNomina(this.id);
		requiereVerificacion(this.id);
		ctrlDeshabilitaBtn();
		deshabilitaBoton('verificaPagoBancos');

		$('#montoPagos').val('');
		$('#totalPagos').val('');
		$('#gridPagosPendientes').html("");
		$('#ligaGenerar').removeAttr("href");
		$('#depositoBancos').hide();
		$('#lbldepositoBancos').hide();
		//$('#verificaPagoBancos').hide();
	});

// FUNCIONALIDAD PARA LISTA DE FOLIOS
	$('#numFolio').bind('keyup',function(e){
        var instNomina=$('#institNominaID').val();

        if(!isNaN(instNomina) ){
            var camposLista = new Array();
            var parametrosLista = new Array();
            camposLista[0] = "institNominaID";
            camposLista[1] = "fechaInicio";
            camposLista[2] = "fechaFin";
            parametrosLista[0] = instNomina;
            parametrosLista[1] = $('#fechaInicio').val();
            parametrosLista[2] = $('#fechaFin').val();
            lista('numFolio', '1', '3', camposLista, parametrosLista, 'aplicacionPagosInsLista.htm');
        }
	});

	$('#numFolio').blur(function() {
		//LLAMAR A LA FUNCION PARA CONSULTAR EL GRID
		consultaFolio();
	});

	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	$('#institucionID').blur(function() {
  		    if($('#institucionID').val()!=""){
  		    	consultaNombreBanco(this.id);
  		    }

 	});

	$('#fechaAplica').val(parametroBean.fechaAplicacion);

	$('#numCuenta').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();
		listaAlfanumerica('numCuenta', '0', '3', camposLista,parametrosLista, 'ctaNostroLista.htm');
	});

	$('#numCuenta').blur(function() {
		validaCtaNostroExiste('numCuenta','institucionID');
	});

	$('#movConciliado').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		camposLista[1] = "numCuenta";
		camposLista[2] = "institNominaID";
		parametrosLista[0] = $('#institucionID').val();
		parametrosLista[1] = $('#numCuenta').val();
		parametrosLista[2] = $('#institNominaID').val();
		lista('movConciliado', '1', '5', camposLista, parametrosLista, 'aplicacionPagosInsLista.htm');
	});

	$('#movConciliado').blur(function() {
		consultaMovConciliado();
	});

	/*asigna el tipo de transaccion */
	$('#realizarPagos').click(function() {
		var movConciVal = $('#movConciliado').val().replace(/ /g, "");
		var numCuentaVal = $('#numCuenta').val();
		if(movConciVal != '' && numCuentaVal != ''){
			validaMonto();
			$('#tipoTransaccion').val(tipoTransaccion.pagar);
		}else{
            $('movConciliado').focus();
            mensajeSis('Ingresar el Movimiento Conciliado ');

            return false;
        }

	});
	$('#cancelarPagos').click(function() {
		// montosIguales= 1;
		$('#tipoTransaccion').val(tipoTransaccion.cancelar);

	});

	$('#verificaPagoBancos').click(function() {

		listaComboMovsTeso();

	});

	$('#importar').click(function() {
		//llamada a función de creditos no aplicados
		consultaNoAplicados($('#numFolio').val());
	});

/* =============== VALIDACIONES DE LA FORMA ================= */
	$('#formaGenerica').validate({
		rules: {
			institNominaID :{
				required:true
				},
			numCuenta :{
				required:function() {return   $('#tipoTransaccion').val()!=tipoTransaccion.cancelar;}
				},
			motivoCancela : {
				required:function() {return   $('#tipoTransaccion').val()==tipoTransaccion.cancelar;},
				maxlength : 100
			},
			movConciliado :{
				required:function() {return   $('#tipoTransaccion').val()!=tipoTransaccion.cancelar;}
			}
		},
		messages: {
			institNominaID :{
				required:'Ingrese una Empresa de Nómina.'
			},
			numCuenta :{
				required:'Ingrese el Número de Cuenta.'
				},
			motivoCancela : {
				required : 'Ingrese un Motivo de Cancelación.',
				maxlength: 'Máximo 100 caracteres.'
			},
			movConciliado :{
				required:'Ingrese movimiento conciliado.'
			}
		}
	});


});// fin document.ready

/* =================== FUNCIONES ========================= */

//Funcion de consulta para obtener el nombre de la institucion bancaria
	function consultaNombreBanco(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoCon= 2;
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(tipoCon,InstitutoBeanCon,{ async: false, callback: function(instituto){
				if(instituto!=null){
					$('#nombreInstitucion').val(instituto.nombre);

				}else{
					mensajeSis("No Existe la Empresa ");
					$('#institucionID').val('');
					$('#institucionID').focus();
					$('#nombreInstitucion').val('');
				}
			}});
		}
	}

// Funcion que consulta el numero de cuenta de depósito de una Institucion de Nomina
 function consultaBancoCuenta(idControl) {
	var jqNombreInst = eval("'#" + idControl + "'");
	var institucionID = $(jqNombreInst).val();
	var tipoCon = 5;
	var institucionBean = {
			'institNominaID': institucionID
	};
	if(institucionID != '' && !isNaN(institucionID) && esTab){
	institucionNomServicio.consulta(tipoCon,institucionBean,{ async: false, callback: function(institNomina) {
		if(institNomina!= null){
			$('#institucionID').val(institNomina.institucionID);
			consultaNombreBanco('institucionID');
			$('#numCuenta').val(institNomina.cuentaDeposito);

			}
		else {
			mensajeSis("La Empresa No Cuenta con un Banco de Depósito");
			$('#institucionID').focus();
			$('#nombreInstitucion').val('');
			$('#institucionID').val('');
			$('#numCuenta').val('');
		}
		}});
	}
 }

// Consulta de Institucion de Nomina
 function consultaInstitucionNomina(idControl) {
	var jqNombreInst = eval("'#" + idControl + "'");
	var institucionID = $(jqNombreInst).val();
	var tipoConsulta = 1 ;
	var institucionBean = {
			'institNominaID': institucionID
	};
	if(institucionID != '' && !isNaN(institucionID) && esTab){
        limpiarFormaGrid();
	institucionNomServicio.consulta(tipoConsulta,institucionBean,{ async: false, callback: function(institNomina) {
		if(institNomina!= null){
			esTab=true;
			consultaBancoCuenta('institNominaID');
			$('#nombreEmpresa').val(institNomina.nombreInstit);
			institNomID= $('#institNominaID').val();
			nombreInstitNom=institNomina.nombreInstit;
			existeCuenta=1;

			}
		else {
			mensajeSis("La Empresa de Nómina No Existe");
			$('#institNominaID').focus();
			$('#institNominaID').val('');
			$('#nombreEmpresa').val('');
			limpiarFormaGrid();
		}
		}});
	 }
	$('#seleccionaTodos').attr('checked', false);
	deshabilitaControl('seleccionaTodos');
  }

// Consulta el monto del folio seleccionado
  function consultaMonto(idFolio){
		var tipoConsulta = 3 ;
		var institNomina=$('#institNominaID').val();
		var cargaPagosBean = {
				'folioCargaID' :  idFolio,
				'institNominaID': institNomina
		};

		bitacoraPagoNominaServicio.consulta(tipoConsulta,cargaPagosBean,{ async: false, callback: function(monto) {
			if(monto!= null){
				$('#montoPagos').val(monto.montoPagos);
				$('#montoPagos').formatCurrency({ //es para regresar el formato moneda
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				  });

				}
			}});
	}

//Consulta para el grid de pagos de institucion
	function consultaFoliosInstitucion(idFolio){
		var institNomina=$('#institNominaID').val();
		var params = {};
		params['numFolio'] = idFolio;
		params['institNominaID'] = institNomina;
		params['tipoLista'] = 1;
        var EstFolio = $('#estatusPagoInst').val();
		$.post("aplicaPagosInstGrid.htm", params, function(data){
            desbloquearPantalla();
				if(data.length >0) {
					$('#gridDescuento').html(data);
					$('#gridDescuento').show();
					agregaMonedaFormat();
					if(EstFolio == 'A'){
                        habilitaControl('seleccionaTodos');
                    }else{
                        $("input[name='listaEsSeleccionado']").each(function(){
                            var jqControl = eval("'seleccionaCheck"+this.id.substr(14,this.id.length)+"'");
                            $("#"+jqControl).attr('checked', true);
                            deshabilitaControl(jqControl);

                        });
                        $('#seleccionaTodos').attr('checked', true);
						deshabilitaControl('seleccionaTodos');
						consultaMontoApli();
                    }
                    valRegGridDescuentos();
				}else{
					$('#gridDescuento').html("");
					$('#gridDescuento').show();
					$('#seleccionaTodos').attr('checked', false);
					deshabilitaControl('seleccionaTodos');
				}
		});

	}

	function consultaFolio(){
		var tipoConsulta = 1 ;
		var institNom=$('#institNominaID').val();
		var numFolio=$('#numFolio').val();
		var cargaPagosBean = {
				'folioNum' :  numFolio,
				'institNominaID': institNom
		};


        if(!isNaN(institNom) && !isNaN(numFolio) && esTab){
            limpiaGrid();
            $('#totalPagos').val(0);
            $('#totalAcumulado').val(0);
            totalAcumulado = 0;
            montoOperacion = 0;
            sumaTotal = 0;
            sumaTotal2 = 0;
            aplicaPagoInstServicio.consulta(tipoConsulta,cargaPagosBean,{ async: false, callback: function(datos) {

                if(datos!= null){
                    $('#fechaDescuento').val(datos.fechaDescuento);
                    $('#montoTotalDesc').val(datos.montoPagos);
                    $('#montoTotalDesc').formatCurrency({ //es para regresar el formato moneda
                        positiveFormat: '%n',
                        roundToDecimalPlace: 2
                    });
					// Estatus de Aplicacion de Pago de Instuticion
                    if (datos.estatusPagoInst == 'A') {// Activo
						$('#estatusPagoInstText').val('PENDIENTE');
						$('#estatusPagoInst').val('A');
                    }else if (datos.estatusPagoInst == 'P'){ // Procesado
						$('#estatusPagoInstText').val('APLICADO');
						$('#estatusPagoInst').val('P');
                    }
					// Estatus de Aplicacion de Pago de Descuento
                    if (datos.estatusPagoDesc == 'P') {// Procesado
						$('#estatusPagoDescText').val('APLICADO');
                        $('#estatusPagoDesc').val('P');
                    }else if (datos.estatusPagoDesc == 'N'){// No Procesado
						$('#estatusPagoDescText').val('PENDIENTE');
                        $('#estatusPagoDesc').val('N');
                    }


                    limpiaSesion(
                    	function(){
                    		//llamada a función para cargar el grid
                    		consultaFoliosInstitucion(numFolio);
                    	}
                    );

                    controlBotones(datos.estatusPagoInst);

                }else{
                    mensajeSis('Folio ' + numFolio + ' No Aplicado el Pago de Descuento o No Existe el Folio');
                    ctrlDeshabilitaBtn();

                    $('#numFolio').focus();
                    $('#estatusPagoDescText').val('');
                    $('#estatusPagoInstText').val('');
                    limpiarFormaGrid();
                   setTimeout(function(){esTab=true; consultaNom()},1000);
                }
			}});
        }
	}

	function consultaMovConciliado(){
		var tipoConsulta = 5 ;
		var institNum=$('#institucionID').val();
		var numMov=$('#movConciliado').val();
		var cargaPagosBean = {
				'folioNum' : numMov,
				'institNominaID': institNum
		};

		if (numMov != '' && numMov != 0) {
			aplicaPagoInstServicio.consulta(tipoConsulta,cargaPagosBean,{ async: false, callback: function(datos) {
				if(datos!= null){
					$('#fechaPagoInst').val(datos.fechaDescuento);
					$('#montoPagoInst').val(datos.montoPagos);
					$('#montoPagoInst').formatCurrency({ //es para regresar el formato moneda
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});
				}
			}});
		}
	}

//Función para sumar los montos de los folios seleccionados
    function sumaCheck(idControl, consecutivoID){
        var jqControl = eval("'#"+idControl+"'");
		var jvalControl = idControl.substr(15,idControl.length);
		var controlCheck = eval("'#seleccionaCheck"+jvalControl+"'");
		var esSeleccionado = "";
        var tipoCheck = "I";
        var tipoLista = "pagoInstitucion";
		if($(controlCheck).is(":checked")){
			esSeleccionado = "S";
		}else{
			esSeleccionado = "N";
		}
		validaCredito('creditoID'+consecutivoID,idControl);
		if(listaPersBloqBean.estaBloqueado  == 'N' || consultaSPL.permiteOperacion == 'S' ){
			validaMontos(esSeleccionado, consecutivoID, tipoLista, tipoCheck);
		}

    }
  //Función para sumar los montos de los folios seleccionados
	function sumaCheck2(idControl, consecutivoID){
		var jqControl = eval("'#"+idControl+"'");
		var jvalControl = idControl.substr(16,idControl.length);
		var controlCheck = eval("'#seleccionaCheck"+jvalControl+"'");
		var esSeleccionado = "";
        var tipoCheck = "I";
        var tipoLista = "pagoNoAplicados";
		if($(controlCheck).is(":checked")){
			esSeleccionado = "S";
		}else{
			esSeleccionado = "N";
		}
		validaCredito('creditoID'+consecutivoID,idControl);
		if(listaPersBloqBean.estaBloqueado  == 'N' || consultaSPL.permiteOperacion == 'S'){
			validaMontos(esSeleccionado, consecutivoID, tipoLista, tipoCheck);
		}

	}

	 //Función para limpiar las listas de la sesion
	function limpiaSesion(callback){

		var params = {};
		params['seleccionado'] = '';
		params['consecutivo'] = 0;
		params['tipoLista'] = 'Inicializar';
        params['tipoCheck'] = '';
		bloquearPantalla();

		$.post("aplicaPagoInstVistaTotales.htm",params,	function(datosResponse) {
			callback();
		});


	}

    function validaMontos(esSeleccionado, idConsecutivo, tipoLista, tipoCheck){
        var params = {};
		params['seleccionado'] = esSeleccionado;
		params['consecutivo'] = idConsecutivo;
		params['tipoLista'] = tipoLista;
        params['tipoCheck'] = tipoCheck;

		bloquearPantalla();
		$.post("aplicaPagoInstVistaTotales.htm",params,function(datosResponse) {
			desbloquearPantalla();
			if (datosResponse != null) {
                $('#totalPagos').val(datosResponse.totalSumatoria);
                $('#totalGridPagos').val(datosResponse.totalAplicaPago);
				$('#totalGridNoaplicados').val(datosResponse.totalNoAplicados);

				$('#totalPagos').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});

		  		$('#totalGridPagos').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});

				$('#totalGridNoaplicados').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});

				// Si seleccionaron el Check de Todos en Registros del Folio
                if(datosResponse.checkPagosTodos == 'S'){
                	$('#seleccionaTodos').attr('checked',true);
                	$('#aplicaTodos').val('S');
                }else{
                	$('#seleccionaTodos').attr('checked',false);
                	$('#aplicaTodos').val('N');
                }

                // Si seleccionaron el Check de Todos en Folios Importados
                if(datosResponse.checkImportadosTodos =='S'){
                	$('#seleccionaTodos2').attr('checked',true);
                }else{
                	$('#seleccionaTodos2').attr('checked',false);
                }

			} else {
				mensajeSis("Error en sumatoria de montos de Grid.");
			}
		});
    }
  // Funcion para validar si la cuenta registrada o proporcionada por la Institucion de Nomina existe
  function validaCtaNostroExiste(numCta,institID){
	  	var tipoCon = 4;
		var jqNumCtaInstit = eval("'#" + numCta + "'");
		var jqInstitucionID = eval("'#" + institID + "'");
		var numCtaInstit = $(jqNumCtaInstit).val();
		var institucionID = $(jqInstitucionID).val();
		var CtaNostroBeanCon = {
				'institucionID':institucionID,
				'numCtaInstit':numCtaInstit
		};

		setTimeout("$('#cajaLista').hide();", 200);
	if(numCtaInstit != '' && !isNaN(numCtaInstit) && institucionID != '' && !isNaN(institucionID) ){

			cuentaNostroServicio.consultaExisteCta(tipoCon,CtaNostroBeanCon, { async: false, callback: function(ctaNostro){
				if(ctaNostro!=null){
					existeCuenta =1;
					$('#centroCostoID').val(ctaNostro.centroCostoID);
					//	listaComboMovsTeso();
				}else{
					mensajeSis('La Cuenta Depósito No Existe');
					$('#numCuenta').val('');
					$('#numCuenta').focus();
				}
			}});
	}
	return existeCuenta;
  }
 // Funcion para consultar si la empresa requiere verificacion de los pagos en Bancos
  function requiereVerificacion(idControl) {
     var jqNombreInst = eval("'#" + idControl + "'");
     var institucionNomID = $(jqNombreInst).val();
     var tipoConsulta= 1;
     var institucionBean = {
		'institNominaID':institucionNomID
		};

    institucionNomServicio.consulta(tipoConsulta,institucionBean,{ async: false, callback: function(datos) {
    	if(datos != null){
    		verificaPagos=datos.reqVerificacion;
			if(verificaPagos == 'S'){
				$('#verificaPagoBancos').show();
				 validaCtaNostroExiste('numCuenta','institucionID');
		    }else{
		      if(verificaPagos == 'N'){
		      $('#verificaPagoBancos').hide();

		      }

		    }
	 }else{
	      $('#verificaPagoBancos').hide();
	    }
    }});
  }
//lista el combo los movimientos que coincidan con las Institucion de Nomina y no esten conciliados
  function listaComboMovsTeso() {
	  if(existeCuenta == 1){
 		var tipoLis= 2;
 		var institNomina=$('#institNominaID').val();
 		var bancoID = $('#institucionID').val();
 		var numCta  = $('#numCuenta').val();

 		var pagosNomBean = {
 				'institucionID' : bancoID,
 				'numCuenta': numCta,
 				'institNominaID': institNomina
 		};
 		dwr.util.removeAllOptions('depositoBancos');
 		dwr.util.addOptions('depositoBancos', {'0':'SELECCIONA'});

 		pagoNominaServicio.listaCombo(tipoLis ,pagosNomBean, { async: false, callback: function(movs){
		  if(movs != ''){
		    $('#depositoBancos').show();
		    $('#lbldepositoBancos').show();
		   dwr.util.addOptions('depositoBancos',movs, 'folioCargaTeso','depositoBancos');
		  }else{
		    $('#depositoBancos').hide();
		    $('#lbldepositoBancos').hide();
		    mensajeSis('No se Localizó Depósito en Bancos');
		    deshabilitaBoton('realizarPagos');

		  }

		}});
	  }
 	}

 // validar que el monto a aplicar sea el mismo que el registrado en Tesoreria
 function validaMonto(){
    var totalPago   = $('#totalPagos').val();
    var totalMovTeso = $('#depositoBancos option:selected').text();
    montosIguales=0;

    if(totalPago == totalMovTeso){
	 montosIguales = 1;
      }else{
    	  if(verificaPagos=='N' || $('#tipoTransaccion').val() == '3'){
    		  montosIguales=1;
    	  }
      }
      return montosIguales;
  }

 function agregaMonedaFormat(){
	 $('input[name=listaMontoPagos]').each(function() {
			numero= this.id.substr(10,this.id.length);
			varCapitalID = eval("'#montoPagos"+numero+"'");
			$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		});

 }

 function funcionExito(){
	      if(tipoTrans==2){
	      	limpiarFormaGrid();
      }
      if(tipoTrans == 3){
    	  $('#totalPagos').val('');
    	  $('#motivoCancela').val('');
    	  deshabilitaBoton('realizarPagos');
  		  deshabilitaBoton('cancelarPagos');
  		  deshabilitaBoton('verificaPagoBancos');
  		  limpiarFormaGrid();

      }else{
		$('#nombreEmpresa').val('');
		$('#montoPagos').val('');
		$('#numCuenta').val('');
		$('#totalPagos').val('');
		$('#motivoCancela').val('');
		$('#institucionID').val('');
		$('#nombreInstitucion').val('');

		$('#verificaPagoBancos').hide();


		deshabilitaBoton('realizarPagos');
		deshabilitaBoton('cancelarPagos');
		limpiarFormaGrid();
      }
      montosIguales=0;
	}
  function funcionError(){
	  agregaFormatoControles('formaGenerica');
	}


  function seleccionarTodos(){
  		bloquearPantalla();
		var controlCheck = eval("'#seleccionaTodos'");
		var esSeleccionado = "";
        var tipoCheck = "T";
        var tipoLista = "pagoInstitucion";
        var consecutivoID = 0;
        var estCheck = "";
		if($(controlCheck).is(":checked")){
			esSeleccionado = "S";
            estCheck = true;
		}else{
			esSeleccionado = "N";
            estCheck = false;
		}

        $("input[name='seleccionaCheck']").each(function(){
            $(this).attr('checked', estCheck);
            var consecutivoID = this.id.substr(15,this.id.length);
            validaCredito('creditoID'+consecutivoID,this.id);
        });

		if(listaPersBloqBean.estaBloqueado  == 'N' || consultaSPL.permiteOperacion == 'S'){
			validaMontos(esSeleccionado, consecutivoID, tipoLista, tipoCheck);
		}
}


function consultaGridTodos() {
	var lista = 1;

	var params = {};
	params['numFolio'] = $('#numFolio').val();
	params['tipoLista'] = lista;
	params['page'] = 'check';
	params['institNominaID']	=	$('#institNominaID').val();

	var listaEsSeleccionado = '';
	$("input[name='listaEsSeleccionado']").each(function(){
				listaEsSeleccionado = listaEsSeleccionado+$(this).val()+",";
	});

	var listaConsecutivoID = '';
	$("input[name='listaConsecutivoID']").each(function(){
				listaConsecutivoID = listaConsecutivoID+$(this).val()+",";
	});

	params['listaConsecutivoID'] = listaConsecutivoID;
	params['listaEsSeleccionado'] = listaEsSeleccionado;


	$('#gridDescuento').show();
	bloquearPantalla();
	$.post("aplicaPagosInstGrid.htm", params, function(data) {
        desbloquearPantalla();
		if (data.length > 0) {
			$('#gridDescuento').html(data);
			$('#gridDescuento').show();
			agregaMonedaFormat();
			habilitaControl('seleccionaTodos');
		} else {
			$('#gridDescuento').html("");
			$('#gridDescuento').show();
			$('#seleccionaTodos').attr('checked', false);
			deshabilitaControl('seleccionaTodos');
		}
	});

}

function consultaGridTodosNoAplicados(pagina) {
	var lista = 1;

	var params = {};
	params['numFolio'] = $('#numFolio').val();
	params['tipoLista'] = lista;
	params['page'] = pagina;
	params['institNominaID']	=	$('#institNominaID').val();

	var listaEsSeleccionado = '';
	$("input[name='listaEsSeleccionado2']").each(function(){
				listaEsSeleccionado = listaEsSeleccionado+$(this).val()+",";
	});

	var listaConsecutivoID = '';
	$("input[name='listaConsecutivoID2']").each(function(){
				listaConsecutivoID = listaConsecutivoID+$(this).val()+",";
	});

	params['listaConsecutivoID2'] = listaConsecutivoID;
	params['listaEsSeleccionado2'] = listaEsSeleccionado;


	$('#gridNoAplicados').show();
	bloquearPantalla();
	$.post("aplicaPagosInstGrid.htm", params, function(data) {
        desbloquearPantalla();
		if (data.length > 0) {
			$('#gridNoAplicados').html(data);
			$('#gridNoAplicados').show();
			agregaMonedaFormat();
			habilitaControl('seleccionaTodos');
		} else {
			$('#gridNoAplicados').html("");
			$('#gridNoAplicados').show();
			$('#seleccionaTodos2').attr('checked', false);
			deshabilitaControl('seleccionaTodos2');
		}
	});

}

  function seleccionarTodosDos(){
  	bloquearPantalla();
   var controlCheck = eval("'#seleccionaTodos2'");
    var esSeleccionado = "";
    var tipoCheck = "T";
    var tipoLista = "pagoNoAplicados";
    var consecutivoID = 0;
    var estCheck = "";
    if($(controlCheck).is(":checked")){
        esSeleccionado = "S";
        estCheck = true;
    }else{
        esSeleccionado = "N";
        estCheck = false;
    }

    $("input[name='seleccionaCheck2']").each(function(){
    	$(this).attr('checked', estCheck);
    	var consecutivoID = this.id.substr(16,this.id.length);
        validaCredito('creditoID'+consecutivoID,this.id);     
    });

    if(listaPersBloqBean.estaBloqueado  == 'N' || consultaSPL.permiteOperacion == 'S'){
    	validaMontos(esSeleccionado, consecutivoID, tipoLista, tipoCheck);
    }
}

function verificarMonto(){
    var controlCheck = eval("'#seleccionaTodos2'");
    var esSeleccionado = "";
    var tipoCheck = "";
    var tipoLista = "sumaTotal";
    var consecutivoID = 0;

    validaMontos(esSeleccionado, consecutivoID, tipoLista, tipoCheck);
}

// VALIDACIONES PARA CAMPOS DE FECHA
function mayor(fecha, fecha2){
	var xMes=fecha.substring(5, 7);
	var xDia=fecha.substring(8, 10);
	var xAnio=fecha.substring(0,4);

	var yMes=fecha2.substring(5, 7);
	var yDia=fecha2.substring(8, 10);
	var yAnio=fecha2.substring(0,4);

	if (xAnio > yAnio){
	      return true;
	 }else{
	  if (xAnio == yAnio){
	    if (xMes > yMes){
		return true;
		}
	      if (xMes == yMes){
		if (xDia > yDia){
		    return true;
		  }else{
		   return false;
		}
	      }else{
		return false;
		}
	     }else{
		return false ;
		}
	   }
   }

  /*funcion valida fecha formato (yyyy-MM-dd)*/
 function esFechaValida(fecha){

	if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha Introducida Errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Introducida Errónea");
				return false;
			}
			return true;
		}
   }


 function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}else {
			return false;
		}
   }


 function regresarFoco(idControl){

		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
		 },0);
	}

//Consulta para el grid de pagos de institucion
	function consultaNoAplicados(idFolio){
		var institNomina=$('#institNominaID').val();
		var params = {};
		params['numFolio'] = idFolio;
		params['institNominaID'] = institNomina;
		params['tipoLista'] = 4;
		bloquearPantalla();
		$.post("crediNoAplicadosGrid.htm", params, function(data){
            desbloquearPantalla();
				if(data.length >0) {
					$('#gridNoAplicados').html(data);
					$('#gridNoAplicados').show();
					agregaMonedaFormat();
					habilitaControl('seleccionaTodos2');
                    verificarMonto();
                    valRegGridNoAplicados();
				}else{
					$('#gridNoAplicados').html("");
					$('#gridNoAplicados').show();
					$('#seleccionaTodos2').attr('checked', false);
					deshabilitaControl('seleccionaTodos2');
				}
		});

	}

// funcion para habilitar los Botones
function controlBotones(estatus){
    if(estatus == 'A'){
        habilitaBoton('realizarPagos');
        habilitaBoton('importar');
        deshabilitaBoton('cancelarPagos');
    }else if(estatus == 'P'){
        habilitaBoton('cancelarPagos');
        deshabilitaBoton('importar');
        deshabilitaBoton('realizarPagos');
    }
}

// funcion para des habilitar los Botones
function ctrlDeshabilitaBtn(){
    deshabilitaBoton('cancelarPagos');
    deshabilitaBoton('importar');
    deshabilitaBoton('realizarPagos');
}

// funcion para contar el numero de Registros del Grid
function valRegGridDescuentos(){
    var contador = 0;
    var estFolio = $('#estatusPagoInst').val();
    $('input[name=seleccionaCheck]').each(function() {
				contador = contador + 1;
			});

    if(contador == 0){
        $('#gridDescuento').html('');
        $('#gridDescuento').hide();
        $('#numFolio').focus();
        limpiaGrid();

            ctrlDeshabilitaBtn();

        mensajeSis('No hay Registros a visualizar');
    }else{
        if(estFolio == 'A'){
             controlBotones(estFolio);
        }

    }


}

// funcion para contar el numero de Registros del Grid
function valRegGridNoAplicados(){
    var contador = 0;
    $('input[name=seleccionaCheck2]').each(function() {
				contador = contador + 1;
			});

    if(contador == 0){
        $('#gridNoAplicados').html('');
        $('#gridNoAplicados').hide();
        deshabilitaBoton('importar');
        mensajeSis('No hay Registros a visualizar');
    }
}

// funcion limpia los 2 Grid
function limpiaGrid(){
    $('#gridDescuento').html("");
	$('#gridNoAplicados').html("");
    $('#gridDescuento').hide();
	$('#gridNoAplicados').hide();
}

//funcion que consulta el Monto Aplicado de Inst del Folio
function consultaMontoApli(){
	var tipoConsulta = 9 ;
	var folioNum=$('#numFolio').val();
	var cargaPagosBean = {
			'folioNum' : folioNum
	};

	if (folioNum != '' && folioNum != 0) {
		aplicaPagoInstServicio.consulta(tipoConsulta,cargaPagosBean,{ async: false, callback: function(datos) {
			if(datos!= null){
				$('#totalPagos').val(datos.montoPagoInst);
				$('#totalPagos').formatCurrency({ //es para regresar el formato moneda
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				});
			}
		}});
	}
}
function consultaNom(){
    consultaInstitucionNomina('institNominaID');
		requiereVerificacion('institNominaID');
		ctrlDeshabilitaBtn();
		deshabilitaBoton('verificaPagoBancos');

		$('#montoPagos').val('');
		$('#totalPagos').val('');
		$('#gridPagosPendientes').html("");
		$('#ligaGenerar').removeAttr("href");
		$('#depositoBancos').hide();
		$('#lbldepositoBancos').hide();
}
// función limpia formuario
function limpiarFormaGrid(){
	$('#gridDescuento').html("");
	$('#gridNoAplicados').html("");

	$('#numFolio').val('');
	$('#fechaDescuento').val('');
	$('#montoTotalDesc').val('');
	$('#estatusPagoDesc').val('');
	$('#estatusPagoInst').val('');
	$('#nombreInstitucion').val('');
	$('#numCuenta').val('');
	$('#movConciliado').val('');
	$('#montoPagoInst').val('');
	$('#fechaPagoInst').val('');
    $('estatusPagoDescText').val('');
	$('estatusPagoInstText').val('');

	deshabilitaBoton('importar');
}


function validaCredito(idControl,idCheck){
	var jqCredito = eval("'#"+idControl+"'"); 
	var jqCheck = eval("'#"+idCheck+"'");
	
	var numCredito = $(jqCredito).val();
	
	 var creditoBeanCon = {
             'creditoID' : numCredito
     };
     creditosServicio.consulta(1,creditoBeanCon, { async: false, callback: function(credito) {
         if (credito != null) {
        	 listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
				consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);
				if(listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'N'){
					$(jqCheck).attr('checked',false);
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				}
         }
     }
     });
}