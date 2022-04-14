var esTab = false;
var cat_TipoCanales = {
	'Creditos' 		: 1,
	'CuentasAho' 	: 2,
	'Tarjeta' 		: 3
};

$(document).ready(function() {
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#formaGenerica').validate({
		rules: {
			tipoCanalID: 'required',
			instrumentoID: 'required'
		},		
		messages: {
			tipoCanalID: 'Especifique el Tipo de Canal.',
			instrumentoID: 'Especifique el Núm. de Instrumento.',
		}		
	});
	
	$('#tipoCanalID').focus();
	deshabilitaBoton('grabar', 'submit');
	
	$('#tipoCanalID').change(function(){
		inicializar();
		$('#instrumentoID').val('');
	});
	
	$('#instrumentoID').blur(function(){
		inicializar();
		var instrumento = $('#instrumentoID').asNumber();
		var tipoCanal = $('#tipoCanalID').asNumber();
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoCanal > 0 && instrumento > 0){
			validaInstrumento(tipoCanal,instrumento);
		} else if(tipoCanal == 0 && esTab){
			mensajeSis('Especifique un Tipo de Canal.');
			$('#tipoCanalID').focus();
			$('#instrumentoID').val('');
		}
	});
	
	$('#tipoReferencia').change(function(){		
		var instrumento = $('#instrumentoID').asNumber();
		var tipoCanal = $('#tipoCanalID').asNumber();
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoCanal > 0 && instrumento > 0){
			esTab=true;
			validaInstrumento(tipoCanal,instrumento);
		} else if(tipoCanal == 0 && esTab){
			mensajeSis('Especifique un Tipo de Canal.');
			$('#tipoCanalID').focus();
			$('#instrumentoID').val('');
		}
	});
	
	$('#instrumentoID').bind('keyup',function(e){
		var tipoCanal = $('#tipoCanalID').asNumber();
		if(tipoCanal > 0 && tipoCanal == cat_TipoCanales.CuentasAho){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			camposLista[1] = "nombreCompleto";
			parametrosLista[0] = 0;
			parametrosLista[1] = $('#instrumentoID').val();

			lista('instrumentoID', '2', '16', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		} else if(tipoCanal > 0 && tipoCanal == cat_TipoCanales.Creditos){
			lista('instrumentoID', '2', '20', 'creditoID', $('#instrumentoID').val(), 'ListaCredito.htm');
		}else if(tipoCanal > 0 && tipoCanal == cat_TipoCanales.Tarjeta){
		}
	});

	$('#instrumentoID').bind('keypress', function(e){
		var tipoCanal = $('#tipoCanalID').asNumber();
		if(tipoCanal > 0 && tipoCanal == cat_TipoCanales.Tarjeta){
			return validaAlfanumerico(e,this);
		}				
	});
		
	$('#grabar').click(function(event){
		$('#tipoTransaccion').val(1);
		grabaDetalles(event);
	});
		
	$('#generar').click(function() {
		generaReporte();
	});	
	
});// FIN DOCUMENT READY
/**
 * Llama al función grabaFormaTransaccionRetrollamada.
 * @author avelasco
 */
function grabaDetalles(event){
	if(validarTabla()){
		if($("#formaGenerica").valid()) {
			if(llenarDetalle())
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExito','funcionError');
		}
	}
}
/**
 * Consulta la lista la referencias de acuerdo al canal y al instrumento, y los muestra en el grid.
 * @author avelasco
 */
function consultaReferencias(){
	var tipoCanal = $('#tipoCanalID').val();
	var instrumento = $('#instrumentoID').val();
	var tipoReferencia = $('#tipoReferencia').val();
	var referenciasBean = {
			'tipoLista'		: 1,
			'tipoCanalID'	: tipoCanal,
			'instrumentoID'	: instrumento,
			'tipoReferencia'	: tipoReferencia
	};
	$('#gridReferencias').html("");
	$.post("referenciasPagGrid.htm", referenciasBean, function(data) {
		if (data.length > 0 ) {
			$('#gridReferencias').html(data);
			$('#gridReferencias').show();
			habilitaBoton('btnAgregar','submit');
			$('#generar').show();
			mostrarBtnCalcular();
		} else {
			$("#numTab").val(4);
			$('#gridReferencias').html("");
			$('#gridReferencias').show();
			deshabilitaBoton('btnAgregar','submit');
			deshabilitaBoton('grabar', 'submit');
			$('#generar').hide();
		}
	});
	$('#btnAgregar').focus();
}
/**
 * Inicializa la forma. Carga y lista los paises de los dos catálogos.
 * @author avelasco
 */
