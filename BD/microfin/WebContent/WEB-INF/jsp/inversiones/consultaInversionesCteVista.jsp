<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="js/inversiones/consultaInversionesCte.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="inversionBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Inversiones por <s:message code="safilocale.cliente"/></legend>
		
					<table border="0" cellpadding="0" cellspacing="0" width="50%">
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="clienteID">No. de <s:message code="safilocale.cliente"/>: </label>		
							</td>
							<td nowrap="nowrap">
								<input type="text" id="clienteID" name="clienteID" size="15" tabindex="1" autocomplete="off" />
								<input type="text" id="nombreCompleto" name="nombreCompleto" size="48" tabindex="2" disabled="true" readOnly="true"/> 
							</td>
						</tr>
					</table>
					<br/>
					<div id="gridInvCteVen"></div>
					<br/>
					<div id="gridInvCteVig"></div>
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