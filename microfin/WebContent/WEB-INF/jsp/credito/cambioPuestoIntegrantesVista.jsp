<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>

	<head>	
	<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/cambioPuestoIntegrantesServicio.js"></script>  
    <script type="text/javascript" src="js/credito/cambioPuestoIntegrantes.js"></script>   
	</head>

<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cambioPuestoIntegrantesBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Cambio de Puesto Integrantes de Grupo</legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
		         		<label for="lblGrupo">Grupo: </label> 
				    </td>
				    <td>
				      <form:input id="grupoID" name="grupoID" path="grupoID" size="12" tabindex="1" maxlength ="10"/>  
				      <input type="text" id="nombreGrupo" name="nombreGrupo"size="50" readOnly="true"  />
				    </td> 
		     		<td class="separador"></td> 
		     		<td class="label"> 
		         		<label for="lblCiclo">Ciclo Actual: </label> 
		     		</td> 
		     		<td> 
		         		 <form:input id="ciclo" name="ciclo" path="ciclo" size="10"  readOnly = "true"/>  
		     		</td>  		
		 		</tr>  
		 		<tr> 
		     		<td class="label"> 
		         		<label for="lblFechaRegistro">Fecha Registro: </label> 
		     		</td> 
		     		<td> 
		         		 <form:input id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" 
		         		 readOnly="true"   />  
		     		</td>
		     	   	<td class="separador"></td> 
		     	   	<td class="label"> 
		     	   		<label for="lblProducto">Producto de Cr&eacute;dito: </label> 
		     	   		
		     		</td> 
		     		<td> 
		         		 <input type="text" id="producCreditoID" name="producCreditoID" size="10" 
		         		    readOnly="true" />  
		         		 <input id="descripProducto" name="descripProducto"size="50" type="text" 
		         		  readOnly="true" />
		     		</td>
		     	</tr>
		     	<tr> 
		     		<td class="label"> 
		         		<label for="lblEstatus">Estatus del Grupo: </label> 
		     		</td> 
		     		<td> 
		         		<input id="estatus" name="estatus"size="15" type="text" readOnly="true" />
		         		<input type="hidden" id="estatusGrupo" name="estatusGrupo" size="2"/>
		         		<input type="hidden" id="fechaMinistrado" name="fechaMinistrado" size="10"/>
		         		<input type="hidden" id="reca" name="reca" size="10"/>
		     		</td>
		     	</tr>	
		    </table>
	 	    <table>
	 	    	<br>
	 	    	<tr>	
					<td>
					 	<div id="integrantesGrupo" style="overflow: scroll; width: 935px; height: 200px; display: none;" />
					</td>		
				</tr> 	
	 		</table>
			
			<table align="right">
				<tr>
					<td>
						<input type="submit" id="actualizar" name="actualizar" class="submit" value="Actualizar" tabindex="50" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
					</td>
					<td id="tdGenerar">
						<input type="button" id="generar" name="generar" class="submit" value="Imprimir Pagaré"  />	
					</td>
					<td id="tdContrato">
						<a id="ligaGenerar" target="_blank">									
							<input type="button" id="contratoAdhesion" name="contratoAdhesion" class="submit" value="Contrato" />
						</a>													             	
		            </td>
	             	<td id="tdPlan">
		             		<input type="button" id="planPago" name="planPago" class="submit" value="Plan Pago" />
		             </td>
				</tr>
			</table>		  		 	 	
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista" ></div>
</div>
</body>
<div id="mensaje" style="display: none;" ></div>
</html>