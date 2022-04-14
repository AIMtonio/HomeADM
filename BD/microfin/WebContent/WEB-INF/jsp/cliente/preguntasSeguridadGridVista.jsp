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

<form id="cuentasBCAMovilBean" name="cuentasBCAMovilBean">  
	<fieldset class="ui-widget ui-widget-content ui-corner-all">  
		<legend>Preguntas de Seguridad</legend>            
		<table id="miTabla" width="100%">
				<c:choose>
					<c:when test="${tipoLista == '6'}">			  	
						<c:forEach items="${listaResultado}" var="result" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">										 	
								<td> 
									<input id="consecutivoIDPP${status.count}"  name="consecutivoIDP" size="2" type="hidden" value="${status.count}" readOnly="true" disabled="true"  /> 	
									<input type="hidden" id="pregunta${status.count}" name="pregunta" size="30" value="${result.preguntaID}"  />  
									<select id="preguntaID${status.count}" name="preguntaID"  style="width:350px"  onchange="limpiaComentario(this.id)" tabindex="${status.count+4}"  >									
									</select> 
									<input type="password" id="respuestas${status.count}" name="respuestas" size="50" onBlur=" validaCaracteres(this.id),ponerMayusculas(this)"
										value="${result.respuestas}" autocomplete="off" maxlength="50" tabindex="${status.count+4}" /> 	  
								</td> 							 
						 	</tr>			
						</c:forEach>
					</c:when>
						<c:when test="${tipoLista == '7'}">			  	
						<c:forEach items="${listaResultado}" var="result" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">										 	
								<td> 
									<input id="consecutivoIDP${status.count}"  name="consecutivoIDP" size="2" type="hidden" value="${status.count}" readOnly="true" disabled="true"  /> 	
									<input type="hidden" id="pregunta${status.count}" name="pregunta" size="30" value="${result.preguntaID}"  />  
									<select id="preguntaID${status.count}" name="preguntaID"  style="width:350px"  onchange="limpiaComentario(this.id)"  tabindex="${status.count+3}" >									
									</select> 
									<input type="password" id="respuestas${status.count}" name="respuestas" size="50" onBlur=" validaCaracteres(this.id),ponerMayusculas(this)"
										value="${result.respuestas}" autocomplete="off" maxlength="50" tabindex="${status.count+3}" /> 	  
								</td> 							 
						 	</tr>			
						</c:forEach>
					</c:when>
				</c:choose>
		</table>
		 <input type="hidden" value="0" name="numeroDocumento" id="numeroDocumento" />	
	</fieldset>
</form>
</body>
</html>


	<script type="text/javascript">		
	$("#numeroDocumento").val($('input[name=consecutivoIDP]').length);	
			
			$('#cuentasBCAMovilBean').validate({
				rules: {
					preguntaID: { 
						required: true,
					},
					respuestas: { 
						required: true,
					}
				},
				messages: { 			
					preguntaID: {
						required: 'Seleccione una opción'
					},
					respuestas: {
						required: 'Escriba una respuesta'
					}
				}		
			});
			
			var numeroPreguntasSeg = "";
			
			consultaNumeroPreguntasSeguridad();
			
			// Funcion para consultar el numero de preguntas de seguridad del cliente
			function consultaNumeroPreguntasSeguridad(){
				var numCliente = $('#clienteID').val();
				var tipConsulta = 3;
				
				var PreguntasBeanCon = {
					'clienteID' : numCliente
				};
				if(numCliente != '' && !isNaN(numCliente)){
					cuentasBCAMovilServicio.consulta(tipConsulta, PreguntasBeanCon,function(preguntas){			
						if (preguntas != null){		
							numeroPreguntasSeg = preguntas.numPreguntas;
							if(numeroPreguntasSeg == 0){
							 	cargaListaPreguntas();
							}
							else{
								cargaConsultaPreguntas();
							}
						}		
					});
				}
			}
			
			// Funcion para cargar las lista de preguntas de seguridad
			function cargaListaPreguntas(){
				var tipoLista = 1;	
				$('tr[name=renglon]').each(function() {
					var numero= this.id.substr(7,this.id.length);
					var jsDesID = eval("'preguntaID" + numero+ "'");
					
					var bean = {
						'clienteID':0			
					};

					cuentasBCAMovilServicio.listaCombo(tipoLista, bean, function(documento){
					dwr.util.removeAllOptions(jsDesID);
					dwr.util.addOptions(jsDesID, {'':'SELECCIONAR'});  
					dwr.util.addOptions(jsDesID, documento, 'preguntaID', 'descripcion');
					});
				});
			}
			
			// Funcion para cargar las consultas de preguntas de seguridad
			function cargaConsultaPreguntas(){
				var tipoLista = 1;	
				$('tr[name=renglon]').each(function() {
					var numero= this.id.substr(7,this.id.length);
					var jsDesID = eval("'preguntaID" + numero+ "'");	
					var jsPre= eval("'pregunta" + numero+ "'");
					
					var valorjsPre= document.getElementById(jsPre).value;
					
					var bean = {
							'clienteID':0			
					};

					cuentasBCAMovilServicio.listaCombo(tipoLista, bean, function(documento){
					dwr.util.removeAllOptions(jsDesID);
					dwr.util.addOptions(jsDesID, {'':'SELECCIONAR'});  
					dwr.util.addOptions(jsDesID, documento, 'preguntaID', 'descripcion');
					
					$('#preguntaID'+numero+' option[value='+ valorjsPre +']').attr('selected','true');
					
					});
				});
			}
			
			// funcion para limpiar comentarios
			function limpiaComentario(control){
				var numero= control.substr(10,control.length);
				var comentarioID = eval("'respuestas" + numero+ "'");
				document.getElementById(comentarioID).value = '';				
			}
			
			// funcion para eliminar caracteres especiales
			function validaCaracteres(control){
				var numero= control.substr(10,control.length);
				var jqRespuesta= eval("'#respuestas" + numero + "'");				
				
				var respuesta = $(jqRespuesta).val();
				
				var valorRespuesta = respuesta.replace(/[%&(=?¡'@,{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\][°|!#|$|%|/|()|=|?|:|;|-|¡|¿|\¬|+*{}|[]|_|]/gi, '');
					valorRespuesta = valorRespuesta.replace(/[_]/gi,'');
					respuesta = valorRespuesta;				
				
				$(jqRespuesta).val(respuesta);
			}


	
	</script>
		
