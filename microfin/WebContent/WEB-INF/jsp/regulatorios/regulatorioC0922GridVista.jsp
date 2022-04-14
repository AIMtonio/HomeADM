<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
					
</head>
<body> 
<br/>
	<c:set var="regulatorioC0922"  value="${listaResultado}"/>
	<c:set var="consecutivoForm"  value="0"/>
			<input type="button" id="agregaDias" value="Agregar" class="botonGral" tabindex="4" onClick="agregarRegistro()"/>
		
		<input type="hidden" id="menuID" name="menuID" value="1"/>
		 	<div >
		 		<br>
				<table id="miTabla" class="tablaRegula"  border="0" cellspacing="0">
					<tbody>	
						
						<tr style="font-weight: bold; font-size: 0.8em">
							<td class=""> 
						   		Clasificación Contable 
							</td>
							<td class=""> 
						   		Nombre 
							</td>
							<td class=""> 
						   		Puesto 
							</td>
							<td class=""> 
						   		Tipo Percepción 
							</td>
							<td class=""> 
						   		Descrición 
							</td>
							<td class=""> 
						   		Dato 
							</td>
														
							<td nowrap="nowrap" class="label"> 
						   		<label for="lbl"></label> 
							</td>
						</tr>					
						<c:forEach items="${regulatorioC0922}" var="registro" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
															
								<td>
								<c:set var="consecutivoForm"  value="${(consecutivoForm+1)}"/>
								<input type="hidden" id="registroID${status.count}" name="registroID" size="6" 
											value="${status.count}" />												
								<input type="hidden" id="valorClasfContable${status.count}" required=""   name="valorClasfContable"  size="10" value="${registro.clasfContable}"/>
								<select tabindex="${consecutivoForm}" name="listClasfContable" id="clasfContable${status.count}"  required=""  >	</select>	
								</td>
								
								<td>
								<c:set var="consecutivoForm"  value="${(consecutivoForm+1)}"/>
								<input tabindex="${consecutivoForm}" type="text" id="nombre${status.count}" required=""  maxlength="250" name="listNombre"  size="60"  onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" value="${registro.nombre}"/>
								</td>
								
								
								<td>
								<c:set var="consecutivoForm"  value="${(consecutivoForm+1)}"/>
								<input  tabindex="${consecutivoForm}" type="text" id="puesto${status.count}" required=""  maxlength="60" name="listPuesto" onblur="ponerMayusculas(this);"  onkeyup="return soloAlfanumericos(this.id);"  size="40" value="${registro.puesto}"/>
								</td>
								
														
								<td>
								<c:set var="consecutivoForm"  value="${(consecutivoForm+1)}"/>
								<input  type="hidden" id="valTipoPercepcion${status.count}"  name="tipoPercepcion" size="20" value="${registro.tipoPercepcion}"/>
									<select   tabindex="${consecutivoForm}" name="listTipoPercepcion" required=""  id="tipoPercepcion${status.count}" >
									</select>
								</td>
								
								<td>
								<c:set var="consecutivoForm"  value="${(consecutivoForm+1)}"/>
								<input  tabindex="${consecutivoForm}" type="text" id="descripcion${status.count}" maxlength="60" required=""  name="listDescripcion"   onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" size="30" value="${registro.descripcion}"/>
								</td>
								
								
								<td nowrap="nowrap">
								<c:set var="consecutivoForm"  value="${(consecutivoForm+1)}"/>
								<input tabindex="${consecutivoForm}"  type="text" id="dato${status.count}" maxlength="18"  required="" esMoneda="true"   name="listDato" size="21" value="${registro.dato}"/>
								</td>
																
								<td nowrap="nowrap">
								<c:set var="consecutivoForm"  value="${(consecutivoForm+1)}"/>
							  		<input  tabindex="${consecutivoForm}" type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarRegistro(this.id)" />
							  		 <input tabindex="${consecutivoForm}" type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarRegistro()"/>
							  	</td>
								
							  						
							</tr>
							 
							
						</c:forEach>
					
					</tbody>

				</table>
				<br>
			 </div>
			<table align="right">
			<tr>
				<td align="right">
					<input  tabindex="997" type="submit" id="grabar" name="grabar" class="submit" value="Grabar"  />
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>
					<input type="hidden" id="tipoBaja" name="tipoBaja" value="tipoBaja"/>								
					<script> numeroIndex = ${consecutivoForm} </script>							
				</td>
				
			</tr>
		</table>	
	 	<input type="hidden" value="0" name="numero" id="numero" />
		<br>
		<br>
 
</body>
</html>
