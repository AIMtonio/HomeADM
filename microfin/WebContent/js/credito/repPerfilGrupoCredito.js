$(document).ready(function() {
	esTab = true;

	var catTipoConsultaGrupo = {
			'principal'	: 1		  		
	};
	parametros = consultaParametrosSession();
	$('#usuario').val(parametros.nombreUsuario); // parametros del sesion para el reporte
	$('#nombreInstitucion').val(parametros.nombreInstitucion);
	$('#fechaEmision').val(parametroBean.fechaSucursal);

	// ----------------------------------- Metodos y Eventos -----------------------------

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

	$('#nombreGrupo').blur(function() { 
		var nombreCnEspacios = $('#nombreGrupo').val();
		var  nombreSinEspacios= $.trim(nombreCnEspacios);
		$('#nombreGrupo').val(nombreSinEspacios);
	});

	$('#grupoID').blur(function() { 
		esTab=true;
		validaGrupo(this.id); 
	});


	$('#grupoID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array(); 
			var parametrosLista = new Array(); 
			camposLista[0] = "nombreGrupo";
			parametrosLista[0] = $('#grupoID').val();
			listaAlfanumerica('grupoID', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); } });

	$('#generar').click(function(){
		var reportePDF = 1;
		enviaDatosPerfilGrupo(reportePDF); 
		
	});

	$('#formaGenerica').validate({

		rules: {	
			grupoID: {
				required: true

			},
		},		
		messages: {		
			grupoID: {
				required: 'Especifica Grupo.',

			},

		}		
	});

	function validaGrupo(control) {
		var numGrupo = $('#grupoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numGrupo != '' && !isNaN(numGrupo) && esTab){

			var grupoBeanCon = { 
					'grupoID':$('#grupoID').val()
			};
			gruposCreditoServicio.consulta(catTipoConsultaGrupo.principal,grupoBeanCon,function(grupos) {
				if(grupos!=null){
					dwr.util.setValues(grupos);
					$('#usuario').val(parametros.nombreUsuario);	
					$('#nombreInstitucion').val(parametros.nombreInstitucion);
				}
				else{								
					alert("No Existe el grupo");
					$('#grupoID').val('');
					$('#nombreGrupo').val('');
					$('#fechaRegistro').val('');
					$('#cicloActual').val('');
					$('#estatusCiclo').val('');
					$('#grupoID').focus();
					$('#grupoID').select();	

				}
			});
		}
	}
	// funcion Genera Reporte Acta Constitutiva

	function enviaDatosPerfilGrupo(tipoReporte){
		var grupo=$('#grupoID').val();
		var fechas=$('#fechaRegistro').val();
		var nivel=$('#cicloActual').val();
		var estatus=$('#estatusCiclo').val();
		
		var fechaCompleta =fechas.substring(0,11);
		if( $('#grupoID').val() == ''){
			alert('El Número del Grupo es requerido');
			$('#grupoID').focus();
			$('#grupoID').select();	
		}
	else{
		var pagina ='repPerfilGrupoPDF.htm?grupoID='+grupo+'&nombreGrupo='+$('#nombreGrupo').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&tipoReporte='+tipoReporte+
		'&fechaRegistro='+fechaCompleta+'&cicloActual='+nivel+'&estatusCiclo='+estatus+'&usuario='+$('#usuario').val()+'&fechaEmision='+$('#fechaEmision').val();
		window.open(pagina,'_blank');
	
		}
	}

});