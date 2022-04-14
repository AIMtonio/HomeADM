<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="dwr/interface/tasasISRExtServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
	<script type="text/javascript" src="js/aportaciones/isrExtranjero.js"></script>
</head>
<c:set var="tipoCatalogo" value="${tipoCatalogo}" />
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tasasISRExtBean">
				<table border="0" width="100%">
					<tr>
						<td colspan="5" valign="top">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="ui-widget ui-widget-header ui-corner-all">Tasas ISR Residentes en el Extranjero</legend>
								<div id="gridISRExtranjero"></div>
								<table style="margin-left:auto;margin-right:0px">
									<tr>
										<td>
											<input type="button" class="submit" value="Grabar" id="grabar" tabindex="299"/>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<input id="detalle" type="hidden" name="detalle" />
							<input id="tipoTransaccion" type="hidden" name="tipoTransaccion" />
						</td>
					</tr>
				</table>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>