function inicializar(){
	$('#clienteIDDes').val('');
	$('#clienteID').val('');
	$('#gridReferencias').html("");
	$('#gridReferencias').hide();
	$('#tipoReferencia').val('M');
	deshabilitaBoton('grabar', 'submit');
	$('#generar').hide();
}
/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 * @author avelasco
 */
function funcionExito(){
	inicializar();
}
/**
 * Funcion de error que se ejecuta cuando después de grabar
 * la transacción marca error.
 * @author avelasco
 */
function funcionError(){
	
}
/**
 * Agrega un nuevo renglón (detalle) a la tabla del grid.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 * @author avelasco
 */
function agregarDetalle(idControl){	
	reasignaTabIndex('tbParametrizacion');
	if($('#tipoReferencia').val() == 'M'){
		habilitaBoton('grabar', 'submit');
	}else if($('#tipoReferencia').val() == 'A'){
		deshabilitaBoton('grabar', 'submit');
	}
	
	if(validarTabla('tbParametrizacion')){
		var numTab=$("#numTab").asNumber();
		var numeroFila=parseInt(getRenglones());
		numTab++;
		numeroFila++;
		var nuevaFila=
		"<tr id=\"tr"+numeroFila+"\" name=\"tr\">"+
			"<td>"+
				"<select id=\"origen"+numeroFila+"\" name=\"origen\" tabindex=\""+(numTab)+"\">"+
					"<option value=\"\">SELECCIONAR</option>"+
					"<option value=\"1\">INSTITUCI&Oacute;N</option>"+
				"</select>"+
			"</td>"+
			"<td>"+
				"<input type=\"text\" id=\"institucionID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"institucionID\" size=\"9\" maxlength=\"10\" onblur=\"consultaInstitucion(this.id,'nombInstitucion"+numeroFila+"','origen"+numeroFila+"')\" onkeypress=\"listaInstituciones(this.id,'origen"+numeroFila+"')\" onchange=\"verificaSeleccionado(this.id)\"/>"+
			"</td>"+
			"<td>"+
				"<input type=\"text\" id=\"nombInstitucion"+numeroFila+"\" name=\"nombInstitucion\" size=\"22\" maxlength=\"100\" readonly=\"readonly\" disabled=\"true\"/>"+
			"</td>"+
			"<td>"+
				"<input type=\"text\" id=\"referencia"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"referencia\" size=\"45\" maxlength=\"45\" onblur=\"ponerMayusculas(this),limpiaCaract(this.id),seRepiteRef(this.id,'institucionID"+numeroFila+"')\"/>"+
				"<input type=\"hidden\" id=\"tipoReferencia"+numeroFila+"\" name=\"lisTipoReferencia\" readonly=\"readonly\" disabled=\"true\"/>"+
			"</td>"+
			"<td>"+
				"<input type=\"button\" id=\"eliminar"+numeroFila+"\"name=\"eliminar"+"\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('tr"+numeroFila+"')\" tabindex=\""+(numTab)+"\"/> "+
				"<input type=\"button\" id=\"agrega"+numeroFila+"\" name=\"agrega"+"\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDetalle(this.id)\" tabindex=\""+(numTab)+"\" />"+
			"</td>"+
			"<td>"+
			"<input type=\"button\" class=\"submit\" value=\"Calcular\" id=\"calcular"+numeroFila+"\" tabindex=\""+(numTab)+"\" onclick=\"calculaReferencia("+numeroFila+")\"/>"+
			"<input type=\"hidden\" id=\"calculoRefere"+numeroFila+"\" name=\"lisCalculoRefere\" value=\"N\" readonly=\"readonly\" />"+
		"</td>"+
		"</tr>";
		$('#tbParametrizacion').append(nuevaFila);
		$("#numTab").val(numTab);
		$("#numeroFila").val(numeroFila);
		mostrarBtnCalcular();
	}
}
/**
 * Remueve de la tabla un tr.
 * @param id : ID del tr.
 * @author avelasco
 */
