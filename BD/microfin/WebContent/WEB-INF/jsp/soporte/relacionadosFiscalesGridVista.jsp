<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>


<c:set var="listaResultadoBean" value="${listaResultado[0]}"/>

<table id="miTabla">			
	<c:forEach items="${listaResultadoBean}" var="bean" varStatus="status">
		<tr id="renglon${status.count}" name="renglons">	
			<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<table id="tablaPersona${status.count}">
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="cteRelacionadoID${status.count}">Aportante:</label>
						</td>
						<td nowrap="nowrap">
					    	<input type="text" id="cteRelacionadoID${status.count}" name="lisCteRelacionadoID" size="12" tabindex="${status.count + 5}" maxlength="20" autocomplete="off" value="${bean.cteRelacionadoID}" onkeypress="listaClientesGrid(this.id);" onblur="consultaClienteGrid(this.id)" />
						</td>
						<td class="separador"/>
						<td class="label" nowrap="nowrap">
							<label for="tipoPersona${status.count}">Tipo de Persona:</label>
						</td>
						<td nowrap="nowrap">		
							<input type="radio" id="tipoPersonaFisica${status.count}" name="tipoPersona${status.count}" value="F" tabindex="${status.count + 5}" ${bean.tipoPersona == 'F' ? "checked='checked'" : ''} onclick="cambiaTipoPersona(${status.count},'F')"/>						
							<label>Física</label>
							<input type="radio" id="tipoPersonaFisActEmp${status.count}" name="tipoPersona${status.count}" value="A" tabindex="${status.count + 5}" ${bean.tipoPersona == 'A' ? "checked='checked'" : ''} onclick="cambiaTipoPersona(${status.count},'A')"/>						
							<label>Física Act. Emp.</label>
							<input type="hidden" id="tipoPersonaValor${status.count}" name="lisTipoPersona" value="${bean.tipoPersona}"/>							
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="primerNombre${status.count}">Primer Nombre:</label>
						</td>
						<td>
							<input type="text" id="primerNombre${status.count}" name="lisPrimerNombre" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this)" maxlength="50" value="${bean.primerNombre}"/>
						</td>		
						<td class="separador"></td>
						<td class="label">
							<label for="segundoNombre${status.count}">Segundo Nombre:</label>
						</td>
						<td >
							<input type="text" id="segundoNombre${status.count}" name="lisSegundoNombre" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this)" maxlength="50" value="${bean.segundoNombre}"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="tercerNombre${status.count}">Tercer Nombre:</label>
						</td>
						<td>
							<input type="text" id="tercerNombre${status.count}" name="lisTercerNombre" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this)" maxlength="50" value="${bean.tercerNombre}"/>
						</td>				
						<td class="separador"></td>
						<td class="label">
							<label for="apellidoPaterno${status.count}">Apellido Paterno:</label>
						</td>
						<td>
							<input type="text" id="apellidoPaterno${status.count}" name="lisApellidoPaterno" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this)" maxlength="50" value="${bean.apellidoPaterno}"/>
						</td>		
					</tr>
					<tr>
						<td class="label">
							<label for="apellidoMaterno${status.count}">Apellido Materno:</label>
						</td>
						<td>
							<input type="text" id="apellidoMaterno${status.count}" name="lisApellidoMaterno" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this)" maxlength="50" value="${bean.apellidoMaterno}"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="registroHacienda${status.count}">Registro de Alta en Hacienda: </label> 
						</td>
						<td class="label" nowrap="nowrap"> 
							<input type="radio" id="registroHaciendaSi${status.count}" name="registroHacienda${status.count}" value="S" tabindex="${status.count + 5}" ${bean.registroHacienda == 'S' ? "checked='checked'" : ''} onclick="cambiaRegistroHacienda(${status.count},'S')" />
							<label for="si">Si</label>
							<input type="radio" id="registroHaciendaNo${status.count}" name="registroHacienda${status.count}" value="N" tabindex="${status.count + 5}" ${bean.registroHacienda == 'N' ? "checked='checked'" : ''} onclick="cambiaRegistroHacienda(${status.count},'N')" />
							<label for="no">No</label>		
							<input type="hidden" id="registroHaciendaValor${status.count}" name="lisRegistroHacienda" value="${bean.registroHacienda}"/>
						</td>					
					</tr>
					<tr>
						<td class="label">
							<label for="nacion${status.count}">Nacionalidad:</label>
						</td>
						<td>
							<select id="nacion${status.count}" name="lisNacion" tabindex="${status.count + 5}" onchange="limpiarMostrarOcultarCamposExtranjero(${status.count})" >
								<option value="">SELECCIONAR</option> 
								<option value="N" ${bean.nacion == 'N' ? "selected='selected'" : ''}>MEXICANA</option> 
							    <option value="E" ${bean.nacion == 'E' ? "selected='selected'" : ''}>EXTRANJERA</option>
							</select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="paisResidencia${status.count}">Pa&iacute;s de Residencia:</label>
						</td>
						<td>
							<input type="text" id="paisResidencia${status.count}" name="lisPaisResidencia" size="6" tabindex="${status.count + 5}" maxlength="9" value="${bean.paisResidencia}" onkeypress="listaPaisesGrid(this.id);" onblur="consultaPais(this.id,'paisR${status.count}')"/>
							<input type="text" id="paisR${status.count}" name="paisR" size="35" tabindex="${status.count + 5}" disabled="true" readOnly="true" />
						</td>
					</tr>
					<tr>	
						<td class="label">
							<label for="RFC${status.count}"> RFC:</label>
						</td>
						<td>
							<input type="text" id="RFC${status.count}" name="lisRFC" maxlength="13" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this)" autocomplete="off" value="${bean.RFC}"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="CURP${status.count}">CURP:</label>
						</td>
						<td>
							<input type="text" id="CURP${status.count}" name="lisCURP" tabindex="${status.count + 5}" size="25" onBlur="ponerMayusculas(this)" maxlength="18" autocomplete="off" value="${bean.CURP}"/>
						</td>
					</tr>
					<tr>
						<td class="label" >
							<label>Domicilio Fiscal:</label>
						</td>
						<td></td> 
						<td class="separador"></td> 
						<td class="tdDomicilioFiscal${status.count}" nowrap="nowrap"> 
					         <label for="estadoID${status.count}">Entidad Federativa:</label> 
					    </td> 
					    <td nowrap="nowrap" class="tdDomicilioFiscal${status.count}"> 
							<input type="text" id="estadoID${status.count}" name="lisEstadoID" size="6" tabindex="${status.count + 5}" autocomplete="off" value="${bean.estadoID}"
								onkeypress="listaEstado(this.id);" onblur="consultaEstado(this.id),consultaDirecCompleta(${status.count})" />
					        <input type="text" id="nombreEstado${status.count}" name="nombreEstado" size="35" disabled ="true" readonly="true"/>   
						</td> 
					</tr>
					<tr class="trDomicilioFiscal${status.count}"> 
						<td class="label"> 
						    <label for="municipioID${status.count}">Municipio: </label> 
						</td> 
						<td nowrap="nowrap"> 
						    <input type="text" id="municipioID${status.count}" name="lisMunicipioID" size="6" tabindex="${status.count + 5}" autocomplete="off" value="${bean.municipioID}"
						    	onkeypress="listaMunicipio(this.id);" onblur="consultaMunicipio(this.id),consultaDirecCompleta(${status.count})" />
						    <input type="text" id="nombreMuni${status.count}" name="nombreMuni" size="35" disabled="true" readonly="true"/>   
						</td> 
						<td class="separador"></td> 
							<td class="label"> 
						<label for="localidadID${status.count}">Localidad: </label> 
						</td> 
						<td nowrap="nowrap"> 
						    <input type="text" id="localidadID${status.count}" name="lisLocalidadID" size="6" tabindex="${status.count + 5}"  autocomplete="off" value="${bean.localidadID}"
						    	onkeypress="listaLocalidad(this.id);" onblur="consultaLocalidad(this.id),consultaDirecCompleta(${status.count})" /> 
							<input type="text" id="nombreLocalidad${status.count}" name="nombreLocalidad" size="35" disabled="true" readonly="true"/>   
						</td>  
					</tr> 
					<tr class="trDomicilioFiscal${status.count}">
						<td class="label"> 
							<label for="coloniaID${status.count}">Colonia: </label> 
						</td> 
						<td nowrap="nowrap"> 
							<input type="text" id="coloniaID${status.count}" name="lisColoniaID" size="6" tabindex="${status.count + 5}" autocomplete="off" value="${bean.coloniaID}"
								onkeypress="listaColonia(this.id);" onblur="consultaColonia(this.id),consultaDirecCompleta(${status.count})" /> 
							<input type="text" id="nombreColonia${status.count}" name="nombreColonia" size="35" disabled="true" readonly="true"/>   
						</td> 
						<td class="separador"></td>
						<td class="label"> 
							<label for="nombreCiudad${status.count}">Ciudad: </label> 
						</td> 
						<td nowrap="nowrap">
							<input type="text" id="nombreCiudad${status.count}" name="lisNombreCiudad" size="42" 	disabled="true" readonly="true"/>
						</td>
					</tr>
					<tr class="trDomicilioFiscal${status.count}"> 
						<td class="label"> 
							<label for="calle${status.count}">Calle: </label> 
						</td> 
						<td nowrap="nowrap"> 
							<input type="text" id="calle${status.count}" name="lisCalle" size="42" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this),consultaDirecCompleta(${status.count})" maxlength = "50" value="${bean.calle}"/> 
						</td> 
						<td class="separador"></td>
						<td class="label"> 
							<label for="numeroCasa${status.count}">N&uacute;mero: </label> 
						</td> 
						<td nowrap="nowrap"> 
							<input type="text" id="numeroCasa${status.count}" name="lisNumeroCasa" size="5" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this),consultaDirecCompleta(${status.count})" value="${bean.numeroCasa}"/>
						    <label for="numInterior${status.count}">Interior: </label>
						    <input type="text" id="numInterior${status.count}" name="lisNumInterior" size="5" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this),consultaDirecCompleta(${status.count})" value="${bean.numInterior}"/>
						    <label for="piso${status.count}">Piso: </label>
						    <input type="text" id="piso${status.count}" name="lisPiso" size="5" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this),consultaDirecCompleta(${status.count})" value="${bean.piso}"/>
						</td> 
					</tr> 
					<tr class="trDomicilioFiscal${status.count}"> 
						<td class="label"> 
							<label for="CP${status.count}">C&oacute;digo Postal:</label> 
						</td> 
						<td nowrap="nowrap"> 
							<input type="text" id="CP${status.count}" name="lisCP" size="15" maxlength="5" tabindex="${status.count + 5}" value="${bean.CP}" onBlur="consultaDirecCompleta(${status.count})"/> 
						</td>
						<td class="separador"></td>
					</tr>
					<tr class="trDomicilioFiscal${status.count}"> 
						<td class="label"> 
							<label for="lote${status.count}">Lote: </label> 
						</td> 
						<td nowrap="nowrap"> 
							<input type="text" id="lote${status.count}" name="lisLote" size="20" tabindex="${status.count + 5}" onBlur="ponerMayusculas(this),consultaDirecCompleta(${status.count})" value="${bean.lote}"/> 
						</td> 
						<td class="separador"></td> 
						<td class="label"> 
						    <label for="manzana${status.count}">Manzana: </label> 
						</td> 
						<td nowrap="nowrap"> 
						    <input type="text" id="manzana${status.count}" name="lisManzana" size="20" tabindex="${status.count + 5}"  onBlur="ponerMayusculas(this),consultaDirecCompleta(${status.count})" value="${bean.manzana}"/> 
						</td> 
					</tr>
					<tr>
						<td class="label"> 
						    <label for="direccionCompleta${status.count}">Dirección Completa: </label> 
						</td> 
						<td nowrap="nowrap">
							<textarea id="direccionCompleta${status.count}" name="lisDireccionCompleta" cols="50" rows="6" tabindex="${status.count + 5}"
								readonly="true"  onBlur=" ponerMayusculas(this)" maxlength="500">${bean.direccionCompleta}</textarea>
						</td>
						<td class="separador"></td> 
						<td class="label" nowrap="nowrap">
							<label for="participacionFiscal${status.count}">Participación Fiscal:</label>
		      			</td>		
		 				<td nowrap="nowrap">
	       		 			<input type="text" id="participacionFiscal${status.count}" name="lisParticipacionFiscal" size="15" tabindex="${status.count + 5}" autocomplete="off"  maxlength="10" value="${bean.participacionFiscal}" onblur="validaParticipacionFiscal(this.id)" style="text-align:right;"/><label>%</label>       		 			
						</td>
					</tr>	
					<tr>		
						<td nowrap="nowrap" colspan="5" align="right">				
							<input type="button" name="eliminar" id="eliminar${status.count}" tabindex="${status.count + 5}" value="" class="btnElimina" onclick="eliminaFilaComprobante(this.id)"  />
							<input type="button" name="agregar" id="agregar${status.count}" tabindex="${status.count + 5}" value="" class="btnAgrega" onclick="agregaPersonaRelacionadaGrid()" />
						</td>						
					</tr>	
				</table>
			</fieldset>
			</td>
		</tr>
	</c:forEach>
</table>
