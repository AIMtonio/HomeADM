$(document).ready(function() {	
	//******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******//
	esTab = false;
	
	var numTransaccion = {
			'actualizar' : 3
	};
	    
	//******* FUNCIONES CARGA AL INICIAR PANTALLA *******//
	
    inicializaPantalla();
    $('#institucionID').focus();
    //PARAMETROS DE SESION
    var parametroBean = consultaParametrosSession();
	    
    //******* VALIDACIONES DE LA FORMA *******//

	$.validator.setDefaults({
	    submitHandler: function(event) { 	
		    grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','institucionID','funcionExito', 'funcionError');  
	     }
	});
	
	$('#formaGenerica').validate({
		rules: {
			institucionID: {
				required: true					
			},
			generaRefeDepRadio: {
				required: true	
			},
			algoritmoID: {
				required: function() { if($('#generaRefeDepSi').is(':checked')) return true; else return false;}
			},
			numContrato: {
				numeroPositivo: true
			},
			cveEmision: {
				numeroPositivo: true
			}
		},		
		messages: {
			institucionID: {
				required: 'Especifique la Institución.'
			},
			generaRefeDepRadio: {
				required: 'Especifique si Genera Referencia Depósitos.'
			},
			algoritmoID: {
				required: 'Seleccione el Algoritmo.'
			},
			numContrato: {
				numeroPositivo: 'Ingrese solo números'
			},
			cveEmision: {
				numeroPositivo: 'Ingrese solo números'
			}
		}
	});
	
	//******* MANEJO DE EVENTOS *******//
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#actualizar').click(function() {
		$('#tipoTransaccion').val(numTransaccion.actualizar);		
	}); 
	
	$('#generaRefeDepSi').click(function() {
		habilitaControl('algoritmoID');	
		$('#generaRefeDep').val('S');
		funcionCargaComboAlgoritmo($('#institucionID').val());
		$('tr[name=convenio]').attr('style','display:');
	}); 
	
	$('#generaRefeDepNo').click(function() {	
		$('#algoritmoID').val("");		
		deshabilitaControl('algoritmoID');	
		$('#generaRefeDep').val('N');

		dwr.util.removeAllOptions('algoritmoID');
		dwr.util.addOptions('algoritmoID', {'':'SELECCIONAR'});
		$('#numConvenio').val('');
		$('#convenioInter').val('');
		$('#numContrato').val('');
		$('#cveEmision').val('');
		$('tr[name=convenio]').attr('style','display : none');
	});


	// LISTA INSTITUCIONES
	$('#institucionID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombre";
		parametrosLista[0] = $('#institucionID').val();
		lista('institucionID', '2', '7', camposLista,parametrosLista, 'listaInstituciones.htm');		
	});	
	
	$('#institucionID').blur(function() {	

		setTimeout("$('#cajaLista').hide();", 200);	
		if(esTab){
			consultaInstitucion(this.id);  
		}
	 });

	//validamos que solo sean numeros y letras
	$('#numConvenio').bind('keypress', function(event) {
		  var regex = new RegExp("^[a-zA-Z0-9]+$");
		  var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);
		  if (!regex.test(key)) {
		    event.preventDefault();
		    return false;
		 }
		});

	$('#numConvenio').blur(function(){
		ponerMayusculas(this);
	});

	//validamos que solo sean numeros y letras
	$('#convenioInter').bind('keypress', function(event) {
		  var regex = new RegExp("^[a-zA-Z0-9]+$");
		  var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);
		  if (!regex.test(key)) {
		    event.preventDefault();
		    return false;
		 }
		});
	$('#convenioInter').blur(function(){
		ponerMayusculas(this);
	});


	//*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******//
	
	// FUNCION PARA CONSULTAR LA INSTITUCION	
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		
		var numConsulta = 1;
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		
		inicializaPantalla();
		if(numInstituto != '' && !isNaN(numInstituto) && numInstituto > 0){
			institucionesServicio.consultaInstitucion(numConsulta,InstitutoBeanCon,function(instituto){		
				if(instituto!=null){							
					$('#nombre').val(instituto.nombre);			
					$('#nombreCorto').val(instituto.nombreCorto);			
					$('#tipoInstitID').val(instituto.tipoInstitID);			
					$('#folio').val(instituto.folio);			
					$('#claveParticipaSpei').val(instituto.claveParticipaSpei);	
					$('#generaRefeDep').val(instituto.generaRefeDep);	
					$('#domicilia').val(instituto.domicilia);
					
					if(instituto.generaRefeDep == 'S'){
						$('#generaRefeDepSi').attr("checked",true);
						$('#numConvenio').val(instituto.numConvenio);
						$('#convenioInter').val(instituto.convenioInter);
						$('tr[name=convenio]').attr('style','display:');
						$('#numContrato').val(instituto.numContrato);
						$('#cveEmision').val(instituto.cveEmision);
					}else if(instituto.generaRefeDep == 'N'){
						$('#generaRefeDepNo').attr("checked",true);
						deshabilitaControl('algoritmoID');	
						dwr.util.removeAllOptions('algoritmoID');
						dwr.util.addOptions('algoritmoID', {'':'SELECCIONAR'});
						$('#numConvenio').val('');
						$('#convenioInter').val('');
						$('tr[name=convenio]').attr('style','display: none');
						$('#numContrato').val('');
						$('#cveEmision').val('');
					}
					
					if(instituto.domicilia == 'S'){
						$('#domiciliaSi').attr("checked",true);
						
					}else if(instituto.domicilia == 'N'){
						$('#domiciliaNo').attr("checked",true);
						
					}
					
					$('#algoritmoID').val(instituto.algoritmoID);
					habilitaBoton("actualizar");
					
				}else{
					mensajeSis("No existe la Institución"); 
					$(jqInstituto).val('');	
					$(jqInstituto).focus();	
					$('#nombre').val("");					
				}    						
			});
		}else{
			if(!isNaN(numInstituto)){
				mensajeSis("No existe la Institución"); 
				$(jqInstituto).val('');	
				$(jqInstituto).focus();	
				$('#nombre').val("");					
			}else{
				if(numInstituto == '' || numInstituto == 0){
					$(jqInstituto).val('');	
					$(jqInstituto).focus();	
					$('#nombre').val("");						
				}
			}
		}
	}	

});// FIN DOCUMENT READY


