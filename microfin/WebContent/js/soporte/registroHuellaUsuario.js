$(document).ready(function() {
	var nombreCompleto;
	var serverHuella = new HuellaServer({
		fnGrabarHuella : function(datos){
			mensajeSis(datos.mensajeRespuesta);
			$('#usuarioID').focus();
			$('#usuarioID').blur();
		}
	});

	$('#usuarioID').focus();

	//Definicion de Constantes y Enums
	var catTipoTransaccionFotoCliente = {
	  		'grabar':1,
	};

	deshabilitaBoton('grabar', 'submit');
	$(':text').focus(function() {
		esTab = false;
	});


	$.validator.setDefaults({
		submitHandler : function(event) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma',
						'mensaje', 'true','usuarioID','funcionResultadoExitoso','funcionResultadoFallido');

		}
	});



	var parametrosBean = consultaParametrosSession();
	var funcionHuella = parametrosBean.funcionHuella;


	$('#grabar').click(function(){
		funcionMostrarFirma($('#nombre').val()+" "+$('#apPaterno').val()+" "+$('#apMaterno').val());
	});

	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});

	$('#usuarioID').blur(function() {
  		validaUsuario(this);
	});

	function validaUsuario(control) {
		var numUsuario = $('#usuarioID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) ){
			if(numUsuario=='0'){
				limpiaFormulario();
			}else {
				var usuarioBeanCon = {
						'usuarioID':numUsuario
				};

				usuarioServicio.consulta(1,usuarioBeanCon,function(usuario) {

					if(usuario!=null){
						$('#dedoHuellaUno').val('');
						$('#dedoHuellaDos').val('');
						dwr.util.setValues(usuario);
						consultaHuellaCliente();
						habilitaBoton('grabar');
					}else{
						limpiaFormulario();
						$('#usuarioID').focus();
						mensajeSis("El usuario no existe");
					}
				});
			}
		}
	}


	function limpiaFormulario(){
		$('#usuarioID').val('');
		$('#nombre').val('');
		$('#apPaterno').val('');
		$('#apMaterno').val('');
		$('#dedoHuellaUno').val('');
		$('#dedoHuellaDos').val('');
		deshabilitaBoton('grabar');
	}

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



	// función para consultar si el cliente ya tiene huella digital registrada
	function consultaHuellaCliente(){
		var numCliente=$('#usuarioID').val();
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente )){
			var clienteIDBean = {
				'personaID':$('#usuarioID').val()
				};


			huellaDigitalServicio.consulta(2,clienteIDBean,function(cliente) {
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
					$('#dedoHuellaDos').val('N/A');
					$('#dedoHuellaUno').val('N/A');
					$('#grabar').val('Registrar Huella');
					serverHuella.tipoRegistroHuella = 'registrar';
					$('#Estatus_Registro_Huella').html(serverHuella.estatus_huella_digital[""].html);
				}
			});
		}
	}

	function funcionMostrarFirma(nomCliente){
		var IDCta='N/A';
		var nomCta="";
		var TipoPersona="U";
		$('#apletHuella').width(800);
		$('#apletHuella').height(700);

		var CteBeanCon = {
				'personaID' : $('#usuarioID').val()
		};

		if(!serverHuella.estaConectado){
                mensajeSis("La aplicación de Huella Digital no se está ejecutando en este equipo."+
                             " Revise que la aplicación se encuentre activa y vuelva a intentarlo");
                return false;
            }

		huellaDigitalServicio.consulta(2, CteBeanCon, function(CteBean){
			  if( CteBean != null){


                serverHuella.enrolamientoUsuario(
                						nomCliente,
                						IDCta,
                						nomCta,
                				 		CteBean.personaID,
                				 		CteBean.dedoHuellaUno,
                				 		CteBean.dedoHuellaDos );



			  }else{

                serverHuella.enrolamientoUsuario(
                  						nomCliente,
                  						IDCta,
                  						nomCta,
                				 		$('#usuarioID').val(),
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