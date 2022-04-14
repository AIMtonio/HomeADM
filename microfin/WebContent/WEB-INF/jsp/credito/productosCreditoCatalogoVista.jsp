<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tipoContratoBCServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clasifrepregServicio.js"></script>
<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clasificCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/circuloCreTipConServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaSeguroVidaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="js/credito/productoCredito.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="productosCreditoBean" >
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Productos de Crédito</legend>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Cobros</legend>
	<table border="0" width="100%">
		<tr>
			<td class="label">
		    	<label for="lblproducCreditoID">Producto de Crédito: </label>
			</td>
			<td>
				<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="1"/>
     		</td>
		   <td class="separador"></td>
		   <td class="label">
         		<label for="lbldescripcion">Descripción: </label>
     		</td>
     		<td>
				<form:input id="descripcion" name="descripcion" path="descripcion" size="45" rows="3" tabindex="2" onblur="ponerMayusculas(this)" />
			</td>
		</tr>
		<tr>
			<td class="label">
         		<label for="lblcobraIVAInteres">Cobra IVA Interés: </label>
     		</td>
     		<td>
     			<form:select id="cobraIVAInteres" name="cobraIVAInteres" path="cobraIVAInteres" tabindex="5">
					<form:option value="S">Sí Cobra IVA</form:option>
			     	<form:option value="N">No Cobra IVA</form:option>
				</form:select>
     		</td>
     		<td class="separador"></td>
     		<td class="label" nowrap="nowrap">
         		<label for="lblcobraFaltaPago">Cobra Falta Pago: </label>
     		</td>
     		<td>
     			<form:select id="cobraFaltaPago" name="cobraFaltaPago" path="cobraFaltaPago" tabindex="6">
					<form:option value="S">Sí Cobra </form:option>
			     	<form:option value="N">No Cobra </form:option>
				 </form:select>
     		</td>
		</tr>
		<tr>
			<td class="label">
         		<label for="lblcobraMora">Cobra Mora:</label>
			</td>
     		<td>
         		<form:select id="cobraMora" name="cobraMora" path="cobraMora" tabindex="7">
					<form:option value="S">Sí Cobra </form:option>
			     	<form:option value="N">No Cobra </form:option>
				</form:select>
     		</td>
     		<td class="separador"></td>
     		<td class="label">
        		<label for="lblcobraIVAMora">Cobra IVA Mora: </label>
	   		</td>
	   		<td>
	      		<form:select id="cobraIVAMora" name="cobraIVAMora" path="cobraIVAMora" tabindex="8">
					<form:option value="S">Sí Cobra IVA</form:option>
		     		<form:option value="N">No Cobra IVA</form:option>
				</form:select>
	   		</td>
		</tr>
		<tr>
    		<td class="label">
        		<label for="lblfactorMora">Tipo Cob. Mora: </label>
    		</td>
    		<td>
        	 	<form:select id="tipCobComMorato" name="tipCobComMorato" path="tipCobComMorato" tabindex="9">
					<form:option value="N">N veces Tasa Ordinaria</form:option>
		     		<form:option value="T">Tasa Fija Anualizada</form:option>
				</form:select>
				<label for="lblcobraMora">Moratorio: </label>
			 	<form:input id="factorMora" name="factorMora" path="factorMora" size="5"  esTasa="true" tabindex="10"/>
    		</td>
    		<td class="separador"></td>
    		<td class="label"></td>
	   		<td></td>
		</tr>
		<tr>
	  		<td class="label">
         		<label for="lblesAutomatico">Es Automático:</label>
    		</td>
    		<td>
		  		<form:select id="esAutomatico" name="esAutomatico" path="esAutomatico" tabindex="13">
					<form:option value="S">Sí es Automático</form:option>
		     		<form:option value="N">No es Automático</form:option>
				</form:select>
    		</td>
			<td class="separador"></td>
 		    <td class="label">
        		<label for="lblclasificacion">Clasificación: </label>
    		</td>
    		<td>
     			<form:input id="clasificacion" name="clasificacion" path="clasificacion" size="5" tabindex="14"/>
     		 	<textarea id="descripClasifica" name="descripClasifica" size="40" type="text" readOnly="true" disabled="true"> </textarea>
    		</td>
		</tr>
		<tr>
	  		<td class="label">
         		<label id="lblTipoAutomatico" for="tipoAutomatico">Tipo Autom&aacute;tico:</label>
    		</td>
    		<td>
		  		<form:select id="tipoAutomatico" name="tipoAutomatico" path="tipoAutomatico" tabindex="15">
		  			<form:option value="">SELECCIONAR</form:option>
					<form:option value="I">Sobre Inversión</form:option>
		     		<form:option value="A">Sobre Ahorro</form:option>
				</form:select>
    		</td>
			<td class="separador"></td>
 		    <td class="label">
        		<label id="lblPorcMaximo" for="porcMaximo">Porcentaje M&aacute;ximo: </label>
    		</td>
    		<td>
     			<form:input id="porcMaximo" name="porcMaximo" path="porcMaximo" size="5" tabindex="16"/>
    		</td>
		</tr>
		<tr>
 			<td class="label">
        		<label for="lbltipo">Tipo: </label>
    		</td>
		    <td>
    		 	<form:select id="tipo" name="tipo" path="tipo" tabindex="17" disabled="true" >
				<form:option value="C">Comercial</form:option>
		     	<form:option value="O">Consumo</form:option>
		     	<form:option value="H">Vivienda</form:option>

			</form:select>
    		</td>
    		<td class="separador"></td>
    		<td class="label">
        		<label for="lblcaracteristicas">Características: </label>
    		</td>
    		<td>
        	  <form:textarea id="caracteristicas" name="caracteristicas" path="caracteristicas" size="15" tabindex="18" onblur="ponerMayusculas(this)" />
    		</td>
	</tr>
	<tr>
		<td class="label">
        		<label  for="lbltipoomXap">Ahorro Voluntario: </label>
        	 </td>
    		<td>
    		  <form:select id="ahoVoluntario" name="ahoVoluntario" path="ahoVoluntario" tabindex="19">
		      <form:option value="S">Si</form:option>
		      <form:option value="N">No</form:option>
	      </form:select>
         	<label id="mto" for="lblVar">Monto: </label>
         	<form:input id="porAhoVol" name="porAhoVol" path="porAhoVol" size="12" esmoneda="true" tabindex="20"/>
          	</td>
  		<td class="separador"></td>
  		<td class="separador"></td>
  		<td class="separador"></td>
	</tr>

	<tr>
		  <td class="label">
        		<label for="lblcalInter">Cálculo de Interés </label>
    		</td>
    		 <td>
    		<form:select id="calcInteres" name="calcInteres" path="calcInteres"  tabindex="24" >
				<form:option value="">SELECCIONAR</form:option>
			</form:select>
			</td>
	</tr>
		<td class="label">
        		<label for="lbltipoCalInteres">Tipo Calc. Interés: </label>
    		</td>

    		<td>
    			<form:select id="tipoCalInteres" name="tipoCalInteres" path="tipoCalInteres" tabindex="25">
     			<form:option value="">SELECCIONAR</form:option>
		      	<form:option value="1">SALDOS INSOLUTOS</form:option>
		      	<form:option value="2">MONTO ORIGINAL</form:option>
	      </form:select>
	   </td>
			   <td class="separador"></td>
			   <td class="seccionProyInt" class="label" nowrap="nowrap">
			       		<label for="lbltipoCalInteres">Proy. Interés Pago Adel. : </label>
			   		</td>
			   		<td class="seccionProyInt"  nowrap="nowrap">
			   			<form:select id="proyInteresPagAde" name="proyInteresPagAde" path="proyInteresPagAde" tabindex="26">
			    			<form:option value="S">Sí</form:option>
				      	<form:option value="N">No</form:option>
			      </form:select>
			   </td>
	   		<tr>
				<tr id="trTipoGenInteres">
				<td class="label">
					<label for="lblTipoGenInteres">Tipo Gen. Interés: </label>
				</td>
				<td>
					<form:select id="tipoGeneraInteres" name="tipoGeneraInteres" path="tipoGeneraInteres" tabindex="27">
						<form:option value="">SELECCIONAR</form:option>
						<form:option value="I">IGUALES</form:option>
						<form:option value="D">D&Iacute;AS TRANSCURRIDOS</form:option>
					</form:select>
				</td>
			</tr>
			<tr>
					<td class="label">
		         		<label for="lblInstitucion">Inst. Fondeo: </label>
		     		</td>
		     		<td>
		     			<form:input id="institutFondID" name="institutFondID" path="institutFondID" size="12" tabindex="28" />
		     			<input type="text" id="descripFondeo" name="descripFondeo" size="45" tabindex="28" disabled="true"/>
				   </td>
				   <td class="separador"></td>

				   <td class="label">
		         		<label for="lblPermitePrepago">Permite Prepago : </label>
		     		</td>
		     		<td>
		     			<form:select id="permitePrepago" name="permitePrepago" path="permitePrepago" tabindex="29">
			     			<form:option value="">SELECCIONAR</form:option>
			     			<form:option value="S">Sí</form:option>
					      	<form:option value="N">No</form:option>
				      </form:select>
				   </td>

			 </tr>
			 <tr id="prepago" >
			 	<td class="label">
		         	<label for="lblmodPrepagoBase">Modificar Prepago Base: </label>
		     	</td>
		     	<td>
					<form:radiobutton id="modificarPrepago" name="modificarPrepago" path="modificarPrepago" value="S" tabindex="30" />
					<label for="si">Si</label>
					<form:radiobutton id="modificarPrepago2" name="modificarPrepago2" path="modificarPrepago" value="N" tabindex="31" />
					<label for="no">No</label>
				</td>
				  <td class="separador"></td>
				<td>
		     			<label for="lbl">Tipo Prepago Capital: </label>
				</td>
				<td>
		     			<form:select id="tipoPrepago" name="tipoPrepago" path="tipoPrepago" tabindex="32">
			     			<form:option value="">SELECCIONAR</form:option>
			     			<form:option value="U">Últimas Cuotas</form:option>
					      	<form:option value="I">Cuotas Siguientes Inmediatas</form:option>
							<form:option value="V">Prorrateo Cuotas Vigentes</form:option>
							<form:option value="P">Pago Cuotas Completas Proyectadas</form:option>
				      </form:select>
				   </td>
			 </tr>

			<tr>
				<td class="label">
					<label for="lblProductoNomina">Producto de Nómina: </label>
				</td>
				<td>
					<form:radiobutton id="productoNomina" name="productoNomina" path="productoNomina" value="S" tabindex="33" />
					<label for="si">Si</label>
					<form:radiobutton id="productoNomina2" name="productoNomina2" path="productoNomina" value="N" tabindex="34" />
					<label for="si">No</label>
				</td>


			</tr>
			<tr class="ocultarSeguroCuota">
				<td class="label">
					<label for="cobraSeguroCuota">Cobro de Seguro por Cuota: </label>
					<input type="hidden" id="mostrarSeguroCuota" name="mostrarSeguroCuota"/>
				</td>
				<td>
					<form:radiobutton id="cobraSeguroCuota" name="cobraSeguroCuota" path="cobraSeguroCuota" value="S" tabindex="35" />
					<label for="cobraSeguroCuota">Si</label>
					<form:radiobutton id="cobraSeguroCuota2" name="cobraSeguroCuota" path="cobraSeguroCuota" value="N" tabindex="35" />
					<label for="cobraSeguroCuota">No</label>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="cobraIVASeguroCuota">Cobra IVA de Seguro por Cuota: </label>
				</td>
				<td>
					<form:select id="cobraIVASeguroCuota" name="cobraIVASeguroCuota" path="cobraIVASeguroCuota" tabindex="36">
					<form:option value="S">Sí Cobra IVA</form:option>
					<form:option value="N" selected="selected">No Cobra IVA</form:option>
					</form:select>
				</td>
			</tr>
			<tr class="ocultarAccesorios">
				<td class="label">
					<label for="cobraAccesorios">Cobro de Accesorios: </label>
				</td>
				<td>
					<form:radiobutton id="cobraAccesorios" name="cobraAccesorios" path="cobraAccesorios" value="S" tabindex="37"/>
					<label for="cobraAccesorios">Si</label>
					<form:radiobutton id="cobraAccesorios2" name="cobraAccesorios" path="cobraAccesorios" value="N" tabindex="37"/>
					<label for="cobraAccesorios">No</label>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="requiereAnalisiCre"> Requiere Análisis de Crédito: </label>
				</td>
				<td>
					<form:radiobutton id="requiereAnalisiCre" name="requiereAnalisiCre" path="requiereAnalisiCre" value="S" tabindex="38" />
					<label for="si">Si</label>
					<form:radiobutton id="requiereAnalisiCre2" name="requiereAnalisiCre2" path="requiereAnalisiCre" value="N" tabindex="38" />
					<label for="si">No</label>
				</td>


			</tr>
	</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Comisión por Apertura</legend>
	<table border="0"  width="100%">
		<tr>
			<td class="label">
	        		<label for="lbltipoComXapert">Tipo Com. x Apertura: </label>
	    		</td>
	    		<td>
	    			<form:select id="tipoComXapert" name="tipoComXapert" path="tipoComXapert" tabindex="38">
				      <form:option value="M">Monto</form:option>
				      <form:option value="P">Porcentaje</form:option>
			      </form:select>
		   </td>
	    		<td class="separador"></td>
	    		<td class="label">
	        		<label for="lblValor">Valor: </label>
	    		</td>
	    		<td>
	    			<form:input id="montoComXapert" name="montoComXapert" path="montoComXapert" size="12" esMoneda="true" tabindex="39"/>
		   </td>
		</tr>


		<tr>
			<td class="label">
        		<label for="lbltipoComXapert">Tipo Forma de Cobro: </label>
    		</td>
    		<td>
    			<select id="formaComApertura" name="formaComApertura" path="formaComApertura" tabindex="40">
			      	<option value="F">Financiamiento</option>
			      	<option value="D">Deduccion</option>
			      	<option value="A">Anticipado</option>
			      	<option value="P">Programado</option>
		      	</select>
	   		</td>

		</tr>

		<tr style="display: none;">
			<td class="label">
				<form:input type="hidden" id="reqConsolidacionAgro" name="reqConsolidacionAgro" path="reqConsolidacionAgro" value="N"/>
				<form:input type="hidden" id="fechaDesembolso" name="fechaDesembolso" path="fechaDesembolso" value="N"/>
     		</td>
		</tr>
	</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Condiciones</legend>
	<table border="0" width="100%">
		<tr>
			<td class="label">
         		<label for="lbltipoPersona">Tipo Persona: </label>
			</td>
		   	<td>
		    	<select id="tipoPersona" name="tipoPersona" path="tipoPersona" tabindex="41">
					<option value="F">Física</option>
			     	<option value="M">Moral</option>
			     	<option value="A">Ambas</option>
				</select>
     		</td>
		   	<td class="separador"></td>
			<td class="label">
         		<label for="lblesGrupal">Es Grupal: </label>
     		</td>
     		<td>
     			<select id="esGrupal" name="esGrupal" path="esGrupal" tabindex="42">
					<option value="N">No es Grupal</option>
					<option value="S">Sí es Grupal</option>
			    </select>
     		</td>
		</tr>
 		<tr>
			<td class="label">
         		<label for="lbltrequiereGarantia">Requiere Garantía: </label>
		  	</td>
		  	<td>
		   		<select id="requiereGarantia" name="requiereGarantia" path="requiereGarantia" tabindex="43">
					<option value="S">Sí Requiere</option>
					<option value="I">Indistinto</option>
			     	<option value="N">No Requiere</option>
				</select>
			</td>
		   	<td class="separador"></td>
		     <td class="label">
         		<label for="lblPerGarCruz">Permite Garantías Cruzadas: </label>
		  	 </td>
		  	 <td>
		  	 	<select id="perGarCruzadas" name="perGarCruzadas" path="perGarCruzadas" tabindex="44" disabled="false" >
		  	 		<option value="">SELECCIONAR</option>
					<option value="S">Sí Permite</option>
			     	<option value="N">No Permite</option>
				</select>
		   	</td>
     	</tr>
		<tr>
		   	<td class="label">
         		<label for="lbltrelGarantCred">Relación Garantía Crédito: </label>
		  	 </td>
		  	 <td>
		  	 	<form:input id="relGarantCred" name="relGarantCred" path="relGarantCred" size="12" tabindex="45" disabled="false"/>
     		</td>
		   	<td class="separador"></td>
			<td class="label">
         		<label for="lblrequiereAvale">Requiere Avales: </label>
     		</td>
     		<td>
     			<select id="requiereAvales" name="requiereAvales" path="requiereAvales" tabindex="46">
					<option value="S">Sí Requiere</option>
					<option value="I">Indistinto</option>
			     	<option value="N">No Requiere</option>
				</select>
     		</td>
     		</tr>
     		<tr>
		  <td class="label">
         		<label for="lbltrelGarantCred">Permite Avales Cruzados: </label>
		  	 </td>
		  	 <td>
		  	 	<select id="perAvaCruzados" name="perAvaCruzados" path="perAvaCruzados" tabindex="47" disabled="false" >
		  	 		<option value="">SELECCIONAR</option>
					<option value="S">Sí Permite</option>
			     	<option value="N">No Permite</option>
				</select>
     		</td>
     	<td class="separador"></td>
		   <td class="label">
         	<label for="lblesReestructura">Es Reestructura/Renovaci&oacute;n: </label>
     		</td>
     		<td>
				<form:select id="esReestructura" name="esReestructura" path="esReestructura" tabindex="48">
					<form:option value="">SELECCIONAR</form:option>
					<form:option value="S">SI PERMITE</form:option>
			     	<form:option value="N">NO PERMITE</form:option>
				</form:select>
     		</td>
     		</tr>

     		<tr>
				<td class="label">
					<label for="lblcantidadAvales">Hasta Cuantos Creditos Avalados: </label>
				</td>

				<td>
					<form:input id="cantidadAvales" name="cantidadAvales" path="cantidadAvales" tabindex="49" type="text" value="0" size="12" disabled="true" onkeyPress="return validador(event);" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="lblintercambioAvales">Intercambio de Avales: </label>
				</td>
				<td>
					<form:radiobutton id="intercambioAvalesRatioSi" name="intercambioAvalesRatio" path="intercambioAvalesRatio" tabindex="50" type="radio" value="S" />
					<label for="si">Si</label>
					<form:radiobutton id="intercambioAvalesRatioNo" name="intercambioAvalesRatio" path="intercambioAvalesRatio" tabindex="51" type="radio" value="N" />
					<label for="no">No</label>
				</td>
			</tr>
			<tr>

     		<td class="label">
         		<label for="reqObligadosSolidarios">Requiere Obligados Solidarios: </label>
     		</td>

		<td>
		   		<select id="obligadosSolidarios" name="requiereObligadosSolidarios" path="requiereObligadosSolidarios" tabindex="52">
					<option value="S">Sí Requiere</option>
					<option value="I">Indistinto</option>
			     	<option value="N">No Requiere</option>
				</select>
			</td>
		<td class="separador"></td>
		<td>
		<label for="permObligadosCruzados">Permite Obligados Solidarios Cruzados: </label>
		<select id="obligadosCruzados" name="permObligadosCruzados" path="permObligadosCruzados" tabindex="53">
					<option value="">SELECCIONAR</option>
					<option value="S">Sí Permite</option>
			     	<option value="N">No permite</option>
				</select>
     </td>
		</tr>
			<tr>
     		<td class="label">
         		<label for="inicioAfuturo">Obligado Solidario requiere consulta SIC </label>
     		</td>
     		<td>
     			<form:radiobutton id="noConsultaSIC" name="sireqConsultaSIC" path="reqConsultaSIC" value="S" tabindex="54" />
					<label for="si">Si</label>
				<form:radiobutton id="siConsultaSIC" name="noreqConsultaSIC" path="reqConsultaSIC" value="N" tabindex="54" />
					<label for="no">No</label>
     		</td>

     	</tr>


     		<tr>
		   <td class="label">
         	<label for="lblmontoMinimo">Monto Mínimo: </label>
     		</td>
     		<td>
         	 <form:input id="montoMinimo" name="montoMinimo" path="montoMinimo" size="12" tabindex="55"  esMoneda="true"/>
     		</td>
		<td class="separador"></td>
		<td class="label">
         	<label for="lblmontoMaximo">Monto Máximo:</label>
			</td>
     		<td>
         	 <form:input id="montoMaximo" name="montoMaximo" path="montoMaximo" size="12" tabindex="56"  esMoneda="true"/>
     		</td>
		</tr>
		<tr>
		   <td class="label">
         		<label for="lblmargenPagIguales">Margen de Pagos Iguales: </label>
     		</td>
     		<td>
         	 	<form:input id="margenPagIgual" name="margenPagIgual" path="margenPagIgual" size="12" esMoneda="true" tabindex="57"/>
     		</td>
     		<td class="separador"></td>
     		<td class="label">
         		<label for="autorizaComite">Permite Funcionarios y/o Relacionados: </label>
     		</td>
     		<td>
         	 	<form:select id="autorizaComite" name="autorizaComite" path="autorizaComite" tabindex="58">
         	 		<form:option value="N">NO</form:option>
					<form:option value="S">SI</form:option>
				</form:select>
     		</td>
     	</tr>
     	<tr>
     		<td class="label">
         		<label for="lblcalculoRatios">Cálculo Ratios: </label>
     		</td>
     		<td>
     			<form:radiobutton id="calculoRatios1" name="calculoRatios1" path="calculoRatios" value="S" tabindex="59" />
					<label for="si">Si</label>
				<form:radiobutton id="calculoRatios2" name="calculoRatios2" path="calculoRatios" value="N" tabindex="60" />
					<label for="si">No</label>
     		</td>
     		<td class="separador"></td>
     		<td><label for="lbPermiteProspecto">Permite Autorización Solicitud por Prospecto:</label> </td>
     		<td>
     			<form:radiobutton id="siPermiteAutSolPros" name="permiteAutSolPros" path="permiteAutSolPros" value="S" tabindex="61" />
				<label for="si">Si</label>
				<form:radiobutton id="noPermiteAutSolPros" name="permiteAutSolPros" path="permiteAutSolPros" value="N" tabindex="62" checked="true"/>
				<label for="no">No</label>
     		</td>
     	</tr>
     	<tr>
     		<td class="label">
         		<label for="inicioAfuturo">Inicio del Cr&eacute;dito Posterior al Desembolso: </label>
     		</td>
     		<td>
     			<form:radiobutton id="inicioAfuturoSi" name="inicioAfuturo" path="inicioAfuturo" value="S" tabindex="63" />
					<label for="si">Si</label>
				<form:radiobutton id="inicioAfuturoNo" name="inicioAfuturo" path="inicioAfuturo" value="N" tabindex="64" />
					<label for="no">No</label>
     		</td>
     		<td class="separador" id="separador"></td>
     		<td class="label">
         		<label for="lbldiasMaximo" id="labelDiasMaximo"> </label>
     		</td>
     		<td id="tdDiasMaximo" style="display:none;">
     			<form:input id="diasMaximo" name="diasMaximo" path="diasMaximo" size="12" tabindex="65"/>
     		</td>
     	</tr>
		<tr>
     		<td><label for="requiereReferencias">Requiere Referencias:</label></td>
     		<td>
     			<select id="requiereReferencias" name="requiereReferencias" path="requiereReferencias" tabindex="66">
			     	<option value="N">No Requiere</option>
			     	<option value="S">Sí Requiere</option>
					<option value="I">Indistinto</option>
				</select>
     		</td>
     		<td class="separador"></td>
     		<td class="label" id="mostrarMinReferencias1">
         		<label for="minReferencias">Mínimo de Referencias: </label>
     		</td>
     		<td id="mostrarMinReferencias2">
         		 <form:input type="text" id="minReferencias" name="minReferencias" path="minReferencias" size="12" tabindex="67" onkeypress="return validaSoloNumero(event,this);" maxlength="3"/>
     		</td>
		</tr>
		<tr>
			<td><label for="requiereCheckList">Requiere CheckList:</label></td>
     		<td>
     			<select id="requiereCheckList" name="requiereCheckList" path="requiereCheckList" tabindex="68">
			     	<option value="N">No Requiere</option>
			     	<option value="S">Sí Requiere</option>
					<option value="I">Indistinto</option>
				</select>
     		</td>
			<td class="separador"></td>
     		<td class="label">
         		<label for="financiamientoRural">Financiamiento Rural: </label>
     		</td>
     		<td>
     			<form:radiobutton id="financiamientoRural1" name="financiamientoRural1" path="financiamientoRural" value="S" tabindex="69" />
					<label for="si">Si</label> <form:radiobutton
									id="financiamientoRural2" name="financiamientoRural2"
									path="financiamientoRural" value="N" tabindex="70" /> <label for="no">No</label>
     		</td>
		</tr>
		<tr>
			<td class="label">
         		<label for="permiteConsolidacion">Permite Consolidación: </label>
     		</td>
     		<td>
         	 	<select id="permiteConsolidacion" name="permiteConsolidacion" path="permiteConsolidacion" tabindex="71">
         	 		<option value="">SELECCIONAR</option>
         	 		<option value="S">SI</option>
         	 		<option value="N">NO</option>
				</select>
     		</td>
			<td class="separador"></td>
     		<td class="label">
         		<label for="instruDispersion">Instrucciones de dispersión: </label>
     		</td>
     		<td>
         	 	<select id="instruDispersion" name="instruDispersion" path="instruDispersion" tabindex="72">
         	 		<option value="">SELECCIONAR</option>
         	 		<option value="S">SI</option>
         	 		<option value="N">NO</option>
				</select>
     		</td>
		</tr>
		<tr>
			<td class="label">
				<label for="numeroOrden">Datos del Conyuge Obligatorios:</label>
				<a href="javaScript:" onClick="ayudaValConyuge();">
					  <img src="images/help-icon.gif" >
				</a>
			</td>
			<td>
				<form:radiobutton id="validaConyu1" name="validaConyu1" path="validacionConyuge" value="S" />
					<label for="si">Si</label>
				<form:radiobutton id="validaConyu2" name="validaConyu2" path="validacionConyuge" value="N" />
					<label for="no">No</label>
			</td>
		</tr>
	</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Línea Crédito</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
         		<label for="lblmanejaLinea">Maneja Línea: </label>
     		</td>
     		<td>
         		<select id="manejaLinea" name="manejaLinea" path="manejaLinea" tabindex="71">
					<option value="S">Sí Maneja</option>
			     	<option value="N">No Maneja</option>
				</select>
			</td>
     		<td class="separador"></td>
     		<td class="label">
				<label for="lblesRevolvente">Es Revolvente:</label>
			</td>
     		<td>
     			<select id="esRevolvente" name="esRevolvente" path="esRevolvente" tabindex="72">
					<option value="S">Sí es Revolvente</option>
			     	<option value="N">No es Revolvente</option>
				</select>
     		</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblmanejaLinea">Afectación Contable: </label>
			</td>
			<td>
				<select id="afectacionContable" name="afectacionContable" path="afectacionContable" tabindex="73">
					<option value="S">Sí</option>
					<option value="N">No</option>
				</select>
			</td>
			<td class="separador"></td>
			<td class="label seccionComAnual">
				<label for="lblCobraComAnual">Cobra Comisi&oacute;n Anual: </label>
			</td>
			<td class="seccionComAnual">
				<form:radiobutton id="cobraComAnual1" name="cobraComAnual1" path="cobraComAnual" value="S" tabindex="74" /><label for="si">Si</label>
				<form:radiobutton id="cobraComAnual2" name="cobraComAnual2" path="cobraComAnual" value="N" tabindex="75" checked="true" /><label for="no">No</label>
			</td>
		</tr>
		<tr class="seccionComAnual">
			<td class="label">
				<label for="lblTipoComAnual">Tipo Comisi&oacute;n Anual</label>
			</td>
			<td>
				<select id="tipoComAnual" name="tipoComAnual" path="tipoComAnual" tabindex="76">
					<option value="">SELECCIONAR</option>
					<option value="P">PORCENTAJE</option>
					<option value="M">MONTO</option>
				</select>
			</td>
			<td class="separador"></td>
			<td class="=label">
				<label for="lblValorComAnual">Valor Comisi&oacute;n;</label>
			</td>
			<td>
				<form:input id="valorComAnual" name="valorComAnual" path="valorComAnual" size="15" maxlength="15" tabindex="77" esmoneda="true" onkeypress="validaLetraNum(event)"/>
			</td>
		</tr>
	</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all" type = "hidden" id = "grupales" >
	<legend>Grupales:</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="lbltg">Tipo de Grupo:</label>
			</td>
	  	<td class="label" colspan="2">
	        	<label for="lblesm">Exclusivo Solo Mujeres:</label>
				<input type="radio" id="eMujeres"	tabindex="90">
		</tr>
		<tr >
			<td class="separador"></td>
		 	<td class="label" colspan="2">
	        	<label for="lblesh">Exclusivo Solo Hombres:</label>
	         	<input type="radio" id="eHombres"	tabindex="91">
			</td>
		</tr>
		<tr >
		 	<td class="separador"></td>
			<td class="label" colspan="2">
	        	<label for="lblmix">Mixto:</label>
	         	<input type="radio" id="gMixto"	tabindex="92">
			</td>
		</tr>
		<tr id="gIntegrantes">
			<td class="label" nowrap="nowrap">
	        	<label for="lblMaxIntegrantes">No. Máximo Integrantes:</label>
			</td>
	     	<td>
	          <form:input id="maximoIntegrantes" name="maximoIntegrantes"  path="maxIntegrantes"
	             size="12" maxlength="10"  tabindex="93"  onkeyPress="return validador(event);" />
			</td>
     		<td class="separador"></td>
			<td class="label" >
         		<label for="lblMinIntegrantes">No. Mínimo Integrantes:</label>
     		</td>
     		<td>
         	 	<form:input id="minimoIntegrantes" name="minimoIntegrantes" path="minIntegrantes"
         	 	 size="12" maxlength="10"  tabindex="94"  onkeyPress="return validador(event);" />
     		</td>
		</tr>
		<tr id="gMujeres">
     		<td class="label" nowrap="nowrap">
         		<label for="lblmaximomujeres">No. Máximo Mujeres:</label>
     		</td>
     		<td>
         		<form:input id="maxMujeres" name="maxMujeres" path="maxMujeres" size="12" maxlength="10" tabindex="95"
         		 onkeyPress="return validador(event);" />
     		</td>
     		<td class="separador" ></td>
     		<td class="label" >
	         	<label for="lblminimomujeres">No. Mínimo Mujeres:</label>
			</td>
     		<td>
         		<form:input id="minMujeres" name="minMujeres" path="minMujeres" size="12" 	maxlength="10" tabindex="96"
         		 onkeyPress="return validador(event);" />
     		</td>
		</tr>
		<tr id="gMujeresS">
     		<td class="label" nowrap="nowrap">
         		<label for="lblmaximomujeresolteras">No. Máximo Mujeres Solteras:</label>
     		</td>
     		<td>
         		<form:input id="maxMujeresSol" name="maxMujeresSol" path="maxMujeresSol" size="12" 	maxlength="10" tabindex="97"
         		 onkeyPress="return validador(event);"/>
     		</td>
     		<td class="separador"></td>
     		<td class="label" >
         		<label for="lblminmujeressolteras">No. Mínimo Mujeres Solteras:</label>
			</td>
     		<td>
         	 	<form:input id="minMujeresSol" name="minMujeresSol" path="minMujeresSol" size="12" maxlength="10" tabindex="98" onkeyPress="return validador(event);" />
     		</td>
			</tr>
			<tr id="gHombres">
	     		<td class="label" nowrap="nowrap">
	         		<label for="maximohombres">No. Máximo Hombres:</label>
	     		</td>
	     		<td>
	         		<form:input id="maxHombres" name="maxHombres" path="maxHombres" size="12" 	maxlength="10" tabindex="99" onkeyPress="return validador(event);" />
	     		</td>
	     		<td class="separador"></td>
	     		<td class="label" >
	         		<label for="minimohombres">No. Mínimo Hombres:</label>
				</td>
	     		<td>
	         		<form:input id="minHombres" name="minHombres" path="minHombres" size="12" 	readOnly="true"	maxlength="10" tabindex="100" onkeyPress="return validador(event);" />
	     		</td>
			 </tr>
			<tr>
	     		<td class="label" >
	         		<label for="lbltasaponderadagrupal">Tasa Ponderada Grupal:</label>
				</td>
	     		<td>
	         		<select id="tasaPonderaGru" name="tasaPonderaGru" path="tasaPonderaGru" tabindex="101">
						<option value="N">No</option>
						<option value="S">Sí</option>
				   </select>
	     		</td>
	     		<td class="separador"></td>
				<td class="label">
	         		<label for="lblpermiteRomp">Permite Rompimiento Grupo:</label>
				</td>
	     		<td>
	     			<select id="perRompimGrup" name="perRompimGrup" path="perRompimGrup" disabled="true"	tabindex="102">
	     				<option value="N">No</option>
	     				<option value="S">Sí</option>
				    </select>
	     		</td>
	     	</tr>
			<tr>
		   		<td class="label">
	        		<label for="lblRangoInicial">Rango Inicial Ciclo Grupal:</label>
	    		</td>
    			<td>
        			<form:input id="raIniCicloGrup" name="raIniCicloGrup" path="raIniCicloGrup" size="12" disabled="false" tabindex="103"/>
				</td>
				<td class="separador"></td>
				<td class="label">
	        		<label for="lblrangoFin">Rango Final Ciclo Grupal:</label>
				</td>
    			<td>
        			<form:input id="raFinCicloGrup" name="raFinCicloGrup" path="raFinCicloGrup" size="12" disabled="false" tabindex="104"/>
    			</td>
    			</tr>
    			<tr>
    			<td class="label">
		         	<label for="lblprorrateoPago">Prorrateo Pago:</label>
		     		</td>
		     		<td>

		         		<select id="prorrateoPago" name="prorrateoPago" path="prorrateoPago" tabindex="105">
							<option value="S">Si</option>
							<option value="N">No</option>
						</select>
					</td>
    		</tr>
		</table>
		</fieldset>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Capital Contable</legend>
	<table >
		<tr>
     		<td class="label">
         		<label for="lblValidaCapConta">Valida Cap. Contable:</label>
     		</td>
     		<td>
         		<select id="validaCapConta" name="validaCapConta" path="validaCapConta" tabindex="120">
					<option value="S">Si</option>
					<option value="N">No</option>
				</select>
			</td>
			<td class="separador"></td>
     	    <td class="label" nowrap="nowrap">
         		<label for="lblPorcMaxCapConta">Porcentaje Máx. de un Crédito: </label>
     		</td>
     		<td>
	     	    <form:input id="porcMaxCapConta" name="porcMaxCapConta" path="porcMaxCapConta" maxlength="11" size="12" esTasa= "true"    tabindex="121"/>
	     	    <label for="lblPorc"> %</label>
     		</td>
 		</tr>

 		</table>
	</fieldset>
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Días</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"><label for="lblgraciaFaltaPago">Gracia Falta Pago:</label></td>
					<td><form:input id="graciaFaltaPago" name="graciaFaltaPago" path="graciaFaltaPago" size="12" tabindex="130" /></td>
					<td class="separador"></td>
					<td class="label"><label for="lblgraciaMoratorios">Gracia Moratorios: </label></td>
					<td><form:input id="graciaMoratorios" name="graciaMoratorios" path="graciaMoratorios" size="12" tabindex="131" /></td>
				</tr>
				<tr>
					<td class="label"><label for="lbldiasSuspesion">Días Suspensión: </label></td>
					<td><form:input id="diasSuspesion" name="diasSuspesion" path="diasSuspesion" size="12" tabindex="132" /></td>
					<td class="separador"></td>
					<td class="label"><label for="lbldiasPasoVencido">Días Paso Atraso: </label></td>
					<td><form:input id="diasPasoAtraso" name="diasPasoAtraso" path="diasPasoAtraso" size="12" tabindex="133" /></td>
				</tr>
				<tr>
					<td class="label"><label for="diasAtrasoMin">D&iacute;as Castigo:</label></td>
					<td><form:input id="diasAtrasoMin" name="diasAtrasoMin" path="diasAtrasoMin" size="12" tabindex="134" /></td>
				</tr>
			</table>
		</fieldset>

