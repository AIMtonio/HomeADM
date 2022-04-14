<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
<head>

<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/rolesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="js/originacion/chekInOutAnalista.js"></script>

</head>
<c:set var="tipoCatalogo" value="${tipoCatalogo}" />
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="usuario" >
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Check-In/out de Analista </legend>

		<table id="tbParametrizacion" border="0" width="350px">
			<tr>
				<td class="label">
				   <label for="lblPerfilesAnalistasCre">Analista</label> 
				</td> 
				<td> 
				   <input type="text" id="nombreCompleto" name="nombreCompleto" size="50" disabled="true " />         	  
			    </td>	
			</tr>
			<tr>
				<td class="label">
				  <label for="lblPerfilesAnalistasCre">Estatus</label> 
				</td> 
				<td> 
				   <input type="text" id="estatusAnalisis" name="estatusAnalisis" size="50" disabled="true " />         	  
				</td>	
			</tr>

		</table>
		<table style="margin-left:auto;margin-right:0px">
			<tr>
				<td>
				<input type="button" class="submit" value="Actualizar" id="Actualizar" tabindex="4 " />
				</td>
			</tr>
			<tr>
				<td>
				<input id="usuarioID" type="hidden"   name="usuarioID" />
				<input id="tipoActualizacion" type="hidden" name="tipoActualizacion" />

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