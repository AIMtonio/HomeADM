<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/tarDebGiroxTipoCliCorpServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tarDebLimiteTipoCteCorpServicio.js"></script>                                       
<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript"	src="js/tarjetas/giroNegocioxTipoTarCliCorpor.js"></script>
<script type="text/javascript"	src="dwr/interface/giroNegocioTarDebServicio.js"></script>
</head>
	<body>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="giroNegocioTarDebBean">
					<legend class="ui-widget ui-widget-header ui-corner-all">Giros de Negocio No Permitidos por Tipo Tarjeta y <s:message code="safilocale.cliente"/> Corporativo</legend>
						<br>
						    <table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									 <td class="label">
							  			<label for="tipoTarjeta">Tipo Tarjeta: </label>
									 </td>
									 <td >
										<input type="text" id="tipoTarjetaDebID" name="tipoTarjetaDebID" maxlength="20" tabindex="1" size="15"/>
										<input type="text" id="nombreTarjeta" name="nombreTarjeta" readOnly="true" size="45"/>
										<input type="text" id="tipoTarjeta" name="tipoTarjeta" readOnly="true" size="8"/>	
									</td>
					  			</tr>
								<tr>
									 <td class="label">
							  			<label for="fecha">Corporativo (Contrato): </label>
									 </td>
									 <td >
										<input type="text" id="coorporativo" name="coorporativo"  tabindex="2" size="15"  />
							
										<input type="text" id="nombreCoorp" name="nombreCoorp"   readOnly="true" size="54"  />	
									</td>
					  			</tr>
			  			</table>
						<br>
						<br>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							   <tr>	
									<td colspan="20">
									 <div id="gridGiroNegocioxTipoTarCliCorpor" style="display: none;" />							
									</td>
								</tr>
					    </table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"  tabindex="3" />
								<!--input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="4" /-->
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								<input type="hidden" id="tipoBaja" name="tipoBaja" />								
							</td>				
						</tr>
					</table>		
				</form:form>
			</fieldset>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
		<div id="mensaje" style="display: none;"></div>
</html>