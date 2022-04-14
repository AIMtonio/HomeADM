$(document).ready(function() {
	$("#fechaInicio").focus();


	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();

	var catTipoLisReestructura  = {
			'ReporteExcel'	: 8
	};

	var catTipoRepReestructura = {
			'Pantalla'	: 1,
			'PDF'		: 2,
			'Excel'		: 3
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	consultaMoneda();
	consultaProductoCreditoOrign();
	consultaProductoCreditoReest();

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


	$('#usuarioID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});

	$('#usuarioID').blur(function() {
  		consultaUsuario(this.id);
	});



	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimien').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es Mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
		this.focus();
	});

	$('#fechaVencimien').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimien').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimien').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es Mayor a la Fecha de Fin.")	;
				$('#fechaVencimien').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaVencimien').val(parametroBean.fechaSucursal);
		}
		this.focus();
	});


	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});

	$('#generar').click(function() {

		if($('#pdf').is(":checked") ){
			generaPDF();
		}

		if($('#excel').is(":checked") ){
			generaExcel();
		}

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
						alert("No Existe el Promotor.");
						$(jqPromotor).val(0);
						$('#nombrePromotorI').val('TODOS');
					}
				});
			}
	}

	function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();
		var consultaPrincipal =1;
		var usuarioBeanCon = {
  				'usuarioID':numUsuario
				};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario == '' || numUsuario==0){
			$(jqUsuario).val(0);
			$('#nombreUsuario').val('TODOS');
		}

		else

		if(numUsuario != '' && !isNaN(numUsuario)){
			usuarioServicio.consulta(consultaPrincipal,usuarioBeanCon,function(usuario) {
						if(usuario!=null){
							$('#nombreUsuario').val(usuario.nombreCompleto);


						}else{
							alert("No Existe el Usuario.");
							$('#usuarioID').val(0);
							$('#nombreUsuario').val('TODOS');
							$('#usuarioID').focus();
							$('#usuarioID').select();
						}
				});
			}
			else{
				$('#usuarioID').val(0);
				$('#nombreUsuario').val('TODOS');
				$('#usuarioID').focus();
				$('#usuarioID').select();
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
						alert("No Existe el Estado.");
						$('#estadoID').val(0);
						$('#nombreEstado').val('TODOS');
						$('#estadoID').focus();
						$('#estadoID').select();
					}
				});
			}else{
				$('#estadoID').val(0);
				$('#nombreEstado').val('TODOS');
				$('#estadoID').focus();
				$('#estadoID').select();
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
				alert("No ha Selecionado Ningún Estado.");
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
						alert("No Existe el Municipio.");
						$('#municipioID').val(0);
						$('#nombreMuni').val('TODOS');
						$('#municipioID').focus();
						$('#municipioID').select();
					}
				});
			}else{
				$('#municipioID').val(0);
				$('#nombreMuni').val('TODOS');
				$('#municipioID').focus();
				$('#municipioID').select();
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

	function consultaProductoCreditoOrign() {
		var tipoCon = 13;
		dwr.util.removeAllOptions('productoCreOrig');
		dwr.util.addOptions( 'productoCreOrig', {'0':'TODOS'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('productoCreOrig', productos, 'producCreditoID', 'descripcion');
		});
	}

	function consultaProductoCreditoReest() {
		var tipoCon = 13;
		dwr.util.removeAllOptions('productoCreDest');
		dwr.util.addOptions( 'productoCreDest', {'0':'TODOS'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('productoCreDest', productos, 'producCreditoID', 'descripcion');
		});
	}



	function generaExcel() {
		$('#pdf').attr("checked",false) ;
		$('#pantalla').attr("checked",false);
		if($('#excel').is(':checked')){
			var tr= catTipoRepReestructura.Excel;
			var tl= catTipoLisReestructura.ReporteExcel;
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaVencimien').val();
			var sucursal = $("#sucursal option:selected").val();
			var moneda = $("#monedaID option:selected").val();
			var productoCreOrig = $("#productoCreOrig option:selected").val();
			var productoCreDest = $("#productoCreDest option:selected").val();
			var usuarioID = $("#usuarioID").val();
			var promotorID = $('#promotorID').val();
			var genero =$("#sexo option:selected").val();
			var estadoID=$('#estadoID').val();
			var municipioID=$('#municipioID').val();
			var fechaEmision = parametroBean.fechaSucursal;

			/// VALORES TEXTO
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombreEstado=$('#nombreEstado').val();
			var nombreMunicipio=$('#nombreMuni').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var nombreProductoCreOrig = $("#productoCreOrig option:selected").val();
			var nombreProductoCreDest = $("#productoCreDest option:selected").val();
			var nombreUsuario = $('#nombreUsuario').val();


			if(nombreProductoCreOrig=='0'){
				nombreProductoCreOrig='';
			}
			else{
				nombreProductoCreOrig = $("#productoCreOrig option:selected").html();
			}



			if(nombreProductoCreDest=='0'){
				nombreProductoCreDest='';
			}
			else{
				nombreProductoCreDest = $("#productoCreDest option:selected").html();
			}

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


			var nivelDetalle=1;
			if($('#detallado').is(':checked'))	{
				nivelDetalle=1;
			}
			else
				if($('#sumarizado').is(':checked'))	{
					nivelDetalle=0;
				}

			$('#ligaGenerar').attr('href','ReporteReestrucCredito.htm?'+
			'fechaInicio='		+fechaInicio+
			'&fechaVencimien='  +fechaFin+
			'&monedaID='		+moneda+
			'&EstadoID='		+estadoID+
			'&municipioID='		+municipioID+
			'&nomInstitucion='	+nombreInstitucion+
			'&nomUsuario='		+parametroBean.nombreUsuario+
			'&nomMunicipio='	+nombreMunicipio+
			'&nomEstado='		+nombreEstado+
			'&nomProductoCreOrig='+nombreProductoCreOrig+
			'&nomMoneda='		+nombreMoneda+
			'&nomSucursal='		+nombreSucursal+
			'&productoCreOrig='	+productoCreOrig+
			'&nivelDetalle='	+nivelDetalle+
			'&fechaEmision='	+fechaEmision+
			'&nomProductoCreDest='+nombreProductoCreDest+
			'&productoCreDest='	+productoCreDest+
			'&nomUsuarioReest='	+nombreUsuario+
			'&sucursal='		+sucursal+
			'&usuarioID='		+usuarioID+

			'&tipoReporte='+tr+
			'&tipoLista='+tl);




		}
	}

	function generaPDF() {
		if($('#pdf').is(':checked')){
			$('#pantalla').attr("checked",false) ;
			$('#excel').attr("checked",false);
			var tr= catTipoRepReestructura.PDF;
			var tl=0;
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaVencimien').val();
			var sucursal = $("#sucursal option:selected").val();
			var moneda = $("#monedaID option:selected").val();
			var productoCreOrig = $("#productoCreOrig option:selected").val();
			var productoCreDest = $("#productoCreDest option:selected").val();
			var usuarioID = $("#usuarioID").val();
			var promotorID = $('#promotorID').val();
			var genero =$("#sexo option:selected").val();
			var estadoID=$('#estadoID').val();
			var municipioID=$('#municipioID').val();
			var fechaEmision = parametroBean.fechaSucursal;

			/// VALORES TEXTO
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombreEstado=$('#nombreEstado').val();
			var nombreMunicipio=$('#nombreMuni').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var nombreProductoCreOrig = $("#productoCreOrig option:selected").val();
			var nombreProductoCreDest = $("#productoCreDest option:selected").val();
			var nombreUsuario = $('#nombreUsuario').val();


			if(nombreProductoCreOrig=='0'){
				nombreProductoCreOrig='';
			}
			else{
				nombreProductoCreOrig = $("#productoCreOrig option:selected").html();
			}



			if(nombreProductoCreDest=='0'){
				nombreProductoCreDest='';
			}
			else{
				nombreProductoCreDest = $("#productoCreDest option:selected").html();
			}

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


			var nivelDetalle=1;
			if($('#detallado').is(':checked'))	{
				nivelDetalle=1;
			}
			else
				if($('#sumarizado').is(':checked'))	{
					nivelDetalle=0;
				}

			$('#ligaGenerar').attr('href','ReporteReestrucCredito.htm?'+
			'fechaInicio='		+fechaInicio+
			'&fechaVencimien='  +fechaFin+
			'&monedaID='		+moneda+
			'&EstadoID='		+estadoID+
			'&municipioID='		+municipioID+
			'&nomInstitucion='	+nombreInstitucion+
			'&nomUsuario='		+parametroBean.nombreUsuario+
			'&nomMunicipio='	+nombreMunicipio+
			'&nomEstado='		+nombreEstado+
			'&nomProductoCreOrig='+nombreProductoCreOrig+
			'&nomMoneda='		+nombreMoneda+
			'&nomSucursal='		+nombreSucursal+
			'&productoCreOrig='	+productoCreOrig+
			'&nivelDetalle='	+nivelDetalle+
			'&fechaEmision='	+fechaEmision+
			'&nomProductoCreDest='+nombreProductoCreDest+
			'&productoCreDest='	+productoCreDest+
			'&nomUsuarioReest='	+nombreUsuario+
			'&sucursal='		+sucursal+
			'&usuarioID='		+usuarioID+

			'&tipoReporte='+tr+
			'&tipoLista='+tl);


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
				alert("Formato de Fecha No Válido (aaaa-mm-dd).");
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
				alert("Fecha Introducida Errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha Introducida Errónea.");
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
