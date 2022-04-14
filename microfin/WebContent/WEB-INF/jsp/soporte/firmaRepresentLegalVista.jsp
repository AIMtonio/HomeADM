<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/firmaRepresentLegalServicio.js"></script>    
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>        	
		<script type="text/javascript" src="js/soporte/firmaRepresentLegal.js"></script>
	</head>
<body>
		<div id="contenedorForma">
			<form:form method="post" id="formaGenerica" name="formaGenerica" action="/microfin/firmaRepresentLegal.htm" enctype="multipart/form-data"  >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend class="ui-widget ui-widget-header ui-corner-all">Firma Facsímil Representante Legal</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>
								<label for="representLegal">Representante Legal: </label>
							</td>
							<td>
								<input type="text" id="representLegal" name="representLegal" path="representLegal" maxlength="70" tabindex="1" size="40"/>
							</td>
							<td class="separador"/>
							<td>
								<label for="rfcRepresentLegal">RFC Representante Legal: </label>
							</td>
							<td>
								<input type="text" id="rfcRepresentLegal" name="rfcRepresentLegal" path="rfcRepresentLegal" tabindex="2" maxlength="13"/>
							</td>							
						</tr>
						<tr>
							<td>
								<label for="razonSocial">Razón Social: </label>
							</td>
							<td>
								<input type="text" id="razonSocial" name="razonSocial" path="razonSocial" maxlength="70" size="40" tabindex="3"/>
							</td>
							<td class="separador"/>
							<td>
								<label for="rfc">RFC: </label>
							</td>
							<td>
								<input type="text" id="rfc" name="rfc" path="rfc" tabindex="4" maxlength="13"/>
							</td>
						</tr>
						</table>	
						<br>
						<div id="gridAdjuntaFirma" style="display: none;">	</div> 				
						<table width="100%">
							<tr>								
							<td align="left" style="vertical-align: bottom;">									
										   	<label>Únicamente Archivos con Extensión .JPG</label>       											
								</td>
								<td align="right">
									<input type="button" id="adjunta" name="adjunta" class="submit" value="Adjuntar Firma" tabindex="5" />
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								</td>
								
							</tr>
							<tr>
								<td>
									 <div id="imagenFirm" style="display: none;">
									 	<img id= "imagenFirma" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Foto Firma"/> 
									</div> 
						       </td>
							</tr>
						</table>	
													
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display:none;"></div> 	
</html>