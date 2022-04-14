<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/speiRecepcionesPenBitServicio.js"></script>
		<script type="text/javascript" src="js/spei/RepBitacoraRecepcionesSPEI.js"></script>
	</head>

<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repRecepcionesSpeiiBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Bitacora de Recepciones SPEI</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="300px">
			<tr>
				<td width="300px">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Par&aacute;metros</label></legend>
          				<table  border="0"  width="300px">
							<tr>
								<td class="label">
									<label for="fechaInicio">Fecha Inicio: </label>
								</td>
								<td >
									<input id="fechaInicio" name="fechaInicio"  size="12" tabindex="1" type="text" esCalendario="true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="fechaFin">Fecha Fin: </label>
								</td>
								<td>
									<input id="fechaFin" name="fechaFin"  size="12" tabindex="2" type="text" esCalendario="true"/>
								</td>
							</tr>

							<tr>
								<td></td>
								<td align="center">
									<input type="button" id="generar" name="generar" class="submit" tabIndex = "7" value="Generar" />
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
				<td width="200"></td>
			</tr>
			
		</table>
		<br/>
		<div id="divRecepcionesPenBitGrid">
			
		</div>
	</fieldset>


</form:form>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>