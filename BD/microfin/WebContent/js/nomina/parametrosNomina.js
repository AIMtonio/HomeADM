//  $(document).ready(function() {
	esTab = true;
	 var clienteSocio = $("#clienteSocio").val();

	$("#empresaID").focus();
	agregaFormatoControles('formaGenerica');
	 deshabilitaBoton('modificar', 'submit');
	 var catTipoTransaccion = {
		  	'modificar'	: '2'
	 };

	 var catTipoConsulta  = {
			'principal':2
	 };

	 var catTipoConsultaCentro = {
	  		'principal'	: 1
	 };

	 /********** METODOS Y MANEJO DE EVENTOS ************/

	 $(':text').focus(function() {
		 	esTab = false;
		});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#empresaID').blur(function() {
		consultaParamEmpresa(this.id);
	});

	$('#empresaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreInstitucion";
		parametrosLista[0] = $('#empresaID').val();
		lista('empresaID', '1', '1', camposLista,parametrosLista, 'listaParametrosSis.htm');
	});

	$('#ctaPagoTransito').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#ctaPagoTransito').val();
			listaAlfanumerica('ctaPagoTransito', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});

	$('#tipoMovTesoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#tipoMovTesoID').val();
			listaAlfanumerica('tipoMovTesoID', '1', '1', camposLista, parametrosLista, 'listaTiposMovTesoreria.htm');
		}
	});


	$('#tipoMovDomiciliaID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#tipoMovDomiciliaID').val();
			listaAlfanumerica('tipoMovDomiciliaID', '1', '1', camposLista, parametrosLista, 'listaTiposMovTesoreria.htm');
		}
	}); 

	$('#ctaTransDomicilia').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaTransDomicilia').val();
			listaAlfanumerica('ctaTransDomicilia', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});
	
	$('#perfilAutCalend').bind('keyup',function(e){
		lista('perfilAutCalend', '2', '1', 'nombreRol', $('#perfilAutCalend').val(), 'listaRoles.htm');
	});

	$('#tipoMovTesoID').blur(function() {
			validaConcepto(this.id);
	});

	$('#ctaPagoTransito').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
	});

	$('#perfilAutCalend').blur(function() {
	 consultaDescPerfil($('#perfilAutCalend').val());
	});


	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.modificar);
	});

	$('#tipoMovDomiciliaID').blur(function() {
			validaConceptoDomiciliacion(this.id);	    
	});

	$('#ctaPagoTransito').blur(function() {
		validaCuentaContable('ctaPagoTransito');
	});

	$('#ctaConcentCancela').blur(function() {
		validaCuentaContable('ctaConcentCancela');
	});

	$('#ctaConcentRetiro').blur(function() {
		validaCuentaContable('ctaConcentRetiro');
	});

	$('#ctaTransDomicilia').blur(function() {
		validaCuentaContable('ctaTransDomicilia');
	});
	

	$.validator.setDefaults({
        submitHandler: function(event) {
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','EmpresaID','limpia','fallo');
        }
	});



	/********** Validaciones de la Forma **************/

	 $('#formaGenerica').validate({
			rules: {
				empresaID: {
					required: true,
				},
				correoElectronico: {
					required: true,
					email : true
				},
				ctaPagoTransito: {
					required: true
				},
				tipoMovTesoID: {
					required: true
				},
				nomenclaturaCR: {
					required: true,
					maxlength: 3
				},

				tipoMovDomiciliaID: {
					required: true
				},

				ctaTransDomicilia: {
					required: true
				},
			},
			messages: {
				empresaID: {
					required: 'Especifique la Empresa.',
				},
				correoElectronico: {
					required: 'Especifique Correo de Encargado Nómina.',
						email :'Correo Inválido.',
				},
				ctaPagoTransito: {
					required: 'Especifique Cta. Contable en Transito.'
				},
				tipoMovTesoID: {
					required: 'Especifique Tipo de Movimiento.'
				},
				nomenclaturaCR: {
					required: 'Especifique Nomenclatura Centro de Costos.',
					maxlength: 'Máximo 3 caracteres.'
				},
				tipoMovDomiciliaID: {
					required: 'Especifique Tipo de Movimiento Domiciliación.'
				},
				ctaTransDomicilia: {
					required: 'Especifique Cta. Contable Domiciliación.'
				},
			}

	});
	/********** METODOS Y MANEJO DE EVENTOS ************/

	 //Funcion para consultar la empresa
	function consultaParamEmpresa(idControl){
		var jqEmpresaID = eval("'#" + idControl + "'");
		var numEmpresa = $(jqEmpresaID).val();
		var tipoCon=1;
		setTimeout("$('#cajaLista').hide();", 200);
		var parametrosNominaBean = {
				'empresaID':numEmpresa
				};
		if(numEmpresa != '' && !isNaN(numEmpresa) && esTab){
			parametrosNominaServicio.consulta(tipoCon,parametrosNominaBean, function(params){
				if(params != null){
					habilitaBoton('modificar', 'submit');
					dwr.util.setValues(params);

					validaConcepto('tipoMovTesoID');
					consultaDescPerfil($('#perfilAutCalend').val());
					validaConceptoDomiciliacion('tipoMovDomiciliaID');
				}else{
					deshabilitaBoton('modificar', 'submit');
					mensajeSis('La Empresa No Existe');
					$('#empresaID').val('');
					$('#empresaID').focus();
					limpia();


				}

			});
			}else{
				if(isNaN($('#empresaID').val()) ){
					$('#empresaID').val("");
					$('#empresaID').focus();
				}
				

			}

	}

	function consultaDescPerfil(idControl){

		var jqRolID = idControl;
		var tipoCon=2;
		setTimeout("$('#cajaLista').hide();", 200);
		var parametrosRoles = {
				'rolID':jqRolID
				};
		if(jqRolID != 0 && jqRolID>0){
			rolesServicio.consultaRoles(tipoCon,parametrosRoles, function(params){
				if(params != null){
					$('#descripcionPerfil').val(params.nombreRol);
				}
			});
			}

	}
	//Funcion que valida el movimiento de conciliacion
	function validaConcepto(idControl) {
		var jqCtaConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqCtaConcepto).val();
		var tipoConciliado= 'C';
		var tesoMovTipoBean = {
				'tipoMovTesoID':numConcepto,
				'tipoMovimiento':tipoConciliado
		};
		setTimeout("$('#cajaLista').hide();", 200);
			if(numConcepto != '' && !isNaN(numConcepto)){
				TiposMovTesoServicioScript.conTiposMovTeso(catTipoConsulta.principal,tesoMovTipoBean,function(tipoBean){
					if(tipoBean!=null){
						$('#descripcionMov').val(tipoBean.descripcion);
					}
					else{
						mensajeSis("No Existe el Tipo de Movimiento.");
						$('#tipoMovTesoID').val('');
						$('#descripcionMov').val('');
						$('#tipoMovTesoID').focus();
					}
				});
			}else
				$('#descripcionMov').val('');
		}

