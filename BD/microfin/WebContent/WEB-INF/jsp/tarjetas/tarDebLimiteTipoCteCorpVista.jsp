<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  

<html> 
	<head>
	 	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tarDebLimiteTipoCteCorpServicio.js"></script>
		<script type="text/javascript"	src="js/tarjetas/tarDebLimiteTipoCteCorp.js"></script> 
	</head>
	<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="limiteTarjetaDebitoCteBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Límites por Tipo de Tarjeta y <s:message code="safilocale.cliente"/> Corporativo</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label" >
					<label for="lblTipoTarjeta">Tipo de Tarjeta:</label>
					</td>
		       		 <td><input type="text" id="tipoTarjetaDebID" name="tipoTarjetaDebID" size="15" tabindex="1" />
		       		 </td>
					 <td><input type="text" id="descripcion" name="descripcion"  onblur="ponerMayusculas(this)"  size="35" readOnly="true"  />
					 	<input type="text" id="tipoTarjeta" name="tipoTarjeta"  onblur="ponerMayusculas(this)"  size="10" readOnly="true"  />
					 </td>		
				</tr>
				<tr>
					<td class="label" >
					<label for="lblclienteCorpID"><s:message code="safilocale.cliente"/> Corporativo:</label>
					</td>
		       		 <td><input type="text" id="clienteCorpID" name="clienteCorpID" size="15" tabindex="2" />
		       		 </td>
					 <td><input type="text" id="nombreClienteCorp" name="nombreClienteCorp"  onblur="ponerMayusculas(this)"  size="70" readOnly="true"  />
					 </td>		
				</tr>
				</table>
				
				<!-- limites tarjeta y cliente corporativo -->
			<div id="limitectecorporativo"> 
			<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<table>
				<tr>	  
					<td class="label">
					<label for="lblMontoDisDia"> Monto M&aacute;x. Dispo. Diario: </label>
					</td>
				<td>
					<input type="text" id="montoDisDia" name="montoDisDia" esMoneda="true"  size="20" tabindex="3" maxlength="12"/>
			    </td>
			    <td class="separador"></td>
				<td class="label">
					<label for="lblMontoDisMes"> Monto M&aacute;x. Dispo. Mensual: </label>
					</td>
				<td>
					<input type="text" id="montoDisMes" name="montoDisMes" esMoneda="true" size="20" tabindex="4" maxlength="12"/>
			    </td>
				</tr>
				<tr>
					<td class="label">
					<label for="lblMontoComDia"> Monto M&aacute;x. Compras. Diario: </label>
					</td>
				<td>
					<input type="text" id="montoComDia" name="montoComDia" esMoneda="true" size="20" tabindex="5" maxlength="12"/>
			    </td>
			    <td class="separador"></td>
				<td class="label">
					<label for="lblMontoComMes"> Monto M&aacute;x. Compras. Mensual: </label>
					</td>
				<td>
					<input type="text" id="montoComMes" name="montoComMes" esMoneda="true" size="20" tabindex="6" maxlength="12"/>
			    </td>
				</tr>
				<tr>	
					<td class="label">
						<label for="lblNumeroDia">N&uacute;mero Disposiciones al Día: </label>
					</td>
					<td> 
						<input type="text" id="numeroDia" name="numeroDia" size="5" tabindex="7" maxlength="5" />
			    	</td>
			    	<td class="separador"></td>
			    	<td class="label">
						<label >N&uacute;mero Consultas Mensual: </label>
					</td>
					<td>
						<input type="text" id="numConsultaMes" name="numConsultaMes" size="5" tabindex="8" maxlength="5"  />
					</td>
			  	</tr>
				<tr>
					<td class="label">
					<label for="lblBloqueoATM"> Bloqueo ATM: </label>
					</td>
				<td>
					<select id="bloqueoATM" name="bloqueoATM"  tabindex="9">
					   <option value="">SELECCIONA</option>
					   <option value="S">SI</option>
					  <option value="N">NO</option>
					</select>
			    </td>
			    <td class="separador"></td>
			    <td class="label">
					<label for="lblBloqueoPOS"> Bloqueo POS: </label>
					</td>
				<td> <select id="bloqueoPOS" name="bloqueoPOS"  tabindex="10" >
					   <option value="">SELECCIONA</option>
					     <option value="S">SI</option>
					  	<option value="N">NO</option>
					</select>
			    </td>
			    </tr>
			    <tr>
					<td class="label">
					<label for="lblBloqueoCash"> Bloqueo Cashback: </label>
					</td>
				<td> <select id="bloqueoCash" name="bloqueoCash"  tabindex="11" >
					   <option value="">SELECCIONA</option>
					     <option value="S">SI</option>
					 	 <option value="N">NO</option>
					</select>
			    </td>
			    <td class="separador"></td>
			   <td class="label">
					<label for="lblOperacionMoto"> Operaciones MOTO: </label>
					</td>
				  <td> <select id="operacionMoto" name="operacionMoto"  tabindex="12" >
					   <option value="">SELECCIONA</option>
					     <option value="S">SI</option>
					  	<option value="N">NO</option>
					</select>
			    </td>
			    </tr>							
			 </table>
		  </fieldset>
		   <br>
		 </div>
		     <!-- Fin limites tarjeta y cliente corporativo  -->
		     		
	<table width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="13" />
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="14" />
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