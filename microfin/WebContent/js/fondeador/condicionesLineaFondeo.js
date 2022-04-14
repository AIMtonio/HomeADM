$(document).ready(function() {
	esTab = true;
	//Definicion de Constantes y Enums  
	parametroBean = consultaParametrosSession();
	
	var catTipoTransaccionLineaCredit = {   
  		'agrega':1,
  		'actualiza':3	};
	
	var catTipoConsultaLineaCredit = {
  		'principal'	: 1,
  		'foranea'	: 2
	};
	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	 var formConDesCte =1;
	var botonClic = 0;
	deshabilitaBoton('modifica', 'submit');
	agregaFormatoControles('formaGenerica');
	ocultarBotonPoliza();

	inicializaForma('formaGenerica','lineaFondeoID' );
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
	      submitHandler: function(event) {
	    	  if(botonClic !=formConDesCte ){
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','lineaFondeoID','funcionExitoLinea','funcionFalloLinea');
	      }
	      }
	      
	   });				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#lineaFondeoID').blur(function() { 
		validaLineaFondeo(this.id); 
	});
	
	$('#institutFondID').blur(function() { 
		consultaInstitucionFondeo(this.id);
	});
	
	$('#tipoLinFondeaID').blur(function() {
		consultaTipoLinFondea(this.id);
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
	  
	
	
	$('#lineaFondeoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "descripLinea";
		camposLista[1] = "institutFondID";


		parametrosLista[0] = $('#lineaFondeoID').val();
		parametrosLista[1] = $('#institutFondID').val();
		
		lista('lineaFondeoID', '2', '2', camposLista, parametrosLista, 'listaLineasFondeador.htm');
	});
	
	
	
	$('#institutFondID').bind('keyup',function(e){
		 if(this.value.length >= 2 && isNaN($('#institutFondID').val())){
			 lista('institutFondID', '2', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
		 }
	});

	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionLineaCredit.actualiza);
		ocultarBotonPoliza();
	});	
	
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		listaAlfanumerica('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
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
//		
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
			montoAumentar: { 
				required: true,
				
			},
			
		
		},
		messages: {
			institutFondID: {
				required: 'Especificar Institución'
			},
			descripLinea: {
				required: 'Especificar Descripción',
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
			montoAumentar: {
				required: 'Especificar el Monto Aumentar'
			},
				
		}		
	});