function eliminarParam(id){
	$('#'+id).remove();
	mostrarBtnGrabarAut();
}
/**
 * Válida que todos el campo con name paisID de la tabla este requisitado correctamente.
 * @param idControl : ID de la tabla a validar.
 * @returns {Boolean} : Si es váildo o no.
 * @author avelasco
 */
function validarTabla(){
	var validar = true;
	$('#tbParametrizacion tr').each(function(index){
		if(index>1){
			var origenid = "#"+$(this).find("select[name^='origen']").attr("id");
			var institucionid = "#"+$(this).find("input[name^='institucionID']").attr("id");
			var referencia = "#"+$(this).find("input[name^='referencia']").attr("id");

			var origen = $(origenid).val().trim();
			var inst = $(institucionid).val().trim();
			var ref = $(referencia).val().trim();

			if(origen==='') {
				agregarFormaError(origenid);
				validar=false;
			}
			if(inst==='') {
				agregarFormaError(institucionid);
				validar=false;
			}
			if(ref==='') {
				agregarFormaError(referencia);
				validar=false;
			}
		}
	});
	return validar;
}
/**
 * Función arma la cadena con los detalles del grid.
 * @returns {Boolean}
 * @author avelasco
 */
function llenarDetalle(){
	var idDetalle = '#detalleReferencias';
	var tipoCanal = $('#tipoCanalID').asNumber();
	var instrumento = $('#instrumentoID').asNumber();
	$(idDetalle).val('');
	$('#tbParametrizacion tr').each(function(index){
		if(index>1){
			var origenid = "#"+$(this).find("select[name^='origen']").attr("id");
			var institucionid = "#"+$(this).find("input[name^='institucionID']").attr("id");
			var nombre="#"+$(this).find("input[name^='nombInstitucion']").attr("id");
			var referencia = "#"+$(this).find("input[name^='referencia']").attr("id");

			var origen = $(origenid).val();
			var inst = $(institucionid).val();
			var nombInst = $(nombre).val();
			var ref = $(referencia).val();
			
			if (index == 1) {
				$(idDetalle).val( $(idDetalle).val()+
				tipoCanal+']'+ instrumento+']'+ origen+']'+ inst+']'+ nombInst+']' + ref+']');
			} else{
				$(idDetalle).val( $(idDetalle).val()+'['+
				tipoCanal+']'+ instrumento+']'+ origen+']'+ inst+']'+ nombInst+']' + ref+']');
			}
		}
	});
	return true;
}
/**
 * Cancela las teclas [ ] en el formulario
 * @param e
 * @returns {Boolean}
 */
document.onkeypress = pulsarCorchete;

function pulsarCorchete(e) {
	tecla = (document.all) ? e.keyCode : e.which;
	if (tecla == 91 || tecla == 93) {
		return false;
	}
	return true;
}
/**
 * Consulta el nombre de la institucion.
 * @param idControl : ID del input que tiene el ID del país.
 * @param idControlNom	: ID del input para mostrar el nombre del país consultado.
 * @author avelasco
 */
function consultaInstitucion(idControl,idControlDesc,idControlOrigen){
	var jqInst = eval("'#" + idControl + "'");
	var jqDesc = eval("'#" + idControlDesc + "'");
	var jqOrigen = eval("'#" + idControlOrigen + "'");
	var num = idControl.substr(13,idControl.length);
	var jqReferencia = eval("'#referencia"+num+"'");
	
	var numInstituto = $(jqInst).val();
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
	var consultaPrincipal = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	if($(jqOrigen).asNumber() > 0){
		if (numInstituto != '' && !isNaN(numInstituto)) {
			institucionesServicio.consultaInstitucion(consultaPrincipal, InstitutoBeanCon, function(instituto) {
				if (instituto != null) {
					if($('#tipoReferencia').val()=='A' ){
						if(instituto.generaRefeDep == 'S'){
							$(jqDesc).val(instituto.nombre);
							if(instituto.algoritmoID == 2){
								$(jqReferencia).val($('#tipoCanalID').val()+cerosIzq2($('#instrumentoID').val(),13));
							}
							if(instituto.algoritmoID == 3 || instituto.algoritmoID == 4){
								$(jqReferencia).val($('#instrumentoID').val());
							}
							if(instituto.algoritmoID == 5){
								$(jqReferencia).val( "VP" +
													 $('#tipoCanalID').val() +
													 cerosIzq2($('#instrumentoID').val(), 13) 
													);
							}
						}if(instituto.generaRefeDep == 'N'){
							mensajeSis("La institución "+instituto.nombre+" esta parametrizada para NO generar Referencias");
							$(jqInst).val('');
							$(jqDesc).val('');
							$(jqInst).focus();
						}						
					}else{
						$(jqDesc).val(instituto.nombre);
					}
				} else {
					mensajeSis("No Existe la Institución.");
					$(jqInst).val('');
					$(jqDesc).val('');
					$(jqInst).focus();
				}
			});
		}else{
			$(jqInst).val('');
			$(jqDesc).val('');
		}
	} else if($(jqOrigen).asNumber() == 0){
		mensajeSis('Especifique un Origen.');
		$(jqOrigen).focus();
		$(jqInst).val('');
		$(jqDesc).val('');
	}
}
/**
 * Lista de Instituciones en un determinado renglón del grid.
 * @param idControl : ID del input que tiene el ID de la Institución.
 * @author avelasco
 */
