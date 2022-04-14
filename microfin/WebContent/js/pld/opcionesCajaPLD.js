var totalOpciones = 0;
var checksMarcados = 0;
$(document).ready(function(){
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	var catTipoCategoriaTran ={
			'actualizar'	: 1
	};

	//-----------------------Método valida y manejo de eventos-----------------------
	agregaFormatoControles('formaGenerica');

	consultaOpcionesPorCaja();
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

	$('#guardar').click(function(event){		
		procesaFilas();
		$('#tipoTransaccion').val(catTipoCategoriaTran.actualizar);	
		//event.preventDefault();
	});
		
	$('#seleccionaTodos').click(function(){
		checkedTodos(this.id);
	});
	
	$('input[name=identiOpcion]').change(function(){
		habilitaBotonGuardar();
	});

	$('input[name=escalaOpcion]').change(function(){
		habilitaBotonGuardar();
	});

	$('input[name=seleccionaTodos]').change(function(){
		habilitaBotonGuardar();
	});
	
});			

function consultaOpcionesPorCaja() {		
	var tipoCajaSesion=parametroBean.tipoCaja;
	var numCon = 7;
	var opcionesCaja = {
			'tipoCaja'	:tipoCajaSesion
	};
	opcionesPorCajaServicio.listaCombo(numCon,opcionesCaja, { async: false, callback: function(opcionesporcaja) {		
		if (opcionesporcaja != null){	
			totalOpciones = opcionesporcaja.length * 2;
			var tds = '';
			tds += '<table id="tablaOperaciones" border="1" style="position:absolute;top:23px;left:45px;" >';
			tds += '<tr>';
				tds += '<td>';
				tds += '<label>Número </label>';
				tds += '</td>';		
				tds += '<td>';
				tds += '<label>Descripción</label>';
				tds += '</td>';		
				tds += '<td>';
				tds += '<label>&nbsp;&nbsp;Idenficación*&nbsp;&nbsp;</label>';
				tds += '</td>';	
				tds += '<td>';
				tds += '<label>&nbsp;&nbsp;Esc.Int.**&nbsp;&nbsp;</label>';
				tds += '</td>';
			tds += '</tr>';			
			for (var i=0; i< opcionesporcaja.length; i++) {
				tds +='<tr name="renglon">';
					tds += '<td>';
					tds += '<input type="text" id="opcionCajaID'+opcionesporcaja[i].opcionCajaID+'" value="'+opcionesporcaja[i].opcionCajaID+'" name="opcionCajaID" size="8" readonly="true"/>';
					tds += '</td>';			
					tds += '<td>';
					tds += '<input type="text" id="descripcion'+opcionesporcaja[i].opcionCajaID+'" value="'+opcionesporcaja[i].descripcion+'" name="descripcion" size="50" readonly="true"/>';
					tds += '</td>';			
					tds += '<td align="center">';
					tds += '<input type="checkbox" id="identiOpcion'+opcionesporcaja[i].opcionCajaID+'" name="identiOpcion" onclick="marcaCheckSelectodos(this.id);"/>';			
					tds += '</td>';			
					tds += '<td align="center">';
					tds += '<input type="checkbox" id="escalaOpcion'+opcionesporcaja[i].opcionCajaID+'" name="escalaOpcion" onclick="marcaCheckSelectodos(this.id);"/>';			
					tds += '</td>';			
				tds += '</tr>';					
			}
			tds += '</table>';
			$('#tablaOperaciones').html(tds);			
		}		
	}});	
	checkeaOpcionesPorCaja();
}

function checkeaOpcionesPorCaja() {
	var numCon = 8;
	var opcionesCaja = {
			'tipoCaja'	:''
	};
	checksMarcados = 0;
	deselecccionaOpciones();
	opcionesPorCajaServicio.listaCombo(numCon,opcionesCaja,{ async: false, callback: function(opciones) {	
		if (opciones != null && opciones != ''){
			 for(var j = 0;j < opciones.length;j++){
				 $('#tablaOperaciones tr[name=renglon]').each(function () {
					 var opcionID=$(this).find("input[name=opcionCajaID]").val();
					 if(opciones[j].opcionCajaID==opcionID){
					 	var jqIdentiOpcion = eval("'#identiOpcion" + opcionID + "'");
						var jqEscalaOpcion = eval("'#escalaOpcion" + opcionID + "'");
						if(opciones[j].sujetoPLDEscala=='S'){			  	  
							$(jqEscalaOpcion).attr('checked', 'true');
							checksMarcados++;
						}				 
						if(opciones[j].sujetoPLDIdenti=='S'){			  	  
							$(jqIdentiOpcion).attr('checked', 'true');
							checksMarcados++;
						}
					 }
				 });
			 }

		}
	}});
	marcaCheckTodos();
}

