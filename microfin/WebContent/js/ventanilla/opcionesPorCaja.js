$(document).ready(function(){
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	var catTipoCategoriaTran ={
			'guardar'	: 1
		};

	deshabilitaBoton('guardar','submit');
	$('#tipoCaja').focus();
	//-----------------------Método valida y manejo de eventos-----------------------
	agregaFormatoControles('formaGenerica');
	
	$.validator.setDefaults({		
	    submitHandler: function(event) {  
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoCaja',
		    			'funcionExito','funcionFallo'); 
	    }
	 });
	
	$('#formaGenerica').validate({
		rules : {
			tipoCaja : {
				required : true
			}
		},
		messages : {
			tipoCaja : {
				required : 'Especifíque el Tipo de Caja'
			}
		},
	});
	
	$('#guardar').click(function(){		
		procesaFilas();
		$('#tipoTransaccion').val(catTipoCategoriaTran.guardar);		
	});
	
	$('#tipoCaja').change(function (){
		habilitaBotonGuardar();
		deselecccionaOpciones();
		deselecccionaOpcionesRev();
		checkeaOpcionesPorCaja();
		checkeaOpcionesPorCajaReversa();			
	});
		
	$('#seleccionaTodos').click(function(){
		checkedTodos(this.id);
	});
	
	consultaOpcionesPorCaja();	
	consultaOpcionesPorCajaReversa();
});			

function consultaOpcionesPorCaja() {		
	var tipoCajaSesion=parametroBean.tipoCaja;
	var numCon = 4;
	var opcionesCaja = {
			'tipoCaja'	:tipoCajaSesion
	};
	opcionesPorCajaServicio.listaCombo(numCon,opcionesCaja, function(opcionesporcaja) {		
		if (opcionesporcaja != null){				
		var tds = '';
		tds += '<table id="tablaOpcionesPorCaja" border="1" style="position:absolute;top:23px;left:45px;" >';
		tds += '<tr>';
		tds += '<td>';
		tds += '<label>Número </label>';
		tds += '</td>';		
		tds += '<td>';
		tds += '<label>Descripción </label>';
		tds += '</td>';		
		tds += '<td>';
		tds += '<label>Seleccionar</label>';
		tds += '</td>';
		tds += '<td>';
		tds += '</td>';
		tds += '</tr>';			
		for (var i=0; i< opcionesporcaja.length; i++) {
			tds +='<tr>';
			tds += '<td>';
			tds += '<input type="text" id="opcionCajaID'+(i+1)+'" value="'+opcionesporcaja[i].opcionCajaID+'" name="opcionCajaID" size="8" readonly="true"/>';
			tds += '</td>';			
			tds += '<td>';
			tds += '<input type="text" id="descripcion'+(i+1)+'" value="'+opcionesporcaja[i].descripcion+'" name="descripcion" size="50" readonly="true"/>';
			tds += '</td>';			
			tds += '<td align="center">';
			tds += '<input type="checkbox" id="aplicaOpcion'+(i+1)+'" name="aplicaOpcion" />';			
			tds += '</td>';			
			tds += '<td align="center">';					
		}
		tds += '</table>';
		$('#tablaOperaciones').html(tds);			
		}// diferente de null		
});	
}

function consultaOpcionesPorCajaReversa() {
	var tipoCajaSesion=parametroBean.tipoCaja;
	var numCon = 5;
	var opcionesCaja = {
			'tipoCaja'	:tipoCajaSesion
	};
	opcionesPorCajaServicio.listaCombo(numCon,opcionesCaja, function(opcionesporcaja) {		
		if (opcionesporcaja != null){				
		var tds = '';
		tds += '<table id="tablaOpcionesPorCaja" border="1" >';
		tds += '<tr>';
		tds += '<td>';
		tds += '<label>Número </label>';
		tds += '</td>';		
		tds += '<td>';
		tds += '<label>Descripción </label>';
		tds += '</td>';		
		tds += '<td>';
		tds += '<label>Seleccionar</label>';
		tds += '</td>';
		tds += '<td>';
		tds += '</td>';
		tds += '</tr>';			
		for (var i=0; i< opcionesporcaja.length; i++) {			
			tds +='<tr>';
			tds += '<td>';
			tds += '<input type="text" id="opcionCajaIDr'+(i+1)+'" value="'+opcionesporcaja[i].opcionCajaID+'" name="opcionCajaIDr" size="8" readonly="true"/>';
			tds += '</td>';			
			tds += '<td>';
			tds += '<input type="text" id="descripcionr'+(i+1)+'" value="'+opcionesporcaja[i].descripcion+'" name="descripcionr" size="50" readonly="true"/>';
			tds += '</td>';			
			tds += '<td align="center">';
			tds += '<input type="checkbox" id="aplicaOpcionr'+(i+1)+'" name="aplicaOpcionr" />';			
			tds += '</td>';			
			tds += '<td align="center">';		
		}					
		tds += '</table>';
		$('#tablaReversas').html(tds);			
		}// diferente de null 		
	});	
}

function checkeaOpcionesPorCaja() {
	var numCon = 1;
	var tipoCajaVal = $('#tipoCaja').val();
	var opcionesCaja = {
			'tipoCaja'	:tipoCajaVal
	};
	opcionesPorCajaServicio.listaCombo(numCon,opcionesCaja,{ async: false, callback: function(opciones) {	
		if (opciones != null && opciones != ''){
			
			 for(var j = 0;j < opciones.length;j++){ 		
				 $('input[name=aplicaOpcion]').each(function () {
					 var i = this.id.substring(12);	
					 var jqAplicaOpcion = eval("'#aplicaOpcion" + i + "'");
					 var jqOpcionCajaID = eval("'#opcionCajaID" + i + "'");				 
					 	if(opciones[j].opcionCajaID  == $(jqOpcionCajaID).val()){			  	  
					 		$(jqAplicaOpcion).attr('checked', 'true');	
					 	}			  
				});
			 }
			 checkeaSelecTodos();
			
		}else{
			 $('input[name=aplicaOpcion]').each(function () {						
			 $(this).removeAttr('checked');							
			 });						
		 }
	}
	 }); 
}