function listaInstituciones(idControl,idControlOrigen){
	var jqOrigen = eval("'#" + idControlOrigen + "'");
	if($(jqOrigen).asNumber() > 0){
		lista(idControl, '1', '1', 'nombre', $('#'+idControl).val(), 'listaInstituciones.htm');
	} else if($(jqOrigen).asNumber() == 0){
		mensajeSis('Especifique un Origen.');
		$(jqOrigen).focus();
		$('#'+idControl).val('');
	}
}
/**
 * Recorre la tabla en busca de elementos repetidos.
 * @param idControl : ID del input que genera el evento.
 * @returns 
 * @author avelasco
 */
function seRepite(idControl){
	return false;
}
/**
 * Válida que no este repetida una institución como referencia.
 * @param id : ID del input que genera el evento.
 * @author avelasco
 */
function verificaSeleccionado(id){
	if(seRepite(id)){
		$("#"+id).val("");
		$("#"+id).focus();
	}
}
/**
 * Limipia caracteres especiales de una referencia.
 * @param id : ID del input a limpiar.
 * @author avelasco
 */
function limpiaCaract(id){
	var textoFolioFond = $('#'+id).val();
	$('#'+id).val(limpiaCaracteresEspeciales(textoFolioFond,'OR'));
}
/**
 * Regresa el número de renglones de un grid.
 * @returns Número de renglones de la tabla.
 * @author avelasco
 */
function getRenglones(){
	var maxNumRenglon = 0;
	var aux = 0;
	$('tr[name=tr]').each(function() {
		var numero= this.id.substr(2,this.id.length);
		if(aux == 0){
			maxNumRenglon = numero;
			aux= aux+1;
		}else{
			if(numero >= maxNumRenglon){
				maxNumRenglon = numero;
			}
		}	
	});
	
	return maxNumRenglon;
}
/**
 * Reasigna/actualiza el número de tabindex de los inputs que se encuentran dentro de la tabla. 
 * @param idTablaParametrizacion : ID de la tabla a actualizar.
 * @author avelasco
 */
function reasignaTabIndex(idTablaParametrizacion){
	var numInicioTabs = 3;
	$('#'+idTablaParametrizacion+' tr').each(function(index){
		if(index>1){
			var origenid = "#"+$(this).find("select[name^='origen']").attr("id");
			var institucionid = "#"+$(this).find("input[name^='institucionID']").attr("id");
			var referencia = "#"+$(this).find("input[name^='referencia']").attr("id");
			var agrega="#"+$(this).find("input[name^='agrega']").attr("id");
			var elimina="#"+$(this).find("input[name^='eliminar']").attr("id");
			numInicioTabs++;
			$(origenid).attr('tabindex' , numInicioTabs);
			$(institucionid).attr('tabindex' , numInicioTabs);
			$(referencia).attr('tabindex' , numInicioTabs);
			$(elimina).attr('tabindex' , numInicioTabs);
			$(agrega).attr('tabindex' , numInicioTabs);
		}
	});
	$('#numTab').val(numInicioTabs);
}
/**
 * Consulta el nombre completo del cliente.
 * @param numCliente : ClienteID
 * @author avelasco
 */
