<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>                 
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/integraGruposServicio.js"></script> 
    	<script type="text/javascript" src="js/fira/creditoGrupal.js"></script>
       
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Crédito Grupal</legend>
						
			<table  width="100%">
				<tr>
					<td class="label">
						<label for="lblGrupo">Grupo: </label>
					</td> 
					<td >
						<form:input type="text" id="grupoID" name="grupoID" path ="grupoID" size="12" tabindex="1" autocomplete="off" />
						<input  type="text" id="nombreGrupo" name="grupoID"  size="40" tabindex="2"  disabled="true" />
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="lblCiclo">Ciclo Actual: </label>
					</td> 
					<td>
						<input type="text" id="cicloActual" name="cicloActual"  size="10" tabindex="3"  disabled="true" />
					</td>					
				</tr>
					
				<tr>
					<td class="label">
						<label for="fecha">Fecha Registro: </label>
					</td> 
		  			<td >
			 			<input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" 
			 			readOnly= "true" disabled = "true" tabindex="3" />
					</td>		
					<td class="separador"></td>
					<td class="label">
						<label for="lblProducto">Producto de Crédito: </label>
					</td> 
					<td >
						<form:input type="text" id="producCreditoID" name="producCreditoID"  path ="producCreditoID" size="10" tabindex="1" disabled="true" />
						<input type="text" id="nombreProducto" name="nombreProducto"  size="40" tabindex="2" disabled="true"  />
					</td>
			</tr>
		</table>
					<div id="Integrantes" style="display: none;" >
					</div>
	
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="agregar" name="agregar" class="submit" value="Grabar" tabindex="5"  />
									<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
									<input type="hidden" id="lisCtes" name="lisCtes" value=""/>	
									<input type="hidden" id="sucursalID" name="sucursalID" />			
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