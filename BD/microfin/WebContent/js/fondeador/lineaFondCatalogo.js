var hayTasaBase = false; // Indica la existencia de una tasa base
$(document).ready(function() {
	//Definicion de Constantes y Enums  
	var parametroBean = consultaParametrosSession();
	var manejaCarAgro = 'N';

	var catTipoTransaccionLineaCredit = {   
  		'agrega':1,
  		'modifica':2	};
	
	var catTipoConsultaLineaCredit = {
  		'principal'	: 1,
  		'foranea'	: 2
	};
	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	//var formLinFondeo = 0;
	var formConDesCte = 1;
	var botonClic = 0;
	
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');

	deshabilitaBoton('grabarCte', 'submit');
	deshabilitaBoton('modificarCte', 'submit');
	deshabilitaBoton('grabarEdo', 'submit');
	deshabilitaBoton('grabarDest', 'submit');
	deshabilitaBoton('grabarAct', 'submit');
	
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('formaGenerica1');
	agregaFormatoControles('formaGenerica2');
	agregaFormatoControles('formaGenerica3');
	agregaFormatoControles('formaGenerica4');
	
	ocultaGridsCondiciones();
	ocultarGridsCondiciones();
	inicializaCondDescuentoCte();
	inicializaForma('formaGenerica','lineaFondeoID' );
	ocultarBotonPoliza();
	$('#refinanciamiento').val('N');	
	
	$('#tipoRevPago').attr('checked',true);
	$('#tipoRevLiq').attr('checked',false);
	$('#tipoRevNo').attr('checked',false);	
	$('#reqIntegra').val('N');	
	deshabilitaControl('tipoRevNo');	
	
	consultaMoneda();
	consultaComboCalInteres();
	
	
	consultaSICParam();
	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			if(botonClic ==formConDesCte ){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje','true','lineaFondeoID','funcionExitoCondCte','funcionFalloCondCte');
			}else{
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','lineaFondeoID','funcionExitoLineaFond','funcionFalloLineaFond');
			}
		}
    });				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#monedaID2').blur(function() {
		console.log('Antes del metodo');
		buscarMoneda(this.id); 
	});
	$('#monedaID2').bind('keyup',function(e){
		lista('monedaID2', '0', 2, 'monedaID', $('#monedaID2').val(), 'listaMonedas.htm');
	});
	
	$('#lineaFondeoID').focus();
	$('#lineaFondeoID').blur(function() { 
		validaLineaFondeo(this.id); 
		validaRevolvencia();
	});
	
	$('#institutFondID').blur(function() { 
		if($('#lineaFondeoID').val()==0){
		$('#tipoLinFondeaID').val('');
		$('#desTipoLinFondea').val('');
		}
		consultaInstitucionFondeo(this.id);
		if($('#institutFondID').val()==''){
			$('#tipoLinFondeaID').val('');
			$('#desTipoLinFondea').val('');
			$('#nombreInstitFondeo').val('');
		}
	});
	
	$('#tipoLinFondeaID').blur(function() { 
		var vacio='';
		consultaTipoLinFondea(this.id); 
		if($('#tipoLinFondeaID').val()==vacio){
			$('#desTipoLinFondea').val('');
		}
	});
	
	$('#montoOtorgado').blur(function() {
		var montoOt= ($('#montoOtorgado').val());
		$('#saldoLinea').val(montoOt);
	});
	
	$('#factorMora').blur(function() {
		var fMora = $('#factorMora').asNumber();
		if (fMora < 0){
			mensajeSis("El Factor de Mora no puede ser Negativo");
			$('#factorMora').focus();
		}
	});
	
	$('#diasGraciaMora').blur(function() {
		var dMora = $('#diasGraciaMora').asNumber();
		var patron = /^\d*$/;                          
		var numero = dMora;                                  
			if (patron .test(numero)) {              
			}else {
		mensajeSis('El Número de Días es Incorrecto');
		$('#diasGraciaMora').focus();
		}
	});
	
	$('#fechInicLinea').change(function() {
		$('#fechaFinLinea').val("");
		$('#fechaMaxVenci').val("");
		validarFechaFin();
		$('#fechInicLinea').focus();
	});
	
	$('#fechaFinLinea').change(function() {
		$('#fechaMaxVenci').val("");
		validarFechaFin();
		$('#fechaFinLinea').focus();
	});
	
	$('#fechaMaxVenci').change(function() {
		validarFechaMax();
		$('#fechaMaxVenci').focus();
	});
	  
	$('#descripLinea').focus(function() {
	 	if(isNaN($('#institutFondID').val())){
	 		consultaInstitucionFondeo('institutFondID');
	 	 }
	});
	
	$('#tipoLinFondeaID').focus(function() {	
		if(isNaN($('#institutFondID').val())){
	 		consultaInstitucionFondeo('institutFondID');
	 	 }
	});
	
	$('#montoOtorgado').focus(function() {	
	 	if(isNaN($('#tipoLinFondeaID').val())){
	 		consultaTipoLinFondea('tipoLinFondeaID');
	 	 }
	 	if(isNaN($('#institutFondID').val())){
	 		consultaInstitucionFondeo('institutFondID');
	 	 }
	});
	
	$('#saldoLinea').focus(function() {	
	 	if(isNaN($('#tipoLinFondeaID').val())){
	 		consultaTipoLinFondea('tipoLinFondeaID');
	 	 }
	 	if(isNaN($('#institutFondID').val())){
	 		consultaInstitucionFondeo('institutFondID');
	 	 }
	});
	
	$('#tasaPasiva').focus(function() {	
	 	if(isNaN($('#tipoLinFondeaID').val())){
	 		consultaTipoLinFondea('tipoLinFondeaID');
	 	 }
	 	if(isNaN($('#institutFondID').val())){
	 		consultaInstitucionFondeo('institutFondID');
	 	 }
	});
	
	$('#lineaFondeoID').bind('keyup',function(e){
		lista('lineaFondeoID', '2', '1', 'descripLinea', $('#lineaFondeoID').val(), 'listaLineasFondeador.htm');
	});
	
	
	$('#institutFondID').bind('keyup',function(e){
		 if(this.value.length >= 2 && isNaN($('#institutFondID').val())){
			 lista('institutFondID', '2', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
		 }
	});
	
	$('#folioFondeo').blur(function() { 
		var textoFolioFond = $(this).val();
		$(this).val(limpiaCaracteresEspeciales(textoFolioFond,'OR'));
	});

   $('#tipoLinFondeaID').bind('keyup',function(e){
	    var vacio='';
    	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "tipoLinFondeaID";
		camposLista[1] = "institutFondID";
		parametrosLista[0] = $('#tipoLinFondeaID ').val();
		parametrosLista[1] = $('#institutFondID').val();
		if($('#institutFondID').val()!= vacio){
			lista('tipoLinFondeaID', '1', '2', camposLista, parametrosLista,'listaTipoLineaFondea.htm');
		}else{
			mensajeSis("Especifique un Número de Institución de Fondeo");
			$('#institutFondID').focus();
			$('#institutFondID').select();
		}
    });
		
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionLineaCredit.agrega);
		botonClic = 0;	
		botonClicModificar = "0";
	});
	
	$('#modifica').click(function() {		
		$('#reqIntegra').val('N');
		$('#tipoTransaccion').val(catTipoTransaccionLineaCredit.modifica);
		botonClic = 0;
		botonClicModificar = "1";
	});	
	
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		listaAlfanumerica('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	
	$('#institucionID').blur(function() {
		if($('#institucionID').val()!=""){
			consultaInstitucion(this.id);  
		} 	
	});
	$('#descripLinea').blur(function() {
		var nombrec = $('#descripLinea').val();
		$('#descripLinea').val($.trim(nombrec));
	});
	
	$('#cuentaClabe').blur(function() {
		validaExisteFolio('cuentaClabe','institucionID'); 	
	});
	
	$('#esRevolvente').change(function() {
		if($('#esRevolvente').val()=='N'){
			deshabilitaControl('tipoRevPago');
			deshabilitaControl('tipoRevLiq');
			deshabilitaControl('tipoRevNo');
			$('#tipoRevPago').attr('checked',false);
			$('#tipoRevNo').attr('checked',true);
			$('#tipoRevLiq').attr('checked',false);
			$('#tipoRevolvencia').val('N');
			$('#tipoRevPago').attr("checked",false);
			$('#tipoRevLiq').attr("checked",false);
			$('#tdTipoRevolvencia').hide(); 
			$('#tdlblTipoRevol').hide();
		}else{			
			$('#tdTipoRevolvencia').show();
			$('#tdlblTipoRevol').show();
			habilitaControl('tipoRevPago');
			habilitaControl('tipoRevLiq');
			deshabilitaControl('tipoRevNo');
			$('#tipoRevPago').attr('checked',true);
			$('#tipoRevLiq').attr('checked',false);
			$('#tipoRevNo').attr('checked',false);
			$('#tipoRevolvencia').val('P');
			$('#tipoRevPago').focus();
		}
	});	
	
	$('#tipoRevPago').click(function() {		
		$('#tipoRevPago').attr('checked',true);
		$('#tipoRevLiq').attr('checked',false);
		$('#tipoRevNo').attr('checked',false);
		$('#tipoRevolvencia').val('P');
		$('#tipoRevPago').focus();
	});
	$('#tipoRevLiq').click(function() {		
		$('#tipoRevPago').attr('checked',false);
		$('#tipoRevNo').attr('checked',false);
		$('#tipoRevLiq').attr('checked',true);
		$('#tipoRevolvencia').val('L');
		$('#tipoRevLiq').focus();
	});

	$('#tipoRevNo').click(function() {		
		$('#tipoRevPago').attr('checked',false);
		$('#tipoRevNo').attr('checked',true);
		$('#tipoRevLiq').attr('checked',false);
		$('#tipoRevolvencia').val('N');
		$('#tipoRevNo').focus();
	});
	
// seccion de eventos para condiciones de descuento por cliente
	$('#grabarCte').click(function() {		
		$('#tipoTransaccionCondCte').val(catTipoTransaccionLineaCredit.agrega);
		botonClic = 1;	
	});
	$('#modificarCte').click(function() {		
		$('#tipoTransaccionCondCte').val(catTipoTransaccionLineaCredit.modifica);
		botonClic = 1;	
	});
	
	
	$('#generoMasculino').click(function(){
		$('#generoIndistinto').attr('checked',false);
		$('#generoFemenino').attr('checked',false);
		$('#generoMasculino').attr('checked',true);
		$('#sexo').val("M");
		$('#generoMasculino').focus();
		consultaConDesctoClientesLinFon($('#lineaFondeoID').val(),$('#sexo').val(),$('#estadoCivil').val());
	});
	
	$('#generoIndistinto').click(function(){
		$('#generoMasculino').attr('checked',false);
		$('#generoFemenino').attr('checked',false);
		$('#generoIndistinto').attr('checked',true);
		$('#sexo').val("I");
		$('#generoIndistinto').focus();
		consultaConDesctoClientesLinFon($('#lineaFondeoID').val(),$('#sexo').val(),$('#estadoCivil').val());
	});
	
	$('#generoFemenino').click(function(){
		$('#generoIndistinto').attr('checked',false);
		$('#generoMasculino').attr('checked',false);
		$('#generoFemenino').attr('checked',true);
		$('#sexo').val("F");
		$('#generoFemenino').focus();
		consultaConDesctoClientesLinFon($('#lineaFondeoID').val(),$('#sexo').val(),$('#estadoCivil').val());
	});

	$('#productosCre').change(function() {
		var todos="1";
		var opcionSelec = $('#productosCre').val();
		if(opcionSelec==todos){
			seleccionaTodosProd();
		};
	});
	
	$('#estadoCivil').change(function() {
		var todos="T";
		var opcionSelec = $('#estadoCivil').val();
		if(opcionSelec==todos){
			seleccionaTodosEst();
		};
	});
	
	$('#numCtaInstit').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		camposLista[1] = "numCtaInstit";
		parametrosLista[0] = $('#institucionID').val();
		parametrosLista[1]=$('#numCtaInstit').val();
		listaAlfanumerica('numCtaInstit', '0', '6', camposLista,parametrosLista, 'ctaNostroLista.htm');	       
	});	
	
	$('#numCtaInstit').blur(function(){
   		if($('#numCtaInstit').val()!="" && $('#institucionID').val()!=""){
   			validaCtaNostroExiste('numCtaInstit','institucionID');
   		}
   		$('#folioFondeo').focus();
   	});
	
	$('#clasificacionComer').click(function(){
		$('#clasificacionComer').attr('checked',true);
		$('#clasificacionHipo').attr('checked',false);
		$('#clasificacionConsu').attr('checked',false);
		$('#clasificacionNo').attr('checked',false);
		$('#clasificacion').val("C");
		$('#clasificacionComer').focus();
	});
	
	$('#clasificacionConsu').click(function(){
		$('#clasificacionConsu').attr('checked',true);
		$('#clasificacionHipo').attr('checked',false);
		$('#clasificacionComer').attr('checked',false);
		$('#clasificacionNo').attr('checked',false);
		$('#clasificacion').val("O");
		$('#clasificacionConsu').focus();
	});
	
	$('#clasificacionHipo').click(function(){
		$('#clasificacionHipo').attr('checked',true);
		$('#clasificacionComer').attr('checked',false);
		$('#clasificacionConsu').attr('checked',false);
		$('#clasificacionNo').attr('checked',false);
		$('#clasificacion').val("H");
		$('#clasificacionHipo').focus();
	});
	
	$('#clasificacionNo').click(function(){
		$('#clasificacionNo').attr('checked',true);
		$('#clasificacionHipo').attr('checked',false);
		$('#clasificacionComer').attr('checked',false);
		$('#clasificacionConsu').attr('checked',false);
		$('#clasificacion').val("N");
		$('#clasificacionNo').focus();
	});
	
