<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
<head>


<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/solicitudesCreAsigServicio.js"></script>
<script type="text/javascript" src="js/originacion/solicitudCreAsigMasiva.js"></script>

</head>
<c:set var="tipoCatalogo" value="${tipoCatalogo}" />
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="analistasAsignacionBean" >
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all"> Reasignaci&oacute;n Masiva de Sol&iacute;citudes de Cr&eacute;dito </legend>
		
	 <table >
		
			<td class="label">
			   <label  for="lblAnalistasAsignacion">Analista</label> 
			</td> 
			<td nowrap="nowrap">
				<input type="text" id="usuarioID"  tabindex="1"  name="usuarioID" size="10"  value="${usuarioID}" />
			    <input type="text" id="nombreAnalista" name="nombreAnalista" size="50" disabled="true " />         	  
			</td>	
	<table style="margin-left:auto;margin-right:0px">
			<tr>
				<td>
					<input type="button" class="submit" value="Reasignar" id="grabarAE" tabindex="2" />
				</td>
			</tr>
    </table>
 		
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
					<input id="listaAsignacionSol" type="hidden" name="listaAsignacionSol" />
					<input id="tipoTransaccion" type="hidden" name="tipoTransaccion" />

				</td>
			</tr>
		</table>
		</fieldset>	
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