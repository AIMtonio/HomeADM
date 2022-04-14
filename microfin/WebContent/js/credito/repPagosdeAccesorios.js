var esTab = false;
var parametrosBean = consultaParametrosSession();

$(document).ready(function() {
	agregaFormatoControles('formaGenerica');
	inicializarPantalla();
	consultaSucursal();
	consultaProductosCredito();
	ocultarEmpresaConvenio();

	

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	$.validator.setDefaults({
		submitHandler : function(event) {
			generaExcel();
		}
	});
	$('#formaGenerica').validate({
		rules : {
			fechaInicio : {
				required : true
			},
			fechaVencimien : {
				required : true
			}
		},
		messages : {
			fechaInicio : {
				required : 'La Fecha Inicio es requerida.',
			},
			fechaVencimien: {
				required: 'La Fecha Final es requerida.'
			}
		}
	});
	

	
	
	$('#generar').click(function() {
		generaExcel();
	});
	
});

function inicializarPantalla() {

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimien').val(parametroBean.fechaSucursal);
	$("#fechaInicio").focus();
	
}
$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimien').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaVencimien').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimien').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimien').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimien').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaVencimien').val(parametroBean.fechaSucursal);
		}

	});
//Lista las Instituciones de Nómina
$('#institNominaID').bind('keyup',function(e){
	lista('institNominaID', '1', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
});

$('#institNominaID').blur(function() {
	var institNominaID= $("#institNominaID").val();
	if(institNominaID==''){
		$("#institNominaID").val(0);
		$("#nombreinstitucionNomina").val("TODOS");
		
	}else{
		if(esTab){
			if($("#institNominaID").val()!="" && $("#institNominaID").val()!=0){
				consultaInstitucionNomina(this.id);
			}
			else{
				$("#institNominaID").val(0);
				$("#nombreinstitucionNomina").val("TODOS");
			}
		}
	}
	
});

$('#convenioNominaID').blur(function(event) {
	if(esTab){
		if($("#convenioNominaID").val()!="" && $("#convenioNominaID").val()!=0){
			consultaConvenioNomina();
		}
		else{
			$("#convenioNominaID").val(0);
			$("#desConvenio").val("TODOS");
		}
	}

});

function consultaSucursal() {
	var tipoCon = 2;
	dwr.util.removeAllOptions('sucursalID');
	dwr.util.addOptions('sucursalID', {
		'0' : 'TODAS'
	});
	sucursalesServicio.listaCombo(tipoCon, function(sucursales) {
		dwr.util.addOptions('sucursalID', sucursales, 'sucursalID',
				'nombreSucurs');
	});
}
function consultaConvenioNomina() {
	if (!isNaN($("#convenioNominaID").val())){ 
		var convenioBean = {
			'convenioNominaID': $("#convenioNominaID").val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		conveniosNominaServicio.consulta(1, convenioBean, function(resultado) {
			if(resultado != null) {
				$("#desConvenio").val(resultado.descripcion);
			}else{
				console.log(resultado);
				mensajeSis("El convenio no existe");
			}
		});
	}
}
function consultaProductosCredito() {			
	dwr.util.removeAllOptions('producCreditoID'); 		
	dwr.util.addOptions('producCreditoID', {0:'TODOS'});						     
	productosCreditoServicio.listaCombo(11, function(producto){
	dwr.util.addOptions('producCreditoID', producto, 'producCreditoID', 'descripcion');
	});
}

//Consulta de Institucion de Nomina
function consultaInstitucionNomina(idControl) {
	var jqNombreInst = eval("'#" + idControl + "'");
	var institucionID = $(jqNombreInst).val();	
	var tipoConsulta = 2 ;
	var institucionBean = {
			'institNominaID': institucionID				
	};	
	if(institucionID != '' && esTab){ 
		
	if(!isNaN(institucionID)) {
	institucionNominaServicio.consulta(tipoConsulta,institucionBean,function(institNomina) {
		if(institNomina!= null){
			$('#nombreinstitucionNomina').val(institNomina.nombreInstit);
			institNomID= $('#institNominaID').val();
			nombreInstitNom=institNomina.nombreInstit;
			habilitaBoton('imprimir', 'submit');
			}
		else {
			alert("El Número de Empresa No Existe");
			$('#institNominaID').focus();
			$('#nombreinstitucionNomina').val('');
			//deshabilitaBoton('imprimir', 'submit');
		}
		});
	 }
	else{
		alert('La Empresa de Nómina es Incorrecta.');
		//deshabilitaBoton('imprimir', 'submit');	
		$('#institNominaID').focus();
		$('#nombreinstitucionNomina').val('');
	}
 }else{
		alert('Especifique la Empresa de Nómina.');
		//deshabilitaBoton('imprimir', 'submit');	
		$('#institNominaID').focus();
		$('#nombreinstitucionNomina').val('');
	}
}

$('#convenioNominaID').bind('keyup', function(e) {
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = 'institNominaID';
	camposLista[1] = 'descripcion';
	parametrosLista[0] = $('#institNominaID').val();
	parametrosLista[1] = $('#convenioNominaID').val();
	if($('#institNominaID').asNumber()==0){
		lista('convenioNominaID', '2', 7, camposLista, parametrosLista, 'listaConveniosNomina.htm');
	}else{
		lista('convenioNominaID', '2', 1, camposLista, parametrosLista, 'listaConveniosNomina.htm');
	}
});

	//
	$('#producCreditoID').change(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		
		if($('#producCreditoID').val()!=null && $('#producCreditoID').val()!=""){
			if($('#producCreditoID').val()=='0'){
				$('#esNomina').val("N");
				ocultarEmpresaConvenio();
			}else{
				consultaProductoCreditoNomina($('#producCreditoID').val());	
			}
		}
	});
	
	function mostrarEmpresaConvenio(){
		$('.datosNomina').show();

		$('#institNominaID').val('0');
		$('#nombreinstitucionNomina').val('TODOS');
		
		
		$('#convenioNominaID').val('0');
		$('#desConvenio').val('TODOS');
	}
	function ocultarEmpresaConvenio(){
		
		$('#institNominaID').val('0');
		$('#nombreinstitucionNomina').val('');
		
		$('.datosNomina').hide();
		
		$('#convenioNominaID').val('0');
		$('#desConvenio').val('');		
	}
		function consultaProductoCreditoNomina(producCreditoID){
		var prodCreditoBeanCon = {
				'producCreditoID' : producCreditoID
		};
		productosCreditoServicio.consulta(1,prodCreditoBeanCon,function(resultado){
			if(resultado!=null){
				if(resultado.productoNomina=='S'){
					mostrarEmpresaConvenio();
					$('#esNomina').val(resultado.productoNomina);
				
				}else{
					ocultarEmpresaConvenio();
					$('#esNomina').val(resultado.productoNomina);
					
				}
			}else{
				$('#esNomina').val("N");
				
				mensajeSis('no se encontrò el producto');
				
			}
		});
	}

function generaExcel(){
	
	
	var fechaInicio = $('#fechaInicio').val();	 
	var fechaVencimien = $('#fechaVencimien').val();	
	var sucursalID = $("#sucursalID option:selected").val();
	var producCreditoID = $("#producCreditoID option:selected").val();
	var institucionNominaID=$('#institNominaID').val();
	var nombreInstitucion=$('#nombreinstitucionNomina').val();
	var convenioNominaID =$('#convenioNominaID').val();
	var nombreconvenioNomina =$('#desConvenio').val();

	var productoCredito = $("#producCreditoID option:selected").val();
	var nombreSucursal = $("#sucursalID option:selected").val();
	var tipo_reporte = 1;
	var tipo_consulta = 18;
	if(nombreSucursal=='0'){
		nombreSucursal='TODAS';
	}
	else{
		nombreSucursal = $("#sucursalID option:selected").html();
	}

	if(productoCredito=='0'){
		productoCredito='TODOS';
	}else{
		productoCredito = $("#producCreditoID option:selected").html();
	}

	if(institucionNominaID=='0' || institucionNominaID == ''){
		nombreInstitucion='TODAS';
	}
	else{
		nombreInstitucion = $('#nombreinstitucionNomina').val();
	}

	if(convenioNominaID=='0' || convenioNominaID==''){
		nombreconvenioNomina='TODOS';
	}
	else{
		nombreconvenioNomina = $('#desConvenio').val();
	}


	$('#ligaGenerar').attr('href','ReportePagosAccesorios.htm?'+
			
			'&tipoReporte='+tipo_reporte+
			'&tipoLista='+tipo_consulta+
			'&fechaInicio='+fechaInicio+
			'&fechaVencimien='+fechaVencimien+
			'&sucursal='+sucursalID+
			'&producCreditoID='+producCreditoID+
			
			'&nombreProducto='+productoCredito+
			'&institucionNominaID='+institucionNominaID+
			'&nombreInstitucion='+nombreInstitucion+
			'&convenioNominaID='+convenioNominaID+
			'&desConvenio='+nombreconvenioNomina+

			'&productoCredito='+productoCredito+
			'&nombreSucursal='+nombreSucursal

	);
}

/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
				break;
			default:
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}


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