function checkeaOpcionesPorCajaReversa() {
	var tipoCajaVal= $('#tipoCaja').val();
	var numCon = 2;
	var opcionesCaja = {
			'tipoCaja'	:tipoCajaVal
	};
	opcionesPorCajaServicio.listaCombo(numCon,opcionesCaja, function(opcionesporcaja) {
		if (opcionesporcaja != null && opcionesporcaja != ''){
			 for(var j = 0;j < opcionesporcaja.length;j++){ 
				 $('input[name=aplicaOpcionr]').each(function () {
					 var i = this.id.substring(13);	
					 var jqAplicaOpcion = eval("'#aplicaOpcionr" + i + "'");
					 var jqOpcionCajaID = eval("'#opcionCajaIDr" + i + "'");				 
					 	if(opcionesporcaja[j].opcionCajaID  == $(jqOpcionCajaID).val()){			  	  
					 		$(jqAplicaOpcion).attr('checked', 'true');
					 	}				  
				});
			 }
			 checkeaSelecTodos();
		}
		 else{
			 $('input[name=aplicaOpcionr]').each(function () {						
			 $(this).removeAttr('checked');							
			 });					
		 }		
});	
}

//Concatena los registros seleccionados
function procesaFilas(){	
	$('#listaOpciones').val('');
	$('input[name=opcionCajaID]').each(function(){
	var i = this.id.substring(12);
  	var jqAplicaOpcion = eval("'#aplicaOpcion" + i + "'");
  	var jqOpcionCajaID = eval("'#opcionCajaID" + i + "'");
  	var cadena = $(jqOpcionCajaID).val();		  	
	  	if( $(jqAplicaOpcion).is(":checked") ){
	  		if($('#listaOpciones').val()==''){
	  			$('#listaOpciones').val(cadena);
	  		}else{
	  			$('#listaOpciones').val($('#listaOpciones').val() +","+ cadena);
	  		}	  		
	  	}else{
	  		
	  	}  	
	});
			
	$('input[name=opcionCajaIDr]').each(function(){
		var i = this.id.substring(13);
	  	var jqAplicaOpcion = eval("'#aplicaOpcionr" + i + "'");
	  	var jqOpcionCajaID = eval("'#opcionCajaIDr" + i + "'");
	  	var cadena = $(jqOpcionCajaID).val();			  	
		  	if( $(jqAplicaOpcion).is(":checked") ){
		  		if($('#listaOpciones').val()==''){
		  			$('#listaOpciones').val(cadena);
		  		}else{
		  			$('#listaOpciones').val($('#listaOpciones').val() +","+ cadena);
		  		}		  		
		  	}
	});	
}

//Selecciona todos los registros del grid
function checkedTodos(idControl){
	var jqSelec  = eval("'#" + idControl + "'");
	if ($(jqSelec).is(':checked') == true){
		$('input[name=aplicaOpcion]').each(function () {
			$(this).attr('checked', 'true');
		});
		$('input[name=aplicaOpcionr]').each(function () {
			$(this).attr('checked', 'true');
		});
	}else {
		$('input[name=aplicaOpcion]').each(function () {
			$(this).removeAttr('checked');
		});
		$('input[name=aplicaOpcionr]').each(function () {
			$(this).removeAttr('checked');
		});
	}
}

function deselecccionaOpciones(){
	$('input[name=aplicaOpcion]').each(function () {
		$(this).removeAttr('checked');
	});
}

function deselecccionaOpcionesRev(){
	$('input[name=aplicaOpcionr]').each(function () {
		$(this).removeAttr('checked');
	});
}

function deselecccionaTodos(){
	$('input[name=seleccionaTodos]').each(function () {
		$(this).removeAttr('checked');
	});
}

function habilitaBotonGuardar(){	
	if($('#tipoCaja').val() == ''){		
		deshabilitaBoton('guardar','submit');
	}else{	
		habilitaBoton('guardar','submit');
	}	
}
// Ckeckea la opcion Selecciona todos si todos estan seleccionados
function checkeaSelecTodos(){	
	var Selecciona ='S';
	$('input[name=aplicaOpcion]').each(function () {	
		var i = this.id.substring(12);
		var jqAplicaOpcion = eval("'#aplicaOpcion" + i + "'");
		if($(jqAplicaOpcion).attr('checked')== false){			
			Selecciona ='N';			
		}		
	});	
	
	$('input[name=aplicaOpcionr').each(function(){
		var j = this.id.substring(13);
		var jqAplicaOpcionr = eval("'#aplicaOpcionr" + j + "'");
		if($(jqAplicaOpcionr).attr('checked')==false){
			Selecciona ='N';
		}
	});
	if(Selecciona == 'N'){
		$('#seleccionaTodos').removeAttr('checked');		
	}else{
		$('#seleccionaTodos').attr('checked',true);
	}
}

function funcionExito(){
	deselecccionaOpciones();
	deselecccionaOpcionesRev();
	deselecccionaTodos();	
	$('#tipoCaja').val('').selected = true; 
	habilitaBotonGuardar();
}

function funcionFallo(){
}