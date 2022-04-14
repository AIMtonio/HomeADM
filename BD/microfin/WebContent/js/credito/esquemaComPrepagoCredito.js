var estatusProd = "";
var descripcion = "";

$(document).ready(function() {


	esTab = true;

	//Definicion de Constantes y Enums
	var catTipoTransaccionEsquemaPrepago = {
			'alta': 1,
			'modifica': 2

	};


	var catTipoConsultaProdCredito = {
			'principal'	: 1

	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modifica', 'submit');
	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID',
					'funcionExito','funcionError');

		}
	});



	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#productoID').bind('keyup',function(e){
        lista('productoID', '2', '15', 'descripcion', $('#productoID').val(), 'listaProductosCredito.htm');
	});

	$('#productoID').blur(function(){
		validaProductoCredito();
	});

	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionEsquemaPrepago.alta);
		$('#tipComLiqAntici').removeAttr('disabled');
	    $('#cobraComLiqAntici').removeAttr('disabled');
		$('#tipComLiqAntici').removeClass('error');




	});
	$('#modifica').click(function(){
		$('#tipoTransaccion').val(catTipoTransaccionEsquemaPrepago.modifica);

	});



	$('#permiteLiqAntici').change(function(){
		var Si='S';
		var no='N';
		var vacio='';
		if ($('#permiteLiqAntici').val() == vacio) {
			$('#cobraComLiqAntici').val(vacio);
			$('#cobraComLiqAntici').attr('disabled',true);
			$('#tipComLiqAntici').val('');
			$('#tipComLiqAntici').attr('disabled',true);
			$('#comisionLiqAntici').val(0);
			$('#diasGraciaLiqAntici').val(0);
			$('#comisionLiqAntici').attr('disabled',true);
			$('#diasGraciaLiqAntici').attr('disabled',true);
		}
		if ($('#permiteLiqAntici').val() == no) {
			$('#cobraComLiqAntici').attr('disabled',true);
			$('#cobraComLiqAntici').val(no);
			$('#tipComLiqAntici').val('');
			$('#tipComLiqAntici').attr('disabled',true);
			$('#comisionLiqAntici').val(0);
			$('#diasGraciaLiqAntici').val(0);
			$('#comisionLiqAntici').attr('disabled',true);
			$('#diasGraciaLiqAntici').attr('disabled',true);


		}
		if ($('#permiteLiqAntici').val() == Si) {
			$('#cobraComLiqAntici').attr('disabled',false);
			$('#cobraComLiqAntici').focus();

		}

		});

	$('#cobraComLiqAntici').change(function(){
		var Si='S';
		var no='N';
		var vacio='';

		if ($('#cobraComLiqAntici').val() == no) {
			$('#tipComLiqAntici').val('');
			$('#tipComLiqAntici').attr('disabled',true);
			$('#comisionLiqAntici').val(0);
			$('#diasGraciaLiqAntici').val(0);
			$('#comisionLiqAntici').attr('disabled',true);
			$('#diasGraciaLiqAntici').attr('disabled',true);
			$('#tipComLiqAntici').removeClass('error');


		}


		if ($('#cobraComLiqAntici').val() == Si) {
			$('#tipComLiqAntici').attr('disabled',false);
			$('#tipComLiqAntici').focus();

		}

		});


	$('#tipComLiqAntici').change(function(){
		var vacio='';
		var proyeccion='P';
		var montoFijo='M';
		var porcentaje='S';
		if ($('#tipComLiqAntici').val() == vacio) {
			$('#comisionLiqAntici').val(0);
			$('#diasGraciaLiqAntici').val(0);
			$('#comisionLiqAntici').attr('disabled',true);
			$('#diasGraciaLiqAntici').attr('disabled',true);
		}

		if ($('#tipComLiqAntici').val() == proyeccion) {
			$('#comisionLiqAntici').val(0);
			$('#comisionLiqAntici').attr('disabled',true);
			$('#diasGraciaLiqAntici').attr('disabled',false);

		}
		if ($('#tipComLiqAntici').val() == montoFijo) {
			$('#comisionLiqAntici').focus();
			$('#comisionLiqAntici').attr('disabled',false);
			$('#diasGraciaLiqAntici').attr('disabled',false);

		}
		if ($('#tipComLiqAntici').val() == porcentaje) {
			$('#comisionLiqAntici').focus();
			$('#comisionLiqAntici').attr('disabled',false);
			$('#diasGraciaLiqAntici').attr('disabled',false);

		}

		});





	$('#formaGenerica').validate({
		rules: {

			productoCreditoID: {
				required: true
			},
			permiteLiqAntici:'required',

			cobraComLiqAntici: {
				'required':function() { return $('#permiteLiqAntici').val()=='S';}			},


			tipComLiqAntici: {
				'required':function() { return $('#cobraComLiqAntici').val()=='S';}
				},

			comisionLiqAntici:'required',



			diasGraciaLiqAntici:'required'

		},
		messages: {
			cobraComLiqAntici: {
				required: 'Especifique si cobra comision'
			},
			permiteLiqAntici: {
				required: 'Especifique si permite cobrar comision'
			},
			tipComLiqAntici: {
				required: 'Especifique el tipo de liquidación anticipada'
			},

			comisionLiqAntici: {
				required: 'Especifique la comisión '
			},
			diasGraciaLiqAntici: {
				required: 'Especificar los dias de Gracia'
			}

		}
	});
	//funcion que consulta el productos desde la tabla de PRODUCTOSCREDITO
	function validaProductoCredito() {
		var numProdCredito = $('#productoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		estatusProd = "";
		descripcion = "";
		if(numProdCredito != '' && !isNaN(numProdCredito) && esTab){

			var prodCreditoBeanCon = {
					'producCreditoID':$('#productoID').val()
			};
			productosCreditoServicio.consulta(catTipoConsultaProdCredito.principal,prodCreditoBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#productoID').val(prodCred.producCreditoID);
					$('#descripcion').val(prodCred.descripcion);
					estatusProd = prodCred.estatus;
					descripcion = prodCred.descripcion;
					consultaEsquemaCom(prodCred.producCreditoID);

				}else{
					mensajeSis('El Producto de Crédito no Existe');
					$('#productoID').focus();
					$('#productoID').val('');
					$('#descripcion').val('');
					$('#permiteLiqAntici').val('');
					$('#cobraComLiqAntici').val('');
					$('#tipComLiqAntici').val('');
					$('#comisionLiqAntici').val('');
					$('#diasGraciaLiqAntici').val('');
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('grabar','submit');
					inicializaForma('formaGenerica','producCreditoID' );
				}

			});

		}
	}
