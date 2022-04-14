<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
   <head>
      <script type="text/javascript" src="dwr/interface/bitacoraBatchServicio.js"></script>
      <script type="text/javascript" src="js/pld/evaluacionMatrizRiesgoCte.js"></script>  
   </head>
   <body>
      <div id="contenedorForma">
         <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="matrizRiesgoBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend
					class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Evaluaci&oacute;n por Matriz de Riesgo</legend>

				<table border="0" width="100%">
					<tr>
						<td class="label" style="width: 20%">
							<label for="fechaEvaluar">Fecha Actual:</label>
						</td>
						<td>
							<form:input id="fechaEvaluar" name="fechaEvaluar" tabindex="3" path="fechaEvaluar" readOnly="true" size="10"/>
						</td>
					</tr>
				</table>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<div class="label">
								<label style="width: 520px; text-align:justify; display: inline-block;">Este proceso se encarga de evaluar el nivel de riesgo de los <s:message code="safilocale.cliente"/>s, la evaluaci&oacute;n se realizar&aacute; para todos los <s:message code="safilocale.cliente"/>s activos con base en los par&aacute;metros de la matriz de riesgo y los niveles de riesgo.</br>
								<br>
								<b>Nota:</b> Se recomienda ejecutar el proceso en un horario no operativo. El proceso s&oacute;lo puede ser ejecutado una vez al d&iacute;a.</label>
							</div>
						</td>
					</tr>
					<br>
					<tr>
						<td>
							<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="7" style="float: right;"/> 
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="2" /> 
							<input type="hidden" id="tipoCliente" name="tipoCliente" value="3" />
							<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>	
						</td>
					</tr>
				</table>
			</fieldset>
         </form:form>
      </div>
      <div id="cargando" style="display: none;"></div>
      <div id="cajaLista" style="display: none;">
      	<div id="elementoLista"></div>
      </div>
   </body>
   <div id="mensaje" style="display: none;"></div>
</html>