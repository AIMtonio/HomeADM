$(document).ready(function(){
	var parametroBean = consultaParametrosSession();
	var esTab= true;
	var tipoReporte = null;
	agregaFormatoControles('formaGenerica');
	
	deshabilitaBoton('generar', 'button');
	$('#pdf').attr("checked",true) ; 
	$('#fechaInicio').val(parametroBean.fechaAplicacion);
	$('#fechaFin').val(parametroBean.fechaAplicacion);
	$('#institNominaID').val('0');
	$('#institNomina').val('TODAS')
	$('#nombreCliente').val('TODOS');
	$('#clienteID').val('0');
	$('#folioID').focus();
	
	tipoReporte= '1';
	/*pone tap falso cuando toma el foco input text */
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	/*pone tab en verdadero cuando se presiona tab */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	$.validator.setDefaults({
		submitHandler: function(event) { 	
		
	  }
	});
	
	
	
	$('#formaGenerica').validate({			
		rules: {
			institNominaID :{ 
				required:true
				},
				clienteID :{
				required:true
				}
		},		
		messages: {
			institNominaID :{
				required:'Ingrese una Empresa de Nómina.',
			},
			clienteID :{
				required:'Ingrese un Número de Empleado.'
				}
		}		
	});
	
	$('#folioID').bind('keyup',function(e){
		lista('folioID', '1', '3', 'institNominaID', $('#folioID').val(), 'institucionesNomina.htm');
	});
	
	$('#folioID').blur(function(){
		if(esTab){
			consultaFolioDomiciPagos(this.id);
			
		}
	});
	
	$('#institNominaID').bind('keyup',function(){
		lista('institNominaID', '1', '4', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});
	
	$('#institNominaID').blur(function(){
		var institNominaID= $("#institNominaID").val();
		if(institNominaID=='' || institNominaID==null || institNominaID=='0'){
			$('#institNominaID').val('0');
			$('#institNomina').val('TODAS');
		}else{
			if(esTab){
				consultaInstitucionNomina(this.id);
				$('#clienteID').val('0');
				$('#nombreCliente').val('TODOS');
			}
		}
	});
	
	$('#clienteID').bind('keyup',function(){
		lista('clienteID','2','39','nombreCompleto',$('#clienteID').val(),'listaCliente.htm');
	});
	
	$('#clienteID').blur(function(){
		var clienteID = $('#clienteID').val();
		if(clienteID == ''){
			$('#nombreCliente').val('');
		}else{
			if(esTab){
				consultaCliente(this.id);
			}
		}
	});
	
	
	
	
	//Valida la fecha de inicio del reporte
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Inicio no Debe ser Mayor a la Fecha Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha Inicio no Debe ser Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
		regresarFoco('fechaInicio');
	});

	//Valida la fecha de fin del reporte
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Fin no Debe ser Menor a la Fecha Inicio.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha  Final  es Mayor a la Fecha del Sistema.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}				
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
		regresarFoco('fechaFin');
	});
	
	 $('#pdf').click(function() {
			$('#excel').attr("checked",false); 
			$('#pdf').attr("checked",true); 
			tipoReporte = '1';
		
		});
		
		$('#excel').click(function() {
			$('#excel').attr("checked",true); 
			$('#pdf').attr("checked",false);
			tipoReporte='2';
		});
	
	
	
	
		$('#ligaGenerar').click(function(){
			generaReporte();
		});


/*funciones para validar las fechas*/
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
 
 
 
