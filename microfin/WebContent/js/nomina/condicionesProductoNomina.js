var parametroBean = consultaParametrosSession();
var catTipoConsultaParam = {
			'principal':1

	};
var conveniosCombo = {};

$(document).ready(function() {
	var cantFilas;
	var perfil;
	agregaFormatoControles('formaGenerica');
	esTab = true;
	
	limpiarFormulario();
	
	$('#institNominaID').focus();
	
	var tipoTransaccion = {
			'grabar':1,
			'grabarTasa':2,

	};


	
	var catTipoConsultaInstitucion = {
			'principal':1

	};
	var catTipoConCalend = {
			'conEstatus':2

	};
	
	

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
     	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','institNominaID',
     			'funcionExito','Error'); 
		}
   });			

	$('#institNominaID').bind('keyup',function(e) {
		lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function(){
		validaInstitucionNomina(this.id);
	});
	
	$('#convenioNominaID').blur(function(){
		$('#contenedorProductosCred').hide();
		$('#formaTablaCred').html('');
		$('#contenedorEsqTasa').hide();
		$('#formaTablaEsqTasa').html('');
		
		if( $('#institNominaID').val() != '' && $('#convenioNominaID option:selected').val() != ''
			&& $('#convenioNominaID').val() != '' && $('#convenioNominaID').val() != 0) {
			listaGridProductosCred();
		} 
		
	});


	
	$('#grabaCred').click(function(event){
		 validaVacios();
		$('#tipoTransaccion').val(tipoTransaccion.grabar);

		event.preventDefault();
			if ($("#formaGenerica").valid()) {
			if(existePepetidos()){
				mensajeSis('El producto de Credito ya existe');
			return;
			}
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'institNominaID', 'funcionExitoProduc', 'funcionError');
		}
	});

	$('#grabaEsqTasa').click(function(event){
		$('#tipoTransaccion').val(tipoTransaccion.grabarTasa);
		event.preventDefault();
		if ($("#formaGenerica").valid()) {
			if(existeRepetidosEsquemaTasa()){
				mensajeSis('No pueden existir más de un esquema de tasa con los mismos valores');
				return;
			}
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'institNominaID', 'funcionExitoTasa', 'funcionError');
		}
	});
	
	

	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			institNominaID: {
				required: true		
			},
			convenioNominaID: {
				required: true		
			}
		},
	
		messages : {
			institNominaID : {
				required : 'Especifique Empresa de Nómina.'
			},
			convenioNominaID: {
				required : 'Especifique el Número de Convenio.'	
			}
		
		}
	});
		

	// ------------ Validaciones de Institución de Nómina-------------------------------------
	
	 function validaInstitucionNomina(idControl) {
		 
	 	 $('#gridCalendarioIngresos').html("");
		 $('#gridCalendarioIngresos').hide();

		var jqInstitucion  = eval("'#" + idControl + "'");
		var numInstitucion = $(jqInstitucion).val();
		if(numInstitucion != '' && !isNaN(numInstitucion) && esTab){
		var institNominaBean = {
				'institNominaID': numInstitucion						
		};
		

			institucionNomServicio.consulta(catTipoConsultaInstitucion.principal,institNominaBean,function(institucionNomina) {
			if(institucionNomina!=null){
				if(institucionNomina.estatus == 'B'){
					mensajeSis("La Empresa de Nómina se Encuentra Cancelada");
					$('#institNominaID').focus();
					$('#institNominaID').val('');
					$('#descripcion').val('');
					$('#convenioNominaID').val('');
				
				}
				else {
				$('#descripcion').val(institucionNomina.nombreInstit);
				consultaConveniosEmpresaNomina();
				}
			}else{
				mensajeSis("El Número de Empresa de Nómina No Existe");
				limpiarFormulario();
				$('#institNominaID').focus();
				$('#institNominaID').val('');
				
				}
			});	
			}
		}
	 
	 /**
	 	 * Consulta de Convenios de Empresa de Nómina
	 	 */
	 	function consultaConveniosEmpresaNomina() {

	 		
	 		var institNominaID = $('#institNominaID').val();
	 		var tipoLista =10;
	 		bean = {
	 			'institNominaID': institNominaID
	 		};
	 		
	 		dwr.util.removeAllOptions('convenioNominaID'); 
	 		dwr.util.addOptions('convenioNominaID', {0:'SELECCIONAR'}); 

	 		conveniosNominaServicio.listaCombo(tipoLista, bean,function(convenios){
	 			if(convenios !=''){
	 				conveniosCombo = convenios;
	 				dwr.util.addOptions('convenioNominaID', convenios, 'convenioNominaID', 'descripcion');	
	 			}
	 		});
	 	}
	 	
	 	

	});//	Fin de las validaciones 