<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>RECA-CONDUSEF</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
		     		<td class="label">
		         	<label for="lblregistroRECA">No. Registro RECA:</label>
					</td>
		     		<td>
		         	 <form:input id="registroRECA" name="registroRECA" path="registroRECA" size="45" tabindex="140"/>
		     		</td>
		     		<td class="separador"></td>
		     		<td class="label">
		         	<label for="lblfechaIns">Fecha Inscripción:</label>
		     		</td>
		     		<td>
		         	 <form:input id="fechaInscripcion" name="fechaInscripcion" path="fechaInscripcion" size="20" esCalendario="true" tabindex="141"/>
		     		</td>
		 	</tr>
		 	<tr>
		     		<td class="label">
		         		<label for="lblnombreComercial">Nombre Comercial:</label>
		     		</td>
		     		<td>
		         	 	<form:input id="nombreComercial" name="nombreComercial" path="nombreComercial" size="45" tabindex="142"/>
		     		</td>
			 		<td class="separador"></td>
			 		<td class="label">
		         		<label for="lbltipoCredito">Tipo Crédito:</label>
				   </td>
				   <td>
				      <form:input id="tipoCredito" name="tipoCredito" path="tipoCredito" size="20" 	tabindex="143"/>
				   </td>
		 	</tr>
						<form:input type="hidden" id="modalidadPago" name="modalidadPago" path="modalidad" />
						<form:input type="hidden" id="reqSeguro" name="reqSeguro" path="reqSeguroVida" />
						<form:input type="hidden" id="factorRiesgoSeg" name="factorRiesgoSeg" path="factorRiesgoSeguro" />
						<form:input type="hidden" id="tipoPagoSeg" name="tipoPagoSeg" path="tipoPagoSeguro" />
						<form:input type="hidden" id="descSeguro" name="descSeguro" path="descuentoSeguro" />
						<input type="hidden" id="montoPol" name="montoPol" path="montoPolSegVida" esmoneda="true" />


    	</table>
	</fieldset>

