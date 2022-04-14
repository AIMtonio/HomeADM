<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
	<!--  declaracion del recurso que se nombro en el xml para consultas -->
		<script type="text/javascript" src="dwr/interface/parametrosYangaServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
	 <!-- se cargan las funciones o recursos js -->     	 	
		<script type="text/javascript" src="js/soporte/parametrosYanga.js"></script>   		
		     
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosYangaBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros YANGA</legend>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"> 
			    	<label for="empredaID">Empresa:</label> 
				</td>
				<td>
					<form:input type='text' id="empresaID" name="empresaID" path="empresaID" size="12" tabindex="1"/> 				
				</td>		
			</tr>
			<tr>
				<td class="label"> 
			    	<label for="haberExSocios">Cta. Conta. Haberes ExSocios: </label> 
				</td>
				<td>
					<form:input type='text' id="haberExSocios" name="haberExSocios" path="haberExSocios" size="34" tabindex="2"/> 				
				
					<input type='text' id="haberExSociosDes" name="haberExSociosDes" size="60" tabindex="3" readonly disabled/> 				
				</td>		
			</tr>	
		</table>	                
	</fieldset>

	<br>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Protecci&oacute;n al Ahorro y Cr&eacute;dito </legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"> 
			    	<label for="tipoCtaProtec">Tipo Cuenta Socios: </label> 
				</td>
				<td>	
					<form:select id="tipoCtaProtec" name="tipoCtaProtec" path="tipoCtaProtec" tabindex="4" type="select">
						<form:option value="">SELECCIONAR</form:option>
					</form:select> 			
				</td>
			</tr>
			<tr>	
				 <td class="label"> 
			    	<label for="montoMaxProtec">Monto M&aacute;ximo: </label> 
				</td>
				 <td>
					<form:input type='text' id="montoMaxProtec" name="montoMaxProtec" path="montoMaxProtec" size="25" tabindex="5" esMoneda="true" style='text-align:right;'/> 				
				</td>		
			</tr>
			<tr>
				<td class="label"> 
			    	<label for="ctaProtecCta">Cta. Conta. Protecci&oacute;n Ahorro: </label> 
				</td>
				<td>
					<form:input type='text' id="ctaProtecCta" name="ctaProtecCta" path="ctaProtecCta" size="34" tabindex="6"/> 				
				
					<input type='text' id="ctaProtecCtaDes" name="ctaProtecCtaDes" size="60" tabindex="7"  readonly disabled//> 				
				</td>
			</tr>
			<tr>
				<td class="label"> 
			    	<label for="ctaProtecCre">Cta. Conta. Protecci&oacute;n Cr&eacute;dito: </label> 
				</td>
				<td>
					<form:input type='text' id="ctaProtecCre" name="ctaProtecCre" path="ctaProtecCre" size="34" tabindex="8"/> 				
				
					<input type='text' id="ctaProtecCreDes" name="ctaProtecCreDes" size="60" tabindex="9"  readonly disabled//> 				
				</td>
			</tr>
		</table>	                
	</fieldset>
	
	<br>


	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>PROFUN </legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"> 
			    	<label for="montoPROFUN">Monto M&aacute;ximo: </label> 
				</td>
				<td>
					<form:input type='text' id="montoPROFUN" name="montoPROFUN" path="montoPROFUN" size="25" tabindex="10" esMoneda="true" style='text-align:right;'/> 				
				</td>
			</tr>
			<tr>	
				 <td class="label"> 
			    	<label for="aporteMaxPROFUN">Aporte M&aacute;ximo por Socio: </label> 			    	
				</td>	
				<td>
					<form:input type='text' id="aporteMaxPROFUN" name="aporteMaxPROFUN" path="aporteMaxPROFUN" size="25" tabindex="11" esMoneda="true" style='text-align:right;'/>				
				</td>
			</tr>
			<tr>
				<td class="label"> 
			    	<label for="ctaContaPROFUN">Cta. PROFUN: </label> 
				</td>
				<td>
					<form:input type='text' id="ctaContaPROFUN" name="ctaContaPROFUN" path="ctaContaPROFUN" size="34" tabindex="12"/> 				
				
					<input type='text' id="ctaContaPROFUNDes" name="ctaContaPROFUNDes" size="60" tabindex="13"  readonly disabled//> 				
				</td>
			</tr>
		</table>	
		</fieldset>
</fieldset>                

<table align="right">
		<tr>
			<td align="right">				
				<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="14"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>						
			</td>
		</tr>
	</table>

</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>