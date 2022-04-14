$(document).ready(function() {
	esTab = true;
	press = false;
	
	var parametroBean = consultaParametrosSession();
	//Definicion de Constantes y Enums  
	var catTipoTransaccionLineaCredit = {   
  		'agrega':1,
  		'modifica':2	};
	
	var catTipoConsultaLineaCredit = {
  		'principal'	: 1,
  		'foranea'	: 2,
  		'redesCto'  : 3
	};
	var catTipoTransaccionCredito = {   
			'agrega':'1',
			'modifica':'2',
			'simulador':'9'
	}; 

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	//var formLinFondeo = 0;
	var formConDesCte = 1;
	var botonClic = 0;
		
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('gridCredFonAsig');
	

	ocultarGridsCondiciones();
	//inicializaCondDescuentoCte();
	inicializaForma('formaGenerica','institutFondID' );
	deshabilitaBoton('verCreditos','submit');
	$('#excel').attr("checked",true);
	$('#pdf').attr("checked",false);
	$('#reporte').val(2);
	$('#lista').val(2);
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			if(botonClic ==formConDesCte ){
				//grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje','true','lineaFondeoID','funcionExitoCondCte','funcionFalloCondCte');
			}else{
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','institutFondID','funcionExitoCondCte1','funcionFalloCondCte1');
			}
		}
    });				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	//deshabilitaControl('saldoCredito');
	//-------- fecha de la asignacion leo--------------
	var fechaactual = parametroBean.fechaSucursal;
	$('#fecha').val(fechaactual);
	$('#institutFondID').focus();
	//------------------------------------------------
	$('#institutFondID').bind('keyup',function(e){
		 if(this.value.length >= 2 && isNaN($('#institutFondID').val())){
			 lista('institutFondID', '2', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
		 }
	});
	$('#gridCredFonAsig').scroll(function() {
		 
	});
	$('#institutFondID').blur(function() { 
		consultaInstitucionFondeo(this.id);
	});
	/////JKDFJSHKFDJSHDKFJSHDFKJSHDFKSJDHFKSJFH
	$('#creditoFondeoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreInstitFon";
			camposLista[1] = "lineaFondeoID";
			camposLista[2] = "institutFondID";
	      			
			parametrosLista[0] = $('#creditoFondeoID').val();
			parametrosLista[1] = $('#lineaFondeoID').val();
			parametrosLista[2] = $('#institutFondID').val();
			
			lista('creditoFondeoID', '1', '2', camposLista, parametrosLista, 'listaCreditoFondeo.htm');
		}				       
	});	
	$('#creditoFondeoID').blur(function(){
		validaCreditoFondeo(this.id);
	});
	
	//-------falta validar ---------------------------
	$('#lineaFondeoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "descripLinea";
		camposLista[1] = "institutFondID";


		parametrosLista[0] = $('#lineaFondeoID').val();
		parametrosLista[1] = $('#institutFondID').val();
		
		lista('lineaFondeoID', '2', '2', camposLista, parametrosLista, 'listaLineasFondeador.htm');
	});
	
	$('#lineaFondeoID').blur(function() { 
		validaLineaFondeo(this.id); 
	});	
	
	$('#tipoLinFondeaID').blur(function() { 
		consultaTipoLinFondea(this.id); 
	});
	
	$('#montoOtorgado').blur(function() {
		var montoOt= ($('#montoOtorgado').val());
		$('#saldoLinea').val(montoOt);
	});
	
	
	$('#tipoLinFondeaID').bind('keyup',function(e){
		 if(this.value.length >= 2 && isNaN($('#tipoLinFondeaID').val())){
			 lista('tipoLinFondeaID', '1', '1', 'descripcion', $('#tipoLinFondeaID').val(), 'listaTipoLineaFondea.htm');
		 }
	});
		
	$('#descripLinea').blur(function() {
		var nombrec = $('#descripLinea').val();
		$('#descripLinea').val($.trim(nombrec));
	});

	$('#verCreditos').click(function() {
		consultaDetalle();
	});
	
	$('#grabar').click(function() {
		quitaFormatoControles('formaGenerica');
		quitaFormatoControles('gridCredFonAsig');
		$('#tipoTransaccion').val(catTipoTransaccionCredito.agrega);
	});
	
	
	$('#imprimir').click(function() {	
		quitaFormatoControles('formaGenerica');
		quitaFormatoControles('gridCredFonAsig');
        var i = $('#institutFondID').val();
        var n = $('#nombreInstitFondeo').val();
        var lf = $('#lineaFondeoID').val();
        var dl = $('#descripLinea').val();
        var cf = $('#creditoFondeoID').val();
        //var sc = $('#saldoCapFon').val();
        var fi = $('#fechaInicioCred').val();
        var fas = $('#fecha').val();
        var tipoReporte = $('#reporte').val();
		var lista = $('#lista').val();
        var usuario = parametroBean.nombreUsuario;
		if(lista == 2){
			$('#ligaImp').attr('href','repBaseCredFommur.htm?institutFondeoID='+i+'&nombreInstitFon='+n+'&lineaFondeoID='+lf+'&descripLinFon='+dl+
					'&creditoFondeoID='+cf+'&fechaIniCredFon='+fi+'&usuarioAsigna='+usuario+'&fechaAsignacion='+fas+'&tipoReporte='+tipoReporte+'&tipoLista='+lista);			
		}else{
		$('#ligaImp').attr('href','repBaseCredFommur.htm?institutFondeoID='+i+'&nombreInstitFon='+n+'&lineaFondeoID='+lf+'&descripLinFon='+dl+
				'&creditoFondeoID='+cf+'&fechaIniCredFon='+fi+'&usuarioAsigna='+usuario+'&fechaAsignacion='+fas+'&tipoReporte='+tipoReporte);
		}
	});
	
	$('#imprimirDetalleEx').click(function() {	
		quitaFormatoControles('formaGenerica');
		quitaFormatoControles('gridCredFonAsig');
        var i = $('#institutFondID').val();
        var n = $('#nombreInstitFondeo').val();
        var lf = $('#lineaFondeoID').val();
        var dl = $('#descripLinea').val();
        var cf = $('#creditoFondeoID').val();
        var sc = $('#saldoCapFon').val();
        var fi = $('#fechaInicioCred').val();
        var fas = $('#fecha').val();
        var tipoReporte = $('#reporte').val();
        var tipoLista = 1;
		var fechaEmision = parametroBean.fechaSucursal;
		var usuario = parametroBean.nombreUsuario;
		$('#ligaExcel').attr('href','RepPDFCreditoAsig.htm?institutFondeoID='+i+'&nombreInstitFon='+n+'&lineaFondeoID='+lf+'&descripLinFon='+dl+
			'&creditoFondeoID='+cf+'&saldoCreditoFon='+sc+'&fechaIniCredFon='+fi+'&usuarioAsigna='+usuario+'&fechaAsignacion='+fas+'&tipoReporte='
			+tipoReporte+'&tipoLista='+tipoLista+'&nombreUsuario='+usuario+'&parFechaEmision='+fechaEmision);
		agregaFormatoControles('formaGenerica');
		agregaFormatoControles('gridCredFonAsig');
	});
	
	$('#pdf').click(function() {
		$('#pdf').focus();
		$('#pdf').attr("checked",true);
		$('#excel').attr("checked",false);
		$('#reporte').val(1);
		$('#lista').val(0);
	});
	
	$('#excel').click(function() {
		$('#excel').focus();
		$('#excel').attr("checked",true);
		$('#pdf').attr("checked",false);
		$('#reporte').val(2);
		$('#lista').val(2);
	});
