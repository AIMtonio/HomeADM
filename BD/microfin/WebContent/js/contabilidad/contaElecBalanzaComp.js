$(document).ready(function() {
	esTab = true;
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	llenaComboAnios(parametroBean.fechaAplicacion);
	var ejecucionBalanzaContable = 'N';
	var userEjecucionBalanzaContable = '';
	var Var_Usuario =parametroBean.nombreUsuario;


	$(':text').focus(function() {
		esTab = false;
	});

	var generaTipoXml = {
		'balanza' : 2
	};

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','consecutivo');
		}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	// ------------ Metodos y Manejo de Eventos

	$('#generar').click(function() {
		validaEjecucionBalanzaContable();

		if( ejecucionBalanzaContable != 'N'){
			var mensaje = "Existe una Ejecución de la Balanza Contable en el Sistema, la cual fue solicitada por el usuario: "+ userEjecucionBalanzaContable+". Favor de Intentar mas Tarde.";
			if(userEjecucionBalanzaContable == ''){
				mensaje = "Existe una Ejecución de la Balanza Contable en el Sistema. Favor de Intentar mas Tarde.";
			}
			mensajeSis(mensaje);
			return ;
		}

		var conEstatus=4;

		var fecha=$('#anio').val()+'-'+($('#mes').length>1?$('#mes').val():'0'+$('#mes').val())+'-01';
		var periodoBean = {
			'fecha':fecha
		};

		periodoContableServicio.consulta(conEstatus,periodoBean,function(periodo){
			if(periodo!=null){
				if(periodo.status=='C'){
					generarXml();
				}
				else{
					mensajeSis('El Periodo Debe Estar Cerrado.');
				}
			}
			else{
				mensajeSis('No Existe El Periodo.');
			}
		});
	});



	$('#mes').blur(function (){
		var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		var anioActual = parametroBean.fechaAplicacion.substring(0, 4);
		var anioSeleccionado = $('#anio').val();

		if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			$("#mes option[value="+ mesSistema +"]").attr("selected",true);
			this.focus();
		}
	});

	$('#mes').change(function (){
		var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		var anioActual = parametroBean.fechaAplicacion.substring(0, 4);
		var anioSeleccionado = $('#anio').val();

		if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			$("#mes option[value="+ mesSistema +"]").attr("selected",true);
			this.focus();
		}
	});

	$('#anio').change(function (){
		var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		var anioActual = parametroBean.fechaAplicacion.substring(0, 4);
		var anioSeleccionado = $('#anio').val();
		var mesSeleccionado = $('#mes').val();

		if((parseInt(mesSeleccionado) > parseInt(mesSistema)) ){
			mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			$("#mes option[value="+ mesSistema +"]").attr("selected",true);
			this.focus();
		}
		else{

			if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
				mensajeSis("El Año Indicado es Incorrecto.");
				$("#mes option[value="+ mesSistema +"]").attr("selected",true);
				this.focus();
			}
		}
	});

	$('#anio').blur(function (){
		var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		var anioActual = parametroBean.fechaAplicacion.substring(0, 4);
		var anioSeleccionado = $('#anio').val();
		var mesSeleccionado = $('#mes').val();

		if((parseInt(mesSeleccionado) > parseInt(mesSistema)) ){
			mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			$("#mes option[value="+ mesSistema +"]").attr("selected",true);
			this.focus();
		}
		else{

			if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
				mensajeSis("El Año Indicado es Incorrecto.");
				$("#mes option[value="+ mesSistema +"]").attr("selected",true);
				this.focus();
			}
		}
	});

	// Validaciones de la forma
	$('#formaGenerica').validate({

		rules: {
			anio: 'required',
			mes: 'required',
		},
		messages: {
			anio: 'Especifique Año',
			mes: 'Especifique Mes',
		}
	});

	// ------------ Validaciones de Controles-------------------------------------


	function llenaComboAnios(fechaActual){
		var anioActual = fechaActual.substring(0, 4);
		var mesActual = parseInt(fechaActual.substring(5, 7));
		var numOption = 2;

		for(var i=0; i<numOption; i++){
			$("#anio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
			anioActual = parseInt(anioActual) - 1;
		}

		$("#mes option[value="+ mesActual +"]").attr("selected",true);
	}

	function generarXml(){
		var nombreUsuario=Var_Usuario;
		var pagina='generarXmlContaElectro.htm?anio='+$('#anio').val()+'&mes='+$('#mes').val() +'&generaTipoXml='+generaTipoXml.balanza +'&nombreUsuario='+nombreUsuario;
		window.location=pagina;
	}

	function validaEjecucionBalanzaContable(){
		paramGeneralesServicio.consulta(53,{},{async: false, callback:function(parametro) {
			if (parametro != null) {
				ejecucionBalanzaContable = parametro.valorParametro;
				if( ejecucionBalanzaContable == 'S' ){
					consultaUsuarioBalanza();
				}
			} else {
				ejecucionBalanzaContable = 'N';
				mensajeSis('Ha ocurrido un error al consultar Si existe una ejecución de Balanza Contable en el Sistema.');
			}
		}});
	}

	function consultaUsuarioBalanza(){
		paramGeneralesServicio.consulta(54,{},{async: false, callback:function(parametro) {
			if (parametro != null) {
				userEjecucionBalanzaContable = parametro.valorParametro;
			} else {
				userEjecucionBalanzaContable = '';
				mensajeSis('Ha ocurrido un error al consultar el Usuario que ejecuto la Balanza Contable en el Sistema.');
			}
		}});
	}

});