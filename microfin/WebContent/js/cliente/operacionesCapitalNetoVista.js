var Var_TipoDocumento=55;
$(document).ready(function() {
	//consulta los parametros del usuario y sesion
	var parametrosBean = consultaParametrosSession();
	var tipoTransaccion= {
		'autoriza' : '1',
		'rechaza' : '2',
	};


	esTab = false;

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

	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	/*le da formato de moneda, calendario, etc */
	agregaFormatoControles('formaGenerica');
	$('#pantallaOrigen').focus();


	/*esta funcion esta en forma.js */
	deshabilitaBoton('autoriza', 'submit');
	deshabilitaBoton('rechaza', 'submit');
	deshabilitaControl('operacionID');
	limpiacampos();
	$('#pantallaOrigen').change(function() {
		limpiacampos();
		if($('#pantallaOrigen').val()!=""){
			$('#operacionID').val("");
			habilitaControl('operacionID');

		}else{
			deshabilitaBoton('autoriza', 'submit');
			deshabilitaBoton('rechaza', 'submit');
			deshabilitaControl('operacionID');
		}
	});

	/* lista de ayudas para clientes */
	$('#operacionID').blur(function() {
		if(esTab){
			consultaOperacion(this.id);
		}
	});

	/* lista de ayudas para solicitud (de apoyo escolar) */
	$('#operacionID').bind('keyup',function(e) {
		var proceso = $('#pantallaOrigen').val();

		if(proceso !=""){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "pantallaOrigen";
			camposLista[1] = "operacionID";

			parametrosLista[0] = proceso;
			parametrosLista[1] = $('#operacionID').val();

			listaAlfanumerica('operacionID', '3', '1', camposLista, parametrosLista, 'listaOperCapNeto.htm');
		}
	});





	/*asigna el tipo de transaccion */
	$('#autoriza').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.autoriza);
	});

	$('#rechaza').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.rechaza);

	});



	/*esta funcion esta en forma.js, verifica que el mensaje d error o exito aparezcan correctamente y que realizara despues de cada caso */
	$.validator.setDefaults({
	    submitHandler: function(event) {
	    	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','operacionID',
		    			'funcionExito','funcionFallo');

	    }
	 });



	/* =============== VALIDACIONES DE LA FORMA ================= */
		$('#formaGenerica').validate({
			rules: {
				pantallaOrigen :{
					required:true
				},
				operacionID : {
					required: true
				}
			},
			messages: {
				pantallaOrigen :{
					required:'Especificar el proceso.'
				},
				operacionID : {
					required: 'Especificar la operación.'
				}
			}
		});





});//

function funcionExito(){
	limpiacampos();
	deshabilitaBoton('autoriza', 'submit');
	deshabilitaBoton('rechaza', 'submit');
}

function funcionFallo(){

}

/* CONSULTA OPERACION */
function consultaOperacion(idControl) {
	var jqInstrumento = eval("'#" + idControl + "'");
	var instrumento = $(jqInstrumento).val();
	setTimeout("$('#cajaLista').hide();", 200);
	operacionBean = {
		'operacionID'	: instrumento,
		'pantallaOrigen'	: $('#pantallaOrigen').val()
	};

	//constulta la operacion
	operacionesCapitalNetoServicio.consulta(1, operacionBean, function(datos) {
		if(datos != null) {
			dwr.util.setValues(datos);

			if(datos.estatusOper!= "SIN PROCESAR"){
				mensajeSis('La operación se encuentra con estatus <b>'+datos.estatusOper,'</b>.');
			}
			switch(datos.estatusOper) {
				case "SIN PROCESAR":
					habilitaBoton('autoriza', 'submit');
					habilitaBoton('rechaza', 'submit');
					habilitaControl('comentario');
				break;
				case "RECHAZADA":
					deshabilitaBoton('autoriza', 'submit');
					deshabilitaBoton('rechaza', 'submit');
					deshabilitaControl('comentario');
				break;
				case "AUTORIZADA":
					deshabilitaBoton('autoriza', 'submit');
					deshabilitaBoton('rechaza', 'submit');
					deshabilitaControl('comentario');
				break;
				default:
					deshabilitaBoton('autoriza', 'submit');
					deshabilitaBoton('rechaza', 'submit');
					deshabilitaControl('comentario');
			}

			consultaCliente(datos.clienteID);
			consultaSucursal(datos.sucursalID);
			switch(datos.pantallaOrigen) {
				case "AS":
					consultaProducto(datos.productoID);
				break;
				case "AC":
					consultaTipoCede(datos.productoID);
				break;
				case "AI":
					validaTipoInversion(datos.productoID);
				break;
			}
			agregaFormatoControles('formaGenerica');
		} else {
			mensajeSis('No existe la operacón ingresada.');
			$('#operacionID').focus();
			limpiacampos();
		}
	});

}

