<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
	<head>	
	 	<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>     
 		<script type="text/javascript" src="dwr/interface/empleadosServicio.js"></script>     
		<script type="text/javascript" src="dwr/interface/organigramaServicio.js"></script>     
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
	    <script type="text/javascript" src="js/gestionComercial/organigramaCatalogo.js"></script>	    
	</head>   
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Organigrama</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="organigrama">  	
				<table>					
					<tr>
						<td class="label"> 
				        	<label for="puestoPadreID">Empleado:</label> 
				     	</td> 
				     	<td> 
				      		<form:input type="text" id="puestoPadreID" name="puestoPadreID" path="puestoPadreID" size="10" tabindex="1" /> 
				      		<input type="text" id="nombre" name="nombre" size="40" disabled="true" />
				     	</td> 
				     	<td class="separador"></td> 	
				     	<td class="label"> 
				      		<label for="puesto">Puesto:</label> 
				     	</td> 
				     	<td> 
				      		<input type="text" id="puesto" name="puesto" size="40" disabled="true" />
				      	</td> 
					</tr>
					<tr>	
				     	<td class="label"> 
				      		<label for="jefeInmediato">Jefe Inmediato:</label> 
				     	</td> 
				     	<td> 
				      		<input type="text" id="jefeInmediato" name="jefeInmediato" size="40" disabled="true" />
				      	</td> 
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="externo">Requiere Cuenta Contable:</label>
		      			</td>
						<td class="label"> 
							<label for="ctaContaSI">Si</label>
							<form:radiobutton id="ctaContaSI" name="requiereCtaConta"  path="requiereCtaConta" value="S" tabindex="2" />
							
							<label for="ctaContaNO">No</label>
							<form:radiobutton id="ctaContaNO" name="requiereCtaConta"  path="requiereCtaConta" value="N" tabindex="3"/>
						</td>
				     	<td class="separador"></td> 
						<td class="label" nowrap="nowrap">
							<label for="ctaContable">Cuenta Contable:</label>
		      			</td>		
		 				<td nowrap="nowrap">
	       		 			<form:input type="text" id="ctaContable" name="ctaContable" path="ctaContable" size="15" tabindex="4" autocomplete="off" maxlength="30" disabled="true" readOnly="true"/>
	       		 			<input type="text" id="descripcionCtaCon" name="descripcionCtaCon" size="45" disabled="true" readOnly="true"/>
						</td>
					</tr>					
				 	<tr>
						<td colspan="7">
							<input type="hidden" id="dependencias" name="dependencias" size="100" />
							<div id="gridOrganigrama" style="display: none;"/>							
						</td>						
					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right">			
							<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="101"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>				
							<input type="hidden" id="categoriaID" name="categoriaID"/>				
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
</html>