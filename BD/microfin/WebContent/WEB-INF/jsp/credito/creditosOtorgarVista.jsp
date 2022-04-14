<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>


<html>
	<head>                                             
		<script type="text/javascript" src="dwr/interface/creditosOtorgarServicio.js"></script>

		<script type="text/javascript" src="js/credito/creditosOtorgar.js"></script>
		<style>	
		.cajaEncabezado{
			border-width:0;
			border-color: #000000;
			font-size: 12px;
		}
	</style>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Cr&eacute;ditos por Otorgar</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label" >
								<label for="lblfecha">Fecha:</label>
							</td>
							<td >
								<input type="text" name="fecha" id="fecha" value="" disabled="true" readOnly="true"/>
							</td>
							<td colspan="2"></td>		 			
						</tr>			
					</table>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Compromisos</legend>
						<table>
		     			 	<tr>
							 	<td class="label">
						  			<label for="lblClienteID">Cr&eacute;ditos Autorizados Por Desembolsar: </label>
							 	</td>
							 	<td>
									<input type="text" id="montoTotal" name="montoTotal"  style="text-align:right" readOnly="true" size="15"  />
									 <a href="javascript:" id="Producto" class="detalle" tabindex="1">
									 	<img src="images/info2.png" alt="Informacion" title="Detalle por Producto" width="15" height="15" />
									 </a> 
								</td>
			  				</tr>						  				
		     			</table>
			     	</fieldset>
		     		<br>		
					<div id="tablaDetalle">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend class="ui-widget ui-widget-header ui-corner-all">Detalle <label id="nombre"></label> &nbsp;&nbsp; <a href="javascript:" id="cerrarDetalle" ><img src="images/close.gif" alt="Cerrar" title="Cerrar"/></a></legend>
							<table id="detalleConsola" border="1" cellpadding="0" cellspacing="0" ></table>
						</fieldset>
					</div> 		   
				<br>
				<div id="tablaGeneral" style="overflow: auto;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">  
							<legend class="ui-widget ui-widget-header ui-corner-all"><label id="nombreEncabezado" style="color:white; font-weight: bold; font-size:small"></label></legend>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">  
									<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">					
									
									</table>							
								</fieldset>	
										<div id= "Tabla" style="display:none"> 	
						<table border="0" width="100%">
							<tr>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label" align="center">
									<label for="lbl" style="text-align:center"> </label> 
								</td>
								<td class="label" align="center">
									<label for="lblCantidad" style="text-align:center">Cant. </label> 
								</td>
								<td class="label" align="center">
									<label for="lblMonto" style="text-align:center">Monto </label>	
								</td>					
							</tr>							
							<tr>	
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>	
								<td class="separador"></td>
								<td class="separador"></td>	
								<td class="separador"></td>					
								<td class="label" align="center">
									<label for="lblCantidad" style="text-align:right">Por Autorizar: </label> 
								</td>
								<td align="right">
									<input id="cantidad" name="cantidad"  style="text-align:right" size="6" tabindex="2" />				 	
								</td>
								<td align="right"> 
									<input id="montoDesembolsar" name="monto"  style="text-align:right" size="15" tabindex="2" />
								</td>
							</tr>
							<br>	
							<tr>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>	
								<td class="separador"></td>
								<td class="separador"></td>	
								<td class="separador"></td>	
								<td class="separador"></td>	
								<td align="right" colspan="2">  
									<input type="submit" id="procesar" name="procesar" class="botonDeshabilitado" tabIndex = "15" value="Procesar" disabled />
								 </td>							
							</tr>	
						</table>		
				</div>					
						</fieldset>
						
				</div> 
										
					<br>			
	   		</fieldset>	
	   		<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
		</form:form>
	</div> 	
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>