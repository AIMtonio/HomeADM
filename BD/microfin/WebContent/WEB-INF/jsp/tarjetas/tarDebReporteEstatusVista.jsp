<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head> 
	
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="js/tarjetas/tarDebReporteEstatus.js"></script>  

</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarjetaDebitoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Solicitud de Tarjeta Nominativa por Estatus</legend>
	
			
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
		  		<legend>Par&aacute;metros</legend>
				<table>
					<tr>
						<td class="label" >
						<label for="lblFechaRegistro">Fecha Inicio:</label>
				        </td >
				 		<td >					
				 			 <input type="text" id="fechaRegistro" name="fechaRegistro" size="12" esCalendario="true"  tabindex="1" />	
				 		</td >
						 	<td class="separador"></td> 	
						<td   class="label">
						<label for="lblFechaVencimiento">Fecha Fin: </label>
					    </td>
					    <td>
				 		 	<input type="text" id="fechaVencimiento" name="fechaVencimiento" size="12" esCalendario="true"  tabindex="2" />	
						</td>
					</tr>
					<tr>
					
					 <td   class="label">
					  	<label for="lblEstatus">Estatus: </label>
				     </td>
					 <td >
					  <select id="estatus" name="estatus" tabindex="3" >
					  <option value="">SELECCIONA</option>
					   <option value="S">SOLICITADA</option>
					   <option value="G">GENERADA</option>
					   <option value="R">RECIBIDA</option>
					   <option value="C">CANCELADA</option>
					  </select>
			   	  	</td>
					</tr>
	 		</table>
		    </fieldset>
		    <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
				<tr>
					<td align="right">			
						<a id="ligaGenerar" href="TarDebReporteEstatus.htm" target="_blank" > 
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