//Funcion que Consulta los productos de la tabla ESQUEMACOMPRECRE
	function consultaEsquemaCom(idProducto) {
		var tipoPrincipal = 1;
		var si='S';
		var No='N';
		var Vacio='';
		var proyeccion='P';
		var MontoFijo='M';
		var Porcentaje='S';
		setTimeout("$('#cajaLista').hide();", 200);
		if(idProducto != '' && !isNaN(idProducto)){
			var bean={
					'productoID':idProducto
			};
			esquemaComPrepagoCreditoServicio.consultaPrincipal(tipoPrincipal,bean,function(prod) {
				if(prod!=null){
					$('#permiteLiqAntici').val(prod.permiteLiqAntici);
					$('#cobraComLiqAntici').val(prod.cobraComLiqAntici);
					$('#tipComLiqAntici').val(prod.tipComLiqAntici);
					$('#comisionLiqAntici').val(prod.comisionLiqAntici);
					$('#diasGraciaLiqAntici').val(prod.diasGraciaLiqAntici);

					if(estatusProd == 'I'){
						mensajeSis("El Producto "+ descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						$('#productoID').focus();
						deshabilitaBoton('modifica','submit');
						deshabilitaBoton('grabar','submit');
					}else{
						habilitaBoton('modifica','submit');
						deshabilitaBoton('grabar','submit');
					}
				}else{
					$('#permiteLiqAntici').val('');
					$('#cobraComLiqAntici').val('');
					$('#tipComLiqAntici').val('');
					$('#comisionLiqAntici').val('');
					$('#diasGraciaLiqAntici').val('');

					if(estatusProd == 'I'){
						mensajeSis("El Producto "+ descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						$('#productoID').focus();
						deshabilitaBoton('modifica','submit');
						deshabilitaBoton('grabar','submit');
					}else{
						deshabilitaBoton('modifica','submit');
						habilitaBoton('grabar','submit');
					}
				}
				if ($('#permiteLiqAntici').val() == si) {
					$('#cobraComLiqAntici').attr('disabled',false);
				}else {
						$('#cobraComLiqAntici').attr('disabled',true);
						$('#tipComLiqAntici').attr('disabled',true);
						$('#comisionLiqAntici').attr('disabled',true);
						$('#diasGraciaLiqAntici').attr('disabled',true);
				}

				if ($('#cobraComLiqAntici').val() == si) {
					$('#tipComLiqAntici').attr('disabled',false);
					$('#comisionLiqAntici').attr('disabled',false);
					$('#diasGraciaLiqAntici').attr('disabled',false);
					$('#tipComLiqAntici').val(prod.tipComLiqAntici);
					$('#comisionLiqAntici').val(prod.comisionLiqAntici);
					$('#diasGraciaLiqAntici').val(prod.diasGraciaLiqAntici);
					if(estatusProd != 'I'){
						$('#tipComLiqAntici').focus();
						$('#comisionLiqAntici').focus();
						$('#diasGraciaLiqAntici').focus();
					}

				}else {
						$('#tipComLiqAntici').attr('disabled',true);
						$('#comisionLiqAntici').attr('disabled',true);
						$('#diasGraciaLiqAntici').attr('disabled',true);
				}

					if ($('#tipComLiqAntici').val() == Vacio) {
						$('#comisionLiqAntici').val(0);
						$('#diasGraciaLiqAntici').val(0);
						$('#comisionLiqAntici').attr('disabled',true);
						$('#diasGraciaLiqAntici').attr('disabled',true);
					}
					if ($('#tipComLiqAntici').val() == proyeccion) {
						$('#comisionLiqAntici').val(0);
						$('#diasGraciaLiqAntici').val(prod.diasGraciaLiqAntici);
						$('#comisionLiqAntici').attr('disabled',true);
						$('#diasGraciaLiqAntici').attr('disabled',false);

					}
					if ($('#tipComLiqAntici').val() == MontoFijo){
						$('#comisionLiqAntici').val(prod.comisionLiqAntici);
						$('#diasGraciaLiqAntici').val(prod.diasGraciaLiqAntici);
					    $('#comisionLiqAntici').focus();
						$('#comisionLiqAntici').attr('disabled',false);
						$('#diasGraciaLiqAntici').attr('disabled',false);
					}
					if ($('#tipComLiqAntici').val() == Porcentaje){
						$('#comisionLiqAntici').val(prod.comisionLiqAntici);
						$('#diasGraciaLiqAntici').val(prod.diasGraciaLiqAntici);
						$('#comisionLiqAntici').focus();
						$('#comisionLiqAntici').attr('disabled',false);
						$('#diasGraciaLiqAntici').attr('disabled',false);

					}




			});
		}
	}

	$('#productoID').focus();

	});

// funcion se asegura de que el usuario le ingrese solo numeros
function Validador(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {
		if (key==8|| key == 46)	{
			return true;
		}
		else
			mensajeSis("sólo se pueden ingresar números");
		return false;

	}

}

// funcion que se ejecuta cuando el resultado fue exito
function funcionExito(){
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#tipComLiqAntici').attr('disabled',true);
    $('#productoID').focus();
	$('#productoID').val('');
	$('#descripcion').val('');
	$('#permiteLiqAntici').val('');
	$('#cobraComLiqAntici').val('');
	$('#tipComLiqAntici').val('');
	$('#comisionLiqAntici').val('');
	$('#diasGraciaLiqAntici').val('');
}
//funcion que se ejecuta cuando el resultado fue error
//diferente de cero
function funcionError(){
	$('#tipComLiqAntici').attr('disabled',true);
	$('#cobraComLiqAntici').attr('disabled',true);


}