<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>C&iacute;rculo y Bur&oacute; de Cr&eacute;dito</legend>
		<table border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="label">
	         		<label for="lblclasificacion">Contrato BC: </label>
	     		</td>
	     		<td>

		     		 <form:input id="tipoContratoBC" name="tipoContratoBC" path="tipoContratoBCID" size="3" tabindex="180"/>
		     		<input type="text" id="descContrato" name="descContrato" size="50" tabindex="181" disabled="true"/>

	     		</td>
	     	</tr>
			<tr>
				<td class="label">
	         		<label for="lblclasificacion">Contrato C&iacute;rculo de Cr&eacute;dito: </label>
	     		</td>
	     		<td>

		     		 <form:input id="tipoContratoCCID" name="tipoContratoCCID" path="tipoContratoCCID" size="3" tabindex="182"/>
		     		<input type="text" id="tipoContratoCCIDDes" name="tipoContratoCCIDDes" size="50" tabindex="183" disabled="true"/>

	     		</td>
	     	</tr>
		</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>PLD</legend>
		<table border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="label">
	         		<label for="lblclaveRiesgo">Nivel de Riesgo: </label>
	     		</td>
		     		<td>
		         		<select id="claveRiesgo" name="claveRiesgo" path="claveRiesgo" tabindex="184">
		         			<option value="">SELECCIONAR</option>
							<option value="A">Alto</option>
							<option value="B">Bajo</option>
						</select>
					</td>
	     	</tr>
		</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all  tipoSofipo">
	<legend>Regulatorios</legend>
		<table border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="label">
	         		<label for="claveCNBV">Tipo Producto CNBV: </label>
	     		</td>
		     		<td>
		         		<form:input id="claveCNBV" name="claveCNBV" path="claveCNBV" size="15" maxlength="9" tabindex="185" />
					</td>
	     	</tr>
		</table>
	</fieldset>

	<br>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>SPEI</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="50%">
		   		<tr>
			 	    <td class="label">
			        	<label for="lblParticipaSpei">Participa en SPEI: </label>
				    </td>
			    	<td>
						<select id="participaSpei" name="participaSpei" path="participaSpei" tabindex="186">
							<option value="">SELECCIONAR</option>
							<option value="S">Si</option>
					     	<option value="N">No</option>
						</select>
			     	</td>
			     	<td class="separador"></td>
			     	<td class="label">
			        	<label for="lblClaveSpei">Clabe Producto SPEI: </label>
			     	</td>
			     	<td>
			     		<form:input type="text" id="productoClabe" name="productoClabe" path="productoClabe" size="15"
			         		tabindex="187" maxlength="3" style="text-align: right;"/>
			     	</td>
			 	</tr>
			</table>
		<br>
	</fieldset>
	<br>
		<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="198"/>
				<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="199"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			</td>
		</tr>
	</table>
	</fieldset>

	<br>

