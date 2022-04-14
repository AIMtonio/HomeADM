<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>

</head>
<body>
<br/>

<c:set var="listaResultado"  value="${listaResultado}"/>

<form id="gridDetalle" name="gridDetalle">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>C&oacute;digos de Respuesta</legend>	
		<input type="button" id="agregaCodigo" value="Agregar" class="botonGral" tabindex="10"/>
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="lblNumero">N&uacute;mero</label> 
						</td>
						<td class="label"> 
					   	<label for="lblCodigo">C&oacute;digo</label> 
						</td>
						<td class="label"> 
							<label for="lblResp">Respuesta</label> 
				  		</td>	
					</tr>
					
					<c:forEach items="${listaResultado}" var="codigoResp" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="consecutivoID${status.count}"  name="consecutivoID" size="6"  
										value="${status.count}" readOnly="true" disabled="true" /> 
						  	</td> 
						  	<td> 
								<input id="codigoRespID${status.count}" name="codigoRespID" size="11" 
										value="${codigoResp.codigoRespID}"  /> 
						  	</td> 
						  	<td> 
								<input id="descripcion${status.count}" name="descripcion" size="50" 
										value="${codigoResp.descripcion}" onBlur="ponerMayusculas(this)" /> 
							 &nbsp;&nbsp;&nbsp;
							<input type="button" name="elimina"   id="${status.count}"  value="" class="btnElimina" onclick="eliminarCodigo(this.id)"/>
							 <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregaNuevoCodigo()"/>
						  	</td> 						
						</tr>
						
						
					</c:forEach>
				</tbody>
				<tr align="right">
					<td class="label" colspan="5"> 
				   	<br>
			     	</td>
				</tr>
			</table>
			<input type="hidden" value="0" name="numeroCodigo" id="numeroCodigo" />
		</fieldset>
	
</form>

</body>
</html>

<script type="text/javascript">
	
	
	$("#numeroCodigo").val($('input[name=consecutivoID]').length);	

	$('#gridCodigosResp').validate({
		rules: {
			consecutivoID: { 
				minlength: 1
			}
		},
		messages: { 			
		 	consecutivoID: {
				minlength: 'Al menos un Caracter'
			}
		}		
	});	
	

	function eliminarCodigo(control){	
		var contador = 0 ;
		var numeroID = control;
		
		var jqRenglon = eval("'#renglon" + numeroID + "'");
		var jqNumero = eval("'#consecutivoID" + numeroID + "'");
		var jqCodigoResp = eval("'#codigoRespID	" + numeroID + "'");		
		var jqDescripcion = eval("'#descripcion" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");
		var jqAgrega = eval("'#agrega" + numeroID + "'");
		 
		// se elimina la fila seleccionada
		$(jqNumero).remove();
		$(jqCodigoResp).remove();
		$(jqDescripcion).remove();
		$(jqElimina).remove();
		$(jqRenglon).remove();
		$(jqAgrega).remove();
					
		// se asigna el numero de 
		var elementos = document.getElementsByName("renglon");
		$('#numeroCodigo').val(elementos.length);	

		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {
			numero= this.id.substr(7,this.id.length);
			var jqRenglonCiclo = eval("'renglon" + numero+ "'");	
			var jqNumeroCiclo = eval("'consecutivoID" + numero + "'");
			var jqCodigoRespIDCiclo = eval("'codigoRespID" + numero + "'");		
			var jqNoDescripcionCiclo = eval("'descripcion" + numero + "'");			
			var jqEliminaCiclo = eval("'" + numero + "'");
			var jqAgregaCiclo=eval("'agrega" + numero + "'");
			document.getElementById(jqNumeroCiclo).setAttribute('value',  contador);
			
			document.getElementById(jqRenglonCiclo).setAttribute('id', "renglon" + contador);
			document.getElementById(jqNumeroCiclo).setAttribute('id', "consecutivoID" + contador);
			document.getElementById(jqCodigoRespIDCiclo).setAttribute('id', "codigoRespID" + contador);
			document.getElementById(jqNoDescripcionCiclo).setAttribute('id', "descripcion" + contador);
			document.getElementById(jqEliminaCiclo).setAttribute('id',  contador);	
			document.getElementById(jqAgregaCiclo).setAttribute('id', "agrega"+ contador);

			contador = parseInt(contador + 1);	
		});
		
	}
	
	
	function agregaNuevoCodigo(){
		var numeroFila = document.getElementById("numeroCodigo").value;
		var nuevaFila = parseInt(numeroFila) + 1;			
      var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	 	 	  
   	if(numeroFila == 0){
    		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="1" autocomplete="off" /></td>';
    		tds += '<td><input id="codigoRespID'+nuevaFila+'" name="codigoRespID" size="11" value="" autocomplete="off" /></td>';
			tds += '<td><input id="descripcion'+nuevaFila+'" name="descripcion" size="50" value=""  onBlur="ponerMayusculas(this)"/>';						
    	} else{    		
			var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
    		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off" /></td>';
    		tds += '<td><input id="codigoRespID'+nuevaFila+'" name="codigoRespID" size="11" value="" autocomplete="off" /></td>';
			tds += '<td><input id="descripcion'+nuevaFila+'" name="descripcion" size="50" value="" onBlur="ponerMayusculas(this)" />';			
    	}
    	tds += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarCodigo(this.id)"/>';
    	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoCodigo()"/></td>';
	   tds += '</tr>';
	   
	   
    	document.getElementById("numeroCodigo").value = nuevaFila;    	
    	$("#miTabla").append(tds);
		
		return false;		
	}

			
	$("#agregaCodigo").click(function() {
		agregaNuevoCodigo();
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
					
	}

</script>