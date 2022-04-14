var parametroBean = consultaParametrosSession();
var manejaConvenio = 'N';
var tipoLista = {
		'listaAyuda' : 1,
		'listaConveniosActivos': 2,
		'listaAyudaEmpleados': 3,
		'listaGridEmpleados': 4,
		'listaAyudaTodosConv': 8
	};
var tipoConsulta = {
		'consultaPrincipal': 1
	};


var catTipoCreditoSusp = {
		'PDF'		: 1,
		'Excel'		: 2 
};	

$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$('#institucionNominaID').val('0');
	$('#nombreInstitucion').val('TODOS');
	$('#convenioNominaID').val('0');
	$('#nombreConvenio').val('TODOS');
	$('#productoCreditoID').val('0');
	$('#descripcion').val('TODOS');

	consultaManejaConvenios();

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text, :button, :submit, select').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text, :button, :submit, textarea, select').blur(function() {
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#formaGenerica :input:enabled:visible:first').focus();
			}, 0);
		}
	});

    $('#productoCreditoID').bind('keyup',function(e){
		lista('productoCreditoID', '1', '1','descripcion', $('#productoCreditoID').val(),'listaProductosCredito.htm');
	});

	$('#productoCreditoID').blur(function() {
		if((isNaN($('#productoCreditoID').val()) || $('#productoCreditoID').val() == '' || $('#productoCreditoID').val() == 0)) {
			$('#productoCreditoID').val('0');
			$('#descripcion').val('TODOS');
			return;
		}
		consultaProductoNotas(this.id);
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var fechaFin = $('#fechaFin').val();
		if ( mayor(Xfecha, fechaFin) )
		{
			mensajeSis("La Fecha de Inicio no puede ser mayor a la Fecha de Fin.")	;
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var fechaFin = $('#fechaFin').val();
		var fechaSuc = parametroBean.fechaSucursal;
        
			if ( menor(fechaFin, Xfecha) )
			{
				mensajeSis("La Fecha de Fin no debe ser menor a la Fecha Inicial.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(fechaFin, fechaSuc) )
			{
				mensajeSis("La Fecha de Fin no puede ser mayor a la Fecha del Sistema.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
	});

	$('#generar').click(function() { 
			generaExcel();
	});

	$('#formaGenerica').validate({
		rules: {
			fechaInicial :{
				required: true
			},
			atrasoFinal :{
				required: true
			}
		},
		
		messages: {
			fechaInicial :{
				required: 'Especifique la fecha inicial.'
			}
			,atrasoFinal :{
				required: 'Especifique la fecha final.'
			}
		}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	
	//INSTITUCION NOMINA
	$('#institucionNominaID').bind('keyup',function(e){
		lista('institucionNominaID','2','1','institNominaID',$('#institucionNominaID').val(),'institucionesNomina.htm');
	});

	
	$('#institucionNominaID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);

		if((isNaN($('#institucionNominaID').val()) || $('#institucionNominaID').val() == '' || $('#institucionNominaID').val() == 0)) {
			$('#institucionNominaID').val('0');
			$('#nombreInstitucion').val('TODOS');
			return;
		}
		consultaInstitucionNomina(this.id);
	});
	
	function consultaInstitucionNomina(idControl) {
		
			var jqControl = eval("'#" + idControl + "'");
			var beanEntrada = {
				'institNominaID': $(jqControl).val()
			};
			setTimeout("$('#cajaLista').hide();", 200);


			if($(jqControl).val() != '' && !isNaN($(jqControl).val()) && !$(jqControl).val()==0) {
				institucionNomServicio.consulta(1, beanEntrada, function(resultado) {
					if(resultado != null) {
						$('#nombreInstitucion').val(resultado.nombreInstit);
					} else {
						
						mensajeSis('La empresa de nómina no existe');
						$('#institucionNominaID').focus();
						$('#nombreInstitucion').val('');
					}
				});
			}
	}
	

	$('#convenioNominaID').bind('keyup', function(e) {
		if($('#institucionNominaID').val()==0 || $('#institucionNominaID').val()==''){
			lista('convenioNominaID','2',1,'descripcion',$('#convenioNominaID').val(),'listaConveniosNomina.htm');
		}else{
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = 'institNominaID';
			camposLista[1] = 'descripcion';
			parametrosLista[0] = $('#institucionNominaID').val();
			parametrosLista[1] = $('#convenioNominaID').val();
			lista('convenioNominaID', '2', tipoLista.listaAyuda, camposLista, parametrosLista, 'listaConveniosNomina.htm');
		}
	});
	
	
	$('#convenioNominaID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);

		if((isNaN($('#convenioNominaID').val()) || $('#convenioNominaID').val()=='' || $('#convenioNominaID').val()==0)){
			$('#convenioNominaID').val('0');
			$('#nombreConvenio').val('TODOS');
			return;
		}
		funcionConsultaConveniosNomina(this.id);
	});
	
	function funcionConsultaConveniosNomina(idControl){
		var jqControl = eval("'#" + idControl + "'");
		var beanEntrada = {
				'convenioNominaID': $(jqControl).val()
		};
		setTimeout("$('#cajaLista').hide();",200);

		if($(jqControl).val() != '' && !isNaN($(jqControl).val()) && !$(jqControl).val()==0){
			conveniosNominaServicio.consulta(tipoConsulta.consultaPrincipal,beanEntrada,function(resultado){
				if(resultado != null){
					$('#nombreConvenio').val(resultado.descripcion);
				}else{
					mensajeSis('El convenio de nómina no existe');
					$('#convenioNominaID').focus();
					$('#nombreConvenio').val('');
				}
			});
		}
	}

	function generaExcel() {
			var tipoReporte = 2;
			var tr= catTipoCreditoSusp.Excel; 
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaFin').val();	
			var producto = $("#productoCreditoID option:selected").val();
			var institucion = $("#institucionNominaID option:selected").val();
			var convenio = $("#convenioNominaID option:selected").val();

			/// VALORES TEXTO
			var nombreProducto = $("#productoCreditoID option:selected").val();
			var nombreInstitucion = $("#institucionNominaID option:selected").val();
			var nombreConvenio = $("#convenioNominaID option:selected").val();

			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#productoCreditoID option:selected").html();
			}
			
			if(nombreInstitucion=='0'){
				nombreInstitucion='';
			}
			else{
				nombreInstitucion = $("#institucionNominaID option:selected").html();
			}
			
			if(nombreConvenio=='0'){
				nombreConvenio='';
			}
			else{
				nombreConvenio = $("#convenioNominaID option:selected").html();
			}

			var pagina = 'repNotasCargo.htm?fechaInicio='+fechaInicio+'&fechaFin='+
							fechaFin+'&productoCreditoID='+producto+'&institucionNominaID='+institucion+
							'&nombreInstitucion='+nombreInstitucion+'&convenioNominaID='+convenio+
							'&nombreConvenio='+nombreConvenio+'&tipoReporte='+tipoReporte+'&nombreProducto='+nombreProducto;
		    $('#ligaGenerar').attr('href',pagina);
		    window.open(pagina,'_blank');

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
	
	function menor(fecha, fecha2){ // valida si fecha < fecha2
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);

		if (xAnio < yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes < yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia < yDia){
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

	
	//Metodo Para consultar si se maneja convenios
	function consultaManejaConvenios(){
	    var tipoConsulta = 36;
	    var bean = {
	            'empresaID'     : 1
	        };
	    paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
	            if (parametro != null){
	                manejaConvenio = parametro.valorParametro;
	            }else {
	                manejaConvenio = 'N';
	            }
	    }});
	}
	
	

});

function consultaProductoNotas(idControl){

	var jqProd = eval("'#" + idControl + "'");
	var numProducto = $(jqProd).val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numProducto != '' && !isNaN(numProducto) && esTab){
		var productoBeanCon = { 
				'producCreditoID':numProducto
		}; 
		 productosCreditoServicio.consulta(tipoConsulta.consultaPrincipal, productoBeanCon, function(objProducto){
			if(objProducto != null){
				esTab=true;

				$('#productoCreditoID').val(objProducto.producCreditoID);
				$('#descripcion').val(objProducto.descripcion);
				consultaProductoCreditoNomina($('#productoCreditoID').val());
			}else{
				mensajeSis("El producto no existe.");
				$('#descripcion').val('');
				$('#productoCreditoID').focus();
			}
		});
	}
}

