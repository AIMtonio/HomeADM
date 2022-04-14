var parametroBean = consultaParametrosSession();
var catTipoConsultaParam = {
			'principal':1

	};
var estatusGuarda = false;
var sinInformacion	= false;
consultarPerfil();
$(document).ready(function() {
	var cantFilas;
	var perfil;
	agregaFormatoControles('formaGenerica');
	esTab = true;
	// Definicion de Constantes y Enums
	deshabilitaBoton('grabar','submit');
	deshabilitaBoton('autorizar','submit');
	deshabilitaBoton('desautorizar','submit');
	deshabilitaBoton('agregarInf');
	limpiarFormulario();
	llenarAnio();
	
	$('#usuarioID').val(parametroBean.numeroUsuario);
	
	var tipoTransaccion = {
			'grabar':1,
			'autorizar':2,
			'desautorizar':3

	};
	
	var catTipoConsultaInstitucion = {
			'principal':1

	};
	var catTipoConCalend = {
			'conEstatus':2

	};
	
	

	consultarPerfil();
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
		consultaReportaIncidencia();
		$('#gridCalendarioIngresos').html("");
		$('#gridCalendarioIngresos').show();
		$('#estatus').val('');
		$('#anio').val('');
	});

	$('#anio').change(function(){
		$('#estatus').val('');
	    llenarEstatusCalend();
		
	});	
    $('#estatus').change(function(){
		$('#estatus').val('');

	});

	 $('#grabar').click(function() {
            validaVacios();
		    $('#tipoTransaccion').val(tipoTransaccion.grabar);
	});

	$('#autorizar').click(function() {
			validaVacios();
		    $('#tipoTransaccion').val(tipoTransaccion.autorizar);
	});

	$('#desautorizar').click(function() {
			validaVacios();
		    $('#tipoTransaccion').val(tipoTransaccion.desautorizar);
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
	 	
		function llenarAnio() {
		
			 		var tipoLista =2;
			 		bean = {
				 			
				 		};
			 		dwr.util.removeAllOptions('anio'); 
			 		dwr.util.addOptions('anio', {0:'SELECCIONAR'}); 
		
			 		calendarioIngresosServicio.listaCombo(tipoLista,bean,function(anios){
		
			 			if(anios !=''){
			 			
			 				dwr.util.addOptions('anio', anios, 'anio', 'anio');		
			 			}
			 		});
			 	}
		
		function llenarEstatusCalend() {
			
	 		bean = {
	 				'institNominaID': $('#institNominaID').val(),
	 				'convenioNominaID': $('#convenioNominaID').val(),
	 				'anio': $('#anio').val()
	 				
		 		};
	 	 
	 		calendarioIngresosServicio.consulta(catTipoConCalend.conEstatus,bean,function(est){
	 			
	 			if(est !='' && est !=null ){
	 					$('#estatus').val(est.estatus);
	 					consultaCalendarioIngresos();
	 					
	 			}else{
	 				 deshabilitaBoton('grabar','submit');
		 	         $('#gridCalendarioIngresos').html("");
		 	         $('#gridCalendarioIngresos').show();
		 	         deshabilitaBoton('agregarInf','submit');
		 	         deshabilitaBoton('autorizar','submit');
		 	         deshabilitaBoton('desautorizar','submit');
	 			}
	 		});
	 	}
		
	 	 function consultaCalendarioIngresos(){
	        
		 	    var inst=$('#institNominaID').val();
		 	    var convenio=$('#convenioNominaID').val();
		 	    var anio=$('#anio').val();
		 	    var estatus=$('#estatus').val();
              
		 	    if (inst == ''){
		 	      mensajeSis("Especifique la Empresa Nómina");
		 	      $('#institNominaID').focus();
		 	      $('#gridCalendarioIngresos').html("");
		 	      $('#gridCalendarioIngresos').hide();
		 	      	deshabilitaBoton('autorizar','submit');
					deshabilitaBoton('desautorizar','submit');
					deshabilitaBoton('grabar','submit');
					deshabilitaBoton('agregarInf','submit');
		 	    
		 	    }else if(convenio == '' || convenio == 0){
		 	      mensajeSis("Especifique el Número de Convenio");
		 	      $('#convenioNominaID').focus();
		 	      $('#gridCalendarioIngresos').html("");
		 	      $('#gridCalendarioIngresos').hide();
		 	      	deshabilitaBoton('autorizar','submit');
					deshabilitaBoton('desautorizar','submit');
					deshabilitaBoton('grabar','submit');
					deshabilitaBoton('agregarInf','submit');
		 	   
		 	    }else if(anio == '' || anio == 0){
			 	      mensajeSis("Especifique el Año");
			 	      $('#anio').focus();
			 	      $('#gridCalendarioIngresos').html("");
			 	      $('#gridCalendarioIngresos').hide();
			 	    deshabilitaBoton('autorizar','submit');
					deshabilitaBoton('desautorizar','submit');
					deshabilitaBoton('grabar','submit');
					deshabilitaBoton('agregarInf','submit');

			 	     
			 	 }else if(estatus =='' ){
				 	      mensajeSis("Especifique el Estatus");
				 	      $('#estatus').focus();
				 	      $('#gridCalendarioIngresos').html("");
				 	      $('#gridCalendarioIngresos').hide();
				 	      deshabilitaBoton('autorizar','submit');
						  deshabilitaBoton('desautorizar','submit');
						  deshabilitaBoton('grabar','submit');
						  deshabilitaBoton('agregarInf','submit');
				 	     
				 }
		 	    else if(inst != '' && convenio != '' && anio != "" && estatus != ""){
		 	   
		 	      estatus=$('#estatus').val();
		 	      var params = {};
		 	      params['tipoLista'] = 1;
		 	      params['institNominaID'] = inst;
		 	      params['convenioNominaID'] = convenio;
		 	      params['anio'] =anio ;
		 	      params['estatus'] = estatus;
                   habilitaBoton('agregarInf');
		 	      $.post("calendarioIngresosGrid.htm", params, function(data){
		 	        if(data.length) {
                     
		 	          $('#gridCalendarioIngresos').html(data);
		 	          $('#gridCalendarioIngresos').show();
		 	          formatoFecha();
					   alternarColumnaFechaRecepcion();
		 	           cantFilas=consultaFilas();
		 	      if(cantFilas > 0)
		 	      { 
		 	  		estatusGuarda = true;
		 	         if($('#estatus').val() == 'R' &&  perfil != true){
						habilitaBoton('grabar','submit');
						deshabilitaBoton('desautorizar','submit');
						deshabilitaBoton('autorizar','submit');
						
					}else if($('#estatus').val() == 'R' && perfil == true){
							
						habilitaBoton('autorizar','submit');
						deshabilitaBoton('desautorizar','submit');
						habilitaBoton('grabar','submit');

						}else if($('#estatus').val() == 'A'){
							 if(perfil)
						     {  
						habilitaBoton('desautorizar','submit');
						deshabilitaBoton('autorizar','submit');
						deshabilitaBoton('grabar','submit');
						     	
						     }
						} else if($('#estatus').val() == 'D' &&  perfil != true){
							habilitaBoton('grabar','submit');
							deshabilitaBoton('desautorizar','submit');
							deshabilitaBoton('autorizar','submit');
						
					}else if($('#estatus').val() == 'D' && perfil == true){
							habilitaBoton('autorizar','submit');
							deshabilitaBoton('desautorizar','submit');
							habilitaBoton('grabar','submit'); 
						}
					}else{
						estatusGuarda = false;
						deshabilitaBoton('desautorizar','submit');
						deshabilitaBoton('autorizar','submit');
						deshabilitaBoton('grabar','submit');
						}
		 	          
		 	        }else {
		 	          deshabilitaBoton('grabar','submit');
		 	          $('#gridCalendarioIngresos').html("");
		 	          $('#gridCalendarioIngresos').show();
		 	        }
		 	      });
		 	    }
               
		 	  }

		 	  function consultarPerfil(){
           
	 	    var pUsuario = parametroBean.perfilUsuario;
	 	    var numEmpresa = 1;
	 	 	setTimeout("$('#cajaLista').hide();", 200);
			var parametrosNomina = {  
					'empresaID':numEmpresa
					};
	
			if(numEmpresa != 0 && numEmpresa>0){
				parametrosNominaServicio.consulta(catTipoConsultaParam.principal,parametrosNomina, function(params){
                  
					if(params != null){
						if(params.perfilAutCalend != pUsuario ){
							perfil = false;
						}else{perfil = true;}
					}	
				});
				}
           
	 	  }
	 	 

	});//	Fin de las validaciones 

  function consultarPerfil(){
           
	 	    var pUsuario = parametroBean.perfilUsuario;
	 	    var numEmpresa = 1;
	 	 	setTimeout("$('#cajaLista').hide();", 200);
			var parametrosNomina = {  
					'empresaID':numEmpresa
					};
	
			if(numEmpresa != 0 && numEmpresa>0){
				parametrosNominaServicio.consulta(catTipoConsultaParam.principal,parametrosNomina, function(params){
                  
					if(params != null){
						if(params.perfilAutCalend != pUsuario ){
							perfil = false;
						}else{perfil = true;}
					}	
				});
				}
           
	 	  }