</form:form>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<form:form id="formaGenerica1" name="formaGenerica1" method="POST"  commandName="esquemaSeguroVidaBean"  action="/microfin/esquemaSeguroVidaControl.htm" >

	<legend>Seguro de Vida</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		     	<td class="label">
		         	<label for="lblgraciaFaltaPago">Seguro de vida</label>
				</td>

		     	<td>
					<input type="radio" id="reqSeguroVida" name="reqSeguroVida"   value="S" 	tabindex="188" />
					<label for="si">Si</label>
					<input type="radio" id="reqSeguroVida2" name="reqSeguroVida2"  value="N" 	tabindex="189"/>
					<label for="si">No</label>
		     	</td>
		     	<td class="separador"></td>
		     	<td class="label">
		         	<label for="lblfactorRS">Modalidad: </label>
		     	</td>
		     	<td>
					<input type="radio" id="unico" name="unico"  value="U" tabindex="190" />
					<label for="si">Único</label>
					<input type="radio" id="tipoPago" name="tipoPago"  value="T" tabindex="191"/>
					<label for="si">Por Tipo de Pago</label>

				</td>
		 		</tr>

		 		<tr id="agregaMod">
		 	    	<td colspan="9">
						<div id="gridAvales" style="display: none;"></div>
					</td>
		 		</tr>