function listaGridProductosCred() {
	 		$('#contenedorEsqTasa').hide();
	 		$('#formaTablaEsqTasa').html('');
	 	
	 		var params = {};
	 		params['institNominaID'] = $('#institNominaID').val();
	 		params['convenioNominaID'] = $('#convenioNominaID option:selected').val();
	 		params['tipoLista'] = 1;
	 		$.post("condicionesProdNomCredGridVista.htm", params, function(data) {
	 			if(data.length > 0) {
	 				$('#formaTablaCred').html(data);
	 				$('#filtroEstatusCred').val('VP');
	 				$('#contenedorProductosCred').show();
	 				$('#formaTablaCred').show();
	 				if($('#numeroRegistrosCred').val() <= 0) {
	 					$('#grabaCred').hide();
	 				}else{
	 					$('#grabaCred').show();
	 				}
				    validaCobroMora();
	 			} else {
	 				mensajeSis("Error al generar la lista de condiciones de crédito");
	 				$('#contenedorProductosCred').hide();
	 			}
	 		}).fail(function() {
	 			mensajeSis("Error al generar el grid de condiciones de crédito");
	 			$('#contenedorProductosCred').hide();
	 		});
	 	}

function existeRepetidosEsquemaTasa(){
	var tamanio = $('#numeroFilaEsqTasa').asNumber();
	for(var j= 1; j <= tamanio ; j ++){
		for(var i = 1; i <= tamanio ; i ++){
			
			if($('#renglonEsqTasa' + i).val() != undefined && $('#renglonEsqTasa' + j).val() != undefined){
				
				if( i != j &&  $('#lisTipoEmpleadoIDEsqTasa' + j).val() == $('#lisTipoEmpleadoIDEsqTasa' + i).val()
						&& $('#lisSucursalID' + j).val() == $('#lisSucursalID' + i).val()
						&& $('#lisPlazoIDEsqTasa' + j).val() == $('#lisPlazoIDEsqTasa' + i).val()
						&& $('#lisMinCredEsqTasa' + j).val() == $('#lisMinCredEsqTasa' + i).val()
						&& $('#lisMaxCredEsqTasa' + j).val() == $('#lisMaxCredEsqTasa' + i).val()
						&& $('#lisMontoMinEsqTasa' + j).val() == $('#lisMontoMinEsqTasa' + i).val()
						&& $('#lisMontoMaxEsqTasa' + j).val() == $('#lisMontoMaxEsqTasa' + i).val()
						&& $('#lisTasaEsqTasa' + j).val() == $('#lisTasaEsqTasa' + i).val()){
					return true;
				}
			}
			
		}
	}
	
	return false;
}

function existePepetidos(){
	var tamanio = $('#numeroFilaCred').asNumber();
	for(var i= 1; i <= tamanio ; i ++){
		for(var j = 1; j <= tamanio ; j ++){
			if($('#renglonCred' + i).val() != undefined && $('#renglonCred' + j).val() != undefined ){
				var productoX = $('#lisProducCreditoID' + i).val();
				var productoY =  $('#lisProducCreditoID' + j).val();
				if(productoX == productoY && i != j){	
						return true;
				}
			}
		}
	}
	return false;
}


 /**
	 * Función para validar que la información del grid no se encuentren vacíos
	 */
	function validaVacios() {

		$('tr[name=renglonCred]').each(function() {
            numero= this.id.substr(11,this.id.length);
			var produc = eval("'#lisProducCreditoID"+numero+"'");
			var valorT = eval("'#lisValorTasaCred"+numero+"'");
        			if($(produc).val() == 0 && $(valorT).val() == ''){
					       if($(valorT).val() != '' )
					       {
							mensajeSis("El Producto de Crédito está Vacío");
							$(produc).focus();
							$(produc).select();
							return 0;
						   }else { 
						   mensajeSis("El valor Tasa está Vacío");
							$(valorT).focus();
							$(valorT).select();
						  return 0;}
						}
				
		});
	}


