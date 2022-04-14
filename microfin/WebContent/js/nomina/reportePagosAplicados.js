$(document).ready(function() {
	var parametroBean = consultaParametrosSession();
	//Definicion de Constantes y Enums
	esTab = true;
	var catTipoConsultaEmpleados = {
		'estatus':2
	};

	var catTipoRepPagosAplica = {
		'PDF'	: 1,
		'Excel'	: 3
	};

	var repLisPagosAplica = {
		'pagosAplicaExcel' : 2
	};

	var repPagosAplica = {
		'pagosAplicaPDF' : 2
	};

	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	agregaFormatoControles('formaGenerica');

	$('#pdf').attr("checked",true) ;

	$('#fechaInicio').val(parametroBean.fechaAplicacion);
	$('#fechaInicio').focus();
	$('#fechaFin').val(parametroBean.fechaAplicacion);
	$('#nombreEmpleado').val('TODOS');
	$('#clienteID').val('0');
	deshabilitaBoton('imprimir', 'submit');

	$('#pdf').click(function() {
		$('#excel').attr("checked",false);
		$('#pdf').attr("checked",true);

	});

	$('#excel').click(function() {
		$('#excel').attr("checked",true);
		$('#pdf').attr("checked",false);
	});


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

	//Lista las Instituciones de Nómina
	$('#institNominaID').bind('keyup',function(e){
		lista('institNominaID', '1', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function() {
		var institNominaID= $("#institNominaID").val();
		if(institNominaID==''){
			$('#nombreEmpresa').val('');
			deshabilitaBoton('imprimir', 'submit');
		}else{
			if(esTab){
				consultaInstitucionNomina(this.id);
				$('#clienteID').val('0');
				$('#nombreEmpleado').val('TODOS');
			}
		}

	});

	//Lista los clientes de la institucion de nómina
	$('#clienteID').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "institNominaID";
		camposLista[1] = "nombreCompleto";

		parametrosLista[0] = $('#institNominaID').val();
		parametrosLista[1] = $('#clienteID').val();

		lista('clienteID', '2', '2', camposLista, parametrosLista, 'listaClientes.htm');

	});

	$('#clienteID').blur(function() {
		consultaEmpleado(this.id);

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

	//Genera el reporte en PDF o Excel
	$('#imprimir').click(function() {
		var institNominaID= $("#institNominaID").val();
		var clienteID= $('#clienteID').val();
		if(institNominaID=='') {
			mensajeSis('Especifique la Empresa de Nómina.');
			$('#institNominaID').focus();
			deshabilitaBoton('imprimir', 'submit');
			$('#ligaGenerar').removeAttr("href");
		}
		else if(clienteID=='') {
			mensajeSis('Especifique el Empleado.');
			$('#clienteID').focus();
			deshabilitaBoton('imprimir', 'submit');
			$('#ligaGenerar').removeAttr("href");
		} else{
			if($('#pdf').is(":checked")){
				  generaReportePDF();
			}
			if($('#excel').is(":checked")){
				  generaReporteExcel();
			}
		}
	});

	/* =============== VALIDACIONES DE LA FORMA ================= */
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

	// Consulta de Institucion de Nomina
	function consultaInstitucionNomina(idControl) {
		var jqNombreInst = eval("'#" + idControl + "'");
		var institucionID = $(jqNombreInst).val();
		var tipoConsulta = 2 ;
		var institucionBean = {
				'institNominaID': institucionID
		};
		if(institucionID != '' && esTab){
			if(!isNaN(institucionID)) {
				institucionNominaServicio.consulta(tipoConsulta,institucionBean,function(institNomina) {
					if(institNomina!= null){
						$('#nombreEmpresa').val(institNomina.nombreInstit);
						institNomID= $('#institNominaID').val();
						nombreInstitNom=institNomina.nombreInstit;
						habilitaBoton('imprimir', 'submit');
					} else {
						mensajeSis("El Número de Empresa No Existe");
						$('#institNominaID').focus();
						$('#nombreEmpresa').val('');
						deshabilitaBoton('imprimir', 'submit');
					}
				});
			} else{
				mensajeSis('La Empresa de Nómina es Incorrecta.');
				deshabilitaBoton('imprimir', 'submit');
				$('#institNominaID').focus();
				$('#nombreEmpresa').val('');
			}
		}else{
			mensajeSis('Especifique la Empresa de Nómina.');
			deshabilitaBoton('imprimir', 'submit');
			$('#institNominaID').focus();
			$('#nombreEmpresa').val('');
		}
	}

	// Consulta de Empleado de Nomina
	function consultaEmpleado(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var numInstitucion	 = $('#institNominaID').val();
		if(numCliente != '' && !isNaN(numCliente)){
			if (numCliente != 0){
				var empleadoNominaBean = {
						'institNominaID': numInstitucion,
						'clienteID': numCliente
				};
				actualizaEstatusEmpServicio.consulta(catTipoConsultaEmpleados.estatus,empleadoNominaBean,function(empleadoNomina) {
					if(empleadoNomina != null){
						$('#nombreEmpleado').val(empleadoNomina.nombreCompleto);
						habilitaBoton('imprimir', 'submit');
					}else{
						mensajeSis('El Empleado de Nómina No Existe');
						$('#nombreEmpleado').val('');
						$('#clienteID').val('');
						$('#clienteID').focus();
					}
				});
			}else{
				$('#nombreEmpleado').val('TODOS');
				$('#clienteID').val('0');
				habilitaBoton('imprimir', 'submit');
			}
		}else{
			$('#nombreEmpleado').val('TODOS');
			$('#clienteID').val('0');
		}

	}

	//Funcion para Generar el Reporte PDF de los Pagos Aplicados
	function generaReportePDF(){
		var fechaIni = $('#fechaInicio').val();
		var fechaFin	= $('#fechaFin').val();
		var nomUsuario = parametroBean.claveUsuario;
		var nombreInstit    =  parametroBean.nombreInstitucion;
		var fechaEm = parametroBean.fechaAplicacion;
		var reporte = catTipoRepPagosAplica.PDF;
		var numeroReporte = repPagosAplica.pagosAplicaPDF;
		var cliente= $('#clienteID').val();
		$('#ligaGenerar').attr( 'href','reportePagosAplicados.htm?fechaInicio='+fechaIni+'&fechaFin='+fechaFin+
								'&reporte='+reporte+'&fechaEmision='+fechaEm+'&nombreUsuario='+nomUsuario+'&nombreInstitFin='+nombreInstit+
								'&institNominaID='+institNomID+'&tipoReporte='+numeroReporte+'&clienteID='+cliente+'&nombreInstitNomina='+nombreInstitNom);
	}

	//Funcion para Generar el Reporte Excel de los Pagos Aplicados
	function generaReporteExcel(){
		var fechaIni = $('#fechaInicio').val();
		var fechaFin	= $('#fechaFin').val();
		var nomUsuario = parametroBean.claveUsuario;
		var nombreInstit    =  parametroBean.nombreInstitucion;
		var fechaEm = parametroBean.fechaAplicacion;
		var reporte = catTipoRepPagosAplica.Excel;
		var numeroLista= repLisPagosAplica.pagosAplicaExcel;
		var cliente= $('#clienteID').val();
		$('#ligaGenerar').attr(	'href','reportePagosAplicados.htm?fechaInicio='+fechaIni+'&fechaFin='
								+fechaFin+'&reporte='+reporte+'&tipoLista='+numeroLista+'&fechaEmision='+fechaEm+
								'&nombreUsuario='+nomUsuario+'&nombreInstitFin='+nombreInstit+'&institNominaID='+institNomID+
								'&clienteID='+cliente+'&nombreInstitNomina='+nombreInstitNom);

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
					} else {
						return false;
					}
				} else {
					return false;
				}
			} else {
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
					if (comprobarSiBisisesto(anio)){ numDias=29;}else{ numDias=28;};
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

}); /* Fin document */