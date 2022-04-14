$(document).ready(function() {

	// Definicion de Constantes y Enums
	esTab = false;
	var cat_TipoLista = {
		'estatusDocumento' : 2
	};

	var cat_TipoReporte = {
		'estatusDocumento' : 2
	};

	var con_sucursal= {
		'principal'	: 1
	};

	var con_almacen= {
		'foranea'	: 2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();

	$('#sucursalID').val('0');
	$('#almacenID').val("0");
	$('#nombreSucursal').val('TODAS');
	$('#nombreAlmacen').val("TODOS");
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#pdf').attr("checked",true);
	$('#excel').attr("checked",false);
	$('#sucursalID').focus();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	//------------ Validaciones de la Forma -----------------------------------

	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#sucursalID').blur(function(){
		consultaSucursal();
	});

	//Consulta de Sucursal
	function consultaSucursal(){

		var sucursalID =  $("#sucursalID").val();
		setTimeout("$('#cajaLista').hide();", 200);

		if( esTab && sucursalID != 0 && sucursalID != ''){
			sucursalesServicio.consultaSucursal(con_sucursal.principal,sucursalID,function(sucursal) {
				if(sucursal!=null){
					$('#sucursalID').val(sucursal.sucursalID);
					$('#nombreSucursal').val(sucursal.nombreSucurs);
				} else {
					mensajeSis("La Sucursal no Existe.");
					$('#nombreSucursal').val("TODAS");
					$('#sucursalID').val("0");
					$('#sucursalID').focus();
				}
			});
		} else {
			$('#sucursalID').val("0");
			$('#nombreSucursal').val("TODAS");
		}
	}

	$('#almacenID').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "nombreAlmacen";
		camposLista[1] = "sucursalID";

		parametrosLista[0] = $('#almacenID').val();
		parametrosLista[1] = $('#sucursalID').val();

		lista('almacenID', '2', '2', camposLista, parametrosLista, 'listaCatalogoAlmacenes.htm');
	});

	$('#almacenID').blur(function(){
		consultaAlmacen();
	});

	//Consulta de almacén
	function consultaAlmacen() {
		var almacenID =  $("#almacenID").val();
		var sucursalID =  $("#sucursalID").val();
		setTimeout("$('#cajaLista').hide();", 200);

		var catalogoAlmacenesBean = {
				'almacenID':almacenID,
				'sucursalID':sucursalID
		};

		if( esTab && almacenID != 0 && almacenID != ''){
			catalogoAlmacenesServicio.consulta(con_almacen.foranea, catalogoAlmacenesBean, function(catalogoAlmacen) {
				if (catalogoAlmacen != null) {
					$('#almacenID').val(catalogoAlmacen.almacenID);
					$('#nombreAlmacen').val(catalogoAlmacen.nombreAlmacen);
				} else {
					mensajeSis("El Almacén no Existe.");
					$('#almacenID').val("0");
					$('#nombreAlmacen').val("TODOS");
				}
			});
		} else {
			$('#almacenID').val("0");
			$('#nombreAlmacen').val("TODOS");
		}
	}


	$('#fechaInicio').change(function() {

		var fechaInicio= $('#fechaInicio').val();
		if(esFechaValida(fechaInicio)){

			if(fechaInicio==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
		$('#fechaInicio').focus();

	});

	$('#fechaInicio').blur(function() {

		var fechaInicio= $('#fechaInicio').val();
		if(esFechaValida(fechaInicio)){

			var fechaSistema = parametroBean.fechaSucursal;
			if ( mayor(fechaInicio, fechaSistema)){
				mensajeSis("La Fecha es mayor a la fecha del sistema.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
		$('#fechaFin').focus();

	});

	$('#fechaFin').change(function() {
		var fechaFin= $('#fechaFin').val();
		if(esFechaValida(fechaFin)){

			if(fechaFin==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}

			var fechaInicio= $('#fechaInicio').val();
			if ( mayor(fechaInicio, fechaFin)){
				mensajeSis("La Fecha Final es menor a la fecha Inicial.");
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}

			var fechaSistema= parametroBean.fechaSucursal;
			if ( mayor(fechaFin, fechaSistema)){
				mensajeSis("La Fecha es mayor a la fecha del sistema.");
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}

		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#fechaFin').focus();
		}
	});

	$('#fechaFin').blur(function() {

		var fechaFin= $('#fechaFin').val();
		if(esFechaValida(fechaFin)){

			if(fechaFin==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}

		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#fechaFin').focus();
		}
		$('#pdf').focus();
	});


	$('#pdf').click(function() {
		$('#pdf').attr("checked",true);
		$('#excel').attr("checked",false);
	});

	$('#excel').click(function() {
		$('#pdf').attr("checked",false);
		$('#excel').attr("checked",true);

	});


	$('#generar').click(function() {
		generaReporte();
	});

	function generaReporte() {

		if($('#pdf').is(':checked')){
			var almacenID = $("#almacenID").val();
			var nombreAlmacen = $("#nombreAlmacen").val();
			if(almacenID == '' || almacenID == 0){
				nombreAlmacen = 'TODOS';
			}else{
				nombreAlmacen = $("#almacenID").val() + ' - ' + $("#nombreAlmacen").val();
			}

			var sucursalID = $("#sucursalID").val();
			var nombreSucursal = $("#nombreSucursal").val();
			if(sucursalID == 0 || sucursalID == ''){
				nombreSucursal = 'TODAS';
			}else{
				nombreSucursal = $("#sucursalID").val() + ' - '+ $("#nombreSucursal").val();
			}

			var estatus = $("#estatus option:selected").val();
			var descripcionEstatus = $("#estatus option:selected").html();
			if(estatus == ''){
				descripcionEstatus = 'TODOS';
			}else{
				descripcionEstatus = $("#estatus option:selected").html();
			}

			var nombreInstitucion=	parametroBean.nombreInstitucion;
			var nombreUsuario = parametroBean.claveUsuario;

			var fechaEmision = parametroBean.fechaSucursal;
			var fecha = new Date();

			var segundos  = fecha.getSeconds();
			var minutos = fecha.getMinutes();
			var horas = fecha.getHours();

			if(fecha.getHours()<10){
				horas = "0"+fecha.getHours();
			}
			if(fecha.getMinutes()<10){
				minutos = "0"+fecha.getMinutes();
			}
			if(fecha.getSeconds()<10){
				segundos = "0"+fecha.getSeconds();
			}

			var horaEmision = horas+":"+minutos+":"+segundos;
			var tipoReporte	= cat_TipoReporte.estatusDocumento;
			var tipoLista = cat_TipoLista.estatusDocumento;

			$('#ligaGenerar').attr('href',
						'reporteDocumentosGrdValPDF.htm'+
						'?nombreInstitucion='+nombreInstitucion+
						'&nombreUsuario='+nombreUsuario+
						'&fechaEmision='+fechaEmision+
						'&horaEmision='+horaEmision+
						'&sucursalID='+sucursalID+
						'&nombreSucursal='+nombreSucursal+
						'&almacenID='+almacenID+
						'&nombreAlmacen='+nombreAlmacen+
						'&estatus='+estatus+
						'&descripcionEstatus='+descripcionEstatus+
						'&tipoReporte='+tipoReporte+
						'&tipoLista='+tipoLista);
		}

		if($('#excel').is(':checked')){

			var almacenID = $("#almacenID").val();
			var nombreAlmacen = $("#nombreSucursal").val();
			if(almacenID == '' || almacenID == 0){
				nombreAlmacen = 'TODOS';
			}else{
				nombreAlmacen = $("#almacenID").val() + ' - ' + $("#nombreSucursal").val();
			}

			var sucursalID = $("#sucursalID").val();
			var nombreSucursal = $("#nombreSucursal").val();
			if(sucursalID == 0 || sucursalID == ''){
				nombreSucursal = 'TODAS';
			}else{
				nombreSucursal = $("#sucursalID").val() + ' - '+ $("#nombreSucursal").val();
			}

			var estatus = $("#estatus option:selected").val();
			var descripcionEstatus = $("#estatus option:selected").html();
			if(estatus == ''){
				descripcionEstatus = 'TODOS';
			}else{
				descripcionEstatus = $("#estatus option:selected").html();
			}

			var nombreInstitucion=	parametroBean.nombreInstitucion;
			var nombreUsuario = parametroBean.claveUsuario;

			var fechaEmision = parametroBean.fechaSucursal;
			var fecha = new Date();

			var segundos  = fecha.getSeconds();
			var minutos = fecha.getMinutes();
			var horas = fecha.getHours();

			if(fecha.getHours()<10){
				horas = "0"+fecha.getHours();
			}
			if(fecha.getMinutes()<10){
				minutos = "0"+fecha.getMinutes();
			}
			if(fecha.getSeconds()<10){
				segundos = "0"+fecha.getSeconds();
			}

			var horaEmision = horas+":"+minutos+":"+segundos;
			var tipoReporte	= cat_TipoReporte.estatusDocumento;
			var tipoLista = cat_TipoLista.estatusDocumento;

			$('#ligaGenerar').attr('href',
						'reporteDocumentosGrdValExcel.htm'+
						'?nombreInstitucion='+nombreInstitucion+
						'&nombreUsuario='+nombreUsuario+
						'&fechaEmision='+fechaEmision+
						'&horaEmision='+horaEmision+
						'&sucursalID='+sucursalID+
						'&nombreSucursal='+nombreSucursal+
						'&almacenID='+almacenID+
						'&nombreAlmacen='+nombreAlmacen+
						'&estatus='+estatus+
						'&descripcionEstatus='+descripcionEstatus+
						'&tipoReporte='+tipoReporte+
						'&tipoLista='+tipoLista);
		}
	}

});
