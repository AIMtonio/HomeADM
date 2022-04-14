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

<script type="text/javascript" src="dwr/interface/solicitudesCreAsigServicio.js"></script>
<script type="text/javascript" src="js/originacion/solicitudCreAsig.js"></script>

</head>
<c:set var="tipoCatalogo" value="${tipoCatalogo}" />
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="analistasAsignacionBean" >
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all"> Reasignaci&oacute;n de Sol&iacute;citud de Cr&eacute;dito </legend>
		
	 <table >
	    <tr>
		
			<td class="label">
			   <label  for="lblAnalistasAsignacion">Solicitud</label> 
			</td> 
				<td nowrap="nowrap">

				<input type="text" id="solicitudCreditoID"  tabindex="3"  name="solicitudCreditoID" size="10"  value="${solicitudCreditoID}" />
				
			   <input type="text" id="descripcion" name="descripcion" size="50" disabled="true " />         	  
			</td>

	
		</tr>
	 		<tr>
		
			<td class="label">
			   <label  for="lblAnalistasAsignacion">Analista Asignado</label> 
			</td> 
				<td nowrap="nowrap">

				<input type="text" id="usuarioAnalista"  tabindex="3"  name="usuarioAnalista" disabled="true" size="10"  value="${usuarioAnalista}" />
				
			   <input type="text" id="nombreCompleto" name="nombreCompleto" size="50" disabled="true " />         	  
			</td>

		</tr>

		<tr>
		
			<td class="label">
			   <label  for="lblAnalistasAsignacion">Nuevo Analista</label> 
			</td> 
				<td nowrap="nowrap">

				<input type="text" id="usuarioID"  tabindex="3"  name="usuarioID" size="10"  value="${usuarioID}" />
				
			   <input type="text" id="nombreCompletoi" name="nombreCompletoi" size="50" disabled="true " />         	  
			</td>
		</tr>
	
	    
 		
 	  </table>
 
					<table style="margin-left:auto;margin-right:0px">
							<tr>
								<td>
									<input type="button" class="submit" value="Reasignar" id="grabarAE" tabindex="4 " />
								</td>
							</tr>
				    </table>
				    	<input id="tipoTransaccion" type="hidden" name="tipoTransaccion" />
							<input id="productoID" type="hidden" name="productoID" />
							<input id="tipoAsignacionID" type="hidden" name="tipoAsignacionID" />
			
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