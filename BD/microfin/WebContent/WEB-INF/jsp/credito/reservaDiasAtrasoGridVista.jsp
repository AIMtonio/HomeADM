<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
	</head>
	<body>
		</br>
		<c:set var="ciclo" value="1"/>
		<c:set var="tipoLista"  value="${listaResultado[0]}"/>
		<c:set var="reservaPeriodo" value="${listaResultado[1]}"/>

		<form id="gridDiasAtraso" name="gridDiasAtraso">
			<input type="button" id="agregaPlazo" value="Agregar" class="botonGral" onclick="agregaElemento();"/>
			<table id="miTabla" border="0">
				<tbody>
				<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr>
						<td class="label">
							<label for="limInferior">L&iacute;m. Inferior</label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="limSuperior">L&iacute;m. Superior</label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="cartSinRest">% Cartera
									<a href="javaScript:" onClick="ayuda(1);">
								  	<img src="images/help-icon.gif" >
								</a> </label>
						</td>
					</tr>
				<c:forEach items="${reservaPeriodo}" var="reservaPeriodo" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<c:choose>
								<c:when test="${status.count == 1}">
									<input type="text" size="5" maxlength="9" name="plazoInferior" id="inferior${status.count}" value="${reservaPeriodo.limInferior}" onkeypress="return IsNumber(event)"/>
								</c:when>
								<c:otherwise>
									<input type="text" size="5" maxlength="9" name="plazoInferior" id="inferior${status.count}" value="${reservaPeriodo.limInferior}" readOnly="true"  />
								</c:otherwise>
							</c:choose>
						</td>
						<td class="separador"></td>
						<td>
							<input type="text" size="5" maxlength="9" name="plazoSuperior" id="superior${status.count}" value="${reservaPeriodo.limSuperior}" onblur="cambiaDiaSuperior(this)" onkeypress="return IsNumber(event)"/>
						</td>
						<td class="separador"></td>
						<td>
							<input type="text" size="8" style="text-align:right;" name="porSReest" id="porSReest${status.count}" value="${reservaPeriodo.porResCarSReest}" onblur="validaLimite(this)" onkeypress="return validaDigitos(event);"/>
							<input type="hidden" size="5" name="porReest" id="porReest${status.count}" value="${reservaPeriodo.porResCarReest}"/>
						</td>
						<td>
							<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaPlazo(this)"/>
							<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()"/>
						</td>
					</tr>
				</c:forEach>
		</c:when>					
					<c:when test="${tipoLista == '2'}">
					<tr>
						<td class="label">
							<label for="limInferior">L&iacute;m. Inferior</label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="limSuperior">L&iacute;m. Superior</label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="cartSinRest">% Cartera Tipo 1  
									<a href="javaScript:" onClick="ayuda(1);">
								  	<img src="images/help-icon.gif" >
								</a> </label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="cartRest">% Cartera Tipo 2
									<a href="javaScript:" onClick="ayuda(2);">
									  	<img src="images/help-icon.gif" >
									</a> </label>
						</td>
					</tr>
				<c:forEach items="${reservaPeriodo}" var="reservaPeriodo" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<c:choose>
								<c:when test="${status.count == 1}">
									<input type="text" size="5"  maxlength="9" name="plazoInferior" id="inferior${status.count}" value="${reservaPeriodo.limInferior}" onkeypress="return IsNumber(event)"/>
								</c:when>
								<c:otherwise>
									<input type="text" size="5"  maxlength="9" name="plazoInferior" id="inferior${status.count}" value="${reservaPeriodo.limInferior}" readOnly="true"  />
								</c:otherwise>
							</c:choose>
						</td>
						<td class="separador"></td>
						<td>
							<input type="text" size="5"  maxlength="9" name="plazoSuperior" id="superior${status.count}" value="${reservaPeriodo.limSuperior}" onblur="cambiaDiaSuperior(this)" onkeypress="return IsNumber(event)"/>
						</td>
						<td class="separador"></td>
						<td>
							<input type="text" size="8" maxlength="10" esMoneda="true" style="text-align:right;" name="porSReest" id="porSReest${status.count}" value="${reservaPeriodo.porResCarSReest}" onblur="validaLimite(this.id)" onkeypress="return validaDigitos(event);"/>
						</td>
						<td class="separador"></td>
						<td>
							<input type="text" size="8" maxlength="10" esMoneda="true" style="text-align:right;" name="porReest" id="porReest${status.count}" value="${reservaPeriodo.porResCarReest}" onblur="validaLimite(this.id)" onkeypress="return validaDigitos(event);"/>
						</td>
						<td>
							<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaPlazo(this)"/>
							<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()"/>
						</td>
					</tr>
				</c:forEach>
		</c:when>			
		</c:choose>
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
	var nav4 = window.Event ? true : false;
	function IsNumber(evt){
		var key = nav4 ? evt.which : evt.keyCode;
		return (key <= 13 || (key >= 48 && key <= 57) );
	}
	$('#gridDiasAtraso').validate({
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
		var jqCtrl = eval("'#"+ control + "'");
		var porcentaje = $(jqCtrl).val();
		var porcentajeSF = $(jqCtrl).asNumber();
		if(porcentaje == 0.00){
			mensajeSis('El porcentaje esta vacío');
			$(jqCtrl).focus();
			$(jqCtrl).val('');
		}else{
			if (porcentajeSF > 100 ){
			mensajeSis('El Valor Capturado debe ser Menor o Igual a 100.');
			$(jqCtrl).focus();
			$(jqCtrl).val('');
		}
		}
		
	}

	function cambiaDiaSuperior(control){
		var numeroID = control.id;
		var siguienteID = (parseInt(numeroID.replace("superior",""))+1);
		var actualID = parseInt(numeroID.replace("superior",""));
		
		var jqDiaInfSig = eval("'#inferior" + String(siguienteID) + "'");
		var jqDiaInfActual = eval("'#inferior" + String(actualID) + "'");
		if (numeroID != 'superior1' && parseInt(control.value) != 0){
			//Valida el Superior no sea menor o igual al inferior
			if (parseInt(control.value) <= parseInt($(jqDiaInfActual).val()) ){
				mensajeSis("El Plazo Superior debe ser Mayor al Plazo Inferior.");
				control.focus();
				control.value = 0;
				return false;
			}
		}else{
			if(parseInt($(jqDiaInfActual).val()) > 0 ){
				if (parseInt(control.value) <= parseInt($(jqDiaInfActual).val()) ){
					mensajeSis("El Plazo Superior debe ser Mayor al Plazo Inferior.");
					control.focus();
					control.value = 0;
					return false;
				}
			}
		}
		if($(jqDiaInfSig).val()!= undefined) {
			$(jqDiaInfSig).val(parseInt(control.value)+1);
		}
	}
	
	function eliminaPlazo(control){
		var numeroID = control.id;
		var jqTr = eval("'#renglon" + numeroID + "'");
		var jqDiaInf = eval("'#inferior" + numeroID + "'");
		var jqDiaSup = eval("'#superior" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");
		
		var jqDiaSupAnt = eval("'#superior" + String(eval(parseInt(numeroID)-1)) + "'");
		var jqDiaInfSig = eval("'#inferior" + String(eval(parseInt(numeroID)+1)) + "'");
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

	var clasificacion   = $("input[name='clasificacion']:checked").val();
	var institucion = $('#tipoInst').val();
	
	function agregaElemento(){

		if(institucion == 3 && clasificacion == 'H') { 
			var numeroFila = document.getElementById("numeroPlazos").value;
			var nuevaFila = parseInt(numeroFila) + 1;
			var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	   		if(numeroFila == 0){
				tds += '<td><input type="text" size="5" maxlength="9" name="plazoInferior" id="inferior'+nuevaFila+'" value="1" /></td>';
				tds += '<td class="separador"></td>';
				tds += '<td><input type="text" size="5" maxlength="9" name="plazoSuperior" id="superior'+nuevaFila+'" value="" autocomplete="off" onblur="cambiaDiaSuperior(this)" onkeypress="return IsNumber(event)"/></td>';
				tds += '<td class="separador"></td>';
	    		tds += '<td><input type="text" size="8" maxlength="10" esMoneda="true" style="text-align:right;" name="porSReest" id="porSReest'+nuevaFila+'" value="" onblur="validaLimite(this.id)" onkeypress="return validaDigitos(event);"/><input type="hidden" size="5" maxlength="10" esMoneda="true" name="porReest" id="porReest'+nuevaFila+'" value="0" onblur="validaLimite(this.id)" onkeypress="return validaDigitos(event);"/></td>';

	    		tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaPlazo(this)"/>';
	        	tds += '	<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()"/></td>';
	    	   	tds += '</tr>';
	        	document.getElementById("numeroPlazos").value = nuevaFila;
	        	$("#miTabla").append(tds);
	    	}else{
				var valor = parseInt(document.getElementById("superior"+numeroFila+"").value) + 1;
				var jqLimSuperior =  eval("'#"+ "superior"+numeroFila + "'");
				
				if(isNaN(valor) || document.getElementById("superior"+numeroFila+"").value == ''){
					mensajeSis('Indique el Límite Superior.');
					$(jqLimSuperior).focus();
				}else{
					tds += '<td><input type="text" size="5" maxlength="9" name="plazoInferior" id="inferior'+nuevaFila+'" value="'+valor+'" readOnly="true" /></td>';
		    		tds += '<td class="separador"></td>';
		    		tds += '<td><input type="text" size="5" maxlength="9" name="plazoSuperior" id="superior'+nuevaFila+'" value="" autocomplete="off" onblur="cambiaDiaSuperior(this)" onkeypress="return IsNumber(event)"/></td>';
		    		tds += '<td class="separador"></td>';
		    		tds += '<td><input type="text" size="8" maxlength="10" esMoneda="true" style="text-align:right;" name="porSReest" id="porSReest'+nuevaFila+'" value="" onblur="validaLimite(this.id)" onkeypress="return validaDigitos(event);"/><input type="hidden" size="5" maxlength="10" esMoneda="true"name="porReest" id="porReest'+nuevaFila+'" value="0" onblur="validaLimite(this.id)" onkeypress="return validaDigitos(event);"/></td>';
		    		
		    		tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaPlazo(this)"/>';
		        	tds += '	<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()"/></td>';
		    	   	tds += '</tr>';
		        	document.getElementById("numeroPlazos").value = nuevaFila;
		        	$("#miTabla").append(tds);
				}
	    		
	    	}
	    	agregaFormatoMoneda('formaGenerica');
	    	return false;
		}

		if(institucion == 3 && clasificacion != 'H' || institucion != 3) { 
			var numeroFila = document.getElementById("numeroPlazos").value;
			var nuevaFila = parseInt(numeroFila) + 1;
			var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	   		if(numeroFila == 0){
				tds += '<td><input type="text" size="5" name="plazoInferior" maxlength="9" id="inferior'+nuevaFila+'" value="1" /></td>';
				tds += '<td class="separador"></td>';
				tds += '<td><input type="text" size="5" name="plazoSuperior" maxlength="9" id="superior'+nuevaFila+'" value="" autocomplete="off" onblur="cambiaDiaSuperior(this)" onkeypress="return IsNumber(event)"/></td>';
				tds += '<td class="separador"></td>';
	    		tds += '<td><input type="text" size="8" maxlength="10" esMoneda="true" style="text-align:right;" name="porSReest" id="porSReest'+nuevaFila+'" value="" onblur="validaLimite(this.id)" onkeypress="return validaDigitos(event);"/></td>';
	    		tds += '<td class="separador"></td>';
	    		tds += '<td><input type="text" size="8" maxlength="10" esMoneda="true" style="text-align:right;" name="porReest" id="porReest'+nuevaFila+'" value="" onblur="validaLimite(this.id)" onkeypress="return validaDigitos(event);"/></td>';
	    		
	    		tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaPlazo(this)"/>';
	        	tds += '	<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()"/></td>';
	    	   	tds += '</tr>';
	        	document.getElementById("numeroPlazos").value = nuevaFila;
	        	$("#miTabla").append(tds);
	    	}else{
				var valor = parseInt(document.getElementById("superior"+numeroFila+"").value) + 1;
				var jqLimSuperior =  eval("'#"+ "superior"+numeroFila + "'");
				
				if(isNaN(valor) || document.getElementById("superior"+numeroFila+"").value == ''){
					mensajeSis('Indique el Límite Superior.');
					$(jqLimSuperior).focus();
				}else{
					tds += '<td><input type="text" size="5" name="plazoInferior" maxlength="9" id="inferior'+nuevaFila+'" value="'+valor+'" readOnly="true" /></td>';
		    		tds += '<td class="separador"></td>';
		    		tds += '<td><input type="text" size="5" name="plazoSuperior" maxlength="9" id="superior'+nuevaFila+'" value="" autocomplete="off" onblur="cambiaDiaSuperior(this)" onkeypress="return IsNumber(event)"/></td>';
		    		tds += '<td class="separador"></td>';
		    		tds += '<td><input type="text" size="8" maxlength="10" esMoneda="true" style="text-align:right;" name="porSReest" id="porSReest'+nuevaFila+'" value="" onblur="validaLimite(this.id)" onkeypress="return validaDigitos(event);"/></td>';
		    		tds += '<td class="separador"></td>';
		    		tds += '<td><input type="text" size="8" maxlength="10" esMoneda="true" style="text-align:right;" name="porReest" id="porReest'+nuevaFila+'" value="" onblur="validaLimite(this.id)" onkeypress="return validaDigitos(event);"/></td>';
		    		
		    		tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaPlazo(this)"/>';
		        	tds += '	<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()"/></td>';
		    	   	tds += '</tr>';
		        	document.getElementById("numeroPlazos").value = nuevaFila;
		        	$("#miTabla").append(tds);
				}
	    		
	    	}
	    	agregaFormatoMoneda('formaGenerica');
	    	return false;
		}
}



</script>