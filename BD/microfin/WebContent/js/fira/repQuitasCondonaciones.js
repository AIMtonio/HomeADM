$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   

	var catTipoConsultaCredito = { 
			'principal'	: 1,
			'foranea'	: 2,
			'pagareImp' : 3,
			'ValidaCredAmor':4,
			'general' : 32

	};			

	var catTipoRepQuitas = { 
			'Pantalla'	: 1,
			'PDF'		: 2,
			'Excel'		: 3 
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	 
	consultaProductoCredito();

	$('#pdf').attr("checked",true) ; 
	$('#nombreCliente').val('TODOS');
	$('#creditoID').val(0);


	$(':text').focus(function() {	
		esTab = false;
	});

	$('#promotorID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('promotorID', '1', '1', 'nombrePromotor',
				$('#promotorID').val(), 'listaPromotores.htm');
	});	


	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});

	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";


		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();

		lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});

	 

	 

	$('#fechaInicio').change(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var Xfecha= $('#fechaInicio').val();
		var Zfecha= parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').focus();
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			else{
				if (mayor(Xfecha, Zfecha) ){
					mensajeSis("La Fecha Inicial es Mayor a la Fecha Actual.");
					$('#fechaInicio').focus();
					$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
				else{
					$('#fechaVencimien').focus();
				}
			}
		}else{
			$('#fechaInicio').focus();
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});


	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaVencimien').change(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var Xfecha= parametroBean.fechaSucursal;
		var Yfecha= $('#fechaVencimien').val();
		var Zfecha= $('#fechaInicio').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaVencimien').val(parametroBean.fechaSucursal);
			}
			else{
				if ( mayor(Yfecha,Xfecha) ){
					mensajeSis("La Fecha Final es mayor a la Fecha Actual.")	;
					$('#fechaVencimien').val(parametroBean.fechaSucursal);
					$('#fechaVencimien').focus();
				}
				else{
					if ( mayor(Zfecha,Yfecha) ){
						mensajeSis("La Fecha de Final es menor a la Fecha Inicial.")	;
						$('#fechaVencimien').val(parametroBean.fechaSucursal);
					}
					else{
						$('#sucursalID').focus();
					}
				}
			}

		}else{
			$('#fechaVencimien').focus();
			$('#fechaVencimien').val(parametroBean.fechaSucursal);
		}
	});


	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '47', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');

	});
	
	$('#creditoID').blur(function() { 
		validaCredito(this.id);

	}); 
	
	
	$('#generar').click(function() { 

		if($('#pdf').is(":checked") ){
			generaPDF();
		}

		if($('#pantalla').is(":checked") ){
			generaPantalla();
		}
		
		if($('#excel').is(":checked") ){
			generaExcel();
		}

	});


	// ***********  Inicio  validacion Credito ***********
 
 
	function validaCredito(control) {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){

			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val()
			};			

			if(numCredito==0){
				$('#nombreCliente').val('TODOS');
				$('#creditoID').val(0);
			}
			else{
				creditosServicio.consulta(catTipoConsultaCredito.general,creditoBeanCon,function(credito) {
					if(credito!=null){
						esTab=true; 	
						 
						 if(credito.esAgropecuario == 'S'){
							consultaCliente(credito.clienteID);
						 }else{
   							mensajeSis("El Crédito " + credito.creditoID + " No es Agropecuario.<br>Favor de consultarla en " + "<b><a onclick=\"$('#Contenedor').load('repQuitasCondVista.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\"> Cartera. <img src=\"images/external.png\"></a></b>");
						 }
						 
					}else{
						mensajeSis("No Existe el Credito");
						$('#nombreCliente').val('TODOS');
						$('#creditoID').val(0);
					}
				});
			}

		}
	}


	function consultaCliente(numCliente) {
		 
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					 						
					$('#nombreCliente').val(cliente.nombreCompleto);
				}else{
					mensajeSis("No Existe el Cliente");
					$('#nombreCliente').val('TODOS');
					$('#creditoID').val(0);
				}    	 						
			});
		}
	}
	
	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursal');
		dwr.util.addOptions( 'sucursal', {'0':'Todas'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimien').val(parametroBean.fechaSucursal);


 

	function consultaProductoCredito() {		
		var tipoCon = 10;
		dwr.util.removeAllOptions('producCreditoID'); 
		dwr.util.addOptions( 'producCreditoID', {'0':'Todas'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('producCreditoID', productos, 'producCreditoID', 'descripcion');
		});
	}




	function generaPantalla() {
		$('#pdf').attr("checked",false) ;
		$('#excel').attr("checked",false) ;
		  
		if($('#pantalla').is(':checked')){	
			var tr= catTipoRepQuitas.Pantalla; 
			var tl= 0;  
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaVencimien').val();	
			var sucursal = $("#sucursal option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var creditoID = $('#creditoID').val();	
			var usuario = 	parametroBean.claveUsuario;
			 
			 
			var fechaEmision = parametroBean.fechaSucursal;
			
			/// VALORES TEXTO
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nombreCredito =$('#creditoID').val();	
			var nombreCte =	$('#nombreCliente').val();
			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursal option:selected").html();
			}
 

			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID option:selected").html();
			}

			if(nombreCredito=='0'  ){
				nombreCredito='';
			}else{
				nombreCredito = $('#creditoID').val();	
			}
			 
			if(nombreCte==''){
				nombreCte='';
			}else{
				nombreCte=$('#nombreCliente').val();;
			}
			$('#ligaGenerar').attr('href','reporteQuitasFiraCond.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&parFechaEmision='+fechaEmision+'&creditoID='+creditoID+'&nomCliente='+nombreCte+'&nomCredito='+nombreCredito+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&nombreSucursal='+nombreSucursal+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion);
		}
	}

	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			$('#pantalla').attr("checked",false) ;
			$('#excel').attr("checked",false) ;
			 
			var tr= catTipoRepQuitas.PDF; 
			var tl=1;

			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaVencimien').val();	
			var sucursal = $("#sucursal option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var creditoID = $('#creditoID').val();	
			var usuario = 	parametroBean.claveUsuario;
			 
			 
			var fechaEmision = parametroBean.fechaSucursal;
			
			/// VALORES TEXTO
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nombreCredito =$('#creditoID').val();	
			var nombreCte =$('#nombreCliente').val();
			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursal option:selected").html();
			}
 

			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID option:selected").html();
			}

			if(nombreCredito=='0'  ){
				nombreCredito='';
			}else{
				nombreCredito = $('#creditoID').val();	
			}
			 
			if(nombreCte==''){
				nombreCte='';
			}else{
				nombreCte=$('#nombreCliente').val();;
			}
			$('#ligaGenerar').attr('href','reporteQuitasFiraCond.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&parFechaEmision='+fechaEmision+'&creditoID='+creditoID+'&nomCliente='+nombreCte+'&nomCredito='+nombreCredito+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&nombreSucursal='+nombreSucursal+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion);
		}
	}

	function generaExcel() {	
		if($('#excel').is(':checked')){	
			$('#pantalla').attr("checked",false) ;
			$('#pdf').attr("checked",false) ;
			 
			var tr= catTipoRepQuitas.Excel; 
			var tl= 1;

			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaVencimien').val();	
			var sucursal = $("#sucursal option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var creditoID = $('#creditoID').val();	
			var usuario = 	parametroBean.claveUsuario;
			 
			 
			var fechaEmision = parametroBean.fechaSucursal;
			
			/// VALORES TEXTO
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nombreCredito =$('#creditoID').val();	
			var nombreCte =$('#nombreCliente').val();
			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursal option:selected").html();
			}
 

			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID option:selected").html();
			}

			if(nombreCredito=='0'  ){
				nombreCredito='';
			}else{
				nombreCredito = $('#creditoID').val();	
			}
			 
			if(nombreCte==''){
				nombreCte='';
			}else{
				nombreCte=$('#nombreCliente').val();;
			}
			$('#ligaGenerar').attr('href','reporteQuitasFiraCond.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&parFechaEmision='+fechaEmision+'&creditoID='+creditoID+'&nomCliente='+nombreCte+'&nomCredito='+nombreCredito+
					'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&nombreSucursal='+nombreSucursal+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion);
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea.");
				return false;
			}
			return true;
		}
	}
//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

	function mayor(fecha, fecha2){
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
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
//	FIN VALIDACIONES DE REPORTES



	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	/***********************************/


});