//consuta folio de Pago de domiciliaicon
 function consultaFolioDomiciPagos(idControl){
 	var jqFolio	= eval("'#"+idControl+"'");
 	var folioID = $(jqFolio).val();
 	var tipoConsulta = 1;
 	var Bitacorabean={
 			'folioID':$('#folioID').val()
 	}
 	if(folioID != '' && esTab){
 		if(!isNaN(folioID)) {
 			bitacoraDomiciPagosServicio.consulta(1,Bitacorabean,function(datos){
 				
 				if(datos != null){
 					$('#fechaInicio').val(datos.fecha);
 					$('#fechaFin').val(datos.fecha);
 					llenacomboFrecuencia(idControl);
 					habilitaBoton('generar', 'submit');
 				}else{
 					mensajeSis("El Folio de Domiciliación no Existe.");
 					$('#folioID').focus();
 				}
 				
 			});
 		}else{
 			mensajeSis('El Folio de Domiciliación es Incorrecta.');
 			$('#folioID').focus();
 			$('#folioID').val('');
 		}
 	}else{
 		mensajeSis('Especifique Folio Domiciliación.');
 		$('#folioID').focus();
 	}
 }


 //Consulta de Institucion de Nomina
 function consultaInstitucionNomina(idControl) {
 	var jqNombreInst = eval("'#" + idControl + "'");
 	var institucionID = $(jqNombreInst).val();	
 	var tipoConsulta = 1 ;
 	var institucionBean = {
 			'institNominaID': institucionID				
 	};	
 	if(institucionID != '' && esTab){ 
 		if(institucionID == '0' || institucionID ==0){
 			$('#institNomia').val('TODOS');
 		}else{
 			if(!isNaN(institucionID)) {
 				institucionNomServicio.consulta(tipoConsulta,institucionBean,function(institNomina) {
 				if(institNomina!= null){
 					$('#institNomina').val(institNomina.nombreInstit);
 					}
 				else {
 					mensajeSis("El Número de Empresa No Existe");
 					$('#institNominaID').focus();
 					$('#institNominaID').val('0');
 					$('#institNomina').val('TODAS');
 				}
 				});
 			 }
 			else{
 				mensajeSis('La Empresa de Nómina es Incorrecta.');
 				$('#institNominaID').focus();
 				$('#institNominaID').val('0');
 				$('#institNomina').val('TODAS');
 			}
 	}
 	}else{
 		mensajeSis('Especifique la Empresa de Nómina.');
 		$('#institNominaID').focus();
 		$('#institNominaID').val('0');
		$('#institNomina').val('TODAS');
 	}
 }

 function consultaCliente(idControl){
 	var jqCliente = eval("'#" + idControl + "'");
 	var clienteID = $(jqCliente).val();	
 	var tipoConsulta = 2 ;
 	var clienteBean = {
 			'clienteID': clienteID				
 	};	
 	if(clienteID != '' && esTab){ 
 		if(clienteID == '0'){
 			$('#nombreCliente').val('TODOS');
 		}else{
 			if(!isNaN(clienteID)) {
 				clienteServicio.consulta(tipoConsulta,clienteID,function(cliente) {
 					if(cliente!= null){
 						$('#clienteID').val(cliente.numero)
 						$('#nombreCliente').val(cliente.nombreCompleto)
 					}else{
 						mensajeSis("El Cliente No Existe");
 						$('#clienteID').focus();
 						$('#clienteID').val('');
 					}
 				});
 			}
 			else{
 				mensajeSis('El Cliente es Incorrecta.');
 				$('#clienteID').focus();
 				$('#nombreCliente').val('');
 			}
 		}
 		
 	}else{
 		mensajeSis('Especifique Cliente.');
 		$('#clienteID').focus();
 		$('#nombreCliente').val('');
 	}
 }
 
 
 /*Funcion para llenar el combo de las frecuencias de pago*/
 function llenacomboFrecuencia(idControl){
	 var jqFolio	= eval("'#"+idControl+"'");
	 var folioID = $(jqFolio).val();
	 var tipoLista = 2;
	 var Bitacorabean={
	 	'folioID':folioID
	 }
	 bitacoraDomiciPagosServicio.lista(tipoLista,Bitacorabean,{async:false,callback:function(listaBean){
			if(listaBean!=null){
				 var tamanio = listaBean.length;;
				 $('#frecuencia option').remove();
				 $('#frecuencia').append(
					new Option('TODAS','',true,true)
				 );
				 for ( var i = 0; i < tamanio; i++) {
					 $('#frecuencia').append(
								new Option(listaBean[i].descFrecuencia,listaBean[i].frecuencia, true,
										true));	
				 }
				 $('#frecuencia').val('').selected = true;
			 }
	 	}
	 });
 }
	 
 function generaReporte(){
	 	  var folioID = $('#folioID').val();
		  var fechaIni = $('#fechaInicio').val();
		  var fechaFin	= $('#fechaFin').val();
		  var nombreInstit    =  parametroBean.nombreInstitucion;
		  var fechaEm = parametroBean.fechaAplicacion;
		  var cliente= $('#clienteID').val();
		  var nomCliente = $('#nombreCliente').val();
		  var institNominaID = $('#institNominaID').val();
		  var institNomina = $('#institNomina').val();
		  var frecuencia =$('#frecuencia').val();
		  var descFrecuencia = $("#frecuencia option:selected").html();

			$('#ligaGenerar').attr('href','repBitacoraPagos.htm?folioID='+folioID+
																'&fechaInicio='+fechaIni+
																'&fechaFin='+fechaFin+
																'&institNominaID='+institNominaID+
																'&institNomina='+institNomina+
																'&frecuencia='+frecuencia+
																'&clienteID='+cliente+
																'&nombreCliente='+nomCliente+
																'&nombreInstitucion='+nombreInstit+
																'&fechaReporte='+fechaEm+
																'&descFrecuencia='+descFrecuencia+
																'&tipoReporte='+tipoReporte);	
 }
 
});

