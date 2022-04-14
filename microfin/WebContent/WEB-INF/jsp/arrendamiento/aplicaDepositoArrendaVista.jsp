<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/periodoContableServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/depositoRefereArrendaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
		
		<script type="text/javascript" src="js/arrendamiento/aplicaDepositoArrenda.js"></script>
	</head>
<body>

<div id="contenedorForma">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Aplicar Pago</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="depositoRefereArrendaBean"> 
		<table border="0" width="100%">  
			<tr>
				<td> 
	         		<fieldset class="ui-widget ui-widget-content ui-corner-all">           
					<table border="0" width="100%">  
						<tr>
							<td class="label"><label for="depRefereID">Deposito Refere:</label></td>
						    <td> 
				         		<input type="text" id="depRefereID" name="depRefereID"  size="13" maxlength="12" class="valid" tabindex="1" autocomplete="off" />
							</td> 
						</tr> 
						<tr>
						    <td class="label">
						        <label for="institucion">Instituci&oacute;n: </label> 
						    </td>
						    <td >
						        <input type="text" id="institucionID" name="institucionID"  size="24" tabindex="2" disabled="true" readOnly="true" autocomplete="off" />
						        <input type="text" id="nombreInstitucion" name="nombreInstitucion"  size="50" disabled="true" readOnly="true"/> 
						    </td>                                            
						</tr>         
						<tr>
						    <td class="label">
						        <label for="cuentaBan">Cuenta Bancaria: </label> 
						    </td>
						    <td>
						    	<input type="text" id="cuentaBancaria" name="cuentaBancaria"  size="24" tabindex="3" disabled="true" readOnly="true"/>
						    	<input type="hidden" id="cuentaAhoID" name="cuentaAhoID"  size="20" value="s" />
						        <input type="text" id="nombreBanco" name="nombreBanco" size="50" disabled="true" readOnly="true"/> 
						    </td>
						</tr>
						<tr>
						    <td class="label">
						        <label for="institucion">Fecha Carga: </label> 
						    </td>
						    <td >
						        <input type="text" id="fechaCarga" name="fechaCarga"  size="24" disabled="true" readOnly="true"/>
						    </td>                                            
						</tr>  
						<tr>
						    <td class="label">
						        <label for="institucion">Fecha Aplicaci&oacute;n: </label> 
						    </td>
						    <td >
						        <input type="text" id="fechaAplica" name="fechaAplica"  size="24" disabled="true" readOnly="true" />
						    </td>                                            
						</tr>     
					</table>
					</fieldset>
				</td> 
			</tr> 
			<tr>
				<td> 
	         		<table border="0" width="100%">  
						<tr>
							<td> 
								<div id="listaDepositosArrenda" style="overflow: scroll; width: 100%; height: 300px;display: none;"></div>
				         	</td> 
						</tr> 
					</table>
				</td> 
			</tr> 
			<tr>
				<td colspan="5">
					<table align="right">
						<tr>
							<td align="right">									
								<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="4" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
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
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"> </div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"/>
</div>	

</body>
</html>