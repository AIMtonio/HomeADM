<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>

	<head>	 
	  <script type="text/javascript" src="dwr/interface/tiposCedesServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/docPorTipoCedesServicio.js"></script>  
	  <script type="text/javascript" src="js/cedes/docPorTipoCedes.js"></script>   
	</head>
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="docPorTipoCedes">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Documentos por Tipo de CEDE</legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
				<td>
						<label for="lblproducto">Tipo CEDE: </label> 
		     	</td> 
		     	<td> 
		         <form:input id="tipoProducto" name="tipoProducto" path="tipoProducto" size="5" tabindex="1" type="text"  />
		     	</td>
		     	
				<td>
				<form:input id="descripcion" name="descripcion" path="descripcion" size="50" type="text"  disabled="true"  readOnly="true"/>
				</td>		
		     			
		     		
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
									<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"/>
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