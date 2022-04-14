$(document).ready(function() {

	var nombreCompleto;
	var serverHuella = new HuellaServer({
		fnGrabarHuella : function(datos){
			mensajeSis(datos.mensajeRespuesta);
			$('#clienteID').focus();
			$('#clienteID').blur();
		}
	});
	//Definicion de Constantes y Enums
	var catTipoTransaccionFotoCliente = {
	  		'grabar':1,
	};

	deshabilitaBoton('grabar', 'submit');
	esTab = false;

	$('#clienteID').focus();

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
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma',
						'mensaje', 'true','clienteID','funcionResultadoExitoso','funcionResultadoFallido');

		}
	});



	var parametrosBean = consultaParametrosSession();
	var funcionHuella = parametrosBean.funcionHuella;

	if($('#flujoCliNumCli').val() != undefined){
		var numCliFlu = Number($('#flujoCliNumCli').val());
		$('#clienteID').val($('#flujoCliNumCli').val());
		if(!isNaN($('#flujoCliNumCli').val())){
			if(funcionHuella == "S"){
				if($('#clienteID').val()!=''){
				habilitaBoton('grabar','sumbit');
			}else{
				deshabilitaBoton('grabar','sumbit');
			}
  			consultaHuellaCliente();
  			consultaCliente('clienteID');
			}
			else{
  			consultaCliente('clienteID');
  			deshabilitaBoton('grabar','sumbit');
  			}
		}
	}

	$('#grabar').click(function(){
		funcionMostrarFirma($('#nombreCliente').val());
	});

	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});


	$('#clienteID').blur(function() {
  		if(funcionHuella=="S"){
			if($('#clienteID').val()!=''){
				habilitaBoton('grabar','sumbit');
			}else{
				deshabilitaBoton('grabar','sumbit');
			}
  			consultaHuellaCliente();
  			consultaCliente('clienteID');
  		}else{
  			consultaCliente('clienteID');
  			deshabilitaBoton('grabar','sumbit');
  		}
	});

	//------------------------validaciones-----------

	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true
			}

		},
		messages: {
			clienteID: {
				required: 'Especificar Cliente'
			}

		}
	});
	//--------------------------funciones---------------------------


	function consultaCliente(control) {
		var masculino='M';
		var femenino='F';
		var moral='M';
		var fisicaActividaEmpresarial='A';
		var fisica='F';
		var numCliente = $('#clienteID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
				clienteServicio.consulta(1,numCliente,function(cliente) {
					if (cliente != null) {
						$('#telefonoCasa').val(cliente.telefonoCasa);
						if (cliente.fechaNacimiento == '1900-01-01'){
							$('#fechaNacimiento').val('');
						}else{
							$('#fechaNacimiento').val(cliente.fechaNacimiento);
						}
						$('#dedoHuellaUno').val('N/A');
						$('#dedoHuellaDos').val('N/A');
						nombreCompleto = cliente.nombreCompleto;
						$('#nombreCliente').val(cliente.nombreCompleto);
						if(cliente.sexo==masculino ){
							$('#sexo').val('MASCULINO');
						}
						if(cliente.sexo==femenino ){
							$('#sexo').val('FEMENINO');
						}
						if(cliente.tipoPersona==moral ){
							$('#tipoPersona').val('MORAL');
						}
						if(cliente.tipoPersona==fisicaActividaEmpresarial){
							$('#tipoPersona').val('FISICA CON ACT. EMP.');
						}
						if(cliente.tipoPersona==fisica){
							$('#tipoPersona').val('FISICA');
						}
						if(funcionHuella=="S"){
							if (cliente.estatus=='I'){
								mensajeSis("El Cliente se encuentra Inactivo");
								$('#clienteID').val('');
								$('#nombreCliente').val('');
								$('#tipoPersona').val('');
								$('#sexo').val('');
								$('#fechaNacimiento').val('');
								$('#telefonoCasa').val('');
								$('#clienteID').focus();
								deshabilitaBoton('grabar','submit');
							}else{
							 consultaHuellaCliente();
							 habilitaBoton('grabar','submit');
							}
						}else{
							deshabilitaBoton('grabar','sumbit');
						}
					} else {
						limpiaForm($('#formaGenerica'));
						mensajeSis("No Existe el Cliente");
						deshabilitaBoton('grabar','submit');
						$('#clienteID').focus();
						$('#clienteID').select();
					}
				});
		}
	}

	// función para consultar si el cliente ya tiene huella digital registrada
	function consultaHuellaCliente(){
		var numCliente=$('#clienteID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente )){
			var clienteIDBean = {
				'personaID':$('#clienteID').val()
				};
			huellaDigitalServicio.consulta(1,clienteIDBean,function(cliente) {
				if (cliente!=null){
					var HuellaUno;
					var HuellaDos;
					if(cliente.dedoHuellaUno == 'I'){
						HuellaUno = 'INDICE';
					}else if (cliente.dedoHuellaUno == 'M'){
						HuellaUno = 'MEDIO';
					}else if(cliente.dedoHuellaUno == 'A'){
						HuellaUno = 'ANULAR';
					}else if(cliente.dedoHuellaUno == 'N'){
						HuellaUno = 'MENIQUE';
					}else if(cliente.dedoHuellaUno == 'P'){
						HuellaUno = 'PULGAR';
					}
					if(cliente.dedoHuellaDos == 'I'){
						HuellaDos = 'INDICE';
					}else if (cliente.dedoHuellaDos == 'M'){
						HuellaDos = 'MEDIO';
					}else if(cliente.dedoHuellaDos == 'A'){
						HuellaDos = 'ANULAR';
					}else if(cliente.dedoHuellaDos == 'N'){
						HuellaDos = 'MENIQUE';
					}else if(cliente.dedoHuellaDos == 'P'){
						HuellaDos = 'PULGAR';
					}
					$('#dedoHuellaUno').val(HuellaUno);
					$('#dedoHuellaDos').val(HuellaDos);
					$('#grabar').val('Modificar Huella');
					serverHuella.tipoRegistroHuella = 'modificar';
					habilitaBoton('grabar');
					$('#Estatus_Registro_Huella').html(serverHuella.estatus_huella_digital[cliente.estatus].html);
				}else{
					$('#grabar').val('Registrar Huella');
					$('#Estatus_Registro_Huella').html(serverHuella.estatus_huella_digital[""].html);
					serverHuella.tipoRegistroHuella = 'registrar';

				}
			});
		}
	}

	function funcionMostrarFirma(nomCliente){
		var IDCta='N/A';
		var nomCta="";
		var TipoPersona="C";
		$('#apletHuella').width(800);
		$('#apletHuella').height(700);

		var CteBeanCon = {
				'personaID' : $('#clienteID').val()
		};

		if(!serverHuella.estaConectado){
            mensajeSis("La aplicación de Huella Digital no se está ejecutando en este equipo."+
                         " Revise que la aplicación se encuentre activa y vuelva a intentarlo");
            return false;
        }

		huellaDigitalServicio.consulta(1, CteBeanCon, function(CteBean){
			  var Regitro='REGISTRO';
			   if( CteBean != null){


                serverHuella.enrolamientoCliente(
                						nomCliente,
                						IDCta,
                						nomCta,
                				 		CteBean.personaID,
                				 		CteBean.dedoHuellaUno,
                				 		CteBean.dedoHuellaDos );



			  }else{

                serverHuella.enrolamientoCliente(
                  						nomCliente,
                  						IDCta,
                  						nomCta,
                				 		$('#clienteID').val(),
                				 		'',
                				 		'' );

			  }
		 });
	}

});
//-- funciones de exito y fallido
function funcionResultadoExitoso(){
	deshabilitaBoton('grabar','submit');
}
function funcionResultadoFallido(){
	deshabilitaBoton('grabar','submit');
}
