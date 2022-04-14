$("#numeroDetalle").val($('input[name=consecutivoID]').length);

function eliminaDetalle(control){	

	var listaEliminados= $('#eliminados').val();

	var numeroID = control.id;
	var jqTr = eval("'#renglon" + numeroID + "'");


	var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
	var jqFolioID = eval("'#folioID" + numeroID + "'");//nuevo
	var jqConcep = eval("'#concep" + numeroID + "'");	//nuevo
	var jqConcepto = eval("'#concepto" + numeroID + "'");		
	var jqDescripcion = eval("'#descripcion" + numeroID + "'");
	var jqEstatus = eval("'#estatus" + numeroID + "'");
	var jqEstatusDes = eval("'#estatusDes" + numeroID + "'");//nuevo		

	var jqMonto = eval("'#monto" + numeroID + "'");
	var jqElimina = eval("'#" + numeroID + "'");

	if( $(jqFolioID).val() !='N'){
		listaEliminados+=","+$(jqFolioID).val();	
		$('#eliminados').val(listaEliminados);	
	}

	var jqConsecutivoIDAnt = eval("'#consecutivoID" + String(eval(parseInt(numeroID)-1)) + "'");				
	var jqConsecutivoIDSig = eval("'#consecutivoID" + String(eval(parseInt(numeroID)+1)) + "'");										  					

	//Si es el primer Elemento
	if ($(jqConsecutivoID).attr("id") == $("input[name=consecutivoID]:first-child").attr("id")){
		$(jqConsecutivoIDSig).val("1");				
	}else if($(jqConsecutivoIDSig).val()!= null && $(jqConsecutivoIDSig).val()!= undefined) {
		//Valida Antes de actualizar, que si exista un sig elemento

		for (i=(parseInt(numeroID)+1);i<=$("#numeroDetalle").val();i++){
			jqConsecutivoIDSig = eval("'#consecutivoID" + i + "'");			 		 	
			$(jqConsecutivoIDSig).val(numeroID);
			numeroID++;

		}
	}	




	//	mensajeSis(jqConsecutivoID+"<>"+jqFolioID+"<>"+jqConcep+"<>"+jqConcepto+"<>"+jqDescripcion+"<>"+jqEstatus+"<>"+jqEstatusDes+"<>"+jqMonto+"<>"+jqElimina+"<>"+jqTr);
	$(jqConsecutivoID).remove();
	$(jqFolioID).remove();
	$(jqConcep).remove();
	$(jqConcepto).remove();
	$(jqDescripcion).remove();
	$(jqEstatus).remove();
	$(jqEstatusDes).remove();
	$(jqMonto).remove();	
	$(jqElimina).remove();

	$(jqTr).remove();


	//Reordenamiento de Controles
	var contador = 1 ;
	$('input[name=consecutivoID]').each(function() {		
		var jqCicInf = eval("'#" + this.id + "'");	

		$(jqCicInf).attr("id", "consecutivoID" + contador);	

		//$(consecutivo).val(contador);	
		contador = contador + 1;	
	});


	//Reordenamiento de Controles
	contador = 1;		
	$('input[name=folioID]').each(function() {		
		var jqCicInf = eval("'#" + this.id + "'");	
		$(jqCicInf).attr("id", "folioID" + contador);			
		contador = contador + 1;	
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=concept]').each(function() {		
		var jqCicInf = eval("'#" + this.id + "'");	
		$(jqCicInf).attr("id", "concep" + contador);			
		contador = contador + 1;	
	});
	//Reordenamiento de Controles
	contador = 1;
	$('input[name=concepto]').each(function() {		
		var jqCicInf = eval("'#" + this.id + "'");	
		$(jqCicInf).unbind();	
		$(jqCicInf).attr("id", "concepto" + contador);		
		//obtenerCuenta("cuentaAhoID" + contador);
		//maestroCuentasDescripcion(cuentaAhoID" + contador,"nombreCte" + contador);	
		contador = contador + 1;	
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=descripcion]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");	
		$(jqCicInf).unbind();	
		$(jqCicInf).attr("id", "descripcion" + contador);			
		//	listaNombreCte("nombreCte" + contador);
		contador = contador + 1;	
	});			

	;		
	//Reordenamiento de Controles		
	contador = 1;		
	$('[name=estatus]').each(function() {		
		var jqCicSup = eval("'#" + this.id + "'");
		//mensajeSis("id="+jqCicSup +", valor="+ $(jqCicSup).val());
		$(jqCicSup).attr("id", "estatus" + contador);				
		contador = contador + 1;
	});
	/*			contador = 1;		
		$('select[name=estatus]').each(function() {	

			var jqCicSup = eval("'#" + this.id + "'");
			if ($(jqCicSup).length) {

			$(jqCicSup).attr("id", "estatus" + contador);			
			}
			contador = contador + 1;
		});
			//Reordenamiento de Controles		
		contador = 1;		
		$('input[name=estatusDes]').each(function() {		
			var jqCicSup = eval("'#" + this.id + "'");
			$(jqCicSup).unbind();
			if ($(jqCicSup).length) {		
			$(jqCicSup).attr("id", "estatusDes" + contador);				
			}

			contador = contador + 1;
		});
		var filas = $('#numeroDetalle').val(); 
		filas =filas -1;
		for(var i=1; i<=filas; i++){
			var estatus = eval("'#estatus" + i + "'");
			//mensajeSis($(estatus).val()+"-"+i);
			mensajeSis($('select[name=estatus]').id());
		}*/
	//Reordenamiento de Controles		
	contador = 1;		
	$('input[name=monto]').each(function() {		
		var jqCicSup = eval("'#" + this.id + "'");
		$(jqCicSup).unbind();			
		$(jqCicSup).attr("id", "monto" + contador);			
		//listaTipoMov("tipoMov" + contador);
		contador = contador + 1;
	});


	//Reordenamiento de Controles
	contador = 1;	
	$('input[name=elimina]').each(function() {
		var jqCicElim = eval("'#" + this.id + "'");
		$(jqCicElim).attr("id", contador);

		contador = contador + 1;	
	});			

	//Reordenamiento de Controles
	contador = 1;		
	$('tr[name=renglon]').each(function() {
		var jqCicTr = eval("'#" + this.id + "'");			
		$(jqCicTr).attr("id", "renglon" + contador);
		contador = contador + 1;	
	});

	$('#numeroDetalle').val($('#numeroDetalle').val()-1);

}


