<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
	<script type="text/javascript" src="js/inversiones/repSaldConcInver.js"></script>
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Saldos y Conciliaci&oacute;n </legend>
	
		<form id="formaGenerica" name="formaGenerica" method="POST" commandName="inverSalCon" target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">		
				<tr>
					<td>
						<label>Fecha:</label>
					</td>
					<td><input type="text" name="fecha" id="fecha" autocomplete="off" esCalendario="true" size="12" tabindex="2" />						
					</td>
					<td colspan="3"></td>
				</tr>		
						
				<tr>		
					<td colspan="5">
						<table align="left" border='0'>
							<tr>
								<td width="350px">
									&nbsp;					
								</td>								
								<td align="right">
								<a id="ligaImp" href="SaldConcInver.htm" target="_blank" >
					             		<button type="button" class="submit" id="imprimir" style="">
					              		Imprimir
					             		</button> 
				            </a>					
								</td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</form>
	</fieldset>
	
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>