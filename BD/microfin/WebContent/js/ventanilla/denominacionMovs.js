$(document).ready(function (){
	esTab = true;
	var parametros = consultaParametrosSession();
	var procede = 0;
	//deshabilitaBoton('generar', 'submit');
	var catTipoListaMoneda = {
		'principal': 3
	};

	var catTipoListaSucursal = {
		'combo': 2
	};
	var catTipoListaTira = {
		'arqueoCaja': 3
	};

	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	cargaSucursales();
	cargaMonedas();
	var parHora = hora();
	$('#hora').val(parHora);
	$('#nombreInstitucion').val(parametros.nombreInstitucion);
	$('#numUsuario').val(parametros.numeroUsuario);
	$('#nomUsuario').val(parametros.claveUsuario);
	$('#fecha').val(parametros.fechaSucursal);
	agregaFormatoControles('formaGenerica');
	//------------ Metodos y Manejo de Eventos ----------
	if($('#cajaIDSesion').val()== undefined){
		var fechaSucursal = parametros.fechaSucursal;
		var fecha = fechaSucursal.split("-");
		var anio = fecha[0];
		anio = anio.substring(2, 4);
		var mes = fecha[1];
		var dia = fecha[2];
		$('#fecha').datepicker('option', 'maxDate', anio+'-'+mes+'-'+dia);
	}else{
		$('#sucursalID').hide();
		$('#nomSucursal').show();
		$('#nomSucursal').val(parametros.nombreSucursal);
		$('#sucursalID').attr('disabled', 'true');
		$('#cajaID').attr('disabled', 'true');
		$('#fecha').datepicker('option', 'maxDate', null);
		$('#cajaID').val(parametros.cajaID);
		consultaCaja("cajaID");
	}
	$('#fecha').change(function (){
		if($('#cajaIDSesion').val()!= undefined){
			var bean = {
		  			'sucursalID': $('#sucursalIDSesion').val(),
		  			'cajaID': $('#cajaIDSesion').val(),
		  			'fecha': $('#fecha').val(),
		  			'monedaID': $('#monedaID').val(),
		  			'denominacionID' : ''
		  			
				};
			var tipoConsutaFecha = 2;
			var parsistema = consultaParametrosSession();

			denominacionMovsServicio.consulta(tipoConsutaFecha, bean, function (fechareg){
				if (fechareg == null){
					alert('La fecha Introducida no contiene Movimientos de Denominaciones.');
					$('#fecha').val(parsistema.fechaSucursal);
				}
				else{
					if(fechareg.fecha == '1900-01-01'){
						alert('La fecha Introducida no contiene Movimientos de Denominaciones.');
						$('#fecha').val(parsistema.fechaSucursal);
					}else{
						$('#fecha').val(fechareg.fecha);
					}
					
					
				}
			});
			
			
			if (this.value != ''){
				habilitaBoton('generar', 'submit');
			}
			if (parametros.cajaID != 0){
				$('#sucursalID').val(parametros.sucursal);
			}
		}
	});
	
	$('#sucursalID').change(function (){
		$('#cajaID').val('');
		$('#descripcionCaja').val('');
		
		$('#cajaID').select();
		$('#cajaID').focus();
	});
	
	$('#cajaID').blur(function() {
  		consultaCaja(this.id);
	});		
	
	$('#cajaID').bind('keyup',function(e) {
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			var tipoListaporSucursal = 6;
			camposLista[0] = "cajaID";
			camposLista[1] = "sucursalID";
			parametrosLista[0] = ($('#cajaID').val());
			parametrosLista[1] = ($('#sucursalID').val());
			lista('cajaID', '1', tipoListaporSucursal, camposLista, parametrosLista, 'listaCajaVentanilla.htm');
		}
	});

	$('#generar').click(function() {
		if($('#sucursalID').val()!='0'){
			if($('#cajaID').val()!='0'){
				var bean = {
			  			'sucursalID': $('#sucursalID').val(),
			  			'cajaID': $('#cajaID').val(),
			  			'fecha': $('#fecha').val(),
			  			'monedaID': $('#monedaID').val(),
			  			'denominacionID' : ''
			  			
					};
				var tipoConsutaFecha = 2;
				var parsistema = consultaParametrosSession();

				denominacionMovsServicio.consulta(tipoConsutaFecha, bean, function (fechareg){
					if (fechareg == null){
						alert('La fecha Introducida no contiene Movimientos de Denominaciones.');
						$('#fecha').val(parsistema.fechaSucursal);
						$('#fecha').focus();
					}
					else{
						if(fechareg.fecha == '1900-01-01'){
							alert('La fecha Introducida no contiene Movimientos de Denominaciones.');
							$('#fecha').val(parsistema.fechaSucursal);
							$('#fecha').focus();
						}else{
							$('#fecha').val(fechareg.fecha);
							var tipoReporte		= 1;
							var nombreInst		= parametros.nombreInstitucion;	
							var sucursalID		= completaCerosIzq($('#sucursalID').val(),3);
							var nomSucursal 	= $('#sucursalID option:selected').text();
							var cajaID 			= completaCerosIzq($('#cajaID').val(),3);
							var numUsuario		= completaCerosIzq(parametros.numeroUsuario,3);
							var nomUsuario		= parametros.claveUsuario;
							var fecha 			= $('#fecha').val();
							var hora	 		=  $('#hora').val();
							var pagina='repDenoMovs.htm?programaID='+nombreInst+'&sucursalID='+sucursalID+'&sucursal='+nomSucursal+'&cajaID='+cajaID+
							'&numusuario='+numUsuario+'&nomusuario='+nomUsuario+'&fecha='+fecha+'&fechaActual='+hora+"&tipoReporte="+tipoReporte;
							 
							window.open(pagina);
						}
					}
				});
				
				
				if (this.value != ''){
					habilitaBoton('generar', 'submit');
				}
				if (parametros.cajaID != 0){
					$('#sucursalID').val(parametros.sucursal);
				}
			}else{
				alert("Especifique Caja");
				$('#cajaID').focus();
			}
		}else{
			alert("Especifique Sucursal");
			$('#sucursalID').focus();
		}
	});


	
	$('#formaGenerica').validate({				
		rules: {
			fecha: {
				required: true
			},
			sucursalID: {
				required: true
			},			
			monedaID: {
				required: true
			},
			cajaID: {
				required: true
			}
			
		},		
		messages: {
			fecha: {
				required: 'Especifique Fecha'
			},
			sucursalID : {
				required: 'Especifique Sucursal'
			},			
			
			monedaID: {
				required: 'Especifique Moneda'
			},
			cajaID: {
				required: 'Especifique Numero de Caja'
			}
		}		
	});
	
	function cargaMonedas(){
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'Selecciona'});
		monedasServicio.listaCombo(catTipoListaMoneda.principal, function(monedas){
			//dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
			for (var i = 0; i < monedas.length; i++){
				$('#monedaID').append(new Option(monedas[i].descripcion, parseInt(monedas[i].monedaID), false, false));
			}
			$('#monedaID').val(1);
		});
	}
 	
 	function cargaSucursales(){
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'Selecciona'});
		sucursalesServicio.listaCombo(catTipoListaSucursal.combo, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
 	}
 	
	function consultaCaja(idControl){
		var jqCajaVentanilla = eval("'#" + idControl + "'");
		var numCajaID = $(jqCajaVentanilla).val();
		var conPrincipal = 1;
		var CajasVentanillaBeanCon = {
  			'cajaID': numCajaID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCajaID != '' && !isNaN(numCajaID)){
			cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanCon ,function(cajasVentanilla){
				if(cajasVentanilla != null){
					$('#descripcionCaja').val(cajasVentanilla.tipoCaja);
					$('#sucursalID').val(cajasVentanilla.sucursalID);
					if(parametros.cajaID == 0){
						habilitaBoton('generar','submit');
					}
				}
				else{
					alert("No Existe la Caja.");
					$('#cajaID').focus();
					$('#cajaID').val('');
					$('#descripcionCaja').val("");
					deshabilitaBoton('generar','submit');
				}
			});
		}
	}
	
	function completaCerosIzq(obj,longitud) {
		var numtmp= String(obj);
  		while (numtmp.length<longitud){  		
    		numtmp = '0'+numtmp;
		}
		return numtmp;
	}
	
	function hora(){	
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		 if (minutes<=9)
		 minutes="0"+minutes;
		 if (seconds<=9)
		 seconds="0"+seconds;
		return  hours+":"+minutes;
	 }
});

