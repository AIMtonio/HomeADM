$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	
	var catTipoListaTipoAportacion= {
			'principal':1,
			'sucursal' :4
		};

	var catTipoConsultaAportaciones = {
		    'principalSucursal' : 1,
			'general' : 2,

	};



    //Asignando la Fecha del Sistema :D
	var parametroBean = consultaParametrosSession();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	habilitaBoton('imprimir', 'button');
	$('#fechaInicio').focus();
	$('#clienteID').val('0');
	$('#nombreCliente').val('TODOS');
	$('#sucursalID').val('0');
	$('#nombreSucursal').val('TODAS');

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
   	agregaFormatoControles('formaGenerica');

   //Validando la Fecha	::::::::::::::::::::::::::::::::::::::::::::::::::::	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Inicial no debe ser mayor a la Fecha Final.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();

			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
			
		}
		regresarFoco('fechaInicio');
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Final no debe ser menor a la Fecha Final.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();

			}
		}else{

			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#fechaFin').focus();
		}
		regresarFoco('fechaFin');
	});


	//Validaciones de los Radio Button 
	$('#pdf').attr("checked",true);
	$('#excel').attr("checked",false);
	$('#reporte').val(2);
	
	$(':text').focus(function() {	
	 	esTab = false;
	});


    //Buscando la Aportación 			
	$('#aportacionID').val(0);
	$('#descripcion').val('TODOS');
	$('#aportacionID').bind('keyup',function(e){
		
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "descripcion";
		 parametrosLista[0] = $('#aportacionID').val();
		
		lista('aportacionID', 2, catTipoListaTipoAportacion.principal, camposLista,
				 parametrosLista, 'listaTiposAportaciones.htm');
	});	

	$('#aportacionID').blur(function() {
		if(esTab){
			consultaAportacion(this.id);
		}
	});

	function consultaAportacion(idControl) {
		var jqAportacion = eval("'#" + idControl + "'");
		var tipoAportacion = $(jqAportacion).val();
		var tiposAportacionesBean = {
		         'tipoAportacionID':tipoAportacion,
		         'monedaId':0
		    };
		setTimeout("$('#cajaLista').hide();", 200);
		if (tipoAportacion != '' && !isNaN(tipoAportacion)) {
          if(tipoAportacion==0){
            $('#aportacionID').val(0);
	        $('#descripcion').val('TODOS');
          }
         else{
			tiposAportacionesServicio.consulta(catTipoConsultaAportaciones.general, tiposAportacionesBean, function(tiposAportaciones) {
				if (tiposAportaciones != null) {
					$('#descripcion').val(tiposAportaciones.descripcion);
				} else {
					mensajeSis("No Existe La Aportación");
					$('#descripcion').val('');
					$('#aportacionID').focus();
					$('#aportacionID').val('');
				}
			});
		  }
		}else{
			$('#aportacionID').val(0);
	        $('#descripcion').val('TODOS');
		}
	}

	//ASIGNANDO SUCURSAL ::::::::::::::::::::::::::::::::::::::::::::::::::::
    $('#sucursalID').bind('keyup',function(e){
				lista('sucursalID', '2', catTipoListaTipoAportacion.sucursal, 'nombreSucurs', 
				$('#sucursalID').val(), 'listaSucursales.htm');
	  });

    $('#sucursalID').blur(function() {
    	if (esTab) {
    		consultaSucursal(this.id);
    		if($("#sucursalID").val() != ''){
				habilitaBoton('imprimir', 'button');
			}else{
			
			deshabilitaBoton('imprimir', 'button');
			}
    	}
		
	});

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var tipoSucursal = $(jqSucursal).val();

		setTimeout("$('#cajaLista').hide();", 200);
		if (tipoSucursal != '' && !isNaN(tipoSucursal)) {
          if(tipoSucursal==0){
            $('#sucursalID').val(0);
	        $('#nombreSucursal').val('TODAS');
          }
         else{
			sucursalesServicio.consultaSucursal(catTipoConsultaAportaciones.principalSucursal, tipoSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#nombreSucursal').val(sucursal.nombreSucurs);
										
				} else {
					mensajeSis("No Existe la Sucursal");
					$('#nombreSucursal').val('');
					$('#sucursalID').focus();
					$('#sucursalID').val('');
				}
			});
		  }
		}else {
			$('#sucursalID').val(0);
	        $('#nombreSucursal').val('TODAS');
			}
	}

	// inicio asignación de cliente
	$('#clienteID').bind('keyup',function(e){
		var sucursalID =  $('#sucursalID').val();
		
		var camposLista = new Array();		
		var parametrosLista = new Array();		
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		
		if(parseFloat(sucursalID)>0){
			camposLista[1] = "sucursalID";
			parametrosLista[1] = sucursalID;
			camposLista[0] = "clienteID";
			lista('clienteID', '2', '16', camposLista, parametrosLista, 'listaCliente.htm');
		}else{
			camposLista[0] = "nombreCompleto";
			lista('clienteID', '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
		}
		
		
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});
	// Fin de asignación de cliente
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fechaInicio:{
				required : true,
				date : true
			},
			fechaFin:{
				required : true,
				date : true
			},
			clienteID:{
				required: true
			},
			sucursalID:{
				required: true
			}
		},
		
		messages: {
			fechaInicio: {
				required : 'La fecha de inicio es requerida',
				date : 'Especifique una fecha correcta'
			},
			fechaFin: {
				required : 'La fecha final es requerida',
				date : 'Especifique una fecha correcta'
			},
			clienteID:{
				required:'Especifique un Cliente'
			},
			sucursalID:{
				required:'Especifique sucursal'
			}
		}
	});
	 

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#pdf').click(function() {
		$('#pdf').focus();
		$('#pdf').attr("checked",true);
		$('#excel').attr("checked",false);
		$('#reporte').val(2);
	});
	
	$('#excel').click(function() {
		$('#excel').focus();
		$('#excel').attr("checked",true);
		$('#pdf').attr("checked",false);
		$('#reporte').val(3);
		$('#lista').val(18);
	});


	$('#imprimir').click(function() {	
          if($('#pdf').is(':checked')){
				reportePDF();
			}else if($('#excel').is(':checked')){
				reporteEXCEL();
			}			
		

	});

   

   /*REPORTE PDF*/
    function reportePDF(){
      	var tipoReporte = $('#reporte').val();
		var fechaInicial = $('#fechaInicio').val();
		var fechaFinal = $('#fechaFin').val();
		var sucursal = $("#sucursalID").val();
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.claveUsuario;
		var nombreSucursal = $("#nombreSucursal").val();
		var fechaAc = parametroBean.fechaSucursal;
		var cliente	  	 = $('#clienteID').val();
		var nombreCliente = $('#nombreCliente').val();

		

	    $('#ligaImp').attr('href','aportacionesPorIniciarRep.htm?fechaInicio='+fechaInicial+
	    			'&fechaVencimiento='+fechaFinal+
					'&sucursalID='+sucursal+
					'&nombreSucursal='+nombreSucursal+
					'&tipoReporte='+tipoReporte+
					'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+
					'&fechaActual='+fechaAc+
					'&clienteID='+cliente+
					'&nombreCliente='+nombreCliente);
	

    }	

   /*REPORTE EXCEL*/
     function reporteEXCEL(){
     	    var tipoLista=$('#lista').val();
            var tipoReporte = $('#reporte').val();
		    var fechaInicial = $('#fechaInicio').val();
		    var fechaFinal = $('#fechaFin').val();
		    var sucursal = $("#sucursalID").val();
		    var nombreInstitucion =  parametroBean.nombreInstitucion;
		    var nombreUsuario = parametroBean.claveUsuario;
		    var nombreSucursal = $("#nombreSucursal").val();
		    var fechaAc = parametroBean.fechaSucursal;
		    var cliente	= $('#clienteID').val();
		    var nombreCliente = $('#nombreCliente').val();

        $('#ligaImp').attr('href','aportacionesPorIniciarRep.htm?fechaInicio='+fechaInicial+
        			'&fechaVencimiento='+fechaFinal+
					'&sucursalID='+sucursal+
					'&nombreSucursal='+nombreSucursal+
					'&tipoReporte='+tipoReporte+
					'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+
					'&fechaActual='+fechaAc+
					'&tipoLista='+tipoLista+
					'&clienteID='+cliente+
					'&nombreCliente='+nombreCliente);
     }

   	 //FUNCIONES PARA LA FECHA	::::::::::::::::::::::::::::::::::::::::::::::::::::
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


	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
				return false;
			}
			return true;
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

	function regresarFoco(idControl){
		var jqControl=eval("'"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
			$(jqControl).select();
		 },0);
	}
	
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).asNumber();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente > 0 && esTab){
			clienteServicio.consulta(tipConPrincipal,numCliente.toString(),function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero)	;						
					$('#nombreCliente').val(cliente.nombreCompleto);																								
				}else{
					mensajeSis("No Existe el " + $('#socioCliente').val() + ".");
					$('#clienteID').val('0')	;	
					$('#nombreCliente').val('TODOS');
					$('#clienteID').focus();
				}    	 						
			});
		} else {
			$('#clienteID').val('0')	;	
			$('#nombreCliente').val('TODOS');
		}
	}

});