// FIN: seccion de eventos para condiciones de descuento por cliente
	
	// evento para generar reporte de la poliza 
	$('#impPoliza').click(function(){
		$('#enlace').attr('href','RepPoliza.htm?polizaID='+numeroPoliza+'&fechaInicial='+parametroBean.fechaSucursal+
				'&fechaFinal='+parametroBean.fechaSucursal+'&nombreUsuario='+parametroBean.nombreUsuario);
	});
	
//	------------ Validaciones de la forma ------------------------------------- 
	$('#formaGenerica').validate({
		rules: {
			institutFondID: { 
				required: true
			},	
			descripLinea: { 
				required: true
			},	
			montoOtorgado: { 
				required: true,
				maxlength: 14
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
			cuentaClabe:{
				required: true,
				minlength:18,
				maxlength:18
			},
			calcInteresID:{
				required: true
			},
			refinanciamiento:{
				required: true
			}
		},
		messages: {
			institutFondID: {
				required: 'Especificar Institución.'
			},
			descripLinea: {
				required: 'Especificar Descripción.',
			},
			montoOtorgado: {
				required: 'Especificar Monto.',
				maxlength : "Máximo 12 caracteres"
			},
			saldoLinea: {
				required: 'Especificar Saldo.',
			},
			tasaPasiva: { 
				required: 'Especificar Tasa.',
			},
			diasGraciaMora: { 
				number: 'Especificar un Número Valido.'
			},
			fechInicLinea: {
				required: 'Especificar Fecha.',
				date: 'Fecha Incorrecta.'
			},
			fechaFinLinea: {
				required: 'Especificar Fecha. ',
				date: 'Fecha Incorrecta.'
			},
			fechaMaxVenci: { 
				required: 'Especificar Fecha. ',
				date: 'Fecha Incorrecta.'
			},
			cuentaClabe:{
				required: 'Especificar Cuenta Clabe.',
				minlength:'Minimo 18 Caracteres.',
				maxlength:'Máximo de Caracteres.'
			},
			calcInteresID:{
				required: 'Especificar el Tipo de Cálculo de Interés.'
			},
			refinanciamiento:{
				required: 'Especificar el Tipo de Refinanciamiento'
			}	
		}		
	});
	
	// formulario de grid de cliente
	$('#formaGenerica1').validate({
		rules: {
			lineaFondeoIDCte: { required: true },
			montoMinimo: { 
				required: true,
				number: true
			},
			montoMaximo: { 
				required: true,
				number: true
			},
			productosCre: { 
				required: true 
			},
			diasGraIngCre: { 
				required: true 
			},
			monedaID: { 
				required: true,
				numeroMayorCero: true,
	            numeroPositivo: true
			},
			estadoCivil: { 
				required: true
			}
		},
		messages: {	
			lineaFondeoIDCte: { required: 'Especificar Linea de Fondeo '},
			montoMinimo: { 
				required: 'Especificar Monto',
				number: 'Especificar un Número Valido',
			},
			montoMaximo: { 
				required: 'Especificar Monto',
				number: 'Especificar un Número Valido'
			},
			productosCre: { required: 'Especificar al menos un producto de Crédito'},
			diasGraIngCre: { 
				required: 'Especificar Dias' 
			},
			monedaID: { 
				required: 'Especificar el Tipo de Moneda',
				numeroMayorCero: 'Elija una Opción',
		        numeroPositivo: 'Elija una Opción'
			},
			estadoCivil: { 
				required: 'Especificar el Estado Civil'
			}
		}		
	});
	
//	------------ Validaciones de Controles -------------------------------------
	function validaLineaFondeo(control) {
		var numLinea = $('#lineaFondeoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		esTab=true;
		if(numLinea != '' && !isNaN(numLinea) && esTab){
			if(numLinea=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				habilitaControl('montoOtorgado');
				inicializaForma('formaGenerica','lineaFondeoID' );
				$("#fechInicLinea").datepicker("enable");
				$("#fechaFinLinea").datepicker("enable");
				$("#fechaMaxVenci").datepicker("enable");
				$('#monedaID').val('-1');
				$('#diasGraIngCre').val("");
				$('#tipoRevPago').attr('checked',true);
				$('#tipoRevLiq').attr('checked',false);
				$('#tipoRevNo').attr('checked',false);
				$('#tipoRevolvencia').val('P');
				$('#estadoCivil').val('');
				$('#maxDiasmora').val('');
		
				// funcion para consultar las condiciones de descuento por cliente
				consultaConDesctoClientesLinFon($('#lineaFondeoID').val(),$('#sexo').val(),$('#estadoCivil').val());
				habilitaBoton('grabarCte', 'submit');
				ocultarBotonPoliza();
			}else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var lineaFondBeanCon = { 
						'lineaFondeoID':$('#lineaFondeoID').val()
				};
				lineaFonServicio.consulta(catTipoConsultaLineaCredit.principal,lineaFondBeanCon,function(lineaFond) {
					if(lineaFond!=null){
						
						dwr.util.setValues(lineaFond);		
				
						$("#fechInicLinea").datepicker("disable");
						$("#fechaFinLinea").datepicker("disable");
						$("#fechaMaxVenci").datepicker("disable");
						$('#afectacionConta').val(lineaFond.afectacionConta);
						
						esTab=true;
						$('#monedaID2').val(lineaFond.monedaID);
						buscarMoneda('monedaID2');
						consultaproductosCreAplica();
						$('#institutFondID').val(lineaFond.institutFondID); 
						consultaInstitucionFondeo('institutFondID');
						$('#tipoLinFondeaID').val(lineaFond.tipoLinFondeaID);
						if(lineaFond.tipoLinFondeaID==0){
							$('#tipoLinFondeaID').val('');
						}
						$('#numCtaInstit').val(lineaFond.numCtaInstit);
						deshabilitaControl('montoOtorgado');
						consultaTipoLinFondea('tipoLinFondeaID');
						$('#montoComFaltaPag').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#montoOtorgado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#saldoLinea').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');
						consultaInstitucion('institucionID');
						
						// funcion para consultar las condiciones de descuento por cliente
						consultaConDesctoClienLinFon($('#lineaFondeoID').val());
						
						if(lineaFond.esRevolvente =='N'){
							deshabilitaControl('tipoRevPago');
							deshabilitaControl('tipoRevLiq');
							deshabilitaControl('tipoRevNo');
							$('#tdTipoRevolvencia').hide(); 
							$('#tdlblTipoRevol').hide();
							
						}else{
							habilitaControl('tipoRevPago');
							habilitaControl('tipoRevLiq');
							deshabilitaControl('tipoRevNo');
							$('#tdTipoRevolvencia').show(); 
							$('#tdlblTipoRevol').show();
						}

						if(lineaFond.tipoRevolvencia == "L"){
							$('#tipoRevPago').attr('checked',false);
							$('#tipoRevLiq').attr('checked',true);
							$('#tipoRevNo').attr('checked',false);
						}else{
							if(lineaFond.tipoRevolvencia == "P"){
								$('#tipoRevPago').attr('checked',true);
								$('#tipoRevLiq').attr('checked',false);
								$('#tipoRevNo').attr('checked',false);
							}else{
								$('#tipoRevNo').attr('checked',true);
								$('#tipoRevLiq').attr('checked',false);
								$('#tipoRevPago').attr('checked',false);
							}
						}
						if(botonClicModificar != "0" ){
							ocultarBotonPoliza();
						}			
						$('#reqIntegra').val(lineaFond.reqIntegracion).selected = true;
						if(lineaFond.reqIntegracion == 'S'){
						}else{
							ocultaGridsCondiciones();
							$('#reqIntegra').val('N');
						}
					}else{
						mensajeSis("No Existe la Linea Fondeador");
						deshabilitaBoton('modifica', 'submit');
   						deshabilitaBoton('agrega', 'submit');
   						inicializaForma('formaGenerica','lineaFondeoID' );
   						inicializarFormularioDesctoCte1();
   						$('#lineaFondeoID').val("");
   						$('#lineaFondeoID').focus();
   						$('#lineaFondeoID').select();
   						ocultarGridsCondiciones();
   						botonClicModificar = "1";
   						$('#reqIntegra').val('N');
					}
				});
			}
		}
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
					mensajeSis("No Existe la Institución"); 
					$('#institutFondID').focus();
					$('#institutFondID').select();
					$('#institutFondID').val("");
					$('#nombreInstitFondeo').val('');
					botonClicModificar = "1";
				}    						
			});
		}
	}
	// consulta de monedas
	function consultaMoneda() {			
		dwr.util.removeAllOptions('monedaID'); 

		dwr.util.addOptions('monedaID', {0:'SELECCIONAR'});
		monedasServicio.listaCombo(3, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function consultaTipoLinFondea(idControl) {
		var jqTipoLinea = eval("'#" + idControl + "'");
		var numTipoLinea = $(jqTipoLinea).val();	
		var numInstit =$('#institutFondID').val();

		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numTipoLinea != '' && !isNaN(numTipoLinea) && esTab){
			tiposLineaFonServicio.consultaTiposInstitut(3,numTipoLinea,numInstit, function(tipoLinea) {
				if(tipoLinea!=null){	
					$('#desTipoLinFondea').val(tipoLinea.descripcion);
				}else{
					mensajeSis("El Tipo de Linea No Corresponde con la Institución"); 
					$('#tipoLinFondeaID').focus();
					$('#tipoLinFondeaID').select();
					$('#tipoLinFondeaID').val('');	
					$('#desTipoLinFondea').val('');	
					botonClicModificar = "1";
				}    						
			});
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
					mensajeSis("La fecha de Fin no puede ser menor \n a la fecha de Inicio .");
					$('#fechaFinLinea').focus();
					$('#fechaFinLinea').select();
					$('#fechaFinLinea').val("");
				}else{
					if(anioFechaInicio==anioFechaFin){ 
						if(mesFechaInicio>mesFechaFin){ 
							mensajeSis("La fecha de Fin no puede ser menor \n a la fecha de Inicio.");
							$('#fechaFinLinea').focus();
							$('#fechaFinLinea').select();
							$('#fechaFinLinea').val("");
						}else{
							if(mesFechaInicio==mesFechaFin){
								if(diaFechaInicio>diaFechaFin){
									mensajeSis("La fecha de Fin no puede ser menor \n a la fecha de Inicio.");
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
					mensajeSis("La fecha de Máximo Vencimientos no puede ser menor \n a la fecha de Fin .");
					$('#fechaMaxVenci').focus();
					$('#fechaMaxVenci').select();
					$('#fechaMaxVenci').val("");
				}else{
					if(anioFechaFin==anioFechaMax){ 
						if(mesFechaFin>mesFechaMax){ 
							mensajeSis("La fecha de Máximo Vencimientos no puede ser menor \n a la fecha de Fin.");
							$('#fechaMaxVenci').focus();
							$('#fechaMaxVenci').select();
							$('#fechaMaxVenci').val("");
						}else{
							if(mesFechaFin==mesFechaMax){
								if(diaFechaFin>diaFechaMax){
									mensajeSis("La fecha de Máximo Vencimientos no puede ser menor \n a la fecha de Fin.");
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
					mensajeSis("No existe la Institución"); 
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
  						mensajeSis("La Cuenta Clabe no coincide con la Institución.");
  						$('#cuentaClabe').focus();
  						$('#cuentaClabe').val('');
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
	function ocultaGridsCondiciones(){
		$('#gridEstadosMunLoc').hide();
		$('#grabarEdo').hide();
		$('#gridDestino').hide();
		$('#grabarDest').hide();
		$('#gridActividades').hide();
		$('#grabarAct').hide();
		$('#condiciones').hide();
		
	}
	function mostrarGridsCondiciones(){
		$('#gridEstadosMunLoc').show();
		$('#grabarEdo').show();
		$('#gridDestino').show();
		$('#grabarDest').show();
		$('#gridActividades').show();
		$('#grabarAct').show();
		$('#condiciones').show();
		
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
					switch(condicionesDes.clasificacion){
						case "C":
							$('#clasificacion').val('C');
							$('#clasificacionComer').attr('checked',true);
							$('#clasificacionHipo').attr('checked',false);
							$('#clasificacionConsu').attr('checked',false);
							$('#clasificacionNo').attr('checked',false);
						break;
						case "O":
							$('#clasificacion').val('O');
							$('#clasificacionConsu').attr('checked',true);
							$('#clasificacionHipo').attr('checked',false);
							$('#clasificacionComer').attr('checked',false);
							$('#clasificacionNo').attr('checked',false);
						break;
						case "H":
							$('#clasificacion').val('H');
							$('#clasificacionHipo').attr('checked',true);
							$('#clasificacionConsu').attr('checked',false);
							$('#clasificacionComer').attr('checked',false);
							$('#clasificacionNo').attr('checked',false);
						break;
						case "N":
							$('#clasificacion').val('N');
							$('#clasificacionNo').attr('checked',true);
							$('#clasificacionHipo').attr('checked',false);
							$('#clasificacionConsu').attr('checked',false);
							$('#clasificacionComer').attr('checked',false);
						break;
						default:
							$('#clasificacion').val('N');
							$('#clasificacionNo').attr('checked',true);
							$('#clasificacionHipo').attr('checked',false);
							$('#clasificacionConsu').attr('checked',false);
							$('#clasificacionComer').attr('checked',false);
					}
					
					habilitaBoton('grabarCte', 'submit');
					$('#monedaID').removeAttr('disabled');
					$('#lineaFondeoIDCte').val(numLineaFondeo);
					$('#montoMaximo').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#montoMinimo').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#montoMinimo').val(condicionesDes.maxDiasMora);
				}else{
					inicializarFormularioDesctoCte(); 
					habilitaBoton('grabarCte', 'submit');
					$('#monedaID').removeAttr('disabled');
					$('#lineaFondeoIDCte').val(numLineaFondeo);
				}    						
			});
		}
	}
	
function consultaConDesctoClienLinFon(numLineaFondeo) {	
		var beanConsulta = {  
				'lineaFondeoIDCte':numLineaFondeo,
		};
		setTimeout("$('#cajaLista').hide();", 200);		 
		esTab = true;
		if(numLineaFondeo != '' && !isNaN(numLineaFondeo) && esTab){
			condicionesDesctoCteLinFonServicio.consulta(2,beanConsulta,function(condicionesDes) {
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
					switch(condicionesDes.clasificacion){
						case "C":
							$('#clasificacion').val('C');
							$('#clasificacionComer').attr('checked',true);
							$('#clasificacionHipo').attr('checked',false);
							$('#clasificacionConsu').attr('checked',false);
							$('#clasificacionNo').attr('checked',false);
						break;
						case "O":
							$('#clasificacion').val('O');
							$('#clasificacionConsu').attr('checked',true);
							$('#clasificacionHipo').attr('checked',false);
							$('#clasificacionComer').attr('checked',false);
							$('#clasificacionNo').attr('checked',false);
						break;
						case "H":
							$('#clasificacion').val('H');
							$('#clasificacionHipo').attr('checked',true);
							$('#clasificacionConsu').attr('checked',false);
							$('#clasificacionComer').attr('checked',false);
							$('#clasificacionNo').attr('checked',false);
						break;
						case "N":
							$('#clasificacion').val('N');
							$('#clasificacionNo').attr('checked',true);
							$('#clasificacionHipo').attr('checked',false);
							$('#clasificacionConsu').attr('checked',false);
							$('#clasificacionComer').attr('checked',false);
						break;
						default:
							$('#clasificacion').val('N');
							$('#clasificacionNo').attr('checked',true);
							$('#clasificacionHipo').attr('checked',false);
							$('#clasificacionConsu').attr('checked',false);
							$('#clasificacionComer').attr('checked',false);
					}
					habilitaBoton('grabarCte', 'submit');
					$('#monedaID').removeAttr('disabled');
					$('#lineaFondeoIDCte').val(numLineaFondeo);
					$('#montoMaximo').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#montoMinimo').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				}else{
					inicializarFormularioDesctoCte(); 
					habilitaBoton('grabarCte', 'submit');
					$('#diasGraIngCre').val('');
					$('#monedaID').val('');
					$('#monedaID').removeAttr('disabled');
					$('#lineaFondeoIDCte').val(numLineaFondeo);
				}    						
			});
		}
	}

	function inicializarFormularioDesctoCte() {	
		$('#montoMinimo').val("");
		$('#montoMaximo').val("");
		$('#estadoCivil').val('');
		$('#maxDiasMora').val('');
		consultaproductosCreAplica();
	}
	function inicializarFormularioDesctoCte1() {	
		inicializaForma('formaGenerica1','lineaFondeoIDCte' );
		$('#diasGraIngCre').val('');
		$('#monedaID').val('');
		$('#montoMinimo').val('');
		$('#montoMaximo').val('');
		$('#estadoCivil').val('');
		$('#generoIndistinto').attr('checked',true);
		$('#generoFemenino').attr('checked',false);
		$('#generoMasculino').attr('checked',false);
		$('#maxDiasMora').val('');
		$('#clasificacionComer').attr('checked',false);
		$('#clasificacionHipo').attr('checked',false);
		$('#clasificacionConsu').attr('checked',false);
		$('#clasificacionNo').attr('checked',true);
		$('#clasificacion').val("N");
		consultaproductosCreAplica();
	}
	
	function consultaproductosCreAplica(){
		var tipoCon=2;
		dwr.util.removeAllOptions('productosCre');
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
		$('#clasificacionComer').attr('checked',false);
		$('#clasificacionHipo').attr('checked',false);
		$('#clasificacionConsu').attr('checked',false);
		$('#clasificacionNo').attr('checked',true);
		$('#clasificacion').val("N");
	}
	
	function validaCtaNostroExiste(numCta,institID){
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
  			 		
  			cuentaNostroServicio.consultaExisteCta(4,CtaNostroBeanCon, function(ctaNostro){
  				  				
  				if(ctaNostro!=null){   				

					var estatuscta=ctaNostro.estatus;
					 nombreInsti=$('#nombreInstitucion').val();
					
	  				if(estatuscta =='A'){
  					$('#cuentaClabe').val(ctaNostro.cuentaClabe);  				
	  				}
	  				else if(estatuscta =='I'){
	  					mensajeSis("El Número de Cuenta Bancaria esta Inactiva");
						$('#numCtaInstit').focus();
						$('#numCtaInstit').val('');
						$('#cuentaClabe').val('');
	  				}
  				}
  				else{
  					mensajeSis("El Número de Cuenta No Existe");
  					$('#numCtaInstit').focus();
					$('#numCtaInstit').val('');
  					$('#cuentaClabe').val('');
  				} 
  			});
  		}
  	}
	function validaGrids(){
		if($('#reqIntegra').val()=='N'){
			if($('#actividadBMXID1').val()!=''||$('#destinoCreID1').val()!=''||$('#estadoID1').val()!=''||$('#numHabitantesInf').val()!=''||$('#numHabitantesSup').val()!=''
				||$('#municipioID1').val()!=''||$('#diasGraIngCre').val()!=''||$('#monedaID').val()!=0||$('#montoMinimo').val()!=''||$('#montoMaximo').val()!=''||
				$('#maxDiasMora').val()!=''){
				mensajeSis("Para indicar que la Línea de Fondeo No Requiere Integración debe eliminar las Condiciones de Integración");
				$('#reqIntegra').val('S');
				mostrarGridsCondiciones();
			}else{
				ocultaGridsCondiciones();
				$('#reqIntegra').val('N');
			}
		}else{
			mostrarGridsCondiciones();
		}
	}
	
	function validaRevolvencia(){
		if($('#esRevolvente').val()== 'N'){
			$('#tipoRevolvencia').val('N');
		}else{
			$('#tipoRevolvencia').val('P');
		}
	}
	
	$('#tasaBase').blur(function() {
		if ($('#tasaBase').val() != 0) {
			consultaTasaBase(this.id, true);
		} else {
			hayTasaBase = false;
			$('#tasaBase').val('');
			$('#desTasaBase').val('');
			$('#tasaPasiva').val('').change();
		}
	});
	$('#tasaBase').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			lista('tasaBase', '2', '1', 'nombre', $('#tasaBase').val(), 'tasaBaseLista.htm');
		}
	});

	$('#calcInteresID').change(function() { 
		if($('#calcInteresID').val()!= "1" ){	
			$('#tasaBase').attr('readOnly',false);
		}else{
			$('#tasaBase').attr('readOnly',true);
		}
	});
	
	
//	FIN------------- funciones para grid de condiciones de descuento, clientes----------------
}); // fin del Ready
var numeroPoliza;
var botonClicModificar = 0;

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
	agregaFormatoControles('formaGenerica');
}
function funcionFalloCondCte(){
}
function funcionExitoLineaFond(){
	habilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	if(botonClicModificar == "0" ){
		numeroPoliza = $('#campoGenerico').val(); // se obtiene el numero de poliza generado en el proceso
		if(numeroPoliza>0){
			$('#impPoliza').show();
			$('#enlace').attr('href');
			habilitaBoton('impPoliza', 'submit');
		}
	}else{
		if(botonClicModificar == "1" ){
			ocultarBotonPoliza();
		}
	}
	inicializaForma('formaGenerica', 'lineaFondeoID');
	$('#tipoRevPago').click();
	$('#refinanciamiento').val('N');
}
function funcionFalloLineaFond(){
	ocultarBotonPoliza();	
}

