<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>    
<html>
<head>	
       	<script type="text/javascript" src="dwr/interface/bitacoraPagoNominaServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/pagoNominaServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/aplicaPagoInstServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		      	
      	<!--<script type="text/javascript" src="js/nomina/aplicacionPagosCredNom.js"></script>-->
      	<script type="text/javascript" src="js/nomina/aplicacionPagosInst.js"></script>
      	
</head>
<body>

<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pagoInstBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Aplicaci&oacute;n Pago Instituci&oacute;n</legend>
		
<table border="0" cellpadding="1" cellspacing="0" width="100%">
	<table>
	  <tr>
		<td class="label" nowrap="nowrap">
			<label for="lblInstitucion">Empresa N&oacute;mina:</label>
		</td>
		<td nowrap="nowrap" colspan="4"> 
		   <form:input type="text" id="institNominaID" path="institNominaID" size="11" tabindex="1" iniforma="false"/>
		   <input type="text" id="nombreEmpresa" name="nombreEmpresa" size="40" disabled= "true" readonly="true" iniforma='false'/>
		</td>
	  </tr>
	  <tr>
		<td class="label"><label for="lblfechaInicio">Fecha Inicio: </label></td>
		<td>    			
			<input id="fechaInicio" name="fechaInicio"  size="12" tabindex="2" type="text"  esCalendario="true" />	
		</td>
		<td class="separador"></td>
		<td >
			<label for="lblFechaFin">Fecha Fin:</label>
			<input type="text" id="fechaFin" name="fechaFin" size="12" esCalendario="true" tabindex="3" />
		</td>
	  </tr>
	  <tr>
	    <td class="label"><label for="lblNumFolio">No. Folio:</label></td>
		<td colspan="4">
		   <form:input id="numFolio" name="numFolio" tabindex="4" path="numFolio" size="20" />
		</td>
	  </tr>
  </table>
  
  <!--  ================================ SECCION DETALLE  -->
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend><label>Presentaci&oacute;n</label></legend>
				<table border="0" cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td class="label"><label for="lblfechaDesc">Fecha Descuento: </label></td>
						<td colspan="4">
							<input id="fechaDescuento" name="fechaDescuento"  size="12" tabindex="10" type="text" disabled= "true" readonly="true" />	
						</td>
						<td nowrap="nowrap"  class="label"> 
							<label for="lblMontoTotalDesc">Monto total descuento:</label> 
						</td>
						<td>
							<input type="text" id="montoTotalDesc" name="montoTotalDesc" size="12"  tabindex="11" disabled= "true" readonly="true" style="text-align: right"/>
						</td>
					</tr>
					<tr>
						<td class="label"><label for="lblestatusDesc">Estatus Pago Descuento: </label></td>
						<td colspan="4">    			
							<input id="estatusPagoDescText" name="estatusPagoDescText"  size="12" tabindex="12" type="text" disabled= "true" readonly="true" />
							<input type="hidden" id="estatusPagoDesc" name="estatusPagoDesc" />
						</td>
						<td nowrap="nowrap"  class="label"> 
							<label for="lblestatusInst">Estatus Pago Instituci&oacute;n:</label> 
						</td>
						<td>
							<input type="text" id="estatusPagoInstText" name="estatusPagoInstText" size="12"  tabindex="13" disabled= "true" readonly="true"/>
							<input type="hidden" id="estatusPagoInst" name="estatusPagoInst" />
						</td>
					</tr>
					<tr>
						<td class="label"><label for="lblBanco">Banco:</label></td>
						<td colspan="4" nowrap="nowrap">
							<input type="text" id="institucionID" name="institucionID" tabindex="14" path="institucionID" size="11" />
							<input type="text" id="nombreInstitucion" name="nombreInstitucion" size="30"  disabled= "true" readonly="true" />  
						</td>
					</tr>
					<tr>
						<td class="label"><label for="lblCuentaDepo">Cuenta Dep&oacute;sito:</label></td>
						<td colspan="4">
							<form:input id="numCuenta" tabindex="15" path="numCuenta" size="20" type="text" />
						</td>
						<td class="label"><label for="lblMovConci">Movimiento Conciliado:</label></td>
						<td colspan="3" nowrap="nowrap">
							<input type="text" id="movConciliado" name="movConciliado" size="20" tabindex="16" />  
						</td>
					</tr>
					<tr>
						<td class="label"><label for="lblMontoPagoInst">Monto Pago Instituci&oacute;n:</label></td>
						<td colspan="4">
							<form:input id="montoPagoInst" tabindex="17" path="montoPagoInst" size="20" type="text" disabled= "true" readonly="true" style="text-align: right"/>
						</td>
						<td class="label"><label for="lblFechaPagoInst">Fecha Pago Instituci&oacute;n:</label></td>
						<td colspan="3" nowrap="nowrap">
						   <input type="text" id="fechaPagoInst" name="fechaPagoInst" size="12" esCalendario="true" tabindex="18" />  

						</td>
					</tr>
					<tr>
						<td colspan="7"></td>
					</tr>
					<tr>
						<td colspan="7"></td>
					</tr>
					<tr>
						<td colspan="7"></td>
					</tr>
					<tr>
						<td colspan="7">
							<div id="gridDescuento"  style="display:none" ></div>
						</td>
					</tr>
				</table>
				<br>
				<br>
				<br>
				<table border="0" cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td align="right" colspan="6">
							
								<input type="button" id="importar" name="importar" class="submit" value="Importar Cr&eacute;ditos No Aplicados" tabindex="20"/>
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td colspan="7">
							<div id="gridNoAplicados"  style="display:none" ></div>
						</td>
					</tr>
				 </table>
				<br>
				<br>
				<table border="0" cellpadding="2" cellspacing="0" width="98.5%">
				  <tr>
				    <td class="separador" colspan="6"></td>
					<td>
						<label for="lblTotal">Total:</label>
						<input type="text" id="totalPagos" name="totalPagos" tabindex="50"  readOnly="true" size="12" disabled="true" style="text-align: right" />
						<input type="hidden" id="totalAcumulado" name="totalAcumulado"  readOnly="true" size="12" disabled="true" style="text-align: right" />
						<input type="hidden" id="totalGridPagos" name="totalGridPagos"  readOnly="true" size="12" disabled="true" style="text-align: right" />
						<input type="hidden" id="totalGridNoaplicados" name="totalGridNoaplicados"  readOnly="true" size="12" disabled="true" style="text-align: right" />
					</td>
				  </tr>
				 </table>
				<br>
				<br>
				 <table border="0" cellpadding="2" cellspacing="0" width="100%">
						<tr>
							<td align="right">
								<input type="submit" id="realizarPagos" name="realizarPagos" class="submit" value="Aplicar" tabindex="60" />
								<input type="submit" id="cancelarPagos" name="cancelarPagos" class="submit" value="Reversar" tabindex="61" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								<input type="hidden" id="fechaAplica" name="fechaAplica" />
								<input type="hidden" id="aplicaTodos" name="aplicaTodos"  value="N"/>
							</td>
						</tr>
				
				 </table>
			</fieldset>
		</td>
	</tr>
	<tr>

  	<td>
  	
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