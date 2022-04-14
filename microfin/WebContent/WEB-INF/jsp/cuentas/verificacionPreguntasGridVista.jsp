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

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="verificacionPreguntasBean" name="verificacionPreguntasBean">  
	<fieldset class="ui-widget ui-widget-content ui-corner-all">  
		<legend>Preguntas de Seguridad</legend>            
		<table id="miTabla" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'}">			  	
					<c:forEach items="${listaResultado}" var="result" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">										 	
							<td> 
								<input id="consecutivoID${status.count}"  name="consecutivoID" size="2" type="hidden" value="${status.count}" readOnly="true" /> 	
								<input type="hidden" id="preguntaID${status.count}" name="preguntaID" size="30" value="${result.preguntaID}"  />  
								<input type="text" id="descripcion${status.count}" name="descripcion" size="50" value="${result.descripcion}" readonly="true"  /> 
								<input type="password" id="respuesta${status.count}" name="respuesta" size="50" onBlur=" validaCaracteres(this.id),ponerMayusculas(this)"
										autocomplete="off" maxlength="50" tabindex="6" /> 	  
								<input type="hidden" id="respuestas${status.count}" name="respuestas" size="30" value="${result.respuestas}"  /> 
							</td> 							 
					 	</tr>			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
</body>
</html>


	<script type="text/javascript">		
	
	$('#verificacionPreguntasBean').validate({
		rules: {
			preguntaID: { 
				required: true,
			},
			respuesta: { 
				required: true,
			}
		},
		messages: { 			
			preguntaID: {
				required: 'Seleccione una opción'
			},
			respuesta: {
				required: 'Escriba una respuesta'
			}
		}		
	});
	
	// funcion para eliminar caracteres especiales
	function validaCaracteres(control){
		var numero= control.substr(9,control.length);
		var jqRespuesta= eval("'#respuesta" + numero + "'");				
		
		var respuesta = $(jqRespuesta).val();
		
		var valorRespuesta = respuesta.replace(/[%&(=?¡'@,{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\][°|!#|$|%|/|()|=|?|:|;|-|¡|¿|\¬|+*{}|[]|_|]/gi, '');
			valorRespuesta = valorRespuesta.replace(/[_]/gi,'');
			respuesta = valorRespuesta;				
		
		$(jqRespuesta).val(respuesta);
	}
	
	</script>
		