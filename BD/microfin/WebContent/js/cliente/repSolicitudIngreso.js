
$(document).ready(function() {

	$("#clienteID").focus();

	esTab = false;
	var parametroBean = consultaParametrosSession();
	//Definicion de Constantes y Enums
	var catTipoTransaccionConocimientoCte = {
			'agrega':'1',
			'modifica':'2'	};

	var catTipoConsultaConocimientoCte = {
			'principal'	:	1,
			'foranea'	:	2
	};

	$(':text').focus(function() {
        esTab = false;
	});

	$(':text').bind('keydown', function(e) {
        if (e.which == 9 && !e.shiftKey) {
            esTab = true;
        }
    });

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('generar', 'submit');
	deshabilitaBoton('impri', 'submit');



	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionConocimientoCte.modifica);
	});


	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		if(esTab){
			if($('#clienteID').val()!=""){
				consultaCliente(this.id);
			}else{
				$('#clienteID').focus();
				$('#nombreCliente').val('');
				$('#sucursal').val('');
				$('#promotorID').val('');
				$('#nombrePromotor').val('');
				$('#nombreSucursal').val('');
				mensajeSis("Especifique el Número del Cliente");
				deshabilitaBoton('impri', 'submit');
			}
		}

	});

	$('#impri').click(function() {
		generaReporte();
	});

	function generaReporte(){
		var clienteID = $('#clienteID').val();
		var tipConPrincipal =1;
		//var sucursal =parametroBean.sucursal;
		var sucursal =$('#sucursal').val();
		var clienteBeanCon = {
				'clienteID'	:clienteID
		};

		if(clienteID != '' && !isNaN(clienteID)){
			clienteServicio.consulta(tipConPrincipal,clienteID,function(creditos) {
				if(creditos!=null){
					if(creditos.esMenorEdad!='S'){
						$('#ligaGenerar').attr('href','repSolicitudIngreso.htm?ClienteID='+$('#clienteID').val()+'&SucursalID='+$('#sucursal').val());
					}
					else{
						$('#ligaGenerar').attr('href','repSolicitudIngresoMenor.htm?ClienteID='+$('#clienteID').val()+'&SucursalID='+$('#sucursal').val());

					}
				}
			});
		}
	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		//var sucursal =parametroBean.sucursal;
		var sucursal =$('#sucursal').val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){
					if(cliente.estatus=='A'){
						$('#clienteID').val(cliente.numero)	;
						$('#nombreCliente').val(cliente.nombreCompleto);
						$('#sucursal').val(cliente.sucursalOrigen);
						validaSucursal() ;
						$('#promotorID').val(cliente.promotorActual);
						consultaPromotor('promotorID');
						habilitaBoton('generar', 'submit');
						habilitaBoton('impri', 'submit');
						if(cliente.esMenorEdad!='S'){
							$('#ligaGenerar').attr('href','repSolicitudIngreso.htm?ClienteID='+$('#clienteID').val()+'&SucursalID='+$('#sucursal').val());
						}
						else{
							$('#ligaGenerar').attr('href','repSolicitudIngresoMenor.htm?ClienteID='+$('#clienteID').val()+'&SucursalID='+$('#sucursal').val());
						}
				}
					else{
						deshabilitaBoton('generar', 'submit');
						deshabilitaBoton('impri', 'submit');
						$('#clienteID').val('')	;
						$('#nombreCliente').val('');
						$('#nombreCliente').val('');
						$('#sucursal').val('');
						$('#promotorID').val('');
						$('#nombrePromotor').val('');
						$('#nombreSucursal').val('');
						$('#clienteID').focus();
						mensajeSis("El Cliente se Encuentra Inactivo");
					}
				}else{
					deshabilitaBoton('generar', 'submit');
					deshabilitaBoton('impri', 'submit');
					$('#clienteID').val('')	;
					$('#nombreCliente').val('');
					$('#nombreCliente').val('');
					$('#sucursal').val('');
					$('#promotorID').val('');
					$('#nombrePromotor').val('');
					$('#nombreSucursal').val('');
					mensajeSis("No Existe el Cliente");
				}
			});
		}
	}


	function consultaPromotor(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor==0){
			$(jqPromotor).val(0);

		}
		else

			if(numPromotor != '' && !isNaN(numPromotor) ){
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) {
					if(promotor!=null){
						$('#nombrePromotor').val(promotor.nombrePromotor);

					}else{
						mensajeSis("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotor').val('');
					}
				});
			}
	}


	function validaSucursal() {
		var numSucursal = $('#sucursal').val();
		var consultaPrincipal=1;
		if(numSucursal != '' && !isNaN(numSucursal)){

			sucursalesServicio.consultaSucursal(consultaPrincipal,numSucursal,function(sucursal) {
				if(sucursal!=null){

					$('#nombreSucursal').val(sucursal.nombreSucurs);

				}else{
					mensajeSis("No Existe la Sucursal");
					$('#sucursal').val(0);
					$('#nombreSucursal').val('');
				}
			});
		}
	}

});