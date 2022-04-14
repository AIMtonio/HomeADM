<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
<head>

<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaComisionCreServicio.js"></script>
<script type="text/javascript" src="js/credito/esquemaComisionCredito.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica"  method="POST" commandName="esquemaComisionCreBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Esquema de Comisión por Falta de Pago</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" >
		<tr>
			<td class="label" nowrap="nowrap">
				<label for="producCreditoID">Producto Crédito: </label>
			</td>
			<td>
				<input id="producCreditoID" name="producCreditoID" size="10" tabindex="1"  />
				<input type="text" id="descripcion" name="descripcion" size="40" tabindex="2" disabled="true" readOnly="true" iniForma="false"/>
			</td>
			<td class="separador"></td>
			<td class="label" nowrap="nowrap">
				<label for="tipoPagoComFalPago">Tipo de Pago: </label>
			</td>
			<td>
				<form:select id="tipoPagoComFalPago" name="tipoPagoComFalPago"  path="tipoPagoComFalPago" tabindex="3">
					<option value="">SELECCIONAR</option> 
					<option value="C">EN CADA CUOTA</option> 
				    <option value="F">AL FINAL DE LA PRELACI&Oacute;N</option>
				</form:select>
			</td>
		</tr>
		<tr>
			<td class="label" nowrap="nowrap">
				<label for="criterioComFalPag">Base de Cálculo: </label>
			</td>
		  	<td>
				<form:select id="criterioComFalPag" name="criterioComFalPag"  path="criterioComFalPag" tabindex="4">
					<option value="">SELECCIONAR</option> 
					<option value="C">MONTO ORIGINAL DE LA CUOTA (Capital)</option> 
				    <option value="T">MONTO ORIGINAL DE LA CUOTA (Capital + Int + IVA)</option>
				    <option value="S">SALDO DE LA CUOTA</option>
				</form:select>
			</td>
			<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="montoMinComFalPag">Mínimo de la Cuota:</label>
				</td>
				<td>
					<form:input id="montoMinComFalPag" name="montoMinComFalPag" path="montoMinComFalPag" size="10" tabindex="5" esMoneda="true"/>
	         		<label>0.- No hay límite</label>
	         		
	    		</td>
	    														
		</tr>
		<tr>
			<td class="label" nowrap="nowrap">
				<label for="lbltipCobComFalPago">Tipo Comisión Falta de Pago: </label>
			</td>
		  	<td>
				<form:select id="tipCobComFalPago" name="tipCobComFalPago"  path="tipCobComFalPago" tabindex="6">
					<option value="">SELECCIONAR</option> 
					<option value="A">COBRO POR AMORTIZACI&Oacute;N</option> 
					<option value="C">UN COBRO SIMULT&Aacute;NEO POR CR&Eacute;DITO</option> 
				    </form:select>
			</td>
			<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="lblperCobComFalPag">Periodicidad en el Cobro:</label>
				</td>
				<td>
					<form:select id="perCobComFalPag" name="perCobComFalPag"  path="perCobComFalPag" tabindex="7">
						<option value="">SELECCIONAR</option> 
						<option value="D">DIARIAMENTE</option> 
						<option value="C">POR INCUMPLIMIENTO</option> 
				    </form:select>
	    		</td>
	    														
		</tr>
		<tr id=esGrupal>
			<td class="label" nowrap="nowrap">
				<label for="lblprorrateoComFalPag">Prorrateo Com. Falta de Pago: </label>
			</td>
		  	<td>
				<form:select id="prorrateoComFalPag" name="prorrateoComFalPag"  path="prorrateoComFalPag" tabindex="8">
					<option value="N">NO</option> 
					<option value="S">NO</option> 
				</form:select>
			</td>
		</tr>
		</table>
		<input type="hidden" id="datosGrid" name="datosGrid" size="100" />
		<div id="gridEsquemaComision" name="gridEsquemaComision" style="display: none;">
		</div>	
		
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="50"/>
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