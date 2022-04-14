<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
<head>

<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaComPrepagoCreditoServicio.js"></script>
<script type="text/javascript" src="js/credito/esquemaComPrepagoCredito.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica"  method="POST" commandName="esquemaComPrepagoCredito">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Esquema Comisión Liquidación Anticipada</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" >
		<tr>
			<td >
				<label for="producCreditoID">Producto Crédito: </label>
			</td>
			<td >
				<form:input id="productoID" name="productoID"   size="10" tabindex="1" path="productoID" />
				<input type="text" id="descripcion" name="descripcion" size="40" tabindex="2" disabled="true" readOnly="true" iniForma="false"/>
			</td>
		</tr>
		<tr>
		<td class="label" nowrap="nowrap">
				<label for="permiteLiqAntici">Permite Liquidación: </label>
			</td>
		  	      <td>
		  		
				  <form:select id="permiteLiqAntici" name="permiteLiqAntici"  path="permiteLiqAntici" tabindex="3">
					<form:option value="">Selecciona</form:option>
					<option value="S">SI</option> 
				    <option value="N">NO</option>
					</form:select>
			      </td>
		
			<td class="label" nowrap="nowrap">
				<label for="cobraComLiqAntici">Comisión Por Liquidación: </label>
			</td>
		  	<td>
				<form:select id="cobraComLiqAntici" name="cobraComLiqAntici"  path="cobraComLiqAntici" tabindex="4">
				    <form:option value="">Selecciona</form:option>
					<option value="S">SI</option> 
				    <option value="N">NO</option>
					</form:select>
				
			 </td>
		</tr>
			<tr>
		
			<td class="label" nowrap="nowrap">
				<label for="tipComLiqAntici">Tipo Comisión Liquidación<br> Anticipada: </label>
			</td>
		  	<td>
				<form:select id="tipComLiqAntici" name="tipComLiqAntici"  path="tipComLiqAntici" tabindex="5">
					<option value="">Selecciona</option>
					<option value="P">Proyección de Interes</option> 
				    <option value="S">Porcentaje de Saldo Insoluto</option>
				    <option value="M">Monto Fijo</option>
					</form:select>
			</td>
			</tr>
			<tr>
	 	
			<td class="label">
					<label for="comisionLiqAntici">Comisión:</label>
				</td>
				<td>
					<form:input id="comisionLiqAntici" name="comisionLiqAntici" path="comisionLiqAntici" Value='' autocomplete="off" onkeyPress="return Validador(event);" tabindex="6" />
				</td>		
				<td class="label">
					<label for="diasGraciaLiqAntici">Dias Gracia: </label>
					</td>
				<td>
					<form:input id="diasGraciaLiqAntici" name="diasGraciaLiqAntici" path="diasGraciaLiqAntici" Value='' autocomplete="off" onkeyPress="return Validador(event);" tabindex="7" />
				</td>												
		    </tr>
		</table>
		
		
		<table align="right">
			<tr>
				<td align="right">
				
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="8"/>
					<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="9"/>
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