function consultaNombreCte(numCliente){
	setTimeout("$('#cajaLista').hide();", 200);
	if (!isNaN(numCliente) && Number(numCliente)>0) {
		clienteServicio.consulta(Number(2), numCliente,"",function(cliente) {
			if (cliente != null) {
				$('#clienteIDDes').val(cliente.nombreCompleto);
			} else {
				$('#clienteIDDes').val('');
			}
		});
	}else{
		$('#clienteIDDes').val('');
	}
}
/**
 * Valida la existencia de una cuenta de ahorro, así como su estatus.
 * @param instrumento : ID de la Cuenta de Ahorro.
 * @author avelasco
 */
function validaCuentaAhorro(instrumento){
	var numCta = instrumento;
	var tipConCampos = 4;
	var activo = 'A';
	var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numCta != '' && !isNaN(numCta) && esTab){
		cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
			if(cuenta!=null){
				if(cuenta.estatus == activo){
					$('#clienteID').val(cuenta.clienteID);
					consultaNombreCte(cuenta.clienteID);
					consultaReferencias();
				} else {
					mensajeSis('La Cuenta esta Inactiva.');
					$('#instrumentoID').focus();
					$('#instrumentoID').select();
					inicializar();
				}
			}else{
				mensajeSis("No Existe la Cuenta de Ahorro.");
				$('#instrumentoID').focus();
				$('#instrumentoID').select();
				inicializar();
			}
		});															
	}
}
/**
 * Valida la existencia de un Crédito, así como su estatus.
 * @param instrumento : ID del Crédito.
 * @author avelasco
 */
function validaCredito(instrumento){
	var Autorizado='A';
	var Vigente='V';
	var Vencido='B';
	var Castigado='K';
	var numCredito = $('#instrumentoID').val();
	var creditoBeanCon = { 
			'creditoID':$('#instrumentoID').val(),
			'fechaActual':$('#fechaSistema').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numCredito != '' && !isNaN(numCredito) && esTab){
		creditosServicio.consulta(15,creditoBeanCon,function(credito) {
			if(credito!=null){
				if((credito.estatus == Autorizado) || (credito.estatus == Vigente ) || (credito.estatus == Vencido) || (credito.estatus == Castigado)){
					$('#clienteID').val(credito.clienteID);
					consultaNombreCte(credito.clienteID);
					consultaReferencias();
				}else{
					mensajeSis("El Estatus del Crédito es Inválido.");
					$('#instrumentoID').focus();
					$('#instrumentoID').select();
					inicializar();
				}
			}else{
				mensajeSis("El Crédito No Existe.");
				$('#instrumentoID').focus();
				$('#instrumentoID').select();
				inicializar();
			}
		});
	}
}
/**
 * Hace la validación del Instrumento dependiendo del tipo de canal.
 * @param tipoCanal	: ID del Tipo de Canal. 1.- Créditos 2.- Cuentas 3.-Tarjeta
 * @param instrumento : CreditoID o CuentaAhoID o tarjetaid respectivamente.
 * @author avelasco	
 */
function validaInstrumento(tipoCanal, instrumento){
	if(Number(tipoCanal) > 0 && tipoCanal == cat_TipoCanales.CuentasAho && esTab){
		validaCuentaAhorro(instrumento);
	} else if(Number(tipoCanal) > 0 && tipoCanal == cat_TipoCanales.Creditos && esTab){
		validaCredito(instrumento);
	} else if(Number(tipoCanal) > 0 && tipoCanal == cat_TipoCanales.Tarjeta){
		var longitudTarjeta=$('#instrumentoID').val().length; 
		if (longitudTarjeta<16){
			$('#instrumentoID').val("");
			inicializar();
		}else{
			consultaClienteIDTarDeb('instrumentoID');
				
		}
	}
}
/**
 * Valida la existencia de un Crédito, así como su estatus.
 * @param instrumento : ID del Crédito.
 * @author avelasco
 */
