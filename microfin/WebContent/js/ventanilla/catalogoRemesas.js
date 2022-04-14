$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();

	var catRemesasTrans= {
			'alta': 1,
			'modificar' : 2,

		};
	var catRemesasCon= {
			'principal': 1
		};
	var catRemesasLis= {
			'principal': 1
		};
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	$('#remesaCatalogoID').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$(':text').focus(function() {
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$.validator.setDefaults({
	      submitHandler: function(event) {
	    	grabaFormaTransaccionRetrollamada({}, 'formaGenerica','contenedorForma', 'mensaje', 'true','remesaCatalogoID', 'inicializa','funcionError');
	      }
	});

	$('#tipoLista').val(catRemesasLis.principal);

	$('#grabar').click(function(){
		$('#tipoTransaccion').val(catRemesasTrans.alta);
	});
	$('#modificar').click(function(){
		$('#tipoTransaccion').val(catRemesasTrans.modificar);
	});

	$('#remesaCatalogoID').blur(function(){
		consultaRemesaCatalogoID($('#remesaCatalogoID').val());
	});
	$('#remesaCatalogoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombre";
		parametrosLista[0] = $('#remesaCatalogoID').val();
		listaAlfanumerica('remesaCatalogoID', '1', '1', camposLista, parametrosLista, 'listaCatalogoRemesadora.htm');
	});
	$('#cuentaCompleta').blur(function(){
		consultaCuentaCompleta(this.id,'descripcionCuentaContable', $('#cuentaCompleta').val());
	});


	$('#cuentaCompleta').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#cuentaCompleta').val();
			listaAlfanumerica('cuentaCompleta', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});


	$('#formaGenerica').validate({
		rules: {
			remesaCatalogoID :{
				required: true
			},
			nombre :{
				required: true
			},
			nombreCorto :{
				required: true
			},
			cuentaCompleta :{
				required: true
			}
		},

		messages: {
			remesaCatalogoID :{
				required: 'Especifica Número de Remesadora.'
			}
			,nombre :{
				required: 'Especifica Nombre de Remesadora.'
			},
			nombreCorto :{
				required: 'Especifica Nombre Corto de Remesadora.'
			}
			,cuentaCompleta :{
				required: 'Especifica Cuenta de Contable.'
			}
		}
	});

	function consultaCuentaCompleta(idOrigen, idFin, valor)
	{	var jqCtaContableO = eval("'#" + idOrigen + "'");
		var jqCtaContableF = eval("'#" + idFin + "'");
		var conPrincipal = 1;
		var CtaContableBeanCon = {
				'cuentaCompleta':valor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(valor != '' && !isNaN(valor) ){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){//que consulte por detalles
				if(ctaConta!=null){
					if(ctaConta.grupo == 'D'){
						$(jqCtaContableO).val(ctaConta.cuentaCompleta);
						$(jqCtaContableF).val(ctaConta.descripcion);
					}else{
						alert('La Cuenta Contable no es de Tipo Detalle.');
						$(jqCtaContableO).val('');
						$(jqCtaContableF).val('');
						$(jqCtaContableO).focus().select();
					}


				} else{
					alert('La Cuenta Contable no Existe.');
					$(jqCtaContableO).val('');
					$(jqCtaContableF).val('');
					$(jqCtaContableO).focus().select();
				}
			});
		} else{
			$(jqCtaContableO).val('');
			$(jqCtaContableF).val('');
			if(valor.trim() != ''){
				$(jqCtaContableO).focus().select();
			}

		}
	}


	function consultaRemesaCatalogoID(valor){
		$('#estatus').val("A");
		if(valor != '' && !isNaN(valor) && esTab){
			if(valor == '0'){
				inicializaForma('contenedorForma', 'remesaCatalogoID');
				habilitaBoton('grabar', 'submit');
				deshabilitaControl('estatus');
				deshabilitaBoton('modificar', 'submit');
			}else{
				habilitaControl('estatus');
				var bean= {
						'remesaCatalogoID':valor
				};
				catalogoRemesasServicio.consulta(catRemesasCon.principal,bean,function(CatRemesaBeanResp){
					if(CatRemesaBeanResp != null){
						dwr.util.setValues(CatRemesaBeanResp);
						consultaCuentaCompleta('cuentaCompleta', 'descripcionCuentaContable', CatRemesaBeanResp.cuentaCompleta);
						deshabilitaBoton('grabar', 'submit');
						habilitaBoton('modificar', 'submit');
					}else{
						mensajeSis('La Remesadora No Existe.');
						inicializaForma('contenedorForma', 'remesaCatalogoID');
						$('#remesaCatalogoID').focus().select();
						$('#remesaCatalogoID').val('');
					}
				});
			}
		}else{
			inicializaForma('contenedorForma', 'remesaCatalogoID');
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('modificar', 'submit');
		}
	}


}); // Fin Jquery
function ayuda(){
	var data;


data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
			'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura Centro Costo:</legend>'+
			'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="encabezadoLista">&SO</td><td id="contenidoAyuda"><b>Sucursal Origen</b></td>'+
					'</tr>'+
					'<tr>'+
						'<td id="encabezadoLista" >&SC</td><td id="contenidoAyuda"><b>Sucursal Cliente</b></td>'+
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
				'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 3:</b></td>'+
						'<td id="contenidoAyuda">15</td>'+
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
	var nav4 = window.Event ? true : false;
	function IsNumber(evt){
		var key = nav4 ? evt.which : evt.keyCode;
		return (key <= 13 || (key >= 48 && key <= 57) || key == 46);
	}

	function funcionError(){
	}

	function inicializa(){
		$('#estatus').val('A');
		inicializaForma('contenedorForma', 'remesaCatalogoID');
		deshabilitaBoton('grabar', 'submit');
		deshabilitaBoton('modificar', 'submit');
	}

