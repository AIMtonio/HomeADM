$(document).ready(function() {
	// Definicion de Constantes y Enums
	
	var parametroBean = consultaParametrosSession();
    var catTipoRepDescuentoNomina = { 
			'Excel'		: 2
	};
    var catTipoConsultaInstitucion = {
    		'institucion': 2
 
	};
    var catTipoConsultaEmpleados = {
    		'estatus':2 
    };
	//------------ Metodos y Manejo de Eventos -----------------------------------------
    deshabilitaBoton('consultar','submit');
	$('#ligaGenerar').removeAttr("href");
    agregaFormatoControles('formaGenerica');
	$('#nombreEmpresa').val("");
	$('#exel').attr("checked",true);
	$("#fechaInicio").val(parametroBean.fechaAplicacion);
	$('#clienteID').val('0');
	$('#nombreCompleto').val('TODOS');
	$("#fechaFin").val(parametroBean.fechaAplicacion);
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
			grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma',
					'mensaje', 'true', 'institNominaID','exitoRegistro','falloRegistro');
    	}
    });	
	
	$('#institNominaID').bind('keyup',function(e){
		lista('institNominaID', '1', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});
	
	$('#clienteID').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "institNominaID";
		camposLista[1] = "nombreCompleto";
		
		parametrosLista[0] = $('#institNominaID').val();
		parametrosLista[1] = $('#clienteID').val();		
		
		lista('clienteID', '2', '2', camposLista, parametrosLista, 'listaClientes.htm');

	});
	$('#clienteID').blur(function() {
		consultaEmpleado(this.id);
		
	});
	
	$('#consultar').click(function() {
		var fechaInicio = $("#fechaInicio").val();
		var fechaFin = $("#fechaFin").val();
		habilitaBoton('consultar','submit');
		var institNominaID= $("#institNominaID").val();
		if(  institNominaID=='')
		{
			alert("La Empresa de Nómina está Vacía.");
			$('#institNominaID').focus();
			
			deshabilitaBoton('consultar','submit');
		}
		else 
		{
				if( fechaInicio=='')
				{					
					alert("La Fecha Inicial Está Vacia.");
					$('#fechaInicio').focus();
					$('#ligaGenerar').removeAttr("href");
					deshabilitaBoton('consultar','submit');
				}
		
				else 
				{	 
					if( fechaFin== '')
						{
						alert("La Fecha Final Está Vacia.");
						$('#fechaFin').focus();
						$('#ligaGenerar').removeAttr("href");
						deshabilitaBoton('consultar','submit');
						}
					else
					{
					
						generaExcel();
					}				
				}
		}
	});
	
	//Obtiene y valida la fecha de inicio
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha Inicial es Mayor a la Fecha Final.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				

			}else{
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					alert("La Fecha Inicial es Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			
		}
		regresarFoco('fechaInicio');
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha Inicial es mayor a la Fecha Final.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					alert("La Fecha Final  es Mayor a la Fecha del Sistema.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}				
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
		regresarFoco('fechaFin');
	});
	

	
	$('#institNominaID').blur(function() {
		consultaInstitucion(this.id);
	});
	
	//------------ Validaciones de Controles -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			institNominaID : {
				required:true
			},
			fechaInicio :{
				required: true
			},
			fechaFin:{
				required: true
			}			
		},
		messages: {
			institNominaID :{
				required: 'Especifique la Empresa de Nómina.'
			},
			fechaInicio :{
				required: 'Especifique la Fecha Inicial.'
			},
			fechaFin :{
				required: 'Especifique la Fecha Final.'
			}
		}
		
		
		
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
				alert("La Empresa de Nómina no Existe.");
				$('#institNominaID').focus();
				$('#institNominaID').val('');
				$('#ligaGenerar').removeAttr("href");
				deshabilitaBoton('consultar','submit');
			}
			});
		}else{
			if( $('#institNominaID') == '' ){
			deshabilitaBoton('consultar','submit');
			}
		}
		
	}
	
	
	//Genera el Reporte en Excel de Descuentos de Nomina Declararlo en el XML repDescuentosNomina
	function generaExcel() {
			var tr= catTipoRepDescuentoNomina.Excel; 
		    var institNominaID = $('#institNominaID').val();
		    var fechaInicio=$('#fechaInicio').val();
		    var fechaFin=$('#fechaFin').val(); 
		    var clienteID=$('#clienteID').val(); 
		    var estatus	= $('#estatusEmp').val(); 
		    
			var nombreUsuario=parametroBean.claveUsuario;
			var nombreInstitucion=parametroBean.nombreInstitucion;
			var fechaEmision=parametroBean.fechaSucursal;
			var nombreInstitNomina =  $('#institNominaID').val() +" - "+ $('#nombreEmpresa').val();
			var nombreCompleto =$('#clienteID').val()+" - "+$('#nombreCompleto').val();
			if($('#clienteID').val() == ''){
				nombreCompleto = '0 - TODOS';
			}
			
			$('#ligaGenerar').attr('href','reporteCambioEstatus.htm?tipoLista='+tr
					+'&institNominaID='+institNominaID+'&fechaInicio='+fechaInicio+'&fechaFin='+fechaFin+
					'&clienteID='+clienteID+'&EstatusEmp='+estatus+'&nombreInstNomina='+nombreInstitNomina+'&nombreCompleto='+nombreCompleto+
					'&usuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaEmision='+fechaEmision);
			}
	
	  //	VALIDACIONES PARA LAS PANTALLAS DE REPORTE
	function mayor(fecha, fecha2){
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		} 
	}
   //	FIN VALIDACIONES DE REPORTES

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de Fecha no Válida (aaaa-mm-dd)");
				return false;
			}
			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29}else{ numDias=28};
				break;
			default:
				alert("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}

	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	function regresarFoco(idControl){
	
		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
		 },0);
	}
	function consultaEmpleado(idControl) {	
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var numInstitucion	 = $('#institNominaID').val();
	if(numCliente != '' && !isNaN(numCliente)){
		var empleadoNominaBean = {
				'institNominaID': numInstitucion,
				'clienteID': numCliente		
		};
	    if(numCliente=="0"){
	    	$('#clienteID').val('0');
	    	$('#nombreCompleto').val('TODOS');
	    }else{
			actualizaEstatusEmpServicio.consulta(catTipoConsultaEmpleados.estatus,empleadoNominaBean,function(empleadoNomina) {
				if(empleadoNomina != null){
					$('#nombreCompleto').val(empleadoNomina.nombreCompleto);
					habilitaBoton('imprimir', 'submit');
				}else{
					alert('El Empleado de Nómina no existe');
					$('#nombreCompleto').val('');
					$('#clienteID').val('');
					$('#clienteID').focus();
				  }
				});
	    }
		}else{
			$('#clienteID').val('0');
	    	$('#nombreCompleto').val('TODOS');
		}
	
	}
});

function generaReporte()
{
	
	generaExcel();
}
function habilitaConsulta(){
	habilitaBoton('consultar','submit');
	
}

