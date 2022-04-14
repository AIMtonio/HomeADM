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
		<script type="text/javascript" src="dwr/interface/creditoDocEntServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/garantiaServicioScript.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditoArchivoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>			      
	    <script type="text/javascript" src="js/fira/autorizacreditoGrupal.js"></script>
       
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Mesa de Control Grupal</legend>
			<table  width="100%">
				<tr>
					<td class="label">
						<label for="lblGrupo">Grupo: </label>
					</td> 
					<td >
						<form:input   type="text" id="grupoID" name="grupoID"  path ="grupoID"   size="12" tabindex="1"  />
						<input  type="text" id="nombreGrupo" name="nombreGrupo"  size="40" tabindex="2"  disabled="true" autocomplete="off"/>
					</td>
			
					<td class="separador"></td>
					<td class="label">
						<label for="lblCiclo">Ciclo Actual: </label>
					</td> 
					<td> 
     					<input  type="text" id="cicloActual" name="cicloActual" size="5"  disabled="true"/> 
     				</td>  
				</tr>
				<tr>
					<td class="label">
						<label for="lblProducto">Producto de Crédito: </label>
					</td> 								
					<td >
						<form:input  type="text" id="producCreditoID" name="producCreditoID"  path ="producCreditoID" size="12" disabled="true" />
						<input  type="text" id="nombreProducto" name="nombreProducto"  size="40"  disabled  />
						<input type="hidden" id="numCredito" name="numCredito" size="11"  value="" />  
						<input type="hidden" id="clieID" name="clieID" size="6"  value="" />  
						<input type="hidden" id="nombreClie" name="nombreClie" size="40"   value="" />
						<input type="hidden" id="statusCre" name="statusCre" size="6" value="" />		
						<input type="hidden" id="cuenta" name="cuenta" size="6" value="" />		
						<input type="hidden" id="decripcioncta" name="decripcioncta" size="6" value="" />		
					</td>
				</tr>	
		</table>
	<div id="Integrantes" style="display: none;" ></div>
	<input type="hidden" id="datosGridDocEnt" name="datosGridDocEnt" size="100" />										
	<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetDocEnt" style="display: none;">                
		<legend>Documentos</legend>	
		<table align="right">
			<tr>
				<td id="documentosEnt" style="display: none;" ></td>	
				<td class="label">				
		      		<input type="button" class="submit" id="expediente" tabindex="3" value="Expediente Cred" style='height:30px;'/> 
				</td> 
				<td align="right">	
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"  />							
				</td>				
			</tr>
		</table>
	 </fieldset>
	  <div id="divComentarios" style="display: none;">
			 <fieldset class="ui-widget ui-widget-content ui-corner-all" >                
				<legend>Comentarios para la Mesa de Control</legend>	
				<table >
					<tr>
						<td class="label" > 
							<label for="lblComentarioEjec">Comentarios: </label> 
						</td>  	
						<td> 
		      				<form:textarea  id="comentarioMesaControl" name="comentarioMesaControl" path="comentarioMesaControl" COLS="50" ROWS="4" onBlur=" ponerMayusculas(this);" disabled="true" />
		     			</td> 
								
					</tr>
				</table>
			 </fieldset>
			 </div>
	
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="autorizar" name="autorizar" class="submit" value="Autorizar" tabindex="4"  />
					<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
					<input type="hidden" id="tipoOperacion" name="tipoOperacion" value="tipoOperacion"/>								
				</td>
				
			</tr>
		</table>		

</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
	<div id="mensaje" style="display: none;"></div>
</html>