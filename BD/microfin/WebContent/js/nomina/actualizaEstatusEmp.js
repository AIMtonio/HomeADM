$(document).ready(function() {
    var parametroBean = consultaParametrosSession();
    esTab = true;
    
 
    // Definicion de Constantes y Enums
    var catTipoTransaccionEmpleado = {
    		'actualiza':'1'
    };
    
    var catTipoConsultaInstitucion = {
			'institucion': 2
	};
    
    var catTipoConsultaEmpleados = {
			'estatus':2 

	};
    
	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
    agregaFormatoControles('formaGenerica');
    $('#fechaInicialInca').val(parametroBean.fechaSucursal);
    $('#fechaFinInca').val(parametroBean.fechaSucursal);
    $('#fechaBaja').val(parametroBean.fechaSucursal);
    deshabilitaBoton('modificar', 'submit');
    
    $(':text').focus(function() {	
		esTab = false;
	});
        
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma',
					'mensaje', 'true', 'clienteID','exitoActualizacion','falloActualizacion');
    	}
    });
    

	$('#institNominaID').bind('keyup',function(e) {
		lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function() {
		consultaInstitucion(this.id);
	});
	
	$('#clienteID').bind('keyup',function(e) {
	var camposLista = new Array();
	var parametrosLista = new Array();
	
	camposLista[1] = "nombreCompleto";
	camposLista[0] = "institNominaID";
	
	parametrosLista[1] = $('#clienteID').val();		
	parametrosLista[0] = $('#institNominaID').val();

	lista('clienteID', '2', '2', camposLista, parametrosLista, 'listaClientes.htm');

	});
  
	$('#clienteID').blur(function() {
		consultaEstatusEN(this.id);
	});
	
	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionEmpleado.actualiza);
	});
	
    $('#estatus').change(function(){
		if($('#estatus').val()=='I'){
			$('#incapacidadDiv').show();
			$('#bajaDiv').hide();
			
			$('#fechaInicialInca').val(parametroBean.fechaSucursal);
			$('#fechaFinInca').val(parametroBean.fechaSucursal);
			$('#fechaBaja').val('');
			$('#motivoBaja').val('');
			
		}else if($('#estatus').val()=='B'){
		  $('#bajaDiv').show();	
		  $('#incapacidadDiv').hide();
		  
		  $('#fechaBaja').val(parametroBean.fechaSucursal);
		  $('#fechaInicialInca').val('');
		  $('#fechaFinInca').val('');
		}else{
		   $('#bajaDiv').hide();	
		   $('#incapacidadDiv').hide();
		   
		   $('#fechaBaja').val('');
		   $('#motivoBaja').val('');
		   $('#fechaInicialInca').val('');
		   $('#fechaFinInca').val('');
		}
     });
  
	
    
  //Obtiene y valida la fecha de inicio
	$('#fechaInicialInca').change(function() {
		var Xfecha= $('#fechaInicialInca').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicialInca').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFinInca').val();
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Inicial es Mayor a la Fecha Final.")	;
				$('#fechaInicialInca').val(parametroBean.fechaSucursal);
				

			}
		}else{
			$('#fechaInicialInca').val(parametroBean.fechaSucursal);
			
		}
		regresarFoco('fechaInicialInca');
	});


  //Obtiene y valida la fecha final
	$('#fechaFinInca').change(function() {
		var Xfecha= $('#fechaInicialInca').val();
		var Yfecha= $('#fechaFinInca').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaFinInca').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Inicial es mayor a la Fecha Final.")	;
				$('#fechaFinInca').val(parametroBean.fechaSucursal);
			}			
			
		}else{
			$('#fechaFinInca').val(parametroBean.fechaSucursal);
		}
		regresarFoco('fechaFinInca');
	});
	
	
	$('#fechaBaja').change(function() {
		var Xfecha= $('#fechaBaja').val();
		if($('#fechaBaja').val() > parametroBean.fechaSucursal) {
			mensajeSis("La Fecha de Baja es Mayor a la Fecha del Sistema.");
			$('#fechaBaja').val(parametroBean.fechaSucursal);
			}
		esFechaValida(Xfecha);
	});
	
	  $(".contador").each(function(){
	      var longitud = $(this).val().length;
		  $(this).parent().find('#longitud_textarea').html('<b>'+longitud+'</b> de 50 caracteres');
		     $(this).keyup(function(){ 
			 var nueva_longitud = $(this).val().length;
			 $(this).parent().find('#longitud_textarea').html('<b>'+nueva_longitud+'</b> de 50 caracteres');
			  if (nueva_longitud == "51") {
				 $('#longitud_textarea').css('color', '#ff0000');
	        		}
			});
	   });
	  
	  
	// ------------ Validaciones de la Forma ----------------
	$('#formaGenerica').validate({
		rules: {
			institNominaID :{
				required: true,
				number: true
			},	
			clienteID: {
				required: true,
				number: true
			},
			estatus: {
				required: true
			},

			fechaInicialInca : {
				required : function() {return $('#estatus').val()=='I';}
				
			},
			fechaFinInca : {
				required : function() {return $('#estatus').val()=='I';}
				
			},
			fechaBaja : {
				required : function() {return $('#estatus').val()=='B';}
				
			},
			motivoBaja : {
				required : function() {return $('#estatus').val()=='B';}
			}
		},

		messages: {
			clienteID: {
				required: "El Número de Empleado es Requerido.",
				number: "Solo Numeros."
			},
			estatus: {
				required: "Seleccione un Nuevo Estatus."
			},
		
			fechaInicialInca:{
				required: "La Fecha Inicial es Requerida."
		
			},
			fechaFinInca : {
				required : "La Fecha Final es Requerida."
				
			},
			fechaBaja : {
				required : "La Fecha de Baja es Requerida."
				
			},
			motivoBaja : {
				required : "El Motivo de la Baja es Requerido."
			},
			institNominaID :{
				required: 'Especifique la Empresa de Nómina.',
				number: 'Solo Números.'
			}
			
		}		
	});

	// Consulta de Institucion de Nomina
	function consultaInstitucion(idControl) {
		var jqNombreInst = eval("'#" + idControl + "'");
		var nombreInsti = $(jqNombreInst).val();
		var institucionBean = {
				'institNominaID': nombreInsti				
		};	
		if(nombreInsti != '' && !isNaN(nombreInsti) && esTab){
		bitacoraPagoNominaServicio.consulta(catTipoConsultaInstitucion.institucion,institucionBean,function(institNomina) {
			if(institNomina!= null){
				$('#nombreEmpresa').val(institNomina.nombreInstit);
				$('#institNominaID').val(institNomina.institNominaID);
				habilitaBoton('modificar', 'submit');
				
				}
			else {
				mensajeSis("El Número de Empresa de Nómina No Existe.");
				limpiarFormulario();
				$('#institNominaID').focus();
				deshabilitaBoton('modificar', 'submit');
			
			}
			});
		}		
	}
	
    // Consulta de Estatus de Empleados de Nomina
	function consultaEstatusEN(idControl) {	
		setTimeout("$('#cajaLista').hide();", 200);
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var numInstitucion	 = $('#institNominaID').val();
		if(numCliente != '' && !isNaN(numCliente)){
			
		var empleadoNominaBean = {
				'institNominaID': numInstitucion,
				'clienteID': numCliente		
		};
		actualizaEstatusEmpServicio.consulta(catTipoConsultaEmpleados.estatus,empleadoNominaBean,function(empleadoNomina) {
		  if(empleadoNomina != null){
				$('#nombreEmpleado').val(empleadoNomina.nombreCompleto);
				var estatusEN = empleadoNomina.estatus;
				validaCambioEstatus(estatusEN);
				if(estatusEN == 'I'){
				    $('#fechaInicialInca').val(empleadoNomina.fechaInicialInca);
				    $('#fechaFinInca').val(empleadoNomina.fechaFinInca);
				    $('#fechaBaja').val('');
				    $('#motivoBaja').val('');
				    $('#estatusActual').val('INCAPACIDAD');
				    
				    $('#incapacidadDiv').show();
				    $('#bajaDiv').hide();
				    
				    habilitaControl('estatus');
					habilitaControl('guardar');
					habilitaControl('fechaBaja'); 
					habilitaControl('motivoBaja'); 
					habilitaBoton('modificar', 'submit');
				    
				}else if(estatusEN =='B'){	 
					  $('#fechaBaja').val(empleadoNomina.fechaBaja);
					  $('#motivoBaja').val(empleadoNomina.motivoBaja);
					  $('#fechaInicialInca').val('');
					  $('#fechaFinInca').val('');
					  $('#estatusActual').val('BAJA');
					  
					  $('#bajaDiv').show();	
					  $('#incapacidadDiv').hide();
					  
					  deshabilitaControl('estatus');
					  deshabilitaControl('guardar');
					  deshabilitaControl('fechaBaja'); 
					  deshabilitaControl('motivoBaja'); 
					  mensajeSis("El Empleado ha sido dado de Baja Imposible Modificar.");
					  $('#institNominaID').focus();
					  deshabilitaBoton('modificar', 'submit');
					  $('#longitud').hide();
				}else{   
					$('#fechaBaja').val('');
					$('#motivoBaja').val('');
					$('#fechaInicialInca').val('');
					$('#fechaFinInca').val('');
					$('#estatusActual').val('ACTIVO');
					
					$('#bajaDiv').hide();	
					$('#incapacidadDiv').hide();
					
					habilitaControl('estatus');
					habilitaControl('guardar');
					habilitaControl('fechaBaja'); 
					habilitaControl('motivoBaja'); 
					habilitaBoton('modificar', 'submit');
					$('#longitud').show();
				}
			}else{
				alert ("El Número de Empleado No Existe.");  
				$('#clienteID').focus();
				$('#clienteID').val('');
				$('#nombreEmpleado').val('');
				$('#estatusActual').val('');
				$('#estatus').val('');	
				$('#bajaDiv').hide();	
				$('#incapacidadDiv').hide();
				deshabilitaBoton('modificar', 'submit');
			}	
		});
		}
	}

 function validaCambioEstatus(estatus){
		if(estatus=='A'){
			$('#estatus').find('option').remove().end().append('<option value="">SELECCIONA</option><option value="I">INCAPACIDAD</option><option value="B">BAJA</option>') ;
			$('#estatus option[value=A]').attr('selected','true');		
		}else if(estatus=='I'){
			$('#estatus').find('option').remove().end().append('<option value="">SELECCIONA</option><option value="A">ACTIVO</option><option value="B">BAJA</option>') ;
			$('#estatus option[value=I]').attr('selected','true');
		}
	 }
//	VALIDACIONES PARA LAS FECHAS

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
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd).");
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
				mensajeSis("Fecha Introducida Errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Introducida Errónea.");
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
 });// fin document
	function limpiarFormulario(){
		$('#institNominaID').val('');
		$('#nombreEmpresa').val('');
		$('#clienteID').val('');
		$('#nombreEmpleado').val('');
		$('#estatusActual').val('');
		$('#estatus').val('');	
		$('#bajaDiv').hide();	
		$('#incapacidadDiv').hide();
	}

    function exitoActualizacion(){
        deshabilitaBoton('modificar', 'submit');
		$('#fechaInicialInca').val(parametroBean.fechaSucursal);
		$('#fechaFinInca').val(parametroBean.fechaSucursal);
		$('#fechaBaja').val(parametroBean.fechaSucursal);
		$('#motivoBaja').val('');
		$('#estatusActual').val('');
		$('#nombreEmpleado').val('');
		$('#estatus').val('');
	    
		$('#bajaDiv').hide();	
		$('#incapacidadDiv').hide();
		
	    }
   function falloActualizacion(){
	
    }