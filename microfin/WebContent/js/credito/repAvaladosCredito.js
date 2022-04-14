var sucursalID="";
var nombreSucursal="";
var producto="";
var nombreProducto="";
var estatus ="";
var alertSocio = $('#alertSocio').val();
$(document).ready(function() {
	esTab = true;

	var catTipoConsulta = {
			'principal'	: 1		  		
	};

	var catTipoListaSucursal = {
			'combo': 2
	};
	parametros = consultaParametrosSession();
	$('#nombreUsuario').val(parametros.claveUsuario); // parametros del sesion para el reporte
	$('#nombreInstitucion').val(parametros.nombreInstitucion);
	$('#fechaSistema').val(parametroBean.fechaSucursal);

	// ----------------------------------- Metodos y Eventos -----------------------------
	agregaFormatoControles('formaGenerica');
	cargaSucursales();
	consultaProductoCredito();
	inicializaCampos();

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 

		}
	});	

	$('#promotor').bind('keyup',function(e){
		lista('promotor', '1', '1', 'nombrePromotor',
				$('#promotor').val(), 'listaPromotores.htm');
	});	

	$('#clienteInicial').bind('keyup',function(e){
		lista('clienteInicial', '3', '1', 'nombreCompleto', 
				$('#clienteInicial').val(), 'listaCliente.htm');
	});

	$('#clienteInicial').blur(function() {
		consultaClienteInicial(this.id);
	});

	$('#clienteFinal').bind('keyup',function(e){
		lista('clienteFinal', '3', '1', 'nombreCompleto', 
				$('#clienteFinal').val(), 'listaCliente.htm');
	});

	$('#clienteFinal').blur(function() {
		consultaClienteFinal(this.id);		
	});

	$('#promotor').blur(function() {
		consultaPromotorI(this.id);

	});


	$('#diasMora').blur(function() {
		validaDiasMora();
	});


	$('#fechaInicial').change(function() {
		var fechaIni=1;
		var Xfecha= $('#fechaInicial').val();
		if(esFechaValida(Xfecha, fechaIni)){
			if(Xfecha=='')$('#fechaInicial').val(parametros.fechaAplicacion);

		}else{
			$('#fechaInicial').val(parametros.fechaAplicacion);
		}
	});

	$('#fechaFinal').change(function() {
		var fechaIni=2;
		var Yfecha= $('#fechaFinal').val();
		if(esFechaValida(Yfecha, fechaIni)){
			if(Yfecha=='')$('#fechaFinal').val(parametros.fechaAplicacion);

		}else{
			$('#fechaFinal').val(parametros.fechaAplicacion);
		}

	});
	$('#pdf').click(function() {	
		$('#excel').attr("checked",false);
	});
	$('#excel').click(function() {	
		$('#pdf').attr("checked",false);
	});
	$('#generar').click(function(){		
		enviaDatosReporteAvales(); 

	});


	$('#formaGenerica').validate({

		rules: {	
			fechaInicial: {
				date: true

			},
			fechaFinal: {
				date: true

			},
		},		
		messages: {		
			fechaInicial: {
				date: 'Fecha Incorrecta.',

			},
			fechaFinal: {
				date: 'Fecha Incorrecta.',

			},

		}		
	});


	function consultaClienteInicial(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente == '' || numCliente==0){
			$(jqCliente).val(0);
			$('#nombreClienteInicial').val('TODOS');
		}
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteInicial').val(cliente.numero)							
					$('#nombreClienteInicial').val(cliente.nombreCompleto);
					validaClientes();
				}else{
					if(numCliente!=0){
						mensajeSis("No Existe el "+alertSocio);
						$('#clienteInicial').focus();
						$('#clienteInicial').select();
						$('#clienteInicial').val("");
						$('#nombreClienteInicial').val("");
					}
				}    	 						
			});
		}
	}

	function consultaClienteFinal(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente == '' || numCliente==0){
			$(jqCliente).val(0);
			$('#nombreClienteFinal').val('TODOS');
		}
		validaClientes();
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteFinal').val(cliente.numero)							
					$('#nombreClienteFinal').val(cliente.nombreCompleto);
					validaClientes();
				}else{
					if(numCliente!=0){
						mensajeSis("No Existe el "+alertSocio);
						$('#clienteFinal').val("");
						$('#clienteFinal').focus();
						$('#clienteFinal').select();
						$('#nombreClienteFinal').val("");
					}
				}    	 						
			});
		}
	}

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
			$('#nombrePromotor').val('TODOS');
		}
		else	

			if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){							
						$('#nombrePromotor').val(promotor.nombrePromotor); 

					}else{
						mensajeSis("No Existe el Promotor");
						$('#promotor').focus();
						$('#promotor').select();
						$('#promotor').val("");
						$('#nombrePromotor').val("");
					}    	 						
				});
			}
	}


	function validaDiasMora(){
		var diasMora=$('#diasMora').val();
		if(diasMora==''){
			$('#diasMora').val("TODOS");
		}else{
			$('#diasMora').val(diasMora);
		}
	}

	function validaClientes(){
		var clienteIni=$('#clienteInicial').val();
		var clienteFin=$('#clienteFinal').val();
		if(clienteIni !=0 && clienteFin !=0){
			if(clienteFin < clienteIni){
				mensajeSis("El "+alertSocio+" Final no Puede ser Menor al "+alertSocio+" inicial ");
				$('#clienteFinal').val("");
				$('#clienteFinal').focus();
				$('#clienteFinal').select();
				$('#nombreClienteFinal').val("");
			}
		}else{
			if(clienteIni==0 && clienteFin !=0){
				mensajeSis("Debe de Seleccionar un "+alertSocio+" Inicial ");
				$('#clienteInicial').val("");
				$('#clienteInicial').focus();
				$('#clienteInicial').select();
				$('#nombreClienteInicial').val("");
			}
		}
	}


	function cargaSucursales(){
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'TODOS'});
		sucursalesServicio.listaCombo(catTipoListaSucursal.combo, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
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
	// funcion Genera Reporte Avales Credito

	function enviaDatosReporteAvales(){
		var clienteIni=$('#clienteInicial').val();
		var clienteFin=$('#clienteFinal').val();
		var fechaIni=$('#fechaInicial').val();
		var fechaFin=$('#fechaFinal').val();
		var promotor=$('#promotor').val();
		var diasMora=$('#diasMora').val();
		var tipoRep = "";
		sucursalID		= $("#sucursalID option:selected").val();
		nombreSucursal		= $("#sucursalID option:selected").val();
		producto = $("#producCreditoID option:selected").val();
		nombreProducto= $("#producCreditoID option:selected").val();
		estatus = $("#estatus option:selected").val();

		if(fechaIni==''){
			$('#fechaInicial').val(parametros.fechaAplicacion);
		}else{
			$('#fechaInicial').val(fechaIni);
		}
		if(fechaFin==''){
			$('#fechaFinal').val(parametros.fechaAplicacion);
		}else{
			$('#fechaFinal').val(fechaFin);
		}
		if(clienteIni == '' || clienteIni==0){
			$('#clienteInicial').val(0);
			$('#nombreClienteInicial').val('TODOS');
		}
		if(clienteFin == '' || clienteFin==0){
			$('#clienteFinal').val(0);
			$('#nombreClienteFinal').val('TODOS');
		}
		if(promotor == '' || promotor==0){
			$('#promotor').val(0);
			$('#nombrePromotor').val('TODOS');
		}
		if(diasMora==''){
			$('#diasMora').val("TODOS");
		}
		if(nombreSucursal=='0'){
			nombreSucursal='TODOS';
		}
		else{
			nombreSucursal = $("#sucursalID option:selected").html();
		}
		if(nombreProducto=='0'){
			nombreProducto='';
		}else{
			nombreProducto = $("#producCreditoID option:selected").html();
		}
		if(clienteFin < clienteIni){
			if(clienteFin !=0 && clienteIni==0 || clienteIni ==''){
				mensajeSis("El "+alertSocio+" Final no Puede ser Menor al "+alertSocio+" inicial ");
				$('#clienteFinal').val("");
				$('#clienteFinal').focus();
				$('#clienteFinal').select();
				$('#nombreClienteFinal').val("");
				$('#fechaInicial').val("");
				$('#fechaFinal').val("");
				$('#promotor').val("");
				$('#nombrePromotor').val("");
				$('#diasMora').val("");
			}else{
				if(fechaFin < fechaIni){
					mensajeSis("La Fecha Final no debe ser menor que la Fecha Inicial");
					$('#fechaFinal').focus();

				}else{
					if($('#excel').attr("checked")==false && $('#pdf').attr("checked")==false){
						mensajeSis("No ha seleccionado Ninguna Opción Para la Presentación del Reporte");
					}
					else{
						if($('#excel').is(':checked')){
							tipoRep = 2;
							imprimir(tipoRep);

						}
						if($('#pdf').is(':checked')){
							tipoRep = 1;
							imprimir(tipoRep);
						}
					}
				}
			}
		}else{
			if(fechaFin < fechaIni){
				mensajeSis("La Fecha Final no debe ser menor que la Fecha Inicial");
				$('#fechaFinal').focus();

			}else{
				if($('#excel').attr("checked")==false && $('#pdf').attr("checked")==false){
					mensajeSis("No ha seleccionado Ninguna Opción Para la Presentación del Reporte");
				}
				else{
					if($('#excel').is(':checked')){
						tipoRep = 2
						imprimir(tipoRep);

					}
					if($('#pdf').is(':checked')){
						tipoRep = 1;
						imprimir(tipoRep);
					}
				}

			}
		}

	}

	function imprimir(tipoReporte){

		var clienteIni=$('#clienteInicial').val();		
		var clienteFin=$('#clienteFinal').val();	
		var fechaIni=$('#fechaInicial').val();
		var fechaFin=$('#fechaFinal').val();
		var promotor=$('#promotor').val();
		var diasMora=$('#diasMora').val();
		var nombreClienIni =$('#nombreClienteInicial').val();
		var ClienteConCaracter = nombreClienIni;
		nombreClienIni = ClienteConCaracter.replace(/\&/g, "%26");
		var nombreClienfin=$('#nombreClienteFinal').val();
		var ClienteConCaracter = nombreClienfin;
		nombreClienfin = ClienteConCaracter.replace(/\&/g, "%26");
		var nombrePromotor=$('#nombrePromotor').val();
		var etiquetaSocio= alertSocio;

		var pagina ='repAvaladosCreditoPDF.htm?clienteInicial='+clienteIni+'&clienteFinal='+clienteFin+'&fechaInicial='+fechaIni+
		'&fechaFinal='+fechaFin+'&promotor='+promotor+'&diasMora='+diasMora+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&tipoReporte='+tipoReporte
		+'&nombreUsuario='+$('#nombreUsuario').val().toUpperCase()+'&fechaSistema='+$('#fechaSistema').val()+'&nombreClienteInicial='+nombreClienIni+'&nombreClienteFinal='+nombreClienfin+'&nombrePromotor='+nombrePromotor
		+'&sucursalID='+sucursalID+'&nombreSucursal='+nombreSucursal+'&producCreditoID='+producto+'&nombreProducto='+nombreProducto+'&estatus='+estatus
		+'&etiquetaSocio='+etiquetaSocio;
		window.open(pagina,'_blank');
	}


	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha,fechaIni){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				if(fechaIni ==1){				
					mensajeSis("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicial').val(parametros.fechaAplicacion); 	
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaInicial').focus();

				}else{
					mensajeSis("Formato de Fecha Final Incorrecto");
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaFinal').focus();
				}
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
				if(fechaIni ==1){				
					mensajeSis("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicial').val(parametros.fechaAplicacion); 	
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaInicial').focus();

				}else{
					mensajeSis("Formato de Fecha Final Incorrecto");
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaFinal').focus();
				}

			return false;
			}
			if (dia>numDias || dia==0){
				if(fechaIni ==1){				
					mensajeSis("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicial').val(parametros.fechaAplicacion); 	
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaInicial').focus();

				}else{
					mensajeSis("Formato de Fecha Final Incorrecto");
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaFinal').focus();
				}
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

	function inicializaCampos(){
		$('#fechaInicial').val(parametroBean.fechaSucursal);		
		$('#fechaFinal').val(parametroBean.fechaSucursal);		
		$('#clienteInicial').val(0);
		$('#nombreClienteInicial').val('TODOS');
		$('#clienteFinal').val(0);
		$('#nombreClienteFinal').val('TODOS');
		$('#promotor').val(0);
		$('#nombrePromotor').val('TODOS');
		$('#diasMora').val("TODOS");
	}
});