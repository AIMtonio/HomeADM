<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
		<script type="text/javascript" src="js/credito/checkListIntegraEC.js"></script>
	</head>
<body>

<div id="contenedorForma">
<form:form method="post" id="formaGenerica" name="formaGenerica" commandName="integraExpCredBean" >
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Check List Integración Expediente de Crédito</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
				<label for="lblFecha">Número de <s:message code="safilocale.cliente"/>:</label>
			</td>
			<td>
				<input type="text" id="nuCliente" name="nuCliente" size="10" autocomplete="off"  tabindex="1"/>
				<input type="text" id="noCliente" name="noCliente" size="40"  autocomplete="off"  tabindex="2" readOnly="true"/>
			</td>
		</tr>
		<tr>
	 		<td class="label">
				<label for="lblFecha">Número de Grupo:</label>
			</td>
			<td>
				<input type="text" id="nuGrupo" name="nuGrupo" size="10"  autocomplete="off"  tabindex="3"/>
				<input type="text" id="noGrupo" name="noGrupo" size="40"  autocomplete="off"  tabindex="4" readOnly="true"/>
			</td>
		</tr>
	</table>
	<table align="right">
			<tr>
				<td align="right">
					<a id="ligaPDF" href="pdfCheckListIntegraEC.htm" target="_blank" >
				  		<button type="button" class="submit" id="generar" style="" tabindex="5">Generar</button> 
				 	</a>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="nombreInstitucion" name="nombreInstitucion"/>					
					
				</td>
			</tr>
	</table>
	</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>