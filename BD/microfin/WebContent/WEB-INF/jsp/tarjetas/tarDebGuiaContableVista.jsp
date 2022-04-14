<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tarDebGuiaContableServicio.js"></script>
		<script type="text/javascript" src="js/tarjetas/tarDebGuiaContable.js"></script>
	</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable de Tarjeta</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="guiaTarDeb">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Cuentas Mayor</legend>
					<table border="0" width="100%">
						<tr>
					   	<td class="label"> 
					         <label for="lblconceptoCajaID">Concepto:</label> 
					     	</td>
					     	<td>
			         			<select id="conceptoTarDeb" name="conceptoTarDeb" tabindex="1">
									<option value="-1">SELECCIONAR</option>
								</select>
					     	</td>
						</tr>
						<tr>
							<td class="label"> 
					        	<label for="lblcuenta">Cuenta:</label> 
					     	</td>
					     	<td>
								<input id="cuenta" name="cuenta"  size="13" tabindex="2" />
							</td>  		
						</tr>
						<tr>
					      <td class="label">
					         <label for="lblnomenclatura">Nomenclatura:</label>
					     	</td>
					     	<td>
					     		<input id="nomenclatura" name="nomenclatura"  size="25" tabindex="3" maxlength="30" /> 
					         	<a href="javaScript:" onClick="ayuda();">
									<img src="images/help-icon.gif" >
								</a> 
					     	</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblClaves"><b>Claves de Nomenclatura Cuentas:
					         		<i><br>
					         			<a href="javascript:" onClick="insertAtCaret('nomenclatura','&CM');return false;">  &CM = Cuentas de Mayor </a>
					         		</i>
								</label>
							</td>
						</tr> 
						<tr> 
					      <td class="label"> 
					         <label for="lblnomenclaturaCR">Nomenclatura Centro Costo:</label> 
					     	</td>
					     	<td>
					     		<input id="nomenclaturaCR" name="nomenclaturaCR"  size="25" tabindex="4" /> 
								<a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a> 
					     	</td>  	
						</tr> 
						<tr>
							<td class="label"> 
					         <label for="lblClaves"><b>Claves de Nomenclatura  Centro Costo: 	
					         <i>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCR','&SO');return false;">  &SO = Sucursal Origen </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCR','&SC');return false;">  &SC = Sucursal <s:message code="safilocale.cliente"/></a></b> </label> 
					     		</i>	
					     	</td>
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaCM" name="grabaCM" class="submit" value="Grabar"  tabindex="4"/>
								<input type="submit" id="modificaCM" name="modificaCM" class="submit" value="Modificar" tabindex="5"/>
								<input type="submit" id="eliminaCM" name="eliminaCM" class="submit" value="Eliminar" tabindex="6"/>
								<input type="hidden" id="tipoTransaccionCM" name="tipoTransaccionCM" value="tipoTransaccionCM"/>
							</td>
						</tr>
					</table>
				</fieldset>
		</form:form>
</fieldset>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"> </div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
</html>