function agregarNuevoRegistro(){
    var numeroFila=consultaFilas();
    var nuevaFila = parseInt(numeroFila) + 1;
    var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
      if(numeroFila == 0){
      	tds += '<td>';
        tds += '  <input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="12"  autocomplete="off"  type="text" value = "'+nuevaFila +'" readonly="true"/>';
        tds += '</td>';
        tds += '<td>';
        tds += '  <input  id="fechaLimiteEnvio'+nuevaFila+'" maxlength="10"  name="lisFechaLimiteEnvio"  size="12"  value="" autocomplete="off"  esCalendario="true" type="text" onchange ="validaAnioFechaL(this.id); validarLogicaFechaRecepcion(this.id); validaFechaIgual(this.id); validaAscendenciaFL(this.id);" />';
        tds += '</td>';
        tds += '<td>';
        tds += '<input  id="fechaPrimerDesc'+nuevaFila+'" maxlength="10" name="lisFechaPrimerDesc"  size="12"  autocomplete="off"  esCalendario="true"  type="text" onchange ="validaFecha(this.id); validaAscendenciaFD(this.id);"/>';
        tds += '</td>';
		tds += '<td class="fechaLimiteRecep">';
        tds += '<input  id="fechaLimiteRecep'+nuevaFila+'" maxlength="10" name="lisFechaLimiteRecep"  size="12"  autocomplete="off"  esCalendario="true"  type="text" onchange ="validaFechaRecepcion(this.id);"/>';
        tds += '</td>';
        tds += '<td>';
        tds += '<input  id="numCuotas'+nuevaFila+'" name="lisNumCuotas" maxlength="4" size="12"  autocomplete="off" type="text" value ="0" onkeypress="return validaSoloNumero(event,this);"/>';
        tds += '</td>';
        tds += '<td >';
        tds += ' <input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarRegistro(this.id)"/>';
        tds += ' <input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarNuevoRegistro()"/>';
        tds += '</td>';
      }
      else{
        var valor = numeroFila+ 1;
       tds += '<td>';
        tds += '  <input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="12"  autocomplete="off"  type="text" value ="'+nuevaFila +'" readonly="true" />';
        tds += '</td>';
        tds += '<td>';
        tds += '  <input  id="fechaLimiteEnvio'+nuevaFila+'" maxlength="10"  name="lisFechaLimiteEnvio"  size="12"  value="" autocomplete="off" type="text" esCalendario="true"  onchange ="validaAnioFechaL(this.id); validarLogicaFechaRecepcion(this.id); validaFechaIgual(this.id); validaAscendenciaFL(this.id);"/>';
        tds += '</td>';
        tds += '<td>';
        tds += '<input  id="fechaPrimerDesc'+nuevaFila+'" maxlength="10"  name="lisFechaPrimerDesc"  size="12"  autocomplete="off"  esCalendario="true" type="text"  onchange ="validaFecha(this.id); validaAscendenciaFD(this.id);"  />';
        tds += '</td>';
		tds += '<td class="fechaLimiteRecep">';
        tds += '<input  id="fechaLimiteRecep'+nuevaFila+'" maxlength="10" name="lisFechaLimiteRecep"  size="12"  autocomplete="off"  esCalendario="true"  type="text" onchange ="validaFechaRecepcion(this.id);"/>';
        tds += '</td>';
        tds += '<td>';
        tds += '<input  id="numCuotas'+nuevaFila+'" name="lisNumCuotas" value ="0" maxlength="4" size="12"  autocomplete="off"   type="text" onkeypress="return validaSoloNumero(event,this);"/>';
        tds += '</td>';
        tds += '<td >';
        tds += ' <input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarRegistro(this.id)" />';
        tds += ' <input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarNuevoRegistro()"/>';
        tds += '</td>';
      }
      tds += '</tr>';
      
      $("#miTabla").append(tds);
     
      if(nuevaFila >0)
      { 
      	 /*Condiciones para el control de los botones tomando encuenta si antes el grid se encontraba 
      	  con información esto para guardar el estatus de los botones*/
      		if($('#estatus').val() == 'R' &&  perfil != true){
				habilitaBoton('grabar','submit');
				if(estatusGuarda != true)
				{
				deshabilitaBoton('desautorizar','submit');
				deshabilitaBoton('autorizar','submit');
				}
						
			}else if($('#estatus').val() == 'R' && perfil == true){
				if(estatusGuarda != true)
				{
				deshabilitaBoton('autorizar','submit');
				deshabilitaBoton('desautorizar','submit');
				}
				if(sinInformacion != true){
				habilitaBoton('grabar','submit');
				}else{
					habilitaBoton('grabar','submit');
					habilitaBoton('autorizar','submit');
				}

			}else if($('#estatus').val() == 'A'){
				 if(perfil)
			     {  
					habilitaBoton('desautorizar','submit');
					deshabilitaBoton('autorizar','submit');
					deshabilitaBoton('grabar','submit');
			     	
			     }
			} else if($('#estatus').val() == 'D' &&  perfil != true){
				habilitaBoton('grabar','submit');
				if(estatusGuarda != true)
				{
				deshabilitaBoton('desautorizar','submit');
				deshabilitaBoton('autorizar','submit');
				}
						
			}else if($('#estatus').val() == 'D' && perfil == true){
				if(estatusGuarda != true)
				{
				deshabilitaBoton('autorizar','submit');
				deshabilitaBoton('desautorizar','submit');
				}
				if(sinInformacion != true){
					habilitaBoton('grabar','submit'); 
				}else{
					habilitaBoton('grabar','submit');
					habilitaBoton('autorizar','submit');
				}
				
			}
			sinInformacion = false;
		  
      }else{ 

      	  deshabilitaBoton('grabar');
		  deshabilitaBoton('autorizar');
		  deshabilitaBoton('desautorizar');}
     
      agregaFormatoControles('formaGenerica');
	  alternarColumnaFechaRecepcion();
      return false;
    }

    function eliminarRegistro(control){
    var contador = 0 ;
    var numeroID = control;

    var jqRenglon = eval("'#renglon" + numeroID + "'");
    var jqNumero = eval("'#consecutivoID" + numeroID + "'");
    var jqFechaL = eval("'#fechaLimiteEnvio" + numeroID + "'");
    var jqFechaPDesc = eval("'#fechaPrimerDesc" + numeroID + "'");
    var jqNumCuotas=eval("'#numCuotas" + numeroID + "'");
    var jqAgrega=eval("'#agrega" + numeroID + "'");
    var jqElimina = eval("'#" + numeroID + "'");

    // se elimina la fila seleccionada
    $(jqNumero).remove();
    $(jqFechaL).remove();
    $(jqElimina).remove();
    $(jqFechaPDesc).remove();
    $(jqAgrega).remove();
    $(jqNumCuotas).remove();
    $(jqRenglon).remove();

    //Reordenamiento de Controles
    contador = 1;
    var numero= 0;
    $('tr[name=renglon]').each(function() {
      numero= this.id.substr(7,this.id.length);
      var jqRenglon1 = eval("'#renglon" + numeroID + "'");
      var jqNumero1 = eval("'#consecutivoID" + numeroID + "'");
      var jqFechaL1 = eval("'#fechaLimiteEnvio" + numeroID + "'");
      var jqFechaPDesc1 = eval("'#fechaPrimerDesc" + numeroID + "'");
      var jqNumCuotas1=eval("'#numCuotas" + numeroID + "'");
      var jqAgrega1=eval("'#agrega" + numeroID + "'");
      var jqElimina1 = eval("'#" + numeroID + "'");
      
      $(jqNumero1).attr('id','consecutivoID'+contador);
      $(jqFechaL1).attr('id','fechaLimiteEnvio'+contador);
      $(jqFechaPDesc1).attr('id','fechaPrimerDesc'+contador);
      $(jqNumCuotas1).attr('id','fechaPrimerDesc'+contador);
      $(jqAgrega1).attr('id','agrega'+contador);
      $(jqElimina1).attr('id',contador);
      $(jqRenglon1).attr('id','renglon'+ contador);
      contador = parseInt(contador + 1);

    });


if(numeroID <=1)
   {  sinInformacion = true;
   	 deshabilitaBoton('grabar');
	 deshabilitaBoton('autorizar');
	 deshabilitaBoton('desautorizar');}
  }

	function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
         
		totales++;

	});
	return totales;
}
	
	function formatoFecha(){
		$('tr[name=renglon]').each(function() {
			var numero = this.id.substr(7,this.id.length);
			var jqIdFechaLim = eval("'fechaLimiteEnvio" + numero+ "'");
			var jqIdFechaPrim = eval("'fechaPrimerDesc" + numero+ "'");
			var jqIdFechaRecep = eval("'fechaLimiteRecep" + numero + "'");
		
			$('#'+jqIdFechaLim).datepicker({
			    			showOn: "button",
			    			buttonImage: "images/calendar.png",
			    			buttonImageOnly: true,
							changeMonth: true, 
							changeYear: true,
							dateFormat: 'yy-mm-dd',
							yearRange: '-100:+10',
							defaultDate: parametroBean.fechaSucursal
						
			});
			
			$('#'+jqIdFechaPrim).datepicker({
				showOn: "button",
				buttonImage: "images/calendar.png",
				buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yy-mm-dd',
				yearRange: '-100:+10',
				defaultDate: parametroBean.fechaSucursal
			
			});

			$('#'+jqIdFechaRecep).datepicker({
				showOn: "button",
				buttonImage: "images/calendar.png",
				buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yy-mm-dd',
				yearRange: '-100:+10',
				defaultDate: parametroBean.fechaSucursal
			
			});
		});
	}

	//Método que determina si la columna Fecha Límite Recepción sera desplegada en pantalla.
	function alternarColumnaFechaRecepcion(){

		var reportaIncidencia = $("#reportaIncidencia").val();

		$(".fechaLimiteRecep").each(function(){
			if (reportaIncidencia == 'S'){
				$(this).show();
			} else {
				$(this).hide();
			}
		});
	}

	//Método que realiza una consulta, al servidor, sobre el estado de la bandera Reporta incidencia de un determinado convenio.
	function consultaReportaIncidencia(){
		var tipoLista = 4;
		var convenio  = $('#convenioNominaID').val();
	 	var	bean = {
	 			'convenioNominaID': convenio
	 		};
		
		conveniosNominaServicio.consulta(tipoLista,bean, function(convenioNominaBean){ 

			if(convenioNominaBean != null){
				$("#reportaIncidencia").val(convenioNominaBean.reportaIncidencia);
			}	
		});
	}

	// Método que permite validar la fecha ingresada en el campo fechaLimiteRecep
	function validaFechaRecepcion(idControl){
		var numero = idControl.substr(16,idControl.length);
		var siguienteNumero = parseInt(numero) + 1;
		var fecha1 = '#fechaLimiteEnvio'+ (siguienteNumero);
        var fecha2 = '#fechaPrimerDesc'+numero;
        var anioF  = $(fecha2).val().substr(0,4);

		if (anioF < $('#anio').val()){
			$(fecha2).val('');
	   		$(fecha2).focus();
	   		mensajeSis("La Fecha no debe ser menor al Año seleccionado");
			return 0;
		} 
		if ($(fecha2).val() >= $( "#" + idControl).val()){
			$("#" + idControl).val('');
			$("#" + idControl).focus();
			mensajeSis("La fecha debe ser mayor a la primera fecha de descuento");
			return 0;
		}

		if ($(fecha1) == null || $(fecha1).val() == ""){
			return 0;
		}

		if ($(fecha1).val() < $( "#" + idControl).val()){
			$("#" + idControl).val('');
			$("#" + idControl).focus();
			mensajeSis("La fecha debe ser menor, o igual, a la siguiente fecha límite de envío.");
			return 0;
		}
	}

	// Método que valida el campo fechaLimiteRecep contra la lógica de la fecha limite de recepción anterior.
	function validarLogicaFechaRecepcion(idControl){
		var numero = idControl.substr(16,idControl.length);
		var numeroAnterior = parseInt(numero) - 1;
        var fecha1 = $('#fechaLimiteEnvio'+numero);
		var fechaLimiteRecepAnterior = '#fechaLimiteRecep' + numeroAnterior;
		var reportaIncidencia = $("#reportaIncidencia").val();

		if ($(fechaLimiteRecepAnterior) == null || $(fechaLimiteRecepAnterior).val() == ''){
			return 0;
		}
		
		if (reportaIncidencia == 'N'){
			return 0;
		}

		if ($(fecha1).val() < $(fechaLimiteRecepAnterior).val()){
			$(fecha1).val('');
	   		$(fecha1).focus();
	   		mensajeSis("La Fecha Límite de Envío debe ser mayor a la Fecha Limite de Recepción anterior");
			return 0;
		}
	}

	function validaFecha(idControl) {
        var numero = idControl.substr(15,idControl.length);
        var fecha1 = $('#fechaLimiteEnvio'+numero);
        var fecha2 = $('#fechaPrimerDesc'+numero);
		var fechaLimiteRecep = '#fechaLimiteRecep' + numero;
        var anioF  = $(fecha2).val().substr(0,4);
		var reportaIncidencia = $("#reportaIncidencia").val();
    
       if(anioF< $('#anio').val()){
	   		$(fecha2).val('');
	   		$(fecha2).focus();
	   		mensajeSis("La Fecha no debe ser menor al Año seleccionado");
	   }else if($(fecha1).val()>$(fecha2).val()){
	   		$(fecha2).val('');
	   		$(fecha2).focus();
	   		mensajeSis("La Fecha de Descuento debe ser mayor a la Fecha Limite de Envío ");
	   }else if($(fecha1).val()==$(fecha2).val())  {
	   		$(fecha2).val('');
	   		$(fecha2).focus();
	   		mensajeSis("La Fecha de Descuento no debe ser igual a la Fecha Limite de Envío");
	   }else if($(fecha2).val() == "")
	   {
	   	 mensajeSis("La Fecha se encuentra vacía");
	   	 $(fecha2).focus();
	   }
       
       if(!esFechaValida($(fecha2).val()))
    	  {
    	  	$(fecha2).val('');
    	    $(fecha2).focus();
    	  }

		if (reportaIncidencia == 'N' || $(fechaLimiteRecep).val() == ''){
			return 0;
		}
      
		if ($(fecha2).val() > $(fechaLimiteRecep).val()){
			$(fecha2).val('');
	   		$(fecha2).focus();
	   		mensajeSis("La Fecha de Descuento debe ser menor a la Fecha Limite de Recepción");
			return 0;
		}
			
	}
	
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
						if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
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
	 
	// FUNCION PARA COMPROBAR EL AÑO BISIESTO
		function comprobarSiBisisesto(anio){
			if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
				return true;
			}
			else {
				return false;
			}
		}
	 

	function validaAnioFechaL(idControl) {
        var numero = idControl.substr(16,idControl.length);
        var fecha1 = $('#fechaLimiteEnvio'+numero);
        var anioF  = $(fecha1).val().substr(0,4);
	   if($('#anio').val()!= anioF){
	   		$(fecha1).val('');
	   		$(fecha1).focus();
	   		mensajeSis("La Fecha no corresponde al Año seleccionado");
	   }else if($(fecha1).val() == "")
	   {
	   	 mensajeSis("La Fecha se encuentra vacía");
	   	 $(fecha1).focus();
	   }


       if(!esFechaValida($(fecha1).val()))
    	  { $(fecha1).val('');
    	    $(fecha1).focus();
    	  }
			
	}


	/**
* Se verifica Fecha Limite Envio Repetido
*/
function validaFechaIgual(idControl){
	var contador = 0;
	var numero = idControl.substr(16,idControl.length);
	var jqFecha = eval("'fechaLimiteEnvio" + numero+ "'");

	var valorFecha = $('#'+jqFecha).val();
	
	for (var i = numero - 1; i > 0; i--) {
	var jqFecha1 = eval("'fechaLimiteEnvio" + i+ "'");

	var valorFecha1 = $('#'+jqFecha1).val();

	if(valorFecha == valorFecha1 ){
	contador ++;
	}
	}

	if(contador > 0){
	mensajeSis("La Fecha Limite Envio ya Existe.");
	$('#'+idControl).focus();
	$('#'+idControl).select();
	$('#'+idControl).val("");

	}
}


