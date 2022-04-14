 <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
 <%@page pageEncoding="UTF-8"%>

<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/identifiClienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>                                                                                                                                                                                                                                                                                        
 		<script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>   
 	   <script type="text/javascript" src="js/cliente/identiClienteCatalogo.js"></script>  
	</head>
<body>

<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="identifiCliente">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend class="ui-widget ui-widget-header ui-corner-all">Identificaciones del <s:message code="safilocale.cliente"/></legend>	
				<table border="0"  width="950px">
					<tr>
						<td class="label"> 
							<label for="clienteID">No. de <s:message code="safilocale.cliente"/>: </label> 
					   </td>
					   <td>
							<form:input id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="1" iniforma="false" />  
							<input type="text" id="nombreCliente" name="nombreCliente" size="60" tabindex="2" disabled= "true" 
							 readOnly="true" iniforma="false"/> 
						</td> 
						<td class="label"> 
							<label for="nIdentificacion">No. de Identificación: </label> 
						</td> 
						<td> 
							<form:input id="identificID" name="identificID" path="identificID" size="6" tabindex="3" /> 
						</td> 
					</tr> 
<!-- 					<tr> -->
<!-- 						<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 						<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td> -->
<!-- 					</tr> -->
					<tr> 
						<td class="label"> 
					   	<label for="tIdentiID">Tipo: </label> 
					   </td> 
					   <td> 
					   	<form:select id="tipoIdentiID" name="tipoIdentiID" path="tipoIdentiID" tabindex="4">
								<form:option value="-1">Seleccionar</form:option>
							</form:select>
						</td>
						<td class="label">  
							<label for="loficial">Es Oficial: </label> 
						</td> 
						<td class="label"> 
						<form:select id="oficial" name="oficial" path="oficial" disabled= "true" readOnly="true" tabindex="5">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
						</form:select>
					</td> 
					</tr> 
					<tr> 
						<td class="label"> 
					   	<label for="nIdentific">Folio: </label> 
					   </td> 
					   <td> 
					   	<form:input id="numIdentific" name="numIdentific" path="numIdentific" size="25" tabindex="6" onBlur=" ponerMayusculas(this)"/> 
					   </td> 
					   <td class="label"> 
					     	<label for="lblFecExIden">Fecha Expedici&oacute;n: </label> 
					   </td> 
					   <td> 
					     	<form:input id="fecExIden" name="fecExIden" path="fecExIden" size="14" 
					     			tabindex="7" esCalendario="true" /> 
					   </td> 
					</tr> 
					<tr> 
					   <td class="label"> 
					    	<label for="lblFecVenIden">Fecha Vencimiento:</label> 
					   </td> 
					   <td> 
					    	<form:input id="fecVenIden" name="fecVenIden" path="fecVenIden" size="14"
					    			tabindex="8" esCalendario="true"/> 
					   </td> 
					   <td></td>
					   <td></td>
					</tr>
				</table>
		<table width="100%">
			<tr>
				<td align="right">
					<input type="submit" id="agrega" name="agrega" class="submit" 
							 value="Agregar" tabindex="9"/>
					<input type="submit" id="modifica" name="modifica" class="submit" 
							 value="Modificar"  tabindex="10"/>
					<input type="submit" id="elimina" name="elimina" class="submit" 
					 		 value="Eliminar"  tabindex="11"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="numeroCaracteres" name="numeroCaracteres"/>					
					<input type="hidden" id="estatus" name="estatus"/>					
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

<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;position:absolute; z-index:999;"/>
</html>