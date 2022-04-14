var tipoReporte="";
$(document).ready(function() {	

	var catTipoConsulta = {
			'principal'	: 1		  		
	};

	var catTipoListaSucursal = {
			'combo': 2
	};

	var parametros = consultaParametrosSession();
	$('#usuario').val(parametros.claveUsuario); // parametros del sesion para el reporte
	$('#nombreInstitucion').val(parametros.nombreInstitucion);
	$('#fechaSistema').val(parametroBean.fechaSucursal);

	// ----------------------------------- Metodos y Eventos -----------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaControl('promotorActual');
	deshabilitaControl('nombrePromotor');
	cargaSucursales();
	inicializaCampos()

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

	$('#promotorActual').bind('keyup',function(e) { 
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorInicial').val();
		parametrosLista[1] = $('#sucursalID').val();  
		lista('promotorActual', '1', '2',camposLista, parametrosLista, 'listaPromotores.htm');
	});

	$('#promotorActual').blur(function() {		
		consultaPromotorA(this.id);
	});

	$('#pdf').click(function() {	
		$('#excel').attr("checked",false);
	});
	$('#excel').click(function() {	
		$('#pdf').attr("checked",false);
	});
	$('#generar').click(function(){		
		enviaDatosReporte(); 

	});
	$('#sucursalID').change(function(){
		if($('#sucursalID').val()==0){
			$('#promotorActual').val(0);
			$('#nombrePromotor').val("TODOS");
			deshabilitaControl('promotorActual');
			deshabilitaControl('nombrePromotor');
		}else{
			habilitaControl('promotorActual');
			habilitaControl('nombrePromotor');
		}
	});
	$('#formaGenerica').validate({
		rules : {

		},
		messages : {

		}
	});

	function consultaPromotorA(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {

					if(promotor.estatus != 'A'){
						alert("El promotor debe de estar Activo");
						$(jqPromotor).val("0");
						$('#nombrePromotor').val("TODOS");
						$(jqPromotor).focus();
					}else{
						parametroBean = consultaParametrosSession();
						if($('#sucursalID').val() != promotor.sucursalID){
							alert("El promotor debe de pertenecer ala sucursal: "+parametroBean.nombreSucursal);
							$(jqPromotor).val("0");
							$(jqPromotor).focus();
							$('#nombrePromotor').val("TODOS");
							inicializaCampos();
						}else{
							$('#nombrePromotor').val(promotor.nombrePromotor);
						}
					}
				} else {
					alert("No Existe el Promotor");
				}
			});
		}
	}

	function cargaSucursales(){
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'TODAS'});
		sucursalesServicio.listaCombo(catTipoListaSucursal.combo, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	function enviaDatosReporte(){
		var sucursalID = $("#sucursalID option:selected").val();
		var nombreSucursal	= $("#sucursalID option:selected").val();
		var estatusCta  =$('#estatusCta').val();
		var promotorActual =$('#promotorActual').val();
		var nombrePromotor =$('#nombrePromotor').val();

		if($('#excel').is(':checked')){
			tipoReporte = "2";

		}
		if($('#pdf').is(':checked')){
			tipoReporte = "1";
		}

		if(nombreSucursal=='0'){
			nombreSucursal='TODOS';
		}
		else{
			nombreSucursal = $("#sucursalID option:selected").html();
		}
		if(promotorActual==""){
			alert("El Promotor está vacio");
			$('#promotorActual').val(0);
			$('#nombrePromotor').val("TODOS");
			$('#promotorActual').focus();
			$('#promotorActual').select();
		}else{
			if($('#excel').attr("checked")==false && $('#pdf').attr("checked")==false){
				alert("No ha seleccionado Ninguna Opción Para la Presentación del Reporte");
			}else{
				var pagina ='repFClientesMenoresPDF.htm?sucursalID='+sucursalID+'&nombreSucurs='+
				nombreSucursal+'&estatusCta='+estatusCta
				+'&promotorActual='+promotorActual+'&nombrePromotor='+nombrePromotor
				+'&tipoReporte='+tipoReporte+'&nombreInstitucion='+$('#nombreInstitucion').val()
				+'&usuario='+$('#usuario').val()+'&fechaSistema='+$('#fechaSistema').val();
				window.open(pagina,'_blank');
			}
		}
	}

	function inicializaCampos(){
		$('#promotorActual').val(0);
		$('#nombrePromotor').val("TODOS");
	}

});