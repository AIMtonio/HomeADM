<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="dwr/interface/cancelacionOrdPagoServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
	<script type="text/javascript" src="js/tesoreria/cancelacionOrdPago.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cancelacionOrdPago">
				<table border="0" width="100%">
					<tr>
						<td colspan="5" valign="top">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="ui-widget ui-widget-header ui-corner-all">Cancelaci&oacute;n Ordenes de Pago</legend>
								
								<div id="gridCancelacion">
									
								</div>
								<table border="0" cellpadding="0" cellspacing="0"  align="right">  
									<tr>
										<td align="right">
									    	<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="26"/>
											<input type="button" id="exportar" name="exportar" class="submit"  value="Exportar" tabindex="27"/>
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						
					</tr>
					<tr>
						<td>
							<input id="detalleCancelacion" type="hidden" name="detalleCancelacion" />
							<input id="tipoTransaccion" type="hidden" name="tipoTransaccion" />
							<input id="numTransaccion" type="hidden" name="numTransaccion" />
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