function validaAscendenciaFL(idControl){
	var contador = 0;
	if(idControl.substr(0,16) == "fechaLimiteEnvio"){
		var numero = idControl.substr(16,idControl.length);
		var jqFechaL = eval("'fechaLimiteEnvio" + numero+ "'");
		var valorFechaL = $('#'+jqFechaL).val();
		
		for (var i = numero - 1; i > 0; i--) {
		var jqFechaL1 = eval("'fechaLimiteEnvio" + i+ "'");
		var valorFechaL1 = $('#'+jqFechaL1).val();
 
		if(valorFechaL < valorFechaL1 ){
			mensajeSis("La Fecha Limite es menor a la Fila anterior.");
			$('#'+idControl).focus();
			$('#'+idControl).select();
			$('#'+idControl).val("");
		}
		}
    }
}



function validaAscendenciaFD(idControl){
   
    	var numero2 = idControl.substr(15,idControl.length);
    	var jqFechaD = eval("'fechaPrimerDesc" + numero2+ "'");
        var valorFechaD = $('#'+jqFechaD).val();
    
		for (var i = numero2 - 1; i > 0; i--) {
		
		var jqFechaD1 = eval("'fechaPrimerDesc" + i+ "'");

		var valorFechaD1 = $('#'+jqFechaD1).val();
        
		if(valorFechaD < valorFechaD1 ){
			mensajeSis("La Fecha Descuento es menor a la Fila anterior.");
			$('#'+idControl).focus();
			$('#'+idControl).select();
			$('#'+idControl).val("");
		}
		}

	}


	function validaSoloNumero(e,elemento){//Recibe al evento 
		var key;
		if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
		}else if(e.which){//Firefox , Opera Netscape
		key = e.which;
		}

		if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja 
		return false;
		return true;
	}

	function validaVacios() {
		$('tr[name=renglon]').each(function() {
			var reportaIncidencia = $("#reportaIncidencia").val();
            numero= this.id.substr(7,this.id.length);
						var numFL= $('#fechaLimiteEnvio'+numero).val();
						if(numFL == ""){
							mensajeSis("Campo Fecha Limite Envío Vacío");
							$('#fechaLimiteEnvio'+numero).focus();
							$('#fechaLimiteEnvio'+numero).select();
							return 0;
						}

					  var numFD = $('#fechaPrimerDesc'+numero).val();
						if(numFD == ""){
							mensajeSis("Campo Fecha Descuento Vacío");
							$('#fechaPrimerDesc'+numero).focus();
							$('#fechaPrimerDesc'+numero).select();
							return 0;
						}
			if(reportaIncidencia != "N"){
				var numFL= $('#fechaLimiteRecep'+numero).val();
						if(numFL == ""){
							mensajeSis("Campo Fecha Limite Recepción Vacío");
							$('#fechaLimiteRecep'+numero).focus();
							$('#fechaLimiteRecep'+numero).select();
							return 0;
						}
			}
		});


	}

	
	function limpiarFormulario(){
		 $('#institNominaID').focus();
		 $('#convenioNominaID').val('');
		 $('#descripcion').val('');
		 $('#estatus').val('R');
		 $('#anio').val(0);
		 $('#gridCalendarioIngresos').html("");
		 $('#gridCalendarioIngresos').hide();
		  deshabilitaBoton('grabar');
		  deshabilitaBoton('autorizar');
		  deshabilitaBoton('desautorizar');
		  deshabilitaBoton('agregarInf');
		  
	}
	
	function Exito(){
		 $('#institNominaID').focus();
		 $('#convenioNominaID').val('');
		 $('#descripcion').val('');
		 $('#estatus').val('R');
		 $('#anio').val(0);
		 $('#gridCalendarioIngresos').html("");
		 $('#gridCalendarioIngresos').hide();
		  deshabilitaBoton('grabar');
		  deshabilitaBoton('autorizar');
		  deshabilitaBoton('desautorizar');
		  deshabilitaBoton('agregarInf');
		
	}

	function Error(){
		
	}