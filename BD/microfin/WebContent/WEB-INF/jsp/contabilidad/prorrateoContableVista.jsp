<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>		
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prorrateoContableServicio.js"></script>
		<script type="text/javascript" src="js/contabilidad/prorrateoContable.js"></script>
	</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend class="ui-widget ui-widget-header ui-corner-all">Métodos Prorrateo Contables</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="prorrateoMetod">         
 				<table border="0" cellpadding="0" cellspacing="0" width="83%">     
					<tr>
						<td class="label">
							<label for="prorrateoID">Método Prorrateo: </label> 
						</td>
					    <td> 
							<form:input type="text" id="prorrateoID" name="prorrateoID" path="prorrateoID" size="11" tabindex="1" autocomplete="off" maxlength="50"/> 		         						
						</td>
					</tr>
					<tr>	
						<td class="label">
				    		<label for="nombreProrrateo">Nombre Método Prorrateo: </label>
				    	</td> 
						<td>
							<form:input type="text" id="nombreProrrateo" name="nombreProrrateo" path="nombreProrrateo" size="38" 
										onBlur="ponerMayusculas(this)" tabindex="2" maxlength="50"/>							 		 		
						</td>
					</tr>  						 
					<tr>  
						<td class="label"> 
					    	<label for="estatus">Estatus: </label> 
						</td>
					    <td>
					    	<select id="estatus" name="estatus" tabindex="3" iniForma="false">
										<option value="">SELECCIONAR</option>
										<option value="A">ACTIVO</option>
										<option value="I">INACTIVO</option>
							</select>					    								 									       
			           	</td>	
					</tr>
					<tr>  
						<td class="label"> 
					    	<label for="descripcion">Descripción: </label> 
						</td>
					    <td>
					    	<form:textarea id="descripcion" name="descripcion" path="descripcion" value="" cols="27" rows="2" tabindex="3" maxlength="100" onBlur="ponerMayusculas(this)" />							 									       
			           	</td>	
					</tr>
					</table>
					 <br>	 	
					<div id="gridSucursProrrateo" style="display: none;"></div>
					<br>
					<table border="0" cellpadding="0" cellspacing="0" width="850px">  
						<tr>
							<td align="right">
						    	<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="30"/>
						    	<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="31"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>							
								<form:input type="hidden" id="listaCentros"   name="listaCentros" path="listaCentros" value=""/>
								<form:input type="hidden" id="porcentajes"   name="porcentajes" path="porcentajes" value=""/>
								<input type="hidden" id="totalPorcentajes"   name="totalPorcentajes"  value=""/>
							</td>
						</tr>
					</table>
		 	</form:form> 
		</fieldset>
	</div>
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"> </div>
	<div id="ContenedorAyuda" style="display: none;">
		<div id="elementoLista"></div>
	</div>	
	</body>
</html>