//	 });  // fin document

	//Funcion de Ayuda de Nomenclatura Centro Costo
	function ayudaCR(){
		var data;
		data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
				'<div id="ContenedorAyuda">'+
				'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura Centro Costo:</legend>'+
				'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="encabezadoLista">&SO</td><td id="contenidoAyuda"><b>Sucursal Origen</b></td>'+
					'</tr>'+
					'<tr>'+
						'<td id="encabezadoLista" >&SC</td><td id="contenidoAyuda"><b>Sucursal ' + clienteSocio + '</b></td>'+
					'</tr>'+
				'</table>'+
				'<br>'+
				'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
				'<div id="ContenedorAyuda">'+
				'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplos: </legend>'+
				'<table id="tablaLista">'+
					'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 1: </b></td>'+
						'<td id="contenidoAyuda">&SO</td>'+
					'</tr>'+
					'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 2:</b></td>'+
						'<td id="contenidoAyuda">&SC</td>'+
					'</tr>'+
				'</table>'+
				'</div></div>'+
				'</fieldset>'+
				'</fieldset>';

		$('#ContenedorAyuda').html(data);
		$.blockUI({message: $('#ContenedorAyuda'),
					   css: {
	                top:  ($(window).height() - 400) /2 + 'px',
	                left: ($(window).width() - 400) /2 + 'px',
	                width: '400px'
	            } });
	   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
	}

	//Funcion que Inserta Claves de Nomenclatura Centro Costo
	function insertAtCaret(areaId,text) {
		$("#nomenclaturaCR").val('');
	    var txtarea = document.getElementById(areaId);
	    var scrollPos = txtarea.scrollTop;
	    var strPos = 0;
	    var br = ((txtarea.selectionStart || txtarea.selectionStart == '0') ?
	    "ff" : (document.selection ? "ie" : false ) );
	    if (br == "ie") {
	    txtarea.focus();
	    var range = document.selection.createRange();
	    range.moveStart ('character', -txtarea.value.length);
	    strPos = range.text.length;
	    }
	    else if (br == "ff") strPos = txtarea.selectionStart;
	    var front = (txtarea.value).substring(0,strPos);
	    var back = (txtarea.value).substring(strPos,txtarea.value.length);
	    txtarea.value=front+text+back;
	    strPos = strPos + text.length;
	    if (br == "ie") {
	    txtarea.focus();
	    var range = document.selection.createRange();
	    range.moveStart ('character', -txtarea.value.length);
	    range.moveStart ('character', strPos);
	    range.moveEnd ('character', 0);
	    range.select();
	    }
	    else if (br == "ff") {
	    txtarea.selectionStart = strPos;
	    txtarea.selectionEnd = strPos;
	    txtarea.focus();
	    }
	    txtarea.scrollTop = scrollPos;
	}
	function limpia(){
		$('#correoElectronico').val('');
		$('#ctaPagoTransito').val('');
		$('#tipoMovTesoID').val('');
		$('#descripcionMov').val('');
		$('#nomenclaturaCR').val('');
		$('#perfilAutCalend').val('');
		$('#descripcionPerfil').val('');
		$('#ctaTransDomicilia').val('');
		$('#tipoMovDomiciliaID').val('');
		$('#descMovDomiciliacion').val('');
		deshabilitaBoton('modificar', 'submit');
	}
	function fallo(){

	}

		//Funcion que valida el movimiento de Domiciliacion
	function validaConceptoDomiciliacion(idControl) { 
		var jqCtaConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqCtaConcepto).val();
		var tipoConciliado= 'C';
		var tesoMovTipoBean = {
				'tipoMovTesoID':numConcepto,
				'tipoMovimiento':tipoConciliado
		};
		setTimeout("$('#cajaLista').hide();", 200);
			if(numConcepto != '' && !isNaN(numConcepto)){
			TiposMovTesoServicioScript.conTiposMovTeso(catTipoConsulta.principal,tesoMovTipoBean,function(tipoBean){
				if(tipoBean!=null){ 
					$('#descMovDomiciliacion').val(tipoBean.descripcion); 
				} 
				else{
					mensajeSis("No Existe el Tipo de Movimiento.");
					$('#tipoMovDomiciliaID').val('');
					$('#descMovDomiciliacion').val('');
					$('#tipoMovDomiciliaID').focus();
				}
			}); 
		}else
			$('#descMovDomiciliacion').val('');
	}
