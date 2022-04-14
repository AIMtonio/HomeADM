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
		
			   	
	   	<script type="text/javascript" src="js/fondeador/baseCreditoFommur.js"></script>
	</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Base Cr&eacute;dito Fommur</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="redesCuentoBean">
		<table border="0" cellpadding="0" width="100%" >
		<tr>
			<td nowrap="nowrap">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                        
          		<table  border="0"  width="560px">
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblFecha">Fecha: </label>
						</td> 
						<td nowrap="nowrap">
							<form:input id="fecha" name="fecha" size="9" path="fechaAsignacion" tabindex="1" esCalendario="true"/>
						</td>	
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="institucionFondeo">Instituci&oacute;n : </label>
						</td> 
					   	<td nowrap="nowrap">
							<form:input id="institutFondID" name="institutFondID"  path="institutFondeoID" size="3" tabindex="2"/>
						 	<input type="text" id="nombreInstitFondeo" name="nombreInstitFondeo" tabindex="3" size="30" disabled="disabled" /> 	 	
						</td>			
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lbllineaFondeo">L&iacute;nea Fondeo: </label>
						</td> 
						<td nowrap="nowrap">
							<form:input id="lineaFondeoID" name="lineaFondeoID" path="lineaFondeoID" size="7" tabindex="4"  />
					        <textarea id="descripLinea" name="descripLinea" rows="2" cols="30" tabindex="5" 
				        		onblur="ponerMayusculas(this)" disabled="disabled"></textarea>
						</td>
						<td class="separador"></td>
		                <td class="label" nowrap="nowrap">
							<label for="tipo">Tipo de L&iacute;nea de Fondeo: </label> 
						</td>
			   			<td nowrap="nowrap">
				 			<input id="tipoLinFondeaID" name="tipoLinFondeaID" size="3" tabindex="6" disabled="disabled"/>
							<textarea id="desTipoLinFondea" name="desTipoLinFondea" rows="2" cols="50" tabindex="7" 
				        		onblur="ponerMayusculas(this)" disabled="disabled"></textarea>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblCreditoFond">Cr&eacute;dito Fondeo: </label>
						</td> 
						<td nowrap="nowrap">
							<form:input id="creditoFondeoID" name="creditoFondeoID" path="creditoFondeoID"  size="15" tabindex="10"  />
						</td>		
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="lblFechaCredito">Fecha Inicio Cr&eacute;dito: </label> 
						</td>
						<td nowrap="nowrap">
							<input id="fechaInicioCred" name="fechaInicioCred" size="9" tabindex="12" disabled="disabled"/>
						</td> 
					</tr>
				</table>
				</fieldset>
				</td>
				<td nowrap="nowrap">
					<table width="200px"> 
						<tr>
					
						<td class="label" style="position:absolute;top:12%;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Presentaci&oacute;n</label></legend>
								<input type="radio" id="excel" name="excel" value="excel" />
								<label> Excel </label>
					            <br>
								<input type="radio" id="pdf" name="pdf" value="pdf">
							<label> PDF </label>				 	
							</fieldset>
							<input type="hidden" name="reporte" id="reporte" />
							<input type="hidden" name="lista" id="lista" />
						</td>      
						</tr>
					</table>
				</td>
				</tr>	
		</table>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>								
					<td align="right" colspan="4">
					<a id="ligaImp" href="repBaseCredFommur.htm" target="_blank" >
		             		<button type="button" class="submit" id="imprimir" style="">
		              		Imprimir
		             		</button> 
	            </a>					
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