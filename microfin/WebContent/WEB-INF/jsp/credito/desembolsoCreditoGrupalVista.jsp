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
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>  
		      
      <script type="text/javascript" src="js/credito/desembolsoCreditoGrupal.js"></script>
       
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Desembolso de Crédito Grupal</legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label">
						<label for="lblGrupo">Grupo: </label>
					</td> 
					<td >
						<form:input id="grupoID" name="grupoID" path="grupoID" size="12" tabindex="1"  />
						<input id="nombreGrupo" name="nombreGrupo"  size="40" tabindex="2" readonly="true"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="lblCiclo">Ciclo Actual: </label>
					</td> 
					<td>
						<input id="cicloActual" name="cicloActual"  size="10" tabindex="3" readonly="true"/>
					</td>			
				</tr>
				<tr>
					<td class="label">
						<label for="lblProducto">Producto de Crédito: </label>
					</td> 
					<td >
						<form:input id="producCreditoID" name="producCreditoID"  path ="producCreditoID" size="12" tabindex="1" disabled="true" />
						<input id="nombreProducto" name="nombreProducto"  size="40" tabindex="2" readonly="true"/>
					</td>		
					<td class="separador"></td>
					<td class="label">
						<label for="lblEstatus">Estatus: </label>
					</td> 
					<td >
						<input id="estatus" name="estatus"  size="12" tabindex="1" readonly="true" />
						<input type="hidden" id="pagare" name="pagare"/>
					</td>			
				</tr>
			
		</table>
					<div id="Integrantes" style="display: none;" >
					</div>
	
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="desembolsar" name="desembolsar" class="submit" value="Desembolsar" tabindex="5" disabled="true"  />
									<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>				
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