// FIN: seccion de eventos para condiciones de descuento por cliente
	
//	------------ Validaciones de la forma ------------------------------------- 
	$('#formaGenerica').validate({
		rules: {
			institutFondID: { 
				required: true
			},	
			descripLinea: { 
				required: true
			},	
			tipoLinFondeaID: { 
				required: true
			},
			montoOtorgado: { 
				required: true
			},
			saldoLinea: { 
				required: true
			},
			tasaPasiva: { 
				required: true
			},
			diasGraciaMora: { 
				number: true
			},
			fechInicLinea: { 
				required: true,
				date: true
			},
			fechaFinLinea: { 
				required: true,
				date: true
			},
			fechaMaxVenci: { 
				required: true,
				date: true
			},
			fechaAsignacion:{
				required: true,
				date: true
			},
			fechaInicioCred:{
				date: true
			}
		},
		messages: {
			institutFondID: {
				required: 'Especificar Institución'
			},
			descripLinea: {
				required: 'Especificar Descripción',
			},
			tipoLinFondeaID: {
				required: 'Especificar Tipo',
			},
			montoOtorgado: {
				required: 'Especificar Monto',
			},
			saldoLinea: {
				required: 'Especificar Saldo',
			},
			tasaPasiva: { 
				required: 'Especificar Tasa',
			},
			diasGraciaMora: { 
				number: 'Especificar un Número Valido'
			},
			fechInicLinea: {
				required: 'Especificar Fecha',
				date: 'Fecha Incorrecta'
			},
			fechaFinLinea: {
				required: 'Especificar Fecha ',
				date: 'Fecha Incorrecta'
			},
			fechaMaxVenci: { 
				required: 'Especificar Fecha ',
				date: 'Fecha Incorrecta'
			},
			cuentaClabe:{
				required: 'Especificar CuentaClabe',
				minlength:'Minimo 18 Caracteres',
				maxlength:'Máximo de Caracteres'
			}	
		}		
	});

