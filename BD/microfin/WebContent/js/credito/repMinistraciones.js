var manejaConvenio = 'N';
var nombreInstit;
var desConvenio;

$(document).ready(function() {

	$('.datosNominaE').hide();
	$('.datosNominaC').hide();
	inicializaCamposNom();
	// Definicion de Constantes y Enums
	consultaManejaConvenios();
	esTab = true;
	$('#esNomina').val("N");
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
	var parametroBean = consultaParametrosSession();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	consultaMoneda();
	consultaProductoCredito();

	$('#pdf').attr("checked",true) ;
	$('#detallado').attr("checked",true) ;

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimien').val(parametroBean.fechaSucursal);

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimien').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaVencimien').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimien').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimien').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimien').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaVencimien').val(parametroBean.fechaSucursal);
		}

	});





	$(':text').focus(function() {
		esTab = false;
	});

	$('#pantalla').click(function() {
		$('#pdf').attr("checked",false);
		$('#excel').attr("checked",false);
	});

	$('#pdf').click(function() {
		$('#pantalla').attr("checked",false);
		$('#excel').attr("checked",false);
	});

	$('#excel').click(function() {
		$('#pantalla').attr("checked",false);
		$('#pdf').attr("checked",false);
	});


	$('#excel').click(function() {
		if($('#excel').is(':checked')){
		}
	});

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){
			$('#tdPresenacion').show('slow');
		}
	});

	//
	$('#producCreditoID').change(function(){
		setTimeout("$('#cajaLista').hide();", 200);

		if($('#producCreditoID').val()!=null && $('#producCreditoID').val()!=""){
			if($('#producCreditoID').val()=='0'){
				$('#esNomina').val("N");
				ocultarEmpresaConvenio();
			}else{

				consultaProductoCreditoNomina($('#producCreditoID').val());
			}
		}
	});


	$('#empresaID').bind('keyup',function(e){
		lista('empresaID','2','1','institNominaID',$('#empresaID').val(),'institucionesNomina.htm');
	});

	$('#empresaID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);

		if((isNaN($('#empresaID').val()) || $('#empresaID').val() == '' || $('#empresaID').val() == 0)) {
			$('#empresaID').val('0');
			$('#nombreEmpresaI').val('TODOS');
			return;
		}
		funcionConsultaInstitucionNomina(this.id);
	});

	$('#convenioNominaID').bind('keyup', function(e) {
		if($('#empresaID').val()==0 || $('#empresaID').val()==''){
			lista('convenioNominaID','2',1,'descripcion',$('#convenioNominaID').val(),'listaConveniosNomina.htm');
		}else{
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = 'institNominaID';
			camposLista[1] = 'descripcion';
			parametrosLista[0] = $('#empresaID').val();
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
	//--fin cambio

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


	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});

	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});

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
				mensajeSis('no se encontrò el producto');
			}
		});
	}

	function mostrarEmpresaConvenio(){
		$('.datosNominaE').show();

		$('#empresaID').val('0');
		$('#nombreEmpresaI').val('TODOS');
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

		$('#empresaID').val('0');
		$('#nombreEmpresaI').val('');
		$('.datosNominaE').hide();
		$('.datosNominaC').hide();

		$('#convenioNominaID').val('0');
		$('#nombreConvenio').val('');
	}
	function funcionConsultaInstitucionNomina(idControl) {
		var jqControl = eval("'#" + idControl + "'");
		var beanEntrada = {
			'institNominaID': $(jqControl).val()
		};
		setTimeout("$('#cajaLista').hide();", 200);


		if($(jqControl).val() != '' && !isNaN($(jqControl).val()) && !$(jqControl).val()==0) {
			institucionNomServicio.consulta(1, beanEntrada, function(resultado) {
				if(resultado != null) {
					$('#nombreEmpresaI').val(resultado.nombreInstit);
				} else {
					mensajeSis('La empresa de nómina no existe');
					dwr.util.removeAllOptions('convenioNominaID');
				}
			});
		}

	}

	function funcionConsultaConveniosNomina(idControl){
		var jqControl = eval("'#" + idControl + "'");
		var beanEntrada = {
				'convenioNominaID': $(jqControl).val()
		};
		setTimeout("$('#cajaLista').hide();",200);

		if($(jqControl).val() != '' && !isNaN($(jqControl).val()) && !$(jqControl).val()==0){
			conveniosNominaServicio.consulta(tipoConsulta.consultaPrincipal,beanEntrada,function(resultado){
				if(resultado != null){
					if(resultado.institNominaID !=$("#empresaID").val()){
						mensajeSis("El convenio seleccionado no corresponde a la empresa de nómina");
						dwr.util.removeAllOptions('conveniosNominaServicio');
						$('#convenioNominaID').val('0');
						$('#nombreConvenio').val('TODOS');
						$('#convenioNominaID').focus();
					}else{
						$('#nombreConvenio').val(resultado.descripcion);
					}
					
				}else{
					mensajeSis('El convenio de nómina no existe');
					dwr.util.removeAllOptions('conveniosNominaServicio');
					$('#convenioNominaID').val('0');
					$('#nombreConvenio').val('TODOS');
					$('#convenioNominaID').focus();
				}
			});
		}
	}

	$('#generar').click(function() {
		var tipoReporte = 0;
		var tipoLista = 2;
		var numLista = 0;
		var sucursal = $("#sucursal option:selected").val();
		var moneda = $("#monedaID option:selected").val();
		var producto = $("#producCreditoID option:selected").val();
		var usuario = 	parametroBean.nombreUsuario;
		var promotorID = $('#promotorID').val();
		var genero =$("#sexo option:selected").val();
		var estadoID=$('#estadoID').val();
		var municipioID=$('#municipioID').val();
		var institucionNominaID=$('#empresaID').val();
		var convenioNominaID =$('#convenioNominaID').val();


		var fechaEmision = parametroBean.fechaSucursal;

		if($('#fechaInicio').val()!= ''){
			fechaInicio = $('#fechaInicio').val();

		}else{
			mensajeSis("La fecha de inicio esta vacia");
			event.preventDefault();
		}

		if($('#fechaVencimien').val()!= ''){
			fechaFin = $('#fechaVencimien').val();
		}else{
			mensajeSis("La fecha de fin esta vacia");
			event.preventDefault();
		}


		if($('#pantalla').is(':checked')){
			tipoReporte = 1;

		}
		if($('#pdf').is(':checked')){
			tipoReporte = 2;
		}
		if($('#excel').is(':checked')){
			tipoReporte = 3;
		}

		var nivelDetalle=1;
		if($('#detallado').is(':checked'))	{
			nivelDetalle=1;
			numLista=3;
		}
		else
			if($('#sumarizado').is(':checked'))	{
				nivelDetalle=0;
				numLista=2;
			}

		/// VALORES TEXTO
		var nombreSucursal = $("#sucursal option:selected").val();
		var nombreMoneda = $("#monedaID option:selected").val();
		var nombreProducto = $("#producCreditoID option:selected").val();
		var nombreUsuario = parametroBean.nombreUsuario;
		var nombrePromotor = $('#nombrePromotorI').val();
		var nombreGenero =$("#sexo option:selected").val();
		var nombreEstado=$('#nombreEstado').val();
		var nombreMunicipio=$('#nombreMuni').val();
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var esNomina=$('#esNomina').val();
		    nombreInstit=$('#nombreEmpresaI').val();
		    desConvenio=$('#nombreConvenio').val();
		    manejaConv  = $("#manejaConvenio").val();



		if(nombreSucursal=='0'){
			nombreSucursal='';
		}
		else{
			nombreSucursal = $("#sucursal option:selected").html();
		}

		if(nombreMoneda=='0'){
			nombreMoneda='';
		}else{
			nombreMoneda = $("#monedaID option:selected").html();
		}

		if(nombreProducto=='0'){
			nombreProducto='';
		}else{
			nombreProducto = $("#producCreditoID option:selected").html();
		}

		if(nombreGenero=='0'){
			nombreGenero='';
		}else{
			nombreGenero =$("#sexo option:selected").html();
		}

		if(genero=='0'){
			genero='';
		}

		$('#ligaGenerar').attr('href','RepMinistracionesCred.htm?fechaInicio='+fechaInicio+'&fechaVencimien='+
				fechaFin+'&monedaID='+moneda+'&sucursal='+sucursal+'&producCreditoID='+producto+
				'&usuario='+usuario+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+
				'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
				'&nivelDetalle='+nivelDetalle+'&institucionNominaID='+institucionNominaID+'&convenioNominaID='+convenioNominaID+
				'&esNomina='+esNomina+'&numLista='+numLista+
				'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+'&parFechaEmision='+fechaEmision+
				'&nombrePromotor='+nombrePromotor+'&nombreGenero='+nombreGenero+'&nombreEstado='+nombreEstado+'&nombreMunicipi='+nombreMunicipio+'&nombreInstitucion='+nombreInstitucion+
				'&nombreInstit='+nombreInstit+
				'&desConvenio='+desConvenio+
				'&manejaConvenio='+manejaConv);
	});

	// ***********  Inicio  validacion Promotor, Estado, Municipio  ***********

	function consultaPromotorI(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor==0){
			$(jqPromotor).val(0);
			$('#nombrePromotorI').val('TODOS');
		}
		else

			if(numPromotor != '' && !isNaN(numPromotor) ){
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) {
					if(promotor!=null){
						$('#nombrePromotorI').val(promotor.nombrePromotor);

					}else{
						mensajeSis("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotorI').val('TODOS');
					}
				});
			}
	}


	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numEstado == '' || numEstado==0){
			$('#estadoID').val(0);
			$('#nombreEstado').val('TODOS');

			var municipio= $('#municipioID').val();
			if(municipio != '' && municipio!=0){
				$('#municipioID').val('');
				$('#nombreMuni').val('TODOS');
			}
		}
		else
			if(numEstado != '' && !isNaN(numEstado) ){
				estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
					if(estado!=null){
						$('#nombreEstado').val(estado.nombre);

						var municipio= $('#municipioID').val();
						if(municipio != '' && municipio!=0){
							consultaMunicipio('municipioID');
						}

					}else{
						mensajeSis("No Existe el Estado");
						$('#estadoID').val(0);
						$('#nombreEstado').val('TODOS');
					}
				});
			}
	}


	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();
		var numEstado =  $('#estadoID').val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMunicipio == '' || numMunicipio==0 || numEstado == '' || numEstado==0){

			if(numEstado == '' || numEstado==0 && numMunicipio!=0){
				mensajeSis("No ha selecionado ningún estado.");
				$('#estadoID').focus();
			}
			$('#municipioID').val(0);
			$('#nombreMuni').val('TODOS');
		}
		else
			if(numMunicipio != '' && !isNaN(numMunicipio)){
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){
						$('#nombreMuni').val(municipio.nombre);

					}else{
						mensajeSis("No Existe el Municipio");
						$('#municipioID').val(0);
						$('#nombreMuni').val('TODOS');
					}
				});
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

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	function consultaMoneda() {
		var tipoCon = 3;
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'TODAS'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function consultaProductoCredito() {
		var tipoCon = 2;
		dwr.util.removeAllOptions('producCreditoID');
		dwr.util.addOptions( 'producCreditoID', {'0':'TODAS'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('producCreditoID', productos, 'producCreditoID', 'descripcion');
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


	function inicializaCamposNom(){
		$("#sucursal").val("TODAS");
		$("#monedaID").val("TODAS");
		$("#producCreditoID").val("TODAS");
		$("#promotorID").val(0);
		$("#nombrePromotorI").val("TODOS");
		$("#estadoID").val(0);
		$("#nombreEstado").val("TODOS");
		$("#municipioID").val(0);
		$("#nombreMuni").val("TODOS");
		$("#empresaID").val(0);
		$("#nombreEmpresaI").val("TOD0S");
		$("#convenioNominaID").val(0);
		$("#nombreConvenio").val("TOD0S");

	}

});
