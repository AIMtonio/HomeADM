$(document).ready(function() {

	var parametroBean = consultaParametrosSession();
	$('#sucursalOrigen').val(parametroBean.sucursal);	
	$('#sucursalO').val(parametroBean.nombreSucursal);	
	
	esTab = true;
	// Definicion de Constantes y Enums
	var catTipoTransaccionActa = {
		'activa' : '5',
		'inactiva' : '6'
	};

	var catTipoConsultaActa = {
		'principal' : '1',
		'foranea' : '2'
	};
	var catTipoConsultaSolicitud = {
		'principal' : '1'
	};
	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	deshabilitaBoton('imprimir', 'submit');
		
	agregaFormatoControles('formaGenerica');
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccion(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','solicitudInd');
		}
	});
	
	$('#solicitudCreditoID').bind('keyup',function(e){  
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#solicitudCreditoID').val();
	
			lista('solicitudCreditoID', '1', '1', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}				       
	});

	$('#solicitudCreditoID').blur(function() {	 
		if( $.trim($('#solicitudCreditoID').val())!= ""  && esTab == true){
			validaSolicitudCredito(this.id);
		}
	});	
	
	$('#grupo').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
		   var parametrosLista = new Array();
		   camposLista[0] = "nombreGrupo";
		   parametrosLista[0] = $('#grupo').val();
		 	lista('grupo', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm');
		 }
	});
	
	$('#grupo').blur(function() {
		validaGrupo(this.id);
	});
	var grpID = 0;
	var solID = 0;
	$('#genera').click(function() {
		if ($('#solicitudInd').is(':checked')){
			if($('#solicitudCreditoID').val() == '' ){
				alert("Especifique la Solicitud de Credito");
				$('#solicitudCreditoID').focus();
				return false;
			}else {
				solID = $('#solicitudCreditoID').val();
				grpID = 0;
			}
		}else if ($('#solicitudGrp').is(':checked')) {
			if($('#grupo').val() == '' ){
				alert("Especifique un Grupo");
				$('#grupo').focus();
				return false;
			}else{
				solID = 0;
				grpID = $('#grupo').val();
			}
		}
		var numUsuario = parametroBean.numeroUsuario;
		var grupoID = grpID;
		var solicitudCreditoID = solID;
		$('#ligaPDF').attr('href',
					'repActaComite.htm?usuario='+numUsuario+
					'&grupoID='+grupoID+
					'&solicitudCreditoID='+solID);	
	});

	$('#solicitudInd').click(function () {
		$('.trIndividual').show();
		$('.trGrupal').hide();
		$('#grupo').val('');
		$('#nombreGrupo').val('');
	});
	
	$('#solicitudGrp').click(function () {
		$('.trGrupal').show();
		$('.trIndividual').hide();
		$('#solicitudCreditoID').val('');
		$('#clienteID').val('');
		$('#nombreCte').val('');
	});
	
	// ------------ Validaciones de Controles-------------------------------------
	function validaGrupo(idControl){
		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		
		var grupoBeanCon = {
  			'grupoID':grupo
		};
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		if(grupo != '' && !isNaN(grupo) && esTab){
			gruposCreditoServicio.consulta(1,grupoBeanCon,function(grupos) {
				if(grupos!=null){
					$('#nombreGrupo').val(grupos.nombreGrupo);
				}else{
					alert("El Grupo no Existe");
					$(jqGrupo).focus();
					deshabilitaBoton('agregar', 'submit');
				}
			});
		}
   }
	
	function validaSolicitudCredito(idControl) {
		var usuario= parametroBean.numeroUsuario;
		var SolCredBeanCon = {
			'solicitudCreditoID': $('#solicitudCreditoID').val(),
			'usuario': usuario
		};
		solicitudCredServicio.consulta(1, SolCredBeanCon,function(solicitud) {
			if(solicitud!=null){
				$('#clienteID').val(solicitud.clienteID);
				$('#nombreCte').val(solicitud.nombreCompletoCliente);
			}
		});
	}
});