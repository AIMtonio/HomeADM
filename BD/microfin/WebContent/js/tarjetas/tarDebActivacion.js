$(document).ready(function() {

	$("#tipoTarjetaD").focus();

    // conseguimos la fecha del sistema
    var parametroBean = consultaParametrosSession();
    $('#fecha').val(parametroBean.fechaSucursal);
    var tipo = 0;
	esTab = false;

	//Definicion de Constantes y Enums
    var catTipoTranActiva= {
   		'activacionTarjeta': 8,
   		'activacionTarjetaCre': 4
    };
	var catTipoConsultaCliente = {
			'corporativos' : '12'
	};
	var catTipoConsultaDirCliente = {
	  		'principal'	:	1,
	  		'dirCpTar'  :   9
	};
	var tipoTarjeta = {
		'debito'  : '1',
		'credito' : '2'
	};

	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('activar', 'submit');
	agregaFormatoControles('formaGenerica');


	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','tipoTarjetaD','funcionExitoActivaTar','funcionErrorActivaTar');
	      }
	});

	$('#activar').click(function() {
		if(tipo == 1){
			$('#tipoTransaccion').val(catTipoTranActiva.activacionTarjeta);
		}else if(tipo == 2){
			$('#tipoTransaccion').val(catTipoTranActiva.activacionTarjetaCre);
		}

	});

	$('#corpRelacionado').blur(function() {
		consultaCorp();
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
		DirCliente(this.id);

	});


	 $('#tarjetaDebID').bind('keyup',function(e){

			if($("#tipoTarjetaD").is(':checked')) {
	           	var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "tarjetaDebID";
				parametrosLista[0] = $('#tarjetaDebID').val();
				lista('tarjetaDebID', '1', '7', camposLista, parametrosLista,'tarjetasDevitoLista.htm');
	        }
	        else if($("#tipoTarjetaC").is(':checked')){
	        	var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "tarjetaDebID";
				parametrosLista[0] = $('#tarjetaDebID').val();
				lista('tarjetaDebID', '1', '3', camposLista, parametrosLista,'tarjetasCreditoLista.htm');
	        }
	});

	$('#tipoTarjetaD').click(function() {
		limpiarFormulario();
		tipo = 1;
		$('#tipoTarjetaC').attr("checked",false);
		$('#tipoTarjeta').val(tipoTarjeta.debito);
	});

	$('#tipoTarjetaC').click(function() {
		tipo = 2;
		limpiarFormulario();
		$('#tipoTarjetaD').attr("checked",false);
		$('#tipoTarjeta').val(tipoTarjeta.credito);
	});

	$("#tipoTarjetaD").blur(function() {
		$('#tipoTarjetaC').focus();
	});


	$('#tarjetaDebID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if($('#tarjetaDebID').val() != '' && esTab){
			if(tipo == 1){
				consultaDatosTarjetaDebito(this.id);
			}else if(tipo == 2){
				consultaDatosTarjetaCredito(this.id);
			}
		}else{
			$('#tipoTarjetaD').focus();
		}
	});

	$("#extTelefonoPart").blur(function(){
		if(this.value != ''){
			if($("#telefono").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telefono").focus();
			}
		}
	});

	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {

			tarjetaDebID:{
				required:true
			}
		},
		messages : {
			tarjetaDebID:{
				required: 'Especificar Número de Tarjeta',
			}
		}
	});

	//------------ Validaciones de Controles -------------------------------------


	// Se Hace la consulta al coorporativo y su Nombre correspondiente
	function consultaCorp() {
		var conCorp=$('#corpRelacionado').val();
			setTimeout("$('#cajaLista').hide();", 200);
		if ( !isNaN(conCorp) && Number(conCorp)>0) {
			clienteServicio.consulta(Number(catTipoConsultaCliente.corporativos), conCorp,"",function(cliente) {
				if (cliente != null) {
					$('#corpRelacionado').val(cliente.numero);
					$('#nombre').val(cliente.nombreCompleto);

				} else {
					deshabilitaBoton('solicitar', 'submit');
					mensajeSis("No Existe el Corporativo Relacionado.");
					$('#corpRelacionado').val('');
					$('#corpRelacionado').focus();
					   }
			});
		}else{
			$('#corpRelacionado').val('');
			 }
	}

	// funcion para consultar el nombre del cliente
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)){
					clienteServicio.consulta(1, numCliente, function(cliente) {
						if (cliente != null) {
							$('#nombreCliente').val(cliente.nombreCompleto);
							$('#telefonoCel').val(cliente.telefonoCelular);
							$('#telefono').val(cliente.telefonoCasa);
							$('#extTelefonoPart').val(cliente.extTelefonoPart);
							$('#email').val(cliente.correo);
							$('#curp').val(cliente.CURP);
							$('#fechaNac').val(cliente.fechaNacimiento);
							$('#rfc').val(cliente.RFC);
							$('#telefonoCel').setMask('phone-us');
							$('#telefono').setMask('phone-us');

							} else {
								mensajeSis("No Existe el Cliente");
								$('#nombreCliente').val('');
								$(jqCliente).focus();
								$(jqCliente).val('');
								deshabilitaBoton('solicitar','submit');
									}
						});

			}
		}


	// consulta de datos de la tarjeta de debito
	function consultaDatosTarjetaDebito(idControl){
		var jqnumeroTarjeta  = eval("'#" + idControl + "'");
		var numTarjeta = $(jqnumeroTarjeta).val();
		var conNumTarjeta=9;
		var TarjetaBeanCon = {
				'tarjetaDebID'	:numTarjeta
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTarjeta != '' && !isNaN(numTarjeta)){
		tarjetaDebitoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaDebito) {
			if(tarjetaDebito!=null){
				$('#clienteID').val(tarjetaDebito.clienteID);
				consultaCliente('clienteID');
				DirCliente('clienteID');
				if (tarjetaDebito.corpRelacionado == '' || tarjetaDebito.corpRelacionado == 0 || tarjetaDebito.corpRelacionado == null) {
					$('#cteCorpTr').hide();
					$('#cteCorpTr2').hide();
				}else {
					$('#cteCorpTr').show();
					$('#cteCorpTr2').show();
					$('#corpRelacionado').val(tarjetaDebito.corpRelacionado);
					consultaCorp();
				}
				if( tarjetaDebito.estatus == 7 ){
					mensajeSis("La Tarjeta se encuentra Activada");
					deshabilitaBoton('activar', 'submit');
				}
				if(tarjetaDebito.estatus == 6 ){
					 habilitaBoton('activar', 'submit');
				}else{
					deshabilitaBoton('activar', 'submit');
				}
			}else{
				mensajeSis("El Número de Tarjeta no Existe");
				deshabilitaBoton('activar', 'submit');
				limpiarFormulario();
				$('#tarjetaDebID').focus();
				}
			});

		}
		else{
			deshabilitaBoton('activar', 'submit');
			$('#clienteID').val('');
			$('#rfc').val('');
			$('#corpRelacionado').val('');
			$('#nombre').val('');
			$('#nombreCliente').val('');
			$('#direccion').val('');
			$('#codigoPostal').val('');
			$('#telefono').val('');
			$('#telefonoCel').val('');
			$('#tarjetaDebID').val('');
			$('#email').val('');
			$('#curp').val('');
			$('#fechaNac').val('');
		}
	 }






	 // consulta de datos de la tarjeta de debito
	function consultaDatosTarjetaCredito(idControl){
		var jqnumeroTarjeta  = eval("'#" + idControl + "'");
		var numTarjeta = $(jqnumeroTarjeta).val();
		var conNumTarjeta=3;
		var TarjetaBeanCon = {
				'tarjetaDebID'	:numTarjeta
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTarjeta != '' && !isNaN(numTarjeta)){
		tarjetaCreditoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaCredito) {
			if(tarjetaCredito!=null){
				$('#clienteID').val(tarjetaCredito.clienteID);
				consultaCliente('clienteID');
				DirCliente('clienteID');
				if (tarjetaCredito.corpRelacionado == '' || tarjetaCredito.corpRelacionado == 0 || tarjetaCredito.corpRelacionado == null) {
					$('#cteCorpTr').hide();
					$('#cteCorpTr2').hide();
				}else {
					$('#cteCorpTr').show();
					$('#cteCorpTr2').show();
					$('#corpRelacionado').val(tarjetaCredito.corpRelacionado);
					consultaCorp();
				}
				if( tarjetaCredito.estatus == 7 ){
					mensajeSis("La Tarjeta se encuentra Activada");
					deshabilitaBoton('activar', 'submit');
				}
				if(tarjetaCredito.estatus == 6 ){
					 habilitaBoton('activar', 'submit');
				}else{
					deshabilitaBoton('activar', 'submit');
				}
			}else{
				mensajeSis("El Número de Tarjeta no Existe");
				deshabilitaBoton('activar', 'submit');
				limpiarFormulario();
				$('#tarjetaDebID').focus();
				}
			});

		}
		else{
			deshabilitaBoton('activar', 'submit');
			$('#clienteID').val('');
			$('#rfc').val('');
			$('#corpRelacionado').val('');
			$('#nombre').val('');
			$('#nombreCliente').val('');
			$('#direccion').val('');
			$('#codigoPostal').val('');
			$('#telefono').val('');
			$('#telefonoCel').val('');
			$('#tarjetaDebID').val('');
			$('#email').val('');
			$('#curp').val('');
			$('#fechaNac').val('');
		}
	 }

	function DirCliente(idControl) {
		var jqnumeroCliente  = eval("'#" + idControl + "'");
		var numcliente = $(jqnumeroCliente).val();
		var direccionesCliente ={
	 			'clienteID' :numcliente
		};
		setTimeout("$('#cajaLista').hide();", 200);
				direccionesClienteServicio.consulta(catTipoConsultaDirCliente.dirCpTar,direccionesCliente,function(direccion) {
					if(direccion!=null){
						$('#direccion').val(direccion.direccionCompleta);
					    $('#codigoPostal').val(direccion.CP);

					}else{
						mensajeSis("No Existe la direccion del Cliente");

					}
				});
			}


	// funcion que limpia el formulario
	function limpiarFormulario(){
		$('#clienteID').val('');
		$('#rfc').val('');
		$('#corpRelacionado').val('');
		$('#nombre').val('');
		$('#nombreCliente').val('');
		$('#direccion').val('');
		$('#codigoPostal').val('');
		$('#telefono').val('');
		$('#telefonoCel').val('');
		$('#tarjetaDebID').val('');
		$('#email').val('');
		$('#curp').val('');
		$('#fechaNac').val('');
		$('#tipoTarjeta').val('');
	}
});//fin