function agregaNuevoDetalle(){
	var concepto =  $('#conceptoID').val();		 	$('#conceptoID').val(''); 
	var conceptoDes = $('#conceptoDescri').val();		$('#conceptoDescri').val('');	 
	var descripcion = $('#descripcionPet').val(); 		$('#descripcionPet').val('');
	var monto = $('#montoPet').val(); 					$('#montoPet').val('');
	
	
	var estatus = 'S';// $('#estatusPet').val();
	var estatusDes;

	if(estatus == 'A'){
		estatusDes = 'Autorizado';
	}		 	
	if(estatus == 'S'){
		estatusDes = 'Solicitado';		 	
	}		 	
	if(estatus == 'C'){
		estatusDes = 'Cancelado';		 	
	}
	//mensajeSis($('#estatusPet').val());
	
	
	var numeroFila = document.getElementById("numeroDetalle").value;

	var nuevaFila = parseInt(numeroFila) + 1;		

	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';

	if(numeroFila == 0){
		tds += '<td class="label" align="center"><input type="text" id="consecutivoID'+nuevaFila+'" style="border: none;" name="consecutivoID" size="3" value="1" autocomplete="off" readOnly="true"/>';
		tds += ' <input type="hidden" id="folioID'+nuevaFila+'" name="folioID" value="N" /> </td>';
		tds += '<td class="label" align="center"><input type="text" id="concept'+nuevaFila+'" name="concept" size="50" value="'+conceptoDes+'" autocomplete="off" readOnly="true"/>';
		tds += '<input type="hidden" id="concepto'+nuevaFila+'" name="concepto" size="13" value="'+concepto+'" /></td>';
		tds += '<td class="label" align="center"><input type="text" id="descripcion'+nuevaFila+'" name="descripcion" size="50" value="'+descripcion+'" autocomplete="off"  onkeyup="aMays(event, this)" onblur="aMays(event, this)" /></td>';
		if(parametroBean.perfilUsuario != parametroBean.rolTesoreria ){ //--
			tds += '<td class="label" align="center"><input type="text" id="estatusDes'+nuevaFila+'" name="estatusDes" value="'+estatusDes+'" size="13" autocomplete="off" readOnly="true"/>';
			tds += '<input type="hidden" id="estatus'+nuevaFila+'" name="estatus" path="estatus" value="'+estatus+'"/></td>';
	
		}
		if(parametroBean.perfilUsuario == parametroBean.rolTesoreria ){ //--
			if(estatus == 'S'){
				tds += '<td class="label" align="center"> <select id="estatus'+nuevaFila+'" name="estatus" path="estatus" >';
				tds += '<option value="S">Solicitado</option>'; 
				tds += '<option value="A">Autorizado</option>'; 
				tds += '<option value="C">Cancelado</option>'; 
				tds += '</select> </td>';  
			}
			else{
				tds += '<td class="label" align="center"><input type="text" id="estatusDes'+nuevaFila+'" name="estatusDes" value="'+estatusDes+'" size="13" autocomplete="off" readOnly="true"/>';
				tds += '<input type="hidden" id="estatus'+nuevaFila+'" name="estatus" path="estatus" value="'+estatus+'"/></td>';
				
			}
			
		}
		tds += '<td class="label" align="center"><input type="text" id="monto'+nuevaFila+'" name="monto" size="10" value="'+monto+'" autocomplete="off"  onkeyPress="return Validador(event);"/></td>';
		if(parametroBean.perfilUsuario != parametroBean.rolTesoreria ){ //--
			tds += '<td class="label" align="center" ><input type="text" id="observaciones'+nuevaFila+'" name="lobservaciones" path="observaciones" readOnly="true" size="50"/></td>';			
			
		}
		if(parametroBean.perfilUsuario == parametroBean.rolTesoreria ){ //--
			tds += '<td class="label" align="center" > <input type="text" id="observaciones'+nuevaFila+'" name="lobservaciones" path="observaciones"size="50" /></td>';			
		
		}

	} 


	else{    		
		var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
		//nuevaFila = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
		// var valor = parseInt(numeroFila) +1;      			
		tds += '<td class="label" align="center"><input type="text" id="consecutivoID'+nuevaFila+'"  style="border: none;"  name="consecutivoID" size="3" value="'+valor+'" autocomplete="off" readOnly="true"/>';
		tds += ' <input type="hidden" id="folioID'+nuevaFila+'" name="folioID" value="N" /></td>';			
		tds += '<td class="label" align="center"><input type="text" id="concept'+nuevaFila+'" name="concept" size="50" value="'+conceptoDes+'" autocomplete="off" readOnly="true"/>';
		tds += '<input type="hidden" id="concepto'+nuevaFila+'" name="concepto" size="13" value="'+concepto+'" /></td>';
		tds += '<td class="label" align="center"><input type="text" id="descripcion'+nuevaFila+'" name="descripcion" size="50" value="'+descripcion+'" autocomplete="off"  onkeyup="aMays(event, this)" onblur="aMays(event, this)" /></td>';

		if(parametroBean.perfilUsuario != parametroBean.rolTesoreria ){ //--
			tds += '<td class="label" align="center"><input type="text" id="estatusDes'+nuevaFila+'" name="estatusDes" value="'+estatusDes+'" size="13" autocomplete="off" readOnly="true"/>';
			tds += '<input type="hidden" id="estatus'+nuevaFila+'" name="estatus" path="estatus" value="'+estatus+'"/></td>';
			
		}
		if(parametroBean.perfilUsuario == parametroBean.rolTesoreria ){ //--
			if(estatus == 'S'){
				tds += '<td class="label" align="center"> <select id="estatus'+nuevaFila+'" path="estatus" name="estatus" path="estatus" >';
				tds += '<option value="S">Solicitado</option>'; 
				tds += '<option value="A">Autorizado</option>'; 
				tds += '<option value="C">Cancelado</option>'; 
				tds += '</select> </td>';  
				
			}
			else{
				tds += '<td class="label" align="center"><input type="text" id="estatusDes'+nuevaFila+'" name="estatusDes" value="'+estatusDes+'" size="13" autocomplete="off" readOnly="true"/>';
				tds += '<input type="hidden" id="estatus'+nuevaFila+'" name="estatus" path="estatus" value="'+estatus+'"/></td>';
			
			}
		}

		tds += '<td class="label" align="center"><input type="text" id="monto'+nuevaFila+'" name="monto" size="10" value="'+monto+'" autocomplete="off" onkeyPress="return Validador(event);" /></td>';
		if(parametroBean.perfilUsuario != parametroBean.rolTesoreria ){ //--
			tds += '<td class="label" align="center" > <input type="text" id="observaciones'+nuevaFila+'" name="lobservaciones" path="observaciones"size="50"  readOnly="true" /></td>';			
		
		}
		if(parametroBean.perfilUsuario == parametroBean.rolTesoreria ){ //--
			tds += '<td class="label" align="center" ><input type="text" id="observaciones'+nuevaFila+'" name="lobservaciones" path="observaciones"size="50"  /></td>';			
		}

	}
	tds += '<td align="center">	<input type="button" name="elimina" id="'+nuevaFila +'"  class="btnElimina" onclick="eliminaDetalle(this)" />';

	tds += '</tr>';

	document.getElementById("numeroDetalle").value = nuevaFila;    	
	$("#miTabla").append(tds);

	//	agregaFormato("'monto"+nuevaFila+"'");
	return false;				
}