function seRepiteRef(idControl,instControl){
	var referencia = $('#'+idControl).val();
	var noInstrumento = $('#instrumentoID').val();
	var creditoBeanCon = { 
			'tipoCanalID':$('#tipoCanalID').val(),
			'institucionID':$('#'+instControl).val(),
			'referencia':$('#'+idControl).val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(referencia != '' ){
		referenciasPagosServicio.consulta(creditoBeanCon,2,{callback: function(referencia) {
			if(referencia!=null){
				if((referencia.existe == 'S' && noInstrumento != referencia.instrumentoID)){
					mensajeSis('La Referencia ya se Encuentra Registrada para el Tipo de Canal '+
							($('#tipoCanalID').val()==cat_TipoCanales.Creditos? 'Crédito':'Cuenta')+'.');
					$('#'+idControl).focus();
					$('#'+idControl).select();
				}
			}
		},
		ErrorHandler : function(message) {
			mensajeSis("Error al Consultar: " + message);
		}});
	}
}

/**
 * Calcula en automatico la referencia
 * @param idControl : ID del renglon que genera referencia.
 * @author dahernandez
 */
function calculaReferencia(idControl) {	
	bloquearPantallaCarga();
	var jqInstitucion = eval("'#institucionID" + idControl + "'");
	var institucion = $(jqInstitucion).val();
	var jqReferencia = eval("'#referencia" + idControl + "'");
	var referencia = $(jqReferencia).val();
	var jqCalcular = eval("'#calcular" + idControl + "'");
	var jqCalculoRefere = eval("'#calculoRefere" + idControl + "'");
	
	//ID CAMPOS RENGLON CALCULA REFERENCIA
	var idOrigen = eval("'origen" + idControl + "'");
	var idInstitucionID = eval("'institucionID" + idControl + "'");
	var idNombInstitucion = eval("'nombInstitucion" + idControl + "'");
	var idReferencia = eval("'referencia" + idControl + "'");
	var idCalcular = eval("'calcular" + idControl + "'");

	var Bean = {
		'institucionID'	:institucion,
		'referencia'	:referencia		
	};
	
	referenciasPagosServicio.calculaAlgoritmoRefe(Bean, function(beanReferencia) {
		if (beanReferencia != null) {
			if(beanReferencia.numero == 0){
				$(jqReferencia).val(beanReferencia.referencia);
				deshabilitaControl(idOrigen);
				deshabilitaControl(idInstitucionID);
				deshabilitaControl(idNombInstitucion);
				deshabilitaControl(idReferencia);
				$(jqCalcular).hide();
				$(jqCalculoRefere).val('S');
				mostrarBtnGrabarAut();
			}else{
				mensajeSis(beanReferencia.referencia);
				$(jqReferencia).focus();
			}
		}
	});
	$('#contenedorForma').unblock(); // desbloquear

}	

// Funcion para generar el reporte en PDF 
function generaReporte(){
	var parametroBean = consultaParametrosSession();

	var varNombreInstitucion = parametroBean.nombreInstitucion;
	var varClaveUsuario		= parametroBean.claveUsuario;
    var varFechaSistema     = parametroBean.fechaSucursal;

	var pagina='reporteRefPagoInst.htm?tipoCanalID=' + $('#tipoCanalID').val()+ 
						'&instrumentoID=' + $('#instrumentoID').val()+ 
						'&clienteID=' + $('#clienteID').val()+ 
						'&nombreCliente=' + $('#clienteIDDes').val()+ 							
						'&fechaSistema='+ varFechaSistema+ 
						'&claveUsuario='+varClaveUsuario.toUpperCase()+
						'&nombreInstitucion='+varNombreInstitucion;
	window.open(pagina);	   
}

function mostrarBtnCalcular(){
	$('tr[name=tr]').each(function() {
		var numero= this.id.substr(2,this.id.length);
		var jqTipoRef = eval("'tipoReferencia" + numero+ "'");
		var jqBtn = eval("'calcular" + numero+ "'");
		var jqCalculoRefe = eval("'calculoRefere" + numero+ "'");
		if($('#tipoReferencia').val()=='A' ){
			if($("#"+jqTipoRef).val()== 'A' || $("#"+jqTipoRef).val() == 'M'){
				$("#"+jqBtn).hide();
			}else{
				if($("#"+jqCalculoRefe).val()== 'N' ){
					$("#"+jqBtn).show();
				}				
			}			
		}else if($('#tipoReferencia').val()=='M'){
			$("#"+jqBtn).hide();
		}		
	});		
}
//FUNCION PARA HABILITAR BORON GRABAR CUANDO TIPO REFERENCIA ES AUTOMATICA Y YA SE CALCULARON TODAS LAS REFERENCIAS
function mostrarBtnGrabarAut(){
	var cont = 0;
	if($('#tipoReferencia').val()=='A' ){
		$('tr[name=tr]').each(function() {
			var numero= this.id.substr(2,this.id.length);
			var jqCalRef = eval("'calculoRefere" + numero+ "'");
			
				if($("#"+jqCalRef).val()== 'N'){
					cont = cont + 1;
				}			
				
		});
		if(cont == 0){
			habilitaBoton('grabar', 'submit');
		}		
	}
}

//Función para poder ingresar solo números o letras 
function validaAlfanumerico(e,elemento){//Recibe al evento 
	var key;
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
	}else if(e.which){//Firefox , Opera Netscape
			key = e.which;
	}
	 if (key > 31 && (key < 48 ||  key > 57) && (key <65 || key >90) && (key<97 || key >122)) //Comparación con código ascii
	    return false;
	 var longitudTarjeta=$('#instrumentoID').val().length;		 	
	 		if (longitudTarjeta == 16 ){
				consultaClienteIDTarDeb('instrumentoID');							
			}	
	 return true;	 
}

