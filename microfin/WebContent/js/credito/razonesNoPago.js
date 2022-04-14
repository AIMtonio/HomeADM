$(document).ready(function() {

	var catRazonesNoPago = {
			'combo': 1
	};

	var parametros = consultaParametrosSession();
	cargaSucursales();
	// ----------------------------------- Metodos y Eventos -----------------------------
	agregaFormatoControles('formaGenerica');

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			generaExcel();
		}
	});
	
	$('#generar').click(function() {
		generaExcel();
	});
	
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var fechaFin = $('#fechaFin').val();
		if ( mayor(Xfecha, fechaFin) )
		{
			mensajeSis("La Fecha de Inicio no puede ser mayor a la Fecha Fin.")	;
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var fechaFin = $('#fechaFin').val();
		var fechaSuc = parametroBean.fechaSucursal;
        
			if ( menor(fechaFin, Xfecha) )
			{
				mensajeSis("La Fecha Fin no debe ser menor a la Fecha Inicial.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(fechaFin, fechaSuc) )
			{
				mensajeSis("La Fecha Fin no puede ser mayor a la Fecha del Sistema.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
	});
	
	$('#formaGenerica').validate({
		rules: {
			fechaInicial :{
				required: true
			},
			fechaFin :{
				required: true
			}
		},
		
		messages: {
			fechaInicial :{
				required: 'Especifique la fecha inicial.'
			}
			,fechaFin :{
				required: 'Especifique la fecha final.'
			}
		}
	});
	
	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}else{
			lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		}
	});
	
	$('#clienteID').blur(function() {
		consultaCliente('clienteID');
	});
	
	$('#creditoID').bind('keyup',function(e) {
        lista('creditoID', '2', '11','creditoID', $('#creditoID').val(),'ListaCredito.htm');
    });
	
	$('#creditoID').blur(function() {
		consultaCredito('creditoID');
	});
	
	function consultaCredito(idControl) {
	var jqCredito = eval("'#" + idControl + "'");
	var credito = $(jqCredito).val();

	var creditoBeanCon = {
		'creditoID' : credito
	};
	if ($("#creditoID").asNumber() > 0) {
		credito = parseInt(credito);
		creditosServicio.consulta(1,creditoBeanCon,
						function(creditos) {
							if (creditos != null) {
								var creditosID = creditos.creditoID;
								$('#creditoID').val(creditos.creditoID);
								deshabilitaControl('clienteID');
								$('#clienteID').val("");
								$('#nombreCliente').val("");
								deshabilitaControl('sucursalID');
								$('#sucursalID').val("");
								$('#nombreSucursal').val("");
								deshabilitaControl('promotorID');
								$('#promotorID').val("");
								$('#nombrePromotor').val("");
							} else {
								$('#creditoID').val("0");
								habilitaControl('clienteID');
								habilitaControl('sucursalID');
								habilitaControl('promotorID');
							}
						});
			}
		}
	
	$('#promotorID').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorID').val();
		parametrosLista[1] = parametroBean.sucursal;  
		lista('promotorID', '1', '2',camposLista, parametrosLista, 'listaPromotores.htm');
	});
	$('#promotorID').blur(function() {
		if(isNaN($('#promotorID').val())){
			$('#promotorID').val('');
			$('#nombrePromotor').val('');
			$('#promotorID').focus();
		}else{
			consultaPromotorI(this.id, 'nombrePromotor', true);
			
		}
	});
	
	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	
	$('#sucursalID').blur(function() {
  		validaSucursal(this);
	});
	
	function cargaSucursales(){
		dwr.util.removeAllOptions('razonID');
		dwr.util.addOptions( 'razonID', {'0':'TODAS'});
		creditosServicio.listComboImpago(catRazonesNoPago.combo, function(razones){
			dwr.util.addOptions('razonID', razones, 'razonID', 'razonDescripcion');
		});
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

});

