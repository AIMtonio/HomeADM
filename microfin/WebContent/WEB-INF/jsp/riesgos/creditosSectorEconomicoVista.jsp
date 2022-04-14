<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
 	   <script type="text/javascript" src="dwr/interface/creditosSectorEconomicoServicio.js"></script>   
      <script type="text/javascript" src="js/riesgos/creditosSectorEconomico.js"></script>  		
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosSectorEconomico">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cr&eacute;ditos Sector Econ&oacute;mico </legend>
			<table border="0"  width="100%">
			 <tr> <td>        
          <table  border="0"  width="100%">
				<tr>
					<td class="label">
						<label for="">Fecha Operaci&oacute;n: </label>
					</td>
					<td>
						<input id="fechaOperacion" name="fechaOperacion"  size="12" tabindex="1" type="text" esCalendario="true" />	
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="">Monto de Cartera Actividad Econ&oacute;mica: </label>
					</td>
					<td>
						<input id="montoActEconomica" name="montoActEconomica" size="20" type="text" readonly="true"  style="text-align: right;"/>	
					</td>				
				</tr>
				<tr>
					<td class="label">
						<label for="">Saldo de Cartera Actividad Econ&oacute;mica: </label>
					</td>
					<td>
						<input id="saldoCarteraCredito" name="saldoCarteraCredito" size="20" type="text"  readonly="true"  style="text-align: right;"/>	
					</td>				
				</tr>
				<tr>
					<td class="label">
						<label for="">Saldo Total de la Cartera de Cr&eacute;dito: </label>&nbsp;&nbsp;
					</td>
					<td>
						<input id="totalCarteraCredito" name="totalCarteraCredito" size="20" type="text"  readonly="true"  style="text-align: right;"/>	
					</td>				
				</tr>
 			</table> 
 		</td>  
   		</tr>
		</table>
		   	<br>
			 <table border="0"  width="100%" id='divMonto'>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend>Monto de Cartera Acumulado del D&iacute;a de Ayer</legend>
							   	<table>
						 	    	<tr>	
										<td>
										 	<div id="divMontoActividad" style="overflow-y: scroll; overflow-x: hidden; width: 550px; height: 150px; display: none;" />
										</td>		
									</tr> 
						 		</table>		 		
					 		</fieldset>  
					 	</td>
					</tr>
		 	</table> 
	 		<br>
	 		 <table border="0"  width="100%" id='divSaldo'>
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend>Saldo de Cartera Acumulado al D&iacute;a de Ayer</legend>
					 		<table>
					 	    	<tr>	
									<td>
									 	<div id="divSaldoActividad" style="overflow-y: scroll; overflow-x: hidden; width: 550px; height: 150px; display: none;" />
									</td>		
								</tr> 
					 		</table>
					 	</fieldset>  
				 	</td>
				</tr>
	 	</table> 
		<br>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">	
			<tr>
				<td colspan="4">
					<table align="right" border='0'>
						<tr>
							<td align="right">
							<a id="ligaGenerar" href="credSectorEconomicoRep.htm" target="_blank" >  		 
								 <input type="button" id="generar" name="generar" class="submit" tabindex = "2" value="Exportar EXCEL" />
							</a>
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