var opcionMenuRegBean ;
var menuClasCred		= {};
var menuFormaAdqui 		= {};
var menuGrupoRiesg 		= {};
var menuTipoInstru		= {};
var menuTipoInversion	= {};
var tipoInstitucion 	= 0;


var esTab				= true;
var enteroCero          = 0;

var catRegulatorioI0391 = {
			'Excel'			: 2,
			'Csv'			: 3,
		};

var lisMenuRegulatorio = {
			'Busqueda'		: 1,
			'Combo'			: 2,
			'TipoValor'		: 4
		};

var catMenuRegulatorio = {
			'Instituciones'			: 1,
			'ClasifCredito'			: 20,
			'FormaAdquisicion'		: 3,
			'TipoRiesgo'			: 22,
			'TipoInstrumento'		: 19,
			'TipoInversion'			: 21,
			'TipoValor'				: 0
		};

$(document).ready(function() {
	parametros = consultaParametrosSession();
	esTab = true;


	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	llenaComboAnios(parametroBean.fechaAplicacion);

	//------------ Validaciones de Controles -------------------------------------

	$.validator.setDefaults({
	    submitHandler: function(event) {
	  	 grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','anio');

	  	   //Si la respuesta es éxitosa se habilita el botón generar
	  	   setTimeout(function(){
		  	   	var resultado = $('#numeroMensaje').val();
				if(resultado == enteroCero){
				 	habilitaBoton('generar');
				}

	  	   },500);


	    }
	 });

	$('#formaGenerica').validate({
		rules: {
			anio: 'required'
		},
		messages: {
			anio: 'Especifique el Año del periodo',
		}
	});


	cargarMenus();
	consultaInstitucion();

	$(':text').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});

	$(':text').focus(function() {
		esTab = false;
	});




});// cerrar




function seleccionaOpcionMenuReg(){
		$('tr[name=renglon]').each(function() {
			var numero			= this.id.substr(7,this.id.length);
			var jsClasCred		= eval("'sclasfConta" + numero+ "'");
			var jsFormaAdqui 	= eval("'sformaAdqui" + numero+ "'");
			var jsGrupoRiesg 	= eval("'sgrupoRiesgo" + numero+ "'");
			var jsTipoInstru 	= eval("'stipoInstru" + numero+ "'");
			var jsTipoInversion = eval("'stipoInversion" + numero+ "'");


			var valorClasCred		= document.getElementById(jsClasCred).value;
			var valorFormaAdqui		= document.getElementById(jsFormaAdqui).value;
			var valorGrupoRiesg		= document.getElementById(jsGrupoRiesg).value;
			var valorTipoInstru		= document.getElementById(jsTipoInstru).value;
			var valorTipoInversion	= document.getElementById(jsTipoInversion).value;

			$('#clasfConta'+numero+' option[value='+ valorClasCred +']').attr('selected','true');
			$('#formaAdqui'+numero+' option[value='+ valorFormaAdqui +']').attr('selected','true');
			$('#grupoRiesgo'+numero+' option[value='+ valorGrupoRiesg +']').attr('selected','true');
			$('#tipoInstru'+numero+' option[value='+ valorTipoInstru +']').attr('selected','true');
			$('#tipoInversion'+numero+' option[value='+ valorTipoInversion +']').attr('selected','true');

			esTab = true;
			consultaEntidad("entidad"+numero);
			consultaTipoValor("tipoValor"+numero);
		});

	}

	function iniciarDatePikers(){
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);

			$("#fechaContra"+numero).datepicker({
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true,
				changeYear: true,
				dateFormat: 'ddmmyy',
				yearRange: '-100:+10'
			});

			$("#fechaVencim"+numero).datepicker({
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true,
				changeYear: true,
				dateFormat: 'ddmmyy',
				yearRange: '-100:+10'
			});

		});

	}


function cargarMenus(){

	// Combo Clasificación del Crédito
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.ClasifCredito,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean1) {
			 menuClasCred = opcionesMenuRegBean1;
			});

	//Combo Forma de Adquisición
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.FormaAdquisicion,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean2) {
			menuFormaAdqui = opcionesMenuRegBean2;
			});

	//Combo Tipo de Riesgo
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoRiesgo,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean3) {
			menuGrupoRiesg = opcionesMenuRegBean3;
			});

	//Combo Tipo de Instrumento
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoInstrumento,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean4) {
			menuTipoInstru = opcionesMenuRegBean4;
			});

	//Combo Tipo de Inversion
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoInversion,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean5) {
			menuTipoInversion = opcionesMenuRegBean5;
			});

}


