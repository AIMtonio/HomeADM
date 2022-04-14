<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>

</head>
<body> 
</br>
<c:set var="ciclo" value="1"/>

<form id="gridplazos" name="gridplazos">
<input type="button" id="agregaPlazo" value="Agrega Plazo" class="botonGral"/>

<table id="miTabla" border="0">
<tbody>
	<tr>
		<td class="label">
			<label for="plaInferior">
				D&iacute;a Inferior
			</label>
			<label for="plaSuperior">
				D&iacute;a Superior
			</label>			
		</td>
	</tr>	
	
	<c:forEach items="${plazosLista}" var="diasAportaciones" varStatus="status">
		<tr id="renglon${status.count}" name="renglon">
			<td>
				<c:choose>
				<c:when test="${status.count == 1}">
					<input type="text" size="5" name="plazoInferior"
							 id="inferior${status.count}"
							 value="${diasAportaciones.plazoInferior}"/>
				</c:when>
				<c:otherwise>
					<input type="text" size="5" name="plazoInferior"
							 id="inferior${status.count}"
							 value="${diasAportaciones.plazoInferior}" readOnly="true"  />
				</c:otherwise>
				</c:choose>
				<input type="text" size="5" name="plazoSuperior"
						 id="superior${status.count}"
						 value="${diasAportaciones.plazoSuperior}"
						 onblur="cambiaDiaSuperior(this)"
						 onkeypress="return validaDigitos(event)"/>
				<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaPlazo(this)"  />
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
		if(e.which!=8 && e.which!=0 && (e.which<48 || e.which>57)){
    		return false;
  		}
	}
	$('#gridplazos').validate({
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
	
	function cambiaDiaSuperior(control){
		var numeroID = control.id;		
		var siguienteID = (parseInt(numeroID.replace("superior",""))+1);
		var actualID = parseInt(numeroID.replace("superior",""));
		
		var jqDiaInfSig = eval("'#inferior" + String(siguienteID) + "'");
		var jqDiaInfActual = eval("'#inferior" + String(actualID) + "'");
		
		//Valida el Superior no sea menor o igual al inferior
		if (parseInt(control.value) <= parseInt($(jqDiaInfActual).val()) ){
			mensajeSis("El Día Superior debe ser Mayor al Día Inferior");			
			control.focus();
			return false;
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
		}else if($(jqDiaInfSig).val()!= null && $(jqDiaInfSig).val()!= undefined) {
			//Valida Antes de actualizar, que si exista un sig elemento
			$(jqDiaSupAnt).val($(jqDiaInfSig).val());
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
		
	$("#agregaPlazo").click(function() {
	 	if($('#tipoAportacionID').val()!=""){	
			var numeroFila = document.getElementById("numeroPlazos").value;
			var nuevaFila = parseInt(numeroFila) + 1;		
	      	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';	 	  
		   	if(numeroFila == 0){	    		
		    		tds += '<td ><input type="text" size="5" name="plazoInferior" id="inferior'+nuevaFila+'" value="1" readOnly disabled />';
		    		tds += '<input type="text" size="5" name="plazoSuperior" id="superior'+nuevaFila+'" value="" autocomplete="off" onblur="cambiaDiaSuperior(this)" onkeypress="return validaDigitos(event)"/>';
		    } else{    		
					var valor = parseInt(document.getElementById("superior"+numeroFila+"").value) + 1;
		    		tds += '<td ><input type="text" size="5" name="plazoInferior" id="inferior'+nuevaFila+'" value="'+valor+'" readOnly disabled />';
		    		tds += '<input type="text" size="5" name="plazoSuperior" id="superior'+nuevaFila+'" value="" autocomplete="off" onblur="cambiaDiaSuperior(this)" onkeypress="return validaDigitos(event)"/>';
		    }
		    tds += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaPlazo(this)"/></td>';
			tds += '</tr>';
		    document.getElementById("numeroPlazos").value = nuevaFila;    	
		    $("#miTabla").append(tds);
		    return false;
		}else{
			mensajeSis("Especifique Tipo de Aportación.");
			$('#tipoAportacionID').focus();
		}
 	});


</script>