function consultaClienteIDTarDeb(control){
	var jqControl=	eval("'#" + control + "'");
	var numeroTar=$(jqControl).val();
	var numTarIdenAccess=numeroTar.replace(/[%&(=?¡'{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\]/gi, '');
		numTarIdenAccess=numTarIdenAccess.replace(/[_]/gi,'');
		numTarIdenAccess=numTarIdenAccess.replace(/[' ']/gi,''); // Quitamos los espacios en blanco
		numTarIdenAccess=numTarIdenAccess.replace(/CY/gi,'02'); // Cambio para reemplazar CY por 02 
		numeroTar=numTarIdenAccess;
		
	$(jqControl).val(numeroTar);
	var conNumTarjeta=20;
	var TarjetaBeanCon = {
			'tarjetaDebID'	:numeroTar
		};
	
	if(numeroTar != '' && numeroTar > 0){
		if ($(jqControl).val().length>16){
			mensajeSis("El Número de Tarjeta es Incorrecto deben de ser 16 dígitos");
			$(jqControl).val("");
			$(jqControl).focus();
			inicializar();
		}
		if($(jqControl).val().length == 16){
			tarjetaDebitoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaDebito) {
				if(tarjetaDebito!=null){					
					if (tarjetaDebito.estatusId==7){
						$('#idCtePorTarjeta').val(tarjetaDebito.clienteID);
						$('#nomTarjetaHabiente').val(tarjetaDebito.nombreCompleto);
						if ($(jqControl).val()!=""&& $('#idCtePorTarjeta').val()!=""){
							$('#clienteID').val($('#idCtePorTarjeta').val());
							consultaNombreCte(tarjetaDebito.clienteID);
							consultaReferencias();
						}
						$(jqControl).val("");
						$('#idCtePorTarjeta').val("");
						$('#nomTarjetaHabiente').val("");
					}else{
							if (tarjetaDebito.estatusId==1){
								mensajeSis("La Tarjeta no se Encuentra Asociada a una Cuenta");
							}else
							if (tarjetaDebito.estatusId==6){
								mensajeSis("La Tarjeta no se Encuentra Activa");
							}else
							if (tarjetaDebito.estatusId==8){
								mensajeSis("La Tarjeta se Encuentra Bloqueada");
							}else
							if (tarjetaDebito.estatusId==9){
								mensajeSis("La Tarjeta se Encuentra Cancelada");
							}
							$(jqControl).focus();
							$(jqControl).val("");
							$('#idCtePorTarjeta').val("");
							$('#nomTarjetaHabiente').val("");
							inicializar();
					}
				}else{
					mensajeSis("La Tarjeta de Identificación no existe.");
					$(jqControl).focus();
					$(jqControl).val("");
					inicializar();
				}
			});		
		}
	}
}

//funcion que bloquea la pantalla mientras se cargan los datos
function bloquearPantallaCarga() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
			border : 'none',
			background : 'none'
		}
	});

}



/*
 * Acompleta ceros a la izquierda de una cadena de numeros
 */
function cerosIzq2(valor, longitud) {
	expr = /\s/;
	var valor2 = valor.replace(expr,"0");
	if (valor2 == "")
		valor2 = 0;
	if (isNaN(valor2) == true)
		valor2 = 0;
	else
	while (valor2.length < longitud) {
		valor2 = "0" + valor2;
	}
	return valor2;
}
