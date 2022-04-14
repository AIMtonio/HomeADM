<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script> 
	 	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	 	<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script> 
	 	<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script> 
	 	<script type="text/javascript" src="dwr/interface/integraGruposServicio.js"></script> 
	 	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	 	<script type="text/javascript" src="js/credito/integraGrupos.js"></script>
	 	<!--  Jair	    --> 
	</head>
   
<body>

<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="integraGruposCre">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Integrantes del Grupo</legend>
			  	
				<table >
					
					<tr>
						<td class="label"> 
				         <label for="lblgrupoID">Grupo:</label> 
				     	</td> 
				     	<td nowrap = "nowrap"> 
				      	<form:input id="grupoID" name="grupoID" path="grupoID" size="5" tabindex="1" /> 
				      	<input type="text" id="nombreGrupo" name="nombreGrupo" size="40" tabindex="2"	disabled />
				     	</td>
				     		<td class="separador"></td> 
				     	<td class="label"> 
        						 <label for="cicloActual">Ciclo Actual: </label> 
     					</td>
  						<td> 
  						   <input  type="text" id="cicloActual" name="cicloActual" size="5" tabindex="6" onBlur=" ponerMayusculas(this)" disabled/> 
    					 </td> 
    					 <td class="separador"></td>
    					 <td class="label">
							<label for="estatus">Estado del Ciclo:</label>
						</td>
						<td>
						         		<form:select id="estatusCiclo" name="estatusCiclo" path="estatus" tabindex="7" disabled="true">
										<form:option value="N">No Iniciado</form:option>
										<form:option value="A">Abierto</form:option>
										<form:option value="C">Cerrado</form:option>
										
							</form:select>
			    		 </td> 
			    		 <td class="separador"></td> 
				     	<td class="label"> 
        						 <label for="fechaReg">Fecha de Registro: </label> 
     					</td>
  						<td> 
         						 <form:input   type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="25" disabled="true" tabindex="3" iniforma="false" /> 
    					 </td>     
					</tr>	
     				<tr>
					<td colspan= "11">
						<br>
						<div id="datosGrupales"  >
							<fieldset class="ui-widget ui-widget-content ui-corner-all">		
							<legend>Condiciones del Grupo:</legend>
							<br>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
		     				<td class="label"> 
		        				<label for="lblmax">Máximo de Integrantes: </label> 
		     				</td>
			     				<td><input  type="text" id="max"  size="5"  disabled /></td>
		   					 <td class="separador"></td>
							<td class="label"> 
		        				<label for="lblmaxm">Máximo de Mujeres: </label> 
		     				</td>
							<td> 
			 						   <input  type="text" id="maxm" size="5" disabled/> 
		   					 </td>
							 
		   					<td class="separador"></td>
							<td class="label"> 
		        				<label for="lblmaxms">Máximo de Mujeres Solteras: </label> 
		     				</td>
							<td> 
			 						   <input  type="text" id="maxms" size="5" disabled/> 
			   					 </td>
			   					 <td class="separador"></td>
								<td class="label"> 
			        				<label for="lblmaxh">Máximo de Hombres: </label> 
			     				</td>
								<td> 
			 						   <input  type="text" id="maxh" size="5" disabled/> 
		   					 </td>
		   					</tr>
							<tr>
							<td class="label"> 
		        				<label for="lblminh">Mínimo de Integrantes: </label> 
		     				</td>
							<td> 
			 						   <input  type="text" id="min"size="5" disabled/> 
		   					 </td>
		   					
		   					
		     				<td class="separador"></td>
							<td class="label"> 
		        				<label for="lblminm">Mínimo de Mujeres: </label> 
		     				</td>
							<td> 
			 						   <input  type="text" id="minm" size="5" disabled/> 
		   					 </td>
		   					  <td class="separador"></td>
							<td class="label"> 
		        				<label for="lblminms">Mínimo de Mujeres Solteras: </label> 
		     				</td>
							<td> 
			 						   <input  type="text" id="minms" size="5" disabled/> 
			   					 </td>
			   					 <td class="separador"></td>
								
								<td class="label"> 
			        				<label for="lblminh">Mínimo de Hombres: </label> 
			     				</td>
								<td> 
			 						   <input  type="text" id="minh" size="5" disabled/> 
			   					 </td>
			   					
							</tr>	
							<tr>
								<td class="label"> 
			        				<label for="lblminh">Número Actual de Integrantes: </label> 
			     				</td>
								<td> 
			 						   <input  type="text" id="inte" name="" size="5" disabled/> 
			   					 </td>
			   					
								<td class="separador"></td>
								
								<td class="label"> 
			        				<label for="lblminm">Número Actual de Mujeres: </label> 
			     				</td>
								<td> 
			 						   <input  type="text" id="intem" name="" size="5" disabled/> 
			   					 </td>
			   					<td class="separador"></td>
			     				<td class="label"> 
			        				<label for="lblminms">Número Actual de Mujeres Solteras: </label> 
			     				</td>
								<td> 
			 						   <input  type="text" id="intems" name="" size="5" disabled/> 
			   					 </td>
			   					 <td class="separador"></td>
			   					 <td class="label"> 
			        				<label for="lblminh">Número Actual de Hombres: </label> 
			     				</td>
								<td> 
			 						   <input  type="text" id="inteh" name="" size="5" disabled/> 
		   					 </td>
							</tr>	 
							</table>
							</fieldset>
						</div>
					</td>
				</tr>
   				<input type="hidden" id="integrantes" name="integrantes" size="100" />	
				 	<tr>
						<td colspan="11">
						<div id="gridIntegrantes" style="display: none;"></div>							
						</td>						
					</tr>
				</table>
				<table > 
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right">			
										<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>				
									</td>
								</tr>
							</table>		
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
<div id="mensaje" style="display: none;"></div>
</html>