//	------------ Validaciones de Controles -------------------------------------
	function validaLineaFondeo(control) {
		var numLinea = $('#lineaFondeoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var numInstitut = $('#institutFondID').val();
		esTab=true;
		if(numLinea != '' && !isNaN(numLinea) && esTab){
			if(numLinea=='0'){
				alert("No existe la línea de Fondeo");
				$('#lineaFondeoID').val("");
					$('#lineaFondeoID').focus();
					$('#descripLinea').val('');
					$('#institutFondID').val('');
					$('#tipoLinFondeaID').val('');
					$('#montoOtorgado').val('');
					$('#saldoLinea').val('');
					$('#fechInicLinea').val('');
					$('#fechaFinLinea').val('');
					$('#fechaMaxVenci').val('');
					$('#desTipoLinFondea').val('');
					deshabilitaBoton('modifica', 'submit');
				}else {
				var lineaFondBeanCon = { 
						'lineaFondeoID':$('#lineaFondeoID').val()
				};
				lineaFonServicio.consulta(4,lineaFondBeanCon,function(lineaFond) {
					if(lineaFond!=null){
						var lineafondeo = lineaFond.institutFondID;
						if(lineafondeo==numInstitut){ 
							$('#lineaFondeoID').val(lineaFond.lineaFondeoID);
							$('#descripLinea').val(lineaFond.descripLinea);
							$('#institutFondID').val(lineaFond.institutFondID);
							$('#tipoLinFondeaID').val(lineaFond.tipoLinFondeaID);
							consultaTipoLinFondea('tipoLinFondeaID');
							
							$('#montoOtorgado').val(lineaFond.montoOtorgado);
							$('#montoOtorgado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#saldoLinea').val(lineaFond.saldoLinea);
							$('#saldoLinea').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#montoAumentar').val('0.00');
							$('#fechInicLinea').val(lineaFond.fechInicLinea);
							$('#fechaFinLinea').val(lineaFond.fechaFinLinea);
							$('#fechaMaxVenci').val(lineaFond.fechaMaxVenci);
							$('#desTipoLinFondea').val('');
								habilitaBoton('modifica', 'submit');
						}else{
							alert("La línea de Fondeo no Corresponde con la Institución");
							$('#lineaFondeoID').val("");
	   						$('#lineaFondeoID').focus();
	   						$('#descripLinea').val('');
							$('#tipoLinFondeaID').val('');
							$('#montoOtorgado').val('');
							$('#saldoLinea').val('');
							$('#fechInicLinea').val('');
							$('#fechaFinLinea').val('');
							$('#fechaMaxVenci').val('');
							$('#desTipoLinFondea').val('');	
							$('#montoAumentar').val('');
							deshabilitaBoton('modifica', 'submit');
	   					
						
						}
					}else{
						alert("No Existe la Línea  de Fondeo");
   						$('#lineaFondeoID').val("");
   						$('#lineaFondeoID').focus();
   						$('#descripLinea').val("");
   						//$('#institutFondID').val('');
						$('#tipoLinFondeaID').val('');
						$('#montoOtorgado').val('');
						$('#saldoLinea').val('');
						$('#fechInicLinea').val('');
						$('#fechaFinLinea').val('');
						$('#fechaMaxVenci').val('');
						$('#desTipoLinFondea').val('');
						$('#montoAumentar').val('');
						deshabilitaBoton('modifica', 'submit');
					
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
					$('#impPoliza').hide();
				}else{
					alert("No Existe la Institución"); 
					$('#institutFondID').focus();
					$('#institutFondID').select();
					$('#institutFondID').val("");
					$('#lineaFondeoID').val("");
					$('#nombreInstitFondeo').val('');
					$('#descripLinea').val("");
					$('#institutFondID').val('');
					$('#tipoLinFondeaID').val('');
					$('#montoOtorgado').val('');
					$('#saldoLinea').val('');
					$('#fechInicLinea').val('');
					$('#fechaFinLinea').val('');
					$('#fechaMaxVenci').val('');
					$('#desTipoLinFondea').val('');	
					deshabilitaBoton('modifica', 'submit');
				
				}    						
			});
		}
	}


	function consultaTipoLinFondea(idControl) {
		var jqTipoLinea = eval("'#" + idControl + "'");
		var numTipoLinea = $(jqTipoLinea).val();	
		var numInstit =$('#institutFondID').val();

		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numTipoLinea != '' && !isNaN(numTipoLinea) ){
			tiposLineaFonServicio.consultaTiposInstitut(3,numTipoLinea,numInstit, function(tipoLinea) {
				if(tipoLinea!=null){	
					$('#desTipoLinFondea').val(tipoLinea.descripcion);
					$('#impPoliza').hide();
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

function funcionExitoLinea(){
	deshabilitaBoton('modifica', 'submit');
	$('#institutFondID').focus();
	$('#lineaFondeoID').val('');
	
	$('#tipoLinFondeaID').val('');
	$('#montoOtorgado').val('');
	$('#saldoLinea').val('');
	$('#fechInicLinea').val('');
	$('#fechaFinLinea').val('');
	$('#fechaMaxVenci').val('');
	$('#desTipoLinFondea').val('');	
	$('#montoAumentar').val('');
	//$('#nombreInstitFondeo').val('');
	$('#descripLinea').val('');
	numeroPoliza = $('#campoGenerico').val(); // se obtiene el numero de poliza generado en el proceso
	if(numeroPoliza>0){
		$('#impPoliza').show();
		$('#enlace').attr('href');
		habilitaBoton('impPoliza', 'submit');
	}
}
	
	

function funcionFalloLinea(){
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
