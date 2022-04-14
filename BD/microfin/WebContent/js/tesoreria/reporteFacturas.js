$(document).ready(function() {
	// Definicion de Constantes y Enums
	 

	var parametroBean = consultaParametrosSession();   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	var catTipoConsultaProveedores = {
			'principal'	: 1
	};	

	$('#NombreProveedor').val('TODOS');
	$('#proveedorID').val('0');
	$('#pdf').attr("checked",true);
	$('#fechaInicio').focus();

	$('#proveedorID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();	 
			camposLista[0] = "apellidoPaterno"; 
			parametrosLista[0] = $('#proveedorID').val();
			listaAlfanumerica('proveedorID', '1', '1', camposLista, parametrosLista, 'listaProveedores.htm');
		}
	});

	$('#proveedorID').blur(function() {

		validaProveedor(this.id); 
	});
	
	$('#excel').click(function() {
		if ($('#estatus').val()=="L"){
			$('#nivel').show();
			$('#sumarizado').attr("checked",true); 
		}else{
			$('#nivel').hide();
		}
	});
	
	$('#pdf').click(function() {
			$('#nivel').hide();
	});
	
	$('#estatus').change(function() {
		if ($('#estatus').val()=="L"){
			if($('#excel').is(':checked')){
				$('#nivel').show();
				$('#sumarizado').attr("checked",true);
			}else{
				$('#nivel').hide();
			}
		}else{
			$('#nivel').hide();
		}
	
	});
	
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);	

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es Mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es Mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});

	$('#generar').click(function(){		
		  generaReporteFacturas(); 
	});

	function generaReporteFacturas(){
		var tipoReporte = 0;
		var tipoLista = 0;
		var sucursal = $("#sucursal option:selected").val();
		var estatus = $("#estatus option:selected").val();
		var usuario = 	parametroBean.nombreUsuario; 
		var proveedor = $('#proveedorID').val();
		var fechaEmision = parametroBean.fechaSucursal;
		var fechaInicio="1900-01-01";
		var fechaFin ="1900-01-01";

		if($('#fechaInicio').val()!= ''){
			fechaInicio = $('#fechaInicio').val();	

		}else{
			mensajeSis("La Fecha de Inicio esta Vacia.");
			event.preventDefault();
		}

		if($('#fechaFin').val()!= ''){
			 fechaFin = $('#fechaFin').val();	 
		}else{
			mensajeSis("La Fecha de Fin esta Vacia.");
			event.preventDefault();
		}
		if(proveedor==''){
			proveedor='0';
		}

		if($('#pdf').is(':checked')){
			tipoReporte = 2;
		}
		
		if($('#excel').is(':checked')){			
			if ($('#estatus').val()=="L"){
				if($('#sumarizado').is(':checked')){		
					tipoReporte = 3;
					tipoLista = 2;
				}else{
					tipoReporte = 4;
					tipoLista = 3;
				}
			}else{
				tipoReporte = 3;
				tipoLista = 2;
			}
		}
		
		/// VALORES TEXTO
		var nombreSucursal = $("#sucursal option:selected").val();
		var nombreUsuario = parametroBean.nombreUsuario; 
		var nombreProveedor = $('#NombreProveedor').val();
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var nombreEstatus = $("#estatus option:selected").html();
		var tipoCaptura = $('#tipoCaptura').val();
		var desTipoCaptura	= $("#tipoCaptura option:selected").html();
		
		if(nombreSucursal=='0'){
			nombreSucursal='TODAS';
		}
		else{
			nombreSucursal = $("#sucursal option:selected").html();
		}

		if(nombreProveedor==''){
			nombreProveedor='TODOS';
		}
 
		$('#ligaGenerar').attr('href','reporteFacturas.htm?fechaInicio='+fechaInicio+
															'&fechaFin='+fechaFin+
															'&sucursal='+sucursal+
															'&proveedorID='+proveedor+
															'&estatus='+estatus+
															'&usuario='+usuario+
															'&tipoReporte='+tipoReporte+
															'&tipoLista='+tipoLista+
															'&nombreSucursal='+nombreSucursal+
															'&nombreUsuario='+nombreUsuario+
															'&parFechaEmision='+fechaEmision+ 
															'&nombreProveedor='+nombreProveedor+
															'&nombreInstitucion='+nombreInstitucion+
															'&nombreEstatus='+nombreEstatus+
															'&tipoCaptura='+tipoCaptura+
															'&desTipoCaptura='+desTipoCaptura);


	}
	// ***********  Inicio  validacion Promotor, Estado, Municipio  ***********

	function validaProveedor(control) {
		var numProveedor = $('#proveedorID').val();
		var nombreProv='';
		setTimeout("$('#cajaLista').hide();", 200);

		if(numProveedor != '' && !isNaN(numProveedor)  	){

			if(numProveedor==0){
				$('#NombreProveedor').val('TODOS');				
			}
			else{
				var proveedorBeanCon = { 
						'proveedorID':$('#proveedorID').val()
				};
				//////////consulta de proveedores/////////////////////////////			 
				proveedoresServicio.consulta(catTipoConsultaProveedores.principal,proveedorBeanCon,function(proveedores) {
					if(proveedores!=null){

						if(proveedores.tipoPersona=='F'){                          
							nombreProv	= $.trim(proveedores.primerNombre)  +' '+ $.trim(proveedores.segundoNombre) +' ';
							nombreProv += $.trim( proveedores.apellidoPaterno)  +' '+ $.trim(proveedores.apellidoMaterno) ;    		
						}
						if(proveedores.tipoPersona=='M'){
							nombreProv= proveedores.razonSocial;
						}

						$('#NombreProveedor').val(nombreProv);

					}else{
						mensajeSis("No Existe el Proveedor.");
						$('#NombreProveedor').val('TODOS');
						$('#proveedorID').val('0');
					}
				});
			}

		}

		if($.trim(numProveedor) == ''){
			$('#NombreProveedor').val('Todos');
			$('#proveedorID').val('0');
		}

	}






	// fin validacion Promotor, Estado, Municipio


	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursal');
		dwr.util.addOptions( 'sucursal', {'0':'TODAS'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	 





//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

	function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
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

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
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
