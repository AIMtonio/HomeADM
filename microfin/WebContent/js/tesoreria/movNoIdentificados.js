$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();
	
	agregaFormatoControles('formaGenerica');
	
	
	
	$('#fechaMov').val(parametroBean.fechaSucursal);
	
	$('#fechaDescripcion').datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'yy-mm-dd' ,
		minDate: new Date(1900, 1 - 1, 1), 
		yearRange: '-100:+10'
	});
			
	$('#fechaDescripcion').datepicker($.datepicker.regional['es']);
	
	$('#fechaDescripcion').change(function() {
		$('#fechaDescripcion').focus();
	});
		
	var catTipoConsulta = {
	  		'institucion'	:2
	};
	
	var catTipoTransaccion = {
	  		'agrega' 	: 1,
	  		'modifica'	: 2
	};
	
	$('#grabar').click(function() {		 
		$('#tipoTransaccion').val(catTipoTransaccion.agrega);
	});
	
	
	$.validator.setDefaults({
		submitHandler: function(event) { 				
				grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'institucionID');
			}
	});
	
	
	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	
	$('#institucionID').blur(function() {
		if($('#institucionID').val() != ''  && esTab){
			consultaInstitucion(this.id);
		}
	});
	
	$('#cuentaAhoID').bind('keyup',function(e){
    	var camposLista = new Array();
		var parametrosLista = new Array();
			camposLista[0] = "institucionID";
            parametrosLista[0] = $('#institucionID').val();
                        
            camposLista[1] = "cuentaAhoID";			
            parametrosLista[1] = $('#cuentaAhoID').val();
                    
		lista('cuentaAhoID', '1', '4', camposLista, parametrosLista, 'tesoCargaMovLista.htm');	       
    });
	
	$('#cuentaAhoID').blur(function() {
		if($('#cuentaAhoID').val() != '' && !isNaN($('#cuentaAhoID').val()) && esTab){
			consultaCuentaAho();
		}
	});
		
	
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
			
		var InstitutoBeanCon = {
  				'institucionID':numInstituto
		};
	 
		if(numInstituto != '' && !isNaN(numInstituto) && esTab){
			institucionesServicio.consultaInstitucion(catTipoConsulta.institucion,InstitutoBeanCon,function(instituto){
					if(instituto!=null){							
						$('#nombreInstitucion').val(instituto.nombre);
					}else{
						alert("No existe la Institución"); 
					}    						
				});
			}
		}
	
	
	function consultaCuentaAho(){
		
		var tipoConsulta = 6;
		var DispersionBeanCta = {
			'institucionID': $('#institucionID').val(),
			'cuentaAhorro': $('#cuentaAhoID').val()
			};
		
		operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
			if(data!=null){				
				$('#cuentaAhoID').val(data.cuentaAhorro);
				$('#nombreSucurs').val(data.nombreCuentaInst);
				$('#numCtaInstit').val(data.numCtaInstit);
			}else{
				alert("No se encontro dato alguno....");
			}
		});			
	}
	
	
	// Agrega el grid para los movimientos
	$('#montoDescripcion').blur(function(){
		
		var descripcion = $('#desDescripcion').val();
		var referencia = $('#desReferencia').val();
		var fechaOperacion = $('#fechaDescripcion').val();
		var natMovimiento = $('#tipMov').val();
		var monto = $('#montoDescripcion').val();
		
		if(descripcion != '' && fechaOperacion != '' && natMovimiento != '' && monto != ''){
			
			var nuevaFila = $('#numeracion').asNumber() + 1;
			
			var naturalez = ""; 
			
			if(natMovimiento == 'A'){
				naturalez = "Abono";
			}else if(natMovimiento == 'C'){
				naturalez = "Cargo";
			}
			
			var tds = '<tr id="filaNum'+nuevaFila+'">';
					tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" class="cajatexto" value="'+nuevaFila+'" size="5" readonly="true" /></td>';
					tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="descripcion" class="cajatexto" value="'+descripcion+'" size="40" /></td>';
					tds += '<td><input type="text" id="referencia'+nuevaFila+'" name="referencia" class="cajatexto" value="'+referencia+'" size="10" /></td>';
					tds += '<td><input type="text" id="natMov'+nuevaFila+'" name="natMov'+nuevaFila+'" class="cajatexto" value="'+naturalez+'" size="7"/>';
					tds += '	<input type="hidden" id="natMovimiento'+nuevaFila+'" name="natMovimiento" class="cajatexto" value="'+natMovimiento+'" size="20" /></td>';
					tds += '<td width="10%">&nbsp;</td>';
					tds += '<td><input type="text" id="fechaOperacion'+nuevaFila+'" name="fechaOperacion" class="cajatexto" value="'+fechaOperacion+'" size="15"/></td>';
					tds += '<td width="10%">&nbsp;</td>';
					tds += '<td><input type="text" id="monto'+nuevaFila+'" name="monto" class="cajatexto" value="'+monto+'" esMoneda="true" /></td>';
				tds += '</tr>';
				
			
			$('#desDescripcion').val("");
			$('#desReferencia').val("");
			$('#fechaDescripcion').val("");
			$('#montoDescripcion').val("");
				
			$("#detalleOperacion").append(tds);
			$('#numeracion').val(nuevaFila);
			$('#desDescripcion').focus();
		}
		
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			institucionID:	'required',
			cuentaAhoID:	'required',
			fechaMov:		'required'			
		},
		
		messages: {
			institucionID:	'Campo Requerido',
			cuentaAhoID:	'Campo Requerido',
			fechaMov:		'Campo Requerido'
		}
	});
	
	
});