//	------------ Validaciones de Controles -------------------------------------
	function validaLineaFondeo(control) {
		var numLinea = $('#lineaFondeoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var numInstitut = $('#institutFondID').val();
		if(numLinea != '' && !isNaN(numLinea) && esTab){
			if(numLinea=='0'){
				alert("No existe la linea de Fondeo");
				$('#lineaFondeoID').val("");
					$('#lineaFondeoID').focus();
					$('#descripLinea').val("");
					$('#tipoLinFondeaID').val("");
					$('#desTipoLinFondea').val("");
					$('#montoOtorgado').val("");
					$('#saldoLinea').val("");
					$('#creditoFondeoID').val("");
					$('#montoCredito').val("");
					$('#saldoCapFon').val("");
					$('#fechaInicioCred').val("");
				}else {
				var lineaFondBeanCon = { 
						'lineaFondeoID':$('#lineaFondeoID').val()
				};
				lineaFonServicio.consulta(catTipoConsultaLineaCredit.redesCto,lineaFondBeanCon,function(lineaFond) {
					if(lineaFond!=null){
						//dwr.util.setValues(lineaFond);								
						//esTab=true;
						var lineafondeo = lineaFond.institutFondID;
						if(lineafondeo==numInstitut){
							$('#tipoLinFondeaID').val(lineaFond.tipoLinFondeaID); 
							$('#descripLinea').val(lineaFond.descripLinea);
							deshabilitaControl('montoOtorgado');
							consultaTipoLinFondea('tipoLinFondeaID');
							$('#montoOtorgado').val(lineaFond.montoOtorgado);
							$('#saldoLinea').val(lineaFond.saldoLinea);
							$('#montoOtorgado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#saldoLinea').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							
							
							// funcion para consultar las condiciones de descuento por cliente
							//consultaConDesctoClientesLinFon($('#lineaFondeoID').val(),$('#sexo').val(),$('#estadoCivil').val());
							// funciones que consultan el contenido de los grid
							//consultaConDesctoEdosMunLinFon($('#lineaFondeoID').val());
							//consultaConDesctoDestinosLinFon($('#lineaFondeoID').val());
							//consultaConDesctoActividadesLinFon($('#lineaFondeoID').val());

							/* if(lineaFond.tipoRevolvencia == "L"){
								$('#tipoRevPago').attr('checked',false);
								$('#tipoRevLiq').attr('checked',true);
							}else{
								$('#tipoRevPago').attr('checked',true);
								$('#tipoRevLiq').attr('checked',false);
							}*/	
						}else{
							alert("La linea de Fondeo no Corresponde con la Institución");
							$('#lineaFondeoID').val("");
	   						$('#lineaFondeoID').focus();
	   						$('#descripLinea').val("");
	   						$('#tipoLinFondeaID').val("");
	   						$('#desTipoLinFondea').val("");
	   						$('#montoOtorgado').val("");
	   						$('#saldoLinea').val("");
	   						$('#creditoFondeoID').val("");
	   						$('#montoCredito').val("");
	   						$('#saldoCapFon').val("");
	   						$('#fechaInicioCred').val("");							
						}
					}else{
						alert("No Existe la Linea Fondeador");
						deshabilitaBoton('modifica', 'submit');
   						deshabilitaBoton('agrega', 'submit');
   						//inicializaForma('formaGenerica','institutFondID' );
   						$('#lineaFondeoID').val("");
   						$('#lineaFondeoID').focus();
   						$('#descripLinea').val("");
   						$('#tipoLinFondeaID').val("");
   						$('#desTipoLinFondea').val("");
   						$('#montoOtorgado').val("");
   						$('#saldoLinea').val("");
   						$('#creditoFondeoID').val("");
   						$('#montoCredito').val("");
   						$('#saldoCapFon').val("");
   						$('#fechaInicioCred').val("");
   						//$('#lineaFondeoID').select();	
   						ocultarGridsCondiciones();
					}
				});
			}
		}
	}
	function consultaDetalle(){	
		var tipConCredAsig = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		var creditoAsigBeanCon = { 
				'lineaFondeoID': $('#lineaFondeoID').val(),
				'institutFondeoID': $('#institutFondID').val(),
				'creditoFondeoID': $('#creditoFondeoID').val(),
				'fechaAsignacion': $('#fecha').val()		
		};

			redesCueServicio.consulta(tipConCredAsig,creditoAsigBeanCon,function(credito) {
				if(credito!=null){
					var tipoListaGridFor = 1;
					listaGridCreditos(tipoListaGridFor);
				} else {
					var tipoListaGridPrin = 1;
					listaGridCreditos(tipoListaGridPrin);
				}
			});
		
	}

	function listaGridCreditos(control){
		var tipoLista = control;
		$("#imprimirDetalle").show();
		$("#imprimirDetalleEx").show();
		$("#grabar").show();
		$("#grabar").removeAttr('disabled');
		deshabilitaBoton('imprimirDetalle');
		deshabilitaBoton('imprimirDetalleEx');
		habilitaBoton('grabar');
		var params = {};
		params['institutFondeoID'] = $('#institutFondID').val();
		params['lineaFondeoID'] = $('#lineaFondeoID').val();
		params['creditoID'] = $('#creditoFondeoID').val();
		params['fechaAsignacion'] = $('#fecha').val();
		params['tipoLista'] = tipoLista;
		$.post("listaCreditosAsig.htm", params, function(data){
				if(data.length >0) {		
						$('#gridCredFonAsig').html(data);
						$('#gridCredFonAsig').show();					
				}else{				
						$('#gridCredFonAsig').html("");
						$('#gridCredFonAsig').show();
				}	
		});	
		
	}
	
	
	function consultaInstitucionFondeo(idControl) {
		setTimeout("$('#cajaLista').hide();", 200);
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();	
		var instFondeoBeanCon = {  
  				'institutFondID':numInstituto
				};
		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numInstituto != '' && !isNaN(numInstituto) && esTab){
			fondeoServicio.consulta(catTipoConsultaLineaCredit.foranea,instFondeoBeanCon,function(instituto) {
				if(instituto!=null){	
					$('#nombreInstitFondeo').val(instituto.nombreInstitFon);
				}else{
					alert("No Existe la Institución"); 
					$('#institutFondID').focus();
					$('#institutFondID').select();
					$('#institutFondID').val("");
					$('#nombreInstitFondeo').val('');
				}    						
			});
		}
	}
	
	function consultaTipoLinFondea(idControl) {
		var jqTipoLinea = eval("'#" + idControl + "'");
		var numTipoLinea = $(jqTipoLinea).val();	
		var tipoLFondeoBeanCon = {  
				'tipoLinFondeaID':numTipoLinea
		};
		esTab = true;
		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numTipoLinea != '' && !isNaN(numTipoLinea) && esTab){
			tiposLineaFonServicio.consulta(2,tipoLFondeoBeanCon,function(tipoLinea) {
				if(tipoLinea!=null){	
					$('#desTipoLinFondea').val(tipoLinea.descripcion);
				}else{
					alert("No Existe el Tipo"); 
					$('#tipoLinFondeaID').focus();
					$('#tipoLinFondeaID').select();
					$('#tipoLinFondeaID').val('');	
					$('#desTipoLinFondea').val('');	
				}    						
			});
		}
	}
		
	function validaCreditoFondeo(idControl){
		var numCredito = $('#creditoFondeoID').val();
		var numInstitut = $('#institutFondID').val();
		var numLinea = $('#lineaFondeoID').val();
		var foranea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		esTab=true;
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			if(numCredito=='0'){
				alert("No existe el Credito Pasivo");
				$('#creditoFondeoID').focus();
				$('#creditoFondeoID').val("");
				$('#montoCredito').val("");
				$('#saldoCapFon').val("");
				$('#fechaInicioCred').val("");
				}else {
				var creditoFondBeanCon = { 
						'creditoFondeoID':numCredito
				};
				creditoFondeoServicio.consulta(foranea,creditoFondBeanCon,function(creditoFond) {
					if(creditoFond!=null){
						//dwr.util.setValues(lineaFond);								
						//esTab=true;
						var lineaFon = creditoFond.lineaFondeoID;
						var institfon = creditoFond.institutFondID;
						if(lineaFon==numLinea && numInstitut == institfon){
							$('#montoCredito').val(creditoFond.monto); 
							$('#saldoCapFon').val(creditoFond.saldoCredito);
							$('#montoCredito').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#saldoCapFon').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#fechaInicioCred').val(creditoFond.fechaInicio);
							habilitaBoton('verCreditos');
						}else{
							alert("El Credito no Corresponde con la Institución y la Linea de Fondeo");
							$('#creditoFondeoID').focus();
							$('#creditoFondeoID').val("");
							$('#montoCredito').val(""); 
							$('#saldoCapFon').val("");	
							$('#fechaInicioCred').val("");
							deshabilitaBoton('verCreditos');
						}
					}else{
						alert("No Existe el Credito de Fondeo");
						$('#creditoFondeoID').focus();
						$('#creditoFondeoID').val("");
						$('#montoCredito').val(""); 
						$('#saldoCapFon').val("");	
						$('#fechaInicioCred').val("");
						deshabilitaBoton('verCreditos');
					}
				});
			}
		}
	}
	
	function validarFechaFin(){
		var valorFechaInicio = $('#fechInicLinea').val();
		var anioFechaInicio	= valorFechaInicio.substr(0,4);
		var mesFechaInicio = valorFechaInicio.substr(5,2);
		var diaFechaInicio = valorFechaInicio.substr(8,2);
		    	
		var valorFechaFin	= $('#fechaFinLinea').val();
		var anioFechaFin	= valorFechaFin.substr(0,4);
		var mesFechaFin = valorFechaFin.substr(5,2);
		var diaFechaFin = valorFechaFin.substr(8,2);
		var separadorUnoFechaFin = valorFechaFin.substr(4,1);
		var separadorDosFechaFin = valorFechaFin.substr(7,1);
		   
		if(separadorUnoFechaFin == "-"){
			if(separadorDosFechaFin == "-"){
				if(anioFechaInicio>anioFechaFin){  
					alert("La fecha de Fin no puede ser menor \n a la fecha de Inicio .");
					$('#fechaFinLinea').focus();
					$('#fechaFinLinea').select();
					$('#fechaFinLinea').val("");
				}else{
					if(anioFechaInicio==anioFechaFin){ 
						if(mesFechaInicio>mesFechaFin){ 
							alert("La fecha de Fin no puede ser menor \n a la fecha de Inicio.");
							$('#fechaFinLinea').focus();
							$('#fechaFinLinea').select();
							$('#fechaFinLinea').val("");
						}else{
							if(mesFechaInicio==mesFechaFin){
								if(diaFechaInicio>diaFechaFin){
									alert("La fecha de Fin no puede ser menor \n a la fecha de Inicio.");
									$('#fechaFinLinea').focus();
									$('#fechaFinLinea').select();
									$('#fechaFinLinea').val("");
								}
							}
						}	
					}
				}
			}
		}
	}
	
	function validarFechaMax(){
		var valorFechaMax = $('#fechaMaxVenci').val();
		var anioFechaMax	= valorFechaMax.substr(0,4);
		var mesFechaMax = valorFechaMax.substr(5,2);
		var diaFechaMax = valorFechaMax.substr(8,2);
		
		var valorFechaFin	= $('#fechaFinLinea').val();
		var anioFechaFin	= valorFechaFin.substr(0,4);
		var mesFechaFin = valorFechaFin.substr(5,2);
		var diaFechaFin = valorFechaFin.substr(8,2);
		var separadorUnoFechaFin = valorFechaFin.substr(4,1);
		var separadorDosFechaFin = valorFechaFin.substr(7,1);
		
		if(separadorUnoFechaFin == "-"){
			if(separadorDosFechaFin == "-"){
				if(anioFechaFin>anioFechaMax){  
					alert("La fecha de Maximos Vencimientos no puede ser menor \n a la fecha de Fin .");
					$('#fechaMaxVenci').focus();
					$('#fechaMaxVenci').select();
					$('#fechaMaxVenci').val("");
				}else{
					if(anioFechaFin==anioFechaMax){ 
						if(mesFechaFin>mesFechaMax){ 
							alert("La fecha de Maximos Vencimientos no puede ser menor \n a la fecha de Fin.");
							$('#fechaMaxVenci').focus();
							$('#fechaMaxVenci').select();
							$('#fechaMaxVenci').val("");
						}else{
							if(mesFechaFin==mesFechaMax){
								if(diaFechaFin>diaFechaMax){
									alert("La fecha de Maximos Vencimientos no puede ser menor \n a la fecha de Fin.");
									$('#fechaMaxVenci').focus();
									$('#fechaMaxVenci').select(); 
									$('#fechaMaxVenci').val("");
								}
							}
						}	
					}
				}
			}
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
			institucionesServicio.consultaInstitucion(2,InstitutoBeanCon,function(instituto){		
				if(instituto!=null){							
					$('#descripcionInstitucion').val(instituto.nombre);
				}else{
					alert("No existe la Institución"); 
					$('#institucionID').val('');	
					$('#institucionID').focus();	
					$('#descripcionInstitucion').val("");					
				}    						
			});
		}
	}
	
	function validaExisteFolio(numCta,institID){
  		var jqNumCtaInstit = eval("'#" + numCta + "'");
  		var jqInstitucionID = eval("'#" + institID + "'");
  		var numCtaInstit = $(jqNumCtaInstit).val();
  		var institucionID = $(jqInstitucionID).val();
  		var CtaNostroBeanCon = {
  				'institucionID':institucionID,
  				'numCtaInstit':numCtaInstit
  				
  		};
  		if(numCtaInstit!= "" && institucionID!=""){
  			cuentaNostroServicio.consultaExisteCta(5,CtaNostroBeanCon, function(ctaNtro){
  				if(ctaNtro!=null){  
  					var folio = ctaNtro.cuentaClabe;// el folio de institucion se paso en el parametro cuentaClabe
  					var cuentaClabe = $('#cuentaClabe').val();
  					var substrClabe= cuentaClabe.substr(0,3);
  					if(folio!=substrClabe){
  						alert("La Cuenta Clabe no coincide con la Institución.");
  						$('#cuentaClabe').focus();	
  					}						 			
  				}
  			});
  		}
  	}
	
	function ocultarGridsCondiciones(){
		// ocultar controles de condiciones de municipios 
		// y estados
		$('#gridEstadosMunLocGrid').html("");
		$('#gridEstadosMunLoc').hide();
		$('#grabarEdo').hide();
		deshabilitaBoton('grabarEdo', 'submit');
		$('#numeroDetalleEdo').val("0");
		
		// ocultar controles de condiciones de destinos de credito 
		$('#gridDestinoGrid').html("");
		$('#gridDestino').hide();
		$('#grabarDest').hide();
		deshabilitaBoton('grabarDest', 'submit');
		$('#numeroDetalleDestino').val("0");
		
		// ocultar controles de actividades 
		$('#gridActividadesGrid').html("");
		$('#gridActividades').hide();
		$('#grabarAct').hide();
		deshabilitaBoton('grabarAct', 'submit');
		$('#numeroDetalleAct').val("0");

		$('#lineaFondeoIDDest').val("");
		$('#lineaFondeoIDCte').val("");
		$('#lineaFondeoIDAct').val("");
		$('#lineaFondeoIDEdo').val("");
		
		inicializaComboProductosCre();
		
	}

