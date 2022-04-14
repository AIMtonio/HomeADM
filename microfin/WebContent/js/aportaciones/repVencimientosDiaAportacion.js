var esTab=false;
$(document).ready(function() {
	// Definicion de Constantes y Enums
	
	var catTipoListaTipoAportacion= {
			'principal':1,
			'sucursal' :4
		};

	var catTipoConsultaAportaciones = {
		    'principalSucursal' : 1,
			'general' : 2,

	};

	var catTipoListaPromotores ={
        'promSucursal':4,
		'promActivo' :10
	}; 
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});


    //Asignando la Fecha del Sistema :D
	var parametroBean = consultaParametrosSession();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#estatus> option[value="0"]').attr('selected', 'selected');
	habilitaBoton('imprimir', 'button');
	$('#fechaInicio').focus();

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
				mensajeSis("La Fecha Final no debe ser menor a la Fecha Inicial.");
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();

			}
		}else{

			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#fechaFin').focus();
		}
		regresarFoco('fechaFin');
	});



	consultaMoneda();

	//Validaciones de los Radio Button 
	$('#pdf').attr("checked",true);
	$('#excel').attr("checked",false);
	$('#reporte').val(2);



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
    $('#sucursalID').val('0');
    $('#nombreSucursal').val('TODAS');
    $('#sucursalID').bind('keyup',function(e){
				lista('sucursalID', '2', catTipoListaTipoAportacion.sucursal, 'nombreSucurs', 
				$('#sucursalID').val(), 'listaSucursales.htm');
	  });

    $('#sucursalID').blur(function() {
    	if (esTab) {
    		consultaSucursal(this.id);
    		if($("#promotorID").val() != '' && $("#sucursalID").val() != '' 
			&& $("#tipoMonedaID option:selected").val() != '' && $("#estatus option:selected").val() != '-1'){
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

	//ASIGNANDO PROMOTOR ::::::::::::::::::::::::::::::::::::::::::::::::::::
	$('#promotorID').val('0');
	$('#nombrePromotorI').val('TODOS');
	$('#promotorID').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var jqSucursal = eval("'#sucursalID'");
		var tipoSucursal = $(jqSucursal).val();
		var camposLista = new Array();
		var parametrosLista = new Array();

        if(tipoSucursal==0){
		     camposLista[0] = "nombrePromotor";
		     camposLista[1] = "sucursalID";
		     parametrosLista[0] = $('#promotorID').val();
		     parametrosLista[1] = 0;  
		     lista('promotorID', '1', catTipoListaPromotores.promActivo,camposLista, parametrosLista, 'listaPromotores.htm');
	    }else{
	    	 camposLista[0] = "nombrePromotor";
		     camposLista[1] = "sucursalID";
		     parametrosLista[0] = $('#promotorID').val();
		     parametrosLista[1] = $('#sucursalID').val(); 
		     lista('promotorID', '1', catTipoListaPromotores.promSucursal,camposLista, parametrosLista, 'listaPromotores.htm');
	    }

	});

	$('#promotorID').blur(function() {
		if (esTab) {
			consultaPromotorI(this.id);
		}
	});


	function consultaPromotorI(idControl) {
		
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor)) {
			if(numPromotor==0){
	            $('#promotorID').val(0);
		        $('#nombrePromotorI').val('TODOS');
         	}else{
         		promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
					if(promotor.estatus != 'A'){
						mensajeSis("El promotor debe de estar Activo.");
						 $(jqPromotor).val("");
						 $(jqPromotor).focus();
						 $('#nombrePromotorI').val("");
					}else{
						
						parametroBean = consultaParametrosSession();
						$('#nombrePromotorI').val(promotor.nombrePromotor);
					}					
				} else {
					mensajeSis("No Existe el Promotor");
					$('#nombrePromotorI').val('');
					$('#promotorID').focus();
					$('#promotorID').val('');
				}
			});

         	}
		}else{
			$('#promotorID').val(0);
		    $('#nombrePromotorI').val('TODOS');
		}
	}

	// FIN AGINACION PROMOTOR :::::::::::::::::::::::::::::::::::::::::::::::
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fecha:{
				required : true,
				date : true
			},
			tipoMonedaID:{
				required : true,
			},
			estatus:{
				required : true,
			},
		},
		
		messages: {
			fecha: {
				required : 'La fecha es requerida',
				date : 'Especifique una fecha correcta'
			},
			tipoMonedaID: {
				required : 'Especifique El Tipo de Moneda',
			},
			estatus: {
				required : 'Especifique El Estatus',
			},
		}
	});  


	function consultaMoneda() {		
	var tipoCon = 3;
	   dwr.util.removeAllOptions('tipoMonedaID');
		dwr.util.addOptions( 'tipoMonedaID', {'0':'TODAS'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('tipoMonedaID', monedas, 'monedaID', 'descripcion');
		});
	}
	 

	
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
		$('#lista').val(8);
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
		var aportacion = $('#aportacionID').val();
		var desTipApor = $('#descripcion').val();
		var promotor = $("#promotorID").val();
		var sucursal = $("#sucursalID").val();
		var moneda = $("#tipoMonedaID option:selected").val();
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.claveUsuario;
		var nombreSucursal = $("#nombreSucursal").val();
		var nombreMoneda = $("#tipoMonedaID option:selected").text();
		var nombrePromotor = $("#nombrePromotorI").val();
		var estatus = $("#estatus option:selected").val();
		var nombreEstatus= $("#estatus option:selected").text();
		var fechaAc = parametroBean.fechaSucursal;

		

	    $('#ligaImp').attr('href','vencimientoAportacionesPDF.htm?fechaInicio='+fechaInicial+'&fechaVencimiento='+fechaFinal+
					'&sucursalID='+sucursal+'&monedaID='+moneda+'&promotorID='+promotor+
					'&aportacionID='+aportacion+'&descripcion='+desTipApor+'&nombrePromotor='+nombrePromotor+
					'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&tipoReporte='+tipoReporte+
					'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&estatus='+estatus+
					'&fechaActual='+fechaAc+'&desEstatus='+nombreEstatus); 
	

    }	

   /*REPORTE EXCEL*/
     function reporteEXCEL(){
     	    var tipoLista=$('#lista').val();
            var tipoReporte = $('#reporte').val();
		    var fechaInicial = $('#fechaInicio').val();
		    var fechaFinal = $('#fechaFin').val();
		    var aportacion = $('#aportacionID').val();
		    var desTipApor = $('#descripcion').val();
		    var promotor = $("#promotorID").val();
		    var sucursal = $("#sucursalID").val();
		    var moneda = $("#tipoMonedaID option:selected").val();
		    var nombreInstitucion =  parametroBean.nombreInstitucion;
		    var nombreUsuario = parametroBean.claveUsuario;
		    var nombreSucursal = $("#nombreSucursal").val();
		    var nombreMoneda = $("#tipoMonedaID option:selected").text();
		    var nombrePromotor = $("#nombrePromotorI").val();
		    var estatus = $("#estatus option:selected").val();
		    var nombreEstatus= $("#estatus option:selected").text();
		    var fechaAc = parametroBean.fechaSucursal;

        $('#ligaImp').attr('href','vencimientoAportacionesPDF.htm?fechaInicio='+fechaInicial+'&fechaVencimiento='+fechaFinal+
					'&sucursalID='+sucursal+'&monedaID='+moneda+'&promotorID='+promotor+
					'&aportacionID='+aportacion+'&descripcion='+desTipApor+'&nombrePromotor='+nombrePromotor+
					'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&tipoReporte='+tipoReporte+
					'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&estatus='+estatus+
					'&fechaActual='+fechaAc+'&desEstatus='+nombreEstatus+'&tipoLista='+tipoLista);
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
	
			

});
