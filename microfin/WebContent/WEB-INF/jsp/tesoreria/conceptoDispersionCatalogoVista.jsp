<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	     
		<script type="text/javascript" src="dwr/engine.js"></script>
		<script type="text/javascript" src="dwr/util.js"></script>     
		<script type="text/javascript" src="dwr/interface/conceptoDispersionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="js/forma.js"></script>
		<script type="text/javascript" src="js/tesoreria/conceptoDispersion.js"></script>	      
	</head>
   	
	<body>
	<div id="contenedorForma">

		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend class="ui-widget ui-widget-header ui-corner-all">Conceptos de Dispersi&oacute;n</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="conceptoDispersion">  	
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label"> 
			         		<label id="labelConcepto" for="lblConcepto">N&uacute;mero: </label> 
			     		</td>
			     		<td>
							<form:input type="text" id="conceptoID" name="conceptoID" path="conceptoID" size="10" tabindex="1" iniforma="false"/> 
	  					</td>
					</tr>
					<tr>
						<td class="label"> 
			         		<label id="labelNombre" for="lblNombre">Nombre: </label> 
			     		</td> 
			     		<td>
	  						<form:input type="text" id="nombre" name="nombre" path="nombre" size="40" tabindex="2" onBlur=" ponerMayusculas(this)" /> 
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblDescripcion">Descripci&oacute;n: </label>
	  					</td>
						<td>
		     		  		<form:textarea type="textarea" id="descripcion" name="descripcion" path="descripcion" COLS="38" ROWS="4" tabindex="3"  onBlur=" ponerMayusculas(this)"/>
		     			</td>
	  				</tr>
	  				<tr>
						<td class="label"> 
					  		<label for="lblEstatus">Estatus: </label>
					 	</td>
					 	<td>
							<form:select id="estatus" name="estatus" path="estatus"  tabindex="4">
								<form:option value="">SELECCIONAR</form:option>
							  	<form:option value="A">ACTIVO</form:option>
							  	<form:option value="I">INACTIVO</form:option>
						  	</form:select>
					  	</td>
				 	</tr>				
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="8" />
							<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="9"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						</td>
					</tr>
				</table>
			</form:form>			
		</fieldset>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"/>
	</div>
	</body>
	<div id="mensaje" style="display: none;position:absolute; z-index:999;"/>
</html>
