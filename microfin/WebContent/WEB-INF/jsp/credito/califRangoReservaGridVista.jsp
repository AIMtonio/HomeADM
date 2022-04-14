<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>

	</head>
	<body>
		</br>
		<c:set var="ciclo" value="1"/>
		<form id="gridCalifReserva" name="gridCalifReserva">
			<input type="button" id="agregaPlazo" value="Agregar" class="botonGral" onclick="agregaElemento();"/>
			<table id="miTabla" border="0">
				<tbody>
					<tr>
						<td class="label">
							<label for="limInferior">L&iacute;m Inferior</label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="limSuperior">L&iacute;m Superior</label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblCalificacion">Calificaci&oacute;n</label>
						</td>
					</tr>
				<c:forEach items="${califReserva}" var="califReserva" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<c:choose>
								<c:when test="${status.count == 1}">
									<input type="text" size="6" maxlength="10" esTasa="true" name="plazoInferior" id="inferior${status.count}" value="${califReserva.limInferior}" onkeypress="return validaDigitos(event);"/>
								</c:when>
								<c:otherwise>
									<input type="text" size="6" maxlength="10" esTasa="true" name="plazoInferior" id="inferior${status.count}" value="${califReserva.limInferior}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<td class="separador"></td>
						<td>
							<input type="text" size="7" maxlength="10" esTasa="true" name="plazoSuperior" id="superior${status.count}" value="${califReserva.limSuperior}" onblur="cambiaDiaSuperior(this)" onkeypress="return validaDigitos(event);"/>
						</td>
						<td class="separador"></td>
						<td>
							<select name="calif" id="calif${status.count}" >
								<option value="A1"${califReserva.calificacion == 'A1' ? 'selected' : ''}>A1</option>
								<option value="A2"${califReserva.calificacion == 'A2' ? 'selected' : ''}>A2</option>
								<option value="B1"${califReserva.calificacion == 'B1' ? 'selected' : ''}>B1</option>
								<option value="B2"${califReserva.calificacion == 'B2' ? 'selected' : ''}>B2</option>
								<option value="B3"${califReserva.calificacion == 'B3' ? 'selected' : ''}>B3</option>
								<option value="C1"${califReserva.calificacion == 'C1' ? 'selected' : ''}>C1</option>
								<option value="C2"${califReserva.calificacion == 'C2' ? 'selected' : ''}>C2</option>
								<option value="D"${califReserva.calificacion == 'D' ? 'selected' : ''}>D</option>
								<option value="E"${califReserva.calificacion == 'E' ? 'selected' : ''}>E</option>
							</select>
						</td>
						<td>
							<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaPlazo(this)"/>
							<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()"/>							
						</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			<input type="hidden" value="0" name="numeroPlazos" id="numeroPlazos" />
		</form>
	</body>
