
	/**
	 * Definicion de Constantes y Enums
	 */
	esTab = false;
	var parametroBean = consultaParametrosSession();
	$('#usuarioID').val(parametroBean.numeroUsuario);
	$('#sucursalID').val(parametroBean.sucursal);
	 
	var tipoTranDepreciacion={
		'procesar' : 1
	};

	 /**
     * Lista de Catalogo de Activos
     */
	var catDepAmortizaActivos = {
		'depAmortizaActivoExcel' : 1 
	};	
	

	/**
	 * Metodos y Manejo de Eventos
	 */
	agregaFormatoControles('formaGenerica');  
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
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','procesar','funcionExito','funcionError');
        }
  	});

  	/**
  	 * Inicializa valores
  	 */
  	 $('#anio').focus();
  	 llenaComboAniosFalta(parametroBean.fechaAplicacion);
  	 descripcionMes($('#mes').val());

  	 /**
  	  * Validaciones de la Forma 
  	  */
	$('#formaGenerica').validate({
		rules: {
			   anio: 'required',
			   mes: 'required',
		   },	
		   messages: {
			   anio: 'Especifique Año.',
			   mes: 'Especifique Mes.',
		   }	
	});

	/**
	 * Validacion cambio de Mes
	 */
	$('#mes').change(function (){
	   descripcionMes($('#mes').val());
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
	   var anioSeleccionado = $('#anio').val();
	   
	   if($('#anio').asNumber() > 0 && $('#mes').asNumber() > 0){
		   if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
			    descripcionMes($('#mes').val());
		   }		   
	   }
   });
 
	/**
	 * Validacion cambio de Anio
	 */
   $('#anio').change(function (){
	   llenaComboMesesPorAnios();
	  
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
	   var anioSeleccionado = $('#anio').val();
	   var mesSeleccionado = $('#mes').val();
	   
	   if($('#anio').asNumber() > 0 && $('#mes').asNumber() > 0){
		   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   mensajeSis("El Año Indicado es Incorrecto.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
			    descripcionMes($('#mes').val());
		   }		   
	   }

   });

   /**
    * Boton Previo a la Depreciacion
    */
  	$('#previo').click(function(event){
		if($('#anio').val() != ''){
			if($('#mes').val() != ''){
				generaReporteDepreciacion();
			}else{
				$('#mes').focus();
				mensajeSis("Seleccione un Mes");			
			}			
		}else{
			$('#anio').focus();
			mensajeSis("Seleccione un Año");			
		}
	});

  	/**
  	 * Boton Aplicacion de la Depreciacion
  	 */
	$('#procesar').click(function(event){
		$('#tipoTransaccion').val(tipoTranDepreciacion.procesar);
	});


	function llenaComboAniosFalta(fechaActual){
		var beanCon ={
			'anio' : 0,
			'mes' : 0 
		};
		dwr.util.removeAllOptions('anio'); 
		aplicacionDepreciacionServicio.listaCombo(1, beanCon, function(beanLista){
			dwr.util.addOptions('anio', {'':'SELECCIONAR'});	
			dwr.util.addOptions('anio', beanLista, 'anio', 'anio');
		});
	}

	function llenaComboMesesPorAnios(fechaActual){
		var beanCon ={
			'anio' : $('#anio').val(),
			'mes' : 0 
		};
		dwr.util.removeAllOptions('mes'); 
		aplicacionDepreciacionServicio.listaCombo(2, beanCon, function(beanLista){
			dwr.util.addOptions('mes', {'':'SELECCIONAR'});	
			dwr.util.addOptions('mes', beanLista, 'mes', 'descMes');
		});
	}

	/** 
	 * Funcion para llenar los Anios en el Combo 
	 */
	function llenaComboAniosDos(fechaActual){
	   var anioActual = fechaActual.substring(0, 4);
	   var mesActual = parseInt(fechaActual.substring(5, 7));
	   var numOption = 6;
	  
	   if(mesActual == 0){
	   		mesActual = 12;
	   		anioActual = anioActual - 1;
	   }

	   for(var i=0; i<numOption; i++){
		   $("#anio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
		   anioActual = parseInt(anioActual) - 1;
	   }
	   
	   $("#mes option[value="+ mesActual +"]").attr("selected",true);
   }

	/**
	 * Funcion para generar el reporte previo en PDF de Depreciacion y Amortizacion de Activos
	 */
	function generaReporteDepreciacion(){

		var tipoLista   = catDepAmortizaActivos.depAmortizaActivoExcel;	

		var varNombreInstitucion = parametroBean.nombreInstitucion;
		var varClaveUsuario		= parametroBean.claveUsuario;
	    var varFechaSistema     = parametroBean.fechaSucursal;
	
		var pagina='reporteApliDepAmor.htm?anio=' + $('#anio').val()+ 
							'&mes=' + $('#mes').val()+ 							
							'&fechaSistema='+ varFechaSistema+ 
							'&claveUsuario='+varClaveUsuario.toUpperCase()+
							'&nombreInstitucion='+varNombreInstitucion +
							'&tipoLista='+tipoLista+
							'&numTransaccion='+$('#numTransaccion').val();
		window.open(pagina);	   
	}


	/**
	 * Funcion Confirmar Depreciacion y Amortizacion de Activos
	 */
	function confirmar(){
		if(confirm('¿Está seguro que desea ejecutar el Proceso de Depreciación / Amortización del año '+ $('#anio').val() + '  y mes ' + $('#descMes').val() + ' seleccionados?'))
			return true;
		else
		return false;
	}

	/**
	 * Funcion descripcion del Mes
	 */
	function descripcionMes(mes){
		var nombreMes = regresaMes(mes);
		$('#descMes').val(nombreMes);
	}

	/**
	 * Funcion para obtener la descripcion del mes
	 */
	function regresaMes(numMes){
		var mes='';  
		switch(numMes)
		{
		case '1': mes = "ENERO";
		break;
		case '2': mes= "FEBRERO";	
		break;
		case '3': mes = "MARZO";
		break;
		case '4': mes= "ABRIL";	
		break;
		case '5': mes = "MAYO";
		break;
		case '6': mes= "JUNIO";	
		break;
		case '7': mes = "JULIO";
		break;
		case '8': mes= "AGOSTO";	
		break;
		case '9': mes = "SEPTIEMBRE";
		break;
		case '10': mes= "OCTUBRE";	
		break;
		case '11': mes = "NOVIEMBRE";
		break;
		case '12': mes= "DICIEMBRE";	
		break;
		default: mes ='';
		}
		return mes;
	}	

	/**
	 * Funcion de  de exito que se ejecuta cuando despues de grabar
	 * la transaccion y esta fue exitosa.
	 */
	function funcionExito(){	
		$('#anio').val("");
		$('#mes').val("");
   }

	/**
	 * Funcion de error que se ejecuta cuando después de grabar
	 * la transacción marca error.
	 */
	function funcionError(){
		
	}