function reasignarTabIndex(){
	var numTab = 3;

	/* asignar tabindex a grid condiciones de credito */
	numTab++;
	$('#agregarCondCred').attr("tabindex", numTab);
	numTab++;
	$('#filtroEstatusCred').attr("tabindex", numTab);
	$('#tablaGridCred tr').each(function(index) {
		if(index > 0){
			numTab++;
		
			$('#' + $(this).find("select[name^='lisProducCreditoID']").attr('id')).attr('tabindex' , numTab);
			numTab++;
			$('#' + $(this).find("select[name^='lisTipoTasaCred']").attr('id')).attr('tabindex' , numTab);
			numTab++;
			$('#' + $(this).find("input[name^='lisValorTasaCred']").attr('id')).attr('tabindex' , numTab);
			numTab++;
			$('#' + $(this).find("input[name^='agregarCred']").attr('id')).attr('tabindex' , numTab);
			numTab++;
			$('#' + $(this).find("input[name^='cancelarCred']").attr('id')).attr('tabindex' , numTab);
		}
	});
	if($('#btnAnteriorCred').length){
		numTab++;
		$('#btnAnteriorCred').attr('tabindex' , numTab);
		validaCobroMora();
	}
	if($('#btnSiguienteCred').length){
		numTab++;
		$('#btnSiguienteCred').attr('tabindex' , numTab);
		validaCobroMora()
	}
	numTab++;
	$('#grabaCred').attr("tabindex", numTab);
	

	/* asignar tabindex a esquemas de tasas*/
	
	numTab++;
	$('#agregarEsqTasaCred').attr("tabindex", numTab);
	numTab++;
	$('#tablaGridEsqTasa tr').each(function(index) {
		if (index > 0) {
			numTab++;
			$('#'+ $(this).find("input[name^='lisEsqTasaCredID']").attr('id')).attr('tabindex', numTab);
			numTab++;
			$('#'+ $(this).find("select[name^='lisTipoEmpleadoIDEsqTasa']").attr('id')).attr('tabindex', numTab);
			numTab++;
			$('#'+ $(this).find("select[name^='lisSucursalID']").attr('id')).attr('tabindex', numTab);
			numTab++;
			$('#'+ $(this).find("select[name^='lisPlazoIDEsqTasa']").attr('id')).attr('tabindex', numTab);
			numTab++;
			$('#'+ $(this).find("input[name^='lisMinCredEsqTasa']").attr('id')).attr('tabindex', numTab);
			numTab++;
			$('#'+ $(this).find("input[name^='lisMaxCredEsqTasa']").attr('id')).attr('tabindex', numTab);
			numTab++;
			$('#'+ $(this).find("input[name^='lisMontoMinEsqTasa']").attr('id')).attr('tabindex', numTab);
			numTab++;
			$('#'+ $(this).find("input[name^='lisMontoMaxEsqTasa']").attr('id')).attr('tabindex', numTab);
			numTab++;
			$('#'+ $(this).find("input[name^='lisTasaEsqTasa']").attr('id')).attr('tabindex', numTab);
			numTab++;
			$('#'+ $(this).find("input[name^='agregarEsqTasa']").attr('id')).attr('tabindex', numTab);
			numTab++;
			$('#'+ $(this).find("input[name^='eliminarEsqTasa']").attr('id')).attr('tabindex', numTab);
		}
	});
	if ($('#btnAnteriorEsqTasa').length) {
		numTab++;
		$('#btnAnteriorEsqTasa').attr('tabindex', numTab);
	}
	if ($('#btnSiguienteEsqTasa').length) {
		numTab++;
		$('#btnSiguienteEsqTasa').attr('tabindex', numTab);
	}
	numTab++;
	$('#grabaEsqTasa').attr("tabindex", numTab);
}


	
	function limpiarFormulario(){
		 $('#institNominaID').focus();
		 $('#convenioNominaID').val('');
		 $('#descripcion').val('');	
		  
	}
	
	//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
	function funcionExitoTasa() {
		agregaFormatoControles('formaGenerica');
	    $('#formaTablaEsqTasa').hide();
	     $('#contenedorEsqTasa').hide();
	    deshabilitaBoton('grabaEsqTasa');
	     listaGridProductosCred();
	}

	function funcionExitoProduc() {
		agregaFormatoControles('formaGenerica');
	    $('#formaTablaEsqTasa').hide();
	   
	     $('#contenedorEsqTasa').hide();
	     $('#convenioNominaID').val("");
        
	      $('#formaTablaCred').hide();
	   
	     $('#contenedorProductosCred').hide();
	    deshabilitaBoton('grabaEsqTasa');  
	}

	//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
	function funcionError() {
		agregaFormatoControles('formaGenerica');
	
		
	} 
	
	function validaCobroMora()
	{   
		var convenioID = $('#convenioNominaID').val();
		var convenioLista = conveniosCombo.find(c=>c.convenioNominaID == convenioID);
		if(convenioLista.cobraMora=='N')
		{
		var length =	$('select[name ="lisTipoCobMora"]').length;
		for(var i=1;i<=length;i++)
		{
			dwr.util.addOptions('lisTipoCobMora'+i, {'-1':'No cobra'});
		}
		$('select[name ="lisTipoCobMora"]').val('-1');
		$('select[name ="lisTipoCobMora"]').attr('disabled','disabled');
		$('input[name ="lisValorMora"]').val('No cobra');
		$('input[name ="lisValorMora"]').attr('disabled','disabled');
		}
	   
	}
	
	
	
	