function consultaCliente(idControl) {
	var jqCliente = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();
	setTimeout("$('#cajaLista').hide();", 200);
	
	if (numCliente != '' && !isNaN(numCliente) && esTab) {
		clienteServicio.consulta(1, numCliente, function(
				cliente) {
			if (cliente != null) {
				$('#clienteID').val(cliente.numero);
				$('#nombreCliente').val(cliente.nombreCompleto);
				deshabilitaControl('sucursalID');
				$('#sucursalID').val("");
				$('#nombreSucursal').val("");
				deshabilitaControl('promotorID');
				$('#promotorID').val("");
				$('#nombrePromotor').val("");
			} else {
				mensajeSis("No Existe el Cliente");
				$('#clienteID').val('');
				$('#nombreCliente').val('');
				habilitaControl('sucursalID');
				habilitaControl('promotorID');
			}
		});
	}
}

function consultaPromotorI(idControl,idControlNom, valida) {
	var jqPromotor = eval("'#" + idControl + "'");
	var numPromotor = $(jqPromotor).val();
	var jqNombre = eval("'#" + idControlNom + "'");
	var tipConForanea = 2;
	var promotor = {
		'promotorID' : numPromotor
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPromotor != '' && !isNaN(numPromotor)) {
		promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
			if (promotor != null) {
				if(valida){
					if(promotor.estatus != 'A'){
						mensajeSis("El Promotor debe de estar Activo");
						 $(jqPromotor).val("");
						 $(jqPromotor).focus();
						 $(jqNombre).val("");
					}
				}
				if(promotor.estatus == 'A'){
					if(valida){
						parametroBean = consultaParametrosSession();
						if(promotor.sucursalID != parametroBean.sucursal){
							mensajeSis("El Promotor debe de pertenecer a la Sucursal: "+parametroBean.nombreSucursal);
							$(jqPromotor).val("");
							 $(jqNombre).val("");
							 $(jqPromotor).focus();
						}else{
							$(jqNombre).val(promotor.nombrePromotor);
						}
					} else {
						$(jqNombre).val(promotor.nombrePromotor);
					}
				}					
			} else {
				$(jqPromotor).val("");
				$(jqNombre).val("");
				$(jqPromotor).focus();
				mensajeSis("No Existe el Promotor.");
			}
		});
	}
}

function validaSucursal(control) {
	var numSucursal = $('#sucursalID').val();
	var gerente = "";
	var subgerente = "";

	setTimeout("$('#cajaLista').hide();", 200);
	if(numSucursal != '' && !isNaN(numSucursal)){
		habilitaBoton('agrega', 'submit');
		habilitaBoton('modifica', 'submit');
		sucursalesServicio.consultaSucursal(1,numSucursal,{ async: false, callback: function(sucursal) {
			if(sucursal!=null){
				$('#nombreSucursal').val(sucursal.nombreSucurs);
			}else{
				$('#sucursalID').val('');
				$('#nombreSucursal').val('');
			}
		}});
	}
}

function generaExcel(){
	
	
	var fechaInicio = $('#fechaInicio').val();	 
	var fechaFin = $('#fechaFin').val();	
	var sucursalID = $("#sucursalID").val();
	var razonID = $('#razonID').val();
	var creditoID = $('#creditoID').val();
	var clienteID = $('#clienteID').val();
	var promotorID = $('#promotorID').val();
	
	var tipo_reporte = 1;
	var tipo_consulta = 1;
	


	$('#ligaGenerar').attr('href','ReporteRazonNoPago.htm?'+
			
			'&tipoReporte='+tipo_reporte+
			'&tipoLista='+tipo_consulta+
			'&fechaInicio='+fechaInicio+
			'&fechaFin='+fechaFin+
			'&sucursalID='+sucursalID+
			'&razonID='+razonID+
			'&creditoID='+creditoID+
			'&clienteID='+clienteID+
			'&promotorID='+promotorID
			

	);
}