function agregaFormato(idControl){
	var jControl = eval("'#" + idControl + "'"); 

	$(jControl).bind('keyup',function(){
		$(jControl).formatCurrency({
			colorize: true,
			positiveFormat: '%n', 
			roundToDecimalPlace: -1
		});
	});
	$(jControl).blur(function() {
		$(jControl).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
	});
	$(jControl).formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});			
}

function Validador(e) {
	controlQuitaFormatoMoneda($('montoPet'));	
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46 || key==44) {		
		mensajeSis(key);
		if (key==8|| key == 46 || key==44){ 			
			return true;
		}
		else{
			mensajeSis("sólo se pueden ingresar números");
		}
		return false;

	}
}



function consultaExistenMovsAutorizados(fila){
	var jq_estatus =eval("'#estatus" + fila + "'");	
	var jq_monAutorizado = eval("'#monto" + fila + "'");
	var montoAut = $(jq_monAutorizado).asNumber();

	if(   montoAut  <= 0 && (parametroBean.perfilUsuario==parametroBean.rolTesoreria || parametroBean.perfilUsuario==parametroBean.rolAdminTeso)) { //--
		mensajeSis("El monto debe ser mayor que $0.00");
		var select =	eval("'#estatus" + fila + " option[value=S]'");
		$(select).attr('selected','true');	
	} 

}

function validMonto(fila){
	var jq_estatus =eval("'#estatus" + fila + "'");	
	var jq_monAutorizado = eval("'#monto" + fila + "'");
	var montoAut = $(jq_monAutorizado).asNumber();

	if( $(jq_estatus).val()=='S' && montoAut  <= 0  ) {
		mensajeSis("El monto   debe ser mayor que $0.00");
		var select =	eval("'#estatus" + fila + " option[value=S]'");
		$(select).attr('selected','true');	
		$(jq_monAutorizado).val('');
	} 

}

function aMays(e, elemento) {
	tecla=(document.all) ? e.keyCode : e.which; 
	 elemento.value = elemento.value.toUpperCase();
	}
