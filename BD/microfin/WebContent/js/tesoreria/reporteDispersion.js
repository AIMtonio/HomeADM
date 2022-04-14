$(document).ready(function() {
	// Definicion de Constantes y Enums
	 

	var parametroBean = consultaParametrosSession();  
	var permiteVer;
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	consultaSucursal();
	verParametrosDispersion();
	$('#fechaInicio').focus();


	var catTipoConsultaInstituciones = {
			'principal':1, 
			'foranea':2
	};
	
	$('#pdf').attr("checked",true) ; 


	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		listaAlfanumerica('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
			consultaInstitucion(this.id);
	});

	$('#cuentaAhorro').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();
		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#cuentaAhorro').val();
		listaAlfanumerica('cuentaAhorro', '2', '2', camposLista, parametrosLista, 'tesoCargaMovLista.htm');	       
	});


	$('#cuentaAhorro').blur(function() {
		validaCuentaAhorro(this.id);	 
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
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
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
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});

	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		var cuenta = $('#cuentaAhorro').val();

		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};
		if (numInstituto=='0' || $(jqInstituto).val()==''){
			 
			$('#nombreInstitucion').val('TODAS');
			$('#institucionID').val(0);
			if(cuenta != ''){
				validaCuentaAhorro();
			} 
		}
		else{
			if(numInstituto != '' && !isNaN(numInstituto) ){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
					if(instituto!=null){							
						$('#nombreInstitucion').val(instituto.nombre);
						if(cuenta != ''){
							validaCuentaAhorro();
						}
					}else{
						alert("No existe la Institución"); 
						$('#nombreInstitucion').val('');
						$('#institucionID').val('');
						if(cuenta != ''){
							validaCuentaAhorro();
						}
					}    						
				});
			}
		}

	}

	function validaCuentaAhorro(idControl){
		
		var tipoConsulta = 9;
		var institucion=$('#institucionID').val();
		var jsCuenta = eval("'#" + idControl + "'");
		var cuenta=$(jsCuenta).val();
		 
		if(institucion=='')institucion=0;
		 
		
		if(cuenta != '' && !isNaN(cuenta)  ){
			setTimeout("$('#cajaLista').hide();", 200);	
		var DispersionBeanCta = {
				'institucionID': institucion,
				'numCtaInstit': cuenta
		};

		if (cuenta=='0' || cuenta=='' ){
			$('#nombreSucurs').val("TODAS");
			$('#cuentaAhorro').val(0);
		}
		else{
				
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){

					$('#nombreSucurs').val(data.nombreCuentaInst);

				}else{
					alert("No existe el número de Cuenta.");
					$('#nombreSucurs').val('TODAS');
					$('#cuentaAhorro').val(0);
				}
			});
		}
		}

	}


	$('#generar').click(function() {	
		 generaReporteDispersion(); 	
		
	});

	// ***********  Inicio  validacion Promotor, Estado, Municipio  ***********

function generaReporteDispersion(){
	var tipoReporte = 0;
	var tipoLista = 0;
	var sucursal = $("#sucursal option:selected").val();
	var institucionID = $('#institucionID').val();
	var cuentaAho= $('#cuentaAhorro').val();
	var estatusEnc=$("#estatusEnc option:selected").val();
	var estatusDet=$("#estatusDet option:selected").val();

	var usuario = 	parametroBean.nombreUsuario; 
	
	var fechaEmision = parametroBean.fechaSucursal;

	if (estatusEnc=='T'){
		estatusEnc='';
	}
	
	if (estatusDet=='T'){
		estatusDet='';
	}
	
	if($('#fechaInicio').val()!= ''){
		var fechaInicio = $('#fechaInicio').val();	

	}else{
		alert("La Fecha de Inicio esta Vacía");
		event.preventDefault();
	}

	if($('#fechaFin').val()!= ''){
		var fechaFin = $('#fechaFin').val();	 
	}else{
		alert("La Fecha de Fin esta Vacía");
		event.preventDefault();
	}
	
	if($('#pantalla').is(':checked')){
		tipoReporte = 1;
		$('#formaPagoTR').hide();

	}
	if($('#pdf').is(':checked')){
		tipoReporte = 2;
		$('#formaPagoTR').hide();
	}
	if($('#excel').is(':checked')){
		tipoReporte=3;
		if(permiteVer == 'S'){
			$('#formaPagoTR').show();
		}
		
	}
	 
	var nombreSucursal = $("#sucursal option:selected").val();
	var nombreUsuario = parametroBean.nombreUsuario; 

	var nombreInstitucion =  parametroBean.nombreInstitucion; 
	var nombreInstitucionID = $('#nombreInstitucion').val();
	
	var nombEstatusEnc=$("#estatusEnc option:selected").html();
	var nombEstatusDet=$("#estatusDet option:selected").html();
	var nombreCuentAho = $('#cuentaAhorro').val();
	
	if(nombreSucursal=='0'){
		nombreSucursal='';
	}
	else{
		nombreSucursal = $("#sucursal option:selected").html();
	}
   if(nombreCuentAho=='0' || nombreCuentAho==''){
	   nombreCuentAho='';
   }
	 
	if(nombreInstitucionID==''){
		nombreInstitucionID='TODAS';
	}
	var formaPagoID;
	var nomFormaPago;
	if(permiteVer == 'S'){
		formaPagoID = $("#formaPago option:selected").val();
		nomFormaPago = $("#formaPago option:selected").html();
	}else{
		formaPagoID = 0;
		nomFormaPago='';
	}


	$('#ligaGenerar').attr('href','reporteOperDispersion.htm?fechaInicio='+fechaInicio+'&fechaFin='+
			fechaFin+'&sucursal='+sucursal+'&institucionID='+institucionID+'&estatusEnc='+estatusEnc+'&estatusDet='+estatusDet+
			'&cuentaAhorro='+cuentaAho+
			'&usuario='+usuario+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+
			'&nomSucursal='+nombreSucursal+'&nomUsuario='+nombreUsuario+'&fechaEmision='+fechaEmision+ 
			'&nomInstitucionID='+nombreInstitucionID+'&nomInstitucion='+nombreInstitucion+'&nomEstatus='+nombEstatusEnc+
		    '&nomEstatusMov='+nombEstatusDet+'&nombreCuentAho='+ nombreCuentAho+'&formaPagoID='+formaPagoID+'&nomFormaPago='+nomFormaPago);
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
				alert("Formato de Fecha no Válido (aaaa-mm-dd)");
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
				alert("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea.");
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
	
	
	function verParametrosDispersion(){
		paramGeneralesServicio.consulta(43,{},function(parametro){
			if (parametro != null) {
				permiteVer = parametro.valorParametro;
				if(permiteVer == 'S'){
					$('#formaPagoTR').show();
					
				}else{
					$('#formaPagoTR').hide();
					
				}
			}
		});
}

});