function cargarCombos(id){
	$('#formaAdqui'+id).each(function() {  $('#formaAdqui'+id+' option').remove(); });
	$('#tipoInstru'+id).each(function() {  $('#tipoInstru'+id+' option').remove(); });
	$('#clasfConta'+id).each(function() {  $('#clasfConta'+id+' option').remove(); });
	$('#grupoRiesgo'+id).each(function() { $('#grupoRiesgo'+id+' option').remove(); });
	$('#tipoInversion'+id).each(function() { $('#tipoInversion'+id+' option').remove(); });
	// se agrega la opcion por default
	$('#formaAdqui'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#tipoInstru'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#clasfConta'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#grupoRiesgo'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#tipoInversion'+id).append( new Option('SELECCIONAR', '', true, true));

	for ( var j = enteroCero; j < menuFormaAdqui.length; j++) {
		$('#formaAdqui'+id).append(new Option(menuFormaAdqui[j].descripcion,menuFormaAdqui[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuTipoInstru.length; j++) {
		$('#tipoInstru'+id).append(new Option(menuTipoInstru[j].descripcion,menuTipoInstru[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuClasCred.length; j++) {
		$('#clasfConta'+id).append(new Option(menuClasCred[j].descripcion,menuClasCred[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuGrupoRiesg.length; j++) {
		$('#grupoRiesgo'+id).append(new Option(menuGrupoRiesg[j].descripcion,menuGrupoRiesg[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuTipoInversion.length; j++) {
		$('#tipoInversion'+id).append(new Option(menuTipoInversion[j].descripcion,menuTipoInversion[j].codigoOpcion,true,true));
		}

	$('#formaAdqui'+id).val('').selected = true;
	$('#tipoInstru'+id).val('').selected = true;
	$('#clasfConta'+id).val('').selected = true;
	$('#grupoRiesgo'+id).val('').selected = true;
	$('#tipoInversion'+id).val('').selected = true;

}


function buscaEntidad(input){
	var parametros = ['descripcion','menuID'];
	var opcionMenuReg = [$('#'+input).val(),1];
	lista(input, '2', '1',parametros,opcionMenuReg,'opcionesMenuRegLista.htm');
}



function consultaEntidad(idControl){
			var jqEntidad = eval("'#" + idControl + "'");
			var numEntidad = $(jqEntidad).val();


			if($(jqEntidad).val().length > 8){
				$('#nombre'+idControl).val('');
				$(jqEntidad).val('');
				mensajeSis("Número de Entidad Incorrecto");
				$(jqEntidad).focus();
				return false;
			}

			var opcionMenuRegBean = {
					'menuID' 		: catMenuRegulatorio.Instituciones,
					'codigoOpcion' 	: numEntidad
			};
			tipoConEntidad = 3;

			if (!isNaN($(jqEntidad).val()) && esTab == true && $(jqEntidad).val() != '') {
				opcionesMenuRegServicio.consulta(tipoConEntidad,opcionMenuRegBean,function(entidad) {
						if (entidad != null) {
							$('#nombre'+idControl).val(entidad.descripcion);
							$('#'+idControl).val(entidad.codigoOpcion);
						} else {
								mensajeSis("No Existe la Entidad Financiera.");
								$('#nombre'+idControl).val('');
								$(jqEntidad).focus();
						}
					});
			}
}



function buscaTipoValor(input){
	var parametros = ['descripcion','menuID'];
	var opcionMenuReg = [$('#'+input).val(),0];
	lista(input, '2', '4',parametros,opcionMenuReg,'opcionesMenuRegLista.htm');
}


function consultaTipoValor(idControl){
	var jqTipoValor = eval("'#" + idControl + "'");
	var tipoValorID = $(jqTipoValor).val();


	if($(jqTipoValor).val().length > 4){
				$(jqTipoValor).val('');
				$('#nombre'+idControl).val('');
				mensajeSis("Tipo de Valor Incorrecto");
				$(jqTipoValor).focus();
				return false;
			}


	var opcionMenuRegBean = {
			'menuID' 		: catMenuRegulatorio.TipoValor,
			'codigoOpcion' 	: tipoValorID
	};
	tipoConEntidad = 5;

	if (esTab == true && $(jqTipoValor).val() != '') {
		opcionesMenuRegServicio.consulta(tipoConEntidad,opcionMenuRegBean,function(entidad) {
				if (entidad != null) {
					$('#nombre'+idControl).val(entidad.descripcion);
				} else {
						mensajeSis("No Existe el Tipo de Valor Ingresado.");
						$('#nombre'+idControl).val('');
						$(jqTipoValor).focus();
				}
			});
	}
}




function agregarRegistro(){
	var numeroFila=consultaFilas();

	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		var valor = 0;
		if(numeroFila == 0){
			valor = 1;
		}else{
			valor = numeroFila+ 1;
		}

			tds += '<td nowrap><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="'+valor+'" autocomplete="off"  type="hidden" />';
			tds += '<input type="text" id="entidad'+nuevaFila+'" maxlength="150" name="lEntidad" size="8" onkeyup="buscaEntidad(this.id)" onblur="consultaEntidad(this.id)" value="" class="display: inline-block" />';
			tds += '<input type="text" id="nombreentidad'+nuevaFila+'" readonly="" disabled=""  name="nombreentidad" size="30" value="" class="display: inline-block" />	</td>';
			tds += '<td nowrap><input type="text" id="emisora'+nuevaFila+'" maxlength="7" onblur=" ponerMayusculas(this);" name="lEmisora" size="10" value=""/></td>';
			tds += '<td nowrap><input type="text" id="serie'+nuevaFila+'" maxlength="10" onblur=" ponerMayusculas(this);" name="lSerie" size="10" value=""/></td>';



			tds += '<td nowrap><input type="text" id="tipoValor'+nuevaFila+'" maxlength="100" name="lTipoValorID" size="4" onkeyup="buscaTipoValor(this.id)" onblur="consultaTipoValor(this.id)"  class="display: inline-block" />'
			tds += '<input type="text" id="nombretipoValor'+nuevaFila+'" readonly="" disabled="" name="tipoValor" size="50" class="display: inline-block" /></td>'

			tds += '<td nowrap><input type="hidden" id="sformaAdqui'+nuevaFila+'"  name="sformaAdqui" size="20" value=""/><select name="lFormaAdqui" onchange="validaReporto(this.id);" id="formaAdqui'+nuevaFila+'" ></select></td>';

			tds += '<td nowrap><input type="hidden" id="stipoInversion'+nuevaFila+'"  name="stipoInversion" size="20" value=""/><select name="lTipoInversion" id="tipoInversion'+nuevaFila+'" ></select></td>';

			tds += '<td nowrap><input type="hidden" id="stipoInstru'+nuevaFila+'"  name="stipoInstru" size="20" value=""/><select name="lTipoInstru" id="tipoInstru'+nuevaFila+'" ></select></td>';
			tds += '<td nowrap><input type="hidden" id="sclasfConta'+nuevaFila+'"  name="sclasfConta" size="20" value=""/><select name="lClasfConta" id="clasfConta'+nuevaFila+'" ></select></td>';
			tds += '<td nowrap><input type="text" id="fechaContra'+nuevaFila+'" maxlength="8" name="lFechaContra" onblur="esFechaValida(this.value,this.id)" size="12" value="" /></td>';
			tds += '<td nowrap><input type="text" id="fechaVencim'+nuevaFila+'" maxlength="8" name="lFechaVencim" onblur="esFechaValida(this.value,this.id)" size="12" value="" /></td>';
			tds += '<td nowrap><input type="text" id="numeroTitu'+nuevaFila+'"  maxlength="21" name="lNumeroTitu"  onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="20" value=""/></td>';
			tds += '<td nowrap><input type="text" id="costoAdqui'+nuevaFila+'"  maxlength="21" name="lCostoAdqui" onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="20" value=""/></td>';
			tds += '<td nowrap><input type="text" id="tasaInteres'+nuevaFila+'" maxlength="16" name="lTasaInteres"  style="text-align:right;" onBlur="evaluaTasa(this)" size="12" value=""/><label class="label">%</label></td>';
			tds += '<td nowrap><input type="hidden" id="sgrupoRiesgo'+nuevaFila+'"  name="sgrupoRiesgo" size="10" value=""/><select name="lGrupoRiesgo" id="grupoRiesgo'+nuevaFila+'" ></select></td>';
			tds += '<td nowrap><input type="text" id="valuacion'+nuevaFila+'" maxlength="21"  name="lValuacion"  onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="21" value=""/></td>';
			tds += '<td nowrap><input type="text" id="resValuacion'+nuevaFila+'" maxlength="21"  name="lResValuacion" onkeyPress="return validaSoloNumeros(event);" onblur="validaValor(this.id);" style="text-align:right;" size="21" value=""/></td>';


		tds += '<td nowrap><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarRegistro(this.id)"/>';
		tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarRegistro()"/></td>';
		tds += '</tr>';

		$("#miTabla").append(tds);
		cargarCombos(nuevaFila);
		iniciarDatePikers();

		// Asignamos el foco al campo entidad
		$('#entidad'+nuevaFila).focus();

		habilitaBoton('grabar');
		deshabilitaBoton('generar');

		agregaFormatoControles('formaGenerica');


		return false;
	}


function validaReporto(campoID){
	var Num = campoID.substr(10,campoID.length);

	if($('#'+campoID).val()==1){
		$('#resValuacion'+Num).val('0');
	}else{
		if($('#resValuacion'+Num).val() == '0'){
			$('#resValuacion'+Num).val('');
		}
	}
}


function validaValor(campoID){
	var Num = campoID.substr(12,campoID.length);
	if($('#formaAdqui'+Num).val()==1 && $('#'+campoID).val()!="0"){
		$('#resValuacion'+Num).val('0');
		mensajeSis('Forma de Adquisición "En Reporto". <br> Resultado por Valuación debe ser igual a "0"');
		$('#resValuacion'+Num).focus();
	}
}

//consulta cuantas filas tiene el grid de documentos
function consultaFilas(){
	var totales=$('tr[name=renglon]:last').attr('id');;
	if(totales == undefined){
		totales = 0;
	}else{

		totales = totales.substr(7,100);
	}

	return totales++;

}

function verificaSeleccionado(idCampo){
	var nuevaFrecuencia=$('#'+idCampo).val();

	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdFrecuencias = eval("'frecuencia" + numero+ "'");
		var valorFrecuencias=$('#'+jqIdFrecuencias).val();
		if(jqIdFrecuencias != idCampo){
			if(valorFrecuencias == nuevaFrecuencia){
				mensajeSis("La Frecuencia se repite para el Producto de Crédito indicado ");
				$('#'+idCampo).focus();
			}
		}
	});

}

function eliminarRegistro(control){
	var contador = enteroCero ;
	var numeroID = control;

	var jqRenglon 			= eval("'#renglon" + numeroID + "'");
	var jqNumero 			= eval("'#consecutivoID" + numeroID + "'");
	var jqEntidad 			= eval("'#entidad"+numeroID+"'");
	var jqNombreentidad 	= eval("'#nombreentidad"+numeroID+"'");
	var jqEmisora 			= eval("'#emisora"+numeroID+"'");
	var jqSerie 			= eval("'#serie"+numeroID+"'");
	var jqSformaAdqui		= eval("'#sformaAdqui"+numeroID+"'");
	var jqFormaAdqui 		= eval("'#formaAdqui"+numeroID+"'");
	var jqStipoInstru 		= eval("'#stipoInstru"+numeroID+"'");
	var jqTipoInstru 		= eval("'#tipoInstru"+numeroID+"'");
	var jqSclasfConta 		= eval("'#sclasfConta"+numeroID+"'");
	var jqClasfConta 		= eval("'#clasfConta"+numeroID+"'");
	var jqFechaContra 		= eval("'#fechaContra"+numeroID+"'");
	var jqFechaVencim 		= eval("'#fechaVencim"+numeroID+"'");
	var jqNumeroTitu 		= eval("'#numeroTitu"+numeroID+"'");
	var jqCostoAdqui 		= eval("'#costoAdqui"+numeroID+"'");
	var jqTasaInteres 		= eval("'#tasaInteres"+numeroID+"'");
	var jqSgrupoRiesgo 		= eval("'#sgrupoRiesgo"+numeroID+"'");
	var jqGrupoRiesgo 		= eval("'#grupoRiesgo"+numeroID+"'");
	var jqValuacion 		= eval("'#valuacion"+numeroID+"'");
	var jqResValuacion 		= eval("'#resValuacion"+numeroID+"'");


	var jqTipoValor 		= eval("'#tipoValor "+numeroID+"'");
	var jqNombretipoValor 	= eval("'#nombretipoValor"+numeroID+"'");
	var jqStipoInversion 	= eval("'#stipoInversion"+numeroID+"'");
	var jqTipoInversion 	= eval("'#tipoInversion"+numeroID+"'");


	// se elimina la fila seleccionada
	$(jqNumero).remove();
	$(jqNumero).remove();
	$(jqEntidad).remove();
	$(jqNombreentidad).remove();
	$(jqEmisora).remove();
	$(jqSerie).remove();
	$(jqSformaAdqui).remove();
	$(jqFormaAdqui).remove();
	$(jqStipoInstru).remove();
	$(jqTipoInstru).remove();
	$(jqSclasfConta).remove();
	$(jqClasfConta).remove();
	$(jqFechaContra).remove();
	$(jqFechaVencim).remove();
	$(jqNumeroTitu).remove();
	$(jqCostoAdqui).remove();
	$(jqTasaInteres).remove();
	$(jqSgrupoRiesgo).remove();
	$(jqGrupoRiesgo).remove();
	$(jqValuacion).remove();
	$(jqResValuacion).remove();
	$(jqRenglon).remove();

	$(jqTipoValor).remove();
	$(jqNombretipoValor).remove();
	$(jqStipoInversion).remove();
	$(jqTipoInversion).remove();


	//Reordenamiento de Controles
	contador = 1;
	var numero= enteroCero;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1 			= eval("'#renglon"+numero+"'");
		var jqNumero1 			= eval("'#consecutivoID"+numero+"'");

		var jqEntidad1 			= eval("'#entidad"+numero+"'");
		var jqNombreentidad1 	= eval("'#nombreentidad"+numero+"'");
		var jqEmisora1 			= eval("'#emisora"+numero+"'");
		var jqSerie1 			= eval("'#serie"+numero+"'");
		var jqSformaAdqui1		= eval("'#sformaAdqui"+numero+"'");
		var jqFormaAdqui1 		= eval("'#formaAdqui"+numero+"'");
		var jqStipoInstru1 		= eval("'#stipoInstru"+numero+"'");
		var jqTipoInstru1 		= eval("'#tipoInstru"+numero+"'");
		var jqSclasfConta1 		= eval("'#sclasfConta"+numero+"'");
		var jqClasfConta1 		= eval("'#clasfConta"+numero+"'");
		var jqFechaContra1 		= eval("'#fechaContra"+numero+"'");
		var jqFechaVencim1 		= eval("'#fechaVencim"+numero+"'");
		var jqNumeroTitu1 		= eval("'#numeroTitu"+numero+"'");
		var jqCostoAdqui1 		= eval("'#costoAdqui"+numero+"'");
		var jqTasaInteres1 		= eval("'#tasaInteres"+numero+"'");
		var jqSgrupoRiesgo1 	= eval("'#sgrupoRiesgo"+numero+"'");
		var jqGrupoRiesgo1		= eval("'#grupoRiesgo"+numero+"'");
		var jqValuacion1 		= eval("'#valuacion"+numero+"'");
		var jqResValuacion1		= eval("'#resValuacion"+numero+"'");

		var jqTipoValor1		= eval("'#tipoValor"+numero+"'");
		var jqNombretipoValor1	= eval("'#nombretipoValor"+numero+"'");
		var jqStipoInversion1	= eval("'#stipoInversion"+numero+"'");
		var jqTipoInversion1	= eval("'#tipoInversion"+numero+"'");

		var jqElimina1 		= eval("'#"+numero+ "'");
		var jqAgrega1 		= eval("'#agrega"+numero+ "'");


		$( jqFechaContra1 ).datepicker( "destroy" );

		$( jqFechaVencim1 ).datepicker( "destroy" );


		$(jqNumero1).attr('id','consecutivoID'+contador);
		$(jqEntidad1).attr('id','entidad'+contador);
		$(jqNombreentidad1).attr('id','nombreentidad'+contador);
		$(jqEmisora1).attr('id','emisora'+contador);
		$(jqSerie1).attr('id','serie'+contador);
		$(jqSformaAdqui1).attr('id','sformaAdqui'+contador);
		$(jqFormaAdqui1).attr('id','formaAdqui'+contador);
		$(jqStipoInstru1).attr('id','stipoInstru'+contador);
		$(jqTipoInstru1).attr('id','tipoInstru'+contador);
		$(jqSclasfConta1).attr('id','sclasfConta'+contador);
		$(jqClasfConta1).attr('id','clasfConta'+contador);
		$(jqFechaContra1).attr('id','fechaContra'+contador);
		$(jqFechaVencim1).attr('id','fechaVencim'+contador);
		$(jqNumeroTitu1).attr('id','numeroTitu'+contador);
		$(jqCostoAdqui1).attr('id','costoAdqui'+contador);
		$(jqTasaInteres1).attr('id','tasaInteres'+contador);
		$(jqSgrupoRiesgo1).attr('id','sgrupoRiesgo'+contador);
		$(jqGrupoRiesgo1).attr('id','grupoRiesgo'+contador);
		$(jqValuacion1).attr('id','valuacion'+contador);
		$(jqResValuacion1).attr('id','resValuacion'+contador);

		$(jqTipoValor1).attr('id','tipoValor1'+contador);
		$(jqNombretipoValor1).attr('id','nombretipoValor1'+contador);
		$(jqStipoInversion1).attr('id','stipoInversion1'+contador);
		$(jqTipoInversion1).attr('id','tipoInversion1'+contador);

		$(jqAgrega1).attr('id','agrega'+contador);
		$(jqElimina1).attr('id',contador);
		$(jqRenglon1).attr('id','renglon'+ contador);
		contador = parseInt(contador + 1);

	});

	deshabilitaBoton('generar');
	iniciarDatePikers();

}




function Validador(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {

		if (key==8|| key == 46)	{
			return true;
		}
		else
			mensajeSis("sólo números");
		return false;
	}
}


// -- FUNCIONES ----------------------

function llenaComboAnios(fechaActual){
	   var anioActual 	= fechaActual.substring(0, 4);
	   var mesActual 	= parseInt(fechaActual.substring(5, 7));
	   var numOption 	= 4;

	   for(var i=0; i<numOption; i++){
		   $("#anio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
		   anioActual = parseInt(anioActual) - 1;
	   }

	   $("#mes option[value="+ mesActual +"]").attr("selected",true);
}


$('#mes').change(function (){
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);
	   var anioSeleccionado = $('#anio').val();

	   if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
		   mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
		   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
		   consultaRegistroRegulatorioI0391();
		   this.focus();
	   }else{
		   consultaRegistroRegulatorioI0391();
	   }
});

$('#anio').change(function (){
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);
	   var anioSeleccionado = $('#anio').val();
	   var mesSeleccionado 	= $('#mes').val();

	   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
		   mensajeSis("El Año Indicado es Incorrecto.");
		   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
		   consultaRegistroRegulatorioI0391();
		   this.focus();
	   }else{
		   consultaRegistroRegulatorioI0391();
	   }
});


function consultaRegistroRegulatorioI0391(){
	var anio 	= $('#anio').val();
	var mes  	= $('#mes').val();
	var params 	= {};
	params['tipoLista'] = 1;
	params['anio'] 		= anio;
	params['mes']		= mes;
	params['institucionID'] = tipoInstitucion;

	$.post("regulatorioI0391GridVista.htm", params, function(data){
		if(data.length >enteroCero) {
			$('#divRegulatorioI0391').html(data);
			$('#fieldsetDiasPasoVencido').show();
			$('#divRegulatorioI0391').show();

			if(consultaFilas() > enteroCero){
				habilitaBoton('grabar');
				habilitaBoton('generar');
			}else{
				deshabilitaBoton('grabar');
				deshabilitaBoton('generar');
			}

			iniciarDatePikers();

			// Intervalo que valida los objetos que contienen las opciones para los combos
			var cargando = setInterval(function(){
				if(menuClasCred.length > enteroCero & menuFormaAdqui.length > enteroCero
				    & menuGrupoRiesg.length > enteroCero & menuTipoInstru.length > enteroCero
				    					& menuTipoInversion.length > enteroCero){

						for (var i = 1; i <= consultaFilas(); i++) {
							cargarCombos(i);
							seleccionaOpcionMenuReg();
						}

				 clearInterval(cargando);

				}

			},100);

			agregaFormatoControles('formaGenerica');

			$('#generar').click(function(){

					  	 		if($('#excel').is(':checked')){
									if(consultaFilas()>enteroCero ){
										generaReporte(catRegulatorioI0391.Excel);
									}
								}
								if($('#csv').is(':checked')){
									if(consultaFilas()>enteroCero){
										generaReporte(catRegulatorioI0391.Csv);
									}
								}

				});

		}else{
			$('#divRegulatorioI0391').html("");
			$('#fieldsetDiasPasoVencido').hide();
			$('#divRegulatorioI0391').hide();
		}
	});


}


function validarPorcentaje(controlID, valor){
	var numero= controlID.substr(10,controlID.length);

	if(isNaN(parseFloat(valor))){
		$("#"+controlID).focus();
		$("#"+controlID).val('0.00');
	}else{
		if(valor.length > 16){
			mensajeSis("Máximo 8 dígitos y 4 decimales");
			$("#"+controlID).focus();
			$("#"+controlID).val('0.00');
		}
	}
}

function generaReporte(tipoReporte){
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   var url='';
		   var tipoEntidad = $('#institucionID').val();
		   url = 'reporteRegulatorioI0391.htm?tipoReporte=' + tipoReporte +'&institucionID='+ tipoEntidad + '&anio='+anio+ '&mes=' + mes;
		   window.open(url);

	   };


function validaSoloNumeros(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {

		if (key==8)	{
			return true;
		}

		return false;
	}
}


function evaluaTasa(campo){
	var tasa = $('#'+campo.id).val();

	if(tasa != "" && !isNaN(tasa)){

		if(/^\d{1,11}(\.\d{1,4})?$/.test(tasa)){
				$('#'+campo.id).formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4,
						groupDigits: false
				});

		}else{
			$('#'+campo.id).val('');
			mensajeSis('Ingrese una Tasa Valida (Máximo 11 dígitos y 4 decimales)');
			$('#'+campo.id).focus();
		}
	}else{
		$('#'+campo.id).val('0');
		$('#'+campo.id).formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4
				});
	}

}


// --------------- funcion para validar la fecha --------------------------
function esFechaValida(fecha,idfecha) {
	if (fecha != undefined && fecha != "") {

		var mes = fecha.substring(2, 4) * 1;
		var dia = fecha.substring(0, 2) * 1;
		var anio = fecha.substring(4, 8) * 1;

		switch (mes) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			numDias = 31;
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			numDias = 30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)) {
				numDias = 29;
			} else {
				numDias = 28;
			}
			;
			break;
		default:
			mensajeSis("Formato de Fecha Invalido.");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
		return false;
		}
		if (dia > numDias || dia == 0) {
			mensajeSis("Formato de Fecha Invalido.");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
			return false;
		}
		return true;
	}else{
		if(fecha != undefined && fecha != "" && fecha.length < 8){
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
		}

	}
}

function comprobarSiBisisesto(anio) {
	if ((anio % 100 != enteroCero) && ((anio % 4 == enteroCero) || (anio % 400 == enteroCero))) {
		return true;
	} else {
		return false;
	}
}

function consultaInstitucion(){

	   var tipoConsulta = 9;
	   var bean = {
				'empresaID'		: 1
			};

		paramGeneralesServicio.consulta(tipoConsulta, bean,function(Institucion){
			   tipoInstitucion = Institucion.valorParametro;

			   $('#institucionID').val(tipoInstitucion);
			   consultaRegistroRegulatorioI0391();

		   });
}

