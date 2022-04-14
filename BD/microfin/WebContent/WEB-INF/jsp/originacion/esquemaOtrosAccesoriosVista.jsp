<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>

<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/otrosAccesoriosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaOtrosAccesoriosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/nivelCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
<script type="text/javascript" src="js/originacion/esquemaOtrosAccesorios.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica"  method="POST" commandName="esquemaOtrosAccesorios">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Esquema de Otros Accesorios</legend>
		<table >
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="producCreditoID">Producto Cr&eacute;dito: </label>
				</td>
				<td>
					<input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="10" tabindex="1"  />
					<input type="text" id="descripcion" name="descripcion" path="descripcion" size="40" tabindex="2" disabled="true" readOnly="true" iniForma="false"/>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="accesorioID">Accesorio: </label>
				</td>
				<td>
					<select id="accesorioID" name="accesorioID" path="accesorioID" tabindex="3">
						<option value="">SELECCIONAR</option> 
					</select> 				
				</td>
			</tr>
			<tr id="rowInstitucionNomina">
				<td class="label" nowrap="nowrap">
					<label for="institNominaID">Empresa Nómina: </label>
				</td>
			  	<td>
			  		<input id="institNominaID" name="institNominaID" path="institNominaID" size="10" tabindex="4"  />
					<input type="text" id="descripcionInstitucionNomina" name="descripcionInstitucionNomina" path="descripcionInstitucionNomina" size="40" tabindex="5" disabled="true" readOnly="true" iniForma="false"/>
				</td>														
			</tr>
			<tr>
	 			<td class="label" nowrap="nowrap">
					<label for="cobraIVA">Cobra IVA: </label>
				</td>
				<td>
					<select id="cobraIVA" name="cobraIVA" path="cobraIVA" tabindex="6">
						<option value="">SELECCIONAR</option> 
						<option value="S">SI</option> 
					    <option value="N">NO</option>
					</select>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="formaCobro">Tipo Forma de Cobro: </label>
				</td>
				<td>
					<select id="formaCobro" name="formaCobro"  path="formaCobro" tabindex="7">
						<option value="">SELECCIONAR</option> 
						<option value="F">FINANCIAMIENTO</option> 
					    <option value="D">DEDUCCI&Oacute;N</option>
					    <option value="A">ANTICIPADO</option>
					</select>
				</td>			
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="generaInteres">Genera Inter&eacute;s: </label>
				</td>
				<td>
					<select id="generaInteres" name="generaInteres" path="generaInteres" tabindex="8">
						<option value="">SELECCIONAR</option> 
						<option value="S">SI</option> 
					    <option value="N">NO</option>
					</select>
				</td>
				<td class="separador"></td>
				<td class="label cobraIVAInteresControl" nowrap="nowrap">
					<label for="cobraIVAInteres">Cobra IVA Inter&eacute;s: </label>
				</td>
				<td class="cobraIVAInteresControl">
					<select id="cobraIVAInteres" name="cobraIVAInteres" path="cobraIVAInteres" tabindex="9">
						<option value="">SELECCIONAR</option> 
						<option value="S">SI</option> 
					    <option value="N">NO</option>
					</select>
				</td>
			</tr>
			<tr>
				 <td class="label" nowrap="nowrap">
					<label for="tipoPago">Tipo de Pago: </label>
				</td>
			  	<td>
					<select id="tipoPago" name="tipoPago"  path="tipoPago" tabindex="10">
						<option value="">SELECCIONAR</option> 
						<option value="M">MONTO FIJO</option> 
						<option value="P">PORCENTAJE</option> 
					</select>
				</td>	
				<td class="separador"></td>
				<td id="ldbBaseCalculo" class="label" nowrap="nowrap">
					<label for="baseCalculo">Base de C&aacute;lculo: </label>
				</td>
			  	<td>
					<select id="baseCalculo" name="baseCalculo"  path="baseCalculo" tabindex="11">
						<option value="">SELECCIONAR</option> 
						<option value="C">MONTO ORIGINAL</option> 
					</select>
				</td>	 				
			</tr>
		</table>

		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="12"/>
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="13"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="montoMinimoCredito" name="montoMinimoCredito"/>
					<input type="hidden" id="montoMaximoCredito" name="montoMaximoCredito"/>
					<input type="hidden" id="productoCreditoNomina" name="productoCreditoNomina"/>
					<input type="hidden" size = "5" id="estatusProducCredito" name="estatusProducCredito"/>
				</td>
			</tr>
		</table>

		<table width="100%">
			<tr>
				<td>
					<div id="gridEsquemaOtrosAccesorios" name="gridEsquemaOtrosAccesorios" style="display: none;"></div>
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
<div id="mensaje" style="display: none;"></div>
</body>
</html>