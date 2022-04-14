<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
    	<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>  
	   	<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/tiposLineaFonServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/condicionesDesctoCteLinFonServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/condicionesDesctoActLinFonServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/condicionesDesctoDestLinFonServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/condicionesDesctoEdoLinFonServicio.js"></script>                                                                                                                                                                                                                                                                                           
     	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
        <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/redesCueServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditoFondeoServicio.js"></script>
		
			   	
	   	<script type="text/javascript" src="js/fondeador/redesCuentoCatalogo.js"></script>
	   	<script type="text/javascript" src="js/fondeador/redesCuentoCreditos.js"></script>
	</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Integraci&oacute;n Cartera</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="redesCuentoBean">
		<table border="0" cellpadding="0" width="100%" >
			<tr>
				<td class="label">
					<label for="lblFecha">Fecha: </label>
				</td> 
				<td>
					<form:input id="fecha" name="fecha" size="9" path="fechaAsignacion" tabindex="1" esCalendario="true"/>
				</td>	
				<td class="separador"></td>
				<td class="label">
					<label for="institucionFondeo">Instituci&oacute;n : </label>
				</td> 
			   	<td>
					<form:input id="institutFondID" name="institutFondID"  path="institutFondeoID" size="3" tabindex="2"/>
				 	<input type="text" id="nombreInstitFondeo" name="nombreInstitFondeo" tabindex="3" size="30" disabled="disabled" /> 	 	
				</td>			
			</tr>
			<tr>
				<td class="label">
					<label for="lbllineaFondeo">L&iacute;nea Fondeo: </label>
				</td> 
				<td >
					<form:input id="lineaFondeoID" name="lineaFondeoID" path="lineaFondeoID" size="7" tabindex="4"  />
			        <textarea id="descripLinea" name="descripLinea" rows="2" cols="30" tabindex="5" 
		        		onblur="ponerMayusculas(this)" disabled="disabled"></textarea>
				</td>
				<td class="separador"></td>
                <td class="label">
					<label for="tipo">Tipo de L&iacute;nea de Fondeo: </label> 
				</td>
	   			<td nowrap="nowrap">
		 			<input id="tipoLinFondeaID" name="tipoLinFondeaID" size="3" tabindex="6" disabled="disabled"/>
					<textarea id="desTipoLinFondea" name="desTipoLinFondea" rows="2" cols="50" tabindex="7" 
		        		onblur="ponerMayusculas(this)" disabled="disabled"></textarea>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="monto">Monto Linea: </label> 
				</td>
	   			<td nowrap="nowrap">
		 			<input id="montoOtorgado" name="montoOtorgado"  size="15" tabindex="8"  
		 				esMoneda="true" disabled="disabled" />
		 				<label for="lblveces">(Otorgado)</label>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="tipo">Saldo: </label> 
				</td>
	   			<td nowrap="nowrap">
		 			<input id="saldoLinea" name="saldoLinea" size="15" tabindex="9" 
		 	 			esMoneda="true" disabled="disabled" />
     	 	 			<label for="lblveces">(Disponible)</label>
				</td>
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="lblCreditoFond">Cr&eacute;dito Fondeo: </label>
				</td> 
				<td>
					<form:input id="creditoFondeoID" name="creditoFondeoID" path="creditoFondeoID"  size="15" tabindex="10"  />
				</td>		
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="lblMontoCredito">Monto Cr&eacute;dito: </label> 
				</td>
				<td >
					<input id="montoCredito" name="montoCredito" size="15" tabindex="11" esMoneda="true" disabled="disabled"  	/>
				</td>
			</tr>
			<tr>
			    <td class="label" nowrap="nowrap">
					<label for="lblSaldoCredito">Saldo Cr&eacute;dito: </label> 
				</td>
				<td >
					<input id="saldoCapFon" name="saldoCapFon" size="15" tabindex="12" esMoneda="true" disabled="disabled" />
				    <label for="lblSaldoCredito1">(Insoluto Capital) </label>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="lblFechaCredito">Fecha Inicio Cr&eacute;dito: </label> 
				</td>
				<td>
					<input id="fechaInicioCred" name="fechaInicioCred" size="9" tabindex="12" disabled="disabled"/>
				</td> 
			</tr>
		</table>
		<table border="0" cellpadding="0" width="100%"> 
			<tr>
				<td colspan="5" align="right">
					<input type="button" id="verCreditos" name="verCreditos" class="submit" value="Ver Creditos" tabindex="13"/>
				</td>
			</tr>		 
			<tr>
			    <td colspan="11">
			    	<div id="gridCredFonAsig" style="overflow: scroll; width: 1000px; height: 300px;display: none;"></div>
				    							
				</td>						
			</tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right">			
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"   disabled="disabled" style="display: none;" />			
								<a id="ligaPDF" href="RepPDFCreditoAsig.htm" target="_blank" >
				             			<button type="button" class="submit" id="imprimirDetalle" style="display: none;">
				              			Imp. Detalle PDF
				             			</button> 
				             			</a>
				             	<a id="ligaExcel" href="RepPDFCreditoAsig.htm" target="_blank" >
				             			<button type="button" class="submit" id="imprimirDetalleEx" style="display: none;">
				              			Imp. Detalle Excel
				             			</button> 
				             			</a>		
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>
								</td>
							</tr>
						</table>		
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
<html>