<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
<head>

<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>

<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/rolesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/analistasAsignacionServicio.js"></script>
<script type="text/javascript" src="js/originacion/analistasAsignacionVista.js"></script>

</head>
<c:set var="tipoCatalogo" value="${tipoCatalogo}" />
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="analistasAsignacionBean" >
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all"> Asignaci&oacute;n Sol&iacute;citudes de Cr&eacute;dito </legend>
		
	 <table >
			<tr>
			<td class="label">
		    <label for="lblAnalistasAsignacion">Tipo de Asignaci&oacute;n: </label>
	       </td>
			<td>					
				<select id="tipoAsignacionID" name="tipoAsignacionID" path="tipoAsignacionID" tabindex="4">
					<option value="">SELECCIONAR</option>
				</select>
			</td>
		</tr>	

		<tr>
			<td class="label">
			    <label id="xx" for="lblAnalistasAsignacionProd">Producto:</label> 
			</td> 
			<td nowrap="nowrap">

			<input type="text" id="productoID"  tabindex="1"  name="productoID" size="10"  onblur="ponerMayusculas(this)"  value="${productoID}"    />
					<input type="text" id="descripcion" name="descripcion" size="50" disabled="true " />         	  
			</td>	
		</tr>
		<tr>
		
			<td class="label">
			   <label  for="lblAnalistasAsignacion">Usuario:</label> 
			</td> 
				<td nowrap="nowrap">

				<input type="text" id="usuarioIDi"  tabindex="3"  name="usuarioIDi" size="10"  value="${usuarioIDi}" />
				
			   <input type="text" id="nombreCompleto" name="nombreCompleto" size="50" disabled="true " />         	  
			</td>
			<td>
			<input type="button" onclick="agregarDetalle('tbAnalistasAsignacion')" class="submit" value="Agregar" id="agregarAnalistasAsig" tabindex="200"/>
			</td>
		</tr>
	
	    
 		
 	  </table>
      <fieldset class="ui-widget ui-widget-content ui-corner-all" >	
	  <table border="0" width="100%">
					<tr>
					<c:choose>

					  <tr>
						<c:when test="${tipoCatalogo == '1'}">
						<td colspan="5" valign="top">
							<div id="gridAsignacionAnalistas"></div>
						</td>
						</c:when>
				       </tr>
					</c:choose>
					</tr>
		
					<tr>
						<td>
							<input id="detalleAsignacion" type="hidden" name="detalleAsignacion" />
							<input id="tipoTransaccion" type="hidden" name="tipoTransaccion" />
						</td>
					</tr>
				</table>
		</fieldset>	
					<table style="margin-left:auto;margin-right:0px">
							<tr>
								<td>
									<input type="button" class="submit" value="Guardar" id="grabarAE" tabindex="4 " />
								</td>
							</tr>
				    	</table>
			
	</fieldset>		
					
</form:form> 
</div> 

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje"  style='display: none;'></div>
</html>