function consultaProductoCreditoNomina(productoCreditoID){
	var prodCreditoBeanCon = {
			'producCreditoID' : productoCreditoID
	};
	productosCreditoServicio.consulta(tipoConsulta.consultaPrincipal,prodCreditoBeanCon,function(resultado){
		if(resultado!=null){
			if(resultado.productoNomina=='S'){
				mostrarEmpresaConvenio();
				$('#esNomina').val(resultado.productoNomina);
				$("#manejaConvenio").val(manejaConvenio);
			}else{
				ocultarEmpresaConvenio();
				$('#esNomina').val(resultado.productoNomina);
				$("#manejaConvenio").val(manejaConvenio);
			}
		}else{
			$('#esNomina').val("N");
			$("#manejaConvenio").val(manejaConvenio);
			mensajeSis('no se encontró el producto');
		}
	});
}

function mostrarEmpresaConvenio(){
	$('.datosNominaI').show();
	$('#institucionNominaID').val('0');
	$('#nombreInstitucion').val('TODOS');
	if(manejaConvenio == "S")
	{
	$('.datosNominaC').show();
	}else{
		$('.datosNominaC').hide();
	}
	$('#convenioNominaID').val('0');
	$('#nombreConvenio').val('TODOS');
}

function ocultarEmpresaConvenio(){
	$('#institucionNominaID').val('0');
	$('#nombreInstitucion').val('TODOS');
	$('.datosNominaI').hide();
	$('.datosNominaC').hide();

	$('#convenioNominaID').val('0');
	$('#nombreConvenio').val('TODOS');
}