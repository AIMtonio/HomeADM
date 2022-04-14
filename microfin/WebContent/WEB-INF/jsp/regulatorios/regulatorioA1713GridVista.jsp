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
  <fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend><label>Reporte</label></legend>
	<c:set var="regulatorioA1713"  value="${listaResultado}"/>
			<input type="button" id="agregaDias" value="Agregar" class="botonGral" tabindex="4" onClick="agregarRegistro()"/>
		
		<input type="hidden" id="menuID" name="menuID" value="1"/>
		 	<div >
		 		<br>
				<table id="miTabla" class="tablaRegula"  border="0" >
					<tbody>	
						
						<tr>
							<td class="label"> 
						   		<label for="lblTipoMovimiento">Tipo  de Movimiento</label> 
							</td>
							<td class="label"> 
						   		<label for="lblNombreFuncionario">Nombre</label> 
							</td>
							<td class="label"> 
						   		<label for="lblRfc">RFC</label> 
							</td>
							<td class="label"> 
						   		<label for="lblCurp">CURP</label> 
							</td>
							<td class="label"> 
						   		<label for="lblProfesion">T&iacute;tulo o Profesi&oacute;n</label> 
							</td>
							<td class="label"> 
						   		<label for="lblCalleDomicilio">Calle</label> 
							</td>
							<td class="label"> 
						   		<label for="lblNumeroExt">No. Exterior</label> 
							</td>
							<td class="label"> 
						   		<label for="lblNumeroInt">No. Interior</label> 
							</td>
							<td class="label"> 
						   		<label for="lblPais">Pais</label> 
							</td>
							<td class="label"> 
						   		<label for="lblEstado">Estado</label> 
							</td>
							<td class="label"> 
						   		<label for="lblMunicipio">Municipio</label> 
							</td>
							<td class="label"> 
						   		<label for="lblLocalidad">Localidad</label> 
							</td>
							<td class="label"> 
						   		<label for="lblColoniaDomicilio">Colonia</label> 
							</td>
							<td class="label"> 
						   		<label for="lblCodigoPostal">C&oacute;digo Postal</label> 
							</td>
							<td class="label"> 
						   		<label for="lblTelefono">Tel&eacute;fono</label> 
							</td>
							
							<td class="label"> 
						   		<label for="lblEmail">Correo Electr&oacute;nico</label> 
							</td>
							
							<td class="label"> 
						   		<label for="lblFechaMovimiento">Fecha del Movimiento</label> 
							</td>
							
							<td class="label"> 
						   		<label for="lblFechaInicio">Fecha de Inicio <br> o conclusi&oacute;n <br>de gestión</label> 
							</td>
							
							<td class="label"> 
						   		<label for="lblOrganoPerteneciente">&Oacute;rgano al que pertenece</label>
						   	</td>
							
							<td class="label"> 
						   		<label for="lblCargo">Cargo</label> 
							</td>
							
							<td class="label"> 
						   		<label for="lblPermanente">Permanente o suplente</label> 
							</td>
							
							<td class="label"> 
						   		<label for="lblManifestCumplimiento">Manifestaci&oacute;n de Cumplimiento</label> 
							</td>
							
							<td nowrap="nowrap" class="label"> 
						   		<label for="lbl"></label> 
							</td>
						</tr>					
						<c:forEach items="${regulatorioA1713}" var="registro" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
															
								<td>
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" 
											value="${status.count}" />	
								<input type="hidden" id="stipoMovimiento${status.count}"   name="stipoMovimiento"  size="10" value="${registro.tipoMovimiento}"/>
								<select tabindex="5" name="lTipoMovimiento" id="tipoMovimiento${status.count}" >	</select>
								</td>
								<td>
								<input tabindex="6" type="text" id="nombreFuncionario${status.count}" maxlength="100" name="lNombreFuncionario"  size="30"  onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" value="${registro.nombreFuncionario}"/>
								</td>
								<td>
								<input  tabindex="7" type="text" id="rfc${status.count}" maxlength="13" name="lRFC" onblur="ponerMayusculas(this);"  onkeyup="return soloAlfanumericos(this.id);"  size="15" value="${registro.rfc}"/>
								</td>
								<td>
								<input  tabindex="8" type="text" id="curp${status.count}" maxlength="18" name="lCURP"   onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" size="21" value="${registro.curp}"/>
								</td>
								<td>
								<input  type="hidden" id="sprofesion${status.count}"  name="sprofesion" size="20" value="${registro.profesion}"/>
									<select   tabindex="9" name="lProfesion" id="profesion${status.count}" >
									</select>
								</td>
								<td>
								<input  tabindex="10" type="text" id="calleDomicilio${status.count}" maxlength="150" name="lCalleDomicilio"   onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" size="30" value="${registro.calleDomicilio}"/>
								</td>
								<td nowrap="nowrap">
								<input tabindex="11"  type="text" id="numeroExt${status.count}" maxlength="10"  onkeyup="return soloAlfanumericos(this.id);"   name="lNumeroExt" onblur="ponerMayusculas(this);" size="10" value="${registro.numeroExt}"/>
								</td>
								<td >
								<input  tabindex="12" type="text" id="numeroInt${status.count}" maxlength="10"   name="lNumeroInt" onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" size="10" value="${registro.numeroInt}"/>
								</td>
								<td nowrap="nowrap">
								<input  tabindex="13" type="text" id="paisID${status.count}"  name="lPais" size="8" onkeyup="buscaPais(this.id)" onblur="consultaPais(this.id)" value="${registro.pais}" class="display: inline-block" />	
								<input type="text" id="despaisID${status.count}" readonly="" disabled="" name="pais" size="30" value="${registro.pais}" class="display: inline-block" />
								</td>
								<td nowrap="nowrap">
								<input  tabindex="14" type="text" id="estadoID${status.count}" name="lEstado" onkeyup="buscaEstado(this.id)" onblur="consultaEstado(this.id)" size="6"  value="${registro.estado}" class="display: inline-block"  />
								<input type="text" id="desestadoID${status.count}" readonly="" disabled="" name="estado" size="30"  class="display: inline-block" />
								</td>
								<td nowrap="nowrap">
								<input  tabindex="15" type="text" id="municipioID${status.count}" name="lMunicipio" onkeyup="buscaMunicipio(this.id)" size="12" onblur="consultaMunicipio(this.id)" value="${registro.municipio}" class="display: inline-block" />
								<input type="text" id="desmunicipioID${status.count}" readonly="" disabled="" name="municipio" size="30" class="display: inline-block" />
								</td>
								<td nowrap="nowrap">
								<input  tabindex="16" type="text" id="localidadID${status.count}" name="lLocalidad" size="12"  onkeyup="buscaLocalidad(this.id)"onblur="consultaLocalidad(this.id)" value="${registro.localidad}" class="display: inline-block" />
								<input type="text" id="deslocalidadID${status.count}" readonly="" disabled="" name="localidad" size="30" value="${registro.localidad}" class="display: inline-block" />
								</td>
								<td nowrap="nowrap">
								<input tabindex="17"  type="text" id="coloniaDomicilioID${status.count}"  name="lColoniaDomicilio" onkeyup="buscaColonia(this.id)"onblur="consultaColonia(this.id)"  size="10" value="${registro.coloniaDomicilio}" class="display: inline-block"/>
 								<input type="text" id="descoloniaDomicilioID${status.count}" readonly="" disabled="" name="coloniaDomicilio" size="30" value="${registro.coloniaDomicilio}" class="display: inline-block" />
								</td>
								<td>
								<input tabindex="18"  type="text" id="codigoPostal${status.count}" maxlength="5"  onkeyPress="return validaSoloNumeros(event);" name="lCodigoPostal" onblur="ponerMayusculas(this);" size="10" value="${registro.codigoPostal}"/>
								</td>
								<td>
								<input tabindex="19" type="text" id="telefono${status.count}" maxlength="20" name="lTelefono" onkeyPress="return validaSoloNumeros(event);" size="10" value="${registro.telefono}"/>
								</td>
								<td>
								<input tabindex="20" type="text" id="email${status.count}" maxlength="75" name="lEmail" onblur="validaEmail(this.id);" size="30" value="${registro.email}"/>
								</td>
								<td nowrap="nowrap">
								<input  tabindex="21" type="text" id="fechaM${status.count}" esCalendario="true"  name="lFechaMovimiento"onblur="esFechaValida(this.value,this.id)" size="12" value="${registro.fechaMovimiento}"/>
								</td>
								<td nowrap="nowrap">
								<input  tabindex="22"  type="text" id="fechaI${status.count}" esCalendario="true"  name="lFechaInicio" onblur="esFechaValida(this.value,this.id)" size="12" value="${registro.fechaInicio}"/>
								</td>
								<td>
								<input  type="hidden" id="sorganoPerteneciente${status.count}"  name="sorganoPerteneciente" size="20" value="${registro.organoPerteneciente}"/>
									<select  tabindex="23" name="lOrganoPerteneciente" id="organoPerteneciente${status.count}" >
									</select>
								</td>
								<td>
								<input  type="hidden" id="scargo${status.count}"  name="scargo" size="20" value="${registro.cargo}"/>
									<select tabindex="24"  name="lCargo" id="cargo${status.count}" >
									</select>
								</td>
								<td>
								<input   type="hidden" id="spermanente${status.count}"  name="spermanente" size="20" value="${registro.permanente}"/>
									<select   tabindex="25" name="lPermanente" id="permanente${status.count}" >
									</select>
								</td>
								<td>
								<input   type="hidden" id="smanifestCumplimiento${status.count}"  name="smanifestCumplimiento" size="20" value="${registro.manifestCumplimiento}"/>
									<select  tabindex="26" name="lManifestCumplimiento" id="manifestCumplimiento${status.count}" >
									</select>
								</td>
								<td nowrap="nowrap">
							  		<input  tabindex="27" type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarRegistro(this.id)" />
							  		 <input tabindex="28" type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarRegistro()"/>
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
					<input  tabindex="29" type="submit" id="grabar" name="grabar" class="submit" value="Grabar"  />
					<button  tabindex="30" id="generar" name="generar" class="submit" type="button"  >Generar</button>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>
					<input type="hidden" id="tipoBaja" name="tipoBaja" value="tipoBaja"/>								
				</td>
				
			</tr>
		</table>	
	 	<input type="hidden" value="0" name="numero" id="numero" />

 
</fieldset>
</body>
</html>