// FUNCIÓN CARGA TODAS LAS OPCIONES EN EL COMBO ALGORITMO
function funcionCargaComboAlgoritmo(institucionID){
	var numLista = 1;
	var beanCon ={
		'institucionID' : institucionID 
	};
	dwr.util.removeAllOptions('algoritmoID'); 
	institucionesServicio.listaComboAlg(numLista,beanCon, { async: false, callback:function(algoritmos){
		dwr.util.addOptions('algoritmoID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('algoritmoID', algoritmos, 'algoritmoID', 'nombreAlgoritmo');
	}});
}

// FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){	
	inicializaForma('formaGenerica','institucionID');
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('actualizar', 'submit');
	habilitaControl('algoritmoID');
	$('#generaRefeDepSi').attr("checked",false);
	$('#generaRefeDepNo').attr("checked",false);
	$('#tipoInstitID').val("");
	$('#algoritmoID').val("");
	$('#generaRefeDep').val("");
	funcionCargaComboAlgoritmo($('#institucionID').val());
	$('#numComvenio').val('');
	$('#convenioInter').val('');
	$('tr[name=convenio]').attr('style','display:none');
}

function validaNumero(e){
	var tecla = (document.all) ? e.keyCode : e.which;

	if(tecla==8){
		return true;
	}
	var teclasPermitidas = /[0-9]/;
	var teclaFinal = String.fromCharCode(tecla);
	return teclasPermitidas.test(teclaFinal);
}

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	inicializaPantalla();	
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
}
