<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	 
		<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/tiposLineaFonServicio.js"></script>
	   	<script type="text/javascript" src="js/fondeador/tipoLineaFondeo.js"></script>	   	
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposLineaFondea">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de L&iacute;nea de Fondeo</legend>						
	<table >
	
		<tr>
			<td class="label">
				<label for="institucionFon">Instituci&oacute;n de Fondeo: </label>
			</td>
			<td >
				<input type="text"  id="institutFondID" name="institutFondID" path="institutFondID" size="7" tabindex="1" maxlength="8"/>
				<input type="text" id="nombreInstitFon" name="nombreInstitFon"  maxlength="20" size="50" 
				 	 disabled="true" readOnly="true"/>	 	
			</td>					
		</tr>
		<tr>
			<td class="label">
				<label for="tipoLinea">Tipo L&iacute;nea: </label> 
			</td>
			<td>
				<input  type="text" id="tipoLinFondeaID" name="tipoLinFondeaID" path="tipoLinFondeaID" size="7" tabindex="2" maxlength="8"/>
	    	</td>
		</tr>	
		<tr>	
			<td class="label">
				<label for="descripcion">Descripci&oacute;n: </label> 
			</td>
			<td>
				<textarea  type="text" id="descripcion" name="descripcion" path="descripcion" rows="2" cols="50" tabindex="3" onblur="ponerMayusculas(this)" 
				maxlength="50" class="valid" ></textarea>
			</td>
		</tr>
		
		<tr>
			<td colspan="2" align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" 
				 value="Agrega" tabindex="5"/>
				<input type="submit" id="modifica" name="modifica" class="submit" 
				 value="Modifica" tabindex="6"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		 
			</td>
		</tr>
	</table>		 
</fieldset>
</form:form> 

</div> 
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
<html>
	