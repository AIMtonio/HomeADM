$(document).ready(function() {
	esTab = true;

	// Definicion de Constantes y Enums	
	var parametroBean = consultaParametrosSession(); 
    
    var catTipoConsulBitacora = {  
    	'conBitacoraFallidos':'1'
	};
    var catTipoConsultaInstitucion = {
			'institucion': 2
 
	};
	var catTipoConsultaCorreo = {
			'correo': 1
	};
	var empID;

	$('#institNominaID').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('adjuntar', 'submit');
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('verBitacora', 'submit');
	deshabilitaBoton('ocultar', 'submit');
	deshabilitaBoton('consultar', 'submit');


	$.validator.setDefaults({
	      submitHandler: function(event) {
	    	  grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','institNominaID', 
	    			  'funcionExito','funcionError');
	      }
	});
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	
	$('#institNominaID').bind('keyup',function(e){
		lista('institNominaID', '1', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});
		
	$('#adjuntar').click(function() {
		if(empID== $('#institNominaID').val()){
		
			deshabilitaBoton('ocultar', 'submit');
			subirArchivosPagosNomina();
		}else{
		esTab= true;	
		consultaInstitucion('institNominaID');
		}
	});
	
	$('#verBitacora').click(function() {
		consultaGridPagosNomina();
		deshabilitaBoton('verBitacora', 'submit');
		habilitaBoton('ocultar', 'submit');

	});
	
	$('#ocultar').click(function() {
		ocultaGridPagosNomina();
		deshabilitaBoton('ocultar', 'submit');
		habilitaBoton('verBitacora', 'submit');

	});
	$('#consultar').click(function() {
		ejemploArchivo();
	});
	
	$('#institNominaID').blur(function() {
		consultaInstitucion(this.id);
		consultaCorreoInstitNomina(this.id);
	});
	
	$('#procesarArchivo').click(function() {
		alert('procesar');
	});
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha Inicial es mayor a la Fecha Final.")	;
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

	});
	
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


	// Consulta de Institucion de Nomina
	function consultaInstitucion(idControl) {
		var jqNombreInst = eval("'#" + idControl + "'");
		var nombreInsti = $(jqNombreInst).val();
		var institucionBean = {
				'institNominaID': nombreInsti				
		};	
		if(nombreInsti != '' && !isNaN(nombreInsti) && esTab){
		bitacoraPagoNominaServicio.consulta(catTipoConsultaInstitucion.institucion,institucionBean,function(institNomina) {
			if(institNomina!= null){
				$('#gridBitacoraCargaArchivo').html("");
				$('#gridBitacoraCargaArchivo').hide(500); 
				deshabilitaBoton('verBitacora', 'submit');
				deshabilitaBoton('ocultar', 'submit');
				
				$('#nombreEmpresa').val(institNomina.nombreInstit);
				$('#institNominaID').val(institNomina.institNominaID);
				habilitaBoton('adjuntar', 'submit');
				habilitaBoton('consultar', 'submit');
				empID=institNomina.institNominaID;
				}
			else {
				alert("El Número de Empresa no Existe");
				$('#institNominaID').focus();
				$('#institNominaID').val('');
				$('#nombreEmpresa').val('');
				deshabilitaBoton('verBitacora', 'submit');
				deshabilitaBoton('ocultar', 'submit');
				deshabilitaBoton('adjuntar', 'submit');
				deshabilitaBoton('consultar', 'submit');
				$('#gridBitacoraCargaArchivo').html("");
				$('#gridBitacoraCargaArchivo').hide(500); 
			}
			});
		}
		
	}
	
	// Consulta Correo Institucion de Nomina
	function consultaCorreoInstitNomina(idControl) {	
		var jqCorreoInst  = eval("'#" + idControl + "'");
		var nomCorreoInsti = $(jqCorreoInst).val();
		
		var correoInstitucionBean = {
				'institNominaID': nomCorreoInsti	
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		if(nomCorreoInsti != '' && !isNaN(nomCorreoInsti)&& esTab){
		pagoNominaServicio.consulta(catTipoConsultaCorreo.correo,correoInstitucionBean,
				function(correoInstitucion) {
			if(correoInstitucion!= null){
				$('#correoElectronico').val(correoInstitucion.correoElectronico);
				}
			else {
				$('#correoElectronico').val('');
			}
			});
		}
	}
	
	// Subir archivos de Pagos de Nomina
	function subirArchivosPagosNomina() {
		var institucion = $("#institNominaID").val();
		if(institucion == ''){
			alert("Especifique la Empresa de Nómina");
			$('#institNominaID').focus();
			$('#nombreEmpresa').val('');
			agregaFormatoControles('formaGenerica');
			deshabilitaBoton('verBitacora', 'submit');
			 event.preventDefault();
			 } 
		else if (isNaN(institucion)) {
		alert("Ingrese Sólo Números");
		$('#institNominaID').focus();
		$('#nombreEmpresa').val('');
		}
		else{
		
 		var url ="bitacoraPagoFileUpload.htm?institucionNomina="+$('#institNominaID').val();
 		var leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
 		var topPosition = (screen.height) ? (screen.height-500)/2 : 0;
 		ventanaArchivosPagosNomina = window.open(url,
 				"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no," +
 				"addressbar=0,menubar=0,toolbar=0"+
 				"left="+leftPosition+
 				",top="+topPosition+
 				",screenX="+leftPosition+
 				",screenY="+topPosition);
 		
 		$('#gridBitacoraCargaArchivo').html("");
		$('#gridBitacoraCargaArchivo').hide(500); 	
	}
	}
	
	// Consultar Errores de Pagos de Nomina
	function consultaGridPagosNomina(){
			var params = {};
			params['tipoLista'] = catTipoConsulBitacora.conBitacoraFallidos;
			params['folioCargaID'] =$('#folioCargaID').val();

			$.post("bitacoraArchivoPagoGrid.htm", params, function(data){		
				if(data.length >0) {
				
					$('#gridBitacoraCargaArchivo').html(data);
					$('#gridBitacoraCargaArchivo').show(500);
					
				}else{
					$('#gridBitacoraCargaArchivo').html("");
					$('#gridBitacoraCargaArchivo').show(500); 
				}
			});
		
	}

	function ocultaGridPagosNomina(){
			var params = {};
			params['tipoLista'] = catTipoConsulBitacora.conBitacoraFallidos;
			params['folioCargaID'] =$('#folioCargaID').val();

			$.post("bitacoraArchivoPagoGrid.htm", params, function(data){		
				if(data.length >0) {
				
					$('#gridBitacoraCargaArchivo').html(data);
					$('#gridBitacoraCargaArchivo').hide(500);
					
				}else{
					$('#gridBitacoraCargaArchivo').html("");
					$('#gridBitacoraCargaArchivo').hide(500); 
				}
			});
		
	}
 
});


