<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>								
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script> 
 	<script type="text/javascript" src="js/fira/gruposCreditoAgro.js"></script> 
</head>	
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="gruposDeCredito">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend class="ui-widget ui-widget-header ui-corner-all">Grupos de Crédito</legend>	
			<table  width="100%">
				<tr>
      				<td class="label"> 
         				<label for="grupo">Grupo: </label> 
     				</td>
     				<td>
						<form:input id="grupoID" name="grupoID" path="grupoID" size="5" tabindex="1" iniforma="false"
							onBlur=" ponerMayusculas(this)" maxlength="10"/> 
     				</td>
					<td class="separador"></td>
					<td class="label"> 
         				<label for="nombreGrupo">Nombre del Grupo: </label> 
     				</td>
			     	<td> 
			        	<form:input id="nombreGrupo" name="nombreGrupo" path="nombreGrupo" size="70" tabindex="2" onBlur=" ponerMayusculas(this)"/> 
			     	</td> 
      			</tr>
       			<tr>
        			<td class="label"> 
          				<label for="fechaReg">Fecha Registro: </label> 
     				</td>
					<td>
          				<form:input id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="25" disabled="true" tabindex="3" iniforma="false" /> 
					</td>
					<td class="separador"></td>
		  			<td class="label"> 
         				<label for="sucursal">Sucursal: </label> 
     				</td>
     				<td> 
     					<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="5" tabindex="4" disabled="true" iniforma="false"/> 
        				<input type="text" id="nombreSucursal" name="nombreSucursal" path="nombreSucursal"  size="40" tabindex="5"  disabled="true" onBlur=" ponerMayusculas(this)"/> 
     				</td>       
 				</tr> 
 				<tr>
  					<td class="label"> 
         				<label for="cicloActual">Ciclo Actual: </label> 
     				</td>
  					<td> 
     					<form:input id="cicloActual" name="cicloActual" path="cicloActual" size="5" tabindex="6" 	onBlur=" ponerMayusculas(this)" disabled="true"/> 
     				</td>  
     				<td class="separador"></td>
     				<td class="label">
						<label for="estatus">Estado del Grupo:</label>
					</td>
					<td>
						<form:select id="estatusCiclo" name="estatusCiclo" path="estatusCiclo" tabindex="7" disabled="true">
							<form:option value="N">No INICIADO</form:option>
							<form:option value="A">ABIERTO</form:option>
							<form:option value="C">CERRADO</form:option>
						</form:select>  
			    	</td>    
 				</tr>
 				<tr>
 					<td class="label">
 						<label for="tipoOpe">Tipo de Operación:</label>
 					</td>
 					<td>
 					<form:select id="tipoOperacion" name="tipoOperacion" path="tipoOperacion" tabindex="8">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="G">GLOBAL</form:option>
							<form:option value="NF">NO FORMAL</form:option>
					</form:select>  
					</td>
 				</tr>
 				<tr>
 					<td class="label"> 
         				<label for="ultCiclo">Fecha Último Ciclo: </label> 
     				</td>
  					<td> 
     					<form:input id="fechaUltCiclo" name="fechaUltCiclo" path="fechaUltCiclo" size="25" tabindex="8" 	onBlur=" ponerMayusculas(this)" disabled="true"/> 
     				</td> 
     				<td class="separador"></td>
     				<td class="label">
						<label for="pro" id="pro" style="display: none"></label>
         				<label for="tipoCre" id="tipoCre" style="display: none">Tipo de Crédito: </label> </td>
         			<td>
     					<form:input id="productoCre" name="productoCre" path="productoCre" size="5" tabindex="6" disabled="true" style="display: none"/> 
     					<input type="text" id="nombreTipoCredito" name="nombreTipoCredito"  size="40" tabindex="6" disabled="true" style="display: none"/> 
     				</td>  
 				</tr>
  			</table>
	  		<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" tabindex="9"
							 value="Grabar"/>
						<input type="submit" id="iniciarCiclo" name="iniciarCiclo" class="submit" tabindex="10"
							 value="Iniciar Nuevo Ciclo"/>
						<input type="submit" id="cerrarCiclo" name="cerrarCiclo" class="submit" tabindex="11"
							 value="Cerrar Grupo"/>
						<input type="button" id="actaConstitutiva" name="actaConstitutiva" class="submit" tabindex="12"
							 value="Acta Grupo"/>							 
						<input type="hidden" id="nombreInstitucion" name="nombreInstitucion" path="nombreInstitucion" size="30" tabindex="13" disabled="true" iniforma="false"  /> 
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
						<input type="hidden" id="esAgropecuario" name="esAgropecuario" value="S"/>
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
<div id="mensaje" style="display: none;position:absolute; z-index:999;"></div>
</html>