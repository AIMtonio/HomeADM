<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>


</head>
<body>
</br>
<c:set var="ciclo" value="1"/>
<form id="gridMontosAportaciones" name="gridMontosAportaciones">
<input type="button" id="agregaMonto" value="Agrega Monto" class="botonGral"/>

<table id="miTabla" border="0">
<tbody>
	<tr>
		<td class="label">
			<label for="plaInferior" >
				Monto Inferior
			</label>
		</td>
		<td class="label">
			<label for="plaSuperior" >
				Monto Superior
			</label>
		</td>
	</tr>

	<c:forEach items="${montosAportaciones}" var="montoAportacion" varStatus="status">
		<tr id="renglon${status.count}" name="renglon">
			<td>
				<c:choose>
				<c:when test="${status.count == 1}">
					<input type="text" size="18" name="montoInferior" id="inferior${status.count}"
							 value="${montoAportacion.montoInferior}" esMoneda="true" maxlength="16"
							 style="text-align: right" readOnly="true"  />
				</c:when>
				<c:otherwise>
					<input type="text" size="18" name="montoInferior" id="inferior${status.count}"
							 value="${montoAportacion.montoInferior}"  esMoneda="true"
							  style="text-align: right" readOnly="true" disabled="true" />
				</c:otherwise>
				</c:choose>
			</td>
			<td>

				<input type="text" size="18" name="montoSuperior" id="superior${status.count}" esMoneda="true"
						 value="${montoAportacion.montoSuperior}" onblur="cambiaMontoSuperior(this)"
						 onkeypress="return validaDigitos(event, this.id)" style="text-align: right"/>
				<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaPlazo(this)" style="text-align: right"   />
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

	$("#numeroPlazos").val($('input[name=montoSuperior]').length);

	agregaFormatoControles('gridMontosAportaciones');

	function validaDigitos(e, idControl){
		if(e.which!=8 && e.which!=46 && e.which!=0 && (e.which<48 || e.which>57) ||
				parseFloat(document.getElementById(idControl).value.replace(/\,/g,"")) > 999999999.99){
    		return false;

		}
	}

	$('#gridMontosAportaciones').validate({
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

	function cambiaMontoSuperior(control){
		var numeroID = control.id;
		var siguienteID = (parseFloat(numeroID.replace("superior",""))+1);
		var actualID = parseFloat(numeroID.replace("superior",""));
		var jqMontoSup = eval("'#superior" + String(actualID) + "'");
		var jqMontoInfSig = eval("'#inferior" + String(siguienteID) + "'");
		var jqMontoInfActual = eval("'#inferior" + String(actualID) + "'");
		//Valida el Superior no sea menor o igual al inferior
		if ($(jqMontoSup).asNumber() <= $(jqMontoInfActual).asNumber() ){
			mensajeSis("El Monto Superior debe ser Mayor al Monto Inferior");
			control.focus();
			return false;
		}
		if($(jqMontoInfSig).val()!= undefined) {
			$(jqMontoInfSig).val(parseFloat(control.value.replace(/\,/g, ""))+.01);
			$(jqMontoInfSig).formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});
		}
	}

	function eliminaPlazo(control){

		var numeroID = control.id;
		var jqTr = eval("'#renglon" + numeroID + "'");
		var jqMontoInf = eval("'#inferior" + numeroID + "'");
		var jqMontoSup = eval("'#superior" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");

		var jqMontoSupAnt = eval("'#superior" + String(eval(parseInt(numeroID)-1)) + "'");
		var jqMontoInfSig = eval("'#inferior" + String(eval(parseInt(numeroID)+1)) + "'");

		//Si es el primer Elemento
		if ($(jqMontoInf).attr("id") == $("input[name=montoInferior]:first-child").attr("id")){
			$(jqMontoInfSig).val("1");
		}else if($(jqMontoInfSig).val()!= null && $(jqMontoInfSig).val()!= undefined) {
			//Valida Antes de actualizar, que si exista un sig elemento
			$(jqMontoSupAnt).val($(jqMontoInfSig).val());
		}
		$(jqMontoInf).remove();
		$(jqMontoSup).remove();
		$(jqElimina).remove();
		$(jqTr).remove();

		//Reordenamiento de Controles
		var contador = 1;
		$('input[name=montoInferior]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "inferior" + contador);
			contador = contador + 1;
		});
		//Reordenamiento de Controles
		contador = 1;
		$('input[name=montoSuperior]').each(function() {
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

	$("#agregaMonto").click(function() {
	 	if($('#tipoAportacionID').val()!=""){
			var numeroFila = document.getElementById("numeroPlazos").value;
			var nuevaFila = parseInt(numeroFila) + 1;
	     	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	  	 	if(numeroFila == 0){
	    		tds += '<td ><input type="text" size="18"   name="montoInferior" value="1.00" id="inferior'+nuevaFila+'" esMoneda="true" style="text-align: right" cambiaMontoSuperior(this)/></td>';
	    		tds += '<td><input type="text" size="18" name="montoSuperior" id="superior'+nuevaFila+'" value="" autocomplete="off" onblur="cambiaMontoSuperior(this)" onkeypress="return validaDigitos(event,this.id)" style="text-align: right"/>';
	    	} else{
				var valor = parseFloat(document.getElementById("superior"+numeroFila+"").value.replace(/\,/g,"")) + .01;

	    		tds += '<td ><input type="text" size="18"  name="montoInferior" id="inferior'+nuevaFila+'" value="'+valor+'" esMoneda="true" readOnly disabled style="text-align: right"/></td>';
	    		tds += '<td><input type="text" size="18"  name="montoSuperior" id="superior'+nuevaFila+'" value="" autocomplete="off" onblur="cambiaMontoSuperior(this)" esMoneda="true" onkeypress="return validaDigitos(event,this.id)" style="text-align: right"/>';
	    	}
	    	tds += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaPlazo(this)"/></td>';
		  	tds += '</tr>';
	    	document.getElementById("numeroPlazos").value = nuevaFila;
	    	$("#miTabla").append(tds);
			agregaFormato("inferior" + nuevaFila);
			agregaFormato("superior" + nuevaFila);
	    	return false;
	 	}else{
	 		mensajeSis("Especifique Tipo de Aportación.");
			$('#tipoAportacionID').focus();
	 	}
 	});

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

</script>