var esTab = false;
var parametrosBean = consultaParametrosSession();

$(document).ready(function() {
	agregaFormatoControles('formaGenerica');
	inicializarPantalla();
	consultaSucursal();
	consultaProductosCredito();
	consultaServiciosAdicionalesCredito();
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
			estadoCredito : {
				required : true
			},
			
		},
		messages : {
			estadoCredito : {
				required : 'El Estaus es requerido.',
			},
			
		}
	});
	

	
	
	$('#generar').click(function() {
		generaExcel();
	});
	
});

function inicializarPantalla() {

	$("#sucursalID").focus();
	$("#estadoCredito").val("");
	$('#estadoCredito').change();
	
	
}

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
function consultaServiciosAdicionalesCredito() {			
	dwr.util.removeAllOptions('servicioID'); 		
	dwr.util.addOptions('servicioID', {0:'TODOS'});						     
	serviciosAdicionalesServicio.listaCombo(1, function(servicio){
	dwr.util.addOptions('servicioID', servicio, 'servicioID', 'descripcion');
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
	var estadoCredito =$('#estadoCredito').val();
	var productoCredito = $("#producCreditoID option:selected").val();
	var nombreSucursal = $("#sucursalID option:selected").val();
	var serviciosId = $("#servicioID option:selected").val();;
	var tipo_reporte = 1;
	var tipo_consulta = 19;
	var valor=$("#estadoCredito").val();	
		
		if (valor[0] == ""){
			estadoCredito="";	
		}
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


	$('#ligaGenerar').attr('href','ReporteServiciosAdicionales.htm?'+
			
			'&tipoReporte='+tipo_reporte+
			'&tipoLista='+tipo_consulta+
			'&sucursalID='+sucursalID+
			'&productoCreditoID='+producCreditoID+
			
			'&productoCreDescri='+productoCredito+
			'&InstitNominaID='+institucionNominaID+
			'&nombreInstit='+nombreInstitucion+
			'&convenioNominaID='+convenioNominaID+
			'&desConvenio='+nombreconvenioNomina+
			'&nombreSucursal='+nombreSucursal+
			'&estadoCredito='+estadoCredito+
			'&serviciosId='+serviciosId

	);
}

