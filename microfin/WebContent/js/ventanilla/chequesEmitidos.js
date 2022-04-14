$(document).ready(function(){
	var tipoReporte =2;
	var nombreInstitucion='TODAS';
	var parametros = consultaParametrosSession();
	var sucursalID="";
	var nombreSucursal="";


	consultaSucursal();
	inicializaCampos();
	habilitaBoton('generarArchivo', 'submit');
	agregaFormatoControles('formaGenerica');
	
	$('#fechaCobro').focus();
	

	$('#numCheque').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		camposLista[1] = "nombreReceptor";
		camposLista[2] = "cuentaEmisor";

		
		parametrosLista[0] = $('#bancoEmisor').val();
		parametrosLista[1] = $('#numCheque').val();
		parametrosLista[2] = $('#cuentaEmisor').val();

		
		   lista('numCheque', '2', '3', camposLista, parametrosLista, 'listaChequeSBC.htm');
	});

	$('#numCheque').blur(function() {
		if($('#numCheque').val()!='' && !isNaN($('#numCheque').val())){
			validaParametros();
		}
		else{				
			$('#numCheque').val(0);
		}
	});
	

	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});

	$('#bancoEmisor').bind('keyup',function(e) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombre";
				parametrosLista[0] = $('#bancoEmisor').val();
				lista('bancoEmisor', '2', '1', camposLista,parametrosLista,'listaInstituciones.htm');
			});

	$('#bancoEmisor').blur(function() {
		if($('#bancoEmisor').val()!='' && !isNaN($('#bancoEmisor').val())){
			consultaInstitucion(this.id);
			validaParametros();
		}
		else{
			$('#bancoEmisor').val(0);
			$('#nombreInstitucion').val('TODAS');
			nombreInstitucion='TODAS';

		}		

	});

	$('#clienteID').blur(function() {
			consultaCliente(this.id);		

	});
	
	
	$('#cuentaEmisor').blur(function() {
			consultaCuentaBan(this.id);	
	});
	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	
	$('#generarArchivo').click(function() {	
		if(validaParametros()){
			generaReporte();
		}
		
	}); 
	
	$('#cuentaEmisor').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#bancoEmisor').val();

		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#cuentaEmisor').val();

		lista('cuentaEmisor', '2', '2', camposLista,parametrosLista, 'tesoCargaMovLista.htm');	

	});
	
	$('#fechaCobro').change(function() {
		var Xfecha= $('#fechaCobro').val();
		if(esFechaValida(Xfecha)){
			if(mayor(Xfecha,parametros.fechaSucursal)){
				alert('La Fecha Indicada es Mayor a la Actual.');
				$('#fechaCobro').val(parametros.fechaSucursal);
				$('#fechaCobro').focus();
			}
			comparaFechas();
			validaParametros();

		}else{
			$('#fechaCobro').val(parametros.fechaSucursal);
		}
	});
		
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var InstitutoBeanCon = {
			'institucionID' : numInstituto
		};
	
		if (Number(numInstituto)>0 && !isNaN(numInstituto) ) {
			institucionesServicio.consultaInstitucion(2,InstitutoBeanCon, function(instituto) {
						if (instituto != null) {
							nombreInstitucion=instituto.nombreCorto;
							$('#nombreInstitucion').val(instituto.nombreCorto);
						} else {
							alert("No existe la Institución");
							$('#bancoEmisor').val(0);
							$('#bancoEmisor').focus();
							$('#nombreInstitucion').val('TODAS');
							nombreInstitucion='TODAS';
						}
					});
		}
		else{
			if($('#bancoEmisor').val()==0 && !isNaN($('#bancoEmisor').val())){						
				$('#nombreInstitucion').val('TODAS');
				nombreInstitucion='TODAS';
			}
	
		}
	}


		
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' || numCliente==0){
			$(jqCliente).val(0);
			$('#nombreCliente').val('TODOS');
		}
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero);			
					$('#nombreCliente').val(cliente.nombreCompleto);
			    
				}else{
					if(numCliente!=0){
					alert("No Existe el Socio");
					$('#clienteID').val(0);
					$('#clienteID').focus();
					$('#nombreCliente').val('TODOS');
				} 
			}
		});
		
		}			
	}
		
	function consultaCuentaBan(idControl) {
		var tipoConsulta = 9;
		var jqCuentaBan= eval("'#" + idControl + "'");
		var numCuenta = $(jqCuentaBan).val();
			
		if(numCuenta != '' && !isNaN(numCuenta)  ){
			setTimeout("$('#cajaLista').hide();", 200);	
		var DispersionBeanCta = {
				'institucionID': $('#bancoEmisor').val(),
				'numCtaInstit': numCuenta
		};
		
		if (numCuenta=='0' || numCuenta=='' ){
			$('#nombreCuenta').val("TODAS");
			$('#cuentaEmisor').val(0);
		}
		
		else{
	
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){
					$('#nombreCuenta').val(data.nombreCuentaInst);					
					$('#cuentaEmisor').val(data.numCtaInstit);
				}else{
					alert("No se encontró la cuenta bancaria.");
					$('#nombreCuenta').val('TODAS');
					$('#cuentaEmisor').val(0);
					$('#cuentaEmisor').focus();
					

				}
			});
		}
		}
			
	}
					
	function generaReporte(){
		if($('#pdf').is(":checked") ){
			tipoReporte= 1; 
		}
		if($('#excel').is(":checked") ){
			tipoReporte= 2; 
		}
		$('#ligaGenerar').attr('href','exportaReporteCheques.htm?fechaCobro='+$('#fechaCobro').val()
			+'&fechaFinCobro='+$('#fechaFinCobro').val()
			+'&bancoEmisor='+$('#bancoEmisor').val()
			+'&cuentaEmisor='+$('#cuentaEmisor').val()
			+'&numCheque='+$('#numCheque').val()
			+'&estatus='+$('#estatus').val()
			+'&clienteID='+$('#clienteID').val()
			+'&sucursalID='+$('#sucursalID').val()
			+'&tipoReporte='+tipoReporte
			+'&nombreInstitucion='+nombreInstitucion
			+'&nomSucursal='+$('#sucursalDes').val()
			+'&usuario='+parametros.claveUsuario
			+'&fechaSis='+parametros.fechaSucursal
			+'&sucMov='+parametros.nombreInstitucion);
	}

	function inicializaCampos(){
		$('#fechaCobro').val(parametros.fechaSucursal);
		$('#fechaFinCobro').val(parametros.fechaSucursal);
		$('#numCheque').val(0);
		$('#cuentaEmisor').val(0);
		$('#nombreCuenta').val('TODAS');
		$('#bancoEmisor').val(0);
		$('#nombreInstitucion').val('TODAS');
		$('#estatus').val('T').selected = true;
		$('#clienteID').val(0);
		$('#nombreCliente').val('TODOS');
	}


	
	$('#fechaFinCobro').change(function() {
		var Xfecha= $('#fechaFinCobro').val();
		if(esFechaValida(Xfecha)){
			if(mayor(Xfecha,parametros.fechaSucursal)){
				alert('La Fecha Indicada es Mayor a la Actual.');
				$('#fechaFinCobro').val(parametros.fechaSucursal);
				$('#fechaFinCobro').focus();
			}
			comparaFechas();
			validaParametros();

		}else{
			$('#fechaFinCobro').val(parametros.fechaSucursal);
		}
	});



	function validaParametros(){
		if($('#bancoEmisor').val()!='' && !isNaN($('#bancoEmisor').val()) ){
			if($('#numCheque').val()!='' && !isNaN($('#numCheque').val()) ){
				habilitaBoton('generarArchivo', 'submit');
				return true;
			}
			else{
				$('#ligaGenerar').removeAttr("href");
				deshabilitaBoton('generarArchivo', 'submit');
				return false;
			}
		}
		else{
			$('#ligaGenerar').removeAttr("href");
			deshabilitaBoton('generarArchivo', 'submit');
			return false;
		}
	}

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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				alert("Fecha Introducida Errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha Introducida Errónea");
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
		
	function comparaFechas(){
		var fechaIni = $('#fechaCobro').val();
		var fechaVen = $('#fechaFinCobro').val();
		if (fechaIni != '' && fechaVen != ''){
			var fechaIni = String(fechaIni);
			var fechaVen = String(fechaVen);
			var xYear=fechaIni.substring(0,4);
			var xMonth=fechaIni.substring(5, 7);
			var xDay=fechaIni.substring(8, 10);
			var yYear=fechaVen.substring(0,4);
			var yMonth=fechaVen.substring(5, 7);
			var yDay=fechaVen.substring(8, 10);
			
			if (yYear<xYear ){
				alert("La Fecha Final debe ser Mayor a la Fecha de Inicio");
				deshabilitaBoton('generarArchivo', 'submit');
				$('#fechaFinCobro').focus();
				$('#fechaFinCobro').val('');
				$('#fechaFinCobro').val(parametros.fechaSucursal);
			}else{
				if (xYear == yYear){
					if (yMonth<xMonth){
						alert("La Fecha Final debe ser Mayor a la Fecha de Inicio");
						deshabilitaBoton('generarArchivo', 'submit');
						$('#fechaFinCobro').focus();
						$('#fechaFinCobro').val('');
						$('#fechaFinCobro').val(parametros.fechaSucursal);
					}else{
						if (xMonth == yMonth){
							if (yDay<xDay){
								alert(" La Fecha Final debe ser Mayor a la Fecha de Inicio");
								deshabilitaBoton('generarArchivo', 'submit');
								$('#fechaFinCobro').focus();
								$('#fechaFinCobro').val('');
								$('#fechaFinCobro').val(parametros.fechaSucursal);
							}
						}
					}
				}
			}
		}
	}
	
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && numSucursal != 0) {
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#sucursalDes').val(sucursal.nombreSucurs);
				} else {
					alert("No Existe la Sucursal");
					$('#sucursalID').val('0');
					$('#sucursalDes').val('TODAS');
				}
			});
		}else{
			$('#sucursalID').val('0');
			$('#sucursalDes').val('TODAS');
		}
	}

});
