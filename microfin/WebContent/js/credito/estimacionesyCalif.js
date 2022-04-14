$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   

	var catTipoLisEstimacionesCredPrev = {
			'estimacionesExcel' : 12,
			'calificacionesExcel' : 13
	};	

	var catTipoRepEstimacionesCredPrev = { 
			'PDF'		: 2,
			'Excel'		: 3,
			'PDF2'		: 4,
			'Excel2'	: 5
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	consultaSucursal();
	consultaMoneda(); 
	consultaProductoCredito();     
	$('#tipoReporte').attr("checked",true);
	$('#pdf').attr("checked",true) ;
	$('#reporte').val(1);
	$('#formato').val(1);
	$('#clienteID').val('0');
	$('#nombreCompleto').val('TODOS');
	$('#grupoID').val('0');
	$('#nombreGrupo').val('TODOS');
	$('#promotorID').val('0');
	$('#nombrePromotorI').val('TODOS');
	$('#estadoID').val('0');
	$('#nombreEstado').val('TODOS');
	$('#municipioID').val('0');
	$('#nombreMuni').val('TODOS');
	
	
	$(':text').focus(function() {	
		esTab = false;
	});
	$('#grupoID').blur(function() { 
		esTab=true;
 		validaGrupo();
	});
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		esTab=true;
		validaCliente();
	});
	$('#grupoID').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	camposLista[0] = "nombreGrupo";
		    	parametrosLista[0] = $('#grupoID').val();
		 listaAlfanumerica('grupoID', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); 
		 } });
    
	$('#tipoReporte').click(function() {
		$('#tipoReporte').focus();
		$('#tipoReporte').attr("checked",true);
		$('#tipoReporte2').attr("checked",false);
		$('#reporte').val(1);
	});
	
	$('#tipoReporte2').click(function() {
		$('#tipoReporte2').focus();
		$('#tipoReporte2').attr("checked",true);
		$('#tipoReporte').attr("checked",false);
		$('#reporte').val(2);
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
		$('#excel').focus();
		$('#excel').attr("checked",true);
		$('#pdf').attr("checked",false);
		$('#formato').val(2);
	});

	$('#pdf').click(function() {
		$('#pdf').focus();
		$('#excel').attr("checked",false);
		$('#pdf').attr("checked",true);
		$('#formato').val(1);
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Corte es Mayor a la Fecha del Sistema.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
		$('#fechaInicio').focus();
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

	$('#generar').click(function() { 
		var fecha = $('#fechaInicio').val();		
	
		if($('#formato').val()==1 && $('#reporte').val()==1 ){
			consultaFechaEstimacion(fecha,1); //1 para pdf y 2 para excel		
		}else
		if($('#formato').val()==1 && $('#reporte').val()==2 ){
			consultaFechaCalificacion(fecha,1); //1 para pdf y 2 para excel
		}else
		if($('#formato').val()==2 && $('#reporte').val()==1 ){
			consultaFechaEstimacion(fecha,2); //1 para pdf y 2 para excel		
		}else
		if($('#formato').val()==2 && $('#reporte').val()==2 ){
			consultaFechaCalificacion(fecha,2); //1 para pdf y 2 para excel
		}
		
	});
   

	// ***********  Inicio  validacion Promotor, Estado, Municipio  ***********
	function validaCliente() {
		var numCliente = $('#clienteID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		esTab=true;
		if(numCliente == ''|| numCliente == 0){
			$('#clienteID').val(0);
			$('#nombreCompleto').val('TODOS');
		}else
		if (numCliente != '' && !isNaN(numCliente)) {
				clienteServicio.consulta(2,numCliente,function(cliente) {
					if (cliente != null) {
						$('#nombreCompleto').val(cliente.nombreCompleto);
					} else {
						mensajeSis("No Existe el Cliente");
						$('#clienteID').val(0);
						$('#nombreCompleto').val('TODOS');
					}
				});
		}
	}
	
	function validaGrupo() {
		var numGrupo = $('#grupoID').val();
		var grupoID=$('#grupoID').asNumber();
		setTimeout("$('#cajaLista').hide();", 200);
		var principal = 1;
		esTab=true;
		if(numGrupo == ''|| numGrupo == 0){
			$('#grupoID').val(0);
			$('#nombreGrupo').val('TODOS');
		}else
		if(numGrupo != '' && !isNaN(numGrupo)){			
				var grupoBeanCon = { 
  				'grupoID':$('#grupoID').val(),
				};
				gruposCreditoServicio.consulta(principal,grupoBeanCon,function(grupos) {
						if(grupos!=null){
							$('#nombreGrupo').val(grupos.nombreGrupo);
						}
						else{
							mensajeSis("No Existe el grupo");
							$('#grupoID').val(0);
							$('#nombreGrupo').val('TODOS');						
						}
				});			
		}
	}
	//---- 
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
		var tipoCon = 2;
		dwr.util.removeAllOptions('producCreditoID'); 
		dwr.util.addOptions( 'producCreditoID', {'0':'TODOS'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('producCreditoID', productos, 'producCreditoID', 'descripcion');
		});
	}       


	function generaPDF() {
	}

	function generaExcel() {
		var fecha = $('#fechaInicio').val();	
			if($('#reporte').val()==1){
				consultaFechaEstimacion(fecha,2);  // 1 para pdf y 2 para excel
			}
			if($('#reporte').val()==2){
				consultaFechaCalificacion(fecha,2); // 1 para pdf y 2 para excel
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
	/* Consulta para obtener la Ultima Fecha de Estimaciones  */
	function consultaFechaEstimacion(varFecha,presentacion){
		var fecha = varFecha;
		var pres = presentacion;
		var pdf =1;
		var excel=2;
		var tipoConsulta = 1;
			var estimacionPreventivaBean = {
				'fechaCorte':fecha
			};
			estimacionPreventivaServicio.consultaEstimacion(estimacionPreventivaBean, tipoConsulta, function(estimacionBean) {
				if(estimacionBean!=null){
					if(estimacionBean.fechaCorte != fecha){
						if (estimacionBean.fechaCorte == '1900-01-01' || estimacionBean.fechaCorte == ''){ 
							$('#fechaValida').val("N");
							mensajeSis('No existe Información para Generar el Reporte');
							$('#fechaInicio').focus();
							
						}else{ 
							$('#fechaValida').val("N");
							mensajeSis("No se encontró información para la fecha: "+fecha+
									"\nLa última fecha con información es: "+ estimacionBean.fechaCorte);
							$('#fechaInicio').val(estimacionBean.fechaCorte);
							$('#fechaInicio').focus();
						}
					}else {
						$('#fechaValida').val("S");
						if(pres==pdf){
							reporteEstimaPDF();
						}else if(pres==excel){
							reporteEstimaExcel();
						} 
					}
				}
			});
		       
		
	}
	
	function consultaFechaCalificacion(varFecha,presentacion){
		var fecha = varFecha;	
		var pres = presentacion;
		var pdf =1;
		var excel=2;
		var creditoBeanCon = { 
			'fechaCorte':fecha
			};
		creditosServicio.consulta(4,creditoBeanCon,function(credito) {
			if(credito!=null){
				if(credito.fechaCorte!= fecha){
					mensajeSis("No se encontró información para la fecha: "+fecha+
							"\nLa última fecha con información es: "+ credito.fechaCorte);
					$('#fechaInicio').val(credito.fechaCorte);
					$('#fechaInicio').focus();
					$('#fechaValida').val("N");
				}else if(credito.fechaCorte== fecha){
					$('#fechaValida').val("S");
					if(pres==pdf){
						reporteCalPDF();
					}else if(pres==excel){
						reporteCalExcel();
					}
				}
			}else{
				mensajeSis("No se encontró información para el Reporte");
			}
		});	
	}
    
	function reporteEstimaPDF(){
		var tr= catTipoRepEstimacionesCredPrev.PDF;
		var tr2= catTipoRepEstimacionesCredPrev.PDF2;
		var fecha = $('#fechaInicio').val();	
		var clienteID = $('#clienteID').val();
		var grupoID = $('#grupoID').val();
		var sucursal = $("#sucursal option:selected").val();
		var moneda = $("#monedaID option:selected").val();
		var producto = $("#producCreditoID option:selected").val();
		var promotorID = $('#promotorID').val();
		var genero =$("#sexo option:selected").val();
		var estadoID=$('#estadoID').val();
		var municipioID=$('#municipioID').val();
		var fechaEmision = parametroBean.fechaSucursal;
		var usuario = 	parametroBean.numeroUsuario;
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
		var nombreCliente = $('#nombreCompleto').val();
		var ClienteConCaracter = nombreCliente;
		nombreCliente = ClienteConCaracter.replace(/\&/g, "%26");
		var nombreGrupo = $('#nombreGrupo').val();
		var tipoConsulta = 1;
		
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

		window.open('EstimacionesCredPrevReporte.htm?fechaInicio='+fecha+'&clienteID='+clienteID+'&grupoID='+grupoID+
		'&monedaID='+moneda+'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+  
		'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
		'&parFechaEmision='+fechaEmision+
		'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario.toUpperCase()+
		'&nombrePromotor='+nombrePromotor+'&nombreGenero='+nombreGenero+'&nombreEstado='+nombreEstado+'&nombreMunicipi='+nombreMunicipio+
		'&nombreInstitucion='+nombreInstitucion+'&nombreCliente='+nombreCliente+'&nombreGrupo='+nombreGrupo,'_blank');
	}
	
	function reporteCalPDF(){
		var tr= catTipoRepEstimacionesCredPrev.PDF;
		var tr2= catTipoRepEstimacionesCredPrev.PDF2;
		var fecha = $('#fechaInicio').val();	
		var clienteID = $('#clienteID').val();
		var grupoID = $('#grupoID').val();
		var sucursal = $("#sucursal option:selected").val();
		var moneda = $("#monedaID option:selected").val();
		var producto = $("#producCreditoID option:selected").val();
		var promotorID = $('#promotorID').val();
		var genero =$("#sexo option:selected").val();
		var estadoID=$('#estadoID').val();
		var municipioID=$('#municipioID').val();
		var fechaEmision = parametroBean.fechaSucursal;
		var usuario = 	parametroBean.numeroUsuario;
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
		var nombreCliente = $('#nombreCompleto').val();
		var ClienteConCaracter = nombreCliente;
		nombreCliente = ClienteConCaracter.replace(/\&/g, "%26");
		var nombreGrupo = $('#nombreGrupo').val();
		var tipoConsulta = 1;
		
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
	
		window.open('EstimacionesCredPrevReporte.htm?fechaInicio='+fecha+'&clienteID='+clienteID+'&grupoID='+grupoID+
				'&monedaID='+moneda+'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr2+  
				'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
				'&parFechaEmision='+fechaEmision+
				'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario.toUpperCase()+
				'&nombrePromotor='+nombrePromotor+'&nombreGenero='+nombreGenero+'&nombreEstado='+nombreEstado+'&nombreMunicipi='+nombreMunicipio+
				'&nombreInstitucion='+nombreInstitucion+'&nombreCliente='+nombreCliente+'&nombreGrupo='+nombreGrupo,'_blank');
	}
	function reporteEstimaExcel(){
		var tr= catTipoRepEstimacionesCredPrev.Excel; 
		var tl= catTipoLisEstimacionesCredPrev.estimacionesExcel;
		var fecha = $('#fechaInicio').val();	
		var clienteID = $('#clienteID').val();
		var grupoID = $('#grupoID').val();	
		var sucursal = $("#sucursal option:selected").val();
		var moneda = $("#monedaID option:selected").val();
		var producto = $("#producCreditoID option:selected").val();
		var usuario = 	parametroBean.numeroUsuario; 
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
		var nombreGrupo	=$('#nombreGrupo').val();
		var nombreCliente=$('#nombreCompleto').val();
		var ClienteConCaracter = nombreCliente;
		nombreCliente = ClienteConCaracter.replace(/\&/g, "%26");
		
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

		var urlReporte = 'EstimacionesCredPrevReporte.htm?fechaInicio='+fecha+'&clienteID='+clienteID+'&grupoID='+grupoID+
				'&monedaID='+moneda+'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr+  
				'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
				'&parFechaEmision='+fechaEmision+'&tipoLista='+tl+
				'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario.toUpperCase()+
				'&nombrePromotor='+nombrePromotor+'&nombreGenero='+nombreGenero.toUpperCase()+'&nombreEstado='+nombreEstado+'&nombreGrupo='+nombreGrupo+'&nombreMunicipi='+nombreMunicipio+'&nombreInstitucion='+nombreInstitucion+'&nombreCliente='+nombreCliente;


		urlReporte = eliminaAcentos(urlReporte);
		window.open(urlReporte,'_blank');
						
	}
	function reporteCalExcel(){
		var tr2= catTipoRepEstimacionesCredPrev.Excel2; 
		var tl2= catTipoLisEstimacionesCredPrev.calificacionesExcel;
		var fecha = $('#fechaInicio').val();	
		var clienteID = $('#clienteID').val();
		var grupoID = $('#grupoID').val();	
		var sucursal = $("#sucursal option:selected").val();
		var moneda = $("#monedaID option:selected").val();
		var producto = $("#producCreditoID option:selected").val();
		var usuario = 	parametroBean.numeroUsuario; 
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
		var nombreGrupo	=$('#nombreGrupo').val();
		var nombreCliente=$('#nombreCompleto').val();

		nombreCliente = nombreCliente.replace(/\&/g, "%26");
		
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


		var urlReporte = 
			'EstimacionesCredPrevReporte.htm?fechaInicio='+fecha+'&clienteID='+clienteID+'&grupoID='+grupoID+
				'&monedaID='+moneda+'&sucursal='+sucursal+'&producCreditoID='+producto+'&usuario='+usuario+'&tipoReporte='+tr2+  
				'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
				'&parFechaEmision='+fechaEmision+'&tipoLista='+tl2+
				'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario.toUpperCase()+
				'&nombrePromotor='+nombrePromotor+'&nombreGenero='+nombreGenero.toUpperCase()+'&nombreEstado='+nombreEstado+'&nombreGrupo='+nombreGrupo+'&nombreMunicipi='+nombreMunicipio+'&nombreInstitucion='+nombreInstitucion+'&nombreCliente='+nombreCliente
			;

		urlReporte = eliminaAcentos(urlReporte);
		window.open(urlReporte,'_blank');

		}

		function eliminaAcentos(cadena){

			cadena = cadena.replace(/Ñ/g, '%D1')
						   .replace(/Á/g, '%C1')
						   .replace(/É/g, '%C9')
						   .replace(/Í/g, '%CD')
						   .replace(/Ó/g, '%D3')
						   .replace(/Ú/g, '%DA')
						   .replace(/ñ/g, '%F1')
						   .replace(/á/g, '%E1')
						   .replace(/é/g, '%E9')
						   .replace(/í/g, '%ED')
						   .replace(/ó/g, '%F3')
						   .replace(/ú/g, '%FA')
						   ;

			return cadena;

		}
	
	

});
