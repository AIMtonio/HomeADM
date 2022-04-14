$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	$('#sumarizado').attr("checked",true) ; 
	$('#excel').attr("checked",true) ; 
	$('#fecha').val(parametros.fechaAplicacion); 
	$('#tipoRep').val(1);
	$('#formaRep').val(1);
	// Definicion de Constantes y Enums

	var catTipoConsultaInstituciones = {
			'principal':1, 
			'foranea':2
		};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {
		esTab = false;
	});
	
	$.validator.setDefaults({
		submitHaandler: function(event) { 

		}
	});		
	
	$('#fecha').change(function() {
		var Xfecha= $('#fecha').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fecha').val(parametros.fechaAplicacion);
			}
				if($('#fecha').val() > parametroBean.fechaSucursal) {
					alert("La Fecha no puede ser mayor a la Fecha del Sistema.");
					$('#fecha').val(parametros.fechaAplicacion);
					}
				}else{
			$('#fecha').val(parametros.fechaAplicacion);
			
		}
		regresarFoco('fechaInicial');
	});
	
	
	$('#excel').click(function() {
		if($('#sumarizado').is(":checked") ){
			$('#tipoRep').val(1);
		}
	});
	
	$('#sumarizado').click(function() {
		if($('#sumarizado').is(":checked") ){
			$('#formaRep').val(1);
		}
	});
	
	$('#detallado').click(function() {
		if($('#detallado').is(":checked") ){
			$('#formaRep').val(2);	
		}
	});
	
	$('#generar').click(function() { 
		if($('#institucionID').val() == ''){
			$('#ligaGenerar').removeAttr("href"); 
			alert('Especifique Institución');
			$('#institucionID').focus();
			}
		else if($('#cuentaBancaria').val() == ''){
			$('#ligaGenerar').removeAttr("href"); 
			alert('Especifique Cuenta Bancaria');
			$('#cuentaBancaria').focus();
			}
		else{
			generaExcel();
		}

	});


	
	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '2', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	

	  $('#institucionID').blur(function() {
		  if(isNaN($('#institucionID').val()) ){
				$('#institucionID').val("");
				$('#desnombreInstitucion').val("");
				$('#cuentaBancaria').val("");
				$('#nombreSucurs').val("");
				$('#institucionID').focus();
				
				
			}else{
				consultaInstitucion(this.id);  
				$('#cuentaBancaria').val("");
				$('#nombreSucurs').val("");
			}
	   	
	   	
	  });
	
	$('#cuentaBancaria').bind('keyup',function(e){
	    	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "institucionID";
			parametrosLista[0] = $('#institucionID').val();
			lista('cuentaBancaria', '2', '3', camposLista,parametrosLista, 'ctaNostroLista.htm');	  
			
	});	


	$('#cuentaBancaria').blur(function() {
		if(isNaN($('#cuentaBancaria').val()) ){
			$('#cuentaBancaria').val("");
			$('#nombreSucurs').val("");
			$('#cuentaBancaria').focus();
	
			
		}else{
		validaCuentaAhorro(this.id);	 			 
		}
	});
	
//	------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({	
		rules: {
			fecha: {
				date: true
			},
			institucionID: {
				required: true,				
			},
			cuentaBancaria: {
				required: true,				
			},
			
		},		
		messages: {
			fecha: {
				date: 'Formato de Fecha Incorrecto'
			},
			institucionID: {
				required:'Especifique Institución'				
			},
			cuentaBancaria: {
				required:'Especifique Cuenta Bancaria'
			}
		}		
	});
	

	function generaExcel(){	
	
		var fechaReporte 	= $('#fecha').val();	 			
		var institucionID 	= $('#institucionID').val();
		var numCtaInstit 	= $('#cuentaBancaria').val();
		var tipoRep       	= $('#tipoRep').val();
		var formaRep        = $('#formaRep').val();
		
		var usuario 	  = parametroBean.claveUsuario;
		var nombreUsuario = parametroBean.claveUsuario; 			
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var fechaEmision	  =  parametroBean.fechaSucursal;
		var hora='';
		var horaEmision= new Date();
		hora = horaEmision.getHours();
		hora = hora+':'+horaEmision.getMinutes();
		hora = hora+':'+horaEmision.getSeconds();

		
		var paginaReporte= 'SaldoBancosCCRep.htm?fecha='+fechaReporte+'&institucionID='+institucionID+'&numCtaInstit='+numCtaInstit+
		'&tipoRep='+tipoRep+'&usuario='+usuario+'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+
		'&fechaEmision='+fechaEmision+'&horaEmision='+hora+'&tipoLista=1'+'&formaRep='+formaRep;			
		$('#ligaGenerar').attr('href',paginaReporte);
	
}


//	FIN VALIDACIONES DE REPORTES


	
	   //Funcion de consulta para obtener el nombre de la institucion	
	function consultaInstitucion(idControl) {

		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		
		if(numInstituto!=''){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){		
					if(instituto!=null){
						$('#desnombreInstitucion').val(instituto.nombre);
					}else{						
						alert("No existe la Institución");
						$('#institucionID').val('');
						$('#desnombreInstitucion').val('');
						$('#institucionID').focus();
						$('#cuentaBancaria').val("");
						$('#nombreSucurs').val("");
					}    						
				});
		}else{
			$('#institucionID').val('');
			$('#desnombreInstitucion').val('');
			
		
		}
	}	
	
	// funcion para validar cuenta de ahorro
	function validaCuentaAhorro(idControl){
		institID = $('#institucionID').val(),
		CtaInstit = $('#cuentaBancaria').val()
		
    	var tipoConsulta = 9;
		var ValidaCuentaBean = {
			'institucionID': institID,
			'numCtaInstit': CtaInstit
			};
		
		if(CtaInstit!=''){
		operDispersionServicio.consulta(tipoConsulta, ValidaCuentaBean, function(data){
					if(data!=null){
						$('#cuentaBancaria').val(data.numCtaInstit);
					    $('#nombreSucurs').val(data.nombreCuentaInst);	   
					   habilitaBoton('generar', 'submit');
					}
						else{
							alert("La Cuenta Bancaria no Existe");
							$('#cuentaBancaria').val("");
							$('#nombreSucurs').val("");
							$('#cuentaBancaria').focus();
						
					}
				});
		
	}else{
		$('#cuentaBancaria').val('');
		$('#nombreSucurs').val('');
	
	
	}
}	
	
	
	
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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
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
			$(jqControl).focus().select();
			$(jqControl).val(parametros.fechaAplicacion);
			
		 },0);
	}
	
	

}); // Fin Document

