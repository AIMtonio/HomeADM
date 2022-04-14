<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>	
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>	
	<script type="text/javascript" src="dwr/interface/limiteOperClienteServicio.js"></script>
	<script type="text/javascript" src="js/cliente/limiteOperCliente.js"></script>
</head>
<body>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Límite de Operaciones por <s:message code="safilocale.cliente"/> </legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="limiteOperClienteBean" target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">							
				<tr>  					
					<td class="label" nowrap="nowrap"><label for="lblLimiteOperID">Número: </label></td> 
				    <td nowrap="nowrap"> 
				    	<input type="text" id="limiteOperID" name="limiteOperID" size="12" tabindex="1" autocomplete="off" iniforma='false' /> 
				    </td>
				    <td class="separador"></td> 
				    <td class="label" nowrap="nowrap"> 
				         <label for="lblClienteID">No. de <s:message code="safilocale.cliente"/>: </label> 
					</td>
				    <td nowrap="nowrap">
				    	<input type="text" id="clienteID" name="clienteID" size="15" disabled="disabled" readonly="true" tabindex="2"/>  
				        <input type="text" id="nombreCompleto" name="nombreCompleto" size="50" disabled= "true" readonly="true" tabindex="3"/>  
					</td> 				  	
				</tr>			
				<tr>  
					<td class="label" nowrap="nowrap"><label for="lblBancaMovil">Banca Móvil: </label></td>
					<td class="label" nowrap="nowrap"> 
						<form:radiobutton id="bancaMovil1" name="bancaMovil" path="bancaMovil" value="S" tabindex="4"/>
						<label for="S">Si</label>&nbsp;&nbsp;
						<form:radiobutton id="bancaMovil2" name="bancaMovil"  path="bancaMovil" value="N" tabindex="5" checked="checked"/>
						<label for="N">No</label>					
					</td>	
				</tr>	
				<tr id="trMontoMaxBcaMovil">
					<td class="label" nowrap="nowrap"><label for="lblMonMaxSpeiBcaMovil">Monto Máximo Banca Movil: </label></td>
					<td><input type="text" id="monMaxBcaMovil" name="monMaxBcaMovil" size="15"  style="text-align: right" esmoneda="true" tabindex="6"/></td>
				</tr>						
			</table>
			</br>
		
			<table align="right">		
			<tr>		
				<td align="right">
					<table align="right" border='0'>
						<tr align="right">					
							<td align="right">
							  <a target="_blank" >									  				
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="7"/>
								<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="8"/>								
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>					
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>										             		 
			                  </a>
							</td>
						</tr>
					</table>		
				</td>
			</tr>
			</table>
		</form:form>
	</fieldset>	
</div>
<div id="cargando" style="display: none;">	
</div>				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>	
<div id="mensaje" style="display: none;"/>
</html>