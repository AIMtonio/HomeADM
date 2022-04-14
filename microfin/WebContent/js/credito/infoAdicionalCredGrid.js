$("#numeroRelaciones").val($('input[name=idPlaca]').length);
function validaDigitos(e){
	if(e.which!=8 && e.which!=0 && e.which != 46 && (e.which<48 || e.which>57)){
   		return false;
	}
}
$('#gridInfoAdicionalCred').validate({
	rules: {
		creditoID: {
			required : true
		},
		placa: {
			minlength : 5,
			maxlength : 7
		},
		vin: {
			minlength : 16,
			maxlength : 18
		},
		gnv: {
			min : 1
		}
	},
	messages: {
	 	creditoID: {
	 		required : 'El Crédito esta Vacío.'
		},
		placa: {
			minlength : 'Minimo de Numeros 5',
			maxlength : 'Máximo de Numeros 7'
		},
		vin: {
			minlength : 'Minimo de Numeros 16',
			maxlength : 'Máximo de Numeros 18'
		},
		gnv: {
			min : "Minimo el valor de 1"
		}
	}
});

$('input[name=idPlaca]').click(function() {
	modificar();
});

$('input[name=idGnv]').click(function() {
	modificar();
});


$('input[name=idVin]').click(function() {
	modificar();
});

function modificar(){	
	$('tr[name=renglon]').click(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqEst = eval("'#estatus" + numero + "'");
		jqEst = $(jqEst).val('P');
	});		
}

function eliminaRelacion(control){
	var numeroID = control.id;
	var jqTr = eval("'#renglon" + numeroID + "'");
	var jqPlaca = eval("'#placa" + numeroID + "'");
	var jqGnv = eval("'#gnv" + numeroID + "'");
	var jqVin = eval("'#vin" + numeroID + "'");
	var jqEst = eval("'#estatus" + numeroID + "'");
	var jqElimina = eval("'#" + numeroID + "'");
	
	$(jqElimina).remove();
	$(jqTr).remove();
	
	//Reordenamiento de Controles 
	var contador = 1;
	$('input[name=idPlaca]').each(function() {
		var jqCicPla = eval("'#" + this.id + "'");
		$(jqCicPla).attr("id", "placa" + contador);
		contador = contador + 1;
	});
	//Reordenamiento de Controles 
	contador = 1;
	$('input[name=idGnv]').each(function() {
		var jqCicGnv = eval("'#" + this.id + "'");
		$(jqCicGnv).attr("id", "gnv" + contador);
		contador = contador + 1;
	});
	contador = 1;
	$('select[name=idVin]').each(function() {
		var jqCicVin = eval("'#" + this.id + "'");
		$(jqCicVin).attr("id", "vin" + contador);
		contador = contador + 1;
	});
	contador = 1;
	$('select[name=idEstatus]').each(function() {
		var jqCicEst = eval("'#" + this.id + "'");
		$(jqCicEst).attr("id", "estatus" + contador);
		contador = contador + 1;
	});
	contador = 1;
	//Reordenamiento de Controles 
	$('input[name=elimina]').each(function() {
		var jqCicElim = eval("'#" + this.id + "'");
		$(jqCicElim).attr("id", contador);
		contador = contador + 1;
	});
	contador = 1;
	//Reordenamiento de Controles 
	$('tr[name=renglon]').each(function() {
		var jqCicTr = eval("'#" + this.id + "'");
		$(jqCicTr).attr("id", "renglon" + contador);
		contador = contador + 1;
	});
	$('#numeroRelaciones').val($('#numeroRelaciones').val()-1);
	if ($('#numeroRelaciones').val() == 0){
		//deshabilitaBoton('grabar', 'submit');
	}
}
		
$("#agregaRelacion").click(function() {
	habilitaBoton('grabar', 'submit');
	var numeroFila = document.getElementById("numeroRelaciones").value;
	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
  		tds +='<td><input type="text" size="19" name="idPlaca" id="placa'+nuevaFila+'" onBlur=" ponerMayusculas(this)" tabindex="'+nuevaFila+'" minlength ="5" maxlength="7"/></td>';
 		tds +='<td><input type="text" size="19" name="idVin" id="vin'+nuevaFila+'" onBlur=" ponerMayusculas(this)" tabindex="'+nuevaFila+'" minlength ="16" maxlength="18"/></td>';
 		tds +='<td><input type="number" size="20" name="idGnv" id="gnv'+nuevaFila+'" tabindex="'+nuevaFila+'" min="1" oninput="validity.valid;"/></td>';
 		tds += '<td>';
		tds +='<select name="idEstatus" id="estatus'+nuevaFila+'" path="idEstatus" disabled="true">';
			tds +='<option value="P">PENDIENTE</option>';
		tds +='</select>';
		tds +='</td>';
    	tds +='<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaRelacion(this)" /></td><td>';
    	tds += '<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()" />';
    	tds += '</td>';
	   	tds += '</tr>';
    document.getElementById("numeroRelaciones").value = nuevaFila;
    $("#miTabla").append(tds);
    $("#placa"+nuevaFila).focus();
    return false;
});
	
function agregaElemento(){
	var numeroFila = document.getElementById("numeroRelaciones").value;
	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
  		tds +='<td><input type="text" size="19" name="idPlaca" id="placa'+nuevaFila+'" onBlur=" ponerMayusculas(this)" tabindex="'+nuevaFila+'" minlength ="5" maxlength="7"/></td>';
 		tds +='<td><input type="text" size="19" name="idVin" id="vin'+nuevaFila+'" onBlur=" ponerMayusculas(this)" tabindex="'+nuevaFila+'" minlength ="16" maxlength="18"/></td>';
 		tds +='<td><input type="number" size="20" name="idGnv" id="gnv'+nuevaFila+'" tabindex="'+nuevaFila+'" min="1" oninput="validity.valid;"/></td>';
 		tds += '<td>';
		tds +='<select name="idEstatus" id="estatus'+nuevaFila+'" path="idEstatus" disabled="true">';
			tds +='<option value="P">PENDIENTE</option>';
		tds +='</select>';
		tds +='</td>';
    	tds +='<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaRelacion(this)" /></td><td>';
    	tds += '<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()" />';
    	tds += '</td>';
	   	tds += '</tr>';
    document.getElementById("numeroRelaciones").value = nuevaFila;
    $("#miTabla").append(tds);
    $("#placa"+nuevaFila).focus();
    return false;
}