/* Consulta el cliente */
function consultaCliente(clinteID) {
	//constulta un cliente
	clienteServicio.consulta(1, clinteID, function(cliente) {
		//si el resultado obtenido de la consulta regreso un resultado
		if(cliente!= null) {
			$('#nombreCompleto').val(cliente.nombreCompleto);
		}
		else{
			mensajeSis('El cliente '+clinteID+' no existe.');
			$('#clienteID').val("");
			$('#nombreCompleto').val("");
		}
	});
}

function consultaSucursal(sucursalID) {
	setTimeout("$('#cajaLista').hide();", 200);
	sucursalesServicio.consultaSucursal(1,sucursalID,function(sucursal) {
		if(sucursal!=null){
			$('#nombreSucursal').val(sucursal.nombreSucurs);

		}else{
			mensajeSis('La sucursal '+productoID+' no existe.');
			$('#sucursalID').val("");
			$('#nombreSucursal').val("");
		}
	});
}

function consultaProducto(productoID) {

	var prodCreditoBeanCon = {
		'producCreditoID':productoID
	};
	productosCreditoServicio.consulta(1,prodCreditoBeanCon,function(prodCred) {
		if(prodCred!=null){
			$('#desProducto').val(prodCred.descripcion);
		}else{
			mensajeSis('El producto '+productoID+' no existe.');
			$('#productoID').val("");
			$('#desProducto').val("");
		}

	});
}

function consultaTipoCede(tipoCedeID){
	setTimeout("$('#cajaLista').hide();", 200);
	var tipoCedeBean = {
			'tipoCedeID':tipoCedeID,
	};
	tiposCedesServicio.consulta(1, tipoCedeBean, function(tipoCede){
		if(tipoCede!=null){
			$('#desProducto').val(tipoCede.descripcion);
		}else{
			mensajeSis('El producto '+productoID+' no existe.');
			$('#productoID').val("");
			$('#desProducto').val("");
		}
	});
}

function validaTipoInversion(tipoInversionID){
	setTimeout("$('#cajaLista').hide();", 200);
	var TipoInversionBean ={
		'tipoInvercionID' :tipoInversionID,
		'monedaId': 1
	};
	tipoInversionesServicio.consultaPrincipal(1,TipoInversionBean, function(tipoInversion){
		if(tipoInversion!=null){
			$('#desProducto').val(tipoInversion.descripcion);
		}else{
			mensajeSis('El producto '+productoID+' no existe.');
			$('#productoID').val("");
			$('#desProducto').val("");
		}
	});
}

/*LIMPIA CAMPOS */
function limpiacampos() {
	$('#fechaOperacion').val("");
	$('#clienteID').val("");
	$('#nombreCompleto').val("");
	$('#productoID').val("");
	$('#desProducto').val("");
	$('#sucursalID').val("");
	$('#nombreSucursal').val("");
	$('#instrumentoID').val("");
	$('#capitalNeto').val("0.0");
	$('#porcentaje').val("0.00");
	$('#estatusOper').val("");
	$('#montoOper').val("");
	$('#comentario').val("");

}