//	------------- funciones para seccion de condiciones de descuento, clientes----------------
	function consultaConDesctoClientesLinFon(numLineaFondeo, valSexo, valEdoCivil) {	
		var beanConsulta = {  
				'lineaFondeoIDCte':numLineaFondeo,
				'sexo':valSexo,
				'estadoCivil':valEdoCivil,
		};
		setTimeout("$('#cajaLista').hide();", 200);		 
		esTab = true;
		if(numLineaFondeo != '' && !isNaN(numLineaFondeo) && esTab){
			condicionesDesctoCteLinFonServicio.consulta(1,beanConsulta,function(condicionesDes) {
				if(condicionesDes!=null){	
					dwr.util.setValues(condicionesDes); 
					consultaComboProductosCredito(condicionesDes.productosCre);
					consultaComboEstadoCivil(condicionesDes.estadoCivil);
					switch(condicionesDes.sexo){
						case "F":
							$('#sexo').val('F');
							$('#generoIndistinto').attr('checked',false);
							$('#generoFemenino').attr('checked',true);
							$('#generoMasculino').attr('checked',false);
						break;
						case "M":
							$('#sexo').val('M');
							$('#generoIndistinto').attr('checked',false);
							$('#generoFemenino').attr('checked',false);
							$('#generoMasculino').attr('checked',true);
						break;
						case "I":
							$('#sexo').val('I');
							$('#generoIndistinto').attr('checked',true);
							$('#generoFemenino').attr('checked',false);
							$('#generoMasculino').attr('checked',false);
						break;
						default:
							$('#sexo').val('I');
						$('#generoIndistinto').attr('checked',true);
						$('#generoFemenino').attr('checked',false);
						$('#generoMasculino').attr('checked',false);
					}
					
					deshabilitaBoton('grabarCte', 'submit');
					habilitaBoton('modificarCte', 'submit');
					//$('#estadoCivil').val(condicionesDes.estadoCivil);
					//$('#monedaID').val(condicionesDes.monedaID);
					$('#monedaID').removeAttr('disabled');
					$('#lineaFondeoIDCte').val(numLineaFondeo);
					$('#montoMaximo').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#montoMinimo').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				}else{
					inicializarFormularioDesctoCte(); 
					habilitaBoton('grabarCte', 'submit');
					$('#monedaID').removeAttr('disabled');
					deshabilitaBoton('modificarCte', 'submit');
					$('#lineaFondeoIDCte').val(numLineaFondeo);
				}    						
			});
		}
	}
	
	function inicializarFormularioDesctoCte() {	
//		inicializaForma('formaGenerica1','lineaFondeoIDCte' );
		$('#montoMinimo').val("");
		$('#montoMaximo').val("");
		$('#estadoCivil').val('');
		consultaproductosCreAplica();
	}
	
	function consultaproductosCreAplica(){
		var tipoCon=2;
		dwr.util.removeAllOptions('productosCre');
		dwr.util.addOptions( 'productosCre', {'':'SELECCIONE'});
		dwr.util.addOptions( 'productosCre', {'1':'TODOS'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('productosCre', productos, 'producCreditoID', 'descripcion');
		});
	}

	// funcion para seleccionar todos los productos
	function seleccionaTodosProd() {
		$("#productosCre option").each(function(){
			idProducto = $(this).attr('value');
			var jqOpcion = eval("'#productosCre option[value="+ idProducto +"]'");  
			if (idProducto!="1" && idProducto!=""){
				$(jqOpcion).attr("selected","selected");   
			}
		});  
	}  
	// funcion para seleccionar todos los estados civiles
	function seleccionaTodosEst() {
		$("#estadoCivil option").each(function(){
			idEstado= $(this).attr('value');
			var jqOpcion = eval("'#estadoCivil option[value="+ idEstado +"]'");  
			if (idEstado!="T" && idEstado!=""){
				$(jqOpcion).attr("selected","selected");   
			}
		});  
	}
	
	// para inicializar el selector multiple
	function inicializaComboProductosCre(){
		$("#productosCre option").each(function(){
			idProducto = $(this).attr('value');
			var jqOpcion = eval("'#productosCre option[value="+ idProducto +"]'");  
			$(jqOpcion).removeAttr("selected");   
		});  
	}

	// funcion para seleccionar los productos de credito que se consulten
	function consultaComboProductosCredito(productosCredito) { 
		var productoValor= productosCredito.split(',');
		var tamanio = productoValor.length;
	 	for (var i=0;i<tamanio;i++) {  
			var tip = productoValor[i];
			var jqTipo = eval("'#productosCre option[value="+tip+"]'");  
			$(jqTipo).attr("selected","selected");    
		}
	}
	// funcion para seleccionar los productos de credito que se consulten
	function consultaComboEstadoCivil(estadoCivil) { 
		var estadoValor= estadoCivil.split(',');
		var tamanio = estadoValor.length;
	 	for (var i=0;i<tamanio;i++) {  
			var tip = estadoValor[i];
			var jqTipo = eval("'#estadoCivil option[value="+tip+"]'");  
			$(jqTipo).attr("selected","selected");    
		}
	}
	
	
	// inicializar seccion cond descuento cliente
	function inicializaCondDescuentoCte(){
		$('#generoIndistinto').attr('checked',true);
		$('#generoMasculino').attr('checked',false);
		$('#generoFemenino').attr('checked',false);
		$('#sexo').val("I");
	}
	
//	FIN------------- funciones para grid de condiciones de descuento, clientes----------------
}); // fin del Ready
var nav4 = window.Event ? true : false;
function IsNumber(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || (key >= 48 && key <= 57) );
}
function IsNumber1(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || key > 43 && key < 45 || (key >= 48 && key <= 57) || key > 45 && key < 47  );
}
function IsNumber2(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || key > 43 && key < 45 || (key >= 48 && key <= 57) || key > 45 && key < 47  );
}
function funcionExitoCondCte(){
	habilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');	
	
}
function funcionFalloCondCte(){
	
}
function funcionExitoCondCte1(){
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('gridCredFonAsig');
	habilitaBoton('imprimirDetalle');
	habilitaBoton('imprimirDetalleEx');
	deshabilitaBoton('grabar');
}
function funcionFalloCondCte1(){
	
}