</html>
<script type="text/javascript">

	$("#numeroPlazos").val($('input[name=plazoSuperior]').length);

	function validaDigitos(e){
		if(e.which!=8 && e.which!=0 && e.which != 46 && (e.which<48 || e.which>57)){
    		return false;
  		}
	}
	$('#gridCalifReserva').validate({
		rules: {
			control: {
				minlength: 1
			}
		},
		messages: {
		 	control: {
				minlength: 'Al menos un Caracter'
			}
		}
	});
	
	function validaLimite(control){
		var vacio = 0;
		var jqCtrl = eval("'#"+ control.id + "'");
		if (control.value > 100 ){
			mensajeSis('El valor capturado debe ser menor o igual a 100');
			$(jqCtrl).value = vacio;
			$(jqCtrl).focus();
		}
	}
	
	function cambiaDiaSuperior(control){
	if (control.value != ''){
		var numeroID = control.id;
		var siguienteID = (parseFloat(numeroID.replace("superior",""))+1);
		var actualID = parseFloat(numeroID.replace("superior",""));
		var numDetalle = $('input[name=plazoSuperior]').length;
		var jqSuperior = eval("'#superior" + numDetalle + "'");
		var jqDiaInfSig = eval("'#inferior" + String(siguienteID) + "'");
		var jqDiaInfActual = eval("'#inferior" + String(actualID) + "'");
		control.value = parseFloat(control.value);
		var jqCtrl = eval("'#"+ control.id + "'");
		var porcentajeSF = $(jqCtrl).asNumber();
		var diaInfActual = $(jqDiaInfActual).val();
		var diaInfActualSF = $(jqCtrl).asNumber();
		
		
			//Valida el Superior no sea menor o igual al inferior
			if (parseFloat(control.value) <= parseFloat($(jqDiaInfActual).val())){
				mensajeSis("El Limite Superior debe ser Mayor al Limite Inferior");
				control.focus();
				$(control).val('');
				return false;
			}else{
				if (porcentajeSF > 100 ){
					mensajeSis("El Limite Superior debe ser menor o igual a 100");
					$(jqSuperior).val(0);
					control.focus();

				}
			}
			if($(jqDiaInfSig).val()!= undefined) {
				$(jqDiaInfSig).val(parseFloat(control.value).toFixed(4));
			}
			$('#'+numeroID).val(parseFloat(control.value).toFixed(4));
		}
	}
	
	function eliminaPlazo(control){
		var numeroID = control.id;
		var jqTr = eval("'#renglon" + numeroID + "'");
		var jqDiaInf = eval("'#inferior" + numeroID + "'");
		var jqDiaSup = eval("'#superior" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");
		
		var jqDiaSupAnt = eval("'#superior" + String(eval(parseFloat(numeroID)-1)) + "'");
		var jqDiaInfSig = eval("'#inferior" + String(eval(parseFloat(numeroID)+1)) + "'");
		//Si es el primer Elemento 
		if ($(jqDiaInf).attr("id") == $("input[name=plazoInferior]:first-child").attr("id")){
			$(jqDiaInfSig).val("1");
		}else if($(jqDiaInfSig).val()!= null && $(jqDiaInfSig).val()!= undefined && !isNaN($(jqDiaInfSig).val())) {
			//Valida Antes de actualizar, que si exista un sig elemento
			$(jqDiaSupAnt).val($(jqDiaInfSig).val()-1);
		}
		$(jqDiaInf).remove();
		$(jqDiaSup).remove();
		$(jqElimina).remove();
		$(jqTr).remove();
		
		//Reordenamiento de Controles 
		var contador = 1;
		$('input[name=plazoInferior]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "inferior" + contador);
			contador = contador + 1;
		});
		//Reordenamiento de Controles 
		contador = 1;
		$('input[name=plazoSuperior]').each(function() {
			var jqCicSup = eval("'#" + this.id + "'");
			$(jqCicSup).attr("id", "superior" + contador);
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
		$('#numeroPlazos').val($('#numeroPlazos').val()-1);
	}
	
	function agregaElemento(){
		var numeroFila = document.getElementById("numeroPlazos").value;
		var jqSuperior = eval("'#superior" + numeroFila + "'");
        if($(jqSuperior).val()==100){
        }else{
		var nuevaFila = parseInt(numeroFila) + 1;
		var valor = 0;
		if(numeroFila == 0){
			valor = 1;
		}else{
			valor = parseFloat(document.getElementById("superior"+numeroFila+"").value).toFixed(4);
		}
		
		if(valor > 0){

			var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	   		if(numeroFila == 0){
				tds += '<td><input type="text" size="6"  maxlength="10" esTasa="true" name="plazoInferior" id="inferior'+nuevaFila+'" value="'+valor+'" /></td>';
				tds += '<td class="separador"></td>';			
				tds += '<td><input type="text" size="7"  maxlength="10" esTasa="true" name="plazoSuperior" id="superior'+nuevaFila+'" value="" autocomplete="off" onblur="cambiaDiaSuperior(this)" onkeypress="return validaDigitos(event)"/></td>';
				tds += '<td class="separador"></td>';
				tds += '<td>';
	    		tds += '<select name="calif" id="calif'+nuevaFila+'" >';
	    		tds += '<option value="A1">A1</option>';
	    		tds += '<option value="A2">A2</option>';
	    		tds += '<option value="B1">B1</option>';
	    		tds += '<option value="B2">B2</option>';
	    		tds += '<option value="B3">B3</option>';
	    		tds += '<option value="C1">C1</option>';
	    		tds += '<option value="C2">C2</option>';
	    		tds += '<option value="D">D</option>';
	    		tds += '<option value="E">E</option>';
	    		tds += '</select>';
	    		tds += '</td>';
	    	}else{
				
	    		tds += '<td><input type="text" size="6"  maxlength="10" esTasa="true" name="plazoInferior" id="inferior'+nuevaFila+'" value="'+valor+'" readOnly="true" /></td>';
	    		tds += '<td class="separador"></td>';
	    		tds += '<td><input type="text" size="7"  maxlength="10" esTasa="true" name="plazoSuperior" id="superior'+nuevaFila+'" value="" autocomplete="off" onblur="cambiaDiaSuperior(this)" onkeypress="return validaDigitos(event)"/></td>';
	    		tds += '<td class="separador"></td>';
	    		tds += '<td>';
	    		tds += '<select name="calif" id="calif'+nuevaFila+'" >';
	    		tds += '<option value="A1">A1</option>';
	    		tds += '<option value="A2">A2</option>';
	    		tds += '<option value="B1">B1</option>';
	    		tds += '<option value="B2">B2</option>';
	    		tds += '<option value="B3">B3</option>';
	    		tds += '<option value="C1">C1</option>';
	    		tds += '<option value="C2">C2</option>';
	    		tds += '<option value="D">D</option>';
	    		tds += '<option value="E">E</option>';
	    		tds += '</select>';
	    		tds += '</td>';
	    	}
	   		tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaPlazo(this)"/>';
	    	tds += '<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()"/>';
	    	tds += '</td>';
		   	tds += '</tr>';
	    	document.getElementById("numeroPlazos").value = nuevaFila;
	    	$("#miTabla").append(tds);
	    	$("#superior"+nuevaFila).focus();
		}else{
			mensajeSis('Indique el L&iacutemite Superior.');
			var jqLimSuperior =  eval("'#"+ "superior"+numeroFila + "'");
			$(jqLimSuperior).focus();			
		}
		
    	   agregaFormatoTasa('formaGenerica');
    	return false;
        }
	}
</script>