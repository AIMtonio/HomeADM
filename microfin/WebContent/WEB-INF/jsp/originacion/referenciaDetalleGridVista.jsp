<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="listaResultado"  value="${listaResultado}"/>
<%! int numFilas = 0; %>
<%! int counter = 4; %>
<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<legend >Referencias</legend>
			<table  border="0" width="100%">
				<tr>
					<td class="label"> 
						<input type="button" id="agrega" name="agrega" class="submit" tabIndex= "2" value="Agregar" onclick="agregarDetalle();" /> 
					</td>		
				</tr>
				<tr>
				<td>
					<table id="tablaReferencias" border="0" width="100%">
						<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
						<tr id="trRefe${status.count}">
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<table id="referencia${status.count}" border="0" width="100%">
									<tr>
							            <td class="label" nowrap="nowrap">
							            	<input type="hidden" name="numReferencia" value="${status.count}"/>
											<label for="primerNombre">Primer Nombre:</label>
										</td>
										<td>
											<% numFilas=numFilas+1; %>
											<% counter++; %>
											<input id="primerNombre${status.count}" name="primerNombre${status.count}" type="text" tabindex="<%=counter %>" maxlength="50" size="50" onBlur="ponerMayusculas(this)" value="${detalle.primerNombre}"/>
										</td>
									 	<td class="separador"></td> 
										<td class="label" nowrap="nowrap">
											<label for="segundoNombre${status.count}">Segundo Nombre: </label>
										</td>
										<td >
											<% counter++; %>
											<input id="segundoNombre${status.count}" name="segundoNombre${status.count}" maxlength="50" size="50" type="text" tabindex="<%=counter %>"  onBlur=" ponerMayusculas(this)" value="${detalle.segundoNombre}"/>
										</td>
									</tr>
									<tr>  
								    	<td class="label" nowrap="nowrap">
											<label for="tercerNombre${status.count}">Tercer Nombre:</label>
										</td>
										<td>
											<% counter++; %>
											<input id="tercerNombre${status.count}" name="tercerNombre${status.count}" tabindex="<%=counter %>" maxlength="50" size="50" onBlur=" ponerMayusculas(this)" value="${detalle.tercerNombre}" type="text"/>
										</td>	
										<td class="separador"></td> 
								    	<td class="label" nowrap="nowrap">
											<label for="apellidoPaterno${status.count}">Apellido Paterno:</label>
										</td>
										<td>
											<% counter++; %>
											<input id="apellidoPaterno${status.count}" name="apellidoPaterno${status.count}" maxlength="50" tabindex="<%=counter %>" size="50" onBlur=" ponerMayusculas(this)" value="${detalle.apellidoPaterno}" type="text"/>
										</td>	
								    </tr>
									<tr> 		
								    	<td class="label" nowrap="nowrap">
											<label for="apellidoMaterno${status.count}">Apellido Materno:</label>
										</td>
										<td >
											<% counter++; %>
											<input id="apellidoMaterno${status.count}" name="apellidoMaterno${status.count}" maxlength="50" size="50" tabindex="<%=counter %>" onBlur=" ponerMayusculas(this)" value="${detalle.apellidoMaterno}" type="text"/>
										</td>
										<td class="separador"></td> 
										<td class="label"> 
									    	<label for="tipoRelacionID${status.count}">Tipo Relaci&oacute;n:</label> 
									    </td> 
									    <td nowrap="nowrap">
									    	<% counter++; %>
									       <input id="tipoRelacionID${status.count}" name="tipoRelacionID${status.count}" size="6" tabindex="<%=counter %>" maxlength="20" value="${detalle.tipoRelacionID}" onkeypress="listaTipoRelacion(this.id)" onBlur="consultaParentesco(this.id,${status.count})" type="text"/>
									       <input type="text" id="descripcionRelacion${status.count}" name="descripcionRelacion" size="43" disabled ="true" readOnly="true" value="${detalle.descripcionRelacion}"/> 
									    </td>
									</tr>  
									<tr>
										<td class="label" valign="top">
											<label for="telefono${status.count}">Tel&eacute;fono:</label>
										</td>
										<td valign="top">
											<% counter++; %>
											<input id="telefono${status.count}" name="telefono${status.count}" size="20" tabindex="<%=counter %>" maxlength="10" value="${detalle.telefono}" type="text"/>
											<label for="lblExt">Ext.:</label>
											<% counter++; %>
											<input id="extTelefonoPart${status.count}" name="extTelefonoPart${status.count}" size="10" maxlength="7" tabindex="<%=counter %>" value="${detalle.extTelefonoPart}" type="text"/>
										</td>
										<td class="separador"></td>
										<td class="label"> 
									    	<label for="estadoID">Entidad Federativa:</label> 
									    </td> 
									    <td>
									    	<% counter++; %>
									       <input id="estadoID${status.count}" name="estadoID${status.count}" size="6" tabindex="<%=counter %>" maxlength="20" value="${detalle.estadoID}" onkeypress="listaEstado(this.id)" onBlur="consultaEstadoNac(this.id,${status.count});" type="text"/>
									       <input type="text" id="nombreEstado${status.count}" name="nombreEstado" size="43" disabled ="true" readOnly="true" value="${detalle.nombreEstado}"/> 
									    </td>
									</tr>
									<tr>
										<td class="label"> 
											<label for="municipioID${status.count}">Municipio: </label> 
										</td>
										<td>
											<% counter++; %>
											<input id="municipioID${status.count}" name="municipioID${status.count}" size="6" tabindex="<%=counter %>" maxlength="20" value="${detalle.municipioID}" onkeypress="listaMunicipio(this.id,${status.count})" onBlur="consultaMunicipio(this.id,${status.count});" type="text"/>
											<input type="text" id="nombreMuni${status.count}" name="nombreMuni" size="43" disabled="true" readOnly="true" value="${detalle.nombreMuni}"/>   
										</td>
										<td class="separador"></td> 
										<td class="label"> 
											<label for="localidadID${status.count}">Localidad: </label> 
										</td> 
										<td>
											<% counter++; %>
											<input id="localidadID${status.count}" name="localidadID${status.count}" size="6" tabindex="<%=counter %>" maxlength="20" value="${detalle.localidadID}" onkeypress="listaLocalidad(this.id,${status.count})" onBlur="consultaLocalidad(this.id,${status.count});" type="text"/> 
											<input type="text" id="nombreLocalidad${status.count}" name="nombrelocalidad" size="43" disabled ="true" readOnly="true" value="${detalle.nombreLocalidad}"/>   
										</td>
									</tr>
									<tr>
										<td class="label"> 
											<label for="coloniaID${status.count}">Colonia: </label> 
										</td> 
										<td>
											<% counter++; %>
											<input id="coloniaID${status.count}" name="coloniaID${status.count}" size="6" tabindex="<%=counter %>" maxlength="20" value="${detalle.coloniaID}" onkeypress="listaColonias(this.id,${status.count})" onBlur="consultaColonia(this.id,${status.count});" type="text"/> 
											<input type="text" id="nombreColonia${status.count}" name="nombreColonia${status.count}" size="43" disabled="true" readOnly="true" value="${detalle.nombreColonia}"/>   
										</td>
										<td class="separador"></td>
										<td class="label"> 
										<label for="calle">Calle: </label> 
										</td> 
										<td>
											<% counter++; %>
											<input id="calle${status.count}" name="calle${status.count}" size="50" tabindex="<%=counter %>" maxlength="50" onBlur="ponerMayusculas(this);consultaDirecCompleta(${status.count});" value="${detalle.calle}" type="text"/> 
										</td>
									</tr>
									<tr>
										<td class="label"> 
												<label for="numeroCasa${status.count}">No. Exterior: </label> 
										</td> 
										<td nowrap="nowrap">
											<% counter++; %>
											<input id="numeroCasa${status.count}" name="numeroCasa${status.count}" size="6" tabindex="<%=counter %>" maxlength="10" value="${detalle.numeroCasa}" onBlur="ponerMayusculas(this);consultaDirecCompleta(${status.count});" type="text"/>
											<label for="numInterior${status.count}"> No. Interior: </label>
											<% counter++; %>
											<input id="numInterior${status.count}" name="numInterior${status.count}" size="6" tabindex="<%=counter %>" maxlength="10" value="${detalle.numInterior}" onBlur="ponerMayusculas(this);consultaDirecCompleta(${status.count});" type="text"/>
											<label for="piso${status.count}"> Piso: </label>
											<% counter++; %>
											<input id="piso${status.count}" name="piso${status.count}" size="6" tabindex="<%=counter %>"  onBlur="ponerMayusculas(this)" value="${detalle.piso}" type="text"/>
										</td>
										<td class="separador"></td>
										<td class="label"> 
											<label for="cp${status.count}">Código Postal: </label> 
										</td> 
										<td>
											<% counter++; %>
											<input id="cp${status.count}" name="cp${status.count}" maxlength="5" size="15" tabindex="<%=counter %>" value="${detalle.cp}" onBlur="ponerMayusculas(this);consultaDirecCompleta(${status.count});" type="text"/> 
										</td>
									</tr>
									<tr>
										<td class="label" valign="top">
											<label for="direccionCompleta${status.count}">Domicilio:</label>
										</td>
										<td>
											<textarea id="direccionCompleta${status.count}" name="direccionCompleta${status.count}" cols="47" rows="3" disabled ="true" readonly="true" onBlur="ponerMayusculas(this)" maxlength = "500" >${detalle.direccionCompleta}</textarea>
										</td>
										<td class="separador"></td>	
										<td class="label" valign="top"> 
											<label for="validado${status.count}">Validado: </label> 
										</td> 
										<td nowrap="nowrap" valign="top">
										<c:choose>
										    <c:when test="${detalle.validado=='N'}">
										    	<% counter++; %>
												<input type="radio" id="validado${status.count}" name="validado${status.count}" value="S"  tabindex="<%=counter %>" /><label>Si</label>
										    	<% counter++; %>
										        <input type="radio" id="validado${status.count}" name="validado${status.count}" value="N"  tabindex="<%=counter %>" checked="true"/><label>No</label>
										    </c:when>    
										    <c:otherwise>
										        <% counter++; %>
												<input type="radio" id="validado${status.count}" name="validado${status.count}" value="S"  tabindex="<%=counter %>" checked="true"/><label>Si</label>
												<% counter++; %>
										        <input type="radio" id="validado${status.count}" name="validado${status.count}" value="N"  tabindex="<%=counter %>" /><label>No</label>
										    </c:otherwise>
										</c:choose>
															 
										</td>
									</tr> 
									<tr>
										<td class="label"> 
											<label for="interesado${status.count}">Interesado: </label> 
										</td> 
										<td nowrap="nowrap">
										<c:choose>
										 <c:when test="${detalle.interesado=='N'}">
											<% counter++; %>
											<input type="radio" id="interesado${status.count}" name="interesado${status.count}" value="S"  tabindex="<%=counter %>" /><label> Si</label>
											<% counter++; %>
											<input type="radio" id="interesado${status.count}" name="interesado${status.count}" value="N"  tabindex="<%=counter %>" checked="true"/><label> No</label>
										 </c:when>    
										    <c:otherwise>
										    <% counter++; %>
											<input type="radio" id="interesado${status.count}" name="interesado${status.count}" value="S"  tabindex="<%=counter %>" checked="true"/><label> Si</label>
											<% counter++; %>
										    <input type="radio" id="interesado${status.count}" name="interesado${status.count}" value="N"  tabindex="<%=counter %>" /><label> No</label>
										    </c:otherwise>
										</c:choose>
										</td>
									</tr>
									<tr>
										<td nowrap="nowrap" colspan="5" align="right">
											<% counter++; %>
											<input type="button" name="elimina" value="" class="btnElimina" tabindex="<%=counter %>" onclick="eliminarDetalle(${status.count})"/>
											<% counter++; %>
											<input type="button" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle()" tabindex="<%=counter %>"/>
										</td>
									</tr>
								</table>
							</fieldset>
							<br></br>
							</td>
						</tr>
						</c:forEach>
					</table>
				</td>
				</tr>
			</table>
		</fieldset>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numReferencia" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>
