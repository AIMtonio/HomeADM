$(document).ready(function() {
	esTab = true;
	// Definicion de Constantes y Enums
	limpiarFormulario();
	var tipoTransaccion = {
			'grabar':1

	};
	var catTipoConsultaInstitucion = {
			'principal':1 

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
     			'Exito','Error'); 
		}
   });			

	$('#institNominaID').bind('keyup',function(e) {
		lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function(){
		validaInstitucionNomina(this.id);
	});
	
	$('#convenioNominaID').change(function(){
		consultaTipoEmpleadoConv();
	});
	
	$('#grabar').click(function(){
		validaVacios();
		$('#tipoTransaccion').val(tipoTransaccion.grabar);
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
		 
	 	 $('#gridTipoEmpleadosConvenio').html("");
		 $('#gridTipoEmpleadosConvenio').hide();

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
	 		var tipoLista =2;
	 		bean = {
	 			'institNominaID': institNominaID
	 		};
	 		
	 		dwr.util.removeAllOptions('convenioNominaID'); 
	 		dwr.util.addOptions('convenioNominaID', {0:'SELECCIONAR'}); 

	 		conveniosNominaServicio.listaCombo(tipoLista, bean,function(convenios){
	 			if(convenios !=''){
	 				dwr.util.addOptions('convenioNominaID', convenios, 'convenioNominaID', 'descripcion');		
	 			}
	 		});
	 	}
	 	
	 	 function consultaTipoEmpleadoConv(){
	 	    var inst=$('#institNominaID').val();
	 	    var convenio=$('#convenioNominaID').val();

	 	    if (inst == ''){
	 	      mensajeSis("Especifique la Empresa Nómina");
	 	      $('#institNominaID').focus();
	 	      $('#gridTipoEmpleadosConvenio').html("");
	 	      $('#gridTipoEmpleadosConvenio').hide();
	 	      deshabilitaBoton('grabar');
	 	    }else if(convenio == '' || convenio == 0){
	 	      mensajeSis("Especifique el Número de Convenio");
	 	      $('#convenioNominaID').focus();
	 	      $('#gridTipoEmpleadosConvenio').html("");
	 	      $('#gridTipoEmpleadosConvenio').hide();
	 	      deshabilitaBoton('grabar');
	 	    }
	 	    else if(inst != '' && convenio != ''){

	 	      habilitaBoton('grabar');
	 	      var params = {};
	 	      params['tipoLista'] = 1;
	 	      params['institNominaID'] = inst;
	 	      params['convenioNominaID'] = convenio;

	 	      $.post("tiposEmpleadosConvGrid.htm", params, function(data){
	 	        if(data.length) {
	 	          $('#gridTipoEmpleadosConvenio').html(data);
	 	          $('#gridTipoEmpleadosConvenio').show();
	 	          seleccionaCheck();
	 	        }else {
	 	          $('#gridTipoEmpleadosConvenio').html("");
	 	          $('#gridTipoEmpleadosConvenio').show();
	 	        }
	 	      });
	 	    }

	 	  }
	
	


	});//	Fin de las validaciones 





    function seleccionaCheck(){
		$('input[name=listaSeleccionado]').each(function(x,y) {	
			var numero= x+1;			
			var varSeleccionado = $("#seleccionado"+numero).val();

			if(varSeleccionado == 'S' ) {
				$("#seleccionaCheck"+numero).attr('checked', true);
				$('#sinTratamiento'+numero).attr('readonly', true);
				$('#conTratamiento'+numero).attr('readonly', true);
			}else{
				$("#seleccionaCheck"+numero).attr('checked', false);
				$('#sinTratamiento'+numero).attr('readonly', false);
				$('#conTratamiento'+numero).attr('readonly', false);
			}

		});	
	}

/*
 * Función para verificar los Checks seleccionados
 */
function verificaCheck(idControl){
	var total = 0;
	
	var jqSelecciona = "";
	var varSeleccion = "";
	var numero = 0;
	$('#numSeleccion').val(0);

    $('input[name=seleccionaCheck]').each(function(x, y) {
		jqSelecciona= eval("'#" + this.id + "'");
		varSeleccion = this.id;
		seleccion = x+1;

		numero = x+1;
	
		if ($("#seleccionaCheck"+numero).is(":checked")){ 
			total = total + 1;		
			$('#seleccionado'+numero).val('S');
			$('#numSeleccion').val(total);		
			$('#sinTratamiento'+numero).attr('readonly', false);
			$('#conTratamiento'+numero).attr('readonly', false);
		}
		else{			
			$('#conTratamiento'+numero).val('0.0'); 
			$('#sinTratamiento'+numero).val('0.0'); 	
			$('#sinTratamiento'+numero).attr('readonly', true);
			$('#conTratamiento'+numero).attr('readonly', true);
			$('#seleccionado'+numero).val('N');
		}
	});
   
	if($('#numSeleccion').val() > 0){
			habilitaBoton('grabar');
	}else{
		deshabilitaBoton('grabar');
	}
}

