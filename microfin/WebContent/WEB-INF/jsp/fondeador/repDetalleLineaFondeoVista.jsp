<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>

		<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>  
	   	<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/tiposLineaFonServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/creditoFondeoServicio.js"></script>
	   	
		<script type="text/javascript" src="js/fondeador/repDetalleLineaFondeo.js"></script>
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Detalle Cr&eacute;dito de Fondeo</legend>
	
		<form id="formaGenerica" name="formaGenerica" method="POST" commandName="lineaFondeador"  target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Par&aacute;metros</label></legend>         
          				<table  border="0"  width="560px">	
							<tr>
								<td class="label">
									<label for="institucionFondeo">Instituci&oacute;n: </label>
								</td> 
							   	<td>
									<input type="text" id="institutFondID" name="institutFondID"  size="12" tabindex="2"/>
								 	<input type="text" id="nombreInstitFondeo" name="nombreInstitFondeo" tabindex="3" size="50" disabled="disabled" /> 	 	
								</td>	
								<td colspan="3"></td>
							</tr>			
							<tr>
								<td class="label">
									<label for="lbllineaFondeo">L&iacute;nea Fondeo: </label>
								</td> 
								<td >
									<input type="text" id="lineaFondeoID" name="lineaFondeoID"  size="12" tabindex="4"  />
							        <textarea type="text" id="descripLinea" name="descripLinea" rows="2" cols="35" tabindex="5" 
						        		onblur="ponerMayusculas(this)" disabled="disabled"></textarea>
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblCreditoFond">Cr&eacute;dito Fondeo: </label>
								</td> 
								<td>
									<input type="text" id="creditoFondeoID" name="creditoFondeoID"   size="12" tabindex="6"  />
									<input type="text" id="folio" name="folio"   size="50" tabindex="6" disabled="disabled" />
								</td>
								<td colspan="3"></td>
							</tr>
						</table>
						</fieldset>  
					</td> 
					<td> 	
						<table width="200px"> 
							<tr>
						
							<td class="label" style="position:absolute;top:12%;">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="7"/>
									<label> PDF </label>
						            <br>
									<input type="radio" id="pantalla" name="pantalla" value="pantalla" tabindex="8">
								<label> Pantalla </label>				 	
								</fieldset>
								<input type="hidden" name="reporte" id="reporte" />
							</td>      
							</tr>
						</table>
					</td>
				<tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>								
					<td align="right" colspan="4">
					<a id="ligaImp" href="lineaFondeoRep.htm" target="_blank" >
		             		<button type="button" class="submit" id="imprimir" style="" tabindex="9">
		              		Imprimir
		             		</button> 
	            </a>					
					</td>
				</tr>
			</table>
		</form>
	</fieldset>
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>