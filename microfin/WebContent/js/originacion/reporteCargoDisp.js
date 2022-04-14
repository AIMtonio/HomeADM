esTab = true;       
//Definicion de Constantes y Enums
var Enum_TipoConsulta = { 
	'principal':1,
	'foranea':2
};

var catTipoReporte ={
		'PDF':1,
		'Excel':2
};

var Enum_Constantes ={
	'SI' : 'S',
	'NO' : 'N'	
};
$(document).ready(function() {
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('eliminar', 'submit');
	
	var parametroBean = consultaParametrosSession();  

	$('#institucionID').focus();
	$('#institucionID').val('0');
	$('#nombInstitucion').val('TODAS');
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFinal').val(parametroBean.fechaSucursal);

	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});				
	
	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	
	$('#institucionID').blur(function() {	 
		consultaInstitucion(this.id);
	});

	$('#generar').click(function() { 
		generaReporte();
	});

	$('#fechaInicio').change(function() {
		var fechaInicial= $('#fechaInicio').val().trim();
		if(esFechaValida(fechaInicial)){
			if(fechaInicial==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var fechaFinal= $('#fechaFinal').val().trim();
			if (fechaInicial > fechaFinal){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFinal').change(function() {
		var fechaInicial= $('#fechaInicio').val().trim();
		var fechaFinal= $('#fechaFinal').val().trim();
		if(esFechaValida(fechaFinal)){
			if(fechaFinal==''){
				$('#fechaFinal').val(parametroBean.fechaSucursal);
			}
			if (fechaInicial > fechaFinal){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFinal').val(parametroBean.fechaSucursal);
				$('#fechaFinal').focus();
			}
			if (fechaFinal > parametroBean.fechaSucursal){
				mensajeSis("La Fecha de Final es mayor a la Fecha del Sistema.")	;
				$('#fechaFinal').val(parametroBean.fechaSucursal);
				$('#fechaFinal').focus();
			}
		}else{
			$('#fechaFinal').val(parametroBean.fechaSucursal);
		}
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			institucionID : 'required',
		},
		
		messages: {
			institucionID : 'Especifíque la Institución.',
		}
	});
	
}); // fin function principal
/**
 * Consulta el nombre de la institucion.
 * @param idControl : ID del input de la institucion.
 * @author avelasco
 */
function consultaInstitucion(idControl){
	var jqInst = eval("'#" + idControl + "'");
	var jqDesc = '#nombInstitucion';
	var producCreditoID = $('#productoCreditoID').asNumber();
	var numInstituto = $(jqInst).val();
	var InstitutoBeanCon = {
			'institucionID':numInstituto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (Number(numInstituto) != 0 && esTab) {
		institucionesServicio.consultaInstitucion(Enum_TipoConsulta.principal, InstitutoBeanCon, function(instituto) {
			if (instituto != null) {
				$(jqDesc).val(instituto.nombre);
			} else {
				mensajeSis("No Existe la Institución.");
				$(jqInst).val('');
				$(jqDesc).val('');
				$(jqInst).focus();
			}
		});
	} else {
		$('#institucionID').val('0');
		$('#nombInstitucion').val('TODAS');
	}
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

function comprobarSiBisisesto(anio){
	if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	}
	else {
		return false;
	}
}

function generaReporte() {
	var ligaGenerar			= '';
	var tipoReporte			= $('input:radio[name=tipoReporte]:checked').val();
	var fechaSistema		= parametroBean.fechaSucursal;
	var usuario				= parametroBean.claveUsuario;
    var nombreInstitucion	= parametroBean.nombreInstitucion; 
    var institucionID		= $('#institucionID').val();
    var nombInstitucion		= $('#nombInstitucion').val();
    var fechaInicio			= $('#fechaInicio').val();
    var fechaFinal			= $('#fechaFinal').val();

	ligaGenerar = 'cargoDispReporteVista.htm?' + 
		'&fechaSistema=' 		+ fechaSistema +
		'&usuario=' 			+ usuario.toUpperCase() +
		'&nombreInstitucion='	+ nombreInstitucion.toUpperCase() +
		'&institucionID='		+ institucionID +
		'&nombInstitucion='		+ nombInstitucion +
		'&fechaInicio='			+ fechaInicio +
		'&fechaFinal='			+ fechaFinal +
		'&tipoReporte=' 		+ tipoReporte;

	window.open(ligaGenerar, '_blank');
}