<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head> 
		<script type="text/javascript"	src="dwr/interface/tarDebMovimientosServicio.js"></script>
		<script type="text/javascript" src="js/tarjetas/movsTarjetaDebito.js"></script>  

</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarjetaDebitoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Movimientos de Tarjeta</legend>
	
			
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
		  		<legend>Par&aacute;metros</legend>
				<table>
					<tr>
						<td class="label" >
							 <input type="hidden" name="tipoTarjeta" id="tipoTarjeta" value="1">
							<label> Tipo de Tarjeta</label>
						</td>
						<td class="label">
							
							<input type="radio" id="tipoTarjetaDeb" name="tipoTarjetaDeb">
							<label> D&eacute;bito</label>
							<input type="radio" id="tipoTarjetaCred" name="tipoTarjetaCred">
							<label> Cr&eacute;dito </label>
						</td>
					</tr>
					<tr>
						<td class="label" >
						<label for="lblFechaInicio">Fecha Inicio:</label>
				        </td >
				 		<td >					
				 			 <input type="text" id="fechaInicio" name="fechaInicio" size="12" esCalendario="true"  tabindex="1" />	
				 		</td >
				 			</tr>
				 				<tr>
						 	
						<td   class="label">
						<label for="lblFechaVencimiento">Fecha Fin: </label>
					    </td>
					    <td>
				 		 	<input type="text" id="fechaVencimiento" name="fechaVencimiento" size="12" esCalendario="true"  tabindex="2" />	
						</td>
					</tr>
					<tr>
					
					 <td   class="label">
					  	<label for="lblTipoOperacion">Tipo Movimiento: </label>
				     </td>
					 <td >
					  <select id="tipoOperacion" name="tipoOperacion" tabindex="3" >
					   <option value="3">TODOS</option>
					   <option value="4">EXITOSOS</option>
					   <option value="5">RECHAZADOS</option>
					  
					  </select>
			   	  	</td>
					</tr>
	 		</table>
		    </fieldset>
		    <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
				<tr>
					<td align="right">			
						<a id="ligaGenerar" href="movsTarjetaDebitoReporte.htm" target="_blank" > 
					<button type="button" class="submit" id="generar" tabindex="4" >Generar</button> 	
						</a>										
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