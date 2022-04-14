<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
      <script type="text/javascript" src="js/credito/actaComite.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Reporte de Acta Comité</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="numero">Tipo Solicitud:</label>
							</td>
							<td>
								<input type="radio" id="solicitudInd" name="solicitud" checked="true" /><label>Individual</label>
								<input type="radio" id="solicitudGrp" name="solicitud" /><label>Grupal</label>
							</td>
						</tr>
						<tr class="trIndividual">
							<td class="label">
								<label for="numero">Solicitud:</label>
							</td>
							<td>
								<form:input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="12" />
							</td>
						</tr>
						<tr class="trIndividual">
							<td>
								<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
		     				</td> 
		     				<td nowrap="nowrap"> 
				         		<input id="clienteID" name="clienteID" size="12" type="text" tabindex="3" disabled = "true"/>
		         				<input id="nombreCte" name="nombreCte"size="50" type="text" tabindex="3" readOnly="true" disabled = "true" />
		     				</td>
						</tr>
						<tr class="trGrupal" style="display:none">
							<td class="label">
								<label for="numero">Grupo:</label>
							</td>
							<td>
								<form:input id="grupo" name="grupo" path="grupoID" size="12" tabindex=""  />
							</td>
						</tr>
						<tr class="trGrupal" style="display:none">
							<td class="label">
								<label for="numero">Nombre Grupo:</label>
							</td>
							<td>
								<input id="nombreGrupo" name="nombreGrupo" size="50" tabindex="" type="text"  disabled="true" iniForma="false"/>
							</td>
						</tr>
					</table>
					<table width="100%">
						<tr>
							<td align="right">
								<a id="ligaPDF" href="repActaComite.htm" target="_blank">
		    						<input type="button" class="submit" id="genera" name="genera" tabindex="" value="Imprimir"/>
								</a>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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