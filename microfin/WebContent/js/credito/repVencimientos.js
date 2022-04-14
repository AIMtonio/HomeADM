var manejaConvenio = 'N';
var nombreInstit;
var desConvenio;

$(document).ready(function() {
	$('.datosNominaE').hide();
	$('.datosNominaC').hide();
	inicializaCamposNom();
	consultaManejaConvenios();
	// Definicion de Constantes y Enums
	esTab = true;
	$('#fechaInicio').focus();
	$('#esNomina').val("N");

	var atrasoInicial = 0;
	var atrasoFinal = 99999;
	var parametroBean = consultaParametrosSession();

	var tipoConsulta = {
			'consultaPrincipal': 1
		};
	var tipoLista = {
			'listaAyuda' : 1,
	};

	var catTipoLisVencimientos  = {
			'vencimientosExcel'	: 8
	};

	var catTipoRepVencimientos = {
			'Pantalla'	: 1,
			'PDF'		: 2,
			'Excel'		: 3
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	consultaMoneda();
	consultaProductoCredito();
	$('#atrasoInicial').val(atrasoInicial);
	$('#atrasoFinal').val(atrasoFinal);

	$('#pdf').attr("checked",true) ;
	$('#detallado').attr("checked",true) ;



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

	$('#excel').click(function() {
		if($('#excel').is(':checked')){
			$('#tdPresenacion').hide('slow');
		}
	});

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){
			$('#tdPresenacion').show('slow');
		}
	});

	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});

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

	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});


	$('#atrasoInicial').bind('keyup',function() {
		if(isNaN($('#atrasoInicial').val())){
			if($('#atrasoInicial').val().trim() != ''){
				$('#atrasoInicial').val(atrasoInicial);
			}

		}else{
			if(Number($('#atrasoInicial').val())>=0 && Number($('#atrasoInicial').val()) <= Number($('#atrasoFinal').val()))
			{
				atrasoInicial = Number($('#atrasoInicial').val());
			}else{
				$('#atrasoInicial').val(atrasoInicial);
			}

		}
	});

	$('#atrasoFinal').bind('keyup',function() {
		if(isNaN($('#atrasoFinal').val())){
			if($('#atrasoFinal').val().trim() != ''){
				$('#atrasoFinal').val(atrasoFinal);
			}
		}else{
			if(Number($('#atrasoFinal').val())>=0 && Number($('#atrasoInicial').val()) <= Number($('#atrasoFinal').val()))
			{
				atrasoFinal = Number($('#atrasoFinal').val());
			}else{
				$('#atrasoFinal').val(atrasoFinal);
			}
		}
	});

	$('#generar').click(function() {

		if($('#pdf').is(":checked") ){
			generaPDF();
		}

		if($('#excel').is(":checked") ){
			generaExcel();
		}

	});

	$('#formaGenerica').validate({
		rules: {
			atrasoInicial :{
				required: true
			},
			atrasoFinal :{
				required: true
			}
		},

		messages: {
			atrasoInicial :{
				required: 'Especifica Días de Atraso Inicial.'
			}
			,atrasoFinal :{
				required: 'Especifica Días de Atraso Final.'
			}
		}
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

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimien').val(parametroBean.fechaSucursal);


	function consultaMoneda() {
		var tipoCon = 3;
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'TODAS'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function consultaProductoCredito() {
		var tipoCon = 13;
		dwr.util.removeAllOptions('producCreditoID');
		dwr.util.addOptions( 'producCreditoID', {'0':'TODAS'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('producCreditoID', productos, 'producCreditoID', 'descripcion');
		});
	}

	function generaPDF() {
		if($('#pdf').is(':checked')){
			$('#pantalla').attr("checked",false) ;
			$('#excel').attr("checked",false);
			var tr= catTipoRepVencimientos.PDF;
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaVencimien').val();
			var sucursal = $("#sucursal option:selected").val();
			var moneda = $("#monedaID option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var institucionNominaID=$('#empresaID').val();
			var convenioNominaID =$('#convenioNominaID').val();
			var esNomina=$('#esNomina').val();
			var usuario = 	parametroBean.claveUsuario;
			var promotorID = $('#promotorID').val();
			var genero =$("#sexo option:selected").val();
			var estadoID=$('#estadoID').val();
			var municipioID=$('#municipioID').val();
			var fechaEmision = parametroBean.fechaSucursal;

			/// VALORES TEXTO
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.claveUsuario;
			var nombrePromotor = $('#nombrePromotorI').val();
			var nombreGenero =$("#sexo option:selected").val();
			var nombreEstado=$('#nombreEstado').val();
			var nombreMunicipio=$('#nombreMuni').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
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

			var nivelDetalle=1;
			if($('#detallado').is(':checked'))	{
				nivelDetalle=1;
			}
			else
				if($('#sumarizado').is(':checked'))	{
					nivelDetalle=0;
				}

			$('#ligaGenerar').attr('href','ReporteVencimientos.htm?fechaInicio='+fechaInicio+'&fechaVencimien='+
					fechaFin+'&monedaID='+moneda+'&parFechaEmision='+fechaEmision+
					'&sucursal='+sucursal+'&producCreditoID='+producto+
					'&institucionNominaID='+institucionNominaID+'&convenioNominaID='+convenioNominaID+
					'&esNomina='+esNomina+'&usuario='+usuario+'&tipoReporte='+tr+
					'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
					'&nivelDetalle='+nivelDetalle+
					'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotor='+nombrePromotor+'&nombreGenero='+nombreGenero+'&nombreEstado='+nombreEstado+'&nombreMunicipi='+nombreMunicipio+'&nombreInstitucion='+nombreInstitucion+
					'&atrasoInicial='+atrasoInicial+'&atrasoFinal='+atrasoFinal+'&nombreInstit='+nombreInstit+
					'&desConvenio='+desConvenio+
					'&manejaConvenio='+manejaConv
			);


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


function generaExcel() {
	$('#pdf').attr("checked",false) ;
	$('#pantalla').attr("checked",false);
	if($('#excel').is(':checked')){
		var tr= catTipoRepVencimientos.Excel;
		var tl= catTipoLisVencimientos .vencimientosExcel;
		var fechaInicio = $('#fechaInicio').val();
		var fechaFin = $('#fechaVencimien').val();
		var sucursal = $("#sucursal option:selected").val();
		var moneda = $("#monedaID option:selected").val();
		var producto = $("#producCreditoID option:selected").val();
		var institucionNominaID=$('#empresaID').val();
		var convenioNominaID =$('#convenioNominaID').val();
		var esNomina=$('#esNomina').val();
		var usuario = 	parametroBean.claveUsuario;
		var nombreUsuario = 	parametroBean.claveUsuario;
		var promotorID = $('#promotorID').val();
		var genero =$("#sexo option:selected").val();
		var estadoID=$('#estadoID').val();
		var municipioID=$('#municipioID').val();
		var fechaEmision = parametroBean.fechaSucursal;
		var fechaSistema = parametroBean.fechaSucursal;

		/// VALORES TEXTO
		var nombreSucursal = $("#sucursal option:selected").val();
		var nombreMoneda = $("#monedaID option:selected").val();
		var nombreProducto = $("#producCreditoID option:selected").val();
		var nombreUsuario = parametroBean.claveUsuario;
		var nombrePromotor = $('#nombrePromotorI').val();
		var nombreGenero =$("#sexo option:selected").val();
		var nombreEstado=$('#nombreEstado').val();
		var nombreMunicipio=$('#nombreMuni').val();
		var nombreInstitucion =  parametroBean.nombreInstitucion;

		var atrasoInicial 	=  $('#atrasoInicial').val();
		var atrasoFinal 	=  $('#atrasoFinal').val();
		nombreInstit=$('#nombreEmpresaI').val();
		desConvenio=$('#nombreConvenio').val();
	    manejaConv  = $("#manejaConvenio").val();

		if(nombreSucursal=='0'){
			nombreSucursal='TODAS';
		}
		else{
			nombreSucursal = $("#sucursal option:selected").html();
		}

		if(nombreMoneda=='0'){
			nombreMoneda='TODAS';
		}else{
			nombreMoneda = $("#monedaID option:selected").html();
		}

		if(nombreProducto=='0'){
			nombreProducto='TODOS';
		}else{
			nombreProducto = $("#producCreditoID option:selected").html();
		}

		if(nombreGenero=='0'){
			nombreGenero='TODOS';
		}else{
			nombreGenero =$("#sexo option:selected").html();
		}
		if(genero=='0'){
			genero='';
		}

		$('#ligaGenerar').attr('href','ReporteVencimientos.htm?'+
				'fechaInicio='+fechaInicio+
				'&fechaVencimien='+fechaFin+
				'&monedaID='+moneda+
				'&parFechaEmision='+fechaEmision+
				'&sucursal='+sucursal+
				'&producCreditoID='+producto+
				'&institucionNominaID='+institucionNominaID+
				'&convenioNominaID='+convenioNominaID+
				'&esNomina='+esNomina+
				'&usuario='+usuario+
				'&tipoReporte='+tr+
				'&tipoLista='+tl+
				'&promotorID='+promotorID+
				'&sexo='+genero+
				'&estadoID='+estadoID+
				'&municipioID='+municipioID+
				'&nombreSucursal='+nombreSucursal+
				'&nombreMoneda='+nombreMoneda+
				'&nombreProducto='+nombreProducto+
				'&nombrePromotor='+nombrePromotor+
				'&nombreGenero='+nombreGenero+
				'&nombreEstado='+nombreEstado+
				'&nombreMunicipi='+nombreMunicipio+
				'&nombreInstitucion='+nombreInstitucion+
				'&atrasoInicial='+atrasoInicial+
				'&fechaSistema='+fechaSistema+
				'&nombreUsuario='+nombreUsuario+
				'&atrasoFinal='+atrasoFinal+'&nombreInstit='+nombreInstit+
				'&desConvenio='+desConvenio+
				'&manejaConvenio='+manejaConv
		);
	}
}



});
