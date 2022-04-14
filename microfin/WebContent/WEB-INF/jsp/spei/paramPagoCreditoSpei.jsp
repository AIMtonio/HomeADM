<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>	
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramPagoCreditoSpei.js"></script>
 		<script type="text/javascript" src="js/spei/paramPagoCreditoSpei.js"></script> 
	</head>
<body>
<div id="contenedorForma">	
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="paramPagoCreditoBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Parámetros Pagos de Crédito</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			 	<tr>
					<td class="label">
						<label for="lblReqVerificacion">Aplica en automático el pago de crédito:</label>
					</td>
					<td>
						<input type="radio" id="aplicaPagAutCre" name="aplicaPagAutCre" value="S">
						<label>Sí</label>
						<input type="radio" id="aplicaPagAutCre1" name="aplicaPagAutCre" value="N">
						<label>No</label>
					</td>
										
				</tr>
				<tr>
					<td class="label ">
						<label for="puesto" class="">En caso de no tener exigible:</label>
					</td>
					<td class="" >
						<input type="radio" id="enCasoTieneExiCre" name="enCasoTieneExiCre" value="A">
						<label>Abono a cuenta</label>
						<input type="radio" id="enCasoTieneExiCre1" name="enCasoTieneExiCre" value="P">
						<label>Prepago de crédito</label>
					</td>
				</tr>
				<tr>
					<td class="label ">
						<label for="puesto" class="">En caso de sobrante:</label>
					</td>
					<td class="" >
						<input type="radio" id="enCasoSobrantePagCre" name="enCasoSobrantePagCre" value="A">
						<label>Abono a cuenta</label>
						<input type="radio" id="enCasoSobrantePagCre1" name="enCasoSobrantePagCre" value="P">
						<label>Prepago de crédito</label>
					</td>
				</tr>
			 
			</table>		
														
		     <table border="0" cellpadding="0" cellspacing="0"  width="100%">    	   
				<tr>					
					<td colspan="5">
						<table align="right"> 
				
							<tr>								
								<td align="right">
									<input type="hidden" id="numEmpresaID" name="numEmpresaID" value="" />
									<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="3" />
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
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>