/**
 * Función para Seleccionar Todos
 */
function seleccionarTodos(){
	var contador = 0;	
	if($("#seleccionaTodos").is(':checked')) {   	
		$('input[name=seleccionaCheck]').each(function(x, y){		
			numero= x+1;
			contador = contador +1;
			$('#seleccionaCheck'+numero).attr('checked', true);
			$('#seleccionado'+numero).val('S');
			$('#numSeleccion').val(contador);		
			$('#sinTratamiento'+numero).attr('readonly', false);
			$('#conTratamiento'+numero).attr('readonly', false);
		});	  
		habilitaBoton('grabar');

	}else{ 
		$('input[name=seleccionaCheck]').each(function(x, y) {		
			numero= x+1;
			contador = contador +1;
			$('#seleccionaCheck'+numero).attr('checked', false);
			$('#seleccionado'+numero).val('N');
			$('#numSeleccion').val(0);
			$('#conTratamiento'+numero).val('0.0'); 
			$('#sinTratamiento'+numero).val('0.0'); 	
			$('#sinTratamiento'+numero).attr('readonly', true);
			$('#conTratamiento'+numero).attr('readonly', true);
			
		});	 	
		deshabilitaBoton('grabar');
	}  
}


	

	 function validaSinTratamiento(idControl){

	 	var numero = idControl.substr(14,idControl.length);
		var valorCampo1 = $('#sinTratamiento'+numero).asNumber();
		var valorCampo2 = $('#seleccionado'+numero);
		var campo = eval("'#sinTratamiento"+numero+"'");
				if (valorCampo2.val()==('S')){
                    
				if(valorCampo1 == 0 || valorCampo1 < 0 ){
					$('#sinTratamiento'+numero).val("");
					mensajeSis("El campo Sin Tratamiento se encuentra vacío");
					$('#sinTratamiento'+numero).focus();
					$('#sinTratamiento'+numero).select();

	 			}else{
	 				$(campo).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	 			}
			}
	 	
	 }

	

	 function validaConTratamiento(idControl){
		var numero = idControl.substr(14,idControl.length);
		var valorCampo1 = $('#conTratamiento'+numero).asNumber();
		
		var valorCampo2 = $('#seleccionado'+numero);
		var campo = eval("'#conTratamiento"+numero+"'");

				if (valorCampo2.val()==('S')){
                    
				if(valorCampo1 == 0 || valorCampo1 < 0 ){
					$('#conTratamiento'+numero).val("");
					mensajeSis("El campo Con Tratamiento se encuentra vacío");
					$('#conTratamiento'+numero).focus();
					$('#conTratamiento'+numero).select();

	 			}else{
	 				$(campo).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	 			}
			}
	 }



	 /**
	 * Función para validar que la información del grid no se encuentren vacíos
	 */
	function validaVacios() {

		$('input[name=listaSeleccionado]').each(function() {
            numero= this.id.substr(12,this.id.length);
			varSeleccionado = eval("'#seleccionado"+numero+"'");
        			if($(varSeleccionado).val() == 'S'){
						var numSelecST = $('#sinTratamiento'+numero).val();
						if(numSelecST == 0){
							mensajeSis("Campo Sin Tratamiento Vacío");
							$('#sinTratamiento'+numero).focus();
							$('#sinTratamiento'+numero).select();
							return 0;
						}

					  var numSelecCT = $('#conTratamiento'+numero).val();
						if(numSelecCT == 0){
							mensajeSis("Campo Con Tratamiento Vacío");
							$('#conTratamiento'+numero).focus();
							$('#conTratamiento'+numero).select();
							return 0;
						}

				}
		});
	}

	
	function limpiarFormulario(){
		 $('#institNominaID').focus();
		 $('#convenioNominaID').val('');
		 $('#descripcion').val('');
		 $('#gridTipoEmpleadosConvenio').html("");
		 $('#gridTipoEmpleadosConvenio').hide();
		  deshabilitaBoton('grabar');
	}
	
	function Exito(){
		 $('#institNominaID').focus();
		 $('#convenioNominaID').val('');
		 $('#descripcion').val('');
		 $('#gridTipoEmpleadosConvenio').html("");
		 $('#gridTipoEmpleadosConvenio').hide();
		  deshabilitaBoton('grabar');
		
	}

	function Error(){
		
	}