<!-- 		 	<table border="0" cellpadding="4" cellspacing="0" >
 -->			<tr id="Seguro1">
				<td class="label">
		         	<label for="lblfactorRS">Factor R/S: </label>
		     	</td>
		     	<td>

		        <input id="factorRiesgoSeguro" name="factorRiesgoSeguro" path="factorRiesgoSeguro" size="12" seisDecimales="true" tabindex="192"/>
		     		</td>

		 		<td class="separador"></td>
		 		<td class="label">
		         	<label for="lbltipoPAgo">Tipo de Pago</label>
		     		</td>
		     		<td>

		         		<select id="tipoPagoSeguro" name="tipoPagoSeguro" path="tipoPagoSeguro" tabindex="193">
							<option value="F">Financiamiento</option>
							<option value="D">Deduccion</option>
							<option value="A">Adelantado</option>
						</select>
					</td>
			    </tr>

			<tr id="Seguro2">
		 		<td class="label">
		 		 <label for="lblporcentajeDescuento">Porcentaje de Descuento: </label>
				   </td>
				   <td>

				      <input id="descuentoSeguro" name="descuentoSeguro" path="descuentoSeguro" size="12" esmoneda="true" 			tabindex="194"/>
				      <label for="lblPorc1"> %</label>
		     		</td>

		 		<td class="separador"></td>
		 		<td class="label">
		         	<label for="lblmontoPoliza">Monto Póliza:</label>
		     		</td>
		     		<td>

			         	<input id="montoPolSegVida" name="montoPolSegVida" path="montoPolSegVida" size="12" esmoneda="true"		tabindex="195"/>
		     		    <input type="hidden" id="productCreditoID" name="productCreditoID" path="productCreditoID" />
		     		    <input type="hidden" id="reqSeguroV" name="reqSeguroV" path="reqSeguroVida" />
		     			<input type="hidden" id="modalid" name="modalid" path="modalidad" />
		     		</td>
		     </tr>

		     <tr id="Seguro3">
		     <td align="right" colspan="5">
		     	<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="196"/>

			</td>
			 </tr>

			</table>

				<div id="divGrid">

					<!-- Muestra la tabla con los esquemas de garantia liquida del producto de credito seleccionado-->
					<div id="tablaGrid"></div>
					<br>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td align="right" colspan="5">

									<input type="submit" id="graba" name="graba" class="submit" value="Grabar" tabindex="197"/>
									<input type="hidden" id="tipoTransaccionGrid" name="tipoTransaccionGrid" />
									<input type="hidden" value="0" name="esquemaSegVidID" id="esquemaSegVidID" path="esquemaSeguroID" />

								</td>
							</tr>
				 		</table>
					</div>


		</form:form>
	 </fieldset>

</div>

<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje"  style='display: none;'></div>
</html>