function ejemploArchivo(){	
	var data;			       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Descripción:</legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Número de Empleado:</b></td><td id="contenidoAyuda" align="left"><b>Corresponde al Número de Empleado.</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Número de Crédito:</b></td><td id="contenidoAyuda" align="left"><b>Corresponde al Número de Crédito del Empleado.</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" align="left"><b>Monto a Pagar:</b></td><td id="contenidoAyuda" align="left"><b>Indica el Monto del Crédito a Pagar.</b></td>'+
				'</tr>'+
			'</table>'+
			'<br>'+
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Formato del Archivo Pagos de Crédito</legend>'+
			'<table border="1" id="tablaLista" width="100%">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Número de Empleado </b></td>'+ 
					'<td id="encabezadoAyuda"><b>Número de Crédito </b></td>'+ 
					'<td id="encabezadoAyuda"><b>Monto a Pagar </b></td>'+ 
				'</tr>'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda"><b>678865</b></td>'+ 
					'<td colspan="0" id="contenidoAyuda"><b>100023717</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>$ 12,550.50</b></td>'+
				'</tr>'+
			'</table>'+
			'</div></div>'+ 
			'</fieldset>'; 
	
	$('#ejemploArchivo').html(data); 
	$.blockUI({message: $('#ejemploArchivo'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '500px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}	

function habilitaBotones(){
	habilitaBoton('verBitacora', 'submit');
	
}