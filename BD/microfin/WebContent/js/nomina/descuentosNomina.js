$(document).ready(function() {
	// Definicion de Constantes y Enums	
	var parametroBean = consultaParametrosSession(); 
    var catTipoRepDescuentoNomina = { 
			'Excel'		: 1
	};
    var catTipoConsultaInstitucion = {
    		'institucion': 2
 
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');  
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$('#consultar').click(function() { 
		generaExcel();

	});
	deshabilitaBoton('consultar','submit');
	$('#institNominaID').focus();

	//------------ Validaciones de la Forma -------------------------------------s
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#exel').attr("checked",true);
  	$.validator.setDefaults({
        submitHandler: function(event) { 
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 
        			'mensaje','true','consultar','funcionExitoConsulta',
        			'funcionFalloConsulta','institNominaID');
        	}
  	});
  	$('#institNominaID').bind('keyup',function(e){
		lista('institNominaID', '1', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});
  	$('#fechaInicio').val(parametroBean.fechaAplicacion);
  	
  	$('#institNominaID').blur(function() {
  		consultaInstitucion(this.id);
	});
  	
	function consultaInstitucion(idControl) {
		var jqNombreInst = eval("'#" + idControl + "'");
		var nombreInsti = $(jqNombreInst).val();
		var institucionBean = {
				'institNominaID': nombreInsti				
		};	
		if(nombreInsti != '' && !isNaN(nombreInsti) && esTab){
		bitacoraPagoNominaServicio.consulta(catTipoConsultaInstitucion.institucion,institucionBean,function(institNomina) {
			if(institNomina!= null){
				$('#nombreEmpresa').val(institNomina.nombreInstit);
				$('#institNominaID').val(institNomina.institNominaID);
				habilitaBoton('consultar','submit');
				}
			else {
				alert("El Número de Empresa no Existe");
				$('#institNominaID').focus();
			}
			});
		}else{ if( $('#institNominaID') == '' ){
			deshabilitaBoton('consultar','submit');
		}
		}
		
	}
	//------------ Validaciones de Controles -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			institNominaID :{
				required: true,
				number: true
			}			
		},
		
		messages: {
			institNominaID :{
				required: 'Especifique la Empresa de Nómina.',
				number: 'Solo Números.'
			}
		}
	});


	// Genera el Reporte en Excel de Descuentos de Nomina
	function generaExcel() {
	
			var tr= catTipoRepDescuentoNomina.Excel; 
		    var fechaEmision = parametroBean.fechaAplicacion;
			var nombreUsuario=parametroBean.claveUsuario;
			var nombreInstitucion=parametroBean.nombreInstitucion;
		    /// Valores Texto	
		
			var institucionNominaID =   $('#institNominaID').val();
			if(  institucionNominaID != '' && !isNaN(institucionNominaID)){
				var pagina='reportDesNomina.htm?tipoLista='+tr+'&institNominaID='
					+institucionNominaID+'&fechaEmision='+fechaEmision +'&usuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion;
					window.open(pagina,'_blank');
			}
	}
	});

	function habilitaConsulta(){
		habilitaBoton('consultar','submit');
	}



	