//funcion para ocultar poliza
function ocultarBotonPoliza(){
	botonClicModificar = "1";
	$('#impPoliza').hide();
	$('#enlace').removeAttr('href');
	deshabilitaBoton('impPoliza', 'submit');
	numeroPoliza = 0;
}
function consultaComboCalInteres() {
	$('#calcInteresID').trigger('change');
	$('#calcInteresID').change();
	if($('#calcInteresID').val()!= "1" ){	
			$('#tasaBase').attr('readOnly',false);
		}else{
			$('#tasaBase').attr('readOnly',true);
		}
}
function consultaSICParam() {
	var parametrosSisCon = {
		'empresaID' : 1
	};
	setTimeout("$('#cajaLista').hide();", 200);
	parametrosSisServicio.consulta(1, parametrosSisCon, function(parametroSistema) {
		if (parametroSistema != null) {
			manejaCarAgro = parametroSistema.manejaCarAgro;
			if(manejaCarAgro=='S'){
				mostrarElementoPorClase('carteraAgro','S');
			} else {
				mostrarElementoPorClase('carteraAgro','N');
			}
		}
	});
}
function consultaTasaBase(idControl, desdeInput) {
	var jqTasa = eval("'#" + idControl + "'");
	var tasaBase = $(jqTasa).asNumber();
	var TasaBaseBeanCon = {
		'tasaBaseID' : tasaBase
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if (tasaBase > 0 && esTab) {
		tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
			if (tasasBaseBean != null) {
				hayTasaBase = true;
				$('#desTasaBase').val(tasasBaseBean.nombre);
				valorTasaBase = tasasBaseBean.valor;
				if (desdeInput) {
					$('#tasaPasiva').val(valorTasaBase).change();
				}
				$('#tasaPasiva').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 4
				});
			} else {
				hayTasaBase = false;
				mensajeSis("No Existe la Tasa Base.");
				$('#tasaBase').focus();
				$('#tasaBase').val('');
				$('#desTasaBase').val('');
				$('#tasaPasiva').val('').change();
			}
		});
	}

}
function buscarMoneda(monedaID) {
	var monedaid = eval("'#" + monedaID + "'");
	var monedaNum = $(monedaid).val();
	if(monedaNum >0 && esTab) {

		monedasServicio.consultaMoneda(2,monedaNum,function(moneda) {
			if (moneda != null) {

				$('#descripcionMoneda').val(moneda.descripcion);
				
			} else {
				mensajeSis("No Existe la Moneda.");
				$('#monedaID2').focus();
				$('#monedaID2').val('');
				$('#descripcionMoneda').val('');
			}
		});
		
	}
}