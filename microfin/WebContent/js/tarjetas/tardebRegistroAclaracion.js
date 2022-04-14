$(document).ready(function() {	
	var parametroBean = consultaParametrosSession();
	esTab = true;
	var numLis, tipo;
	
	var catTipoTransaccionAclaracion = {
			'agrega'		: '1',
			'modifica'	: '2'
	};
	var catConAclaracion ={
		'principal' : 1,
		'conCredito': 5
	};
	var catTipoConsultaInstituciones = {
			'principal':1,
			'foranea':2
	};
	var catTipoConAsociaTC = {
	  		'principal'		:1,
	  		'tarjetaCta'	:13
	};
	var catEstatusAclaracion ={
			'alta'     	    :'A',
			'seguimiento'   :'S',
			'resuelta'      :'R'
	};
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	agregaFormatoControles('formaGenerica');
	$('#detalleArchivos').hide();
	$('#gridAdjuntos').hide();
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('adjuntar', 'submit');
	deshabilitaBoton('pdf', 'submit'); 
	$('#tipoTarjetaD').focus();	
	consultaParametros();
	consultaTipoReporte();

	$.validator.setDefaults({
	      submitHandler: function(event) {
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','reporteID', 
	    			  'funcionExito','funcionError');
	      }
	});
	
	$('#reporteID').blur(function(){
		if($('#tipoTarjetaD').attr("checked") == true && $('#tipoTarjetaC').attr("checked") == false){
			validaAclaracion(this.id);
			consultaArchiAclaracion();
		}else if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == true){
			validaAclaracionCre(this.id);
			consultaArchiAclaracion();
		}		
	});
			
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	
	$('#institucionID').blur(function(){
		consultaInstitucion(this.id);		
	});
	
	$('#agrega').click(function() {
		$('#detalleArchivos').hide();
		deshabilitaBoton('adjuntar', 'submit');
		deshabilitaBoton('pdf', 'submit');
		$('#tipoTransaccion').val(catTipoTransaccionAclaracion.agrega);
		creaArchivosAclara();
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionAclaracion.modifica);
		creaArchivosAclara();
	});

	$('#tipoTarjetaD').click(function() {
		limpiarFormulario();
		$('#reporteID').val('');
		$('#gridAdjuntos').hide();
		$('#reporteID').focus();
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modifica', 'submit');
		$('#tipoTarjetaC').attr("checked",false);
	});

	$('#tipoTarjetaC').click(function() {
		limpiarFormulario();
		$('#reporteID').val('');
		$('#gridAdjuntos').hide();
		$('#reporteID').focus();
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modifica', 'submit');
		$('#tipoTarjetaD').attr("checked",false);
	});

	$('#fechaOperacion').change(function() {
		$('#fechaOperacion').focus();
	});
	$('#fechaOperacion').blur(function() {
		if($('#tipoTarjetaD').attr("checked") == true && $('#tipoTarjetaC').attr("checked") == false){
			consultaTransaccion('');
		}else if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == true){
			consultaTransaccionCred('');
		}
	});
	$('#tipoReporte').change(function() {
		if($('#tipoTarjetaD').attr("checked") == true && $('#tipoTarjetaC').attr("checked") == false){
			numLis = 1;
			consultaOperaAclara('',numLis);
		}else if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == true){
			numLis = 2;
			consultaOperaAclara('',numLis);
		}	
	});
	$('#montoOperacion').blur(function() {
		verificaMonto(this.id);
	});
	$('#tarjetaDebID').blur(function() {

		if($('#tipoTarjetaD').attr("checked") == true && $('#tipoTarjetaC').attr("checked") == false){
			consultaTarCte(this.id);	
		}else if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == true){
			consultaTarCreCte(this.id);	
		}	
		
	});
	
	$('#adjuntar').click(function() {
		subirArchivos();
	});
	
	$('#pdf').click(function() {
		var numTr = ($('#tablaArchivos >tbody >tr').length ) -1;
		if(numTr != 0){
			var reporteID = $('#reporteID').val();
			var nombre=$('#nombre').val();
			var fechaEmision = parametroBean.fechaSucursal;
			var usuario = 	parametroBean.numeroUsuario;
			var nombreUsuario = parametroBean.claveUsuario;
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			$('#enlaceAclaracion').attr('href','aclaracionArchivoPDF.htm?reporteID='+reporteID
				+'&nombre='+nombre+'&nombreUsuario='+nombreUsuario.toUpperCase()+'&usuario='+usuario+
				'&fechaEmision='+fechaEmision+'&nombreInstitucion='+nombreInstitucion);
		}else {
			alert("No Existen Documentos Adjuntos");
		}
	});
	
	$('#tarjetaDebID').bind('keyup',function(e) {
		if($('#tipoTarjetaD').attr("checked") == true && $('#tipoTarjetaC').attr("checked") == false){
			lista('tarjetaDebID', '2', '5', 'tarjetaDebID', $('#tarjetaDebID').val(), 'tarjetasDevitoLista.htm');
		}else if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == true){
			lista('tarjetaDebID', '1', '5', 'tarjetaDebID',  $('#tarjetaDebID').val(),'tarjetasCreditoLista.htm');
		}
	});
	
	$('#reporteID').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		if($('#tipoTarjetaD').attr("checked") == true && $('#tipoTarjetaC').attr("checked") == false){
			camposLista[0] = "reporteID";
			camposLista[1] = "tipoTarjeta";
			parametrosLista[0] = $('#reporteID').val();
			parametrosLista[1] = 'D';
			lista('reporteID', '3', '1',camposLista,parametrosLista , 'aclaraTarjListaVista.htm');
		}else if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == true){
			camposLista[0] = "reporteID";
			camposLista[1] = "tipoTarjeta";
			parametrosLista[0] = $('#reporteID').val();
			parametrosLista[1] = 'C';
			lista('reporteID', '3', '1',camposLista,parametrosLista, 'aclaraTarjListaVista.htm');
		}
	});
	
	// ------------ Validaciones de la Forma	
	$('#formaGenerica').validate({
		rules : {
			tipoReporte: {
				required: true,
			},
			reporteID: {
				number: true,
				required: true,
			},
			tarjetaDebID: {
				required : true,
				minlength :16,
				maxlength: 16
			},
			institucionID: {
  				required: true,
  				number: true
  			},
  			operacionID:{
  				required: true
  			},
  			tienda:{
				  required:function() { return $('#tipoReporte').val() == 1; }
			},
			cajeroID:{
				  required:function() { return $('#tipoReporte').val() == 2; }				  
			},
  			montoOperacion: {
				required: true,
				number: true,
			},  			
			fechaOperacion: {
				required : true
			},
			noAutorizacion:{
				required : true
			},
			detalleReporte: {
				required: true
			}
		},
		messages : {
			tipoReporte: {
				required: "Especificar el Tipo de Reporte"
			},
			reporteID: {
				number: 'Sólo números',
				required: 'Especificar el Número de Reporte.',				
			},
			tarjetaDebID: {
				required : 'Especificar el Número de Tarjeta',
				minlength : 'Mínimo 16 caracteres',
				maxlength: 'Máximo 16 caracteres'
			},
			institucionID: {
				required: 'Especificar el Número de Institución',
				number: 'Sólo Números'
  			},
  			operacionID:{
  				required: 'Especificar el Tipo de Operación'
  			},
  			tienda:{
				required :'Especificar la Tienda o Comercio'
			},
			cajeroID:{
				required :'Especificar el Cajero'
			},
  			montoOperacion: {
				required: 'Especificar el Monto de la Operación',
				number: 'Sólo Números',
			},
			fechaOperacion: {
				required : 'Especificar la Fecha de Operación'
			},
			noAutorizacion:{
				required : 'Especificar el Número de Autorización'
			},
			detalleReporte: {
				required: 'Especificar el Detalle del Reporte'
			}
		}
	});
			
	function consultaTipoReporte() {
		dwr.util.removeAllOptions('tipoReporte');
		dwr.util.addOptions('tipoReporte', {'':'SELECCIONA'});
		var nombre = {
				'tipoAclaracionID' :'0',
				'descripcion'	:''
		};
		tipoAclaracionServicio.lista(2, nombre,function(reporte){
			dwr.util.addOptions('tipoReporte', reporte, 'tipoAclaracionID', 'descripcion');
		});
	}

	function mostrarDias(){
		var fechaInicio = $('#fechaOperacion').val();
		var fechaFin = parametroBean.fechaSucursal;
		var diaInicio=fechaInicio.substring(8,10);
		var mesInicio=fechaInicio.substring(5,7);
		var anoInicio=fechaInicio.substring(0,4);
		var diaFin=fechaFin.substring(8,10);
		var mesFin=fechaFin.substring(5,7);
		var anoFin=fechaFin.substring(0,4);
		var f1 =  new Date(anoInicio,mesInicio,diaInicio);
		var f2 =  new Date(anoFin,mesFin,diaFin);
		var difDias = Math.floor((f2.getTime()-f1.getTime()) / (1000 * 60 * 60 * 24))+1;
		return difDias;
	}
	
	// ------------ Validaciones de Controles-------------------------------------
	function validaAclaracion(idControl){
		var jqTipoAcla  = eval("'#" + idControl + "'");
		var numTipoAcla = $(jqTipoAcla).val();
		if(numTipoAcla != '' && !isNaN(numTipoAcla) ){
			tipo = 'D';
			numLis = 1;
			var tipoAclaraBeanCon = { 
				'reporteID' : numTipoAcla,
				'tipoTarjeta': tipo
			};			
			if(numTipoAcla == '0'){ 
				$('#gridAdjuntos').hide();
				limpiarFormulario();
				$('#estatus').val("ALTA");
				habilitaControl('tarjetaDebID');
				$('#tipoReporte').focus();
				habilitaBoton('agrega', 'submit');	
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('adjuntar', 'submit');
				deshabilitaBoton('pdf', 'submit');
			}else{
				habilitaBoton('modifica', 'submit');
				habilitaBoton('agrega', 'submit');
				$('#estatus').val('');
				aclaracionServicio.consulta(catConAclaracion.principal, tipoAclaraBeanCon, function(aclaracionBean) {
					if(aclaracionBean != null){
						$('#tipoReporte').val(aclaracionBean.tipoReporte);
						$('#reporteID').val(aclaracionBean.reporteID);
						$('#tarjetaDebID').val(aclaracionBean.tarjetaDebID);
						deshabilitaControl('tarjetaDebID');
						$('#tipoTarjetaDebID').val(aclaracionBean.tipoTarjetaID);
						$('#nombreTarjeta').val(aclaracionBean.tipoTarjeta);
						$('#cuentaAho').show();
						$('#producto').hide();
						$('#clienteID').val(aclaracionBean.clienteID);
						$('#nombre').val(aclaracionBean.nombre);
						$('#numCuenta').val(aclaracionBean.numCuenta);
						$('#descCuenta').val(aclaracionBean.tipoCuenta);
						$('#corporativoID').val(aclaracionBean.corporativoID);
						$('#corporativo').val(aclaracionBean.nombreCorp);
						if (aclaracionBean.corporativoID == 0 || aclaracionBean.corporativoID == '' || aclaracionBean.corporativoID == null) {
							$('#cteCorpTr').hide();
							$('#corporativoID').val('');
							$('#corporativo').val('');
						}else {
							$('#cteCorpTr').show();
							$('#corporativoID').val(aclaracionBean.corporativoID);
							$('#corporativo').val(aclaracionBean.nombreCorp);	
						}
						$('#institucionID').val(aclaracionBean.institucionID);
						consultaInstitucion('institucionID');
						consultaOperaAclara(aclaracionBean.operacionID,numLis);	
						$('#tienda').val(aclaracionBean.tienda);
						$('#noAutorizacion').val(aclaracionBean.noAutorizacion);
						$('#cajeroID').val(aclaracionBean.cajeroID);
						$('#detalleReporte').val(aclaracionBean.detalleReporte);
						$('#montoOperacion').val(aclaracionBean.montoOperacion);
						$('#montoOperacion').formatCurrency({
							positiveFormat: '%n', 
							roundToDecimalPlace: 2	
						});
						if(aclaracionBean.estatus == catEstatusAclaracion.alta){
							$('#fechaOperacion').val(aclaracionBean.fechaOperacion);
							if($('#reporteID').val() == 0){
								validaDiasAclaracion();
							}							
							$('#estatus').val('ALTA');
							consultaTransaccion(aclaracionBean.transaccionID);
							habilitaBoton('adjuntar', 'submit');
							habilitaBoton('pdf', 'submit');
							habilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');
						}else if(aclaracionBean.estatus == catEstatusAclaracion.seguimiento){
							$('#estatus').val('Seguimiento');
							deshabilitaBoton('adjuntar', 'submit');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit');
						}else if(aclaracionBean.estatus == catEstatusAclaracion.resuelta){
							$('#estatus').val('Resuelta');
							deshabilitaBoton('adjuntar', 'submit');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit');
						}
						$('#gridAdjuntos').show();
					}else{
						alert("El Número de Reporte de Aclaración no Existe");
						limpiarFormulario();
						$('#reporteID').val('');
						$('#gridAdjuntos').hide();
						$('#reporteID').focus();
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
					}
				});
			}
		}
	}



	function validaAclaracionCre(idControl){
		var jqTipoAcla  = eval("'#" + idControl + "'");
		var numTipoAcla = $(jqTipoAcla).val();
		if(numTipoAcla != '' && !isNaN(numTipoAcla) ){
			tipo = 'C';
			numLis = 2;
			var tipoAclaraBeanCon = { 
				'reporteID' : numTipoAcla,
				'tipoTarjeta': tipo
			};			
			if(numTipoAcla == '0'){ 
				$('#gridAdjuntos').hide();
				limpiarFormulario();
				$('#estatus').val("ALTA");
				habilitaControl('tarjetaDebID');
				$('#tipoReporte').focus();
				habilitaBoton('agrega', 'submit');	
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('adjuntar', 'submit');
				deshabilitaBoton('pdf', 'submit');
			}else{
				habilitaBoton('modifica', 'submit');
				habilitaBoton('agrega', 'submit');
				$('#estatus').val('');
				aclaracionServicio.consulta(catConAclaracion.conCredito, tipoAclaraBeanCon, function(aclaracionBean) {
					if(aclaracionBean != null){
						$('#tipoReporte').val(aclaracionBean.tipoReporte);
						$('#reporteID').val(aclaracionBean.reporteID);
						$('#tarjetaDebID').val(aclaracionBean.tarjetaDebID);
						deshabilitaControl('tarjetaDebID');
						$('#producto').show();
						$('#cuentaAho').hide();
						$('#tipoTarjetaDebID').val(aclaracionBean.tipoTarjetaID);
						$('#nombreTarjeta').val(aclaracionBean.tipoTarjeta);
						$('#productoID').val(aclaracionBean.productoID);
						$('#nombreProducto').val(aclaracionBean.nombreProducto);
						$('#clienteID').val(aclaracionBean.clienteID);
						$('#nombre').val(aclaracionBean.nombre);
						$('#corporativoID').val(aclaracionBean.corporativoID);
						$('#corporativo').val(aclaracionBean.nombreCorp);
						if (aclaracionBean.corporativoID == 0 || aclaracionBean.corporativoID == '' || aclaracionBean.corporativoID == null) {
							$('#cteCorpTr').hide();
							$('#corporativoID').val('');
							$('#corporativo').val('');
						}else {
							$('#cteCorpTr').show();
							$('#corporativoID').val(aclaracionBean.corporativoID);
							$('#corporativo').val(aclaracionBean.nombreCorp);	
						}
						$('#institucionID').val(aclaracionBean.institucionID);
						consultaInstitucion('institucionID');
						consultaOperaAclara(aclaracionBean.operacionID,numLis);	
						$('#tienda').val(aclaracionBean.tienda);
						$('#noAutorizacion').val(aclaracionBean.noAutorizacion);
						$('#cajeroID').val(aclaracionBean.cajeroID);
						$('#detalleReporte').val(aclaracionBean.detalleReporte);
						$('#montoOperacion').val(aclaracionBean.montoOperacion);
						$('#montoOperacion').formatCurrency({
							positiveFormat: '%n', 
							roundToDecimalPlace: 2	
						});
						if(aclaracionBean.estatus == catEstatusAclaracion.alta){
							$('#fechaOperacion').val(aclaracionBean.fechaOperacion);
							if($('#reporteID').val() == 0){
								validaDiasAclaracion();
							}							
							$('#estatus').val('ALTA');
							consultaTransaccionCred(aclaracionBean.transaccionID);
							habilitaBoton('adjuntar', 'submit');
							habilitaBoton('pdf', 'submit');
							habilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');
						}else if(aclaracionBean.estatus == catEstatusAclaracion.seguimiento){
							$('#estatus').val('Seguimiento');
							deshabilitaBoton('adjuntar', 'submit');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit');
						}else if(aclaracionBean.estatus == catEstatusAclaracion.resuelta){
							$('#estatus').val('Resuelta');
							deshabilitaBoton('adjuntar', 'submit');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit');
						}
						$('#gridAdjuntos').show();
					}else{
						alert("El Número de Reporte de Aclaración no Existe");
						limpiarFormulario();
						$('#reporteID').val('');
						$('#gridAdjuntos').hide();
						$('#reporteID').focus();
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
					}
				});
			}
		}
	}



	function validaDiasAclaracion() {
		var diasTrans = mostrarDias();
		var diasMaxAclaracion = $('#diasAclaracion').val();
		if (diasTrans > diasMaxAclaracion){
			alert("Ha excedido el Máximo de Días permitidos para realizar la Aclaración");
			$('#fechaOperacion').val('');
			$('#fechaOperacion').focus();
		}
	}



	
 	function consultaOperaAclara(valor, numLis){
		dwr.util.removeAllOptions('operacionID');
		numeroLista = numLis;
		dwr.util.addOptions( 'operacionID', {'0':'SELECCIONA'});
		var tipoReporte = $('#tipoReporte').val();
		var operaBean = {
				'tipoAclaracionID' : tipoReporte,
				'descripcion'	:''
		};
		if (tipoReporte != '' && !isNaN(tipoReporte) ){
			operacionAclaracionServicio.listaCombo(numeroLista, operaBean,function(operacion){
				for (var i = 0; i < operacion.length; i++){
					$('#operacionID').append(new Option(operacion[i].descripcion, parseInt(operacion[i].operacion), false, false));
				}
				$('#operacionID').val(valor);
			});
		}
	}
	
	//Funcion de consulta para obtener el nombre de la institucion	
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){		
				if(instituto!=null){							
					$('#nombreInstitucion').val(instituto.nombre);
				}else{
					alert("No Existe la Institución"); 
					$('#institucionID').val('');	
					$('#institucionID').focus();	
					$('#nombreInstitucion').val("");					
				}    						
			});
		}
	}
	
	function verificaMonto(idControl){
		var jqNumMonto = eval("'#" + idControl + "'");
		var monto = $(jqNumMonto).asNumber();
		if(monto == 0 && esTab){
			alert("El Monto debe ser Mayor a 0.");
			$('#montoOperacion').focus();	
		}
	}

	function consultaTarCte(control) {
		var numeroTarjeta = $('#tarjetaDebID').val();
		var clasificacion = 'C';	//Cliente Corporativo
		var tarjetaDebito = { 
				'tarjetaDebID' : numeroTarjeta,
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numeroTarjeta != '' && !isNaN(numeroTarjeta) && esTab){
			tarjetaDebitoServicio.consulta(catTipoConAsociaTC.tarjetaCta,tarjetaDebito,function(tarjetaDebito) {
				if(tarjetaDebito != null){
					$('#tipoTarjetaDebID').val(tarjetaDebito.tipoTarjetaDebID);
					$('#nombreTarjeta').val(tarjetaDebito.tipo);				
					$('#clienteID').val(tarjetaDebito.clienteID);
					$('#nombre').val(tarjetaDebito.nombreCompleto);
					$('#numCuenta').val(tarjetaDebito.cuentaAhoID);
					$('#descCuenta').val(tarjetaDebito.etiqueta);					
					if(tarjetaDebito.clasificacion == clasificacion){
						$('#cteCorpTr').show();
						$('#corporativoID').val(tarjetaDebito.clienteCorporativo);
						$('#corporativo').val(tarjetaDebito.razonSocial);
					}else{
						$('#cteCorpTr').hide();
						$('#corporativoID').val('');
						$('#corporativo').val('');
					}
					if(tarjetaDebito.identificacionSocio=='S'){
						alert('El Tipo de Tarjeta es de Identificación.');
						$('#tipoTarjetaDebID').val('');
						$('#nombreTarjeta').val('');				
						$('#clienteID').val('');
						$('#nombre').val('');
						$('#numCuenta').val('');
						$('#descCuenta').val('');
						$('#tarjetaDebID').val('');
						$('#tarjetaDebID').focus();
					}
				}else{
					$('#tarjetaDebID').focus();
					$('#tarjetaDebID').select();
				}
			});															
		}
	}


	function consultaTarCreCte(control) {
		var numeroTarjeta = $('#tarjetaDebID').val();
		var clasificacion = 'C';	//Cliente Corporativo
		var tarjetaDebito = { 
				'tarjetaDebID' : numeroTarjeta,
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numeroTarjeta != '' && !isNaN(numeroTarjeta) && esTab){
			tarjetaCreditoServicio.consulta(8,tarjetaDebito,function(tarjetaDebito) {
				if(tarjetaDebito != null){
					$('#tipoTarjetaDebID').val(tarjetaDebito.tipoTarjetaDebID);
					$('#nombreTarjeta').val(tarjetaDebito.tipo);				
					$('#clienteID').val(tarjetaDebito.clienteID);
					$('#nombre').val(tarjetaDebito.nombreCompleto);
					$('#numCuenta').val(tarjetaDebito.cuentaAhoID);
					$('#descCuenta').val(tarjetaDebito.etiqueta);					
					if(tarjetaDebito.clasificacion == clasificacion){
						$('#cteCorpTr').show();
						$('#corporativoID').val(tarjetaDebito.clienteCorporativo);
						$('#corporativo').val(tarjetaDebito.razonSocial);
					}else{
						$('#cteCorpTr').hide();
						$('#corporativoID').val('');
						$('#corporativo').val('');
					}
					if(tarjetaDebito.identificacionSocio=='S'){
						alert('El Tipo de Tarjeta es de Identificación.');
						$('#tipoTarjetaDebID').val('');
						$('#nombreTarjeta').val('');				
						$('#clienteID').val('');
						$('#nombre').val('');
						$('#numCuenta').val('');
						$('#descCuenta').val('');
						$('#tarjetaDebID').val('');
						$('#tarjetaDebID').focus();
					}
				}else{
					$('#tarjetaDebID').focus();
					$('#tarjetaDebID').select();
				}
			});															
		}
	}





	function subirArchivos() {
		agregarFilasArchivos();
 		var consecutivo = ($('#tablaArchivos >tbody >tr').length ) -1;
		var numReporte = $('#reporteID').val();
 		var url ="aclaraFileUploadVista.htm?reporteID="+ numReporte +"&consecutivo="+consecutivo;
 		var leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
 		var topPosition = (screen.height) ? (screen.height-500)/2 : 0;
 		ventanaArchivosAclaracion = window.open(url,
 				"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no," +
 				"addressbar=0,menubar=0,toolbar=0"+
 				"left="+leftPosition+
 				",top="+topPosition+
 				",screenX="+leftPosition+
 				",screenY="+topPosition);
	}
 	
	function creaArchivosAclara(){
		var contador = 1;
		$('#lisFolio').val("");
		$('#lisTipoArchivo').val("");
		$('#lisRuta').val("");
		$('#lisNombreArchivo').val("");		
		$('input[name=folioID]').each(function() {
			if (contador != 1){
				$('#lisFolio').val($('#lisFolio').val() + ','  + this.value);
			}else{
				$('#lisFolio').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=tipoArchivo]').each(function() {
			if (contador != 1){
				$('#lisTipoArchivo').val($('#lisTipoArchivo').val() + ','  + this.value);
			}else{
				$('#lisTipoArchivo').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=ruta]').each(function() {
			if (contador != 1){
				$('#lisRuta').val($('#lisRuta').val() + ','  + this.value);
			}else{
				$('#lisRuta').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=nombreArchivo]').each(function() {
			if (contador != 1){
				$('#lisNombreArchivo').val($('#lisNombreArchivo').val() + ','  + this.value);
			}else{
				$('#lisNombreArchivo').val(this.value);
			}
			contador = contador + 1;
		});
	} 	
 	
 	function consultaArchiAclaracion(){
 		var numReporte = $('#reporteID').val();
 		if (numReporte != '' ){
 			var params = {};
 			params['tipoLista'] = 2;
 			params['reporteID'] = $('#reporteID').val();
			$.post("gridAclaraArchivo.htm", params, function(data){
				if(data.length >0) {
					$('#detalleArchivos').html(data);
					$('#detalleArchivos').show();
					habilitaBoton('pdf', 'button');	
					habilitaBoton('adjuntar', 'button');
				}else{
					$('#detalleArchivos').html("");
					$('#detalleArchivos').show();
				}
			});
 		}else{
 			$('#detalleArchivos').html("");
 			$('#detalleArchivos').hide();
		}
	}

	function consultaParametros() {
		var numConsulta = 3;
		var paramBean = {
				'reporteID' : ''
		}; 
		aclaracionServicio.consulta(numConsulta, paramBean, function(parametros) {
			if (parametros != null) {
				$('#diasAclaracion').val(parametros.diasAclaracion);
			}
		});
	}
});//	FIN VALIDACIONES DE REPORTES

	function consultaTransaccion(valor) {
		var fechaOperacion = $('#fechaOperacion').val();
		var numTarjeta = $('#tarjetaDebID').val();
		var numConsulta = 3;
		var aclaraBean = {
			'tarjetaDebID'	: numTarjeta,
			'fechaOperacion': fechaOperacion,
			'tipoTarjeta': 'D'
		};
		dwr.util.removeAllOptions('transaccionID');
		dwr.util.addOptions('transaccionID', {'':'SELECCIONA'});
		if (fechaOperacion != ''){
			aclaracionServicio.lista(numConsulta, aclaraBean ,function(transaccion){
				if (transaccion.length > 0 ){
					for (var i = 0; i < transaccion.length; i++){
						$('#transaccionID').append(new Option(transaccion[i].descMovimiento, parseInt(transaccion[i].numeroTransaccion), false, false));
					}
					$('#transaccionID').val(valor);
				}else {
					alert("No Existen Transacciones para la Fecha Indicada")
					$('#fechaOperacion').val('');
					$('#fechaOperacion').focus();
				}
			});
		}
	}


	function consultaTransaccionCred(valor) {
		var fechaOperacion = $('#fechaOperacion').val();
		var numTarjeta = $('#tarjetaDebID').val();
		var numConsulta = 2;
		var aclaraBean = {
			'tarjetaDebID'	: numTarjeta,
			'fechaOperacion': fechaOperacion
		};
		dwr.util.removeAllOptions('transaccionID');
		dwr.util.addOptions('transaccionID', {'':'SELECCIONA'});
		if (fechaOperacion != ''){
			aclaracionServicio.lista(numConsulta, aclaraBean ,function(transaccion){
				if (transaccion.length > 0 ){
					for (var i = 0; i < transaccion.length; i++){
						$('#transaccionID').append(new Option(transaccion[i].descMovimiento, parseInt(transaccion[i].numeroTransaccion), false, false));
					}
					$('#transaccionID').val(valor);
				}else {
					alert("No Existen Transacciones para la Fecha Indicada")
					$('#fechaOperacion').val('');
					$('#fechaOperacion').focus();
				}
			});
		}
	}


	function validaFecha(){
		if (esFechaValida($('#fechaOperacion').val())) {
			$('#fechaOperacion').val(parametroBean.fechaSucursal);
			$('#fechaOperacion').focus();
			$('#fechaOperacion').select();
		}
	}

	function agregarFilasArchivos(){
		var fechaSucursal=parametroBean.fechaSucursal;
		var numeroFila = ($('#tablaArchivos >tbody >tr').length ) -1 ;
		var nuevaFila = numeroFila + 1;	
		var tds = '<tr id="registro' + nuevaFila + '" name="registro" style="visibility : hidden" >';
		if(numeroFila == 0){
			tds += '<td><input type="text" id="folioID'+nuevaFila+'" name="folioID"  size="10" autocomplete="off"  type="hidden" /></td>';
			tds += '<td><input type="text" id="tipoArchivo'+nuevaFila+'" name="tipoArchivo"  size="60"  value="" /></td>';	
			tds += '<td> <a id="enlaceAclara'+nuevaFila+'" href="aclaraVerArchivos.htm" target="_blank">';
			tds += '<input type="button" id="ver'+nuevaFila+'" name="ver" class="submit" value="Ver" autocomplete="off" onclick="verArchivosAclara(this.id)"/>'; 
			tds += '</a> </td> ';
			tds += '<td><input type="text" id="fechaRegistro'+nuevaFila+'" value='+fechaSucursal+' name="fechaRegistro" path="fechaRegistro" size="10" /></td>';
			tds += '<input type="hidden" id="ruta' +nuevaFila+'" name="ruta" path="ruta" />';
			tds += '<input type="hidden" id="nombreArchivo' +nuevaFila+'" name="nombreArchivo" path="nombreArchivo" />';
		} else{
			var valor = numeroFila+ 1;
			tds += '<td><input type="text" id="folioID'+nuevaFila+'" name="folioID"'+valor+' size="10"/></td>';
			tds += '<td><input type="text"  id="tipoArchivo'+nuevaFila+'" name="tipoArchivo"  size="60"  value="" /></td>';
			tds += '<td> <a id="enlaceAclara'+nuevaFila+'" href="aclaraVerArchivos.htm" target="_blank">';
			tds += '<input type="button" id="ver'+nuevaFila+'" name="ver" class="submit" value="Ver" onclick="verArchivosAclara(this.id)"/>';
			tds += '</a> </td>';
			tds += '<td><input type="text" id="fechaRegistro'+nuevaFila+'" value='+fechaSucursal+' name="fechaRegistro" path="fechaRegistro" size="10"/></td>';
			tds += '<input type="hidden" id="ruta' +nuevaFila+'" name="ruta" path="ruta"/>';
			tds += '<input type="hidden" id="nombreArchivo' +nuevaFila+'" name="nombreArchivo" path="nombreArchivo"  />';
		}
		tds += '<td align="center"> <input type="button" id="'+nuevaFila+'" name="eliminar" class="btnElimina" onclick="eliminaArchivo(this)"/>';
		tds += '</tr>';
		$("#tablaArchivos").append(tds);
	}

	function eliminaArchivo(control){
		if (confirm("¿Desea eliminar este registro?") == true){
			
			var numeroID = control.id;
			var jqTr = eval("'#registro" + numeroID + "'");
			var jqFolio = eval("'#folioID" + numeroID + "'");
			var jqTipoAr = eval("'#tipoArchivo" + numeroID + "'");
			var jqBoton = eval("'#ver" + numeroID + "'");	
			var jqElimina = eval("'#" + numeroID + "'");
			$(jqTr).remove();
		
			//Reordenamiento de Controles 
			var contador = 1;
			$('input[name=folioID]').each(function() {
				var jqFolio = eval("'#" + this.id + "'");
				$(jqFolio).attr("id", "folioID" + contador);
				contador = contador + 1;
			});
			contador = 1;
			$('input[name=tipoArchivo]').each(function() {
				var jqTipAr = eval("'#" + this.id + "'");
				$(jqTipAr).attr("id", "tipoArchivo" + contador);
				contador = contador + 1;
			});
			contador = 1;
			$('input[name=ver]').each(function() {
				var jqBotV = eval("'#" + this.id + "'");
				$(jqBotV).attr("id", "ver" + contador);
				contador = contador + 1;
			});
			contador = 1;
			$('input[name=fechaRegistro]').each(function() {
				var jqFec = eval("'#" + this.id + "'");
				$(jqFec).attr("id", "fechaRegistro" + contador);
				contador = contador + 1;
			});
			contador = 1;
			$('input[name=eliminar]').each(function() {
				var jqElim = eval("'#" + this.id + "'");
				$(jqElim).attr("id", contador);
				contador = contador + 1;
			});
			contador = 1; 
			$('tr[name=registro]').each(function() {
				var jqReg = eval("'#" + this.id + "'");
				$(jqReg).attr("id", "registro" + contador);
				contador = contador + 1;
			});
		}
	}
		
	//funcion que valida fecha 
	function esFechaValida(fecha){
		var fecha2 = parametroBean.fechaSucursal;
		if(fecha == ""){return false;}
		if (fecha != undefined  ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de fecha no válido (aaaa-mm-dd)");
				return true;
			}
			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;
			var mes2=  fecha2.substring(5, 7)*1;
			var dia2= fecha2.substring(8, 10)*1;
			var anio2= fecha2.substring(0,4)*1;
			if(anio>anio2 || anio==anio2&&mes>mes2 || anio==anio2&&mes==mes2&&dia>dia2 ){
				alert("Fecha introducida es mayor a la actual.");
				return true;
			}		
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
					alert("Fecha introducida errónea.");
				return true;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea.");
				return true;
			}
			return false;
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

	$(".contador").each(function(){
		var longitud = $(this).val().length;
		$(this).parent().find('#longitud_textarea').html('<b>'+longitud+'</b>/2000');
		$(this).keyup(function(){
			var nueva_longitud = $(this).val().length;
			$(this).parent().find('#longitud_textarea').html('<b>'+nueva_longitud+'</b>/2000');
			if (nueva_longitud == "2000") {
				$('#longitud_textarea').css('color', '#ff0000');
			}
		});
	});
	
	function limpiarFormulario(){
		$('#tipoReporte').val('');	
		$('#tarjetaDebID').val('');
		$('#tipoTarjeta').val('');
		$('#clienteID').val('');
		$('#nombre').val('');
		$('#numCuenta').val('');
		$('#cuenta').val('');
		$('#corporativoID').val('');
		$('#corporativo').val('');
		$('#institucionID').val('');
		$('#operacionID').val('');	
		$('#tienda').val('');
		$('#cajeroID').val('');
		$('#montoOperacion').val('');
		$('#descCuenta').val('');
		$('#nombreInstitucion').val('');		
		$('#fechaOperacion').val('');
		$('#noAutorizacion').val('');
		consultaTransaccion('');
		$('#transaccionID').val('');
		$('#detalleReporte').val('');	
		$('#tipoTarjetaDebID').val('');
		$('#nombreTarjeta').val('');
	}

	function funcionExito (){
		resultado();
		$('#tipoReporte').val('');
		$('#estatus').val('');
		$('#tarjetaDebID').val('');
		$('#tipoTarjeta').val('');
		$('#tipoTarjetaDebID').val('');
		$('#nombreTarjeta').val('');
		$('#clienteID').val('');
		$('#nombre').val('');
		$('#numCuenta').val('');
		$('#cuenta').val('');
		$('#descCuenta').val('');
		$('#corporativoID').val('');
		$('#nombreCorp').val('');
		$('#corporativo').val('');
		$('#institucionID').val('');
		$('#nombreInstitucion').val('');	
		$('#operacionID').val('');	
		$('#tienda').val('');
		$('#cajeroID').val('');
		$('#noAutorizacion').val('');
		$('#montoOperacion').val('');
		$('#fechaOperacion').val('');
		$('#transaccionID').val('');
		$('#detalleReporte').val('');
	}

	function funcionError (){
	}

	function resultado(){
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.claveUsuario;
		var usuario = parametroBean.numeroUsuario;
		var tarjetaID = $('#tarjetaDebID').val();
		var reporteID = $('#reporteID').val();
		var fechaEmision = parametroBean.fechaSucursal;
		window.open('solicitudAclaracion.htm?nombreInstitucion='+nombreInstitucion+
					'&tarjetaDebID='+tarjetaID+'&usuarioID='+usuario+				
					'&reporteID='+reporteID+'&nombreUsuario='+nombreUsuario+'&fechaEmision='+fechaEmision+'&tipoReporte=1','_blank');
	}

 	function verArchivosAclara(control) {
		var numero= control.substr(3,control.length);
		var reporteID = $('#reporteID').val();
		var folioID = $('#folioID'+numero).val();
		var tipoArchivo =  $('#tipoArchivo'+numero).val();
		var nombreArchivo = $('#nombreArchivo'+numero).val();
		var ruta = $('#ruta'+numero).val();	 	
		$('#enlaceAclara'+numero).attr('href','aclaraVerArchivos.htm?reporteID='+reporteID+'&folioID='+folioID+
					'&tipoArchivo='+tipoArchivo+'&nombreArchivo='+nombreArchivo+
					'&ruta='+ruta,'_blank');
	}
 	
	function validaSoloNumeros() {
		if ((event.keyCode < 48) || (event.keyCode > 57))
  		event.returnValue = false;
	}
	
	function muestraFila(fila){
		var jqTr = eval("'#registro" + fila + "'");
		$(jqTr).css("visibility", "visible");
	}