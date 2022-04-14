<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/guiaContableSpeiIEServicio.js"></script>
	<script type="text/javascript" src="js/spei/guiaContableSpeiIE.js"></script> 
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable SPEI</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="guiaContableSpeiIEBean" target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">							
				<tr>  
				  <td class="label" nowrap="nowrap"><label for="lblCtaContableDeuDiv">Cta. Contable Deudores Div.IE SPEI: </label></td>
				   <td><input type="text" id="ctaDDIESpei" name="ctaDDIESpei" size="25" tabindex="9" maxlength="20"/>
				  </td>
				</tr>
				
				<tr>
	  			    <td class="label" nowrap="nowrap"><label for="lblCtaBancaria">Cta. Contable Deudores Div.IE Transf: </label></td>
					<td><input type="text" id="ctaDDIETrans" name="ctaDDIETrans" size="25" tabindex="9" maxlength="20"/>
				</tr>	
				<tr>		
					<td colspan="2">
						<table align="right" border='0'>
							<tr align="right">					
								<td align="right">
								  <a target="_blank" >									  				
									<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="2"/>	
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>					             		 
				                  </a>
								</td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</form:form>
	</fieldset>	
</div>
<div id="cargando" style="display: none;">	
</div>				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>