<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>

	<head>	
      <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
	  <script type="text/javascript" src="js/originacion/documentosReqProd.js"></script>   
	</head>
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solicidocreqBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Documentos por Producto</legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<label for="lblproducto">Producto de Crédito: </label> 
		     		</td> 
		     		<td> 
		         	<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="1" type="text"  />
		         	<input id="descripProducto" name="descripProducto"size="50" type="text" tabindex="2" readOnly="true" disabled = "true" />
		     		</td>	
		     		<td class="separador"></td> 
		     		<td class="separador"></td> 
		     		<td class="separador"></td> 
		     	</tr>
			</table>	
		 	<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
		 		<tr> 
		 			<div id="gridDocumentosReq" style="display: none;">  </div>
		 			<input type="hidden" id="detalleDocumentosReq" name="detalleDocumentosReq" size="100" />	
		 		</tr>	

				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="18"  />
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
	<div id="elementoLista" ></div>
</div>
</body>
<div id="mensaje" style="display: none;" ></div>
</html>