//Concatena los registros seleccionados
function procesaFilas(){	
	$('#listaOpcionesPLD').val('');
	$('#tablaOperaciones tr[name=renglon]').each(function(index){
		if (index >= 0) {
			var opcionCajaID = $(this).find("input[name=opcionCajaID]").val();
			var identiOpcion = $(this).find("input[name=identiOpcion]").is(":checked");
			var escalaOpcion = $(this).find("input[name=escalaOpcion]").is(":checked");
			if (index == 0) {
				$('#listaOpcionesPLD').val($('#listaOpcionesPLD').val() 
							+ opcionCajaID + ']' 
							+ (identiOpcion?'S':'N') + ']' 
							+ (escalaOpcion?'S':'N') + ']');
			} else {
				$('#listaOpcionesPLD').val($('#listaOpcionesPLD').val() + '['
							+ opcionCajaID + ']' 
							+ (identiOpcion?'S':'N') + ']' 
							+ (escalaOpcion?'S':'N') + ']');
			}
		}  	
	});
}

//Selecciona todos los registros del grid
function checkedTodos(idControl){
	var jqSelec  = eval("'#" + idControl + "'");
	if ($(jqSelec).is(':checked') == true){
		$('input[name=identiOpcion]').each(function () {
			$(this).attr('checked', 'true');
		});
		$('input[name=escalaOpcion]').each(function () {
			$(this).attr('checked', 'true');
		});
		checksMarcados = totalOpciones;
	}else {
		$('input[name=identiOpcion]').each(function () {
			$(this).removeAttr('checked');
		});
		$('input[name=escalaOpcion]').each(function () {
			$(this).removeAttr('checked');
		});
		checksMarcados = 0;
	}
}

function deselecccionaOpciones(){
	$('input[name=identiOpcion]').each(function () {
		$(this).removeAttr('checked');
	});
	$('input[name=escalaOpcion]').each(function () {
		$(this).removeAttr('checked');
	});
}

function deselecccionaTodos(){
	$('input[name=seleccionaTodos]').each(function () {
		$(this).removeAttr('checked');
	});
}

function habilitaBotonGuardar(){	
	habilitaBoton('guardar','submit');
}

//Marca la opcion Selecciona todos si todos estan seleccionados
function marcaCheckSelectodos(idControl){
	var jqCheck  = eval("'#" + idControl + "'");
	if($(jqCheck).attr('checked')== true){			
		checksMarcados++;
	} else if($(jqCheck).attr('checked')== false){			
		checksMarcados--;
	}	

	if(totalOpciones==checksMarcados){
		$('#seleccionaTodos').attr('checked',true);
	} else {
		$('#seleccionaTodos').removeAttr('checked');
	}
}

// Marca la opcion Selecciona todos si todos estan seleccionados
function marcaCheckTodos(){	
	var Selecciona ='S';
	$('input[name=identiOpcion]').each(function () {	
		var i = this.id.substring(12);
		var jqidentiOpcion= eval("'#identiOpcion" + i + "'");
		if($(jqidentiOpcion).attr('checked')== false){			
			Selecciona ='N';
		}
		if($(jqidentiOpcion).attr('checked')== true){			
		}		
	});	
	
	$('input[name=escalaOpcion').each(function(){
		var j = this.id.substring(12);
		var jqAplicaOpcionr = eval("'#escalaOpcion" + j + "'");
		if($(jqAplicaOpcionr).attr('checked')==false){
			Selecciona ='N';
		}
		if($(jqAplicaOpcionr).attr('checked')==true){
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
	deselecccionaTodos();	
	deshabilitaBoton('guardar','submit');
	checkeaOpcionesPorCaja();
}

function funcionFallo(){
}