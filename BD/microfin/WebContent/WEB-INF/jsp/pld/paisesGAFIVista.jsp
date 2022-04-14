<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="dwr/interface/paisesGAFIPLDServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
	<script type="text/javascript" src="js/pld/paisesGafi.js"></script>
</head>
<c:set var="tipoCatalogo" value="${tipoCatalogo}" />
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="paisesGAFIPLDBean">
				<table border="0" width="100%">
					<tr>
					<c:choose>
						<c:when test="${tipoCatalogo == '2'}">
						<td colspan="5" valign="top">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="ui-widget ui-widget-header ui-corner-all">Paises No Cooperantes GAFI</legend>
								<div id="gridPaisesNoCoop"></div>
								<table style="margin-left:auto;margin-right:0px">
									<tr>
										<td>
											<input type="button" class="submit" value="Grabar" id="grabarNoCoop" tabindex="299"/>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						</c:when>
						<c:when test="${tipoCatalogo == '1'}">
						<td colspan="5" valign="top">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="ui-widget ui-widget-header ui-corner-all">Paises Por Integrarse GAFI</legend>
								<div id="gridPaisesEnMejora"></div>
								<table style="margin-left:auto;margin-right:0px">
									<tr>
										<td>
											<input type="button" class="submit" value="Grabar" id="grabarMejora" tabindex="600" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						</c:when>
						</c:choose>
					</tr>
					<tr>
						<td>
							<input id="detalleMejora" type="hidden" name="detalleMejora" />
							<input id="detalleNoCoop" type="hidden" name="detalleNoCoop" />
							<input id="tipoTransaccion" type="hidden" name="tipoTransaccion" />
							<input id="tipoPais" type="hidden" name="tipoPais" />
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