// funcion que se ejecuta cuando el resultado fue un éxito
function funcionExitoActivaTar(){
	deshabilitaBoton('activar', 'submit');
	$('#clienteID').val('');
	$('#rfc').val('');
	$('#corpRelacionado').val('');
	$('#nombre').val('');
	$('#nombreCliente').val('');
	$('#direccion').val('');
	$('#codigoPostal').val('');
	$('#telefono').val('');
	$('#telefonoCel').val('');
	$('#tarjetaDebID').val('');
	$('#email').val('');
	$('#curp').val('');
	$('#fechaNac').val('');
	$('#tipoTarjeta').val('');
	$('#tipoTarjetaD').attr("checked",false);
	$('#tipoTarjetaC').attr("checked",false);
	$("#tipoTarjetaD").focus();
}

// funcion que se ejecuta cuando el resultado fue error
// diferente de cero
function funcionErrorActivaTar(){
}

function Validador(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {

		if (key==8|| key == 46)	{
			return true;
		}
		else
		return false;
	}
}
//función para cargar los valores de la lista recibe el
//el control que es el campo donde secargara el valor y el valorCompleto es un valor extra. que se podra usar en cualquier campo

function cargaValorListaTarjetaDeb(control, valor,valorCompleto) {
	consultaSesion();
	jqControl = eval("'#" + control + "'");
	$(jqControl).val(valor);
	$(jqControl).focus();
	setTimeout("$('#cajaLista').hide();", 200);
	$('#tarjetaDebID').val(valorCompleto);
}

function cargaValorListaTarjetaCred(control, valor,valorCompleto) {
	consultaSesion();
	jqControl = eval("'#" + control + "'");
	$(jqControl).val(valor);
	$(jqControl).focus();
	setTimeout("$('#cajaLista').hide();", 200);
	$('#tarjetaDebID').val(valorCompleto);
}