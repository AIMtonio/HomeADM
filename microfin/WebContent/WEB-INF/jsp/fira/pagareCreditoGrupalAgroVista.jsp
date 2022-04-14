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
		<script type="text/javascript" src="js/fira/pagareCreditoGrupal.js"></script>
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Pagaré de Crédito Grupal</legend>
						
			<table width="100%">
				<tr>
					<td class="label">
						<label for="lblGrupo">Grupo: </label>
					</td> 
					<td >
						<form:input type="text" id="grupoID" name="grupoID"  path="grupoID" size="12" tabindex="1" autocomplete="off" />
						<input type="text" id="nombreGrupo" name="grupoID"  size="40" tabindex="2"  disabled="true" />
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
						<label for="fecha">Fecha Desembolso: </label>
					</td> 
		  			<td >
			 			<form:input type="text" id="fechaMinistrado" name="fechaMinistrado" path="fechaMinistrado" size="12" tabindex="4" esCalendario="true" />
					</td>	
					<td class="separador"></td>
					<td class="label">
						<label for="lblProducto">Producto de Crédito: </label>
					</td> 
					<td >
						<form:input type="text" id="producCreditoID" name="producCreditoID"  path ="producCreditoID" size="12" tabindex="5" disabled="true" />
						<input type="text"  id="nombreProducto" name="nombreProducto"  size="40" tabindex="6" disabled="true"  />
					</td>
						
				</tr>				

		</table>
		<div id="Integrantes" style="display: none;" >
		</div>
			<table align="right">
				<tr>
					<td>
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="7" disabled="true"  />
						<a id="ligaRep" href="RepPDFPagareCredito.htm" target="_blank" type="hidden"   >
	             			<button type="hidden"  class="submit" id="imprimir"  >
	              			Imprimir Pagar&eacute;
	             			</button> 
	             		</a>	
	             	</td>
					<td>
				  		<input type="button" id="generar" name="generar" class="submit" value="Imprimir Pagaré " />
						<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
						<input type="hidden" id="reca" name="reca" />
					</td>
					<td>
						<a id="ligaGenerar" target="_blank">									
						<input type="button" id="contratoAdhesion" name="contratoAdhesion" class="submit" value="Contrato" />
						</a>													             	
		             </td>
	             	<td>
	             		<input type="button" id="planPago" name="planPago" class="submit" value="Plan Pago" />
	             	</td>
				</tr>
			</table>		
<form:input type="hidden" id="formaPago" path="formaPago" name="formaPago"/>		
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista">
	</div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>